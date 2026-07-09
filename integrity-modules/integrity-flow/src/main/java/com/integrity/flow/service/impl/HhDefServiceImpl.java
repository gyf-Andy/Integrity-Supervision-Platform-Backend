package com.integrity.flow.service.impl;

import com.integrity.flow.adapter.WarmFlowAdapter;
import com.integrity.flow.service.HhDefService;
import com.integrity.system.api.model.WarmFlowInteractiveTypeVo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 流程定义serviceImpl
 *
 * @author warm
 * @since 2023/5/29 13:09
 */
@Service
@RequiredArgsConstructor
public class HhDefServiceImpl implements HhDefService {
    /*
    private final DefService defService;

    private final NodeService nodeService;

    private final SkipService skipService;*/

    private final List<WarmFlowAdapter> warmFlowAdapters;

    @Transactional(rollbackFor = Exception.class)
    @Override
    public Boolean interactiveType(WarmFlowInteractiveTypeVo warmFlowInteractiveTypeVo) {
        Integer operatorType = warmFlowInteractiveTypeVo.getOperatorType();
        for (WarmFlowAdapter warmFlowAdapter : warmFlowAdapters) {
            if (warmFlowAdapter.isAdapter(operatorType)) {
                return warmFlowAdapter.adapter(warmFlowInteractiveTypeVo);
            }
        }
        return false;
    }
}
