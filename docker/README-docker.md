# 廉政监管平台后端 - 架构与 Docker 部署说明

本文档对廉政监管平台后端的系统整体架构、微服务模块划分以及 Docker 容器化部署方案进行详细归纳与说明，以便于日常开发、运维与内网环境部署。

---

## 一、 系统架构与模块划分

项目采用 **Spring Cloud** 微服务架构，以 `integrity-` 作为服务命名前缀。

### 1. 基础设施与网关
*   **网关服务 (`integrity-gateway`)**：API 统一入口，负责路由转发、权限校验、Sentinel 限流与跨域处理。
*   **认证中心 (`integrity-auth`)**：负责用户登录、Token 签发与刷新、验证码生成以及安全上下文校验。

### 2. 业务服务层 (`integrity-modules`)
*   **系统服务 (`integrity-system`)**：提供用户、角色、菜单、部门、岗位、参数、字典等基础数据管理。
*   **工作流服务 (`integrity-flow`)**：基于 **Warm Flow** 工作流引擎，实现审批流、线索处置以及整改闭环等核心业务。
*   **任务调度服务 (`integrity-job`)**：基于 Quartz 提供分布式定时任务的 CRUD 及 Cron 管理。
*   **文件服务 (`integrity-file`)**：支持 MinIO / FastDFS 文件上传下载及切片上传。
*   **代码生成服务 (`integrity-gen`)**：支持 Velocity 模板的代码生成，实现逆向工程。

### 3. 公共组件库 (`integrity-common`)
提供微服务通用的切面、安全过滤、多数据源及加解密能力，包含核心工具类 (`core`)、安全鉴权 (`security`)、日志切面 (`log`)、多数据源切换 (`datasource`)、数据权限过滤 (`datascope`)、敏感字段脱敏 (`sensitive`) 以及国密/数据库密码加解密 (`encrypt`) 等。

---

## 二、 Docker 部署架构设计

本项目的 Docker 部署方案专门针对**内网（离线）环境**进行了优化，采用“基础设施”与“业务应用”分离的双 Compose 文件结构。

```text
docker/
├── .env.example              # 环境变量配置模板（使用前复制为 .env）
├── Dockerfile.java17         # 后端服务通用 Java 17 运行镜像模板
├── docker-compose.infra.yml  # 基础设施 Compose（Nacos, Redis, 可选达梦）
├── docker-compose.apps.yml   # 业务服务 Compose（各微服务、Nginx）
├── nacos/                    # Nacos 配置及数据库插件挂载
├── redis/                    # Redis 配置文件挂载
└── nginx/                    # Nginx 配置文件及前端静态包挂载
```

### 1. 基础设施 Compose (`docker-compose.infra.yml`)
*   **Nacos**：作为注册与配置中心，挂载了自定义的 `application.properties`。
*   **Redis**：挂载了本地的 `redis.conf`。
*   **达梦数据库 (dm)**：内置了 `dm8_single` 的占位配置，通过 `profiles: - dm` 声明。如需在 Compose 内运行达梦，启动时增加该 profile 即可。

### 2. 业务应用 Compose (`docker-compose.apps.yml`)
*   定义了所有微服务容器，全部使用 YAML 锚点（`&app-defaults` 和 `&app-common-env`）来共享配置与容器依赖。
*   通过 `depends_on` 确保所有应用服务都在 `nacos` 和 `redis` 启动后才开始加载。

### 3. 达梦数据库 (DM8) 与 Nacos 的适配
Nacos 配置库默认使用达梦数据库进行存储：
*   在 `nacos/conf/application.properties` 中指定了 `spring.datasource.platform=dm` 及达梦的 Driver。
*   在启动 Nacos 容器时，必须通过 `docker-compose.infra.yml` 将达梦的数据源插件及 `DmJdbcDriver18.jar` 挂载到容器内的 `/home/nacos/plugins/` 目录中。

### 4. Nginx 反向代理与安全配置
挂载在 `nginx/conf/nginx.conf`：
*   前端静态资源托管于 `/home/integrity/projects/integrity-ui`，支持单页应用路由。
*   将 `/prod-api/` 开头的接口统一代理到微服务网关服务 `http://integrity-gateway:8080/`。
*   **安全防护**：配置了路径拦截，防止外部恶意请求直接访问 Spring Boot Actuator 的健康和指标端点：
    ```nginx
    if ($request_uri ~ "/actuator") {
        return 403;
    }
    ```

### 5. 通用 Dockerfile (`Dockerfile.java17`)
为了避免每个微服务重复维护 Dockerfile，项目采用参数化的 `Dockerfile.java17`：
```dockerfile
ARG JAVA17_IMAGE=eclipse-temurin:17-jre
FROM ${JAVA17_IMAGE}
WORKDIR /app
ARG JAR_FILE
COPY ${JAR_FILE} /app/app.jar
ENV JAVA_OPTS="" \
    TZ=Asia/Shanghai
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar /app/app.jar"]
```
构建时通过 `--build-arg JAR_FILE=...` 动态指定要打包的模块 Jar 文件。

---

## 三、 本地 Docker 开发与构建指南

### 1. 准备配置文件
复制环境变量模板文件：
```bash
cp docker/.env.example docker/.env
```
根据本地环境，修改 `docker/.env` 中的 `DM_HOST`（达梦数据库 IP）、`REDIS_PASSWORD` 等信息。

### 2. 编译项目 Jar 包
```bash
mvn -DskipTests clean package
```

### 3. 运行容器服务
*   **仅启动基础设施（Nacos + Redis）**：
    ```bash
    docker compose --env-file docker/.env -f docker/docker-compose.infra.yml up -d
    ```
*   **启动基础设施及所有业务模块**：
    ```bash
    docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml up -d
    ```
*   **只重建并启动某个特定模块（例如：integrity-flow）**：
    ```bash
    mvn -pl integrity-modules/integrity-flow -am -DskipTests package
    docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml up -d --build integrity-flow
    ```
*   **查看运行日志**：
    ```bash
    docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml logs -f integrity-flow
    ```
