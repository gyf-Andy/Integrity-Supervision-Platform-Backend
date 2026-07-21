package com.integrity.system.domain;

import com.integrity.common.core.annotation.Excel;
import com.integrity.common.core.annotation.Excel.ColumnType;
import com.integrity.common.core.web.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 文件元数据表 sys_file_info。
 *
 * @author Integrity-Supervision-Platform
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class SysFileInfo extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 文件记录编号 */
    @Excel(name = "file id", cellType = ColumnType.STRING)
    private String fileId;

    /** 上传时的原始文件名 */
    @Excel(name = "original name")
    private String originalName;

    /** 存储后的文件名 */
    @Excel(name = "file name")
    private String fileName;

    /** 文件后缀 */
    @Excel(name = "file suffix")
    private String fileSuffix;

    /** 文件内容类型 */
    @Excel(name = "content type")
    private String contentType;

    /** 文件大小，单位字节 */
    @Excel(name = "file size")
    private Long fileSize;

    /** 文件访问地址 */
    @Excel(name = "url")
    private String url;
}
