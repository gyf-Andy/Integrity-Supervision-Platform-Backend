package com.integrity.job.service;

import com.integrity.job.domain.SysJobMonitor;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.vo.TaskParam;

import java.util.List;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-09
 */
public interface ISysJobMonitorService {

    int addJobMonitor(SysJobVo sysJobVo, String dependentId, TaskParam taskParam);

    List<SysJobMonitor> selectList(SysJobMonitor sysJobMonitor);

    int updateJobMonitor(SysJobMonitor sysJobMonitor);

    int selectWaitNotExecuteStatus(String batchDate, String detectTaskLabel, List<String> status);

    void cleanDependent(String jobId);

    List<SysJobMonitor> selectByStatus(String batchDate,
                                       String detectTaskLabel,
                                       String status);

    List<SysJobMonitor> aboutToBeAdjustMonitors(String batchDate, String detectTaskLabel, int aboutToBeAdjustCount);
}
