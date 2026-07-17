# 内网离线 Docker 开发环境准备与启动指南

本文档用于把当前外网开发机上的后端 Docker 开发环境迁移到不能联网的内网开发机。目标是：内网机器导入镜像后，可以像当前机器一样直接用 Docker Compose 启动。

## 一、离线包位置

当前已在外网开发机生成离线包：

```text
D:\offline-bundles\integrity-docker-offline-20260717
```

建议把整个目录拷贝到移动硬盘或内网允许的传输介质中。

## 二、离线包内容

```text
integrity-docker-offline-20260717/
├── docker-images/
│   ├── integrity-docker-images.tar
│   └── images.txt
├── installers/
│   ├── Docker Desktop Installer.exe
│   ├── Git-2.55.0.2-64-bit.exe
│   ├── OpenJDK17-Temurin-windows-x64.msi
│   ├── VSCodeUserSetup-x64-stable.exe
│   └── apache-maven-3.9.9-bin.zip
├── maven/
│   ├── maven-repository.tar.gz
│   └── settings.xml
├── nacos-config/
│   ├── DmJdbcDriver18-8.1.3.140.jar
│   └── nacos-config-after-update.dump
├── repo/
│   └── Integrity-Supervision-Platform-Backend-workingtree.zip
└── scripts/
    ├── load-images.ps1
    ├── start-offline.ps1
    └── check-health.ps1
```

## 三、必须提前准备

1. Docker Desktop
   - 已下载到 `installers/Docker Desktop Installer.exe`。
   - 内网机器需开启虚拟化、WSL2 或 Hyper-V 支持。

2. Docker 镜像包
   - 已导出到 `docker-images/integrity-docker-images.tar`。
   - 包含业务镜像、Nacos、Redis、Nginx、Sentinel、MinIO、MinIO Client、Java 17 基础镜像。

3. 达梦数据库
   - 当前 Compose 默认使用宿主机本地达梦数据库，不使用达梦 Docker 镜像。
   - 内网机器必须提前安装并启动达梦，监听 `5236`。
   - 需要导入 `sql/` 目录中的初始化脚本，至少准备这些库或 schema：
     - `INTEGRITY-CONFIG`
     - `INTEGRITY-CLOUD`
     - `INTEGRITY-CLOUD-FLOW`
   - 默认连接信息在 `docker/.env` 中：
     - `DM_HOST=host.docker.internal`
     - `DM_PORT=5236`
     - `DM_USERNAME=SYSDBA`
     - `DM_PASSWORD=IntegritySupervision0`

4. Nacos 配置库
   - 当前业务配置存储在达梦的 Nacos 配置库中。
   - 离线包已提供当前验证通过的配置导出：`nacos-config/nacos-config-after-update.dump`。
   - 如果内网机器使用全新的达梦库，请确认 Nacos `CONFIG_INFO` 中这些 dataId 已存在且内容与 dump 一致：
     - `application-dev.yml`
     - `integrity-gateway-dev.yml`
     - `integrity-auth-dev.yml`
     - `integrity-system-dev.yml`
     - `integrity-gen-dev.yml`
     - `integrity-job-dev.yml`
     - `integrity-flow-dev.yml`
     - `integrity-file-dev.yml`
     - `integrity-monitor-dev.yml`
     - `sentinel-integrity-gateway`

## 四、可选准备

1. JDK 17
   - 已下载 `OpenJDK17-Temurin-windows-x64.msi`。
   - 当前外网机器使用 Java 17，Compose 运行镜像默认也是 `eclipse-temurin:17-jdk`。

2. Maven 3.9.9
   - 已下载 `apache-maven-3.9.9-bin.zip`。
   - VS Code 当前通过 `.vscode/settings.json` 指定 `D:\environment\maven\apache-maven-3.9.9\conf\settings.xml`。
   - 该 `settings.xml` 中配置的本地仓库是 `D:/environment/maven/maven-repository`。
   - 已打包正确的本机 Maven 缓存：`maven/maven-repository.tar.gz`。
   - 已复制当前 Maven 配置文件：`maven/settings.xml`。
   - 如果内网需要改代码并重新打包，先恢复 Maven 缓存。

3. Git for Windows
   - 已下载 `Git-2.55.0.2-64-bit.exe`。

4. 源码快照
   - 已打包当前工作区快照：`repo/Integrity-Supervision-Platform-Backend-workingtree.zip`。
   - 该快照包含当前 Docker/Nacos 配置修改，不包含 `.git` 和各模块 `target` 目录。

5. VS Code
   - 已下载 `VSCodeUserSetup-x64-stable.exe`。
   - 当前机器的 `code` 命令不在 PATH，未导出扩展 `.vsix`。内网如需完全一致的 IDE 插件，请提前从可联网机器单独导出对应扩展。

## 五、内网机器首次安装

在内网开发机上执行：

1. 安装 Docker Desktop。
2. 安装 JDK 17。
3. 解压 Maven 3.9.9，并配置 `MAVEN_HOME` 与 `PATH`。
4. 安装 Git for Windows。
5. 可选安装 VS Code。
6. 安装达梦数据库并导入项目 SQL。

如果内网机器已经安装过同版本工具，可以跳过对应安装步骤。

Docker Desktop 需要 Windows 虚拟化能力。若内网机器未启用 WSL2 或 Hyper-V，请先让管理员开启对应 Windows 功能；离线环境下 `wsl --install` 可能无法自动下载组件。

## 六、导入 Docker 镜像

假设离线包复制到了：

```powershell
D:\offline-bundles\integrity-docker-offline-20260717
```

在 PowerShell 中执行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
cd D:\offline-bundles\integrity-docker-offline-20260717
.\scripts\load-images.ps1 -BundleRoot D:\offline-bundles\integrity-docker-offline-20260717
```

导入后可检查：

```powershell
docker images
```

## 七、准备源码目录

方式 A：使用离线包中的源码快照。

```powershell
Expand-Archive .\repo\Integrity-Supervision-Platform-Backend-workingtree.zip D:\CodeProject\Integrity-Supervision-Platform-Backend
cd D:\CodeProject\Integrity-Supervision-Platform-Backend
```

方式 B：如果内网已有仓库，只需要确认已包含当前这些 Docker 配置文件的修改：

```text
docker/.env.example
docker/Dockerfile.java17
docker/README-docker.md
docker/内网离线Docker开发指南.md
docker/docker-compose.apps.yml
docker/docker-compose.infra.yml
docker/nacos/conf/application.properties
docker/offline/*.ps1
```

## 八、恢复 Maven 配置和缓存

只有需要在内网重新 `mvn package` 时才需要这一步。

```powershell
New-Item -ItemType Directory -Force D:\environment\maven | Out-Null
tar -xzf D:\offline-bundles\integrity-docker-offline-20260717\maven\maven-repository.tar.gz -C D:\environment\maven
Copy-Item D:\offline-bundles\integrity-docker-offline-20260717\maven\settings.xml D:\environment\maven\apache-maven-3.9.9\conf\settings.xml -Force
```

恢复后目录应类似：

```text
D:\environment\maven\maven-repository
```

离线编译示例：

```powershell
mvn -o -DskipTests clean package
```

## 九、配置 docker/.env

如果源码目录没有 `docker/.env`，先复制：

```powershell
Copy-Item docker\.env.example docker\.env
```

重点确认：

```env
DM_HOST=host.docker.internal
DM_PORT=5236
DM_USERNAME=SYSDBA
DM_PASSWORD=IntegritySupervision0
NACOS_AUTH_ENABLE=false
NACOS_USERNAME=
NACOS_PASSWORD=
```

说明：

- 本地开发默认关闭 Nacos 鉴权。
- `NACOS_AUTH_TOKEN` 必须保留非空，因为当前 Nacos 镜像启动脚本要求 token 非空。
- 生产环境启用鉴权时，必须更换 `NACOS_AUTH_TOKEN`、`NACOS_USERNAME`、`NACOS_PASSWORD`。

## 十、启动服务

优先直接使用已导入镜像启动，不要加 `--build`：

```powershell
cd D:\CodeProject\Integrity-Supervision-Platform-Backend
.\docker\offline\start-offline.ps1
```

等 Nacos 和 Redis 显示 healthy 后，业务服务会自动启动。

也可以手动执行：

```powershell
docker compose --env-file docker/.env -f docker/docker-compose.apps.yml up -d
```

## 十一、健康检查

```powershell
.\docker\offline\check-health.ps1
```

预期主要端点返回 `200`：

```text
http://localhost:8080/actuator/health
http://localhost:9201/actuator/health
http://localhost:9202/actuator/health
http://localhost:9203/actuator/health
http://localhost:9204/actuator/health
http://localhost:9300/actuator/health
http://localhost:9100/actuator/health
```

查看日志：

```powershell
docker compose --env-file docker/.env -f docker/docker-compose.apps.yml logs -f integrity-gateway
```

## 十二、常见问题

### 1. Docker 仍尝试联网拉镜像

先确认镜像已导入：

```powershell
docker images
```

再确认启动命令没有加 `--pull always` 或误删本地镜像。

### 2. 不要首次启动就执行 --build

`--build` 会重新构建业务镜像。内网如果缺 Maven 依赖或 Jar 包，会失败。

推荐顺序：

1. `docker load`
2. `docker compose up -d`
3. 确认能启动后，再考虑离线 Maven 构建。

### 3. Nacos 容器 unhealthy

检查：

```powershell
docker logs integrity-nacos
```

常见原因：

- 达梦数据库没有启动。
- `DM_HOST`、`DM_PORT`、用户名或密码错误。
- `NACOS_AUTH_TOKEN` 为空。
- Nacos 配置库 `INTEGRITY-CONFIG` 未导入初始化表。

### 4. 业务服务数据库连接失败

检查：

- 达梦本地服务是否监听 `5236`。
- `docker/.env` 中 `DM_HOST=host.docker.internal`。
- `INTEGRITY-CLOUD`、`INTEGRITY-CLOUD-FLOW` 是否已导入。

### 5. Sentinel 报 ruleType null

当前 Compose 已只在 gateway 配置 Sentinel Nacos datasource。如果仍出现该错误，确认内网使用的是本次离线包中的 `docker/docker-compose.apps.yml`。

## 十三、离线包校验

离线包中提供 `checksums/SHA256SUMS.txt`。复制到内网后可以重新计算文件哈希进行比对。
