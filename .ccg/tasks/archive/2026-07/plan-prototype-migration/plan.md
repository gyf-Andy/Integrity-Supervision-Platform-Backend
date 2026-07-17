# 原型整体迁移到正式前端计划

## 目标判断

当前正式前后端已有的整体页面和功能，基本对应原型项目中的“系统管理”。因此迁移时不要把原型的 `SystemSecurity.vue` 当作新主系统重复迁入，而应把它作为正式前端现有 `system/monitor/flow/tool` 能力的参考。

迁移重点是把原型中的业务应用层整体引入正式前端：

- 首页/总览：`overview`、`Dashboard.vue`
- 数据引接采报：`DataAccess.vue`、`dataAccess/*`
- 数据管理：`dataManage/*`
- 数据模型分析：`DataModel.vue`、`dataModel/*`
- 智慧监管应用：`SuperviseApp.vue`、`superviseApp/*`
- 监督态势展示：原型态势展示入口、`situationDisplay/*`
- 工具型页面：`ModelDesigner.vue`、`BillAnalysis.vue`
- 原型公共布局/业务组件：`AppLayout.vue`、`SupervisedModelPanel.vue`
- 原型 mock/service/type/shared/data：`services/*`、`data/*`、`shared/*`、`types/*`

## 总体策略

采用“命名空间隔离 + 分阶段接入”的迁移方式。

正式前端是 JS 工程，原型是 TS 工程。第一阶段不要为了迁移一次性把正式前端改成 TypeScript 工程，避免扩大风险；优先把原型 `.vue` 中的 `lang="ts"` 与 `.ts` 服务层按可控范围转为 JS，或先保留 TS 并补齐 Vite/tsconfig 支撑。推荐保守方案是：页面先 JS 化迁入，后续再评估全量 TS。

## 推荐目录结构

在正式前端中新增独立命名空间，避免污染现有 `system/flow/monitor/tool`：

```text
src/
├── views/
│   └── supervision/
│       ├── overview/
│       │   └── index.vue
│       ├── data-access/
│       │   ├── index.vue
│       │   └── panels/
│       ├── data-manage/
│       │   ├── index.vue
│       │   └── panels/
│       ├── data-model/
│       │   ├── index.vue
│       │   ├── asset/
│       │   ├── case-bill/
│       │   ├── cleaning/
│       │   ├── data-service/
│       │   ├── model/
│       │   ├── report/
│       │   └── tools/
│       ├── supervise-app/
│       │   ├── index.vue
│       │   ├── case/
│       │   ├── entity-hub/
│       │   ├── inspection/
│       │   ├── integrity-info/
│       │   ├── integrity-work/
│       │   ├── procurement/
│       │   ├── project/
│       │   └── project-supervision/
│       ├── situation-display/
│       │   ├── index.vue
│       │   ├── overview/
│       │   └── tabs/
│       └── tools/
│           ├── model-designer.vue
│           └── bill-analysis.vue
├── components/
│   └── supervision/
│       ├── SupervisionAppLayout.vue
│       └── SupervisedModelPanel.vue
├── api/
│   └── supervision/
│       ├── dataAccess.js
│       ├── dataModel.js
│       ├── dataSupervision.js
│       ├── situation.js
│       └── llm.js
├── services/
│   └── supervision/
│       ├── mock/
│       └── adapters/
├── data/
│   └── supervision/
├── types/
│   └── supervision/
└── assets/
    └── styles/
        └── supervision.scss
```

说明：

- `src/views/supervision` 是迁移边界，后端菜单 `component` 可配置为 `supervision/data-access/index` 这类路径。
- `src/components/supervision` 放原型跨模块复用组件，不放到全局 `components` 根目录。
- `src/services/supervision/mock` 暂存原型 mock 数据服务，后续逐步替换为 `src/api/supervision` 真实接口。
- `src/data/supervision` 暂存静态 mock 数据；长期应减少直接依赖。
- `src/assets/styles/supervision.scss` 放原型样式的隔离入口，避免直接覆盖正式前端全局样式。

## 路由与菜单策略

正式前端的大部分菜单来自后端 `getRouters`，所以迁移后不建议只在 `src/router/index.js` 写静态路由。

建议：

1. 保留正式前端现有 `system/flow/monitor/tool` 菜单，作为“系统管理/基础管理”模块。
2. 在后端菜单中新增一级业务菜单：
   - 数字化廉政监督
   - 数据引接采报
   - 数据管理
   - 数据模型分析
   - 智慧监管应用
   - 监督态势展示
3. 菜单 `component` 指向 `src/views/supervision/**` 下的组件路径。
4. 原型内部顶部导航 `AppLayout.vue` 不应直接替换正式前端 `layout/index.vue`。更推荐作为 `SupervisionAppLayout.vue` 用在业务域首页/沉浸式页面中；普通管理页继续使用正式前端侧边栏 + tagsView。

## 分阶段实施

### Phase 1：迁移准备

- 清理原型中的 `node_modules`、`._*`、临时预览文件，不迁入正式前端。
- 梳理原型页面清单、依赖清单、公共组件清单。
- 确认是否保留 TypeScript：推荐第一版 JS 化迁移，除非正式前端同意引入 TS 构建。
- 建立 `views/supervision`、`components/supervision`、`services/supervision`、`data/supervision` 等目录。

### Phase 2：基础可编译迁入

- 迁入公共样式，改为 `supervision.scss` 并只在监督业务入口组件中引用。
- 迁入 `AppLayout.vue` 为 `components/supervision/SupervisionAppLayout.vue`，调整路由跳转路径。
- 迁入原型公共类型/数据/mock service，先放在 `services/supervision/mock` 与 `data/supervision`。
- 迁入核心入口页：`overview/index.vue`、`data-access/index.vue`、`data-model/index.vue`、`supervise-app/index.vue`、`situation-display/index.vue`。
- 先跑 `npm run build:prod`，解决编译层问题。

### Phase 3：模块逐块迁移

按依赖和业务优先级迁移：

1. 首页/总览与态势展示：最适合快速验证视觉和 ECharts。
2. 数据引接采报：涉及 localStorage/mock service，改造成本中等。
3. 数据模型分析/数据管理：页面多，按 panel 逐个迁。
4. 智慧监管应用：最大模块，按 project/procurement/inspection/case/integrity-info/entity-hub 分包迁。
5. 工具页面：模型设计器、账单分析，最后处理交互细节。

每迁一个模块都跑一次构建，避免最后一次性爆雷。

### Phase 4：接入正式权限与菜单

- 后端菜单新增业务模块，配置 component 路径和权限标识。
- 前端按钮权限逐步替换为 `v-hasPermi` / `auth.hasPermi`。
- 原型里的硬编码“管理员/系统管理员/退出登录”改为正式 user store 和 logout 逻辑。
- 原型里独立登录页不迁入或仅保留为参考，正式登录继续使用当前 `src/views/login.vue`。

### Phase 5：mock 到 API 的适配层

- 先保留 mock service，使页面迁入后可运行。
- 对每个 service 建立对应 `src/api/supervision/*.js`。
- 页面不要直接依赖 mock；统一经 adapter：
  - 开发早期：adapter 调 mock。
  - 后端接口完成后：adapter 切换到 request。
- LLM 直连浏览器的逻辑不要原样产品化，改为后端代理接口，避免 API Key 存 localStorage。

### Phase 6：样式与体验收口

- 解决原型 `body overflow: hidden`、全屏布局与正式后台 layout 的冲突。
- ECharts 图表统一封装 resize/dispose，避免 tagsView 切换后尺寸错误或内存泄露。
- 统一 Element Plus 版本差异，正式前端是 `2.4.3`，原型是 `^2.4.4`，先不升级正式依赖。
- 统一图标导入方式，使用正式前端已有 Element Plus Icons/SvgIcon 体系。

### Phase 7：验证

- `npm run build:prod`
- `npm run dev` 页面巡检。
- 登录、刷新、动态菜单、tagsView、权限按钮巡检。
- 核心页面视觉巡检：桌面宽屏、1366 宽度、移动窄屏至少不破版。
- 检查控制台报错、路由 404、chunk 加载、图表 resize。

## 不建议的做法

- 不建议把原型 `src/views/*` 直接平铺到正式前端 `src/views` 根目录。
- 不建议直接替换正式前端 `layout/index.vue`。
- 不建议迁入原型 `Login.vue` 覆盖正式登录。
- 不建议一开始就把 mock 数据全部删掉并强接真实接口。
- 不建议在浏览器端保存真实 LLM API Key。

## 建议第一批落地范围

第一批迁移只做“壳 + 可见主页面”：

- `src/views/supervision/overview/index.vue`
- `src/views/supervision/data-access/index.vue`
- `src/views/supervision/data-model/index.vue`
- `src/views/supervision/supervise-app/index.vue`
- `src/views/supervision/situation-display/index.vue`
- `src/components/supervision/SupervisionAppLayout.vue`
- `src/services/supervision/mock/*`
- `src/data/supervision/*`

目标是先能登录正式前端，通过后端菜单进入原型业务模块，并完成生产构建。后续再逐块迁子页面和真实接口。
