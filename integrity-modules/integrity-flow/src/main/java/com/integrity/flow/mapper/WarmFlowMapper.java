package com.integrity.flow.mapper;

import com.integrity.flow.vo.FlowTaskVo;
import org.apache.ibatis.annotations.Param;
import org.dromara.warm.flow.core.entity.HisTask;
import org.dromara.warm.flow.core.entity.Task;
import org.dromara.warm.flow.orm.entity.FlowHisTask;
import org.dromara.warm.flow.orm.entity.FlowTask;

import java.util.List;
import java.util.Set;

/**
 * warm-flow工作流Mapper接口
 *
 * @author Integrity-Supervision-Platform
 * @date 2024-03-07
 */
public interface WarmFlowMapper {
    /**
     * 分页查询待办任务
     *
     * @param task 条件实体
     */
    List<FlowTaskVo> toDoPage(@Param("task") Task task);

    /**
     * 获取最新的已办任务
     *
     * @param hisTask
     * @return
     */
    List<FlowHisTask> donePage(@Param("hisTask") HisTask hisTask);

    /**
     * 分页获取抄送任务
     *
     * @param flowTask
     * @param remoteUserIdSet
     * @return
     */
    List<FlowHisTask> copyPage(@Param("task") FlowTask flowTask,
                               @Param("remoteUserIdSet") Set<String> remoteUserIdSet);
}

