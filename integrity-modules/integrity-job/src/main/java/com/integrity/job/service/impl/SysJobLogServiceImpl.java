package com.integrity.job.service.impl;

import com.alibaba.fastjson2.JSON;
import com.integrity.common.core.constant.ScheduleConstants;
import com.integrity.job.domain.SysJobLog;
import com.integrity.job.mapper.SysJobLogMapper;
import com.integrity.job.service.ISysJobLogService;
import com.integrity.job.service.ISysJobService;
import com.integrity.job.vo.TaskParam;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 定时任务调度日志信息 服务层
 *
 * @author Integrity-Supervision-Platform
 */
@Service
@RequiredArgsConstructor
public class SysJobLogServiceImpl implements ISysJobLogService {
    private final SysJobLogMapper jobLogMapper;

    private final ISysJobService sysJobService;

    /**
     * 获取quartz调度器日志的计划任务
     *
     * @param jobLog 调度日志信息
     * @return 调度任务日志集合
     */
    @Override
    public List<SysJobLog> selectJobLogList(SysJobLog jobLog) {
        return jobLogMapper.selectJobLogList(jobLog);
    }

    /**
     * 通过调度任务日志ID查询调度信息
     *
     * @param jobLogId 调度任务日志ID
     * @return 调度任务日志对象信息
     */
    @Override
    public SysJobLog selectJobLogById(String jobLogId) {
        return jobLogMapper.selectJobLogById(jobLogId);
    }

    /**
     * 新增任务日志
     *
     * @param jobLog 调度日志信息
     */
    @Override
    public void addJobLog(SysJobLog jobLog) {
        jobLogMapper.insertJobLog(jobLog);
    }

    /**
     * 批量删除调度日志信息
     *
     * @param logIds 需要删除的数据ID
     * @return 结果
     */
    @Override
    public int deleteJobLogByIds(String[] logIds) {
        return jobLogMapper.deleteJobLogByIds(logIds);
    }

    /**
     * 删除任务日志
     *
     * @param jobId 调度日志ID
     */
    @Override
    public int deleteJobLogById(String jobId) {
        return jobLogMapper.deleteJobLogById(jobId);
    }

    /**
     * 清空任务日志
     */
    @Override
    public void cleanJobLog(String batchDate) {
        jobLogMapper.cleanJobLog(batchDate);
    }

    @Override
    public int exceptionRerun(SysJobLog sysJobLog) {
        SysJobLog reRunSysJobLog = jobLogMapper.selectJobIdBatchDate(sysJobLog.getJobId(), sysJobLog.getBatchDate(),
                ScheduleConstants.TIMED_EXECUTION);
        if (!"2".equals(reRunSysJobLog.getStatus())) return 0;

        String invokeTarget = reRunSysJobLog.getInvokeTarget();
        String jobId = reRunSysJobLog.getJobId();
        String dependentId = reRunSysJobLog.getDependentId();
        TaskParam taskParam = JSON.parseObject(invokeTarget, TaskParam.class);

        return sysJobService.exceptionRerun(jobId, taskParam, dependentId);
    }
}

