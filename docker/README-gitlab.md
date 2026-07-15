# 离线环境 Docker 与 GitLab 部署指南

本说明提供在纯内网（离线）环境下安装 Docker、Docker Compose，并使用容器化方式部署 GitLab 社区版（CE）的详细流程。

---

## 目录

1. [一、 Docker 离线安装](#一-docker-离线安装)
   - [方式一：二进制包安装（不限发行版，无依赖冲突，推荐）](#方式一二进制包安装不限发行版无依赖冲突推荐)
   - [方式二：包管理器离线安装（以 CentOS/RHEL 为例）](#方式二包管理器离线安装以-centosrhel-为例)
2. [二、 Docker Compose 离线安装](#二-docker-compose-离线安装)
3. [三、 GitLab 离线容器化部署](#三-gitlab-离线容器化部署)
   - [第一步：外网准备 GitLab 镜像](#第一步外网准备-gitlab-镜像)
   - [第二步：内网导入 GitLab 镜像](#第二步内网导入-gitlab-镜像)
   - [第三步：创建部署目录并编写 docker-compose.yml](#第三步创建部署目录并编写-docker-composeyml)
   - [第四步：启动 GitLab 服务](#第四步启动-gitlab-服务)
   - [第五步：获取 root 用户初始密码](#第五步获取-root-用户初始密码)
4. [四、 系统资源要求与避坑优化建议](#四-系统资源要求与避坑优化建议)

---

## 一、 Docker 离线安装

根据您内网服务器的操作系统，选择以下任意一种方式进行离线安装：

### 方式一：二进制包安装（不限发行版，无依赖冲突，推荐）

该方式不依赖操作系统的包管理器（Yum/Apt），纯二进制拷贝，最为干净稳定。

1. **在外网机器下载二进制包**：
   访问 [Docker Static Binaries](https://download.docker.com/linux/static/stable/x86_64/) 下载所需版本（例如 `docker-26.1.4.tgz`）。

2. **将 `.tgz` 压缩包拷贝到内网服务器并解压**：
   ```bash
   tar -zxvf docker-26.1.4.tgz
   ```

3. **将解压出来的二进制文件移动到系统 PATH 路径**：
   ```bash
   sudo cp docker/* /usr/bin/
   ```

4. **配置 systemd 服务**：
   新建并编辑系统服务文件 `/etc/systemd/system/docker.service`，写入以下内容：
   ```ini
   [Unit]
   Description=Docker Application Container Engine
   Documentation=https://docs.docker.com
   After=network-online.target firewalld.service
   Wants=network-online.target

   [Service]
   Type=notify
   ExecStart=/usr/bin/dockerd
   ExecReload=/bin/kill -s HUP $MAINPID
   LimitNOFILE=infinity
   LimitNPROC=infinity
   LimitCORE=infinity
   TimeoutStartSec=0
   Delegate=yes
   KillMode=process
   Restart=on-failure
   StartLimitBurst=3
   StartLimitInterval=60s

   [Install]
   WantedBy=multi-user.target
   ```

5. **启动并设置开机自启**：
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable --now docker
   ```

---

### 方式二：包管理器离线安装（以 CentOS/RHEL 为例）

1. **在外网相同系统的机器上下载安装包及其全部依赖**：
   ```bash
   mkdir docker-rpms
   # 1. 下载基础依赖包
   sudo yum install --downloadonly --downloaddir=./docker-rpms yum-utils device-mapper-persistent-data lvm2
   
   # 2. 配置 Docker 官方 Yum 源
   sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
   
   # 3. 下载 Docker 安装包及其依赖
   sudo yum install --downloadonly --downloaddir=./docker-rpms docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```

2. **将 `docker-rpms` 文件夹打包并拷贝到内网服务器**。

3. **在内网服务器上执行本地安装**：
   ```bash
   cd docker-rpms
   sudo yum localinstall *.rpm -y
   ```

4. **启动并设置开机自启**：
   ```bash
   sudo systemctl enable --now docker
   ```

---

## 二、 Docker Compose 离线安装

1. **在外网机器上下载对应架构的二进制文件**：
   访问 [Docker Compose GitHub Releases](https://github.com/docker/compose/releases)，选择所需版本下载，例如：`docker-compose-linux-x86_64`。

2. **将该二进制文件拷贝到内网服务器，并配置为 Docker CLI 插件（推荐）**：
   ```bash
   sudo mkdir -p /usr/libexec/docker/cli-plugins
   sudo cp docker-compose-linux-x86_64 /usr/libexec/docker/cli-plugins/docker-compose
   sudo chmod +x /usr/libexec/docker/cli-plugins/docker-compose
   ```

3. **验证是否安装成功**：
   ```bash
   docker compose version
   ```

---

## 三、 GitLab 离线容器化部署

### 第一步：外网准备 GitLab 镜像

1. **拉取 GitLab 社区版（CE）官方镜像**：
   ```bash
   docker pull gitlab/gitlab-ce:16.11.2-ce.0
   ```

2. **将镜像打包导出为 tar 包**：
   ```bash
   docker save gitlab/gitlab-ce:16.11.2-ce.0 -o gitlab-ce-16.11.2.tar
   ```

---

### 第二步：内网导入 GitLab 镜像

1. **将 `gitlab-ce-16.11.2.tar` 传输到内网服务器**。
2. **导入镜像**：
   ```bash
   docker load -i gitlab-ce-16.11.2.tar
   ```

---

### 第三步：创建部署目录并编写 docker-compose.yml

1. **创建工作目录**：
   ```bash
   sudo mkdir -p /opt/gitlab
   cd /opt/gitlab
   ```

2. **编写 `docker-compose.yml`**：
   新建并编辑文件 `docker-compose.yml`，根据您内网服务器的实际 IP 进行配置：
   ```yaml
   version: '3.8'

   services:
     gitlab:
       image: 'gitlab/gitlab-ce:16.11.2-ce.0'
       container_name: gitlab
       restart: always
       # 宿主机的内网 IP 或内网域名（克隆链接中的主机名）
       hostname: '192.168.1.100'
       environment:
         GITLAB_OMNIBUS_CONFIG: |
           # 1. 外部网页访问链接
           external_url 'http://192.168.1.100'
           
           # 2. 修改 SSH 克隆端口（避免与宿主机默认 22 端口冲突）
           gitlab_rails['gitlab_shell_ssh_port'] = 8022
           
           # 3. 设置时区
           gitlab_rails['time_zone'] = 'Asia/Shanghai'
       ports:
         - '80:80'      # HTTP 网页服务映射端口
         - '443:443'    # HTTPS 端口（若需配置 SSL）
         - '8022:22'    # SSH 映射端口（将容器 22 映射为宿主机 8022）
       volumes:
         - './config:/etc/gitlab'      # 挂载配置目录
         - './logs:/var/log/gitlab'    # 挂载日志目录
         - './data:/var/opt/gitlab'    # 挂载数据目录
       shm_size: '256m'                # 必须指定，以防控制台及某些内置组件崩溃
   ```

> [!WARNING]
> **非标准端口部署时的注意事项**：
> 如果您不想让 GitLab 占用宿主机的 `80` 端口（比如想改用 `8090`），请务必在配置中做如下修改，否则将导致页面无法访问或克隆链接错误：
> 1. 将 `external_url` 修改为：`'http://192.168.1.100:8090'`
> 2. 将 `ports` 端口映射修改为：`- '8090:8090'`
> 
> *原因：GitLab 在读取到外部 URL 包含非 80/443 端口时，会自动在其内部的 Nginx 监听该自定义端口。因此，容器内的服务端口已经不再是 80，宿主机的端口必须与容器内部的真实端口一致绑定。*

---

### 第四步：启动 GitLab 服务

1. **在 `/opt/gitlab` 目录下运行服务**：
   ```bash
   docker compose up -d
   ```

2. **监控服务状态与启动日志**（首次初始化需要约 3 至 5 分钟）：
   ```bash
   docker logs -f gitlab
   ```

---

### 第五步：获取 root 用户初始密码

1. **执行以下命令提取系统默认生成的初始密码**：
   ```bash
   docker exec -it gitlab cat /etc/gitlab/initial_root_password
   ```

> [!IMPORTANT]
> 该密码文件在容器首次初始化成功后的 **24小时后会被系统自动清除**。请在第一次访问时使用用户名 `root` 和该密码进行登录，并立即在后台管理界面更改管理员密码。

---

## 四、 系统资源要求与避坑优化建议

1. **硬件性能瓶颈**：
   GitLab 内部封装了 PostgreSQL、Redis、Puma、Sidekiq 等十余个服务，对系统资源消耗非常大。建议内网服务器配置至少为 **4 核 CPU，8GB 内存**。如果内存少于 4GB，极易在启动或运行阶段遇到内存溢出（OOM），表现为浏览器端访问持续出现 **502 Whoops, GitLab is taking too much time to respond**。
   
2. **离线备份**：
   内网服务器多为本地物理机运行，硬件故障概率较高。请务必定期打包备份宿主机上的 `./data`、`./config` 数据挂载文件夹，或在 `gitlab.rb` 中配置 GitLab 定时备份任务（`gitlab-backup` 命令）。
