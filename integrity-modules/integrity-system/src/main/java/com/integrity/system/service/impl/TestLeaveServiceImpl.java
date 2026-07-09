package com.integrity.system.service.impl;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.integrity.common.core.constant.SecurityConstants;
import com.integrity.common.core.domain.R;
import com.integrity.common.core.exception.ServiceException;
import com.integrity.common.core.utils.DateUtils;
import com.integrity.common.core.utils.StringUtils;
import com.integrity.common.redis.service.IdGeneratorService;
import com.integrity.common.security.utils.SecurityUtils;
import com.integrity.system.api.RemoteFlowService;
import com.integrity.system.api.domain.SysDictData;
import com.integrity.system.api.domain.SysRole;
import com.integrity.system.api.domain.TestLeave;
import com.integrity.system.api.model.LoginUser;
import com.integrity.system.api.model.WarmFlowSkipByInsIdVo;
import com.integrity.system.api.model.WarmFlowSkipVo;
import com.integrity.system.api.model.WarmFlowStartVo;
import com.integrity.system.api.model.WarmFlowTerminationVo;
import com.integrity.system.mapper.TestLeaveMapper;
import com.integrity.system.service.ISysDictTypeService;
import com.integrity.system.service.ITestLeaveService;
import lombok.RequiredArgsConstructor;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.collections4.MapUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * OA 请假申请Service业务层处理
 *
 * @author Integrity-Supervision-Platform
 * @date 2024-03-07
 */
@Service
@RequiredArgsConstructor
public class TestLeaveServiceImpl implements ITestLeaveService {
    private final TestLeaveMapper testLeaveMapper;

    private final RemoteFlowService remoteFlowService;

    private final ISysDictTypeService sysDictTypeService;

    private final IdGeneratorService idGeneratorService;

    /**
     * 查询OA 请假申请
     *
     * @param id OA 请假申请主键
     * @return OA 请假申请
     */
    @Override
    public TestLeave selectTestLeaveById(String id) {
        TestLeave testLeave = testLeaveMapper.selectTestLeaveById(id);
        R<List<String>> permissionResponse = remoteFlowService.getPermission(testLeave.getInstanceId(), SecurityConstants.INNER);
        checkResponse(permissionResponse);
        List<String> permission = permissionResponse.getData();
        if (CollectionUtils.isNotEmpty(permission)) {
            testLeave.setAdditionalHandler(permission);
        } else {
            testLeave.setAdditionalHandler(new ArrayList<>());
        }
        return testLeave;
    }

    /**
     * 查询OA 请假申请列表
     *
     * @param testLeave OA 请假申请
     * @return OA 请假申请
     */
    @Override
    public List<TestLeave> selectTestLeaveList(TestLeave testLeave) {
        return testLeaveMapper.selectTestLeaveList(testLeave);
    }

    /**
     * 新增OA 请假申请
     *
     * @param testLeave OA 请假申请
     * @return 结果
     */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public int insertTestLeave(TestLeave testLeave, String flowStatus) {
        // 设置流转参数
        // String id = IdUtils.nextIdStr();
        String id = idGeneratorService.generateId("TL");
        testLeave.setId(id);
        LoginUser user = SecurityUtils.getLoginUser();
        // 从字典表中获取流程编码
        String flowCode = getFlowType(testLeave);
        WarmFlowStartVo warmFlowStartVo = new WarmFlowStartVo();
        warmFlowStartVo.setId(id);
        warmFlowStartVo.setFlowCode(flowCode);
        warmFlowStartVo.setUserId(user.getUserid());

        // 流程变量
        Map<String, Object> variable = new HashMap<>();
        // 流程变量传递业务数据，按实际业务需求传递 【按需传】
        variable.put("businessData", testLeave);
        variable.put("businessType", "testLeave");
        // 条件表达式替换，判断是否满足某个任务的跳转条件  【按需传】
        variable.put("flag", String.valueOf(testLeave.getDay()));
        // 办理人变量表达式替换  【按需传】
        variable.put("handler1", Arrays.asList(4, "5", 100L));
        variable.put("handler2", 12L);
        variable.put("handler3", new Object[]{9, "10", 102L});
        variable.put("handler4", "15");
        // Task task = FlowFactory.newTask().setId(55L);
        // variable.put("handler5", task);
        variable.put("handler6", 77L);
        warmFlowStartVo.setVariable(variable);
        // 自定义流程状态扩展
        if (StringUtils.isNotEmpty(flowStatus)) {
            warmFlowStartVo.setFlowStatus(flowStatus);
        }

        R<JSONObject> instanceResponse = remoteFlowService.start(warmFlowStartVo, SecurityConstants.INNER);
        checkResponse(instanceResponse);
        JSONObject data = instanceResponse.getData();
        testLeave.setInstanceId(MapUtils.getLong(data, "id")) /*instance.getId())*/;
        testLeave.setNodeCode(MapUtils.getString(data, "nodeCode")) /*instance.getNodeCode())*/;
        testLeave.setNodeName(MapUtils.getString(data, "nodeName")) /*instance.getNodeName())*/;
        testLeave.setNodeType(MapUtils.getInteger(data, "nodeType")) /*instance.getNodeType())*/;
        testLeave.setFlowStatus(MapUtils.getString(data, "flowStatus"))/* instance.getFlowStatus())*/;
        testLeave.setCreateTime(DateUtils.getNowDate());
        // 新增抄送人方法  【按需】
        if (CollectionUtils.isNotEmpty(testLeave.getAdditionalHandler())) {
            R<Boolean> structureUserResponse = remoteFlowService.structureUser(MapUtils.getLong(data, "id"), String.join(",", testLeave.getAdditionalHandler()),
                    SecurityConstants.INNER);
            checkResponse(structureUserResponse);
            // 执行到这里代表抄送成功
        }
        // 此处可以发送消息通知，比如短信通知，邮件通知等，代码自己实现

        return testLeaveMapper.insertTestLeave(testLeave);
    }

    /**
     * 修改OA 请假申请
     *
     * @param testLeave OA 请假申请
     * @return 结果
     */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public int updateTestLeave(TestLeave testLeave) {
        testLeave.setUpdateTime(DateUtils.getNowDate());
        return testLeaveMapper.updateTestLeave(testLeave);
    }

    /**
     * 批量删除OA 请假申请
     *
     * @param ids 需要删除的OA 请假申请主键
     * @return 结果
     */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public int deleteTestLeaveByIds(String[] ids) {
        List<TestLeave> testLeaveList = testLeaveMapper.selectTestLeaveByIds(ids);
        if (testLeaveMapper.deleteTestLeaveByIds(ids) > 0) {
            List<Long> instanceIds = testLeaveList.stream().map(TestLeave::getInstanceId).collect(Collectors.toList());
            R<Boolean> removeFlowResponse = remoteFlowService.remove(instanceIds, SecurityConstants.INNER);
            checkResponse(removeFlowResponse);
            return removeFlowResponse.getData() ? 1 : 0;
        }
        return 0;
    }

    private static void checkResponse(R<?> commonResponse) {
        if (R.FAIL == commonResponse.getCode()) {
            throw new ServiceException(commonResponse.getMsg());
        }
    }

    /**
     * 删除OA 请假申请信息
     *
     * @param id OA 请假申请主键
     * @return 结果
     */
    @Override
    public int deleteTestLeaveById(String id) {
        return testLeaveMapper.deleteTestLeaveById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int submit(String id, String flowStatus) {
        // 设置流转参数
        TestLeave testLeave = testLeaveMapper.selectTestLeaveById(id);
        LoginUser user = SecurityUtils.getLoginUser();
        // 是通过流程还是退回流程  【必传】
        WarmFlowSkipByInsIdVo warmFlowSkipByInsIdVo = new WarmFlowSkipByInsIdVo();
        warmFlowSkipByInsIdVo.setSkipType("PASS");
        warmFlowSkipByInsIdVo.setUserId(user.getUserid());
        warmFlowSkipByInsIdVo.setInstanceId(testLeave.getInstanceId());
        // 设置办理人拥有的权限，办理中需要校验是否有权限办理 【必传】
        List<SysRole> roles = user.getSysUser().getRoles();
        List<String> permissionList = new ArrayList<>();
        if (Objects.nonNull(roles)) {
            permissionList = roles.stream().map(role -> "role:" + role.getRoleId()).collect(Collectors.toList());
        }
        permissionList.add("dept:" + user.getSysUser().getDeptId());
        permissionList.add(user.getUserid());
        warmFlowSkipByInsIdVo.setPermissionFlag(permissionList);
        // 自定义流程状态扩展  【按需传】
        if (StringUtils.isNotEmpty(flowStatus)) {
            warmFlowSkipByInsIdVo.setFlowStatus(flowStatus);
        }
        // 流程变量
        Map<String, Object> variable = new HashMap<>();
        // 流程变量传递业务数据，按实际业务需求传递  【按需传】
        variable.put("businessType", "testLeave");
        // 办理人变量表达式替换  【按需传】
        variable.put("flag", String.valueOf(testLeave.getDay()));
        warmFlowSkipByInsIdVo.setVariable(variable);

        // 更新请假表
        R<JSONObject> skipByInsIdResponse = remoteFlowService.skipByInsId(warmFlowSkipByInsIdVo, SecurityConstants.INNER);
        checkResponse(skipByInsIdResponse);
        JSONObject data = skipByInsIdResponse.getData();
        testLeave.setNodeCode(MapUtils.getString(data, "nodeCode")/*instance.getNodeCode()*/);
        testLeave.setNodeName(MapUtils.getString(data, "nodeName")/*instance.getNodeName()*/);
        testLeave.setNodeType(MapUtils.getInteger(data, "nodeType")/*instance.getNodeType()*/);
        testLeave.setFlowStatus(MapUtils.getString(data, "nodeStatus")/*instance.getFlowStatus()*/);
        testLeave.setUpdateTime(DateUtils.getNowDate());
        return testLeaveMapper.updateTestLeave(testLeave);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int handle(TestLeave testLeave, Long taskId, String skipType, String message, String nodeCode, String flowStatus) {
        // 设置流转参数
        LoginUser user = SecurityUtils.getLoginUser();
        WarmFlowSkipVo warmFlowSkipVo = new WarmFlowSkipVo();
        warmFlowSkipVo.setMessage(message);
        warmFlowSkipVo.setSkipType(skipType);
        warmFlowSkipVo.setUserId(user.getUserid());
        warmFlowSkipVo.setNodeCode(nodeCode);
        // 流程变量
        Map<String, Object> variable = new HashMap<>();
        // 流程变量传递业务数据，按实际业务需求传递  【按需传】
        variable.put("businessType", "testLeave");
        // 办理人变量表达式替换  【按需传】
        variable.put("flag", String.valueOf(testLeave.getDay()));
        warmFlowSkipVo.setVariable(variable);
        // 自定义流程状态扩展  【按需传】
        if (StringUtils.isNotEmpty(flowStatus)) {
            warmFlowSkipVo.setFlowStatus(flowStatus);
            warmFlowSkipVo.setHisStatus(flowStatus);
        }
        // 请假信息存入flowParams,方便查看历史审批数据  【按需传】
        warmFlowSkipVo.setHisTaskExt(JSON.toJSONString(testLeave));
        R<JSONObject> instanceResponse = remoteFlowService.skip(warmFlowSkipVo, SecurityConstants.INNER);
        return updateTestLeave(testLeave, instanceResponse);
    }

    private int updateTestLeave(TestLeave testLeave, R<JSONObject> instanceResponse) {
        checkResponse(instanceResponse);
        JSONObject data = instanceResponse.getData();
        // 更新请假表
        testLeave.setNodeCode(MapUtils.getString(data, "nodeCode"));
        testLeave.setNodeName(MapUtils.getString(data, "nodeName"));
        testLeave.setNodeType(MapUtils.getInteger(data, "nodeType"));
        testLeave.setFlowStatus(MapUtils.getString(data, "flowStatus"));
        return testLeaveMapper.updateTestLeave(testLeave);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int termination(TestLeave testLeave) {
        // 设置流转参数
        WarmFlowTerminationVo warmFlowTerminationVo = new WarmFlowTerminationVo();
        // 设置流转参数
        LoginUser user = SecurityUtils.getLoginUser();
        // 作为审批意见保存到历史记录表  【按需传】
        // 作为办理人保存到历史记录表 【必传】
        warmFlowTerminationVo.setMessage("终止流程");
        warmFlowTerminationVo.setUserId(user.getUserid());

        Map<String, Object> variable = new HashMap<>();
        // 流程变量传递业务数据，按实际业务需求传递  【按需传】
        variable.put("businessType", "testLeave");
        //flowParams.variable(variable);
        warmFlowTerminationVo.setVariable(variable);
        warmFlowTerminationVo.setInstanceId(testLeave.getInstanceId());
        R<JSONObject> terminationResponse = remoteFlowService.termination(warmFlowTerminationVo, SecurityConstants.INNER);
        return updateTestLeave(testLeave, terminationResponse);
    }

    /**
     * 从字典表中获取流程编码
     *
     * @param testLeave 请假信息
     * @return 流程编码
     */
    private String getFlowType(TestLeave testLeave) {
        List<SysDictData> leaveType = sysDictTypeService.selectDictDataByType("leave_type");
        Map<String, String> map = leaveType.stream().collect(Collectors.toMap(SysDictData::getDictValue, SysDictData::getRemark));
        return map.get(testLeave.getType().toString());
    }
}

