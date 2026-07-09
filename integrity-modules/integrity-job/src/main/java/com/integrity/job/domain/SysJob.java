package com.integrity.job.domain;

import com.integrity.common.core.annotation.Excel;
import com.integrity.common.core.web.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

/**
 * 定时任务调度表 sys_job
 *
 * @author Integrity-Supervision-Platform
 */
@Data
@ToString
@EqualsAndHashCode(callSuper = true)
public class SysJob extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * 任务ID
     */
    @Excel(name = "任务序号")
    private String jobId;

    /**
     * 任务名称
     */
    @Excel(name = "任务名称")
    private String jobName;

    /**
     * 父任务名称
     */
    @Excel(name = "父任务名称")
    private String parentName;

    /**
     * 父任务ID
     */
    @Excel(name = "父任务ID")
    private String parentId;

    /**
     * 显示顺序
     */
    @Excel(name = "显示顺序")
    private Integer orderNum;

    /**
     * 任务组名
     */
    @Excel(name = "任务组名")
    private String jobGroup;

    /**
     * 任务类型
     */
    @Excel(name = "任务类型")
    private String jobType;
}
