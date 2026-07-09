package com.integrity.job.util;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.integrity.common.core.constant.Constants;
import com.integrity.common.core.constant.ScheduleConstants;
import com.integrity.common.core.exception.job.TaskException;
import com.integrity.common.core.utils.DateUtils;
import com.integrity.common.core.utils.SpringUtils;
import com.integrity.common.core.utils.StringUtils;
import com.integrity.job.actuator.impl.BeanExecution;
import com.integrity.job.actuator.impl.ProcedureExecution;
import com.integrity.job.actuator.impl.PythonExecution;
import com.integrity.job.actuator.impl.ShellExecution;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.vo.TaskParam;
import org.quartz.CronScheduleBuilder;
import org.quartz.CronTrigger;
import org.quartz.Job;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.TriggerBuilder;
import org.quartz.TriggerKey;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 定时任务工具类
 *
 * @author Integrity-Supervision-Platform
 */
public class ScheduleUtils {
    private static final Map<String, Class<? extends Job>> ACTUATOR_TYPE_RELATION = new ConcurrentHashMap<>();

    static {
        ACTUATOR_TYPE_RELATION.put(ScheduleConstants.BEAN, BeanExecution.class);
        ACTUATOR_TYPE_RELATION.put(ScheduleConstants.PROCEDURE, ProcedureExecution.class);
        ACTUATOR_TYPE_RELATION.put(ScheduleConstants.PYTHON, PythonExecution.class);
        ACTUATOR_TYPE_RELATION.put(ScheduleConstants.SHELL, ShellExecution.class);
    }

    public static String[] commandParams(TaskParam taskParam) {
        JSONObject commandParam = taskParam.getCommandParam();

        Collection<Object> values = commandParam.values();
        List<Object> objects = new ArrayList<>(values);
        String[] strArray = new String[values.size()];
        for (int i = 0; i < objects.size(); i++) {
            strArray[i] = String.valueOf(objects.get(i));
        }
        return strArray;
    }

    /**
     * 得到quartz任务类
     *
     * @param sysJobVo 执行计划
     * @return 具体执行任务类
     */
    public static Class<? extends Job> getQuartzJobClass(SysJobVo sysJobVo) {
        String actuatorType = sysJobVo.getActuatorType();
        return ACTUATOR_TYPE_RELATION.get(actuatorType);
    }

    /**
     * 构建任务触发对象
     */
    public static TriggerKey getTriggerKey(String jobId, String jobGroup) {
        return TriggerKey.triggerKey(ScheduleConstants.TASK_CLASS_NAME + jobId, jobGroup);
    }

    /**
     * 构建任务键对象
     */
    public static JobKey getJobKey(String jobId, String jobGroup) {
        return JobKey.jobKey(ScheduleConstants.TASK_CLASS_NAME + jobId, jobGroup);
    }

    /**
     * 创建定时任务
     */
    public static void createScheduleJob(Scheduler scheduler, SysJobVo job) throws SchedulerException, TaskException {
        Class<? extends Job> jobClass = getQuartzJobClass(job);
        // 构建job信息
        String jobId = job.getJobId();
        TaskParam taskParam = parseInvokeTarget(job.getInvokeTarget(), job.getBatchType());
        String jobGroup = getJobGroup(job, taskParam);
        JobDetail jobDetail = JobBuilder.newJob(jobClass).withIdentity(getJobKey(jobId, jobGroup)).build();

        // 表达式调度构建器
        CronScheduleBuilder cronScheduleBuilder = CronScheduleBuilder.cronSchedule(job.getCronExpression());
        cronScheduleBuilder = handleCronScheduleMisfirePolicy(/*job,*/ cronScheduleBuilder);

        // 按新的cronExpression表达式构建一个新的trigger
        CronTrigger trigger = TriggerBuilder.newTrigger().withIdentity(getTriggerKey(jobId, jobGroup))
                .withSchedule(cronScheduleBuilder).build();

        // 放入参数，运行时的方法可以获取
        jobDetail.getJobDataMap().put(ScheduleConstants.TASK_PROPERTIES, job);
        jobDetail.getJobDataMap().put(ScheduleConstants.TASK_PARAMS, taskParam);
        jobDetail.getJobDataMap().put(ScheduleConstants.TASK_RUN_MODE, ScheduleConstants.TIMED_EXECUTION);

        // 判断是否存在
        if (scheduler.checkExists(getJobKey(jobId, jobGroup))) {
            // 防止创建时存在数据问题 先移除，然后在执行创建操作
            scheduler.deleteJob(getJobKey(jobId, jobGroup));
        }

        // 判断任务是否过期
        if (StringUtils.isNotNull(CronUtils.getNextExecution(job.getCronExpression()))) {
            // 执行调度任务
            scheduler.scheduleJob(jobDetail, trigger);
        }

        // 暂停任务
        if (ScheduleConstants.Status.PAUSE.getValue().equals(job.getStatus())) {
            scheduler.pauseJob(getJobKey(jobId, jobGroup));
        }
    }

    public static String getJobGroup(SysJobVo job, TaskParam taskParam) {
        String batchType = job.getBatchType();
        if (ScheduleConstants.BATCH_TYPE_DEFAULTS.contains(batchType)) {
            return job.getJobGroup();
        }
        return taskParam.getBatchDate();
    }

    /**
     * 设置定时任务策略
     */
    /*public static CronScheduleBuilder handleCronScheduleMisfirePolicy(SysJobVo job, CronScheduleBuilder cb)
            throws TaskException {
        switch (job.getMisfirePolicy()) {
            case ScheduleConstants.MISFIRE_DEFAULT:
                return cb;
            case ScheduleConstants.MISFIRE_IGNORE_MISFIRES:
                return cb.withMisfireHandlingInstructionIgnoreMisfires();
            case ScheduleConstants.MISFIRE_FIRE_AND_PROCEED:
                return cb.withMisfireHandlingInstructionFireAndProceed();
            case ScheduleConstants.MISFIRE_DO_NOTHING:
                return cb.withMisfireHandlingInstructionDoNothing();
            default:
                throw new TaskException("The task misfire policy '" + job.getMisfirePolicy()
                        + "' cannot be used in cron schedule tasks", Code.CONFIG_ERROR);
        }
    }*/
    public static CronScheduleBuilder handleCronScheduleMisfirePolicy(/*SysJobVo job, */CronScheduleBuilder cb)
            throws TaskException {
        return cb.withMisfireHandlingInstructionDoNothing();
    }

    /**
     * 检查包名是否为白名单配置
     *
     * @param invokeTarget 目标字符串
     * @return 结果
     */
    public static boolean whiteList(String invokeTarget) {
        String packageName = StringUtils.substringBefore(invokeTarget, "(");
        int count = StringUtils.countMatches(packageName, ".");
        if (count > 1) {
            return StringUtils.containsAnyIgnoreCase(invokeTarget, Constants.JOB_WHITELIST_STR);
        }
        Object obj = SpringUtils.getBean(StringUtils.split(invokeTarget, ".")[0]);
        String beanPackageName = obj.getClass().getPackage().getName();
        return StringUtils.containsAnyIgnoreCase(beanPackageName, Constants.JOB_WHITELIST_STR)
                && !StringUtils.containsAnyIgnoreCase(beanPackageName, Constants.JOB_ERROR_STR);
    }

    public static TaskParam parseInvokeTarget(String invokeTarget, String batchType) {
        TaskParam taskParam = JSON.parseObject(invokeTarget, TaskParam.class);
        JSONObject commandParam = null;
        if (Objects.isNull(taskParam.getCommandParam()) || taskParam.getCommandParam().isEmpty()) {
            commandParam = new JSONObject();
        } else {
            commandParam = taskParam.getCommandParam();
        }

        int dateSubtractDay = taskParam.getDateSubtractDay();
        // 设置跑批日期
        String batchDate = DateUtils.currentDateMinusDay(dateSubtractDay, batchType);
        commandParam.put("batchDate", batchDate);
        taskParam.setBatchDate(batchDate);
        taskParam.setCommandParam(commandParam);
        return taskParam;
    }

    public static void main(String[] args) {
        String s = DateUtils.currentDateMinusDay(1, "DAY");
        System.out.println(s);
    }

    public static String generateCronWithDelayInSeconds(int delayInSeconds) {
        // 获取当前时间并加上指定的延迟（秒）
        LocalDateTime now = LocalDateTime.now().plusSeconds(delayInSeconds);

        // 格式化为Cron表达式需要的格式
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("ss mm HH dd MM ? yyyy");
        String cron = now.format(formatter);

        // 因为标准Cron表达式不包含年份，所以我们去掉最后的年份部分
        cron = cron.substring(0, cron.length() - 5);

        // 如果秒数是59，下一次执行可能会跨分钟，导致延迟到下一分钟的第0秒
        // 所以我们可以选择将秒设为0并增加一分钟，确保任务能立即执行
        if ("59".equals(now.getSecond())) {
            now = now.plusMinutes(1).withSecond(0);
            cron = now.format(DateTimeFormatter.ofPattern("ss mm HH dd MM ?"));
        }

        return cron;
    }
}
