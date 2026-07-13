Place the Nacos datasource plugin and database driver required by your Nacos version here.

For Dameng-backed Nacos configuration storage, the Nacos image must have:

- a Nacos datasource plugin whose type is `dm`
- the Dameng JDBC driver, for example `DmJdbcDriver18`

The files in this directory are copied to `/home/nacos/plugins/` by `docker/nacos/dockerfile`.
