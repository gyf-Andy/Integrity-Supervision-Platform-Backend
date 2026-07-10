## 问题
IntegrityFlowApplication 启动报: Failed to configure a DataSource: 'url' attribute is not specified and no embedded datasource could be configured. Reason: Failed to determine a suitable driver class

## 根因
4 个 bootstrap.yml 的数据源 url 中 schema 段使用了无默认值的占位符 `schema=${DM_DATABASE}`。当 DM_DATABASE 环境变量未设置时, Spring 占位符解析失败, 导致 spring.datasource.url 整体无法解析为有效值, DataSourceAutoConfiguration 拿不到 url -> 报 "url not specified"。
- 此前迁移达梦时把 `schema=${DM_SCHEMA:SYSDBA}` 改成 `schema=${DM_DATABASE}`, 意图让 schema 跟库名一致, 但漏掉了默认值, 引入此隐患。
- flow 模块用原生 spring.datasource(非 dynamic-datasource), 直接受影响; system/gen/job 用 dynamic-datasource, 数据源来自 Nacos 的 spring.datasource.dynamic.druid.datasource.master.url(写死), 未触发, 故之前未暴露。

## 变更
4 个 bootstrap.yml 的 schema 占位符恢复带默认值:
- integrity-flow: `schema=${DM_SCHEMA:INTEGRITY-CLOUD-FLOW}`
- integrity-system / integrity-gen / integrity-job: `schema=${DM_SCHEMA:INTEGRITY-CLOUD}`
url 主体里的 `${DM_DATABASE:INTEGRITY-CLOUD-FLOW}` / `${DM_DATABASE:INTEGRITY-CLOUD}` 保留(本就有默认值)。

## 验证
- mvn spring-boot:run integrity-flow: 启动成功, "Started IntegrityFlowApplication in 9.259 seconds"
- 日志确认 Nacos 加载 integrity-flow-dev.yml(datasource driver=dm.jdbc.driver.DmDriver, url=jdbc:dm://localhost:5236/INTEGRITY-CLOUD-FLOW?schema=INTEGRITY-CLOUD-FLOW)
- HikariPool 成功连接达梦: Added connection dm.jdbc.driver.DmdbConnection, Start completed
- 订阅 integrity-flow / integrity-flow-dev.yml / integrity-flow.yml 三个 Nacos 配置成功

## 风险
- 无新增风险; schema 默认值与库名一致, 符合达梦 schema=INTEGRITY-CLOUD-FLOW / INTEGRITY-CLOUD 的实际结构(已 JDBC 实测 ALL_TABLES owner=INTEGRITY-CLOUD 等)。
- 若部署时通过 DM_SCHEMA 环境变量指定不同 schema, 仍可覆盖默认值。
