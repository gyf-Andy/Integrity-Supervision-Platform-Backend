package com.integrity.flow.controller;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.integrity.common.core.constant.SecurityConstants;
import com.integrity.common.core.domain.R;
import com.integrity.common.core.exception.ServiceException;
import com.integrity.common.core.utils.StringUtils;
import com.integrity.common.core.web.controller.BaseController;
import com.integrity.common.core.web.page.TableDataInfo;
import com.integrity.common.security.annotation.InnerAuth;
import com.integrity.common.security.annotation.RequiresPermissions;
import com.integrity.common.security.utils.SecurityUtils;
import com.integrity.flow.service.ExecuteService;
import com.integrity.flow.service.HhDefService;
import com.integrity.flow.vo.FlowTaskVo;
import com.integrity.system.api.RemoteUserService;
import com.integrity.system.api.domain.SysRole;
import com.integrity.system.api.domain.SysUser;
import com.integrity.system.api.model.LoginUser;
import com.integrity.system.api.model.WarmFlowInteractiveTypeVo;
import com.integrity.system.api.model.WarmFlowSkipByInsIdVo;
import com.integrity.system.api.model.WarmFlowSkipVo;
import com.integrity.system.api.model.WarmFlowStartVo;
import com.integrity.system.api.model.WarmFlowTerminationVo;
import lombok.RequiredArgsConstructor;
import org.apache.commons.collections4.CollectionUtils;
import org.dromara.warm.flow.core.FlowFactory;
import org.dromara.warm.flow.core.dto.FlowParams;
import org.dromara.warm.flow.core.entity.HisTask;
import org.dromara.warm.flow.core.entity.Instance;
import org.dromara.warm.flow.core.entity.Node;
import org.dromara.warm.flow.core.entity.Task;
import org.dromara.warm.flow.core.entity.User;
import org.dromara.warm.flow.core.enums.CooperateType;
import org.dromara.warm.flow.core.enums.SkipType;
import org.dromara.warm.flow.core.enums.UserType;
import org.dromara.warm.flow.core.service.HisTaskService;
import org.dromara.warm.flow.core.service.InsService;
import org.dromara.warm.flow.core.service.NodeService;
import org.dromara.warm.flow.core.service.TaskService;
import org.dromara.warm.flow.core.service.UserService;
import org.dromara.warm.flow.core.utils.StreamUtils;
import org.dromara.warm.flow.orm.entity.FlowHisTask;
import org.dromara.warm.flow.orm.entity.FlowTask;
import org.springframework.beans.BeanUtils;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * 流程实例Controller
 *
 * @author hh
 * @date 2023-04-18
 */
@Validated
@RestController
@RequestMapping("/execute")
@RequiredArgsConstructor
public class ExecuteController extends BaseController {
    private final RemoteUserService remoteUserService;

    private final HisTaskService hisTaskService;

    private final TaskService taskService;

    private final NodeService nodeService;

    private final InsService insService;

    private final UserService flowUserservice;

    private final ExecuteService executeService;

    private final HhDefService hhDefService;

    /**
     * 分页待办任务列表
     */
    @RequiresPermissions("flow:execute:toDoPage")
    @GetMapping("/toDoPage")
    public TableDataInfo toDoPage(FlowTask flowTask) {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        SysUser sysUser = loginUser.getSysUser();
        List<String> permissionList = permissionList(sysUser.getUserId(), sysUser.getDeptId(), sysUser);
        flowTask.setPermissionList(permissionList);
        startPage();
        List<FlowTaskVo> list = executeService.toDoPage(flowTask);
        List<Long> taskIds = StreamUtils.toList(list, FlowTaskVo::getId);
        List<User> userList = flowUserservice.getByAssociateds(taskIds);
        Map<Long, List<User>> map = StreamUtils.groupByKey(userList, User::getAssociated);
        for (FlowTaskVo taskVo : list) {
            if (StringUtils.isNotNull(taskVo)) {
                List<User> users = map.get(taskVo.getId());
                if (CollectionUtils.isNotEmpty(users)) {
                    for (User user : users) {
                        if (UserType.APPROVAL.getKey().equals(user.getType())) {
                            if (StringUtils.isEmpty(taskVo.getApprover())) {
                                taskVo.setApprover("");
                            }
                            String name = getName(user.getProcessedBy());
                            if (StringUtils.isNotEmpty(name))
                                taskVo.setApprover(taskVo.getApprover().concat(name).concat(";"));
                        } else if (UserType.TRANSFER.getKey().equals(user.getType())) {
                            if (StringUtils.isEmpty(taskVo.getTransferredBy())) {
                                taskVo.setTransferredBy("");
                            }
                            String name = getName(user.getProcessedBy());
                            if (StringUtils.isNotEmpty(name))
                                taskVo.setTransferredBy(taskVo.getTransferredBy().concat(name).concat(";"));
                        } else if (UserType.DEPUTE.getKey().equals(user.getType())) {
                            if (StringUtils.isEmpty(taskVo.getDelegate())) {
                                taskVo.setDelegate("");
                            }
                            String name = getName(user.getProcessedBy());
                            if (StringUtils.isNotEmpty(name))
                                taskVo.setDelegate(taskVo.getDelegate().concat(name).concat(";"));
                        }
                    }
                }
            }
        }
        return getDataTable(list);
    }

    /**
     * 分页抄送任务列表
     * author：暗影
     */
    @RequiresPermissions("flow:execute:copyPage")
    @GetMapping("/copyPage")
    public TableDataInfo copyPage(FlowTask flowTask) {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        SysUser sysUser = loginUser.getSysUser();
        List<String> permissionList = permissionList(sysUser.getUserId(), sysUser.getDeptId(), sysUser);
        flowTask.setPermissionList(permissionList);
        //region modify by Liangli, 保证审批系统独立运行，不依赖 sys_user 表
        String flowName = flowTask.getFlowName();
        List<FlowHisTask> list = null;
        if (StringUtils.isBlank(flowName)) {
            startPage();
            list = executeService.copyPage(flowTask, null);
            mappingApprover(list);
        } else {
            WarmFlowInteractiveTypeVo warmFlowInteractiveTypeVo = new WarmFlowInteractiveTypeVo();
            warmFlowInteractiveTypeVo.setNickName(flowName);
            List<SysUser> queryNickNameUsers = remoteUserIdList(warmFlowInteractiveTypeVo);
            Map<String, String> remoteUserMap = StreamUtils.toMap(queryNickNameUsers, user -> String.valueOf(user.getUserId()), SysUser::getNickName);
            Set<String> remoteUserIdSet = remoteUserMap.keySet();
            startPage();
            list = executeService.copyPage(flowTask, remoteUserIdSet);
            mappingApprover(list);
        }
        //endregion
        return getDataTable(list);
    }

    private List<SysUser> remoteUserIdList(WarmFlowInteractiveTypeVo warmFlowInteractiveTypeVo) {
        R<List<SysUser>> remoteFindUserIdListResponse = remoteUserService.findUserIdList(warmFlowInteractiveTypeVo, SecurityConstants.INNER);
        checkResponse(remoteFindUserIdListResponse);
        return remoteFindUserIdListResponse.getData();
    }

    private void mappingApprover(List<FlowHisTask> list) {
        Map<Long, String> flowHisTaskMap = StreamUtils.toMap(list, FlowHisTask::getId, FlowHisTask::getCreateBy);
        Collection<String> createByList = flowHisTaskMap.values();
        WarmFlowInteractiveTypeVo warmFlowInteractiveTypeVo = new WarmFlowInteractiveTypeVo();
        warmFlowInteractiveTypeVo.setQueryType("1");
        warmFlowInteractiveTypeVo.setUserIds(new ArrayList<>(createByList));
        List<SysUser> data = remoteUserIdList(warmFlowInteractiveTypeVo);
        Map<String, String> remoteUserMap = StreamUtils.toMap(data, sysUser -> String.valueOf(sysUser.getUserId()), SysUser::getNickName);
        for (FlowHisTask flowHisTask : list) {
            String nickName = remoteUserMap.get(flowHisTask.getCreateBy());
            flowHisTask.setApprover(StringUtils.isBlank(nickName) ? "未知用户" : nickName);
        }
    }

    /**
     * 分页已办任务列表
     */
    @RequiresPermissions("flow:execute:donePage")
    @GetMapping("/donePage")
    public TableDataInfo donePage(FlowHisTask flowHisTask) {
        startPage();
        LoginUser loginUser = SecurityUtils.getLoginUser();
        SysUser sysUser = loginUser.getSysUser();
        List<String> permissionList = permissionList(sysUser.getUserId(), sysUser.getDeptId(), sysUser);
        flowHisTask.setPermissionList(permissionList);
        List<FlowHisTask> list = executeService.donePage(flowHisTask);
        if (CollectionUtils.isNotEmpty(list)) {
            for (FlowHisTask hisTaskVo : list) {
                if (StringUtils.isNotEmpty(hisTaskVo.getApprover())) {
                    String name = getName(hisTaskVo.getApprover());
                    hisTaskVo.setApprover(name);
                }
                if (StringUtils.isNotEmpty(hisTaskVo.getCollaborator())) {
                    R<String> userNameResponse = remoteUserService.idMappingUserName(hisTaskVo.getCollaborator(), SecurityConstants.INNER);
                    checkResponse(userNameResponse);
                    hisTaskVo.setCollaborator(userNameResponse.getData());
                }
            }
        }
        return getDataTable(list);
    }

    private String getName(String id) {
        if (StringUtils.isNotNull(id)) {
            if (id.contains("dept:")) {
                R<String> deptNameResponse = remoteUserService.idMappingDeptName(id.replace("dept:", ""), SecurityConstants.INNER);
                checkResponse(deptNameResponse);
                if (StringUtils.isNotEmpty(deptNameResponse.getData())) {
                    return "部门:" + deptNameResponse.getData();
                }
            } else if (id.contains("role")) {
                R<String> roleNameResponse = remoteUserService.idMappingRoleName(id.replace("role:", ""), SecurityConstants.INNER);
                checkResponse(roleNameResponse);
                if (StringUtils.isNotEmpty(roleNameResponse.getData())) {
                    return "角色:" + roleNameResponse.getData();
                }
            } else {
                R<String> userNameResponse = remoteUserService.idMappingUserName(id.replace("user:", ""), SecurityConstants.INNER);
                checkResponse(userNameResponse);
                if (StringUtils.isNotEmpty(userNameResponse.getData())) {
                    return "用户:" + userNameResponse.getData();
                }
            }
        }
        return "";
    }

    private static void checkResponse(R<?> commonResponse) {
        if (R.FAIL == commonResponse.getCode()) {
            throw new ServiceException(commonResponse.getMsg());
        }
    }


    /**
     * 查询已办任务历史记录
     */
    @RequiresPermissions("flow:execute:doneList")
    @GetMapping("/doneList/{instanceId}")
    public R<List<FlowHisTask>> doneList(@PathVariable("instanceId") Long instanceId) {
        List<HisTask> flowHisTasks = hisTaskService.orderById().desc().list(new FlowHisTask().setInstanceId(instanceId));
        List<FlowHisTask> flowHisTaskList = new ArrayList<>();
        if (CollectionUtils.isNotEmpty(flowHisTasks)) {
            for (HisTask hisTask : flowHisTasks) {
                if (StringUtils.isNotEmpty(hisTask.getApprover())) {
                    String name = getName(hisTask.getApprover());
                    hisTask.setApprover(name);
                }
                if (StringUtils.isNotEmpty(hisTask.getCollaborator())) {
                    R<String> userNameResponse = remoteUserService.idMappingUserName(hisTask.getCollaborator(), SecurityConstants.INNER);
                    checkResponse(userNameResponse);
                    hisTask.setCollaborator(userNameResponse.getData());
                }
                FlowHisTask flowHisTask = new FlowHisTask();
                BeanUtils.copyProperties(hisTask, flowHisTask);
                flowHisTaskList.add(flowHisTask);
            }
        }
        return R.ok(flowHisTaskList);
    }

    /**
     * 根据taskId查询代表任务
     *
     * @param taskId
     * @return
     */
    @GetMapping("/getTaskById/{taskId}")
    public R<Task> getTaskById(@PathVariable("taskId") Long taskId) {
        return R.ok(taskService.getById(taskId));
    }

    /**
     * 查询跳转任意节点列表
     */
    @RequiresPermissions("flow:execute:doneList")
    @GetMapping("/anyNodeList/{instanceId}")
    public R<List<Node>> anyNodeList(@PathVariable("instanceId") Long instanceId) {
        Instance instance = insService.getById(instanceId);
        List<Node> nodeList = nodeService.list(FlowFactory.newNode().setDefinitionId(instance.getDefinitionId()));
        return R.ok(nodeList);
    }

    /**
     * 处理非办理的流程交互类型
     *
     * @param warmFlowInteractiveTypeVo 要转办用户
     * @return 是否成功
     */
    @PostMapping("/interactiveType")
    public R<Boolean> interactiveType(WarmFlowInteractiveTypeVo warmFlowInteractiveTypeVo) {
        return R.ok(hhDefService.interactiveType(warmFlowInteractiveTypeVo));
    }

    /**
     * 交互类型可以选择的用户
     *
     * @param warmFlowInteractiveTypeVo 交互类型请求类
     * @return 是否成功
     */
    @GetMapping("/interactiveTypeSysUser")
    public TableDataInfo interactiveTypeSysUser(WarmFlowInteractiveTypeVo warmFlowInteractiveTypeVo) {
        startPage();
        LoginUser loginUser = SecurityUtils.getLoginUser();
        SysUser currentUser = loginUser.getSysUser();
        String userId = String.valueOf(currentUser.getUserId());
        Integer operatorType = warmFlowInteractiveTypeVo.getOperatorType();
        List<SysUser> list;
        Long taskId = warmFlowInteractiveTypeVo.getTaskId();
        List<User> users = flowUserservice.listByAssociatedAndTypes(taskId);
        List<String> userIds = StreamUtils.toList(users, User::getProcessedBy);
        warmFlowInteractiveTypeVo.setUserIds(userIds);
        if (!Objects.equals(CooperateType.REDUCTION_SIGNATURE.getKey(), operatorType)) {
            warmFlowInteractiveTypeVo.setQueryType("2");
            list = remoteUserIdList(warmFlowInteractiveTypeVo);
        } else {
            warmFlowInteractiveTypeVo.setQueryType("1");
            list = remoteUserIdList(warmFlowInteractiveTypeVo);
            list = StreamUtils.filter(list, sysUser -> !Objects.equals(userId, String.valueOf(sysUser.getUserId())));
        }
        return getDataTable(list);
    }

    /**
     * 激活流程
     *
     * @param instanceId
     * @return
     */
    @GetMapping("/active/{instanceId}")
    public R<Boolean> active(@PathVariable("instanceId") Long instanceId) {
        return R.ok(insService.active(instanceId));
    }

    /**
     * 挂起流程
     *
     * @param instanceId
     * @return
     */
    @GetMapping("/unActive/{instanceId}")
    public R<Boolean> unActive(@PathVariable("instanceId") Long instanceId) {
        return R.ok(insService.unActive(instanceId));
    }

    /**
     * 获取权限
     *
     * @param userId  用户编号
     * @param deptId  部门编号
     * @param sysUser 登陆用户
     * @return 权限列表
     */
    private List<String> permissionList(String userId, String deptId, SysUser sysUser) {
        List<SysRole> roles = sysUser.getRoles();
        List<String> permissionList = new ArrayList<>();
        if (CollectionUtils.isNotEmpty(roles)) {
            permissionList = StreamUtils.toList(roles, role -> "role:" + role.getRoleId());
        }
        permissionList.add(userId);
        if (Objects.nonNull(deptId)) {
            permissionList.add("dept:" + deptId);
        }
        logger.info("当前用户所有权限[{}]", permissionList);
        return permissionList;
    }

    /**
     * 根据ID反显姓名
     *
     * @param ids 需要反显姓名的用户ID
     * @return {@link R<List<SysUser>>}
     * @author liangli
     * @date 2024/12/14 10:05
     **/
    @RequiresPermissions("flow:definition:query")
    @GetMapping(value = "/idReverseDisplayName/{ids}")
    public R<List<SysUser>> idReverseDisplayName(@PathVariable List<String> ids) {
        if (CollectionUtils.isEmpty(ids)) {
            return R.fail("传输后端为空，查询失败");
        }
        WarmFlowInteractiveTypeVo warmFlowInteractiveTypeVo = new WarmFlowInteractiveTypeVo();
        warmFlowInteractiveTypeVo.setQueryType("1");
        warmFlowInteractiveTypeVo.setUserIds(ids);
        return R.ok(remoteUserIdList(warmFlowInteractiveTypeVo));
    }

    /**
     * 获取流程权限
     *
     * @param instanceId 实例ID
     */
    @InnerAuth
    @GetMapping("/getPermission/{instanceId}")
    public R<List<String>> getPermission(@PathVariable("instanceId") Long instanceId) {
        return R.ok(flowUserservice.getPermission(instanceId, "4"));
    }

    /**
     * 删除流程实例
     *
     * @param instanceIds 实例ID
     */
    @InnerAuth
    @DeleteMapping("/remove/{instanceIds}")
    public R<Boolean> remove(@PathVariable("instanceIds") List<Long> instanceIds) {
        return R.ok(insService.remove(instanceIds));
    }

    /**
     * 办理流程
     *
     * @param warmFlowSkipVo 办理流程vo类
     */
    @InnerAuth
    @PostMapping("/skip")
    public R<JSONObject> skip(@RequestBody WarmFlowSkipVo warmFlowSkipVo) {
        // 是通过流程还是退回流程 【必传】
        FlowParams flowParams = FlowParams.build().skipType(warmFlowSkipVo.getSkipType());
        // 作为办理人保存到历史记录表 【必传】
        flowParams.handler(warmFlowSkipVo.getUserId());
        // 如果需要任意跳转流程，传入此参数  【按需传】
        flowParams.nodeCode(warmFlowSkipVo.getNodeCode());
        // 作为审批意见保存到历史记录表  【按需传】
        flowParams.message(warmFlowSkipVo.getMessage());

        flowParams.variable(warmFlowSkipVo.getVariable());
        // 自定义流程状态扩展  【按需传】
        if (StringUtils.isNotEmpty(warmFlowSkipVo.getFlowStatus())) {
            flowParams.flowStatus(warmFlowSkipVo.getFlowStatus()).hisStatus(warmFlowSkipVo.getHisStatus());
        }
        // 请假信息存入flowParams,方便查看历史审批数据  【按需传】
        flowParams.hisTaskExt(warmFlowSkipVo.getHisTaskExt());
        try {
            Instance skip = taskService.skip(warmFlowSkipVo.getTaskId(), flowParams);
            return R.ok(JSON.parseObject(JSON.toJSONString(skip)));
        } catch (Exception e) {
            return R.fail("审批系统办理失败");
        }
    }

    /**
     * 启动流程
     *
     * @param warmFlowStartVo 启动流程vo类
     */
    @InnerAuth
    @PostMapping("/start")
    public R<JSONObject> start(@RequestBody WarmFlowStartVo warmFlowStartVo) {
        // 传递流程编码，绑定流程定义 【必传】
        FlowParams flowParams = FlowParams.build().flowCode(warmFlowStartVo.getFlowCode());
        // 设置办理人唯一标识，保存为流程实例的创建人 【必传】
        flowParams.handler(warmFlowStartVo.getUserId());
        // 流程变量
        flowParams.variable(warmFlowStartVo.getVariable());
        String flowStatus = warmFlowStartVo.getFlowStatus();
        // 自定义流程状态扩展
        if (StringUtils.isNotEmpty(flowStatus)) {
            flowParams.flowStatus(flowStatus).hisStatus(flowStatus);
        }
        try {
            Instance skip = insService.start(warmFlowStartVo.getId(), flowParams);
            return R.ok(JSON.parseObject(JSON.toJSONString(skip)));
        } catch (Exception e) {
            return R.fail("审批系统办理失败");
        }
    }

    /**
     * 抄送用户
     *
     * @param id
     * @param additionalHandler
     * @return {@link R< JSONObject>}
     * @author liangli
     * @date 2024/12/14 17:01
     **/
    @InnerAuth
    @GetMapping("/structureUser/{id}/{additionalHandler}")
    public R<Boolean> structureUser(@PathVariable("id") Long id,
                                    @PathVariable(name = "additionalHandler", required = false) String additionalHandler) {
        try {
            List<String> handlers = StringUtils.isEmpty(additionalHandler) ? new ArrayList<>() : Arrays.asList(additionalHandler.split(","));
            List<User> users = flowUserservice.structureUser(id, handlers, "4");
            FlowFactory.userService().saveBatch(users);
            return R.ok(true);
        } catch (Exception e) {
            return R.fail("审批系统办理失败");
        }
    }

    /**
     * 提交审批
     *
     * @param warmFlowSkipByInsIdVo 提交审批VO类
     * @return {@link R< JSONObject>}
     * @author liangli
     * @date 2024/12/14 17:14
     **/
    @InnerAuth
    @PostMapping("/skipByInsId")
    public R<JSONObject> skipByInsId(@RequestBody WarmFlowSkipByInsIdVo warmFlowSkipByInsIdVo) {
        try {
            FlowParams flowParams = FlowParams.build().skipType(SkipType.PASS.getKey());
            // 作为办理人保存到历史记录表 【必传】
            flowParams.handler(warmFlowSkipByInsIdVo.getUserId());
            // 设置办理人拥有的权限，办理中需要校验是否有权限办理 【必传】
            flowParams.permissionFlag(warmFlowSkipByInsIdVo.getPermissionFlag());
            // 自定义流程状态扩展  【按需传】
            String flowStatus = warmFlowSkipByInsIdVo.getFlowStatus();
            if (StringUtils.isNotEmpty(flowStatus)) {
                flowParams.flowStatus(flowStatus).hisStatus(flowStatus);
            }
            flowParams.variable(warmFlowSkipByInsIdVo.getVariable());

            // 更新请假表
            Instance instance = insService.skipByInsId(warmFlowSkipByInsIdVo.getInstanceId(), flowParams);
            return R.ok(JSON.parseObject(JSON.toJSONString(instance)));
        } catch (Exception e) {
            return R.fail("审批系统办理失败");
        }
    }

    /**
     * 终止审批
     *
     * @param warmFlowTerminationVo 终止审批VO类
     * @return {@link R< JSONObject>}
     * @author liangli
     * @date 2024/12/14 17:14
     **/
    @InnerAuth
    @PostMapping("/termination")
    public R<JSONObject> termination(@RequestBody WarmFlowTerminationVo warmFlowTerminationVo) {
        try {
            FlowParams flowParams = new FlowParams();
            // 作为审批意见保存到历史记录表  【按需传】
            flowParams.message(warmFlowTerminationVo.getMessage());
            // 作为办理人保存到历史记录表 【必传】
            flowParams.handler(warmFlowTerminationVo.getUserId());
            // 流程变量传递业务数据，按实际业务需求传递  【按需传】
            flowParams.variable(warmFlowTerminationVo.getVariable());

            Instance instance = insService.termination(warmFlowTerminationVo.getInstanceId(), flowParams);
            if (instance == null) {
                R.fail("流程实例不存在");
            }
            return R.ok(JSON.parseObject(JSON.toJSONString(instance)));
        } catch (Exception e) {
            return R.fail(e.getMessage());
        }
    }
}
