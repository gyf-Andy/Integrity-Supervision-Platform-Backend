package com.integrity.flow.service;

import com.integrity.flow.vo.FlowTaskVo;
import org.dromara.warm.flow.core.entity.HisTask;
import org.dromara.warm.flow.core.entity.Task;
import org.dromara.warm.flow.orm.entity.FlowHisTask;
import org.dromara.warm.flow.orm.entity.FlowTask;

import java.util.List;
import java.util.Set;

/**
 * 流程执行service
 *
 * @author warm
 * @since 2023/5/29 13:09
 */
public interface ExecuteService {

    /**
     * 分页查询待办任务
     *
     * @param task 条件实体
     * @return
     */
    List<FlowTaskVo> toDoPage(Task task);

    /**
     * 获取已办任务
     *
     * @param hisTask
     * @return
     */
    List<FlowHisTask > donePage(HisTask hisTask);

    List<FlowHisTask > copyPage(FlowTask flowTask, Set<String> remoteUserIdSet);
}
