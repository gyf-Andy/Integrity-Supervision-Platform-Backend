package com.integrity.system.api.model;

import lombok.Data;

import java.util.List;
import java.util.Map;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-14
 */
@Data
public class WarmFlowSkipByInsIdVo {
    private Long instanceId;

    private String userId;

    private String flowStatus;

    private Map<String, Object> variable;

    private String skipType;

    private List<String> permissionFlag;
}
