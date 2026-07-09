package com.integrity.flow.service;


import com.integrity.system.api.model.WarmFlowInteractiveTypeVo;

/**
 * 流程定义service
 *
 * @author warm
 * @since 2023/5/29 13:09
 */
public interface HhDefService {

    Boolean interactiveType(WarmFlowInteractiveTypeVo warmFlowInteractiveTypeVo);
}
