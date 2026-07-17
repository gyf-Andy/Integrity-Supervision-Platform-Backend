# 原型迁移文件结构重规划

## 目标

正式前后端当前已有页面能力，对应原型中的“系统安全管理分系统”。接下来迁移原型时，应按五个分系统重新组织正式前端文件结构，而不是按原型现有目录原样搬迁。

五个分系统为：

- 数据接引采报分系统
- 数据模型分析
- 智慧监管应用分系统
- 廉政态势展示分系统
- 系统安全管理分系统

本文只规划前端文件结构和页面跳转关系，不实施迁移代码。

## 命名原则

- 文件夹和文件名不使用原型简称作为命名。
- 顶层按分系统组织，避免把页面平铺到 `src/views`。
- 路由级页面放 `pages`，页面内部切换面板放 `components` 或 `panels`。
- 数据模拟、临时适配、正式接口分开，避免页面直接依赖 mock。
- 系统安全管理优先复用正式前端现有 `system`、`monitor`、`flow`、`tool` 结构，不重复迁入原型单页。

## 推荐总目录

```text
src/
├── views/
│   ├── portal/
│   │   └── index.vue
│   └── subsystems/
│       ├── data-ingestion/
│       ├── data-model-analysis/
│       ├── smart-supervision/
│       ├── integrity-situation/
│       └── security-management/
├── components/
│   └── subsystems/
│       ├── common/
│       ├── data-ingestion/
│       ├── data-model-analysis/
│       ├── smart-supervision/
│       ├── integrity-situation/
│       └── security-management/
├── api/
│   └── subsystems/
│       ├── data-ingestion.js
│       ├── data-model-analysis.js
│       ├── smart-supervision.js
│       ├── integrity-situation.js
│       └── security-management.js
├── services/
│   └── subsystems/
│       ├── adapters/
│       └── mock/
├── data/
│   └── subsystems/
├── types/
│   └── subsystems/
├── router/
│   └── modules/
│       └── subsystems.js
└── assets/
    └── styles/
        └── subsystems/
```

说明：

- `views/portal/index.vue` 是五个分系统的统一入口，对应原型首页/总览卡片。
- `views/subsystems/*/pages` 放可被路由和后端菜单直接指向的页面。
- `components/subsystems/*` 放分系统内部复用面板、表格、图表、弹窗。
- `services/subsystems/mock` 临时保留原型 mock 数据。
- `services/subsystems/adapters` 做 mock 和正式 API 的切换适配，页面只调用 adapter。
- `router/modules/subsystems.js` 可作为本地开发静态路由参考；正式生产仍建议由后端菜单返回动态路由。

## 一、数据接引采报分系统

### 原型跳转逻辑

原型入口为数据接引采报页面。页面内部用左侧菜单切换：

- 任务管理
- 模板配置
- 统计分析
- 运行监控
- 数据源管理
- AI 模型配置

另有数据域快速切换：

- 业务系统引接
- 本地汇聚数据
- 外部接入数据

这些是同一分系统内的状态切换，不建议拆成大量顶级路由。

### 推荐结构

```text
src/views/subsystems/data-ingestion/
├── index.vue
└── pages/
    ├── task-management.vue
    ├── template-config.vue
    ├── statistics.vue
    ├── runtime-monitor.vue
    ├── data-source.vue
    └── ai-model-settings.vue

src/components/subsystems/data-ingestion/
├── domain-switch.vue
├── task/
│   ├── task-panel.vue
│   ├── task-dialog.vue
│   └── task-category-tree.vue
├── template/
│   └── template-panel.vue
├── statistics/
│   └── statistics-panel.vue
├── monitor/
│   └── monitor-panel.vue
├── data-source/
│   └── data-source-panel.vue
└── ai/
    ├── model-settings-panel.vue
    └── assistant-panel.vue
```

### 路由建议

```text
/data-ingestion
/data-ingestion/tasks
/data-ingestion/templates
/data-ingestion/statistics
/data-ingestion/monitor
/data-ingestion/sources
/data-ingestion/ai-settings
```

默认进入 `/data-ingestion/tasks`。数据域通过 query 或页面状态承载，例如：

```text
/data-ingestion/tasks?domain=business
/data-ingestion/tasks?domain=local
/data-ingestion/tasks?domain=external
```

## 二、数据模型分析

### 原型跳转逻辑

原型的数据模型页面是大型左侧菜单页，包含：

- 数据清洗
- 数据资产
- 数据服务
- 监督模型
- 系统设置
- 案件账单分析
- 报告模板管理
- 常用工具

其中“数据管理”页面里也有数据接引采报和数据模型两个 tab，它更像早期整合页。迁移时不建议保留这个混合页作为顶级结构，应拆回两个分系统。

### 推荐结构

```text
src/views/subsystems/data-model-analysis/
├── index.vue
└── pages/
    ├── cleaning/
    │   ├── task-management.vue
    │   ├── component-management.vue
    │   └── engine-monitor.vue
    ├── assets/
    │   ├── overview.vue
    │   ├── catalog.vue
    │   ├── asset-set.vue
    │   ├── metadata.vue
    │   ├── cataloging.vue
    │   ├── permission.vue
    │   └── topic-libraries.vue
    ├── services/
    │   ├── service-management.vue
    │   ├── component-management.vue
    │   ├── app-management.vue
    │   └── approval.vue
    ├── models/
    │   ├── management.vue
    │   ├── designer.vue
    │   ├── run.vue
    │   ├── statistics.vue
    │   └── marketplace.vue
    ├── settings/
    │   ├── data-source.vue
    │   ├── files.vue
    │   ├── categories.vue
    │   ├── authorization.vue
    │   └── custom-functions.vue
    ├── case-bill/
    │   ├── import.vue
    │   ├── tools.vue
    │   ├── persons.vue
    │   └── bank-analysis.vue
    ├── reports/
    │   ├── templates.vue
    │   └── generation.vue
    └── tools/
        ├── form-designer.vue
        ├── table-designer.vue
        ├── chart-management.vue
        ├── portal-designer.vue
        └── ocr.vue

src/components/subsystems/data-model-analysis/
├── cleaning/
├── assets/
├── services/
├── models/
├── settings/
├── case-bill/
├── reports/
└── tools/
```

### 路由建议

```text
/data-model-analysis
/data-model-analysis/cleaning/tasks
/data-model-analysis/cleaning/components
/data-model-analysis/cleaning/engine
/data-model-analysis/assets/overview
/data-model-analysis/assets/catalog
/data-model-analysis/assets/asset-sets
/data-model-analysis/assets/metadata
/data-model-analysis/assets/cataloging
/data-model-analysis/assets/permissions
/data-model-analysis/assets/topic-libraries
/data-model-analysis/services/management
/data-model-analysis/services/components
/data-model-analysis/services/apps
/data-model-analysis/services/approvals
/data-model-analysis/models/management
/data-model-analysis/models/designer
/data-model-analysis/models/runs
/data-model-analysis/models/statistics
/data-model-analysis/models/marketplace
/data-model-analysis/settings/data-sources
/data-model-analysis/settings/files
/data-model-analysis/settings/categories
/data-model-analysis/settings/authorization
/data-model-analysis/settings/functions
/data-model-analysis/case-bill/import
/data-model-analysis/case-bill/tools
/data-model-analysis/case-bill/persons
/data-model-analysis/case-bill/bank-analysis
/data-model-analysis/reports/templates
/data-model-analysis/reports/generation
/data-model-analysis/tools/form-designer
/data-model-analysis/tools/table-designer
/data-model-analysis/tools/charts
/data-model-analysis/tools/portal-designer
/data-model-analysis/tools/ocr
```

## 三、智慧监管应用分系统

### 原型跳转逻辑

原型中智慧监管应用由顶部/左侧业务菜单驱动，`SuperviseApp` 根据 route path 切换内部组件。主要业务链为：

- 项目建设监督
- 招标采购监督
- 巡视整改监督
- 案件档案管理
- 廉政信息管理
- 实体中心
- 监督模型浮层

原型同时存在旧版项目页面和新版项目监督页面。迁移规划中应合并到“项目建设监督”，避免重复形成两个顶级模块。

### 推荐结构

```text
src/views/subsystems/smart-supervision/
├── index.vue
└── pages/
    ├── project-construction/
    │   ├── overview.vue
    │   ├── project-list.vue
    │   ├── risk-management.vue
    │   ├── tracking.vue
    │   ├── profile.vue
    │   ├── issue-handling.vue
    │   └── work-supervision.vue
    ├── procurement/
    │   ├── overview.vue
    │   ├── procurement-list.vue
    │   ├── risk-warning.vue
    │   ├── risk-handling.vue
    │   └── expert-management.vue
    ├── inspection-rectification/
    │   ├── problem-import.vue
    │   ├── rectify-publish.vue
    │   └── rectify-assessment.vue
    ├── case-archive/
    │   ├── overview.vue
    │   ├── clue-source-analysis.vue
    │   ├── search.vue
    │   └── bill-analysis.vue
    ├── integrity-info/
    │   ├── basic-info.vue
    │   ├── person-portrait.vue
    │   ├── policy.vue
    │   ├── business-online.vue
    │   ├── supervision-guard.vue
    │   ├── clue-handling.vue
    │   ├── access-trace.vue
    │   ├── risk-assessment.vue
    │   └── integrity-review.vue
    └── entity-hub/
        ├── overview.vue
        ├── project-hub.vue
        ├── person-hub.vue
        └── event-hub.vue

src/components/subsystems/smart-supervision/
├── shared/
│   ├── supervised-model-drawer.vue
│   └── risk-assessment-panel.vue
├── project-construction/
│   ├── flow-chart.vue
│   ├── action-compliance-table.vue
│   └── work-monitors/
├── procurement/
├── inspection-rectification/
├── case-archive/
├── integrity-info/
└── entity-hub/
```

### 路由建议

```text
/smart-supervision
/smart-supervision/projects/overview
/smart-supervision/projects/list
/smart-supervision/projects/risks
/smart-supervision/projects/tracking
/smart-supervision/projects/profile/:projectId
/smart-supervision/projects/issues
/smart-supervision/projects/work-supervision
/smart-supervision/procurement/overview
/smart-supervision/procurement/list
/smart-supervision/procurement/risks
/smart-supervision/procurement/handling
/smart-supervision/procurement/experts
/smart-supervision/inspection/import
/smart-supervision/inspection/publish
/smart-supervision/inspection/assessment
/smart-supervision/cases/overview
/smart-supervision/cases/clue-analysis
/smart-supervision/cases/search
/smart-supervision/cases/bill-analysis
/smart-supervision/integrity-info/basic
/smart-supervision/integrity-info/person-portrait
/smart-supervision/integrity-info/policy
/smart-supervision/integrity-info/business-online
/smart-supervision/integrity-info/guard
/smart-supervision/entity-hub/overview
/smart-supervision/entity-hub/projects/:projectId
/smart-supervision/entity-hub/persons/:personId
/smart-supervision/entity-hub/events
```

## 四、廉政态势展示分系统

### 原型跳转逻辑

态势展示是独立驾驶舱页面，内部通过顶部 tab 切换：

- 全局态势总览
- 巡视整改成效
- 个性化查询
- 预警中心
- 督办任务

它是只读聚合层，依赖前三个业务分系统的数据，不应把数据采集、模型运行或处置逻辑写进本分系统。

### 推荐结构

```text
src/views/subsystems/integrity-situation/
├── index.vue
└── pages/
    ├── overview.vue
    ├── rectification-effect.vue
    ├── personalized-query.vue
    ├── alert-center.vue
    └── supervision-tasks.vue

src/components/subsystems/integrity-situation/
├── layout/
│   ├── situation-header.vue
│   ├── situation-tabs.vue
│   └── situation-status-bar.vue
├── overview/
├── rectification/
├── query/
├── alerts/
└── tasks/
```

### 路由建议

```text
/integrity-situation
/integrity-situation/overview
/integrity-situation/rectification
/integrity-situation/query
/integrity-situation/alerts
/integrity-situation/tasks
```

内部 tab 可同步到路由，便于刷新、收藏和后端菜单定位。

## 五、系统安全管理分系统

### 原型跳转逻辑

原型系统安全页内部用菜单切换：

- 单位管理
- 部门管理
- 用户管理
- 角色管理
- 权限管理
- 菜单管理
- 参数配置
- 字典管理
- 日志审计
- 数据源管理
- 文件管理
- 角色权限配置
- 操作审计

正式前端已经有系统管理、监控、文件、流程、代码生成等模块，并且后端也已有对应接口。迁移时应以正式前端现有结构为准，不建议把原型 `SystemSecurity` 单页整体搬入。

### 推荐结构

保留正式前端现有结构：

```text
src/views/system/
├── user/
├── role/
├── menu/
├── dept/
├── post/
├── dict/
├── config/
├── notice/
├── operlog/
├── logininfor/
└── leave/

src/views/monitor/
├── online/
└── job/

src/views/tool/
├── gen/
└── build/
```

如需补充原型中正式前端缺失的安全管理页面，再放入：

```text
src/views/subsystems/security-management/
└── pages/
    ├── organization-units.vue
    ├── permission-policy.vue
    ├── data-sources.vue
    ├── file-management.vue
    ├── role-permissions.vue
    └── audit-overview.vue

src/components/subsystems/security-management/
├── organization/
├── permissions/
├── data-sources/
├── files/
└── audit/
```

### 路由建议

已有正式前端系统管理路由继续沿用：

```text
/system/user
/system/role
/system/menu
/system/dept
/system/dict
/system/config
/monitor/online
/monitor/job
/tool/gen
```

新增页面才使用：

```text
/security-management/units
/security-management/permissions/policy
/security-management/data-sources
/security-management/files
/security-management/role-permissions
/security-management/audit
```

## 公共能力规划

跨分系统共享能力不要放进某个业务分系统：

```text
src/components/subsystems/common/
├── charts/
├── query/
├── risk/
├── status/
├── tables/
└── workflow/

src/services/subsystems/adapters/
├── data-ingestion-adapter.js
├── data-model-analysis-adapter.js
├── smart-supervision-adapter.js
├── integrity-situation-adapter.js
└── security-management-adapter.js

src/services/subsystems/mock/
├── data-ingestion.mock.js
├── data-model-analysis.mock.js
├── smart-supervision.mock.js
├── integrity-situation.mock.js
└── security-management.mock.js

src/data/subsystems/
├── reference-data.js
├── dashboard-data.js
└── situation-data.js
```

原型中的 `dataCollection`、`dataAnalysis`、`dataSupervision`、态势聚合服务建议迁移为 adapter 层，不直接进入页面：

- 数据接引采报：提供原始数据和接入任务。
- 数据模型分析：提供清洗、资产、模型、分析结果。
- 智慧监管应用：消费原始数据和模型结果，产生处置结果。
- 廉政态势展示：聚合前三个分系统的数据，只读展示。

## 后端动态菜单 component 建议

正式前端动态菜单的 `component` 路径应指向 `src/views` 下相对路径，例如：

```text
subsystems/data-ingestion/pages/task-management
subsystems/data-model-analysis/pages/assets/overview
subsystems/smart-supervision/pages/project-construction/overview
subsystems/integrity-situation/pages/overview
system/user/index
```

其中系统安全管理已有页面继续使用现有路径，不强行搬到 `subsystems/security-management`。

## 第一阶段建议落地范围

第一阶段只做“结构骨架 + 五个分系统入口”，不要一次性迁所有面板：

```text
src/views/portal/index.vue
src/views/subsystems/data-ingestion/index.vue
src/views/subsystems/data-model-analysis/index.vue
src/views/subsystems/smart-supervision/index.vue
src/views/subsystems/integrity-situation/index.vue
src/views/subsystems/security-management/index.vue
src/router/modules/subsystems.js
src/components/subsystems/common/
src/services/subsystems/adapters/
src/services/subsystems/mock/
```

验收目标：

- 正式前端登录后能看到五个分系统入口。
- 每个入口能进入对应分系统首页。
- 后端菜单 component 路径和正式前端文件路径一致。
- `npm run build:prod` 通过。

## 需要确认的问题

1. 顶部一级导航是否就固定为五个分系统，还是继续保留正式前端现有“系统管理/流程/监控/工具”菜单，把五个分系统作为新增业务菜单？
2. “数据接引采报分系统”的正式名称是否采用“接引”还是原型文档中的“引接”？建议产品文案统一后再落表和路由。
3. 系统安全管理是否完全复用现有正式前端系统管理，还是需要补迁原型中的“单位管理、数据源管理、文件管理、角色权限配置、操作审计”等页面？
