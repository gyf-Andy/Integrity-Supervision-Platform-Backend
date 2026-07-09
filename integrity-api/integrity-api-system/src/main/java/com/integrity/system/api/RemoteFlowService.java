package com.integrity.system.api;

import com.alibaba.fastjson2.JSONObject;
import com.integrity.common.core.constant.SecurityConstants;
import com.integrity.common.core.constant.ServiceNameConstants;
import com.integrity.common.core.domain.R;
import com.integrity.system.api.factory.RemoteFlowFallbackFactory;
import com.integrity.system.api.model.*;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 流程服务
 *
 * @author Integrity-Supervision-Platform
 */
@FeignClient(contextId = "remoteFlowService", value = ServiceNameConstants.FLOW_SERVICE, fallbackFactory = RemoteFlowFallbackFactory.class)
public interface RemoteFlowService {
    /**
     * 获取流程权限
     *
     * @param instanceId 实例ID
     */
    @GetMapping("/execute/getPermission/{instanceId}")
    R<List<String>> getPermission(@PathVariable("instanceId") Long instanceId, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);

    @DeleteMapping("/execute/remove/{instanceIds}")
    R<Boolean> remove(@PathVariable("instanceIds") List<Long> instanceIds, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);

    @PostMapping("/execute/skip")
    R<JSONObject> skip(@RequestBody WarmFlowSkipVo warmFlowSkipVo, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);

    @PostMapping("/execute/start")
    R<JSONObject> start(@RequestBody WarmFlowStartVo warmFlowStartVo, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);

    @GetMapping("/structureUser/{id}/{additionalHandler}")
    R<Boolean> structureUser(@PathVariable("id") Long id, @PathVariable("additionalHandler") String additionalHandler, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);

    @PostMapping("/execute/skipByInsId")
    R<JSONObject> skipByInsId(@RequestBody WarmFlowSkipByInsIdVo warmFlowSkipByInsIdVo, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);

    @PostMapping("/execute/termination")
    R<JSONObject> termination(@RequestBody WarmFlowTerminationVo warmFlowTerminationVo, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);
}

