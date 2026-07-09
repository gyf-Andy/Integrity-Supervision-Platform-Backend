package com.integrity.job.util;

import com.alibaba.fastjson.JSON;
import com.integrity.common.core.constant.CacheConstants;
import com.integrity.common.core.constant.ScheduleConstants;
import com.integrity.common.core.utils.ExceptionUtil;
import com.integrity.common.core.utils.StringUtils;
import com.integrity.common.core.utils.bean.BeanUtils;
import com.integrity.common.redis.service.IdGeneratorService;
import com.integrity.common.redis.service.RedisService;
import com.integrity.job.domain.SysJobDependent;
import com.integrity.job.domain.SysJobLog;
import com.integrity.job.domain.SysJobMonitor;
import com.integrity.job.domain.SysJobNotice;
import com.integrity.job.domain.SysJobQueue;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.mapper.SysJobDependentMapper;
import com.integrity.job.mapper.SysJobLogMapper;
import com.integrity.job.mapper.SysJobMapper;
import com.integrity.job.mapper.SysJobNoticeMapper;
import com.integrity.job.mapper.SysJobQueueMapper;
import com.integrity.job.publishlistener.runjobgroup.TimedJobGroupEvent;
import com.integrity.job.service.ISysJobMonitorService;
import com.integrity.job.vo.CommandResult;
import com.integrity.job.vo.TaskParam;
import com.integrity.system.api.domain.SysDictData;
import org.apache.commons.collections4.CollectionUtils;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executor;
import java.util.stream.Collectors;

/**
 * 抽象quartz调用
 *
 * @author Integrity-Supervision-Platform
 */
@Component
public abstract class AbstractQuartzJob implements Job {
    private static final Logger log = LoggerFactory.getLogger(AbstractQuartzJob.class);
    /**
     * 线程本地变量
     */
    private static final ThreadLocal<Date> THREAD_LOCAL = new ThreadLocal<>();
    @Autowired
    private ApplicationEventPublisher applicationEventPublisher;
    @Qualifier("asyncTaskExecutor")
    @Autowired
    private Executor asyncTaskExecutor;
    @Autowired
    private SysJobMapper jobMapper;
    @Autowired
    private RedisService redisService;
    @Autowired
    private IdGeneratorService idGeneratorService;
    @Autowired
    private SysJobLogMapper sysJobLogMapper;
    @Autowired
    private SysJobDependentMapper sysJobDependentMapper;
    @Autowired
    private SysJobQueueMapper sysJobQueueMapper;
    @Autowired
    private SysJobNoticeMapper sysJobNoticeMapper;
    @Autowired
    private ISysJobMonitorService jobMonitorService;

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        SysJobVo sysJobVo = new SysJobVo();
        JobDataMap mergedJobDataMap = context.getMergedJobDataMap();
        BeanUtils.copyBeanProp(sysJobVo, mergedJobDataMap.get(ScheduleConstants.TASK_PROPERTIES));
        log.info("任务监听器接收到 JobId [{}], 开始跑批...", sysJobVo.getJobId());
        TaskParam taskParam = ScheduleUtils.parseInvokeTarget(sysJobVo.getInvokeTarget(), sysJobVo.getBatchType());
        String runMode = (String) context.getMergedJobDataMap().get(ScheduleConstants.TASK_RUN_MODE);
        String detectTaskLabelArray = redisService.getCacheObject(CacheConstants.SYS_CONFIG_KEY + "detecting_task_label");

        // 校验是否监控任务最大数
        String detectTaskLabel = null;
        int detectTaskCount = -1;
        if (StringUtils.isNotBlank(detectTaskLabelArray)) {
            String[] split = detectTaskLabelArray.split("_");
            detectTaskLabel = split[0];
            try {
                detectTaskCount = Integer.parseInt(split[1]);
            } catch (NumberFormatException e) {
                detectTaskCount = 0;
            }
        }
        int waitNotExecuteStatusCount = StringUtils.isBlank(detectTaskLabel) ? 0 :
                jobMonitorService.selectWaitNotExecuteStatus(taskParam.getBatchDate(), detectTaskLabel, Arrays.asList("2"));
        if (waitNotExecuteStatusCount >= detectTaskCount) {
            log.info("定时任务监控正在跑批的任务数量为[{}], 配置为[{}], 本次调用结束, 等待定时任务调起", waitNotExecuteStatusCount, detectTaskCount);
            return;
        }

        // 更新数量
        SysJobMonitor sysJobMonitor = new SysJobMonitor();
        if (StringUtils.isNotBlank(detectTaskLabel)) {
            sysJobMonitor.setParentName(detectTaskLabel);
        }
        sysJobMonitor.setJobId(sysJobVo.getJobId());
        sysJobMonitor.setBatchDate(taskParam.getBatchDate());
        sysJobMonitor.setBatchType(sysJobVo.getBatchType());
        sysJobMonitor.setStatus("0");
        List<SysJobMonitor> sysJobMonitors = jobMonitorService.selectList(sysJobMonitor);
        if (CollectionUtils.isNotEmpty(sysJobMonitors)) {
            for (SysJobMonitor jobMonitor : sysJobMonitors) {
                jobMonitor.setStatus("2");
                jobMonitorService.updateJobMonitor(jobMonitor);
            }
        }

        if (ScheduleConstants.EXECUTE_IMMEDIATELY.equals(runMode)) {// 立即执行
            executeExecutor(context, sysJobVo, runMode, taskParam);
        }
        // 定时执行|异常执行
        if (ScheduleConstants.TIMED_EXECUTION.equals(runMode) || ScheduleConstants.EXCEPTION_EXECUTION.equals(runMode)) {
            timedExecutor(context, sysJobVo, runMode, taskParam);
        }
        log.info("任务监听器接收到 JobId [{}], 跑批结束...", sysJobVo.getJobId());
    }

    private void executeExecutor(JobExecutionContext context, SysJobVo sysJobVo, String runMode, TaskParam taskParam) {
        String batchDate = taskParam.getBatchDate();
        JobDataMap mergedJobDataMap = context.getMergedJobDataMap();
        SysJobLog sysJobLog = new SysJobLog();
        try {
            before(context, sysJobVo, taskParam);

            sysJobLog.setJobLogId(idGeneratorService.generateId("SJL"));
            sysJobLog.setStatus("0");//正在运行
            sysJobLog.setJobId(sysJobVo.getJobId());
            sysJobLog.setJobName(sysJobVo.getJobName());
            sysJobLog.setBatchDate(batchDate);
            sysJobLog.setRunMode(runMode);
            sysJobLog.setInvokeTarget(JSON.toJSONString(taskParam));
            Object o = mergedJobDataMap.get(ScheduleConstants.TASK_DEPENDENT_ID);
            if (Objects.isNull(o) || StringUtils.isBlank(String.valueOf(o))) {
                sysJobLog.setJobGroup("DEFAULT");
                sysJobLog.setDependentId("");
            } else {
                sysJobLog.setJobGroup("TASK_GROUP");
                sysJobLog.setDependentId(String.valueOf(o));
            }

            if (ScheduleConstants.EXCEPTION_EXECUTION.equals(runMode)) {
                sysJobLog.setStatus("0");
                sysJobLog.setJobMessage("异常重跑");
            }

            int count = 0;
            CommandResult commandResult = null;
            do {
                try {
                    commandResult = doExecute(context, sysJobVo, taskParam);
                    if (commandResult.getCode() != 0) {
                        log.info("JobId [{}], 任务执行失败，等待{}秒后重试，当前重试次数：{}", sysJobVo.getJobId(), sysJobVo.getExceptionWaitSecond(), count);
                        Thread.sleep(sysJobVo.getExceptionWaitSecond() * 1000);
                        count++;
                    }
                } catch (Exception e) {
                    count++;
                    Thread.sleep(sysJobVo.getExceptionWaitSecond() * 1000);
                }
            } while (count < sysJobVo.getExceptionRetryCount() && Objects.requireNonNull(commandResult).getCode() != 0);

            if (count >= sysJobVo.getExceptionRetryCount()) {
                alarmNotificator(sysJobVo, count, taskParam, commandResult.getMessage());
                sysJobLog.setStatus("2");// 运行异常
                sysJobLog.setExceptionInfo(commandResult.getMessage());
                after(context, sysJobLog);
            } else {
                sysJobLog.setStatus("1");// 运行完成
                sysJobLog.setJobMessage(commandResult.getMessage());
                after(context, sysJobLog);
            }
        } catch (Exception e) {
            log.error("任务执行异常  - ：", e);
            sysJobLog.setStatus("2");// 运行异常
            sysJobLog.setExceptionInfo(StringUtils.substring(ExceptionUtil.getExceptionMessage(e), 0, 2000));
            after(context, sysJobLog);
        }
    }

    private void timedExecutor(JobExecutionContext context, SysJobVo sysJobVo, String runMode, TaskParam taskParam) {
        String batchDate = taskParam.getBatchDate();
        JobDataMap mergedJobDataMap = context.getMergedJobDataMap();
        SysJobLog sysJobLog = sysJobLogMapper.selectJobIdBatchDate(sysJobVo.getJobId(), batchDate, runMode);
        try {
            before(context, sysJobVo, taskParam);

            if (Objects.isNull(sysJobLog)) {
                sysJobLog = new SysJobLog();
                sysJobLog.setJobLogId(idGeneratorService.generateId("SJL"));
                sysJobLog.setStatus("0");//正在运行
                sysJobLog.setJobId(sysJobVo.getJobId());
                sysJobLog.setJobName(sysJobVo.getJobName());
                sysJobLog.setBatchDate(batchDate);
                sysJobLog.setRunMode(runMode);
                sysJobLog.setInvokeTarget(JSON.toJSONString(taskParam));
                Object o = mergedJobDataMap.get(ScheduleConstants.TASK_DEPENDENT_ID);
                if (Objects.isNull(o) || StringUtils.isBlank(String.valueOf(o))) {
                    sysJobLog.setJobGroup("DEFAULT");
                    sysJobLog.setDependentId("");
                } else {
                    sysJobLog.setJobGroup("TASK_GROUP");
                    sysJobLog.setDependentId(String.valueOf(o));
                }

                if (ScheduleConstants.EXCEPTION_EXECUTION.equals(runMode)) {
                    sysJobLog.setStatus("0");
                    sysJobLog.setJobMessage("异常重跑");
                }
            } else if ("1".equals(sysJobLog.getStatus())) {
                getJuniorDependent(sysJobVo, batchDate);
                sysJobLog.setJobMessage(String.format("任务监听器 JobId [%s], 跑批日期 [%s], 存在重复跑批, 日志记录", sysJobVo.getJobId(), taskParam.getBatchDate()));
                after(context, sysJobLog);
                return;
            } else if ("0".equals(sysJobLog.getStatus())) {
                log.info("任务监听器 JobId [{}], 正在执行，不再执行", sysJobVo.getJobId());
                return;
            } else if ("2".equals(sysJobLog.getStatus())) { // 异常，标记异常重跑
                sysJobLog.setStatus("0");
                sysJobLog.setJobMessage("异常重跑");
            }

            int count = 0;
            CommandResult commandResult = null;
            do {
                try {
                    commandResult = doExecute(context, sysJobVo, taskParam);
                    if (commandResult.getCode() != 0) {
                        count++;
                        log.info("JobId [{}], 任务执行失败，等待[{}]分钟后重试，当前重试次数：{}", sysJobVo.getJobId(), sysJobVo.getExceptionWaitSecond(), count);
                        Thread.sleep((sysJobVo.getExceptionWaitSecond() * 1000 * 60));
                    }
                } catch (Exception e) {
                    count++;
                    Thread.sleep((sysJobVo.getExceptionWaitSecond() * 1000 * 60));
                }
            } while (count < sysJobVo.getExceptionRetryCount() && Objects.requireNonNull(commandResult).getCode() != 0);

            if (count >= sysJobVo.getExceptionRetryCount()) {
                alarmNotificator(sysJobVo, count, taskParam, commandResult.getMessage());
                sysJobLog.setStatus("2");// 运行异常
                sysJobLog.setExceptionInfo(commandResult.getMessage());
                String detectTaskLabel = detectTaskLabel();
                updateJobMonitor(sysJobVo, taskParam, detectTaskLabel, "2");
                after(context, sysJobLog);
            } else {
                sysJobLog.setStatus("1");// 运行完成
                sysJobLog.setJobMessage(commandResult.getMessage());
                after(context, sysJobLog);
                String detectTaskLabel = detectTaskLabel();
                updateJobMonitor(sysJobVo, taskParam, detectTaskLabel, "1");
                getJuniorDependent(sysJobVo, batchDate);
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("任务执行异常  - ：", e);
            sysJobLog.setStatus("2");// 运行异常
            sysJobLog.setExceptionInfo(e.getMessage());
            after(context, sysJobLog);
        }
    }

    private String detectTaskLabel() {
        String detectTaskLabelArray = redisService.getCacheObject(CacheConstants.SYS_CONFIG_KEY + "detecting_task_label");
        String[] split = detectTaskLabelArray.split("_");
        String detectTaskLabel = split[0];
        return detectTaskLabel;
    }

    private void updateJobMonitor(SysJobVo sysJobVo, TaskParam taskParam, String detectTaskLabel, String status) {
        SysJobMonitor sysJobMonitor = new SysJobMonitor();
        sysJobMonitor.setJobId(sysJobVo.getJobId());
        sysJobMonitor.setParentName(detectTaskLabel);
        sysJobMonitor.setBatchDate(taskParam.getBatchDate());
        sysJobMonitor.setBatchType(sysJobVo.getBatchType());
        sysJobMonitor.setStatus(status);
        jobMonitorService.updateJobMonitor(sysJobMonitor);
    }

    private void getJuniorDependent(SysJobVo sysJobVo, String batchDate) {
        List<SysJobQueue> sysJobQueues = sysJobQueueMapper.selectDependentStatus(sysJobVo.getJobId(), batchDate);
        if (CollectionUtils.isEmpty(sysJobQueues)) {
            juniorDependent(sysJobVo, batchDate);
        } else {
            for (SysJobQueue sysJobQueue : sysJobQueues) {
                String jobId = sysJobQueue.getJobId();
                List<SysJobQueue> sysJobQueues2 = sysJobQueueMapper.selectJobStatus(jobId, batchDate);
                if (CollectionUtils.isEmpty(sysJobQueues2)) {
                    juniorDependent(sysJobVo, batchDate);
                } else {
                    String status = sysJobQueue.getStatus();
                    if ("0".equals(status)) {
                        sysJobQueueMapper.updateStatus(sysJobVo.getJobId(), batchDate, "1");
                    }
                    sysJobQueues2 = sysJobQueueMapper.selectJobStatus(jobId, batchDate);
                    if (CollectionUtils.isEmpty(sysJobQueues2)) {
                        juniorDependent(sysJobVo, batchDate);
                    }
                }
            }
        }
    }

    /**
     * 查找下级依赖
     *
     * @param sysJobVo  单任务ID
     * @param batchDate 跑批日期
     * @author liangli
     * @date 2024/12/4 16:20
     **/
    private void juniorDependent(SysJobVo sysJobVo, String batchDate) {
        // 查找下级依赖中间方法
        List<SysJobDependent> juniorDependent = sysJobDependentMapper.selectJuniorDependentOpt(sysJobVo.getJobId());
        if (CollectionUtils.isEmpty(juniorDependent)) {
            return;
        }

        Set<String> jobIds = juniorDependent.stream().map(SysJobDependent::getJobId).collect(Collectors.toSet());
        SysJobDependent sysJobDependent = juniorDependent.get(0);
        Integer index = sysJobDependent.getBatchIndex() + 1;

        // 查找下级依赖
        juniorDependent = sysJobDependentMapper.selectJuniorDependent(jobIds, index);
        if (CollectionUtils.isEmpty(juniorDependent)) {
            return;
        }

        Map<String, List<SysJobDependent>> collect = juniorDependent.stream().collect(Collectors.groupingBy(SysJobDependent::getJobId));

        Set<Map.Entry<String, List<SysJobDependent>>> entries = collect.entrySet();
        jobIds = new HashSet<>();
        StringBuilder stringBuilder = new StringBuilder("调起源任务ID：" + sysJobVo.getJobId() + "<br/>");
        stringBuilder.append("==============================start==============================").append("<br/>");
        int count = 1;
        for (Map.Entry<String, List<SysJobDependent>> entry : entries) {
            List<SysJobDependent> value = entry.getValue();
            String key = entry.getKey();
            stringBuilder.append("关联任务组ID【 ").append(count).append(" 】：").append(key).append("<br/>");
            stringBuilder.append("任务组ID批次【").append(index).append(" 】<br/>");
            if (value.size() > 1) {
                List<SysJobQueue> jobQueues = new ArrayList<>();
                for (SysJobDependent jobDependent : value) {
                    SysJobQueue sysJobQueue = new SysJobQueue();
                    sysJobQueue.setDependentId(jobDependent.getDependentId());
                    sysJobQueue.setJobId(jobDependent.getJobId());
                    sysJobQueue.setBatchDate(batchDate);
                    sysJobQueue.setStatus("0");
                    sysJobQueue.setBatchIndex(jobDependent.getBatchIndex());
                    jobQueues.add(sysJobQueue);
                    jobIds.add(jobDependent.getDependentId());
                }
                stringBuilder.append("任务组依赖ID【").append(String.join(", ", jobIds)).append("】<br/>");
                sysJobQueueMapper.insertBatch(jobQueues);
            } else {
                SysJobDependent sysJobDependent1 = value.get(0);
                stringBuilder.append("任务组依赖ID【").append(sysJobDependent1.getDependentId()).append("】<br/>");
                jobIds.add(sysJobDependent1.getDependentId());
            }
            if (count < entries.size()) {
                stringBuilder.append("------------------------------").append("<br/>");
            }
            count++;
        }
        stringBuilder.append("============================== end ==============================");
        if (CollectionUtils.isNotEmpty(jobIds)) {
            List<SysJobVo> sysJobVos = jobMapper.selectJobListIdStr(String.join(",", jobIds));
            sysJobVos.forEach(sysJobVo2 -> {
                String ifDependent = sysJobVo2.getIfDependent();
                if ("Y".equals(ifDependent)) {
                    CompletableFuture.runAsync(() -> {
                        applicationEventPublisher.publishEvent(new TimedJobGroupEvent(this, sysJobVo2.getJobId(), stringBuilder.toString()));
                    }, asyncTaskExecutor);
                } else {
                    log.error("源任务ID[{}],依赖单任务ID[{}],依赖标识关闭", sysJobVo.getJobId(), sysJobVo2.getJobId());
                }
            });
        }
        //return jobIds;
    }

    /**
     * 执行前
     *
     * @param context   工作执行上下文对象
     * @param SysJobVo  系统计划任务
     * @param taskParam 任务参数
     */
    protected void before(JobExecutionContext context, SysJobVo SysJobVo, TaskParam taskParam) {
        THREAD_LOCAL.set(new Date());
    }

    /**
     * 执行后
     *
     * @param context 工作执行上下文对象
     */
    protected void after(JobExecutionContext context, SysJobLog sysJobLog) {
        Date startTime = THREAD_LOCAL.get();
        sysJobLog.setStartTime(startTime);
        sysJobLog.setStopTime(new Date());
        long runMs = sysJobLog.getStopTime().getTime() - startTime.getTime();
        double runTime = ((double) runMs / 1000);
        String taskTimeOut = redisService.getCacheObject(CacheConstants.SYS_CONFIG_KEY + "task_time_out");
        if (runTime > (Integer.parseInt(taskTimeOut)) * 60) {
            sysJobLog.setStatus("3");
        }
        sysJobLog.setRunTime(runTime);
        THREAD_LOCAL.remove();

        int i = sysJobLogMapper.selectJobLogByIdCount(sysJobLog.getJobLogId());
        if (i > 0) {
            sysJobLogMapper.updateJobLog(sysJobLog);
        } else {
            sysJobLogMapper.insertJobLog(sysJobLog);
        }
    }

    /**
     * 执行方法，由子类重载
     *
     * @param context   工作执行上下文对象
     * @param sysJobVo  系统计划任务
     * @param taskParam 任务参数
     * @throws Exception 执行过程中的异常
     */
    protected abstract CommandResult doExecute(JobExecutionContext context, SysJobVo sysJobVo, TaskParam taskParam) throws Exception;

    protected void alarmNotificator(SysJobVo sysJobVo, int count, TaskParam taskParam, String message) {
        List<SysDictData> sysDictDataList = redisService.getCacheObject(CacheConstants.SYS_DICT_KEY + "job_notice_peoples");
        if (CollectionUtils.isEmpty(sysDictDataList)) {
            log.error("异常任务未配置通知人...通知主键 [{}]", CacheConstants.SYS_DICT_KEY + "job_notice_peoples");
            return;
        }
        String jobExceptionNoticeContent = redisService.getCacheObject(CacheConstants.SYS_CONFIG_KEY + "job_exception_notice_content");
        List<SysJobNotice> sysJobNotices = new ArrayList<>();
        for (SysDictData sysDictData : sysDictDataList) {
            SysJobNotice sysJobNotice = new SysJobNotice();
            sysJobNotice.setJobNoticeId(idGeneratorService.generateId("SJN"));
            sysJobNotice.setJobId(sysJobVo.getJobId());
            sysJobNotice.setJobName(sysJobVo.getJobName());
            sysJobNotice.setBatchDate(taskParam.getBatchDate());
            sysJobNotice.setIfHandle("N");
            sysJobNotice.setNoticeTarget(sysDictData.getDictValue());
            sysJobNotice.setNoticeContent(String.format(jobExceptionNoticeContent, sysDictData.getDictLabel(), sysJobVo.getJobName(),
                    taskParam.getBatchDate(), message));
            sysJobNotices.add(sysJobNotice);
        }
        sysJobNoticeMapper.insert(sysJobNotices);
    }
}

