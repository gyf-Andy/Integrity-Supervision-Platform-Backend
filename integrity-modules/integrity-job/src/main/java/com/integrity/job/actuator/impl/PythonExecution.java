package com.integrity.job.actuator.impl;

import com.integrity.job.domain.SysJobVo;
import com.integrity.job.util.AbstractQuartzJob;
import com.integrity.job.util.CommandUtil;
import com.integrity.job.util.ScheduleUtils;
import com.integrity.job.vo.CommandResult;
import com.integrity.job.vo.TaskParam;
import org.quartz.JobExecutionContext;

/**
 * Shell执行器
 *
 * @author liangli_lmj@126.com
 * @date 2024-11-28
 */
public class PythonExecution extends AbstractQuartzJob {

    @Override
    protected CommandResult doExecute(JobExecutionContext context, SysJobVo sysJobVo, TaskParam taskParam) throws Exception {
        String[] strArray = ScheduleUtils.commandParams(taskParam);

        return CommandUtil.exec("python", taskParam.getName(), strArray);
    }
}
