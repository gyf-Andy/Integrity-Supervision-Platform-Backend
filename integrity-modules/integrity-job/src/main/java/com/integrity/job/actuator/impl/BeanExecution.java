package com.integrity.job.actuator.impl;

import com.alibaba.fastjson2.JSONObject;
import com.integrity.common.core.utils.SpringUtils;
import com.integrity.common.core.utils.StringUtils;
import com.integrity.job.domain.SysJobVo;
import com.integrity.job.util.AbstractQuartzJob;
import com.integrity.job.vo.CommandResult;
import com.integrity.job.vo.TaskParam;
import org.quartz.JobExecutionContext;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;

/**
 * 存储过程执行器
 *
 * @author liangli_lmj@126.com
 * @date 2024-11-28
 */
public class BeanExecution extends AbstractQuartzJob {

    @Override
    protected CommandResult doExecute(JobExecutionContext context, SysJobVo sysJobVo, TaskParam taskParam) throws Exception {
        try {
            invokeMethod(sysJobVo, taskParam);
            return CommandResult.success();
        } catch (Exception e) {
            e.printStackTrace();
            return CommandResult.fail(e.getMessage());
        }
    }

    /**
     * 执行方法
     *
     * @param SysJobVo  系统任务
     * @param taskParam 任务参数
     */
    public static void invokeMethod(SysJobVo SysJobVo, TaskParam taskParam) throws Exception {
        TaskParam invokeTargetJson = taskParam;
        String name = invokeTargetJson.getName();
        String value = invokeTargetJson.getValue();
        JSONObject commandParam = invokeTargetJson.getCommandParam();
        if (!isValidClassName(name)) {
            Object bean = SpringUtils.getBean(name);
            invokeMethod(bean, value, commandParam);
        } else {
            Object bean = Class.forName(name).getDeclaredConstructor().newInstance();
            invokeMethod(bean, value, commandParam);
        }
    }

    /**
     * 调用任务方法
     *
     * @param bean         目标对象
     * @param methodName   方法名称
     * @param methodParams 方法参数
     */
    private static void invokeMethod(Object bean, String methodName, JSONObject methodParams) throws NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
        Method method = bean.getClass().getMethod(methodName, JSONObject.class);
        method.invoke(bean, methodParams/*methodParams*/);
    }

    /**
     * 校验是否为为class包名
     *
     * @param invokeTarget 名称
     * @return true是 false否
     */
    public static boolean isValidClassName(String invokeTarget) {
        return StringUtils.countMatches(invokeTarget, ".") > 1;
    }

    /**
     * 获取参数值
     *
     * @param methodParams 参数相关列表
     * @return 参数值列表
     */
    public static Object[] getMethodParamsValue(List<Object> methodParams) {
        Object[] objects = new Object[methodParams.size()];
        int index = 0;
        for (Object os : methodParams) {
            objects[index] = (Object) os;
            index++;
        }
        return objects;
    }
}
