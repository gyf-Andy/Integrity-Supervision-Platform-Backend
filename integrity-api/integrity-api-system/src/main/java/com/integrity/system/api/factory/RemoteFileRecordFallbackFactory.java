package com.integrity.system.api.factory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;
import com.integrity.common.core.domain.R;
import com.integrity.system.api.RemoteFileRecordService;
import com.integrity.system.api.domain.SysFile;

/**
 * 文件元数据远程服务降级处理。
 *
 * @author Integrity-Supervision-Platform
 */
@Component
public class RemoteFileRecordFallbackFactory implements FallbackFactory<RemoteFileRecordService>
{
    /** 日志记录器 */
    private static final Logger log = LoggerFactory.getLogger(RemoteFileRecordFallbackFactory.class);

    /**
     * 创建文件元数据远程服务降级实例。
     *
     * @param throwable 远程调用异常
     * @return 降级后的远程服务实例
     */
    @Override
    public RemoteFileRecordService create(Throwable throwable)
    {
        log.error("file metadata service call failed:{}", throwable.getMessage());
        return new RemoteFileRecordService()
        {
            /**
             * 文件元数据保存失败时返回脱敏错误信息。
             *
             * @param sysFile 文件元数据信息
             * @param source 请求来源
             * @return 失败结果
             */
            @Override
            public R<SysFile> saveFile(SysFile sysFile, String source)
            {
                return R.fail("save file metadata failed");
            }
        };
    }
}
