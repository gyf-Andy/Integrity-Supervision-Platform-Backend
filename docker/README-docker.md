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
├── docker-compose.infra.yml  # 基础设施 Compose（Nacos, Redis, Sentinel, MinIO，dm 可选）
├── docker-compose.apps.yml   # 业务服务 Compose（各微服务、Nginx）
├── nacos/                    # Nacos 配置及数据库插件挂载
├── redis/                    # Redis 配置文件挂载
└── nginx/                    # Nginx 配置文件及前端静态包挂载
```

### 1. 基础设施 Compose (`docker-compose.infra.yml`)
*   **Nacos**：作为注册与配置中心，挂载了自定义的 `application.properties`。
*   **Redis**：挂载了本地的 `redis.conf`。
*   **达梦数据库**：默认使用宿主机本地达梦数据库，容器内服务通过 `host.docker.internal:5236` 访问；如需容器内达梦，可显式启用 `dm` profile。

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
ARG JAVA17_IMAGE=eclipse-temurin:17-jdk
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
默认使用宿主机本地达梦数据库，`docker/.env` 中的 `DM_HOST` 默认为 `host.docker.internal`。请先确保本地达梦已启动、监听 `5236`，并已导入 `sql/` 目录中的初始化脚本。如需连接其他机器上的达梦数据库，可修改 `DM_HOST` 为数据库 IP；如需改回 Compose 内达梦容器，可设置 `COMPOSE_PROFILES=dm`、将 `DM_HOST` 改为 `dm`，并提前准备 `DM_IMAGE` 指向的镜像。

本地开发默认关闭 Nacos 鉴权：`NACOS_AUTH_ENABLE=false`，`NACOS_USERNAME` 与 `NACOS_PASSWORD` 保持为空。只有在明确启用 Nacos 鉴权时，才填写这两个账号密码变量；否则客户端会尝试调用登录接口，容易在 Nacos 3.x 或启动早期产生无意义的登录错误日志。生产环境必须开启 Nacos 鉴权，并修改默认账号、密码和 `NACOS_AUTH_TOKEN`。

Sentinel 的 Nacos 规则源只配置在 `integrity-gateway` 上，其他业务服务仅连接 Sentinel Dashboard，避免非网关服务加载不完整的 `ds1` 数据源。

### 2. 编译项目 Jar 包
```bash
mvn -DskipTests clean package
```

### 3. 运行容器服务
*   **仅启动基础设施（Nacos + Redis + Sentinel + MinIO，达梦使用宿主机本地服务）**：
    ```bash
    docker compose --env-file docker/.env -f docker/docker-compose.infra.yml up -d
    ```
*   **启动基础设施及所有业务模块**：
    ```bash
    docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml up -d
    ```
    Nacos 首次启动可能需要约 1 分钟才开放 API。如果业务模块日志中出现短暂的 `Client not connected` 或 `Connection refused`，等 Nacos ready 后重启业务模块即可：
    ```bash
    docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml up -d --force-recreate integrity-gateway integrity-auth integrity-system integrity-gen integrity-job integrity-flow integrity-file integrity-monitor
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

---

## Docker 环境下的 MinIO 文件存储

Docker 模式默认使用 MinIO 作为文件存储。

`docker/.env` 中的关键变量：

```env
MINIO_IMAGE=quay.io/minio/minio:latest
MINIO_MC_IMAGE=quay.io/minio/mc:latest
MINIO_ENABLED=true
MINIO_CLIENT_ADDR=http://minio:9000
MINIO_PUBLIC_URL=http://localhost:9000
MINIO_BUCKET=integrity
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin
```

`MINIO_CLIENT_ADDR` 是 `integrity-file` 在 Compose 内部网络中访问 MinIO 的地址。
`MINIO_PUBLIC_URL` 是文件上传后返回给浏览器访问的地址。

启动完整服务：

```bash
docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml up -d --build integrity-file
```

MinIO 控制台：

```text
http://localhost:9001
```

默认登录账号和密码由 `MINIO_ACCESS_KEY`、`MINIO_SECRET_KEY` 控制。

如果从 Docker Hub 拉取 `minio/minio:latest` 时遇到 CloudFront `EOF`，
可以使用上面的默认 `quay.io/minio/...` 镜像，或者将 `MINIO_IMAGE`、
`MINIO_MC_IMAGE` 指向内网镜像仓库。

如果 Docker Hub 和 Quay 都出现 `EOF`，需要先处理 Docker 守护进程到镜像仓库的网络。
常见处理方式：

```bash
# 方式 A：配置 Docker Desktop 代理或镜像加速后重试：
docker compose -f docker/docker-compose.infra.yml pull minio minio-init

# 方式 B：从离线 tar 包导入镜像，然后打成 .env 中配置的标签：
docker load -i minio.tar
docker load -i mc.tar
docker tag <已导入的MinIO镜像> quay.io/minio/minio:latest
docker tag <已导入的mc镜像> quay.io/minio/mc:latest
```

也可以直接修改 `docker/.env` 中的 `MINIO_IMAGE` 和 `MINIO_MC_IMAGE`，
让它们指向内网镜像仓库，例如 `registry.example.com/minio/minio:latest`。
