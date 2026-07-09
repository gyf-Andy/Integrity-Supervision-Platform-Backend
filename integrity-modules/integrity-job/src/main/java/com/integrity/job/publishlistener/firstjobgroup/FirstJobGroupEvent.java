package com.integrity.job.publishlistener.firstjobgroup;

import lombok.Getter;
import org.springframework.context.ApplicationEvent;

/**
 * 第一次执行任务组通知事件
 *
 * @author liangli_lmj@126.com
 * @date 2024-12-03
 */
@Getter
public class FirstJobGroupEvent extends ApplicationEvent {
    private final String jobId;

    public FirstJobGroupEvent(Object source, String jobId) {
        super(source);
        this.jobId = jobId;
    }
}
