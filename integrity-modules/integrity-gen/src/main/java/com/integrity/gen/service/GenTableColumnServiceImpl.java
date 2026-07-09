package com.integrity.gen.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.integrity.common.core.text.Convert;
import com.integrity.common.core.utils.StringUtils;
import com.integrity.common.redis.service.IdGeneratorService;
import com.integrity.gen.domain.GenTableColumn;
import com.integrity.gen.mapper.GenTableColumnMapper;

/**
 * 业务字段 服务层实现
 * 
 * @author Integrity-Supervision-Platform
 */
@Service
public class GenTableColumnServiceImpl implements IGenTableColumnService 
{
	@Autowired
	private GenTableColumnMapper genTableColumnMapper;

	@Autowired
	private IdGeneratorService idGeneratorService;

	/**
     * 查询业务字段列表
     * 
     * @param tableId 业务字段编号
     * @return 业务字段集合
     */
	@Override
	public List<GenTableColumn> selectGenTableColumnListByTableId(String tableId)
	{
	    return genTableColumnMapper.selectGenTableColumnListByTableId(tableId);
	}
	
    /**
     * 新增业务字段
     * 
     * @param genTableColumn 业务字段信息
     * @return 结果
     */
	@Override
	public int insertGenTableColumn(GenTableColumn genTableColumn)
	{
		if (StringUtils.isEmpty(genTableColumn.getColumnId()))
		{
			genTableColumn.setColumnId(idGeneratorService.generateId("GTC"));
		}
	    return genTableColumnMapper.insertGenTableColumn(genTableColumn);
	}
	
	/**
     * 修改业务字段
     * 
     * @param genTableColumn 业务字段信息
     * @return 结果
     */
	@Override
	public int updateGenTableColumn(GenTableColumn genTableColumn)
	{
	    return genTableColumnMapper.updateGenTableColumn(genTableColumn);
	}

	/**
     * 删除业务字段对象
     * 
     * @param ids 需要删除的数据ID
     * @return 结果
     */
	@Override
	public int deleteGenTableColumnByIds(String ids)
	{
		return genTableColumnMapper.deleteGenTableColumnByIds(Convert.toStrArray(ids));
	}
}

