package com.integrity.job.publishlistener.firstjobgroup;

import com.integrity.common.core.exception.job.TaskException;
import com.integrity.job.domain.SysJobDependent;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.mapper.SysJobDependentMapper;
import com.integrity.job.mapper.SysJobMapper;
import com.integrity.job.service.ISysJobMonitorService;
import com.integrity.job.util.ScheduleUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-03
 */
@Component
@Slf4j
@RequiredArgsConstructor
public class FirstJobGroupListener {
    private final ISysJobMonitorService jobMonitorService;

    private final SysJobMapper jobMapper;

    private final SysJobDependentMapper jobDependentMapper;

    private final Scheduler scheduler;

    @EventListener
    public void handlerJobEvent(FirstJobGroupEvent firstJobGroupEvent) {
        String jobId = firstJobGroupEvent.getJobId();
        SysJobDependent queryDependent = new SysJobDependent();
        queryDependent.setJobId(jobId);
        queryDependent.setBatchIndex(1);
        // 查询任务组第一批任务
        List<SysJobDependent> sysJobDependents = jobDependentMapper.selectJobDependent(queryDependent);
        SysJobDependent sysJobDependent = sysJobDependents.get(0);
        SysJobVo runJobVo = jobMapper.selectJobById(sysJobDependent.getDependentId());
        String dependentId = runJobVo.getJobId();

        // 如果子任务批次所关联的任务组中有大于1，则不执行
        queryDependent = new SysJobDependent();
        queryDependent.setDependentId(dependentId);
        queryDependent.setBatchIndex(1);
        List<SysJobDependent> sysJobDependents1 = jobDependentMapper.checkJobId(queryDependent);
        if (CollectionUtils.isNotEmpty(sysJobDependents1)) {
            return;
        }
        try {
            jobMonitorService.cleanDependent(jobId);
            ScheduleUtils.createScheduleJob(scheduler, runJobVo);
            jobMonitorService.addJobMonitor(runJobVo, jobId, null);
        } catch (SchedulerException | TaskException e) {
            // throw new RuntimeException(e);
        }
    }
}
