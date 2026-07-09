package com.integrity.system.api.model;


import com.integrity.common.core.web.domain.BaseEntity;

import java.util.List;

public class WarmFlowInteractiveTypeVo extends BaseEntity {
    /**
     * 任务id
     */
    private Long taskId;

    /**
     * 增加办理人
     */
    private List<String> addHandlers;

    /**
     * 操作类型[2:转办,6:加签,3:委派,7:减签]
     */
    private Integer operatorType;

    /**
     * 部门ID
     */
    private String deptId;

    /**
     * 用户ID
     */
    private List<String> userIds;

    /**
     * 1-in查询，2-not in查询
     */
    private String queryType;

    /**
     * 昵称
     */
    private String nickName;

    public Long getTaskId() {
        return taskId;
    }

    public WarmFlowInteractiveTypeVo setTaskId(Long taskId) {
        this.taskId = taskId;
        return this;
    }

    public List<String> getAddHandlers() {
        return addHandlers;
    }

    public WarmFlowInteractiveTypeVo setAddHandlers(List<String> addHandlers) {
        this.addHandlers = addHandlers;
        return this;
    }

    public Integer getOperatorType() {
        return operatorType;
    }

    public WarmFlowInteractiveTypeVo setOperatorType(Integer operatorType) {
        this.operatorType = operatorType;
        return this;
    }

    public String getDeptId() {
        return deptId;
    }

    public WarmFlowInteractiveTypeVo setDeptId(String deptId) {
        this.deptId = deptId;
        return this;
    }

    public List<String> getUserIds() {
        return userIds;
    }

    public WarmFlowInteractiveTypeVo setUserIds(List<String> userIds) {
        this.userIds = userIds;
        return this;
    }

    public String getQueryType() {
        return queryType;
    }

    public WarmFlowInteractiveTypeVo setQueryType(String queryType) {
        this.queryType = queryType;
        return this;
    }

    public String getNickName() {
        return nickName;
    }

    public WarmFlowInteractiveTypeVo setNickName(String nickName) {
        this.nickName = nickName;
        return this;
    }
}
