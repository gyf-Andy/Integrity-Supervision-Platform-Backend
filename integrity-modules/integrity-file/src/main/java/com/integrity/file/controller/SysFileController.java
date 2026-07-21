package com.integrity.file.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.integrity.common.core.constant.SecurityConstants;
import com.integrity.common.core.domain.R;
import com.integrity.common.core.utils.ServletUtils;
import com.integrity.common.core.utils.StringUtils;
import com.integrity.common.core.utils.file.FileUtils;
import com.integrity.file.service.ISysFileService;
import com.integrity.system.api.RemoteFileRecordService;
import com.integrity.system.api.domain.SysFile;

/**
 * 文件请求处理。
 *
 * @author Integrity-Supervision-Platform
 */
@RestController
public class SysFileController
{
    /** 日志记录器 */
    private static final Logger log = LoggerFactory.getLogger(SysFileController.class);

    /** 文件存储服务 */
    @Autowired
    private ISysFileService sysFileService;

    /** 文件元数据远程登记服务 */
    @Autowired
    private RemoteFileRecordService remoteFileRecordService;

    /**
     * 上传文件并登记文件元数据。
     *
     * @param file 上传文件
     * @return 上传后的文件信息
     */
    @PostMapping("upload")
    public R<SysFile> upload(@RequestParam("file") MultipartFile file)
    {
        try
        {
            String url = sysFileService.uploadFile(file);
            String fileName = FileUtils.getName(url);
            SysFile sysFile = new SysFile();
            sysFile.setName(fileName);
            sysFile.setUrl(url);
            sysFile.setOriginalName(file.getOriginalFilename());
            sysFile.setFileName(fileName);
            sysFile.setFileSuffix(getExtension(fileName));
            sysFile.setContentType(file.getContentType());
            sysFile.setFileSize(file.getSize());
            sysFile.setCreateBy(getUsername());
            if (!saveFileRecord(sysFile))
            {
                return R.fail("upload file metadata failed");
            }
            return R.ok(sysFile);
        }
        catch (Exception e)
        {
            log.error("upload file failed", e);
            return R.fail("upload file failed");
        }
    }

    /**
     * 保存文件元数据记录，并将系统服务生成的文件编号回填到上传响应对象。
     *
     * @param sysFile 文件元数据信息
     * @return 是否保存成功
     */
    private boolean saveFileRecord(SysFile sysFile)
    {
        try
        {
            R<SysFile> result = remoteFileRecordService.saveFile(sysFile, SecurityConstants.INNER);
            if (result == null || result.getCode() != R.SUCCESS)
            {
                log.warn("save file metadata failed, url: {}, originalName: {}, reason: {}",
                        sysFile.getUrl(), sysFile.getOriginalName(), result == null ? "empty response" : result.getMsg());
                return false;
            }
            if (result.getData() != null)
            {
                sysFile.setFileId(result.getData().getFileId());
            }
            return StringUtils.isNotEmpty(sysFile.getFileId());
        }
        catch (Exception e)
        {
            log.warn("save file metadata failed, url: {}, originalName: {}", sysFile.getUrl(), sysFile.getOriginalName(), e);
            return false;
        }
    }

    /**
     * 从网关透传请求头中获取当前上传人。
     *
     * @return 当前用户名，缺失时返回 unknown
     */
    private String getUsername()
    {
        String username = ServletUtils.getRequest().getHeader(SecurityConstants.DETAILS_USERNAME);
        return StringUtils.isEmpty(username) ? "unknown" : username;
    }

    /**
     * 获取文件后缀。
     *
     * @param fileName 文件名
     * @return 小写文件后缀，无后缀时返回空字符串
     */
    private String getExtension(String fileName)
    {
        int index = fileName == null ? -1 : fileName.lastIndexOf(".");
        return index == -1 ? "" : fileName.substring(index + 1).toLowerCase();
    }
}
