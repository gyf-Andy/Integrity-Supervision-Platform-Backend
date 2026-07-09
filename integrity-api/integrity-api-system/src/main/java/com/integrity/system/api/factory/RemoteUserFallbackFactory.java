package com.integrity.system.api.factory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;
import com.integrity.common.core.domain.R;
import com.integrity.system.api.RemoteUserService;
import com.integrity.system.api.domain.SysUser;
import com.integrity.system.api.model.LoginUser;
import com.integrity.system.api.model.WarmFlowInteractiveTypeVo;

import java.util.List;

/**
 * 用户服务降级处理
 * 
 * @author Integrity-Supervision-Platform
 */
@Component
public class RemoteUserFallbackFactory implements FallbackFactory<RemoteUserService>
{
    private static final Logger log = LoggerFactory.getLogger(RemoteUserFallbackFactory.class);

    @Override
    public RemoteUserService create(Throwable throwable)
    {
        log.error("用户服务调用失败:{}", throwable.getMessage());
        return new RemoteUserService()
        {
            @Override
            public R<LoginUser> getUserInfo(String username, String source)
            {
                return R.fail("获取用户失败:" + throwable.getMessage());
            }

            @Override
            public R<Boolean> registerUserInfo(SysUser sysUser, String source)
            {
                return R.fail("注册用户失败:" + throwable.getMessage());
            }

            @Override
            public R<Boolean> recordUserLogin(SysUser sysUser, String source)
            {
                return R.fail("记录用户登录信息失败:" + throwable.getMessage());
            }

            @Override
            public R<String> idMappingUserName(String userId, String source)
            {
                return R.fail("查询用户名称失败:" + throwable.getMessage());
            }

            @Override
            public R<String> idMappingDeptName(String deptId, String source)
            {
                return R.fail("查询部门名称失败:" + throwable.getMessage());
            }

            @Override
            public R<String> idMappingRoleName(String roleId, String source)
            {
                return R.fail("查询角色名称失败:" + throwable.getMessage());
            }

            @Override
            public R<List<SysUser>> findUserIdList(WarmFlowInteractiveTypeVo warmFlowInteractiveTypeVo, String source)
            {
                return R.fail("WarmFlow查询工作流所需用户失败:" + throwable.getMessage());
            }
        };
    }
}

