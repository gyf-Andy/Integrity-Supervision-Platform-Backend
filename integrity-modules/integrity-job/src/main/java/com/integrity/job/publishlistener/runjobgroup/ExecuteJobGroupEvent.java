package com.integrity.job.publishlistener.runjobgroup;

import com.integrity.job.domain.SysJobDependent;
import com.integrity.job.vo.TaskParam;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

/**
 * 立即执行事件
 *
 * @author liangli_lmj@126.com
 * @date 2024-12-02
 */
@Getter
public class ExecuteJobGroupEvent extends ApplicationEvent {
    private final SysJobDependent sysJobDependent;
    private final TaskParam taskParam;

    public ExecuteJobGroupEvent(Object source, SysJobDependent sysJobDependent, TaskParam taskParam) {
        super(source);
        this.sysJobDependent = sysJobDependent;
        this.taskParam = taskParam;
    }
}
