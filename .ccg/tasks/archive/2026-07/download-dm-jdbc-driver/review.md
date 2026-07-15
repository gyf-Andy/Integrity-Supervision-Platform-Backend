# Review

- 下载目标：`docker/nacos/plugins/DmJdbcDriver18-8.1.3.140.jar`
- Maven 坐标：`com.dameng:DmJdbcDriver18:8.1.3.140`
- 校验结果：jar 内包含 `dm/jdbc/driver/DmDriver.class`，匹配 Nacos 配置 `db.pool.config.driverClassName=dm.jdbc.driver.DmDriver`。
- SHA256：`9AF4FF4D6ED15948507F528A18AB9B7196B3600D9169AD7998C19869031A3C6F`
- 风险：低。仅新增驱动文件，未修改业务代码或配置。
