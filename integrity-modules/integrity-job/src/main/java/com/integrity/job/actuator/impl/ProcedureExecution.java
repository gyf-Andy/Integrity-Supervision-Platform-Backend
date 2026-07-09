package com.integrity.job.actuator.impl;

import com.alibaba.fastjson2.JSONObject;
import com.integrity.common.core.utils.SpringUtils;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.mapper.SysJobMapper;
import com.integrity.job.util.AbstractQuartzJob;
import com.integrity.job.vo.CommandResult;
import com.integrity.job.vo.TaskParam;
import org.apache.commons.collections4.MapUtils;
import org.quartz.JobExecutionContext;

/**
 * 存储过程执行器
 *
 * @author liangli_lmj@126.com
 * @date 2024-11-28
 */
public class ProcedureExecution extends AbstractQuartzJob {

    @Override
    protected CommandResult doExecute(JobExecutionContext context, SysJobVo sysJobVo, TaskParam taskParam) throws Exception {
        try {
            SysJobMapper bean = SpringUtils.getBean(SysJobMapper.class);
            JSONObject commandParam = taskParam.getCommandParam();
            commandParam.put("output_code", null);
            commandParam.put("output_message", null);

            bean.callStoredProcedure(taskParam.getName(), commandParam);

            return new CommandResult(MapUtils.getInteger(commandParam, "output_code"), MapUtils.getString(commandParam, "output_message"));
        } catch (Exception e) {
            e.printStackTrace();
            return CommandResult.fail(e.getMessage());
        }

    }
}