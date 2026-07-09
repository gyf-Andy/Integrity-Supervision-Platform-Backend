package com.integrity.job.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.integrity.common.core.annotation.Excel;
import com.integrity.common.core.web.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.Date;

/**
 * 定时任务调度日志表 sys_job_log
 *
 * @author Integrity-Supervision-Platform
 */
@Data
@ToString
@EqualsAndHashCode(callSuper = true)
public class SysJobLog extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * ID
     */
    @Excel(name = "日志序号")
    private String jobLogId;
    /**
     * 任务ID
     */
    private String jobId;
    /**
     * 任务名称
     */
    @Excel(name = "任务名称")
    private String jobName;

    /**
     * 任务组名
     */
    @Excel(name = "任务组名")
    private String jobGroup;

    /**
     * 调用目标字符串
     */
    @Excel(name = "调用目标字符串")
    private String invokeTarget;

    /**
     * 日志信息
     */
    @Excel(name = "日志信息")
    private String jobMessage;

    /**
     * 执行状态（0正常 1失败）
     */
    @Excel(name = "执行状态", readConverterExp = "0=正常,1=失败")
    private String status;

    /**
     * 异常信息
     */
    @Excel(name = "异常信息")
    private String exceptionInfo;

    /**
     * 开始时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /**
     * 停止时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date stopTime;
    /**
     * 运行时长
     */
    private Double runTime;
    /**
     * 跑批时间
     */
    private String batchDate;
    /**
     * 依赖ID
     */
    private String dependentId;
    /**
     * 运行模式
     */
    private String runMode;
}

