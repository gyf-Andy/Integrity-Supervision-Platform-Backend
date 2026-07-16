请在此处放置您的 Nacos 版本所需的 Nacos 数据源插件和数据库驱动程序。

对于以达梦数据库为后端的 Nacos 配置存储，Nacos 镜像必须包含：

- 一个类型为 `dm` 的 Nacos 数据源插件
- 达梦 JDBC 驱动程序，例如 `DmJdbcDriver18`

此目录下的文件会被 `docker/docker-compose.infra.yml` 挂载到 `/home/nacos/plugins/`。
