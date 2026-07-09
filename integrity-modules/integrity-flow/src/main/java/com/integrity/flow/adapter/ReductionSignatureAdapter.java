package com.integrity.flow.adapter;

import com.integrity.common.security.utils.SecurityUtils;
import com.integrity.system.api.model.WarmFlowInteractiveTypeVo;
import com.integrity.system.api.domain.SysUser;
import org.dromara.warm.flow.core.dto.FlowParams;
import org.dromara.warm.flow.core.enums.CooperateType;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * 减签适配器
 */
@Component
public class ReductionSignatureAdapter extends AbstractWarmFlowAdapter implements WarmFlowAdapter {
    @Override
    public boolean isAdapter(Integer warmFlowType) {
        return Objects.equals(CooperateType.REDUCTION_SIGNATURE.getKey(), warmFlowType);
    }

    @Override
    public boolean adapter(WarmFlowInteractiveTypeVo obj) {
        Long taskId = obj.getTaskId();
        SysUser sysUser = SecurityUtils.getLoginUser().getSysUser();
        String userId = String.valueOf(sysUser.getUserId());
        FlowParams flowParams = new FlowParams()
                .handler(userId)
                .permissionFlag(permissionList(sysUser, userId))
                .reductionHandlers(obj.getAddHandlers())
                .message(type(obj.getOperatorType()));

        return super.taskService.reductionSignature(taskId, flowParams);
    }
}
