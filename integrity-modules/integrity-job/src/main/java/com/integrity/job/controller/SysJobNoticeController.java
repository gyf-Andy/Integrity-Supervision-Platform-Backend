package com.integrity.job.controller;

import com.integrity.common.core.web.controller.BaseController;
import com.integrity.common.core.web.domain.AjaxResult;
import com.integrity.common.core.web.page.TableDataInfo;
import com.integrity.common.security.annotation.RequiresPermissions;
import com.integrity.job.domain.SysJobNotice;
import com.integrity.job.service.ISysJobNoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 调度日志操作处理
 *
 * @author Integrity-Supervision-Platform
 */
@RestController
@RequestMapping("/job/notice")
@RequiredArgsConstructor
public class SysJobNoticeController extends BaseController {
    private final ISysJobNoticeService jobNoticeService;

    /**
     * 查询定时任务调度日志列表
     */
    @RequiresPermissions("monitor:jobNotice:list")
    @GetMapping("/list")
    public TableDataInfo list(SysJobNotice jobNotice) {
        startPage();
        List<SysJobNotice> list = jobNoticeService.selectList(jobNotice);
        return getDataTable(list);
    }

    /**
     * 查询定时任务调度日志列表
     */
    @RequiresPermissions("monitor:jobNotice:list")
    @PostMapping("/update")
    public AjaxResult update(@RequestBody SysJobNotice jobNotice) {
        return toAjax(jobNoticeService.update(jobNotice));
    }
}

