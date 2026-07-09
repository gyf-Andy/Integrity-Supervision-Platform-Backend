package com.integrity.job.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.ToString;

import java.util.Date;

/**
 * @author liangli_lmj@126.com
 * @date 2024-12-05
 */
@Data
@ToString
public class SysJobNotice {
    /**
     * 任务通知ID
     */
    private String jobNoticeId;
    /**
     * 任务ID
     */
    private String jobId;
    /**
     * 任务名称
     */
    private String jobName;
    /**
     * 通知内容
     */
    private String noticeContent;
    /**
     * 通知目标
     */
    private String noticeTarget;
    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;
    /**
     * 跑批日期
     */
    private String batchDate;
    /**
     * 是否处理，Y-是N-否
     */
    private String ifHandle;
}
