package com.integrity.system.api.model;

import lombok.Data;

import java.util.Map;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-14
 */
@Data
public class WarmFlowStartVo {
    private String id;

    private String userId;

    private String flowCode;

    private String flowStatus;

    private Map<String, Object> variable;
}
