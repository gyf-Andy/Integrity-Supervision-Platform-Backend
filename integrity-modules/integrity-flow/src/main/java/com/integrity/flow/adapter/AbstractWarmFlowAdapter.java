package com.integrity.flow.adapter;

import com.integrity.system.api.domain.SysRole;
import com.integrity.system.api.domain.SysUser;
import org.dromara.warm.flow.core.enums.CooperateType;
import org.dromara.warm.flow.core.service.TaskService;
import org.dromara.warm.flow.core.utils.StreamUtils;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.List;

@Service
public abstract class AbstractWarmFlowAdapter {
    @Resource
    protected TaskService taskService;

    /**
     * 获取权限
     *
     * @return 权限列表
     */
    protected List<String> permissionList(SysUser sysUser, String userId) {
        List<SysRole> roles = sysUser.getRoles();
        List<String> permissionList = StreamUtils.toList(roles, role -> "role:" + role.getRoleId());
        permissionList.add(userId);
        permissionList.add("dept:" + sysUser.getDeptId());
        return permissionList;
    }

    /**
     * 根据类型获取描述
     *
     * @param type 流程类型
     * @return value
     */
    protected String type(Integer type) {
        return CooperateType.getValueByKey(type);
    }
}
