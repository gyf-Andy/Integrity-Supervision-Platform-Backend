# 项目系统了解摘要

## 后端

路径：`D:\CodeProject\antigraviry_repository\Integrity-Supervision-Platform-Backend`

后端是 Java 17 + Spring Boot 3.3.5 + Spring Cloud 2023.0.3 + Spring Cloud Alibaba 2023.0.1.2 的 Maven 多模块微服务项目，版本号 `3.6.5`。核心模块包括：

- `integrity-gateway`：统一入口，端口 `8080`，负责认证过滤、验证码、XSS、Sentinel 网关限流、SpringDoc 聚合。
- `integrity-auth`：认证中心，端口 `9200`，提供 `/login`、`/logout`、`/refresh`、`/register`，前端经网关访问为 `/auth/login` 等。
- `integrity-modules/integrity-system`：系统管理，端口 `9201`，用户、角色、菜单、部门、字典、配置、日志、通知、请假流程等。
- `integrity-modules/integrity-flow`：流程服务，端口 `9204`，基于 Warm Flow 1.3.4，流程定义与执行接口。
- `integrity-modules/integrity-job`：任务调度，端口 `9203`。
- `integrity-modules/integrity-file`：文件服务，端口 `9300`，支持 MinIO/FastDFS/本地存储。
- `integrity-modules/integrity-gen`：代码生成，端口 `9202`。
- `integrity-visual/integrity-monitor`：Spring Boot Admin 监控，端口 `9100`。
- `integrity-common`：core/security/redis/log/swagger/datasource/datascope/sensitive/seata/encrypt 等横切能力。
- `integrity-api`：Feign 远程接口定义。

数据层当前重点是达梦数据库：`system/gen/job` 默认库为 `INTEGRITY-CLOUD`，`flow` 默认库为 `INTEGRITY-CLOUD-FLOW`，Nacos 配置库为 `INTEGRITY-CONFIG`。`sql/` 中当前是达梦 `.dmp` 导出文件。

Docker 部署分两段：`docker-compose.infra.yml` 启 Nacos/Redis/Sentinel/MinIO/可选 DM，`docker-compose.apps.yml` 启各微服务和 Nginx。Nginx 将 `/prod-api/` 代理到 `integrity-gateway:8080/`。

## 正式前端

路径：`D:\CodeProject\antigraviry_repository\Integrity-Supervision-Platform-Frontend`

正式前端是 Vue 3.3.9 + Vite 5.0.4 + Pinia + Vue Router 4 + Element Plus 2.4.3，整体是 RuoYi-Cloud 管理后台风格。脚本：

- `npm run dev`：Vite 开发服务，默认端口 `80`。
- `npm run build:prod`：生产构建。
- `npm run build:stage`：预发布构建。

环境变量：

- 开发：`VITE_APP_BASE_API=/dev-api`，Vite 代理到 `http://localhost:8080` 并去掉 `/dev-api`。
- 生产：`VITE_APP_BASE_API=/prod-api`，匹配后端 Docker Nginx 代理。
- 预发布：`/stage-api`，当前只在前端配置中看到，后端 Nginx 目前只配置了 `/prod-api/`。

登录和权限链路：

- `src/api/login.js` 调 `/auth/login`、`/auth/logout`、`/auth/refresh`、`/system/user/getInfo`、`/code`。
- `src/utils/request.js` 统一 Axios 封装，自动添加 `Authorization: Bearer <token>`，统一处理 401/500/601，支持下载。
- `src/permission.js` 做路由守卫，未登录跳 `/login`，登录后拉取 `getInfo` 和 `getRouters`。
- `src/store/modules/permission.js` 将后端返回的菜单路由转换为前端组件，组件路径必须匹配 `src/views/**/*.vue`。

主要页面模块包括系统管理、流程管理、系统监控、代码生成、个人中心等。接口路径与后端网关前缀大致对应：`/auth`、`/system`、`/flow`、`/schedule`、`/code`。

## 原型项目

路径：`D:\CodeProject\antigraviry_repository\lz`

原型项目是 Vue 3 + TypeScript + Vite + Element Plus + ECharts，开发端口 `3000`。它不是纯静态 HTML，而是可运行的前端原型工程，并包含大量说明文档。

它的业务范围比正式前端更完整，覆盖：

- 数据引接采报分系统。
- 数据模型分析分系统。
- 数据管理/数据服务/数据资产/模型设计。
- 智慧监管应用：项目建设监督、招标采购监督、巡视整改监督、案件档案、监督信息管理。
- 监督态势展示：总览、预警、查询、整改。
- 实体中心：项目中心、人员中心、事件总览。
- 系统安全管理。

当前原型的业务数据主要来自 `src/services/*.ts`、`src/data/*.ts` 中的 mock/Promise/localStorage；没有统一 Axios 封装，也没有正式后端 API baseURL。`src/services/llmService.ts` 是例外，它会按本地配置直接调用兼容 OpenAI 的 `/chat/completions` 接口。

## 三者关系

后端和正式前端已经形成一套可运行管理后台：网关 `8080` + 前端 `/dev-api` 或 `/prod-api`，动态菜单由后端系统模块驱动。

`lz` 更像业务蓝图和高保真功能原型：页面、交互、领域模型、文档都比较丰富，但尚未纳入正式前端的权限/菜单/API 框架。后续如果迁移，推荐路径是：

1. 先把 `lz` 的领域模块映射成后端微服务/表/接口边界。
2. 在正式前端中按 `src/api/{module}`、`src/views/{module}`、后端菜单 `component` 路径的方式落地。
3. 将 mock service 替换为正式 `request` 封装，统一走网关。
4. 需要新增大屏/态势页时，优先复用 `lz` 的页面结构和 mock 数据类型，再逐步接真实接口。

## 注意点

- 后端 README 在当前终端有编码乱码，但源码、POM、YAML、Docker 文件可正常确认事实。
- CCG 双模型分析尝试失败：`antigravity` 后端依赖的 `agy` 命令不在 PATH；Claude 后端未在 180 秒内返回可用报告。
- 前端生产 `/prod-api` 与后端 Nginx 已匹配；`/stage-api` 需要部署侧另配代理。
- 原型中存在 `._*` 文件，像 macOS 资源叉遗留文件，后续迁移时应排除。
- 原型里 LLM API Key 存 localStorage 并由浏览器直连外部模型，若产品化应改为后端代理和权限审计。
