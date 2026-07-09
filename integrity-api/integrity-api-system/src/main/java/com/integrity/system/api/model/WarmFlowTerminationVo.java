package com.integrity.system.api.model;

import lombok.Data;

import java.util.Map;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-14
 */
@Data
public class WarmFlowTerminationVo {
    private Long instanceId;

    private String userId;

    private Map<String, Object> variable;

    private String message;
}
