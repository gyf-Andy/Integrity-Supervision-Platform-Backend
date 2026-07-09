package com.integrity.common.core.constant;

/**
 * 权限相关通用常量
 * 
 * @author Integrity-Supervision-Platform
 */
public class SecurityConstants
{
    /**
     * 用户ID字段
     */
    public static final String DETAILS_USER_ID = "user_id";

    /**
     * 超级管理员用户ID
     */
    public static final String SUPER_ADMIN_USER_ID = "ADMIN001";

    /**
     * 历史超级管理员用户ID，仅用于兼容迁移前的旧数据。
     * 待所有环境超级管理员用户ID统一为 {@link #SUPER_ADMIN_USER_ID} 后可移除。
     */
    public static final String LEGACY_SUPER_ADMIN_USER_ID = "1";

    /**
     * 用户名字段
     */
    public static final String DETAILS_USERNAME = "username";

    /**
     * 授权信息字段
     */
    public static final String AUTHORIZATION_HEADER = "Authorization";

    /**
     * 请求来源
     */
    public static final String FROM_SOURCE = "from-source";

    /**
     * 内部请求
     */
    public static final String INNER = "inner";

    /**
     * 用户标识
     */
    public static final String USER_KEY = "user_key";

    /**
     * 登录用户
     */
    public static final String LOGIN_USER = "login_user";

    /**
     * 角色权限
     */
    public static final String ROLE_PERMISSION = "role_permission";
}


