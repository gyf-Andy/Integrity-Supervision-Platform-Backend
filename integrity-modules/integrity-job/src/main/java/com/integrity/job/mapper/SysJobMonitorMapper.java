package com.integrity.job.mapper;

import com.integrity.job.domain.SysJobMonitor;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 调度任务日志信息 数据层
 *
 * @author Integrity-Supervision-Platform
 */
public interface SysJobMonitorMapper {

    List<SysJobMonitor> selectList(SysJobMonitor sysJobMonitor);

    /**
     * 新增任务日志
     *
     * @param sysJobMonitor 任务监控信息
     * @return 结果
     */
    public int insert(SysJobMonitor sysJobMonitor);

    int update(SysJobMonitor sysJobMonitor);

    int selectWaitNotExecuteStatus(@Param("batchDate") String batchDate,
                                   @Param("detectTaskLabel") String detectTaskLabel,
                                   @Param("status") List<String> status);

    void cleanDependent(@Param("jobId") String jobId);

    List<SysJobMonitor> selectDetectTaskLabelList(
            @Param("batchDate") String batchDate,
            @Param("detectTaskLabel") String detectTaskLabel,
            @Param("status") String status
    );

    List<SysJobMonitor> aboutToBeAdjustMonitors(@Param("batchDate") String batchDate,
                                                @Param("detectTaskLabel") String detectTaskLabel,
                                                @Param("aboutToBeAdjustCount") int aboutToBeAdjustCount);
}

