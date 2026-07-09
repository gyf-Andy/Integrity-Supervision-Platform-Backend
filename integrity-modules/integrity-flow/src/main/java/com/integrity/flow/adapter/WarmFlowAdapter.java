package com.integrity.flow.adapter;


import com.integrity.system.api.model.WarmFlowInteractiveTypeVo;

public interface WarmFlowAdapter {
    boolean isAdapter(Integer warmFlowType);

    boolean adapter(WarmFlowInteractiveTypeVo obj);
}
