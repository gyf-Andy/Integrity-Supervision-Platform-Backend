package com.integrity.job.service.impl;

import com.alibaba.fastjson2.JSON;
import com.integrity.common.core.utils.bean.BeanUtils;
import com.integrity.common.redis.service.IdGeneratorService;
import com.integrity.job.domain.SysJobMonitor;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.mapper.SysJobMonitorMapper;
import com.integrity.job.service.ISysJobMonitorService;
import com.integrity.job.util.ScheduleUtils;
import com.integrity.job.vo.TaskParam;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.List;
import java.util.Objects;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-09
 */
@Service
@RequiredArgsConstructor
public class SysJobMonitorServiceImpl implements ISysJobMonitorService {
    private final SysJobMonitorMapper jobMonitorMapper;
    private final IdGeneratorService idGeneratorService;

    @Override
    public int addJobMonitor(SysJobVo sysJobVo, String dependentId, TaskParam taskParam) {
        String batchType = sysJobVo.getBatchType();
        if (Objects.isNull(taskParam)) {
            String invokeTarget = sysJobVo.getInvokeTarget();
            taskParam = ScheduleUtils.parseInvokeTarget(invokeTarget, batchType);
        }

        SysJobMonitor queryJobMonitor = new SysJobMonitor();
        queryJobMonitor.setJobId(sysJobVo.getJobId());
        queryJobMonitor.setBatchDate(taskParam.getBatchDate());
        queryJobMonitor.setBatchType(batchType);
        List<SysJobMonitor> sysJobMonitors = jobMonitorMapper.selectList(queryJobMonitor);
        int rows = 0;
        if (CollectionUtils.isEmpty(sysJobMonitors)) {
            SysJobMonitor sysJobMonitor = new SysJobMonitor();
            BeanUtils.copyBeanProp(sysJobMonitor, sysJobVo);
            sysJobMonitor.setJobMonitorId(idGeneratorService.generateId("SJM"));
            sysJobMonitor.setBatchDate(taskParam.getBatchDate());
            sysJobMonitor.setDependentId(dependentId);
            sysJobMonitor.setInvokeTarget(JSON.toJSONString(taskParam));
            sysJobMonitor.setStatus("0");
            sysJobMonitor.setBatchType(batchType);
            rows = jobMonitorMapper.insert(sysJobMonitor);
        }
        return rows;
    }

    @Override
    public List<SysJobMonitor> selectList(SysJobMonitor sysJobMonitor) {
        return jobMonitorMapper.selectList(sysJobMonitor);
    }

    @Override
    public int updateJobMonitor(SysJobMonitor sysJobMonitor) {
        return jobMonitorMapper.update(sysJobMonitor);
    }

    @Override
    public int selectWaitNotExecuteStatus(String batchDate, String detectTaskLabel, List<String> status) {
        return jobMonitorMapper.selectWaitNotExecuteStatus(batchDate, detectTaskLabel, status);
    }

    @Override
    public void cleanDependent(String jobId) {
        jobMonitorMapper.cleanDependent(jobId);
    }

    @Override
    public List<SysJobMonitor> selectByStatus(String batchDate, String detectTaskLabel, String status) {
        return jobMonitorMapper.selectDetectTaskLabelList(batchDate, detectTaskLabel, status);
    }

    @Override
    public List<SysJobMonitor> aboutToBeAdjustMonitors(String batchDate, String detectTaskLabel, int aboutToBeAdjustCount) {
        return jobMonitorMapper.aboutToBeAdjustMonitors(batchDate, detectTaskLabel, aboutToBeAdjustCount);
    }
}
