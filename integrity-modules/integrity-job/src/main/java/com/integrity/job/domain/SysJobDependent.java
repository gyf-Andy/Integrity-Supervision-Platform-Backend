package com.integrity.job.domain;

import lombok.Data;
import lombok.ToString;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-03
 */
@Data
@ToString
public class SysJobDependent {
    private Integer batchIndex;
    private String jobId;
    private String dependentId;
    private String createBy;
    private String status;
}
