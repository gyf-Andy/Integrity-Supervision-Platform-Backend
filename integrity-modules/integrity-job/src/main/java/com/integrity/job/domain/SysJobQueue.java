package com.integrity.job.domain;

import lombok.Data;

/**
 * 定时任务队列
 *
 * @author liangli_lmj@126.com
 * @date 2024-12-05
 */
@Data
public class SysJobQueue {
    /**
     * 任务组ID
     */
    private String jobId;
    /**
     * 跑批日期
     */
    private String batchDate;
    /**
     * 依赖ID
     */
    private String dependentId;
    /**
     * 状态,0-任务组同一批所有任务等待,1-任务组同一批所有任务完成
     */
    private String status;
    /**
     * 批次号
     */
    private int batchIndex;
}
