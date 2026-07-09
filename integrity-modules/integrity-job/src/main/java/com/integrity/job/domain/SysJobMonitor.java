package com.integrity.job.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.ToString;

import java.util.Date;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-09
 */
@Data
@ToString
public class SysJobMonitor {
    /**
     * 监控ID
     */
    private String jobMonitorId;
    /**
     * 任务ID
     */
    private String jobId;
    /**
     * 任务组ID
     */
    private String dependentId;
    /**
     * 跑批日期
     */
    private String batchDate;
    /**
     * 跑批类型
     */
    private String batchType;
    /**
     * 状态0-等待调起,1-调度完成,2-调度中
     */
    private String status;
    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;
    /**
     * 调用目标字符串
     */
    private String invokeTarget;
    /**
     * 分类名称
     */
    private String parentName;
}
