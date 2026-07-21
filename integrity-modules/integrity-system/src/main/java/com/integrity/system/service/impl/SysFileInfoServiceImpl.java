package com.integrity.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.integrity.common.core.utils.StringUtils;
import com.integrity.common.redis.service.IdGeneratorService;
import com.integrity.system.domain.SysFileInfo;
import com.integrity.system.mapper.SysFileInfoMapper;
import com.integrity.system.service.ISysFileInfoService;

/**
 * 文件元数据服务实现。
 *
 * @author Integrity-Supervision-Platform
 */
@Service
public class SysFileInfoServiceImpl implements ISysFileInfoService
{
    /** 文件元数据数据访问层 */
    @Autowired
    private SysFileInfoMapper fileInfoMapper;

    /** 分布式编号生成服务 */
    @Autowired
    private IdGeneratorService idGeneratorService;

    /**
     * 查询文件元数据列表。
     *
     * @param fileInfo 查询条件
     * @return 文件元数据列表
     */
    @Override
    public List<SysFileInfo> selectFileInfoList(SysFileInfo fileInfo)
    {
        return fileInfoMapper.selectFileInfoList(fileInfo);
    }

    /**
     * 根据文件编号查询文件元数据。
     *
     * @param fileId 文件编号
     * @return 文件元数据
     */
    @Override
    public SysFileInfo selectFileInfoById(String fileId)
    {
        return fileInfoMapper.selectFileInfoById(fileId);
    }

    /**
     * 新增或更新文件元数据。
     *
     * @param fileInfo 文件元数据
     * @return 影响行数
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertFileInfo(SysFileInfo fileInfo)
    {
        SysFileInfo exists = fileInfoMapper.selectFileInfoByUrl(fileInfo.getUrl());
        if (exists != null)
        {
            fileInfo.setFileId(exists.getFileId());
            return fileInfoMapper.updateFileInfo(fileInfo);
        }
        if (StringUtils.isEmpty(fileInfo.getFileId()))
        {
            fileInfo.setFileId(idGeneratorService.generateId("SF"));
        }
        try
        {
            return fileInfoMapper.insertFileInfo(fileInfo);
        }
        catch (DuplicateKeyException e)
        {
            SysFileInfo duplicated = fileInfoMapper.selectFileInfoByUrl(fileInfo.getUrl());
            if (duplicated != null)
            {
                fileInfo.setFileId(duplicated.getFileId());
                return fileInfoMapper.updateFileInfo(fileInfo);
            }
            throw e;
        }
    }

    /**
     * 批量删除文件元数据。
     *
     * @param fileIds 文件编号数组
     * @return 影响行数
     */
    @Override
    public int deleteFileInfoByIds(String[] fileIds)
    {
        return fileInfoMapper.deleteFileInfoByIds(fileIds);
    }
}
