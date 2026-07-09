package com.integrity.job.mapper;

import com.integrity.job.domain.SysJobQueue;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 调度任务日志信息 数据层
 *
 * @author Integrity-Supervision-Platform
 */
public interface SysJobQueueMapper {

    List<SysJobQueue> selectList(SysJobQueue sysJobQueue);

    /**
     * 新增任务日志
     *
     * @param jobQueues 任务队列
     * @return 结果
     */
    public int insertBatch(@Param("jobQueues") List<SysJobQueue> jobQueues);

    List<SysJobQueue> selectDependentStatus(@Param("dependentId") String dependentId,
                                            @Param("batchDate") String batchDate/*,
                                      @Param("batchIndex") String batchIndex*/);

    void updateStatus(@Param("dependentId") String dependentId, @Param("batchDate") String batchDate,
                      @Param("status") String status/*, @Param("batchIndex") String batchIndex*/);

    List<SysJobQueue> selectJobStatus(@Param("jobId") String jobId,
                                      @Param("batchDate") String batchDate/*,
                                      @Param("batchIndex") String batchIndex*/
    );
}

