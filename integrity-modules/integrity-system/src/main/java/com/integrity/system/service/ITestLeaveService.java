package com.integrity.system.service;


import com.integrity.system.api.domain.TestLeave;

import java.util.List;

/**
 * OA 请假申请Service接口
 *
 * @author Integrity-Supervision-Platform
 * @date 2024-03-07
 */
public interface ITestLeaveService {
    /**
     * 查询OA 请假申请
     *
     * @param id OA 请假申请主键
     * @return OA 请假申请
     */
    public TestLeave selectTestLeaveById(String id);

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
     * @param testLeave  OA 请假申请
     * @param flowStatus 自定义流程状态扩展
     * @return 结果
     */
    public int insertTestLeave(TestLeave testLeave, String flowStatus);

    /**
     * 修改OA 请假申请
     *
     * @param testLeave OA 请假申请
     * @return 结果
     */
    public int updateTestLeave(TestLeave testLeave);

    /**
     * 批量删除OA 请假申请
     *
     * @param ids 需要删除的OA 请假申请主键集合
     * @return 结果
     */
    public int deleteTestLeaveByIds(String[] ids);

    /**
     * 删除OA 请假申请信息
     *
     * @param id OA 请假申请主键
     * @return 结果
     */
    public int deleteTestLeaveById(String id);

    /**
     * 提交审批
     *
     * @param id
     * @param flowStatus 自定义流程状态扩展
     * @return
     */
    public int submit(String id, String flowStatus);

    /**
     * 办理
     *
     * @param testLeave
     * @param taskId
     * @param skipType
     * @param message
     * @param nodeCode
     * @param flowStatus 自定义流程状态扩展
     * @return
     */
    int handle(TestLeave testLeave, Long taskId, String skipType, String message, String nodeCode, String flowStatus);

    /**
     * 终止流程，提前结束
     *
     * @param testLeave
     * @return
     */
    int termination(TestLeave testLeave);
}

