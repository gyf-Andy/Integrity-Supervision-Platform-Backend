package com.integrity.job.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * @author liangli_lmj@126.com
 * @date 2024/12/8 20:43
 */
@Data
public class SysJobDependentVo implements Serializable {
    /**
     * 任务名称
     */
    private String jobName;
    /**
     * 创建人
     */
    private String createBy;
    /**
     * 任务组状态
     */
    private String status;
    /**
     * 任务组执行批次
     */
    private String batchIndex;
    /**
     * 任务组创建时间
     */
    private String createTime;
}
