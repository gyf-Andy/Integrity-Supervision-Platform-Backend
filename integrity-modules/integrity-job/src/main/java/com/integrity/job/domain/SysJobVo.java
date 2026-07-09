package com.integrity.job.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.integrity.common.core.annotation.Excel;
import com.integrity.common.core.utils.StringUtils;
import com.integrity.job.util.CronUtils;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 定时任务调度表 sys_job
 *
 * @author Integrity-Supervision-Platform
 */
@Data
@ToString
@EqualsAndHashCode(callSuper = true)
public class SysJobVo extends SysJob {
    /**
     * 调用目标字符串
     */
    @Excel(name = "调用目标字符串")
    private String invokeTarget;

    /**
     * cron执行表达式
     */
    @Excel(name = "执行表达式")
    private String cronExpression;

    /**
     * 执行器类型
     */
    @Excel(name = "执行器类型", readConverterExp = "shell,procedure,python,bean")
    private String actuatorType;

    /**
     * 任务状态（0正常 1暂停）
     */
    @Excel(name = "任务状态", readConverterExp = "0=正常,1=暂停")
    private String status;

    /**
     * 是否可被依赖
     */
    @Excel(name = "是否可被依赖", readConverterExp = "Y=是,N=否")
    private String ifDependent;

    /**
     * 跑批类型（秒任务，分钟任务，小时任务，日批，月批，年批）
     */
    @Excel(name = "跑批类型", readConverterExp = "秒任务，分钟任务，小时任务，日批，月批，年批")
    private String batchType;

    /**
     * 异常重试次数
     */
    @Excel(name = "异常重试次数", readConverterExp = "大于1的整数值")
    private Integer exceptionRetryCount;

    /**
     * 异常等待时间，单位（秒）
     */
    @Excel(name = "异常等待时间，单位（秒）", readConverterExp = "大于1的整数值")
    private Integer exceptionWaitSecond;

    /**
     * 当{@link SysJob#getJobGroup()}为任务组时，展示的是依赖任务id
     */
    private String dependentIds;

    /**
     * 当{@link SysJob#getJobGroup()}为任务组时，展示的是依赖任务id
     */
    private String[] dependentIdArray;

    /**
     * 子菜单
     */
    private List<SysJobVo> children = new ArrayList<>();

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getNextValidTime() {
        if (StringUtils.isNotEmpty(cronExpression)) {
            return CronUtils.getNextExecution(cronExpression);
        }
        return null;
    }
}
