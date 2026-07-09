package com.integrity.system.mapper;


import com.integrity.system.api.domain.TestLeave;

import java.util.List;

/**
 * OA 请假申请Mapper接口
 *
 * @author Integrity-Supervision-Platform
 * @date 2024-03-07
 */
public interface TestLeaveMapper {
    /**
     * 查询OA 请假申请
     *
     * @param id OA 请假申请主键
     * @return OA 请假申请
     */
    public TestLeave selectTestLeaveById(String id);

    /**
     * 查询OA 请假申请
     *
     * @param ids OA 请假申请主键s
     * @return OA 请假申请
     */
    public List<TestLeave> selectTestLeaveByIds(String[] ids);

    /**
     * 查询OA 请假申请列表
     *
     * @param testLeave OA 请假申请
     * @return OA 请假申请集合
     */
    public List<TestLeave> selectTestLeaveList(TestLeave testLeave);

    /**
     * 新增OA 请假申请
     *
     * @param testLeave OA 请假申请
     * @return 结果
     */
    public int insertTestLeave(TestLeave testLeave);

    /**
     * 修改OA 请假申请
     *
     * @param testLeave OA 请假申请
     * @return 结果
     */
    public int updateTestLeave(TestLeave testLeave);

    /**
     * 删除OA 请假申请
     *
     * @param id OA 请假申请主键
     * @return 结果
     */
    public int deleteTestLeaveById(String id);

    /**
     * 批量删除OA 请假申请
     *
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTestLeaveByIds(String[] ids);
}

