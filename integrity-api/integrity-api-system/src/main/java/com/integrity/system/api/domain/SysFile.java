package com.integrity.system.api.domain;

import java.io.Serializable;
import lombok.Data;

/**
 * 文件上传响应与元数据信息。
 *
 * @author Integrity-Supervision-Platform
 */
@Data
public class SysFile implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 文件记录编号 */
    private String fileId;

    /** 兼容原上传接口返回的文件名称 */
    private String name;

    /** 文件访问地址 */
    private String url;

    /** 上传时的原始文件名 */
    private String originalName;

    /** 存储后的文件名 */
    private String fileName;

    /** 文件后缀 */
    private String fileSuffix;

    /** 文件内容类型 */
    private String contentType;

    /** 文件大小，单位字节 */
    private Long fileSize;

    /** 上传人 */
    private String createBy;
}
