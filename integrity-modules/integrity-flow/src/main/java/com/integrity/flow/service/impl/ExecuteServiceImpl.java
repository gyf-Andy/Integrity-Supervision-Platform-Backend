package com.integrity.flow.service.impl;

import com.integrity.flow.mapper.WarmFlowMapper;
import com.integrity.flow.service.ExecuteService;
import com.integrity.flow.vo.FlowTaskVo;
import lombok.RequiredArgsConstructor;
import org.dromara.warm.flow.core.entity.HisTask;
import org.dromara.warm.flow.core.entity.Task;
import org.dromara.warm.flow.orm.entity.FlowHisTask;
import org.dromara.warm.flow.orm.entity.FlowTask;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

/**
 * 流程执行SERVICEIMPL
 *
 * @author WARM
 * @since 2023/5/29 13:09
 */
@Service
@RequiredArgsConstructor
public class ExecuteServiceImpl implements ExecuteService {

    private final WarmFlowMapper flowMapper;

    @Override
    public List<FlowTaskVo> toDoPage(Task task) {
        return flowMapper.toDoPage(task);
    }

    @Override
    public List<FlowHisTask> donePage(HisTask hisTask) {
        return flowMapper.donePage(hisTask);
    }

    @Override
    public List<FlowHisTask> copyPage(FlowTask flowTask, Set<String> remoteUserIdSet) {
        return flowMapper.copyPage(flowTask, remoteUserIdSet);
    }
}
