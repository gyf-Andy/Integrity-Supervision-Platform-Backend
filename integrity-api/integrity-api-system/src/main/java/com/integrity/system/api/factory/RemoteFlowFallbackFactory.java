package com.integrity.system.api.factory;

import com.alibaba.fastjson2.JSONObject;
import com.integrity.common.core.domain.R;
import com.integrity.system.api.RemoteFlowService;
import com.integrity.system.api.model.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 审批流程服务降级处理
 *
 * @author Integrity-Supervision-Platform
 */
@Component
public class RemoteFlowFallbackFactory implements FallbackFactory<RemoteFlowService> {
    private static final Logger log = LoggerFactory.getLogger(RemoteFlowFallbackFactory.class);

    @Override
    public RemoteFlowService create(Throwable throwable) {
        log.error("流程服务调用失败:{}", throwable.getMessage());
        return new RemoteFlowService() {
            @Override
            public R<List<String>> getPermission(Long instanceId, String source) {
                return R.fail("审批流程系统获取权限失败：" + throwable.getMessage());
            }

            @Override
            public R<Boolean> remove(List<Long> instanceIds, String source) {
                return R.fail("审批流程系统删除实例失败：" + throwable.getMessage());
            }

            @Override
            public R<JSONObject> skip(WarmFlowSkipVo warmFlowSkipVo, String source) {
                return R.fail("审批流程系统办理失败：" + throwable.getMessage());
            }

            @Override
            public R<JSONObject> start(WarmFlowStartVo warmFlowStartVo, String source) {
                return R.fail("审批流程系统启动流程失败：" + throwable.getMessage());
            }

            @Override
            public R<Boolean> structureUser(Long id, String additionalHandler, String source) {
                return R.fail("审批流程系统抄送用户失败：" + throwable.getMessage());
            }

            @Override
            public R<JSONObject> skipByInsId(WarmFlowSkipByInsIdVo warmFlowSkipByInsIdVo, String source) {
                return R.fail("审批流程系统提交审批失败：" + throwable.getMessage());
            }

            @Override
            public R<JSONObject> termination(WarmFlowTerminationVo warmFlowTerminationVo, String source) {
                return R.fail("审批流程系统终止流程失败：" + throwable.getMessage());
            }
        };
    }
}

