package com.integrity.job.publishlistener.runjobgroup;

import lombok.Getter;
import org.springframework.context.ApplicationEvent;

/**
 * 定时执行事件
 *
 * @author liangli_lmj@126.com
 * @date 2024-12-02
 */
@Getter
public class TimedJobGroupEvent extends ApplicationEvent {
    private final String jobId;
    private final String dependentId;

    public TimedJobGroupEvent(Object source, String jobId, String dependentId) {
        super(source);
        this.jobId = jobId;
        this.dependentId = dependentId;
    }

}
