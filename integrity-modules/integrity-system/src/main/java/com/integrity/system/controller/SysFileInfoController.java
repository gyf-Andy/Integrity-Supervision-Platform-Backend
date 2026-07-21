package com.integrity.system.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.integrity.common.core.domain.R;
import com.integrity.common.core.utils.poi.ExcelUtil;
import com.integrity.common.core.web.controller.BaseController;
import com.integrity.common.core.web.domain.AjaxResult;
import com.integrity.common.core.web.page.TableDataInfo;
import com.integrity.common.log.annotation.Log;
import com.integrity.common.log.enums.BusinessType;
import com.integrity.common.security.annotation.InnerAuth;
import com.integrity.common.security.annotation.RequiresPermissions;
import com.integrity.system.api.domain.SysFile;
import com.integrity.system.domain.SysFileInfo;
import com.integrity.system.service.ISysFileInfoService;

/**
 * 文件元数据管理。
 *
 * @author Integrity-Supervision-Platform
 */
@RestController
@RequestMapping("/file")
public class SysFileInfoController extends BaseController
{
    /** 文件元数据服务 */
    @Autowired
    private ISysFileInfoService fileInfoService;

    /**
     * 查询文件元数据列表。
     *
     * @param fileInfo 查询条件
     * @return 分页文件元数据
     */
    @RequiresPermissions("system:file:list")
    @GetMapping("/list")
    public TableDataInfo list(SysFileInfo fileInfo)
    {
        startPage();
        List<SysFileInfo> list = fileInfoService.selectFileInfoList(fileInfo);
        return getDataTable(list);
    }

    /**
     * 导出文件元数据。
     *
     * @param response HTTP 响应
     * @param fileInfo 查询条件
     */
    @Log(title = "File Management", businessType = BusinessType.EXPORT)
    @RequiresPermissions("system:file:export")
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysFileInfo fileInfo)
    {
        List<SysFileInfo> list = fileInfoService.selectFileInfoList(fileInfo);
        ExcelUtil<SysFileInfo> util = new ExcelUtil<SysFileInfo>(SysFileInfo.class);
        util.exportExcel(response, list, "file data");
    }

    /**
     * 根据文件编号查询文件元数据详情。
     *
     * @param fileId 文件编号
     * @return 文件元数据详情
     */
    @RequiresPermissions("system:file:query")
    @GetMapping(value = "/{fileId}")
    public AjaxResult getInfo(@PathVariable String fileId)
    {
        return success(fileInfoService.selectFileInfoById(fileId));
    }

    /**
     * 批量删除文件元数据。
     *
     * @param fileIds 文件编号数组
     * @return 删除结果
     */
    @Log(title = "File Management", businessType = BusinessType.DELETE)
    @RequiresPermissions("system:file:remove")
    @DeleteMapping("/{fileIds}")
    public AjaxResult remove(@PathVariable String[] fileIds)
    {
        return toAjax(fileInfoService.deleteFileInfoByIds(fileIds));
    }

    /**
     * 内部接口：保存上传成功后的文件元数据。
     *
     * @param sysFile 上传文件信息
     * @return 保存后的文件信息
     */
    @InnerAuth
    @PostMapping
    public R<SysFile> add(@RequestBody SysFile sysFile)
    {
        SysFileInfo fileInfo = new SysFileInfo();
        BeanUtils.copyProperties(sysFile, fileInfo);
        int rows = fileInfoService.insertFileInfo(fileInfo);
        if (rows <= 0)
        {
            return R.fail("save file metadata failed");
        }
        sysFile.setFileId(fileInfo.getFileId());
        return R.ok(sysFile);
    }
}
