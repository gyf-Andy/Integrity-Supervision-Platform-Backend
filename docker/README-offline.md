# 内网 Docker 开发与部署说明

本目录提供一套不依赖公网的 Docker 启动方案，适合内网本地开发和内网服务器部署。

## 文件说明

- `Dockerfile.java17`：后端服务通用 Java 17 运行镜像模板。
- `.env.example`：离线环境变量模板，首次使用复制为 `docker/.env`。
- `docker-compose.infra.yml`：基础设施，包含 `nacos`、`redis`，以及可选 `dm`。
- `docker-compose.apps.yml`：业务服务，包含 `gateway`、`auth`、`system`、`gen`、`job`、`flow`、`file`、`monitor`、`nginx`。

旧版 `docker-compose.yml`、旧版模块 Dockerfile 和旧部署脚本已移除；后续只维护本说明中的两个 compose 文件和 `Dockerfile.java17`。

## 一、外网机器准备离线物料

在能联网的机器上准备基础镜像、Maven 依赖和前端产物。

```bash
docker pull eclipse-temurin:17-jre
docker pull nacos/nacos-server:latest
docker pull redis:latest
docker pull nginx:latest

docker save eclipse-temurin:17-jre -o images/eclipse-temurin-17-jre.tar
docker save nacos/nacos-server:latest -o images/nacos-server.tar
docker save redis:latest -o images/redis.tar
docker save nginx:latest -o images/nginx.tar
```

如果达梦也用容器运行，需要按你的授权和镜像来源额外准备达梦镜像 tar，并在 `docker/.env` 中设置 `DM_IMAGE`。

建议在外网机器先执行一次 Maven 构建，让依赖进入本地仓库，然后把 `.m2/repository` 打包带到内网：

```bash
mvn dependency:go-offline
mvn -DskipTests package
```

构建业务镜像并导出，供内网服务器直接 `docker load`：

```bash
cp docker/.env.example docker/.env
docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml build
docker save \
  integrity/gateway:dev integrity/auth:dev integrity/system:dev integrity/gen:dev \
  integrity/job:dev integrity/flow:dev integrity/file:dev integrity/monitor:dev \
  -o images/integrity-apps-dev.tar
```

## 二、内网机器初始化

导入基础镜像：

```bash
docker load -i images/eclipse-temurin-17-jre.tar
docker load -i images/nacos-server.tar
docker load -i images/redis.tar
docker load -i images/nginx.tar
```

复制环境文件：

```bash
cp docker/.env.example docker/.env
```

按实际情况编辑 `docker/.env`：

- 达梦在宿主机或外部服务器：设置 `DM_HOST` 为容器可访问的 IP。
- 达梦也在 compose 中：设置 `DM_HOST=dm`，并使用 `--profile dm` 启动。
- Redis 密码不为空时：设置 `REDIS_PASSWORD`，并同步修改 `docker/redis/conf/redis.conf`。

## 三、数据库与 Nacos 配置

先初始化达梦数据库和 schema，再导入 SQL：

- `sql/integrity-config.sql`：Nacos 配置库。
- `sql/integrity-cloud.sql`：系统主库。
- `sql/integrity-cloud-flow.sql`：流程库。
- `sql/integrity-seata.sql`：Seata 库，如启用 Seata 再导入。

可使用达梦客户端工具执行导入，例如 `disql`、达梦管理工具或 DBeaver。不同达梦镜像的自动初始化目录约定不一致，`docker-compose.infra.yml` 中的 `dm` 服务只提供占位模板；生产环境请按实际达梦镜像文档调整镜像名、数据目录和初始化方式。

注意：Nacos 配置中的 `localhost` 在容器环境里通常不可用。优先通过 `docker-compose.apps.yml` 中的环境变量覆盖；如果某个配置仍然连到 `localhost`，请在 Nacos 控制台把对应配置改为 Docker 服务名：

- Nacos：`nacos:8848`
- Redis：`redis:6379`
- 达梦：`dm:5236` 或你的内网数据库 IP

## 四、本地开发启动

先构建 jar：

```bash
mvn -DskipTests package
```

启动基础设施：

```bash
docker compose --env-file docker/.env -f docker/docker-compose.infra.yml up -d nacos redis
```

启动核心业务服务：

```bash
docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml up -d integrity-gateway integrity-auth integrity-system integrity-flow
```

需要全量启动时：

```bash
docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml up -d --build
```

只重建并重启某个模块，例如 `integrity-flow`：

```bash
mvn -pl integrity-modules/integrity-flow -am -DskipTests package
docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml up -d --build integrity-flow
```

查看日志：

```bash
docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml logs -f integrity-flow
```

## 五、内网服务器部署

推荐交付包结构：

```text
deploy-package/
  docker/
    .env
    Dockerfile.java17
    docker-compose.infra.yml
    docker-compose.apps.yml
    nacos/
    redis/
    nginx/
  images/
    *.tar
  sql/
    *.sql
  README-deploy.md
```

服务器部署顺序：

1. 安装 Docker 和 Docker Compose 插件。
2. `docker load -i images/*.tar` 导入基础镜像和业务镜像。
3. 初始化达梦库和 Nacos 配置库。
4. 启动 `nacos`、`redis`。
5. 确认 Nacos 控制台能访问：`http://服务器IP:8848/nacos`。
6. 启动业务服务和 `nginx`。
7. 通过 `http://服务器IP/` 或 `http://服务器IP:8080/` 验证。

## 六、常见问题

- 服务启动后找不到 Nacos：确认环境变量 `SPRING_CLOUD_NACOS_DISCOVERY_SERVER_ADDR=nacos:8848` 和 `SPRING_CLOUD_NACOS_CONFIG_SERVER_ADDR=nacos:8848` 已注入。
- 服务连 Redis 失败：确认 Nacos 配置和环境变量没有仍指向 `localhost`。
- 服务连达梦失败：容器内不能用宿主机的 `localhost`，应使用 `host.docker.internal`、内网 IP，或 compose 服务名 `dm`。
- 镜像构建失败找不到 jar：先执行 `mvn -DskipTests package`，并确认 `target/*.jar` 已生成。
- Java 版本异常：不要使用旧的 `openjdk:8-jre` Dockerfile，统一使用 `Dockerfile.java17`。
