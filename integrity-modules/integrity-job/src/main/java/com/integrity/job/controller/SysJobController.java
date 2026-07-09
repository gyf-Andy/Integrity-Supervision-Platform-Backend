package com.integrity.job.controller;

import com.alibaba.nacos.common.utils.StringUtils;
import com.integrity.common.core.constant.ScheduleConstants;
import com.integrity.common.core.exception.job.TaskException;
import com.integrity.common.core.utils.poi.ExcelUtil;
import com.integrity.common.core.web.controller.BaseController;
import com.integrity.common.core.web.domain.AjaxResult;
import com.integrity.common.log.annotation.Log;
import com.integrity.common.log.enums.BusinessType;
import com.integrity.common.security.annotation.RequiresPermissions;
import com.integrity.common.security.utils.SecurityUtils;
import com.integrity.job.domain.SysJob;
import com.integrity.job.domain.SysJobDependent;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.service.ISysJobService;
import com.integrity.job.util.CronUtils;
import com.integrity.job.vo.SaveBatchSysJob;
import com.integrity.job.vo.SysJobDependentVo;
import lombok.RequiredArgsConstructor;
import org.quartz.SchedulerException;
import org.springframework.beans.BeanUtils;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.util.List;

/**
 * 调度任务信息操作处理
 *
 * @author Integrity-Supervision-Platform
 */
@RestController
@RequestMapping("/job")
@RequiredArgsConstructor
public class SysJobController extends BaseController {
    private final ISysJobService jobService;

    /**
     * 查询定时任务列表
     */
    @RequiresPermissions("monitor:job:list")
    @GetMapping("/list")
    public AjaxResult list(SysJobVo entity) {
        List<SysJobVo> list = jobService.selectJobList(entity);
        return success(list);
    }

    /**
     * 获取菜单下拉树列表
     */
    @GetMapping("/treeSelect")
    public AjaxResult treeSelect(SysJobVo sysJobVo) {
        String userId = String.valueOf(SecurityUtils.getUserId());
        List<SysJobVo> sysJobVos = jobService.selectMenuList(sysJobVo, userId);
        return success(jobService.buildMenuTreeSelect(sysJobVos));
    }

    /**
     * 导出定时任务列表
     */
    @RequiresPermissions("monitor:job:export")
    @Log(title = "定时任务", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysJobVo SysJobVo) {
        List<SysJobVo> list = jobService.selectJobList(SysJobVo);
        ExcelUtil<SysJobVo> util = new ExcelUtil<SysJobVo>(SysJobVo.class);
        util.exportExcel(response, list, "定时任务");
    }

    /**
     * 获取定时任务详细信息
     */
    @RequiresPermissions("monitor:job:query")
    @GetMapping(value = "/{jobId}")
    public AjaxResult getInfo(@PathVariable("jobId") String jobId) {
        SysJobVo sysJobVo = jobService.selectJobById(jobId);
        String dependentIds = sysJobVo.getDependentIds();
        if (StringUtils.isNotBlank(dependentIds)) {
            String[] split = dependentIds.split("\\],");
            for (int i = 0; i < split.length; i++) {
                String s = split[i];
                s = s.replaceAll("\\[", "").replaceAll("\\]", "");
                if (i < split.length - 1) {
                    split[i] = s;
                }
            }
            sysJobVo.setDependentIdArray(split);
        }
        return success(sysJobVo);
    }

    /**
     * 获取单任务任务被依赖的任务组
     */
    @RequiresPermissions("monitor:job:query")
    @GetMapping(value = "/dependent/{jobId}")
    public AjaxResult selectSysJobDependent(@PathVariable("jobId") String jobId) {
        List<SysJobDependentVo> sysJobDependentVos = jobService.selectSysJobDependent(jobId);
        return success(sysJobDependentVos);
    }

    /**
     * 新增定时任务
     */
    @RequiresPermissions("monitor:job:add")
    @Log(title = "定时任务", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysJobVo job) throws SchedulerException, TaskException, ParseException {
        String jobType = job.getJobType();
        if ("M".equals(jobType)) {
            if (jobService.checkJobNameUnique(job)) {
                return error("新增任务失败，'" + job.getJobName() + "'名称重复");
            }
            job.setCreateBy(SecurityUtils.getUsername());
            return toAjax(jobService.insertJob(job));
        }

        if (!CronUtils.isValid(job.getCronExpression())) {
            return error("新增任务'" + job.getJobName() + "'失败，Cron表达式不正确");
        } else if (jobService.checkJobNameUnique(job)) {
            return error("新增任务失败，'" + job.getJobName() + "'名称重复");
        } else if (StringUtils.isBlank(ScheduleConstants.BatchType.getBatchTypeKey(job.getBatchType()))) {
            return error("新增任务失败，'" + job.getJobName() + "'未指定跑批类型，或选择错误");
        }
        job.setCreateBy(SecurityUtils.getUsername());
        return toAjax(jobService.insertJob(job));
    }

    /**
     * 修改定时任务
     */
    @RequiresPermissions("monitor:job:edit")
    @Log(title = "定时任务", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysJobVo job) throws SchedulerException, TaskException {
        if ("M".equals(job.getJobType())) {
            if (jobService.checkJobNameUniqueNotCurrent(job)) {
                return error("新增任务失败，'" + job.getJobName() + "'名称重复");
            }
            job.setUpdateBy(SecurityUtils.getUsername());
            return toAjax(jobService.updateJob(job));
        }
        if (!CronUtils.isValid(job.getCronExpression())) {
            return error("修改任务'" + job.getJobName() + "'失败，Cron表达式不正确");
        } else if (StringUtils.isBlank(ScheduleConstants.BatchType.getBatchTypeKey(job.getBatchType()))) {
            return error("修改任务失败，'" + job.getJobName() + "'未指定跑批类型，或选择错误");
        }
        job.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(jobService.updateJob(job));
    }

    /**
     * 定时任务状态修改
     */
    @RequiresPermissions("monitor:job:changeStatus")
    @Log(title = "定时任务", businessType = BusinessType.UPDATE)
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestBody SysJobVo job) throws SchedulerException {
        SysJobVo newJob = jobService.selectJobById(job.getJobId());
        newJob.setStatus(job.getStatus());
        return toAjax(jobService.changeStatus(newJob));
    }

    /**
     * 定时任务依赖修改
     */
    @RequiresPermissions("monitor:job:changeStatus")
    @Log(title = "定时任务", businessType = BusinessType.UPDATE)
    @PutMapping("/changeIfDependent")
    public AjaxResult changeIfDependent(@RequestBody SysJobVo job) throws SchedulerException {
        SysJobVo newJob = jobService.selectJobById(job.getJobId());
        newJob.setIfDependent(job.getIfDependent());
        return toAjax(jobService.changeIfDependent(newJob));
    }

    /**
     * 定时任务立即执行一次
     */
    @RequiresPermissions("monitor:job:changeStatus")
    @Log(title = "定时任务", businessType = BusinessType.UPDATE)
    @PutMapping("/run")
    public AjaxResult run(@RequestBody SysJobVo job) throws SchedulerException {
        boolean result = jobService.run(job);
        return result ? success() : error("任务不存在或已过期！");
    }

    /**
     * 删除定时任务
     */
    @RequiresPermissions("monitor:job:remove")
    @Log(title = "定时任务", businessType = BusinessType.DELETE)
    @DeleteMapping("/{jobIds}")
    public AjaxResult remove(@PathVariable String[] jobIds) throws SchedulerException, TaskException {
        for (String jobId : jobIds) {
            if (jobService.checkJuniorDependentOpt(jobId)) {
                return error("任务编号'" + jobId + "'，已被任务组依赖，删除失败");
            }
        }
        jobService.deleteJobByIds(jobIds);
        return success();
    }

    /**
     * 新增定时任务组
     */
    @RequiresPermissions("monitor:job:add")
    @Log(title = "定时任务", businessType = BusinessType.INSERT)
    @PostMapping("/saveBatch")
    public AjaxResult saveBatch(@RequestBody SaveBatchSysJob saveBatchSysJob) throws SchedulerException, TaskException {
        List<SysJobDependent> sysJobDependents = saveBatchSysJob.getSysJobDependents();
        SysJob sysJob = saveBatchSysJob.getSysJob();
        SysJobVo sysJobVo = new SysJobVo();
        BeanUtils.copyProperties(sysJob, sysJobVo);
        if (CollectionUtils.isEmpty(sysJobDependents)) {
            return error("新增任务'" + sysJob.getJobName() + "'失败，依赖任务必须选择");
        } else if (jobService.checkJobIdSize(sysJobDependents)) {
            return error("新增任务失败, 第一批次任务大于0|其他批次重复");
        } else if (jobService.checkJobNameUniqueNotCurrent(sysJobVo)) {
            return error("新增任务'" + sysJob.getJobName() + "'失败，名称重复");
        }

        return toAjax(jobService.saveBatch(saveBatchSysJob));
    }
}

