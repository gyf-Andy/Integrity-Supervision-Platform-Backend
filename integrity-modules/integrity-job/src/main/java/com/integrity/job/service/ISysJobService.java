package com.integrity.job.service;

import com.integrity.common.core.exception.job.TaskException;
import com.integrity.job.domain.SysJob;
import com.integrity.job.domain.SysJobDependent;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.vo.TreeSelect;
import com.integrity.job.vo.SaveBatchSysJob;
import com.integrity.job.vo.SysJobDependentVo;
import com.integrity.job.vo.TaskParam;
import org.quartz.SchedulerException;

import java.text.ParseException;
import java.util.List;

/**
 * 定时任务调度信息信息 服务层
 *
 * @author Integrity-Supervision-Platform
 */
public interface ISysJobService {
    /**
     * 获取quartz调度器的计划任务
     *
     * @param job 调度信息
     * @return 调度任务集合
     */
    public List<SysJobVo> selectJobList(SysJobVo job);

    /**
     * 通过调度任务ID查询调度信息
     *
     * @param jobId 调度任务ID
     * @return 调度任务对象信息
     */
    public SysJobVo selectJobById(String jobId);

    /**
     * 暂停任务
     *
     * @param job 调度信息
     * @return 结果
     */
    public int pauseJob(SysJobVo job) throws SchedulerException;

    /**
     * 恢复任务
     *
     * @param job 调度信息
     * @return 结果
     */
    public int resumeJob(SysJobVo job) throws SchedulerException;

    /**
     * 删除任务后，所对应的trigger也将被删除
     *
     * @param job 调度信息
     * @return 结果
     */
    public int deleteJob(SysJobVo job) throws SchedulerException;

    /**
     * 批量删除调度信息
     *
     * @param jobIds 需要删除的任务ID
     * @return 结果
     */
    public void deleteJobByIds(String[] jobIds) throws SchedulerException;

    public boolean checkJuniorDependentOpt(String jobId);

    /**
     * 任务调度状态修改
     *
     * @param job 调度信息
     * @return 结果
     */
    public int changeStatus(SysJobVo job) throws SchedulerException;

    /**
     * 立即运行任务
     *
     * @param job 调度信息
     * @return 结果
     */
    public boolean run(SysJobVo job) throws SchedulerException;

    /**
     * 新增任务
     *
     * @param job 调度信息
     * @return 结果
     */
    public int insertJob(SysJobVo job) throws SchedulerException, TaskException, ParseException;

    /**
     * 更新任务
     *
     * @param job 调度信息
     * @return 结果
     */
    public int updateJob(SysJobVo job) throws SchedulerException, TaskException;

    /**
     * 校验cron表达式是否有效
     *
     * @param cronExpression 表达式
     * @return 结果
     */
    public boolean checkCronExpressionIsValid(String cronExpression);

    /**
     * 批量插入定时任务
     *
     * @param saveBatchSysJob 批量任务信息
     * @return {@link int}
     * @author liangli
     * @date 2024/12/2 19:34
     **/
    int saveBatch(SaveBatchSysJob saveBatchSysJob);

    boolean checkJobGroup(SysJob sysJob);

    boolean checkJobIdSize(List<SysJobDependent> saveBatchSysJobItems);

    boolean checkJobNameUnique(SysJobVo job);

    /**
     * 异常重跑
     *
     * @param jobId       任务ID
     * @param taskParam   任务参数
     * @param dependentId
     * @return {@link int}
     * @author liangli
     * @date 2024/12/5 16:07
     **/
    int exceptionRerun(String jobId, TaskParam taskParam, String dependentId);

    List<SysJobVo> selectMenuList(SysJobVo sysJobVo, String userId);

    List<TreeSelect> buildMenuTreeSelect(List<SysJobVo> sysJobVos);

    int changeIfDependent(SysJobVo newJob);

    boolean checkJobNameUniqueNotCurrent(SysJobVo job);

    List<SysJobDependentVo> selectSysJobDependent(String jobId);
}
