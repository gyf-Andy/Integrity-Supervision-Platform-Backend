package com.integrity.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.integrity.common.core.utils.StringUtils;
import com.integrity.common.redis.service.IdGeneratorService;
import com.integrity.system.api.domain.SysOperLog;
import com.integrity.system.mapper.SysOperLogMapper;
import com.integrity.system.service.ISysOperLogService;

/**
 * 操作日志 服务层处理
 * 
 * @author Integrity-Supervision-Platform
 */
@Service
public class SysOperLogServiceImpl implements ISysOperLogService
{
    @Autowired
    private SysOperLogMapper operLogMapper;

    @Autowired
    private IdGeneratorService idGeneratorService;

    /**
     * 新增操作日志
     * 
     * @param operLog 操作日志对象
     * @return 结果
     */
    @Override
    public int insertOperlog(SysOperLog operLog)
    {
        if (StringUtils.isEmpty(operLog.getOperId()))
        {
            operLog.setOperId(idGeneratorService.generateId("SOL"));
        }
        return operLogMapper.insertOperlog(operLog);
    }

    /**
     * 查询系统操作日志集合
     * 
     * @param operLog 操作日志对象
     * @return 操作日志集合
     */
    @Override
    public List<SysOperLog> selectOperLogList(SysOperLog operLog)
    {
        return operLogMapper.selectOperLogList(operLog);
    }

    /**
     * 批量删除系统操作日志
     * 
     * @param operIds 需要删除的操作日志ID
     * @return 结果
     */
    @Override
    public int deleteOperLogByIds(String[] operIds)
    {
        return operLogMapper.deleteOperLogByIds(operIds);
    }

    /**
     * 查询操作日志详细
     * 
     * @param operId 操作ID
     * @return 操作日志对象
     */
    @Override
    public SysOperLog selectOperLogById(String operId)
    {
        return operLogMapper.selectOperLogById(operId);
    }

    /**
     * 清空操作日志
     */
    @Override
    public void cleanOperLog()
    {
        operLogMapper.cleanOperLog();
    }
}

