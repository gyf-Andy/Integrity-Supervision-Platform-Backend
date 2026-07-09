package com.integrity.job.service.impl;

import com.alibaba.fastjson2.JSON;
import com.alibaba.nacos.common.utils.StringUtils;
import com.integrity.common.core.constant.ScheduleConstants;
import com.integrity.common.core.exception.job.TaskException;
import com.integrity.common.core.utils.bean.BeanUtils;
import com.integrity.common.redis.service.IdGeneratorService;
import com.integrity.common.security.utils.SecurityUtils;
import com.integrity.job.domain.SysJob;
import com.integrity.job.domain.SysJobDependent;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.mapper.SysJobDependentMapper;
import com.integrity.job.mapper.SysJobMapper;
import com.integrity.job.publishlistener.firstjobgroup.FirstJobGroupEvent;
import com.integrity.job.service.ISysJobService;
import com.integrity.job.util.CronUtils;
import com.integrity.job.util.ScheduleUtils;
import com.integrity.job.vo.SaveBatchSysJob;
import com.integrity.job.vo.SysJobDependentVo;
import com.integrity.job.vo.TaskParam;
import com.integrity.job.vo.TreeSelect;
import com.integrity.system.api.domain.SysUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.quartz.JobDataMap;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 定时任务调度信息 服务层
 *
 * @author Integrity-Supervision-Platform
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class SysJobServiceImpl implements ISysJobService {
    private final Scheduler scheduler;

    private final SysJobMapper jobMapper;

    private final SysJobDependentMapper sysJobDependentMapper;

    private final IdGeneratorService idGeneratorService;

    private final ApplicationEventPublisher applicationEventPublisher;

    /**
     * 获取quartz调度器的计划任务列表
     *
     * @param job 调度信息
     * @return
     */
    @Override
    public List<SysJobVo> selectJobList(SysJobVo job) {
        return jobMapper.selectJobList(job);
    }

    /**
     * 通过调度任务ID查询调度信息
     *
     * @param jobId 调度任务ID
     * @return 调度任务对象信息
     */
    @Override
    public SysJobVo selectJobById(String jobId) {
        return jobMapper.selectJobById(jobId);
    }

    /**
     * 暂停任务
     *
     * @param job 调度信息
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int pauseJob(SysJobVo job) throws SchedulerException {
        String jobId = job.getJobId();
        job.setStatus(ScheduleConstants.Status.PAUSE.getValue());
        int rows = jobMapper.updateJob(job);
        String jobGroupDB = jobMapper.dictData("任务组");
        if (jobGroupDB.equals(job.getJobGroup())) {
            SysJobDependent sysJobDependent = new SysJobDependent();
            sysJobDependent.setJobId(jobId);
            sysJobDependent.setStatus(ScheduleConstants.Status.NORMAL.getValue());
            sysJobDependent.setBatchIndex(1);
            List<SysJobDependent> sysJobDependents = sysJobDependentMapper.selectJobDependent(sysJobDependent);
            SysJobDependent sysJobDependent1 = sysJobDependents.get(0);
            SysJobVo sysJobVo = jobMapper.selectJobById(sysJobDependent1.getDependentId());
            String invokeTarget = job.getInvokeTarget();
            TaskParam taskParam = JSON.parseObject(invokeTarget, TaskParam.class);
            String jobGroup = ScheduleUtils.getJobGroup(sysJobVo, taskParam);
            if (rows > 0) {
                scheduler.pauseJob(ScheduleUtils.getJobKey(sysJobDependent1.getDependentId(), jobGroup));
            }
        } else {
            String invokeTarget = job.getInvokeTarget();
            TaskParam taskParam = JSON.parseObject(invokeTarget, TaskParam.class);
            String jobGroup = ScheduleUtils.getJobGroup(job, taskParam);
            if (rows > 0) {
                scheduler.pauseJob(ScheduleUtils.getJobKey(jobId, jobGroup));
            }
        }
        return rows;
    }

    /**
     * 恢复任务
     *
     * @param job 调度信息
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int resumeJob(SysJobVo job) throws SchedulerException {
        String jobId = job.getJobId();
        job.setStatus(ScheduleConstants.Status.NORMAL.getValue());
        int rows = jobMapper.updateJob(job);

        String jobGroupDB = jobMapper.dictData("任务组");
        if (jobGroupDB.equals(job.getJobGroup())) {
            SysJobDependent sysJobDependent = new SysJobDependent();
            sysJobDependent.setJobId(jobId);
            sysJobDependent.setStatus(ScheduleConstants.Status.NORMAL.getValue());
            sysJobDependent.setBatchIndex(1);
            List<SysJobDependent> sysJobDependents = sysJobDependentMapper.selectJobDependent(sysJobDependent);
            SysJobDependent sysJobDependent1 = sysJobDependents.get(0);
            SysJobVo sysJobVo = jobMapper.selectJobById(sysJobDependent1.getDependentId());
            String invokeTarget = job.getInvokeTarget();
            TaskParam taskParam = JSON.parseObject(invokeTarget, TaskParam.class);
            String jobGroup = ScheduleUtils.getJobGroup(sysJobVo, taskParam);

            if (rows > 0) {
                scheduler.resumeJob(ScheduleUtils.getJobKey(sysJobDependent1.getDependentId(), jobGroup));
            }
        } else {
            String invokeTarget = job.getInvokeTarget();
            TaskParam taskParam = JSON.parseObject(invokeTarget, TaskParam.class);
            String jobGroup = ScheduleUtils.getJobGroup(job, taskParam);
            if (rows > 0) {
                scheduler.resumeJob(ScheduleUtils.getJobKey(jobId, jobGroup));
            }
        }
        return rows;
    }

    /**
     * 删除任务后，所对应的trigger也将被删除
     *
     * @param job 调度信息
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteJob(SysJobVo job) throws SchedulerException {
        String jobId = job.getJobId();
        int rows = jobMapper.deleteJobById(jobId);
        String jobGroupDB = jobMapper.dictData("任务组");
        if (jobGroupDB.equals(job.getJobGroup())) {
            sysJobDependentMapper.cleanDependent(jobId);
            SysJobDependent sysJobDependent = new SysJobDependent();
            sysJobDependent.setJobId(jobId);
            sysJobDependent.setStatus(job.getStatus());
            sysJobDependent.setBatchIndex(1);
            List<SysJobDependent> sysJobDependents = sysJobDependentMapper.selectJobDependent(sysJobDependent);
            if (CollectionUtils.isEmpty(sysJobDependents)) {
                return 1;
            }

            SysJobDependent sysJobDependent1 = sysJobDependents.get(0);
            SysJobVo sysJobVo = jobMapper.selectJobById(sysJobDependent1.getDependentId());
            String invokeTarget = job.getInvokeTarget();
            TaskParam taskParam = JSON.parseObject(invokeTarget, TaskParam.class);
            String jobGroup = ScheduleUtils.getJobGroup(sysJobVo, taskParam);
            if (scheduler.checkExists(ScheduleUtils.getJobKey(sysJobVo.getJobId(), jobGroup))) {
                scheduler.deleteJob(ScheduleUtils.getJobKey(sysJobVo.getJobId(), jobGroup));
            }
            return 1;
        }
        String invokeTarget = job.getInvokeTarget();
        TaskParam taskParam = JSON.parseObject(invokeTarget, TaskParam.class);
        if (rows > 0 && !"M".equals(job.getJobType())) {
            scheduler.deleteJob(ScheduleUtils.getJobKey(jobId, ScheduleUtils.getJobGroup(job, taskParam)));
        }
        return rows;
    }

    /**
     * 批量删除调度信息
     *
     * @param jobIds 需要删除的任务ID
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteJobByIds(String[] jobIds) throws SchedulerException {
        for (String jobId : jobIds) {
            SysJobVo job = jobMapper.selectJobById(jobId);
            deleteJob(job);
        }
    }

    public boolean checkJuniorDependentOpt(String jobId) {
        List<SysJobDependent> sysJobDependents = sysJobDependentMapper.selectJuniorDependentOpt(jobId);
        return !CollectionUtils.isEmpty(sysJobDependents);
    }

    /**
     * 任务调度状态修改
     *
     * @param job 调度信息
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int changeStatus(SysJobVo job) throws SchedulerException {
        int rows = 0;
        String status = job.getStatus();
        if (ScheduleConstants.Status.NORMAL.getValue().equals(status)) {
            rows = resumeJob(job);
        } else if (ScheduleConstants.Status.PAUSE.getValue().equals(status)) {
            rows = pauseJob(job);
        }
        return rows;
    }

    /**
     * 立即运行任务
     *
     * @param job 调度信息
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean run(SysJobVo job) throws SchedulerException {
        boolean result = false;
        String jobId = job.getJobId();
        String jobGroup = job.getJobGroup();
        SysJobVo properties = selectJobById(job.getJobId());

        String jobGroupDB = jobMapper.dictData("任务组");
        if (jobGroupDB.equals(properties.getJobGroup())) {
            return false;
        }
        // 参数
        JobDataMap dataMap = new JobDataMap();
        dataMap.put(ScheduleConstants.TASK_PROPERTIES, properties);
        TaskParam taskParam = ScheduleUtils.parseInvokeTarget(properties.getInvokeTarget(), properties.getBatchType());

        dataMap.put(ScheduleConstants.TASK_PARAMS, taskParam);
        dataMap.put(ScheduleConstants.TASK_RUN_MODE, ScheduleConstants.EXECUTE_IMMEDIATELY);
        JobKey jobKey = ScheduleUtils.getJobKey(jobId, jobGroup);
        if (scheduler.checkExists(jobKey)) {
            result = true;
            scheduler.triggerJob(jobKey, dataMap);
        }
        return result;
    }

    /**
     * 新增任务
     *
     * @param job 调度信息 调度信息
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertJob(SysJobVo job) throws SchedulerException, TaskException, ParseException {
        job.setJobId(idGeneratorService.generateId("SJ"));
        int rows = jobMapper.insertJob(job);
        if (rows > 0 && !"M".equals(job.getJobType())) {
            job.setStatus(ScheduleConstants.Status.PAUSE.getValue());
            ScheduleUtils.createScheduleJob(scheduler, job);
        }
        return rows;
    }

    /**
     * 更新任务的时间表达式
     *
     * @param job 调度信息
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateJob(SysJobVo job) throws SchedulerException, TaskException {
        int rows = jobMapper.updateJob(job);
        SysJobVo properties = selectJobById(job.getJobId());
        if (rows > 0 && !"M".equals(properties.getJobType())) {
            updateSchedulerJob(job);
        }
        return rows;
    }

    /**
     * 更新任务
     *
     * @param job 任务对象
     */
    public void updateSchedulerJob(SysJobVo job) throws SchedulerException, TaskException {
        //String jobId = job.getJobId();
        // 判断是否存在
        /*JobKey jobKey = ScheduleUtils.getJobKey(jobId, jobGroup);
        if (scheduler.checkExists(jobKey)) {
            // 防止创建时存在数据问题 先移除，然后在执行创建操作
            scheduler.deleteJob(jobKey);
        }*/
        ScheduleUtils.createScheduleJob(scheduler, job);
    }

    /**
     * 校验cron表达式是否有效
     *
     * @param cronExpression 表达式
     * @return 结果
     */
    @Override
    public boolean checkCronExpressionIsValid(String cronExpression) {
        return CronUtils.isValid(cronExpression);
    }

    @Override
    @Transactional
    public int saveBatch(SaveBatchSysJob saveBatchSysJob) {
        SysJob sysJob = saveBatchSysJob.getSysJob();

        String jobId = sysJob.getJobId();
        int rows;
        String username = SecurityUtils.getUsername();
        if (StringUtils.isBlank(jobId)) {
            jobId = idGeneratorService.generateId("SJ");
            sysJob.setJobId(jobId);
            rows = jobMapper.insertSysJob(sysJob, username);
            if (rows <= 0) return rows;
        } else {
            SysJobVo sysJobVo = new SysJobVo();
            sysJob.setUpdateBy(username);
            BeanUtils.copyBeanProp(sysJobVo, sysJob);
            int i = jobMapper.updateJob(sysJobVo);
            if (i <= 0) return i;
        }

        List<SysJobDependent> saveSysJobDependents = getSysJobDependents(saveBatchSysJob, jobId);

        sysJobDependentMapper.cleanDependent(jobId);
        sysJobDependentMapper.insertSysJobDependents(saveSysJobDependents);

        applicationEventPublisher.publishEvent(new FirstJobGroupEvent(this, jobId));
        return saveSysJobDependents.size();
    }

    private static List<SysJobDependent> getSysJobDependents(SaveBatchSysJob saveBatchSysJob, String jobId) {
        List<SysJobDependent> saveSysJobDependents = new ArrayList<>();
        List<SysJobDependent> sysJobDependents = saveBatchSysJob.getSysJobDependents();
        for (SysJobDependent sysJobDependent : sysJobDependents) {
            String jobVID = sysJobDependent.getDependentId();
            String[] split = jobVID.split(",");
            for (String s : split) {
                SysJobDependent sysJobDependentSave = new SysJobDependent();
                sysJobDependentSave.setCreateBy(SecurityUtils.getUsername());
                sysJobDependentSave.setJobId(jobId);
                sysJobDependentSave.setDependentId(s);
                sysJobDependentSave.setBatchIndex(sysJobDependent.getBatchIndex());
                sysJobDependentSave.setStatus(ScheduleConstants.Status.PAUSE.getValue());
                saveSysJobDependents.add(sysJobDependentSave);
            }
        }
        return saveSysJobDependents;
    }

    @Override
    public boolean checkJobGroup(SysJob sysJob) {
        String jobName = sysJob.getJobName();
        String jobGroup = sysJob.getJobGroup();
        return jobMapper.checkJobGroup(jobName, jobGroup) > 0;
    }

    @Override
    public boolean checkJobIdSize(List<SysJobDependent> sysJobDependents) {
        if (CollectionUtils.isEmpty(sysJobDependents)) return false;

        List<String> jobIds = new ArrayList<>();
        for (int i = 0; i < sysJobDependents.size(); i++) {
            SysJobDependent sysJobDependent = sysJobDependents.get(i);
            String jobVID = sysJobDependent.getDependentId();
            if (org.apache.commons.lang3.StringUtils.isBlank(jobVID)) return false;
            String[] split = jobVID.split(",");
            if (i == 0 && split.length != 1) return false;
            jobIds.addAll(Arrays.asList(split));

        }
        int jobIdCount = jobMapper.checkJobIdSize(jobIds);
        return jobIds.size() != jobIdCount;
    }

    @Override
    public boolean checkJobNameUnique(SysJobVo job) {
        SysJobVo sysJobVo = new SysJobVo();
        sysJobVo.setJobName(job.getJobName());
        List<SysJobVo> sysJobVos = jobMapper.selectJobList(sysJobVo);
        return !CollectionUtils.isEmpty(sysJobVos);
    }

    @Override
    public boolean checkJobNameUniqueNotCurrent(SysJobVo job) {
        SysJobVo sysJobVo = new SysJobVo();
        sysJobVo.setJobId(job.getJobId());
        sysJobVo.setJobName(job.getJobName());
        int count = jobMapper.checkJobNameUniqueNotCurrent(sysJobVo);
        return count > 0;
    }

    @Override
    public int exceptionRerun(String jobId, TaskParam taskParam, String dependentId) {
        SysJobVo sysJobVo = jobMapper.selectJobById(jobId);

        // 参数
        JobDataMap dataMap = new JobDataMap();
        dataMap.put(ScheduleConstants.TASK_PROPERTIES, sysJobVo);
        dataMap.put(ScheduleConstants.TASK_PARAMS, taskParam);
        dataMap.put(ScheduleConstants.TASK_RUN_MODE, ScheduleConstants.EXCEPTION_EXECUTION);
        dataMap.put(ScheduleConstants.TASK_DEPENDENT_ID, dependentId);
        JobKey jobKey = ScheduleUtils.getJobKey(jobId, taskParam.getBatchDate());
        try {
            if (scheduler.checkExists(jobKey)) {
                scheduler.triggerJob(jobKey, dataMap);
                return 1;
            }
        } catch (SchedulerException e) {
            log.error("异常重跑报错, 报错信息如下 [{}]", e.getMessage());
            return 0;
        }
        return 0;
    }

    @Override
    public List<SysJobDependentVo> selectSysJobDependent(String jobId) {
        return sysJobDependentMapper.selectSysJobDependent(jobId);
    }

    @Override
    public List<SysJobVo> selectMenuList(SysJobVo sysJobVo, String userId) {
        List<SysJobVo> jobVos = null;
        // 管理员显示所有菜单信息
        if ("1".equals(userId)) {
            jobVos = jobMapper.selectJobList(sysJobVo);
        } else {
            sysJobVo.getParams().put("userId", userId);
            jobVos = jobMapper.selectJobListByUserId(sysJobVo);
        }
        return jobVos;
    }

    @Override
    public List<TreeSelect> buildMenuTreeSelect(List<SysJobVo> sysJobVos) {
        List<SysJobVo> menuTrees = buildJobTree(sysJobVos);
        return menuTrees.stream().map(TreeSelect::new).collect(Collectors.toList());
    }

    private List<SysJobVo> buildJobTree(List<SysJobVo> sysJobVos) {
        List<SysJobVo> returnList = new ArrayList<>();
        List<String> tempList = sysJobVos.stream().map(SysJobVo::getJobId).collect(Collectors.toList());
        for (SysJobVo menu : sysJobVos) {
            // 如果是顶级节点, 遍历该父节点的所有子节点
            if (!tempList.contains(menu.getParentId())) {
                recursionFn(sysJobVos, menu);
                returnList.add(menu);
            }
        }
        if (returnList.isEmpty()) {
            returnList = sysJobVos;
        }
        return returnList;
    }

    /**
     * 递归列表
     *
     * @param list 分类表
     * @param t    子节点
     */
    private void recursionFn(List<SysJobVo> list, SysJobVo t) {
        // 得到子节点列表
        List<SysJobVo> childList = getChildList(list, t);
        t.setChildren(childList);
        for (SysJobVo tChild : childList) {
            if (hasChild(list, tChild)) {
                recursionFn(list, tChild);
            }
        }
    }

    /**
     * 得到子节点列表
     */
    private List<SysJobVo> getChildList(List<SysJobVo> list, SysJobVo t) {
        List<SysJobVo> tlist = new ArrayList<>();
        for (SysJobVo n : list) {
            if (com.integrity.common.core.utils.StringUtils.equals(n.getParentId(), t.getJobId())) {
                tlist.add(n);
            }
        }
        return tlist;
    }

    /**
     * 判断是否有子节点
     */
    private boolean hasChild(List<SysJobVo> list, SysJobVo t) {
        return !getChildList(list, t).isEmpty();
    }

    @Override
    public int changeIfDependent(SysJobVo newJob) {
        return jobMapper.updateJob(newJob);
    }
}

