package com.integrity.file.service;

import java.io.InputStream;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.nacos.common.utils.IoUtils;
import com.github.tobato.fastdfs.domain.fdfs.StorePath;
import com.github.tobato.fastdfs.service.FastFileStorageClient;
import com.integrity.common.core.utils.file.FileTypeUtils;

import lombok.RequiredArgsConstructor;

/**
 * FastDFS 文件存储
 *
 * @author Integrity-Supervision-Platform
 */
@Service
@RequiredArgsConstructor
public class FastDfsSysFileServiceImpl implements ISysFileService {
    /**
     * 域名或本机访问地址
     */
    @Value("${fdfs.domain}")
    public String domain;

    private final FastFileStorageClient storageClient;

    /**
     * FastDfs文件上传接口
     *
     * @param file 上传的文件
     * @return 访问地址
     * @throws Exception
     */
    @Override
    public String uploadFile(MultipartFile file) throws Exception {
        InputStream inputStream = file.getInputStream();
        StorePath storePath = storageClient.uploadFile(inputStream, file.getSize(),
                FileTypeUtils.getExtension(file), null);
        IoUtils.closeQuietly(inputStream);
        return domain + "/" + storePath.getFullPath();
    }
}

