# 文件存储实现梳理

## 结论

- 文件能力集中在 `integrity-modules/integrity-file` 微服务。
- 调用入口是 `POST /upload`，其他模块通过 `RemoteFileService` Feign 调用。
- `SysFile` 只是返回 DTO，包含 `name` 和 `url`，文件服务本身未看到数据库持久化。
- 当前代码中 `LocalSysFileServiceImpl` 标记 `@Primary`，因此默认注入本地磁盘实现；MinIO/FastDFS 实现存在，但未看到条件切换注解。
- Docker 文档描述了 `minio.enabled` 开关，但当前 Java 代码未看到对应 `@ConditionalOnProperty`。

## 链路

1. 调用方上传 MultipartFile。
2. Feign `RemoteFileService.upload()` 调用 `integrity-file` 服务 `/upload`。
3. `SysFileController` 调用注入的 `ISysFileService.uploadFile(file)`。
4. 存储实现返回可访问 URL。
5. Controller 返回 `SysFile{name,url}`。
6. 调用方按业务需要保存 URL，例如用户头像保存到 `sys_user.avatar`。

## 存储后端

- 本地磁盘：使用 `file.path` 落盘，`file.prefix` 做 Spring 静态资源映射，返回 `file.domain + file.prefix + name`。
- MinIO：使用 `minio.url/accessKey/secretKey/bucketName` 创建客户端，把对象写入 bucket，返回 `minio.url + "/" + bucketName + "/" + fileName`。
- FastDFS：使用 `FastFileStorageClient.uploadFile()`，返回 `fdfs.domain + "/" + storePath.getFullPath()`。

## 注意点

- 本地实现会走 `FileUploadUtils.upload()`，有 50MB 限制、文件名长度限制和扩展名白名单。
- MinIO/FastDFS 实现只复用文件名生成，没有调用 `assertAllowed()`，通用上传场景缺少同等校验。
- MinIO 配置类没有 `endpoint` 字段；Docker 注入的 `MINIO_ENDPOINT` 当前未被 Java 代码绑定。
- Docker 注入 `MINIO_BUCKET`，但 Java 字段是 `bucketName`；需依赖 Nacos 里已有 `minio.bucketName` 或改成 `MINIO_BUCKET_NAME` 这类可绑定变量。
- 外部双模型分析按 CCG 流程尝试调用，但本机 wrapper 环境失败：antigravity 缺少 `agy`，Claude wrapper 退出。
