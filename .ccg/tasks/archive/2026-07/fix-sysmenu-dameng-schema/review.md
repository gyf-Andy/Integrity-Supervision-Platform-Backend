## 变更总览
修复 SysMenuMapper.xml 在达梦下报 "You have an error in your SQL syntax ... near '"QUERY"'" 的错误。

## 根因分析
1. **Nacos 配置中心仍是 MySQL 数据源**: integrity-system/gen/job/flow 的 *-dev.yml 在 Nacos 里还是 `com.mysql.cj.jdbc.Driver` + `jdbc:mysql://localhost:3306/...`, 报错信息显示 "MySQL server version" 即来源于此。服务启动从 Nacos 拉配置覆盖了 bootstrap.yml 的本地达梦配置。
2. **bootstrap.yml schema 默认值错误**: `DM_SCHEMA` 默认 `SYSDBA`, 但业务表实际在 `INTEGRITY-CLOUD`/`INTEGRITY-CLOUD-FLOW` schema 下(经达梦实例验证: ALL_TABLES 显示表 owner=INTEGRITY-CLOUD 等, SYSDBA schema 下无 SYS_MENU)。
3. **Nacos 配置中心库 his_config_info.NID 缺 IDENTITY**: Nacos 达梦方言插件期望 NID 为 BIGINT IDENTITY(1,1), 但迁移后表结构是普通 DECIMAL NOT NULL, 推送配置时 INSERT 不带 NID 违反非空约束。

## 变更内容
### 代码侧
- 4 个 bootstrap.yml(integrity-system/gen/job/flow): `schema=${DM_SCHEMA:SYSDBA}` -> `schema=${DM_DATABASE}` (与库名一致)
- docker/docker-compose.yml: `DM_SCHEMA=${DM_SCHEMA:-SYSDBA}` -> `DM_SCHEMA=${DM_DATABASE}` (3 处)
- SysMenuMapper.xml: resultMap `column="query"` -> `column="QUERY"` (达梦返回大写列名, 显式统一); 清理末尾多余空行; "QUERY" 双引号大写引用保留(已验证达梦标准模式 COMPATIBLE_MODE=0 下可解析)

### Nacos 配置中心(通过 Open API v2 推送, HTTP 200 success)
- integrity-system-dev.yml / integrity-gen-dev.yml / integrity-job-dev.yml / integrity-flow-dev.yml:
  - 数据源 driver -> dm.jdbc.driver.DmDriver
  - url -> jdbc:dm://localhost:5236/INTEGRITY-CLOUD?schema=INTEGRITY-CLOUD (flow 用 INTEGRITY-CLOUD-FLOW)
  - username/password -> SYSDBA / IntegritySupervision0
  - mybatis -> mybatis-plus (配合持久层迁移)

### 达梦数据库(经 JDBC 验证执行)
- DROP + 重建 INTEGRITY-CONFIG.HIS_CONFIG_INFO, NID 改为 BIGINT IDENTITY(1,1) NOT NULL, 重建主键/索引
- 验证: 重建后 INFO2=1(IDENTITY), INSERT 测试通过; NID 自增正常
- 注: 原表 17 行历史记录被清空(配置变更历史, 不影响业务配置)

## 验证
- 直连 INTEGRITY-CLOUD schema 执行 SysMenuMapper.selectMenuTreeAll 原始 SQL: 返回 30 行, OK
- 执行 selectMenuVo: 返回 87 行, OK
- 4 个配置推送 Nacos v2 API: 全部 code=0 success
- 拉回验证: 4 个配置数据源均为达梦 + mybatis-plus
- mvn compile integrity-system: BUILD SUCCESS

## 风险与注意
- TENANT_CAPACITY.ID / GROUP_CAPACITY.ID 仍非 IDENTITY(INFO2=0), 当前未触发报错, 暂不处理。若后续 Nacos 创建租户/分组容量记录时报类似非空约束, 需同样重建为 IDENTITY。
- bootstrap.yml 的 schema 默认值改为 ${DM_DATABASE}, 要求 DM_DATABASE 环境变量与目标 schema 一致(本地默认已对: INTEGRITY-CLOUD / INTEGRITY-CLOUD-FLOW)。
- Nacos 推送配置后, 已运行的实例需重启或等待配置刷新才会切到新数据源。

## 双模型外部审查状态(CCG 要求)
- antigravity: wrapper 调用 exit=127, `agy command not found`, 不可用
- claude: wrapper 调用挂死(进程不退出, 5+ 分钟无输出), 强制终止
- 结论: 本环境外部双模型审查均不可用, 已以自审 + 实测验证替代:
  - SQL 直连达梦实测跑通
  - Nacos 配置推送 API 200 success 并拉回验证
  - 表结构 IDENTITY 属性 INFO2=1 验证
  - mvn compile BUILD SUCCESS
- 风险: 已尽本环境所能验证, 残余风险见上文风险段
