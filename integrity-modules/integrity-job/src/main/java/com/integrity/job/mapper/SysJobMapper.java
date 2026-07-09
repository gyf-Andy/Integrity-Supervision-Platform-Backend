package com.integrity.job.mapper;

import com.integrity.job.domain.SysJob;
import com.integrity.job.domain.SysJobVo;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 调度任务信息 数据层
 *
 * @author Integrity-Supervision-Platform
 */
public interface SysJobMapper {
    /**
     * 查询调度任务日志集合
     *
     * @param job 调度信息
     * @return 操作日志集合
     */
    public List<SysJobVo> selectJobList(SysJobVo job);

    /**
     * 查询调度任务日志集合
     *
     * @param jobIds 调度信息
     * @return 操作日志集合
     */
    public List<SysJobVo> selectJobListIdStr(@Param("jobIds") String jobIds);

    /**
     * 查询所有调度任务
     *
     * @return 调度任务列表
     */
    public List<SysJobVo> selectJobAll();

    /**
     * 通过调度ID查询调度任务信息
     *
     * @param jobId 调度ID
     * @return 角色对象信息
     */
    public SysJobVo selectJobById(String jobId);

    /**
     * 通过调度ID删除调度任务信息
     *
     * @param jobId 调度ID
     * @return 结果
     */
    public int deleteJobById(String jobId);

    /**
     * 批量删除调度任务信息
     *
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    public int deleteJobByIds(String[] ids);

    /**
     * 修改调度任务信息
     *
     * @param job 调度任务信息
     * @return 结果
     */
    public int updateJob(SysJobVo job);

    /**
     * 新增调度任务信息
     *
     * @param job 调度任务信息
     * @return 结果
     */
    public int insertJob(SysJobVo job);

    /**
     * 动态调用存储过程
     *
     * @param procedureCall 存储过程名称
     * @param params        参数列表
     * @return 返回值
     */
    Map<String, Object> callStoredProcedure(@Param("procedureCall") String procedureCall, @Param("params") Map<String, Object> params);

    String dictData(@Param("dictLabel") String dictLabel);

    int insertSysJob(@Param("sysJob") SysJob sysJob, @Param("createBy") String createBy);

    int checkJobGroup(@Param("jobName") String jobName, @Param("jobGroup") String jobGroup);

    int checkJobIdSize(@Param("jobIds") List<String> jobIds);

    List<SysJobVo> selectJobListByUserId(SysJobVo sysJobVo);

    int checkJobNameUniqueNotCurrent(SysJobVo sysJobVo);
}

