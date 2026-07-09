package com.integrity.system.api.model;

import lombok.Data;

import java.util.Map;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-14
 */
@Data
public class WarmFlowSkipVo {
    private Long taskId;
    private String skipType;
    private String message;
    private String nodeCode;
    private String flowStatus;
    private String hisStatus;
    private String userId;
    private Map<String, Object> variable;
    private String hisTaskExt;
}
