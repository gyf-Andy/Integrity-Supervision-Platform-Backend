package com.integrity.system.api;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import com.integrity.common.core.constant.SecurityConstants;
import com.integrity.common.core.constant.ServiceNameConstants;
import com.integrity.common.core.domain.R;
import com.integrity.system.api.factory.RemoteFileRecordFallbackFactory;
import com.integrity.system.api.domain.SysFile;

/**
 * 文件元数据远程服务。
 *
 * @author Integrity-Supervision-Platform
 */
@FeignClient(contextId = "remoteFileRecordService", value = ServiceNameConstants.SYSTEM_SERVICE,
        fallbackFactory = RemoteFileRecordFallbackFactory.class)
public interface RemoteFileRecordService
{
    /**
     * 保存上传文件元数据。
     *
     * @param sysFile 文件元数据信息
     * @param source 请求来源
     * @return 保存后的文件信息
     */
    @PostMapping("/file")
    public R<SysFile> saveFile(@RequestBody SysFile sysFile, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);
}
