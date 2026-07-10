## 变更内容
文件: D:\enviroment\nacos-server-3.2.2\nacos\conf\application.properties
备份: D:\enviroment\nacos-server-3.2.2\nacos\conf\application.properties.bak-20260710-dameng

将尾部数据源从 MySQL 替换为达梦(DM):
```properties
# db dameng
spring.datasource.platform=dm
spring.sql.init.platform=dm
db.num=1
db.pool.config.driverClassName=dm.jdbc.driver.DmDriver
db.url.0=jdbc:dm://localhost:5236/INTEGRITY-CONFIG?schema=SYSDBA
db.user=SYSDBA
db.password=IntegritySupervision0
```

## 关键前置依赖(Critical)
Nacos 3.2.2 默认 plugins 目录目前没有达梦支持，必须手动放入以下两个 jar，否则 Nacos 无法启动/连接达梦:
1. nacos-datasource-plugin-dm 对应版本插件 jar(达梦数据源插件)
2. DmJdbcDriver18.jar(达梦 JDBC 驱动)

放置目录: D:\enviroment\nacos-server-3.2.2\nacos\plugins

当前 plugins 目录只有 derby/mysql/oracle/postgresql 数据源插件和对应驱动，缺达梦。

## 假设
- 达梦库已创建 schema INTEGRITY-CONFIG(由原 mysql 库 integrity-config 对应)
- 达梦实例监听本机 5236 端口

## 审查
风险: high(数据库配置)。变更仅 8 行配置，范围受限。外部文件不纳入 git。antigravity wrapper 在本机 PATH 不可用，未跑双模型外部审查；已做自审，主要风险即上述缺失的达梦插件 jar。
