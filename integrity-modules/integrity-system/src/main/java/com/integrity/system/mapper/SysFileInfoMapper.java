package com.integrity.system.mapper;

import java.util.List;
import com.integrity.system.domain.SysFileInfo;

/**
 * 文件元数据数据访问层。
 *
 * @author Integrity-Supervision-Platform
 */
public interface SysFileInfoMapper
{
    /**
     * 查询文件元数据列表。
     *
     * @param fileInfo 查询条件
     * @return 文件元数据列表
     */
    public List<SysFileInfo> selectFileInfoList(SysFileInfo fileInfo);

    /**
     * 根据文件编号查询文件元数据。
     *
     * @param fileId 文件编号
     * @return 文件元数据
     */
    public SysFileInfo selectFileInfoById(String fileId);

    /**
     * 根据文件访问地址查询文件元数据。
     *
     * @param url 文件访问地址
     * @return 文件元数据
     */
    public SysFileInfo selectFileInfoByUrl(String url);

    /**
     * 新增文件元数据。
     *
     * @param fileInfo 文件元数据
     * @return 影响行数
     */
    public int insertFileInfo(SysFileInfo fileInfo);

    /**
     * 修改文件元数据。
     *
     * @param fileInfo 文件元数据
     * @return 影响行数
     */
    public int updateFileInfo(SysFileInfo fileInfo);

    /**
     * 批量删除文件元数据。
     *
     * @param fileIds 文件编号数组
     * @return 影响行数
     */
    public int deleteFileInfoByIds(String[] fileIds);
}
