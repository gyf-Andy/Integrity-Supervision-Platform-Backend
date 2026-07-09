package com.integrity.system.controller;


import com.integrity.common.core.utils.poi.ExcelUtil;
import com.integrity.common.core.web.controller.BaseController;
import com.integrity.common.core.web.domain.AjaxResult;
import com.integrity.common.core.web.page.TableDataInfo;
import com.integrity.common.log.annotation.Log;
import com.integrity.common.log.enums.BusinessType;
import com.integrity.common.security.annotation.RequiresPermissions;
import com.integrity.system.api.domain.TestLeave;
import com.integrity.system.service.ITestLeaveService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * OA 请假申请Controller
 *
 * @author Integrity-Supervision-Platform
 * @date 2024-03-07
 */
@RestController
@RequestMapping("/leave")
@RequiredArgsConstructor
public class TestLeaveController extends BaseController {
    private final ITestLeaveService testLeaveService;

    /**
     * 查询OA 请假申请列表
     */
    @RequiresPermissions("system:leave:list")
    @GetMapping("/list")
    public TableDataInfo list(TestLeave testLeave) {
        startPage();
        List<TestLeave> list = testLeaveService.selectTestLeaveList(testLeave);
        return getDataTable(list);
    }

    /**
     * 导出OA 请假申请列表
     */
    @RequiresPermissions("system:leave:export")
    @Log(title = "OA 请假申请", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TestLeave testLeave) {
        List<TestLeave> list = testLeaveService.selectTestLeaveList(testLeave);
        ExcelUtil<TestLeave> util = new ExcelUtil<>(TestLeave.class);
        util.exportExcel(response, list, "OA 请假申请数据");
    }

    /**
     * 获取OA 请假申请详细信息
     */
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") String id) {
        return success(testLeaveService.selectTestLeaveById(id));
    }

    /**
     * 新增OA 请假申请
     */
    @RequiresPermissions("system:leave:add")
    @Log(title = "OA 请假申请", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody TestLeave testLeave, String flowStatus) {
        return toAjax(testLeaveService.insertTestLeave(testLeave, flowStatus));
    }

    /**
     * 修改OA 请假申请
     */
    @RequiresPermissions("system:leave:edit")
    @Log(title = "OA 请假申请", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody TestLeave testLeave) {
        return toAjax(testLeaveService.updateTestLeave(testLeave));
    }

    /**
     * 删除OA 请假申请
     */
    @RequiresPermissions("system:leave:remove")
    @Log(title = "OA 请假申请", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable String[] ids) {
        return toAjax(testLeaveService.deleteTestLeaveByIds(ids));
    }

    /**
     * 提交审批
     */
    @RequiresPermissions("system:leave:submit")
    @Log(title = "OA 请假申请", businessType = BusinessType.OTHER)
    @GetMapping(value = "/submit")
    public AjaxResult submit(String id, String flowStatus) {
        return toAjax(testLeaveService.submit(id, flowStatus));
    }

    /**
     * 办理
     */
    @RequiresPermissions("system:leave:handle")
    @Log(title = "流程实例", businessType = BusinessType.OTHER)
    @PostMapping("/handle")
    public AjaxResult handle(@RequestBody TestLeave testLeave, Long taskId, String skipType, String message, String nodeCode, String flowStatus) {
        return toAjax(testLeaveService.handle(testLeave, taskId, skipType, message, nodeCode, flowStatus));
    }

    /**
     * 终止流程，提前结束
     *
     * @param testLeave
     * @return
     */
    @RequiresPermissions("system:leave:termination")
    @PostMapping("/termination")
    public AjaxResult termination(@RequestBody TestLeave testLeave) {
        return toAjax(testLeaveService.termination(testLeave));
    }

}

