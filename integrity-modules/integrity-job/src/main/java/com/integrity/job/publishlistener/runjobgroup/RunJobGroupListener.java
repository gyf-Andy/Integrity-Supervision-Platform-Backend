package com.integrity.job.publishlistener.runjobgroup;

import com.integrity.common.core.constant.ScheduleConstants;
import com.integrity.common.core.exception.job.TaskException;
import com.integrity.job.domain.SysJobDependent;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.mapper.SysJobMapper;
import com.integrity.job.util.ScheduleUtils;
import com.integrity.job.vo.TaskParam;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.quartz.JobDataMap;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executor;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-02
 */
@Component
@Slf4j
@RequiredArgsConstructor
public class RunJobGroupListener {
    private final SysJobMapper sysJobMapper;

    private final Scheduler scheduler;

    @Qualifier("asyncTaskExecutor")
    private final Executor asyncTaskExecutor;

    @EventListener
    public void handlerExecuteJobGroupEvent(ExecuteJobGroupEvent executeJobGroupEvent) {
        SysJobDependent sysJobDependent = executeJobGroupEvent.getSysJobDependent();
        String jobVID = sysJobDependent.getDependentId();
        String jobId = sysJobDependent.getJobId();
        SysJobVo sysJobVo = sysJobMapper.selectJobById(jobVID);
        SysJobVo sysJobGroup = sysJobMapper.selectJobById(jobId);
        try {
            sysJobVo.setCronExpression(ScheduleUtils.generateCronWithDelayInSeconds(5));
            sysJobVo.setStatus(ScheduleConstants.Status.NORMAL.getValue());
            sysJobVo.setJobGroup("TASK_GROUP");
            sysJobVo.setJobName(sysJobGroup.getJobName());
            log.info("任务监听器接收到 JobId [{}], 依赖ID [{}], 跑批参数 [{}], 准备跑批...", sysJobGroup.getJobId(), sysJobVo.getJobId(), sysJobVo);
            ScheduleUtils.createScheduleJob(scheduler, sysJobVo);
            log.info("任务监听器接收到 JobId [{}], 依赖ID [{}], 跑批结束...", sysJobGroup.getJobId(), sysJobVo.getJobId());
        } catch (SchedulerException | TaskException e) {
        }
    }

    @EventListener
    public void handlerTimedJobGroupEvent(TimedJobGroupEvent timedJobGroupEvent) {
        String jobId = timedJobGroupEvent.getJobId();
        String dependentId = timedJobGroupEvent.getDependentId();
        SysJobVo properties = sysJobMapper.selectJobById(jobId);
        CompletableFuture.runAsync(() -> {
            // 参数
            JobDataMap dataMap = new JobDataMap();
            dataMap.put(ScheduleConstants.TASK_PROPERTIES, properties);
            TaskParam taskParam = ScheduleUtils.parseInvokeTarget(properties.getInvokeTarget(), properties.getBatchType());
            dataMap.put(ScheduleConstants.TASK_PARAMS, taskParam);
            dataMap.put(ScheduleConstants.TASK_RUN_MODE, ScheduleConstants.TIMED_EXECUTION);
            dataMap.put(ScheduleConstants.TASK_DEPENDENT_ID, dependentId);
            String jobGroup = ScheduleUtils.getJobGroup(properties, taskParam);
            JobKey jobKey = ScheduleUtils.getJobKey(jobId, jobGroup);
            try {
                if (scheduler.checkExists(jobKey)) {
                    scheduler.triggerJob(jobKey, dataMap);
                }
            } catch (SchedulerException e) {
                throw new RuntimeException(e);
            }
        }, asyncTaskExecutor);
    }
}
