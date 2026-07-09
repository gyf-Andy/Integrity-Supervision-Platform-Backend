package com.integrity.job.controller;

import com.integrity.common.core.web.controller.BaseController;
import com.integrity.common.core.web.page.TableDataInfo;
import com.integrity.common.security.annotation.RequiresPermissions;
import com.integrity.job.domain.SysJobMonitor;
import com.integrity.job.service.ISysJobMonitorService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 调度监控
 *
 * @author Integrity-Supervision-Platform
 */
@RestController
@RequestMapping("/job/monitor")
@RequiredArgsConstructor
public class SysJobMonitorController extends BaseController {

    private final ISysJobMonitorService jobMonitorService;

    /**
     * 查询定时任务调度队列列表
     */
    @RequiresPermissions("monitor:jobMonitor:list")
    @GetMapping("/list")
    public TableDataInfo list(SysJobMonitor jobMonitor) {
        startPage();
        List<SysJobMonitor> list = jobMonitorService.selectList(jobMonitor);
        return getDataTable(list);
    }
}

