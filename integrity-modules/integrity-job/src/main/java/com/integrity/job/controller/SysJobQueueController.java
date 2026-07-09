package com.integrity.job.controller;

import com.integrity.common.core.web.controller.BaseController;
import com.integrity.common.core.web.page.TableDataInfo;
import com.integrity.common.security.annotation.RequiresPermissions;
import com.integrity.job.domain.SysJobQueue;
import com.integrity.job.service.ISysJobQueueService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 调度队列
 *
 * @author Integrity-Supervision-Platform
 */
@RestController
@RequestMapping("/job/queue")
@RequiredArgsConstructor
public class SysJobQueueController extends BaseController {
    private final ISysJobQueueService jobQueueService;

    /**
     * 查询定时任务调度队列列表
     */
    @RequiresPermissions("monitor:jobNotice:list")
    @GetMapping("/list")
    public TableDataInfo list(SysJobQueue jobQueue) {
        startPage();
        List<SysJobQueue> list = jobQueueService.selectList(jobQueue);
        return getDataTable(list);
    }
}

