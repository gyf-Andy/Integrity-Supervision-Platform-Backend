package com.integrity.job.mapper;

import com.integrity.job.domain.SysJobDependent;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.vo.SysJobDependentVo;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Set;

/**
 * 调度任务信息 数据层
 *
 * @author Integrity-Supervision-Platform
 */
public interface SysJobDependentMapper {
    int updateSysJobDependent(SysJobDependent sysJobDependent);

    void insertSysJobDependents(@Param("sysJobDependents") List<SysJobDependent> sysJobDependents);

    void cleanDependent(String jobId);

    List<SysJobDependent> selectJobDependent(SysJobDependent sysJobDependent);

    List<SysJobDependent> checkJobId(SysJobDependent sysJobDependent);

    List<SysJobDependent> selectJuniorDependentOpt(@Param("jobId") String jobId);

    List<SysJobDependent> selectJuniorDependent(@Param("jobIds") Set<String> jobIds, @Param("batchIndex") Integer batchIndex);

    List<SysJobDependentVo> selectSysJobDependent(@Param("jobId") String jobId);

    List<SysJobVo> selectJobRefreshByType(@Param("batchType") String batchType);
}

