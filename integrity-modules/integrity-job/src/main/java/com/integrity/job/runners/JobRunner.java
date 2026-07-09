package com.integrity.job.runners;

import com.integrity.job.domain.SysJobDependent;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.mapper.SysJobDependentMapper;
import com.integrity.job.mapper.SysJobMapper;
import com.integrity.job.util.ScheduleUtils;
import lombok.RequiredArgsConstructor;
import org.quartz.Scheduler;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.List;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-09
 */
@Component
@RequiredArgsConstructor
public class JobRunner implements ApplicationRunner {
    private final Scheduler scheduler;
    private final SysJobMapper jobMapper;
    private final SysJobDependentMapper jobDependentMapper;
    private final JobScheduled jobScheduled;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        scheduler.clear();
        SysJobVo sysJobVo = new SysJobVo();
        sysJobVo.setJobGroup("DEFAULT");
        List<SysJobVo> jobList = jobMapper.selectJobList(sysJobVo);
        for (SysJobVo job : jobList) {
            SysJobDependent sysJobDependent = new SysJobDependent();
            sysJobDependent.setDependentId(job.getJobId());
            sysJobDependent.setBatchIndex(1);
            List<SysJobDependent> sysJobDependents = jobDependentMapper.selectJobDependent(sysJobDependent);
            if (CollectionUtils.isEmpty(sysJobDependents)) {
                ScheduleUtils.createScheduleJob(scheduler, job);
            }
        }
        jobScheduled.dayTaskScheduled();

        jobScheduled.monthTaskScheduled();

        jobScheduled.yearTaskScheduled();
    }
}
