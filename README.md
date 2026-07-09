# 廉政监管平台后端

Integrity-Supervision-Platform Backend

## 项目概述

廉政监管平台后端是基于 Spring Cloud 微服务架构的监管业务系统，提供认证授权、系统管理、监督流程、定时任务、文件服务、监控中心和网关路由等微服务能力，支撑廉政风险监管、线索处置、整改闭环和监督留痕等业务场景。

核心特性：

- **微服务架构**：Spring Cloud Gateway 统一入口，Nacos 注册中心与配置中心，OpenFeign 远程调用
- **认证授权**：Spring Security + JWT 无状态认证，RBAC 权限模型，数据权限隔离
- **工作流引擎**：基于 Warm Flow 实现审批流程、线索处置、整改闭环
- **分布式能力**：Seata 分布式事务，Redis 缓存，MinIO/FastDFS 文件存储
- **服务治理**：Sentinel 流量控制，Spring Boot Admin 监控，Druid 连接池

## 技术栈

| 分类 | 技术 | 版本 |
|------|------|------|
| **语言** | Java | 17 |
| **基础框架** | Spring Boot | 3.3.5 |
| **微服务** | Spring Cloud | 2023.0.3 |
| **微服务** | Spring Cloud Alibaba | 2023.0.1.2 |
| **注册/配置** | Nacos | 3.2.2+ |
| **网关** | Spring Cloud Gateway | — |
| **认证** | Spring Security + JWT (jjwt) | 0.9.1 |
| **远程调用** | OpenFeign + LoadBalancer | — |
| **流量控制** | Sentinel | — |
| **ORM** | MyBatis (mybatis-spring) | 3.0.3 |
| **连接池** | Druid | 1.2.23 |
| **多数据源** | Dynamic-Datasource | 4.3.1 |
| **分页** | PageHelper | 2.1.0 |
| **数据库** | MySQL | — |
| **缓存** | Redis | — |
| **分布式事务** | Seata | — |
| **文件存储** | MinIO | 8.2.2 |
| **文件存储(备)** | FastDFS Client | 1.27.2 |
| **工作流** | Warm Flow | 1.3.4 |
| **监控** | Spring Boot Admin | 3.3.5 |
| **API 文档** | SpringDoc (OpenAPI) | 2.6.0 |
| **模板引擎** | Apache Velocity | 2.3 |
| **Excel** | Apache POI | 4.1.2 |
| **JSON** | FastJSON2 | 2.0.53 |
| **验证码** | Kaptcha | 2.3.3 |
| **配置加密** | Jasypt | 3.0.5 |
| **SM4 加密** | BouncyCastle | 1.78.1 |
| **线程传递** | Transmittable-Thread-Local | 2.14.4 |
| **工具** | Lombok | 1.18.36 |
| **工具** | Commons IO | 2.13.0 |
| **工具** | Commons Exec | 1.3 |

## 代码结构

```text
Integrity-Supervision-Platform
├── integrity-gateway/                          # 网关模块
│   └── src/main/java/com/integrity/gateway/    # Spring Cloud Gateway 路由、过滤器、限流
├── integrity-auth/                             # 认证授权中心
│   └── src/main/java/com/integrity/auth/       # 登录认证、Token 管理、用户注册
├── integrity-api/                              # 服务接口模块（Feign 远程调用接口）
│   ├── integrity-api-system/                   # 系统管理远程接口：用户/角色/菜单/部门/日志
│   └── integrity-api-flow/                     # 工作流远程接口
├── integrity-common/                           # 通用能力模块
│   ├── integrity-common-core/                  # 核心工具：基础实体、异常处理、工具类、Feign 配置
│   ├── integrity-common-security/              # 安全模块：鉴权注解、Token 校验、登录用户获取
│   ├── integrity-common-redis/                 # Redis 缓存：分布式锁、缓存注解、序列化
│   ├── integrity-common-log/                   # 日志记录：操作日志 AOP、登录日志收集
│   ├── integrity-common-swagger/               # API 文档：SpringDoc 自动聚合、Knife4j 增强
│   ├── integrity-common-datasource/            # 多数据源：Druid + Dynamic-Datasource 动态切换
│   ├── integrity-common-datascope/             # 数据权限：数据范围注解、部门权限过滤
│   ├── integrity-common-sensitive/             # 数据脱敏：敏感字段自动脱敏注解
│   ├── integrity-common-seata/                 # 分布式事务：Seata AT 模式集成
│   └── integrity-common-encrypt/               # 配置加密：Jasypt 加密 + SM4 国密算法
├── integrity-modules/                          # 业务模块
│   ├── integrity-system/                       # 系统管理：用户/角色/菜单/部门/岗位/字典/参数/日志管理
│   ├── integrity-flow/                         # 监督流程：Warm Flow 工作流定义、流程实例、审批任务
│   ├── integrity-job/                          # 定时任务：Quartz 任务调度、Cron 管理、执行日志
│   ├── integrity-file/                         # 文件服务：MinIO/FastDFS 文件上传下载、切片上传
│   └── integrity-gen/                          # 代码生成：Velocity 模板、数据表逆向生成 CRUD 代码
├── integrity-visual/                           # 可视化监控模块
│   └── integrity-monitor/                      # 服务监控：Spring Boot Admin 健康检查、指标监控
├── sql/                                        # 数据库初始化脚本
│   ├── integrity-cloud.sql                     # 核心业务库 DDL + 初始数据
│   ├── integrity-cloud-flow.sql                # 工作流库 DDL
│   ├── integrity-config.sql                    # Nacos 配置中心数据
│   └── integrity-seata.sql                     # Seata 分布式事务 UNDO_LOG 表
├── bin/                                        # 启动脚本
│   ├── package.bat / clean.bat                 # 打包与清理
│   ├── run-gateway.bat                         # 网关启动
│   ├── run-auth.bat                            # 认证中心启动
│   ├── run-modules-system.bat                  # 系统管理启动
│   ├── run-modules-gen.bat                     # 代码生成启动
│   ├── run-modules-job.bat                     # 定时任务启动
│   ├── run-modules-file.bat                    # 文件服务启动
│   └── run-monitor.bat                         # 监控中心启动
├── docker/                                     # Docker 容器化部署
│   ├── docker-compose.yml                      # 编排文件
│   ├── deploy.sh / copy.sh                     # 部署与镜像拷贝脚本
│   ├── integrity/                              # 各模块 Dockerfile
│   ├── mysql/                                  # MySQL 容器
│   ├── nacos/                                  # Nacos 容器
│   ├── nginx/                                  # Nginx 前端容器
│   └── redis/                                  # Redis 容器
└── script/                                     # 运维脚本
    ├── python_example.py                       # Python 示例
    └── shell_example.sh                        # Shell 示例
```

## 模块职责

### 基础设施层

| 模块 | 职责 |
|------|------|
| `integrity-gateway` | API 统一入口，路由转发、权限校验、限流熔断、跨域处理 |
| `integrity-auth` | 登录/登出、Token 签发与刷新、验证码生成、用户注册 |

### 通用能力层 (`integrity-common`)

| 模块 | 职责 |
|------|------|
| `integrity-common-core` | 基础实体封装、全局异常处理、通用工具类、Feign 拦截器 |
| `integrity-common-security` | Spring Security 鉴权集成、`@PreAuthorize` 注解支持、登录用户上下文 |
| `integrity-common-redis` | Redis 配置与工具类、分布式锁、缓存注解、发布订阅 |
| `integrity-common-log` | 操作日志 AOP 切面、登录日志事件监听 |
| `integrity-common-swagger` | SpringDoc + Knife4j 接口文档聚合、微服务文档路由 |
| `integrity-common-datasource` | Druid 连接池配置、Dynamic-Datasource 多数据源注解切换 |
| `integrity-common-datascope` | 数据权限 SQL 片段注入、按部门/角色过滤数据范围 |
| `integrity-common-sensitive` | 敏感字段脱敏注解（手机号/身份证/银行卡等） |
| `integrity-common-seata` | Seata AT 模式自动配置、全局事务 XID 传递 |
| `integrity-common-encrypt` | 数据库连接密码加密、SM4 国密算法加解密 |

### 远程接口层 (`integrity-api`)

| 模块 | 职责 |
|------|------|
| `integrity-api-system` | 系统管理 Feign 接口定义（RemoteUserService、RemoteLogService 等） |
| `integrity-api-flow` | 工作流 Feign 接口定义 |

### 业务服务层 (`integrity-modules`)

| 模块 | 职责 |
|------|------|
| `integrity-system` | 用户管理、角色管理、菜单管理、部门管理、岗位管理、字典管理、参数配置、操作日志、登录日志、通知公告 |
| `integrity-flow` | 流程定义、流程实例、审批任务、审批历史、流程参数配置 |
| `integrity-job` | 定时任务 CRUD、Cron 表达式管理、任务执行日志、并发控制 |
| `integrity-file` | 文件上传/下载/预览、切片上传、MinIO/FastDFS 适配、文件分类管理 |
| `integrity-gen` | 数据库表导入、Velocity 模板渲染、一键生成 Controller/Service/Mapper/Entity/Vue 页面代码 |

### 监控运营层 (`integrity-visual`)

| 模块 | 职责 |
|------|------|
| `integrity-monitor` | Spring Boot Admin 服务端，实例上下线通知、JVM 指标、日志查看、Wallboard |

## 架构图

```text
                    ┌─────────────────────────────────────┐
                    │            Nginx / 前端              │
                    └────────────────┬────────────────────┘
                                     │
                    ┌────────────────▼────────────────────┐
                    │        Integrity Gateway             │
                    │   (路由 / 限流 / 鉴权 / 熔断)         │
                    └────────┬───────┬───────┬────────────┘
                             │       │       │
              ┌──────────────▼┐ ┌───▼───┐ ┌─▼──────────────┐
              │ Integrity-Auth│ │ ...   │ │ Integrity-*    │
              │   (认证中心)   │ │       │ │  (业务模块)     │
              └──────┬────────┘ └───────┘ └──────┬─────────┘
                     │                            │
       ┌─────────────┼────────────┬───────────────┼───────────┐
       │             │            │               │           │
  ┌────▼────┐  ┌─────▼────┐ ┌────▼────┐  ┌───────▼──┐  ┌─────▼────┐
  │  Nacos  │  │ Sentinel │ │  MySQL  │  │  Redis   │  │  MinIO   │
  │注册/配置│  │  流量控制 │ │  数据库  │  │   缓存   │  │ 文件存储  │
  └─────────┘  └──────────┘ └─────────┘  └──────────┘  └──────────┘
```

## 初始化

### 环境要求

| 组件 | 推荐版本 | 用途 |
|------|----------|------|
| JDK | 17 | Java 运行时 |
| Maven | 3.8+ | 项目构建 |
| MySQL | 8.0+ | 业务数据库 |
| Redis | 7.0+ | 缓存与分布式锁 |
| Nacos | 3.2.2+ | 注册中心 + 配置中心 |
| Sentinel | 1.8+ | 流量控制（可选） |
| MinIO | latest | 文件存储（可选） |

### 数据库初始化

1. 创建数据库并导入 SQL：

```sql
-- 依次执行 sql/ 目录下的脚本
source sql/integrity-cloud.sql;       -- 核心业务库
source sql/integrity-cloud-flow.sql;  -- 工作流库（可选）
source sql/integrity-seata.sql;       -- Seata 库（可选）
```

2. Nacos 配置初始化：将 `sql/integrity-config.sql` 导入 Nacos 连接的数据库（默认库名 `integrity-config`）。

3. 根据本地环境调整每个模块 `bootstrap.yml` 中的 MySQL、Redis、Nacos 地址。

### 本地启动

按以下顺序启动：

1. **基础设施**：Nacos → MySQL → Redis → Sentinel（可选）
2. **网关与认证**：`integrity-gateway` → `integrity-auth`
3. **核心业务**：`integrity-modules/integrity-system`
4. **其他模块**：`integrity-flow` → `integrity-job` → `integrity-file` → `integrity-gen` → `integrity-monitor`

Windows 下可直接使用 `bin/` 目录中的 `run-*.bat` 脚本启动对应模块。

## 品牌信息

- 中文名：廉政监管平台
- 英文名：Integrity-Supervision-Platform
- Maven GroupId：`com.integrity`
- 服务注册名前缀：`integrity-*`

---

> 说明：当前代码已完成 Maven 坐标、服务注册名、Nacos dataId 和 Java 包名的 Integrity 命名迁移；如果已有旧环境数据，请同步迁移 Nacos 配置和数据库连接信息。
