# 原型迁移文件结构重规划

## 目标

正式前端当前已有页面能力整体归入“系统安全管理分系统”，并且该分系统已开发完毕。接下来迁移原型时，当前开发重点只放在“智慧监管应用分系统”；其他分系统先作为首页内容模块保留展示，不规划点击后的页面跳转。

长期目录规划仍按五个分系统组织，命名必须参照正式前端 `Integrity-Supervision-Platform-Frontend` 的现有格式。

五个分系统为：

- 数据接引采报分系统
- 数据模型分析
- 智慧监管应用分系统
- 廉政态势展示分系统
- 系统安全管理分系统

本文只规划前端文件结构和页面跳转关系，不实施迁移代码。

## 当前阶段范围确认

- 原型首页“核心监管业务”的五个模块都属于“智慧监管应用分系统”，包括：项目监督、招标采购监督、巡视整改监督、案件档案管理、监督信息管理/廉政信息管理。
- 正式前端现有的 `system`、`monitor`、`tool`、`flow` 等代码，均作为“系统安全管理分系统”的已完成能力看待，不再迁移原型中的系统安全单页。
- 下一阶段实际开发只推进“智慧监管应用分系统”。数据接引采报、数据模型分析、廉政态势展示等其他分系统当前只需要在首页保留内容模块或入口展示，不需要配置点击跳转和二级页面。
- 首页可以展示五个分系统或核心业务内容模块，但非当前开发范围的模块应保持静态展示、禁用跳转，或仅保留占位状态。

## 正式前端命名基准

正式前端现有命名风格：

```text
src/views/system/user/index.vue
src/views/system/user/authRole.vue
src/views/flow/task/done/doneList.vue
src/views/monitor/job/components/JobViewAdd.vue
src/api/system/user.js
src/api/monitor/jobNotice.js
src/store/modules/tagsView.js
```

因此迁移规划采用以下规则：

- 顶层业务目录使用小驼峰或短小写：`dataIngestion`、`dataModelAnalysis`、`smartSupervision`、`integritySituation`。系统安全管理当前沿用正式前端既有 `system`、`monitor`、`tool`、`flow`；只有后续单独立项补充缺口时，才考虑新增 `securityManagement`。
- 路由主页面使用目录加 `index.vue`，例如 `views/dataIngestion/task/index.vue`。
- 非路由子页面或详情页使用小驼峰 `.vue`，例如 `doneList.vue`、`authRole.vue` 这种风格。
- 页面内部组件放在当前模块的 `components/` 目录，组件文件可使用 PascalCase，参照 `JobViewAdd.vue`。
- API 按业务目录拆分，文件使用小驼峰，例如 `api/dataIngestion/dataSource.js`。
- 不新增 `subsystems` 这种正式前端里没有的中间大目录，避免迁入后路径过深、菜单 component 难维护。
- 文件夹和文件名不使用原型简称作为命名。

## 清晰易读结构规则

为保证迁移后长期可维护，目录结构遵守以下约束：

- **最多三层业务语义**：`分系统 / 业务域 / 功能页`。再细的 UI 片段放 `components/`，不要继续拆目录。
- **一个目录只表达一个概念**：例如 `dataIngestion/task` 只放任务管理相关内容，不混入模板、统计、监控。
- **路由页统一用 `index.vue`**：后端菜单 `component` 路径更稳定，迁移时也更容易批量检查。
- **组件就近放置**：只被某个业务域使用的组件放在该业务域 `components/`；多个业务域复用后再提升到分系统级 `components/`。
- **接口按业务域拆文件**：例如 `api/dataModelAnalysis/asset.js`，不要把一个分系统所有接口塞进单个超大文件。
- **mock 只做临时过渡**：每个分系统可以有 `mock/`，但页面优先通过 adapter/API 调用，避免 mock 深度散落在页面里。
- **避免空泛目录名**：不用 `pages`、`modules`、`common panels` 这类难判断职责的名字；必须能从目录名看出业务含义。

## 推荐总目录

以下总目录按当前开发优先级排列：先列本阶段实际开发的 `smartSupervision`，再列后续预留分系统和系统安全管理既有能力。

```text
src/
├── views/
│   ├── index.vue                         # 现有首页，保留五个分系统/核心内容模块展示
│   ├── smartSupervision/                 # 智慧监管应用分系统，当前阶段实际开发
│   ├── dataIngestion/                    # 数据接引采报分系统，后续预留
│   ├── dataModelAnalysis/                # 数据模型分析，后续预留
│   ├── integritySituation/               # 廉政态势展示分系统，后续预留
│   ├── system/                           # 系统安全管理分系统既有能力
│   ├── monitor/                          # 系统安全管理分系统既有能力
│   ├── tool/                             # 系统安全管理分系统既有能力
│   └── flow/                             # 系统安全管理分系统既有能力
├── api/
│   ├── smartSupervision/
│   ├── dataIngestion/                    # 后续预留
│   ├── dataModelAnalysis/                # 后续预留
│   ├── integritySituation/               # 后续预留
│   ├── system/                           # 系统安全管理分系统既有能力
│   ├── monitor/                          # 系统安全管理分系统既有能力
│   ├── tool/                             # 系统安全管理分系统既有能力
│   └── flow/                             # 系统安全管理分系统既有能力
├── store/
│   └── modules/
│       ├── dataIngestion.js              # 仅在确有跨页状态时新增
│       ├── dataModelAnalysis.js
│       ├── smartSupervision.js
│       └── integritySituation.js
└── assets/
    └── styles/
        ├── dataIngestion.scss
        ├── dataModelAnalysis.scss
        ├── smartSupervision.scss
        └── integritySituation.scss
```

说明：

- 新开发分系统页面优先放在 `src/views/{module}` 下，和现有 `system`、`flow`、`monitor`、`tool` 平级。
- 当前阶段只新建或迁移 `smartSupervision` 相关页面；`dataIngestion`、`dataModelAnalysis`、`integritySituation` 目录仅作为后续规划，不在本阶段创建空目录、页面和路由。
- 分系统内部复用组件放在本分系统自己的 `components/` 中，不优先放全局 `src/components`。
- 原型 mock 数据临时放入对应分系统的 `mock/` 或 `data/` 子目录，后续替换成 `src/api/{module}` 的正式接口。
- 正式生产仍建议由后端菜单返回动态路由；本地静态路由只作为开发期兜底。
- 各分系统内部采用“入口页 + 业务域目录 + 就近组件”的结构，例如 `dataModelAnalysis/asset/overview/index.vue`。

## 一、数据接引采报分系统

当前阶段只在首页保留该分系统内容模块或入口展示，不实施点击跳转、路由和页面迁移。

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

这些是同一分系统内的状态切换，不建议拆成过多顶级目录。

### 推荐结构

```text
src/views/dataIngestion/
├── index.vue
├── task/
│   └── index.vue
├── template/
│   └── index.vue
├── statistics/
│   └── index.vue
├── monitor/
│   └── index.vue
├── dataSource/
│   └── index.vue
├── aiSettings/
│   └── index.vue
├── components/
│   ├── DomainSwitch.vue
│   ├── TaskPanel.vue
│   ├── TaskDialog.vue
│   ├── TaskCategoryTree.vue
│   ├── TemplatePanel.vue
│   ├── StatisticsPanel.vue
│   ├── MonitorPanel.vue
│   ├── DataSourcePanel.vue
│   ├── ModelSettingsPanel.vue
│   └── AssistantPanel.vue
├── mock/
│   └── dataIngestionData.js
└── types.js

src/api/dataIngestion/
├── task.js
├── template.js
├── statistics.js
├── monitor.js
├── dataSource.js
└── aiSettings.js
```

### 路由建议

```text
/dataIngestion
/dataIngestion/task
/dataIngestion/template
/dataIngestion/statistics
/dataIngestion/monitor
/dataIngestion/dataSource
/dataIngestion/aiSettings
```

默认进入 `/dataIngestion/task`。数据域通过 query 或页面状态承载，例如：

```text
/dataIngestion/task?domain=business
/dataIngestion/task?domain=local
/dataIngestion/task?domain=external
```

## 二、数据模型分析

当前阶段只在首页保留该分系统内容模块或入口展示，不实施点击跳转、路由和页面迁移。

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
src/views/dataModelAnalysis/
├── index.vue
├── cleaning/
│   ├── index.vue
│   ├── task/
│   │   └── index.vue
│   ├── component/
│   │   └── index.vue
│   ├── engine/
│   │   └── index.vue
│   └── components/
│       ├── CleanTaskPanel.vue
│       ├── CleanTaskDialog.vue
│       ├── ComponentPanel.vue
│       ├── ComponentDialog.vue
│       └── EnginePanel.vue
├── asset/
│   ├── index.vue
│   ├── overview/
│   │   └── index.vue
│   ├── catalog/
│   │   └── index.vue
│   ├── assetSet/
│   │   └── index.vue
│   ├── metadata/
│   │   └── index.vue
│   ├── cataloging/
│   │   └── index.vue
│   ├── permission/
│   │   └── index.vue
│   └── topicLibrary/
│       └── index.vue
├── dataService/
│   ├── index.vue
│   ├── service/
│   │   └── index.vue
│   ├── component/
│   │   └── index.vue
│   ├── app/
│   │   └── index.vue
│   └── approval/
│       └── index.vue
├── model/
│   ├── index.vue
│   ├── management/
│   │   └── index.vue
│   ├── designer/
│   │   └── index.vue
│   ├── run/
│   │   └── index.vue
│   ├── statistics/
│   │   └── index.vue
│   └── market/
│       └── index.vue
├── settings/
│   ├── index.vue
│   ├── dataSource/
│   │   └── index.vue
│   ├── fileData/
│   │   └── index.vue
│   ├── category/
│   │   └── index.vue
│   ├── authorization/
│   │   └── index.vue
│   └── customFunction/
│       └── index.vue
├── caseBill/
│   ├── index.vue
│   ├── import/
│   │   └── index.vue
│   ├── tools/
│   │   └── index.vue
│   ├── person/
│   │   └── index.vue
│   └── bankAnalysis/
│       └── index.vue
├── report/
│   ├── index.vue
│   ├── template/
│   │   └── index.vue
│   └── generate/
│       └── index.vue
├── tools/
│   ├── index.vue
│   ├── formDesigner/
│   │   └── index.vue
│   ├── tableDesigner/
│   │   └── index.vue
│   ├── chart/
│   │   └── index.vue
│   ├── portalDesigner/
│   │   └── index.vue
│   └── ocr/
│       └── index.vue
├── components/
│   ├── SectionMenu.vue
│   ├── ToolbarActions.vue
│   └── ChartCard.vue
├── mock/
│   └── dataModelAnalysisData.js
└── types.js

src/api/dataModelAnalysis/
├── cleaning.js
├── asset.js
├── dataService.js
├── model.js
├── settings.js
├── caseBill.js
├── report.js
└── tools.js
```

说明：分系统入口 `index.vue` 负责整体布局和二级菜单；业务域入口如 `asset/index.vue` 负责该域默认跳转或概览；具体功能页仍落到 `asset/overview/index.vue` 这类稳定路径。

### 路由建议

```text
/dataModelAnalysis
/dataModelAnalysis/cleaning/task
/dataModelAnalysis/cleaning/component
/dataModelAnalysis/cleaning/engine
/dataModelAnalysis/asset/overview
/dataModelAnalysis/asset/catalog
/dataModelAnalysis/asset/assetSet
/dataModelAnalysis/asset/metadata
/dataModelAnalysis/asset/cataloging
/dataModelAnalysis/asset/permission
/dataModelAnalysis/asset/topicLibrary
/dataModelAnalysis/dataService/service
/dataModelAnalysis/dataService/component
/dataModelAnalysis/dataService/app
/dataModelAnalysis/dataService/approval
/dataModelAnalysis/model/management
/dataModelAnalysis/model/designer
/dataModelAnalysis/model/run
/dataModelAnalysis/model/statistics
/dataModelAnalysis/model/market
/dataModelAnalysis/settings/dataSource
/dataModelAnalysis/settings/fileData
/dataModelAnalysis/settings/category
/dataModelAnalysis/settings/authorization
/dataModelAnalysis/settings/customFunction
/dataModelAnalysis/caseBill/import
/dataModelAnalysis/caseBill/tools
/dataModelAnalysis/caseBill/person
/dataModelAnalysis/caseBill/bankAnalysis
/dataModelAnalysis/report/template
/dataModelAnalysis/report/generate
/dataModelAnalysis/tools/formDesigner
/dataModelAnalysis/tools/tableDesigner
/dataModelAnalysis/tools/chart
/dataModelAnalysis/tools/portalDesigner
/dataModelAnalysis/tools/ocr
```

## 三、智慧监管应用分系统

### 原型跳转逻辑

原型首页“核心监管业务”中的五个模块均归入本分系统，是下一阶段优先迁移的业务范围：

- 项目监督：归入 `smartSupervision/project`。
- 招标采购监督：归入 `smartSupervision/procurement`。
- 巡视整改监督：归入 `smartSupervision/inspection`。
- 案件档案管理：归入 `smartSupervision/caseArchive`。
- 监督信息管理/廉政信息管理：归入 `smartSupervision/integrityInfo`。

原型中智慧监管应用由顶部/左侧业务菜单驱动，`SuperviseApp` 根据 route path 切换内部组件。主要业务链为：

- 项目建设监督
- 招标采购监督
- 巡视整改监督
- 案件档案管理
- 廉政信息管理
- 实体中心
- 监督模型浮层

其中前五项对应首页“核心监管业务”五个模块，是当前阶段的实际开发重点；实体中心和监督模型浮层可作为智慧监管应用内部支撑能力，按页面需要再迁移。

原型同时存在旧版项目页面和新版项目监督页面。迁移规划中应合并到“项目建设监督”，避免重复形成两个顶级模块。

### 推荐结构

```text
src/views/smartSupervision/
├── index.vue
├── project/
│   ├── index.vue
│   ├── overview/
│   │   └── index.vue
│   ├── list/
│   │   └── index.vue
│   ├── risk/
│   │   └── index.vue
│   ├── tracking/
│   │   └── index.vue
│   ├── profile/
│   │   ├── index.vue
│   │   └── projectProfileDialog.vue
│   ├── issueHandle/
│   │   └── index.vue
│   ├── workSupervision/
│   │   └── index.vue
│   └── components/
│       ├── FlowChart.vue
│       ├── RiskAssessmentPanel.vue
│       └── ActionComplianceTable.vue
├── procurement/
│   ├── index.vue
│   ├── overview/
│   │   └── index.vue
│   ├── list/
│   │   └── index.vue
│   ├── risk/
│   │   └── index.vue
│   ├── handle/
│   │   └── index.vue
│   ├── expert/
│   │   └── index.vue
│   └── components/
├── inspection/
│   ├── index.vue
│   ├── problemImport/
│   │   └── index.vue
│   ├── rectifyPublish/
│   │   └── index.vue
│   └── rectifyAssessment/
│       └── index.vue
├── caseArchive/
│   ├── index.vue
│   ├── overview/
│   │   └── index.vue
│   ├── clueAnalysis/
│   │   └── index.vue
│   ├── search/
│   │   └── index.vue
│   └── billAnalysis/
│       └── index.vue
├── integrityInfo/
│   ├── index.vue
│   ├── basic/
│   │   └── index.vue
│   ├── personPortrait/
│   │   └── index.vue
│   ├── policy/
│   │   └── index.vue
│   ├── businessOnline/
│   │   └── index.vue
│   ├── guard/
│   │   └── index.vue
│   ├── clueHandle/
│   │   └── index.vue
│   ├── accessTrace/
│   │   └── index.vue
│   ├── riskAssessment/
│   │   └── index.vue
│   └── integrityReview/
│       └── index.vue
├── entityHub/
│   ├── index.vue
│   ├── overview/
│   │   └── index.vue
│   ├── project/
│   │   └── index.vue
│   ├── person/
│   │   └── index.vue
│   └── event/
│       └── index.vue
├── components/
│   ├── SupervisedModelDrawer.vue
│   └── SupervisedModelPanel.vue
├── mock/
│   └── smartSupervisionData.js
└── types.js

src/api/smartSupervision/
├── project.js
├── procurement.js
├── inspection.js
├── caseArchive.js
├── integrityInfo.js
├── entityHub.js
└── model.js
```

说明：每条业务链都有自己的 `index.vue`，用于承载该业务链默认页、二级导航或重定向；具体页面都用 `xxx/index.vue`，便于后端菜单稳定引用。

### 路由建议

```text
/smartSupervision
/smartSupervision/project/overview
/smartSupervision/project/list
/smartSupervision/project/risk
/smartSupervision/project/tracking
/smartSupervision/project/profile/:projectId
/smartSupervision/project/issueHandle
/smartSupervision/project/workSupervision
/smartSupervision/procurement/overview
/smartSupervision/procurement/list
/smartSupervision/procurement/risk
/smartSupervision/procurement/handle
/smartSupervision/procurement/expert
/smartSupervision/inspection/problemImport
/smartSupervision/inspection/rectifyPublish
/smartSupervision/inspection/rectifyAssessment
/smartSupervision/caseArchive/overview
/smartSupervision/caseArchive/clueAnalysis
/smartSupervision/caseArchive/search
/smartSupervision/caseArchive/billAnalysis
/smartSupervision/integrityInfo/basic
/smartSupervision/integrityInfo/personPortrait
/smartSupervision/integrityInfo/policy
/smartSupervision/integrityInfo/businessOnline
/smartSupervision/integrityInfo/guard
/smartSupervision/entityHub/overview
/smartSupervision/entityHub/project/:projectId
/smartSupervision/entityHub/person/:personId
/smartSupervision/entityHub/event
```

## 四、廉政态势展示分系统

当前阶段只在首页保留该分系统内容模块或入口展示，不实施点击跳转、路由和页面迁移。

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
src/views/integritySituation/
├── index.vue
├── overview/
│   └── index.vue
├── rectification/
│   └── index.vue
├── query/
│   └── index.vue
├── alert/
│   └── index.vue
├── task/
│   └── index.vue
├── components/
│   ├── SituationHeader.vue
│   ├── SituationTabs.vue
│   ├── SituationStatusBar.vue
│   ├── OverviewPanel.vue
│   ├── RectificationPanel.vue
│   ├── QueryPanel.vue
│   ├── AlertCenterPanel.vue
│   └── SuperviseTaskPanel.vue
├── mock/
│   └── integritySituationData.js
└── types.js

src/api/integritySituation/
├── overview.js
├── rectification.js
├── query.js
├── alert.js
└── task.js
```

### 路由建议

```text
/integritySituation
/integritySituation/overview
/integritySituation/rectification
/integritySituation/query
/integritySituation/alert
/integritySituation/task
```

内部 tab 应同步到路由，便于刷新、收藏和后端菜单定位。

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

正式前端已经有系统管理、监控、文件、流程、代码生成等模块，并且后端也已有对应接口。当前正式前端代码都归入“系统安全管理分系统”，并视为已开发完毕；迁移时应以正式前端现有结构为准，不再把原型 `SystemSecurity` 单页整体搬入。

### 推荐结构

保留正式前端现有结构，不新增系统安全管理目录：

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

src/views/flow/
├── definition/
├── notice/
└── task/

src/api/system/
src/api/monitor/
src/api/tool/
└── gen.js

src/api/flow/
├── definition.js
└── execute.js
```

当前阶段不新增 `securityManagement` 目录，也不补迁系统安全相关原型页面。如后续发现正式前端确有缺口，再单独立项评估。

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
/flow/definition
/flow/task
/flow/notice
```

当前阶段不新增系统安全管理路由。

## 公共能力规划

跨分系统共享能力尽量先模块内局部复用，确认多个分系统都用到后，再提升到全局组件。正式前端已有全局组件目录，应遵守现有 PascalCase 目录风格：

```text
src/components/
├── ChartPanel/
├── RiskTag/
├── StatusBadge/
├── QueryForm/
└── WorkflowViewer/
```

临时 mock 和适配层建议先放在各分系统内部：

```text
src/views/dataIngestion/mock/
src/views/dataModelAnalysis/mock/
src/views/smartSupervision/mock/
src/views/integritySituation/mock/
```

后续正式接口稳定后，页面统一改为调用：

```text
src/api/dataIngestion/
src/api/dataModelAnalysis/
src/api/smartSupervision/
src/api/integritySituation/
```

原型中的 `dataCollection`、`dataAnalysis`、`dataSupervision`、态势聚合服务建议迁移为各分系统内部临时 adapter，不直接进入页面：

- 数据接引采报：提供原始数据和接入任务。
- 数据模型分析：提供清洗、资产、模型、分析结果。
- 智慧监管应用：消费原始数据和模型结果，产生处置结果。
- 廉政态势展示：聚合前三个分系统的数据，只读展示。

## 后端动态菜单 component 建议

正式前端动态菜单的 `component` 路径应指向 `src/views` 下相对路径，例如：

```text
dataIngestion/task/index
dataModelAnalysis/asset/overview/index
smartSupervision/project/overview/index
integritySituation/overview/index
system/user/index
```

以上示例包含长期规划路径；第一阶段只配置 `smartSupervision` 相关路径和正式前端既有系统安全管理路径。

其中系统安全管理已有页面继续使用现有路径，不强行搬到 `securityManagement`。

## 第一阶段建议落地范围

第一阶段从“首页内容模块 + 智慧监管应用分系统”开始，不再做五个分系统的可点击入口骨架。其他分系统只在首页 `src/views/index.vue` 中保留静态展示内容，不单独创建占位目录，不配置跳转和二级页面。

```text
src/views/index.vue                         # 包含五个分系统/核心内容模块静态展示，非当前范围模块不跳转
src/views/smartSupervision/index.vue
src/views/smartSupervision/project/index.vue
src/views/smartSupervision/procurement/index.vue
src/views/smartSupervision/inspection/index.vue
src/views/smartSupervision/caseArchive/index.vue
src/views/smartSupervision/integrityInfo/index.vue
src/api/smartSupervision/
```

验收目标：

- 正式前端登录后能看到五个分系统或核心内容模块展示。
- 数据接引采报、数据模型分析、廉政态势展示等非当前开发模块仅展示，不配置点击跳转。
- 原型首页“核心监管业务”五个模块全部落入 `smartSupervision` 下的清晰目录。
- 系统安全管理继续复用正式前端现有 `system`、`monitor`、`tool`、`flow` 等路径，不新增 `securityManagement`。
- 如配置后端菜单，`component` 路径和正式前端 `smartSupervision` 文件路径一致。
- `npm run build:prod` 通过。

## 已确认结论

1. 原型首页“核心监管业务”五个模块归入“智慧监管应用分系统”。
2. 正式前端当前代码归入“系统安全管理分系统”，并且该分系统已开发完毕。
3. 下一阶段只开发“智慧监管应用分系统”；其他分系统暂不考虑点击后的页面跳转，只在首页保留内容模块展示。
4. 第一阶段首页展示五个分系统或核心业务内容模块；非智慧监管应用分系统的模块只做静态展示，不单独创建占位页面。
5. 分系统名称当前统一采用“数据接引采报分系统”，不再使用“引接”作为目录或路由命名依据。
6. 系统安全管理继续复用正式前端现有 `system`、`monitor`、`tool`、`flow` 目录，不新增 `securityManagement`。
