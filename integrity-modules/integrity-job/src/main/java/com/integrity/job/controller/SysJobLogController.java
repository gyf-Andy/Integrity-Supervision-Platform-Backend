package com.integrity.job.controller;

import com.alibaba.nacos.common.utils.StringUtils;
import com.integrity.common.core.exception.job.TaskException;
import com.integrity.common.core.utils.poi.ExcelUtil;
import com.integrity.common.core.web.controller.BaseController;
import com.integrity.common.core.web.domain.AjaxResult;
import com.integrity.common.core.web.page.TableDataInfo;
import com.integrity.common.log.annotation.Log;
import com.integrity.common.log.enums.BusinessType;
import com.integrity.common.security.annotation.RequiresPermissions;
import com.integrity.job.domain.SysJobLog;
import com.integrity.job.service.ISysJobLogService;
import lombok.RequiredArgsConstructor;
import org.quartz.SchedulerException;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 调度日志操作处理
 *
 * @author Integrity-Supervision-Platform
 */
@RestController
@RequestMapping("/job/log")
@RequiredArgsConstructor
public class SysJobLogController extends BaseController {
    private final ISysJobLogService jobLogService;

    /**
     * 查询定时任务调度日志列表
     */
    @RequiresPermissions("monitor:job:list")
    @GetMapping("/list")
    public TableDataInfo list(SysJobLog sysJobLog) {
        startPage();
        List<SysJobLog> list = jobLogService.selectJobLogList(sysJobLog);
        return getDataTable(list);
    }

    /**
     * 导出定时任务调度日志列表
     */
    @RequiresPermissions("monitor:job:export")
    @Log(title = "任务调度日志", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysJobLog sysJobLog) {
        List<SysJobLog> list = jobLogService.selectJobLogList(sysJobLog);
        ExcelUtil<SysJobLog> util = new ExcelUtil<SysJobLog>(SysJobLog.class);
        util.exportExcel(response, list, "调度日志");
    }

    /**
     * 根据调度编号获取详细信息
     */
    @RequiresPermissions("monitor:job:query")
    @GetMapping(value = "/{jobLogId}")
    public AjaxResult getInfo(@PathVariable String jobLogId) {
        return success(jobLogService.selectJobLogById(jobLogId));
    }

    /**
     * 删除定时任务调度日志
     */
    @RequiresPermissions("monitor:job:remove")
    @Log(title = "定时任务调度日志", businessType = BusinessType.DELETE)
    @DeleteMapping("/{jobLogIds}")
    public AjaxResult remove(@PathVariable String[] jobLogIds) {
        return toAjax(jobLogService.deleteJobLogByIds(jobLogIds));
    }

    /**
     * 清空定时任务调度日志
     */
    @RequiresPermissions("monitor:job:remove")
    @Log(title = "调度日志", businessType = BusinessType.CLEAN)
    @DeleteMapping("/clean/{batchDate}")
    public AjaxResult clean(@PathVariable String batchDate) {
        if (StringUtils.isBlank(batchDate)) {
            return error("跑批日期不能为空");
        }
        jobLogService.cleanJobLog(batchDate);
        return success();
    }

    /**
     * 异常重跑
     */
    @RequiresPermissions("monitor:job:exceptionReRun")
    @Log(title = "定时任务", businessType = BusinessType.INSERT)
    @PostMapping("/exceptionRerun")
    public AjaxResult exceptionRerun(@RequestBody SysJobLog sysJobLog) throws SchedulerException, TaskException {
        return toAjax(jobLogService.exceptionRerun(sysJobLog));
    }
}

