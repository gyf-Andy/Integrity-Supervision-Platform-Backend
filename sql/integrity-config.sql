/*
 Navicat Premium Data Transfer

 Source Server         : 本地数据库
 Source Server Type    : MySQL
 Source Server Version : 80032
 Source Host           : localhost:3306
 Source Schema         : integrity-config

 Target Server Type    : MySQL
 Target Server Version : 80032
 File Encoding         : 65001

 Date: 09/07/2026 10:21:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_resource
-- ----------------------------
DROP TABLE IF EXISTS `ai_resource`;
CREATE TABLE `ai_resource`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源名称',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源类型',
  `c_desc` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资源描述',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资源状态',
  `namespace_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '命名空间ID',
  `biz_tags` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务标签',
  `ext` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '扩展信息(JSON)',
  `c_from` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local' COMMENT '来源标识(导入/同步来源)',
  `version_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '版本信息(JSON)',
  `meta_version` bigint(0) NOT NULL DEFAULT 1 COMMENT '元数据版本(乐观锁)',
  `scope` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PRIVATE' COMMENT '可见性: PUBLIC/PRIVATE',
  `owner` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '创建者用户名',
  `download_count` bigint(0) NOT NULL DEFAULT 0 COMMENT '下载次数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ai_resource_ns_name_type`(`namespace_id`, `name`, `type`, `c_from`) USING BTREE,
  INDEX `idx_ai_resource_name`(`name`) USING BTREE,
  INDEX `idx_ai_resource_type`(`type`) USING BTREE,
  INDEX `idx_ai_resource_gmt_modified`(`gmt_modified`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI资源元数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ai_resource_version
-- ----------------------------
DROP TABLE IF EXISTS `ai_resource_version`;
CREATE TABLE `ai_resource_version`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源类型',
  `author` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '作者',
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源名称',
  `c_desc` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '版本描述',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '版本状态',
  `version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '版本号',
  `namespace_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '命名空间ID',
  `storage` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '存储信息(JSON)',
  `publish_pipeline_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '发布流水线信息(JSON)',
  `download_count` bigint(0) NOT NULL DEFAULT 0 COMMENT '下载次数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ai_resource_ver_ns_name_type_ver`(`namespace_id`, `name`, `type`, `version`) USING BTREE,
  INDEX `idx_ai_resource_ver_name`(`name`) USING BTREE,
  INDEX `idx_ai_resource_ver_status`(`status`) USING BTREE,
  INDEX `idx_ai_resource_ver_gmt_modified`(`gmt_modified`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI资源版本表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for config_info
-- ----------------------------
DROP TABLE IF EXISTS `config_info`;
CREATE TABLE `config_info`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'group_id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'app_name',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration description',
  `c_use` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration usage',
  `effect` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置生效的描述',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置的类型',
  `c_schema` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配置的模式',
  `encrypted_data_key` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密钥',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfo_datagrouptenant`(`data_id`, `group_id`, `tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'config_info' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info
-- ----------------------------
INSERT INTO `config_info` VALUES (1, 'application-dev.yml', 'DEFAULT_GROUP', 'spring:\n  autoconfigure:\n    exclude: com.alibaba.druid.spring.boot3.autoconfigure.DruidDataSourceAutoConfigure\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: 127.0.0.1:8718\n\nfeign:\n  sentinel:\n    enabled: true\n  okhttp:\n    enabled: true\n  httpclient:\n    enabled: false\n  client:\n    config:\n      default:\n        connectTimeout: 10000\n        readTimeout: 10000\n  compression:\n    request:\n      enabled: true\n      min-request-size: 8192\n    response:\n      enabled: true\n\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \'*\'', 'e642125240036db04cb4599be10c1550', '2020-05-20 12:00:00', '2026-07-08 21:27:35', 'nacos_namespace_migrate', '127.0.0.1', '', '', '通用配置', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (2, 'integrity-gateway-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  cloud:\n    gateway:\n      discovery:\n        locator:\n          lowerCaseServiceId: true\n          enabled: true\n      routes:\n        - id: integrity-auth\n          uri: lb://integrity-auth\n          predicates:\n            - Path=/auth/**\n          filters:\n            - name: CacheRequestBody\n              args:\n                bodyClass: java.lang.String\n            - ValidateCodeFilter\n            - StripPrefix=1\n        - id: integrity-gen\n          uri: lb://integrity-gen\n          predicates:\n            - Path=/code/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-job\n          uri: lb://integrity-job\n          predicates:\n            - Path=/schedule/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-flow\n          uri: lb://integrity-flow\n          predicates:\n            - Path=/flow/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-system\n          uri: lb://integrity-system\n          predicates:\n            - Path=/system/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-file\n          uri: lb://integrity-file\n          predicates:\n            - Path=/file/**\n          filters:\n            - StripPrefix=1\n\nsecurity:\n  captcha:\n    enabled: true\n    type: math\n  xss:\n    enabled: true\n    excludeUrls:\n      - /system/notice\n  ignore:\n    whites:\n      - /auth/logout\n      - /auth/login\n      - /auth/register\n      - /flow/warm-flow-ui/**\n      - /*/v2/api-docs\n      - /*/v3/api-docs\n      - /csrf\n\nspringdoc:\n  webjars:\n    prefix:\n', '0bb97abfe7ed7925df7db59e4f4d1bde', '2020-05-14 14:17:55', '2026-07-08 00:52:40', 'nacos_namespace_migrate', '127.0.0.1', '', '', '网关模块', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (3, 'integrity-auth-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n', '72565b1a725e013154ee57c8fd3045c4', '2020-11-20 00:00:00', '2024-09-14 04:49:42', 'nacos', '0:0:0:0:0:0:0:1', '', '', '认证中心', 'null', 'null', 'yaml', '', '');
INSERT INTO `config_info` VALUES (4, 'integrity-monitor-dev.yml', 'DEFAULT_GROUP', '# spring\nspring:\n  security:\n    user:\n      name: admin\n      password: 123456\n  boot:\n    admin:\n      ui:\n        title: 廉政监管平台服务监控\n', 'e62adf3893e0e0138a01292a39c004b9', '2020-11-20 00:00:00', '2026-07-09 09:48:51', 'fix_monitor_encoding', '0:0:0:0:0:0:0:1', '', '', '监控中心', 'null', 'null', 'yaml', '', '');
INSERT INTO `config_info` VALUES (5, 'integrity-system-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=5000\n      datasource:\n          master:\n            driver-class-name: dm.jdbc.driver.DmDriver\n            url: ${DB_URL:jdbc:dm://${DM_HOST:localhost}:${DM_PORT:5236}/INTEGRITY-CLOUD?schema=${DM_SCHEMA:SYSDBA}}\n            username: ${DB_USERNAME:${DM_USERNAME:SYSDBA}}\n            password: ${DB_PASSWORD:${DM_PASSWORD:IntegritySupervision0}}\n\nmybatis-plus:\n  type-aliases-package: com.integrity.system\n  mapper-locations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: System API\n    description: System API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', 'de7c09a2c6e0d224cacb3f30be78b802', '2020-11-20 00:00:00', '2026-07-08 15:53:54', 'fix_system_encoding', '192.168.1.12', '', '', '系统模块', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (6, 'integrity-gen-dev.yml', 'DEFAULT_GROUP', '# spring配置\nspring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n  datasource:\n    driver-class-name: dm.jdbc.driver.DmDriver\n    url: ${DB_URL:jdbc:dm://${DM_HOST:localhost}:${DM_PORT:5236}/INTEGRITY-CLOUD?schema=${DM_SCHEMA:SYSDBA}}\n    username: ${DB_USERNAME:${DM_USERNAME:SYSDBA}}\n    password: ${DB_PASSWORD:${DM_PASSWORD:IntegritySupervision0}}\n\n# mybatis-plus配置\nmybatis-plus:\n    # 搜索指定包别名\n    type-aliases-package: com.integrity.gen.domain\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapper-locations: classpath:mapper/**/*.xml\n\n# springdoc配置\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    # 是否开启接口文档\n    enabled: true\n  info:\n    # 标题\n    title: \'代码生成接口文档\'\n    # 描述\n    description: \'代码生成接口描述\'\n    # 作者信息\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\n# 代码生成\ngen:\n  # 作者\n  author: integrity\n  # 默认生成包路径 system 需改成自己的模块名称 如 system monitor tool\n  packageName: com.integrity.system\n  # 自动去除表前缀，默认是false\n  autoRemovePre: false\n  # 表前缀（生成类名不会包含表前缀，多个用逗号分隔）\n  tablePrefix: sys_\n  # 是否允许生成文件覆盖到本地（自定义路径），默认不允许\n  allowOverwrite: false', '84f9f0a0b44a5aa685d1c49d07b078fc', '2020-11-20 00:00:00', '2024-12-25 08:39:25', 'nacos', '0:0:0:0:0:0:0:1', '', '', '代码生成', 'null', 'null', 'yaml', '', '');
INSERT INTO `config_info` VALUES (7, 'integrity-job-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  datasource:\n    driver-class-name: dm.jdbc.driver.DmDriver\n    url: ${DB_URL:jdbc:dm://${DM_HOST:localhost}:${DM_PORT:5236}/INTEGRITY-CLOUD?schema=${DM_SCHEMA:SYSDBA}}\n    username: ${DB_USERNAME:${DM_USERNAME:SYSDBA}}\n    password: ${DB_PASSWORD:${DM_PASSWORD:IntegritySupervision0}}\n\nmybatis-plus:\n  type-aliases-package: com.integrity.job.domain\n  mapper-locations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: Job API\n    description: Job API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', 'f98a6eb63954f1ae14bb23061f6b5f39', '2020-11-20 00:00:00', '2026-07-08 12:50:38', 'fix_job_encoding', '192.168.206.196', '', '', '定时任务', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (8, 'integrity-file-dev.yml', 'DEFAULT_GROUP', '# 本地文件上传    \nfile:\n    domain: http://127.0.0.1:9300\n    path: D:/integrity-supervision/uploadPath\n    prefix: /statics\n\n# FastDFS配置\nfdfs:\n  domain: http://127.0.0.1\n  soTimeout: 3000\n  connectTimeout: 2000\n  trackerList: 127.0.0.1:22122\n\n# Minio配置\nminio:\n  url: http://127.0.0.1:9000\n  accessKey: minioadmin\n  secretKey: minioadmin\n  bucketName: test\n\n  # 防盗链配置\nreferer:\n  # 防盗链开关\n  enabled: false\n  # 允许的域名列表\n  allowed-domains: localhost,127.0.0.1,integrity-supervision-platform.local\n', '095791a04211d6e3d294359b21357394', '2020-11-20 00:00:00', '2025-09-02 05:10:11', 'nacos', '0:0:0:0:0:0:0:1', '', '', '文件服务', 'null', 'null', 'yaml', '', '');
INSERT INTO `config_info` VALUES (9, 'sentinel-integrity-gateway', 'DEFAULT_GROUP', '[\r\n    {\r\n        \"resource\": \"integrity-auth\",\r\n        \"count\": 500,\r\n        \"grade\": 1,\r\n        \"limitApp\": \"default\",\r\n        \"strategy\": 0,\r\n        \"controlBehavior\": 0\r\n    },\r\n	{\r\n        \"resource\": \"integrity-system\",\r\n        \"count\": 1000,\r\n        \"grade\": 1,\r\n        \"limitApp\": \"default\",\r\n        \"strategy\": 0,\r\n        \"controlBehavior\": 0\r\n    },\r\n	{\r\n        \"resource\": \"integrity-gen\",\r\n        \"count\": 200,\r\n        \"grade\": 1,\r\n        \"limitApp\": \"default\",\r\n        \"strategy\": 0,\r\n        \"controlBehavior\": 0\r\n    },\r\n	{\r\n        \"resource\": \"integrity-job\",\r\n        \"count\": 300,\r\n        \"grade\": 1,\r\n        \"limitApp\": \"default\",\r\n        \"strategy\": 0,\r\n        \"controlBehavior\": 0\r\n    }\r\n]', '9f3a3069261598f74220bc47958ec252', '2020-11-20 00:00:00', '2020-11-20 00:00:00', NULL, '0:0:0:0:0:0:0:1', '', '', '限流策略', 'null', 'null', 'json', NULL, '');
INSERT INTO `config_info` VALUES (31, 'integrity-flow-dev.yml', 'DEFAULT_GROUP', 'spring:\n  main:\n    allow-bean-definition-overriding: true\n  data:\n    redis:\n      host: 127.0.0.1\n      port: 6379\n      password:\n      database: 0\n  datasource:\n    driver-class-name: dm.jdbc.driver.DmDriver\n    url: ${DB_URL:jdbc:dm://${DM_HOST:localhost}:${DM_PORT:5236}/INTEGRITY-CLOUD-FLOW?schema=${DM_SCHEMA:SYSDBA}}\n    username: ${DB_USERNAME:${DM_USERNAME:SYSDBA}}\n    password: ${DB_PASSWORD:${DM_PASSWORD:IntegritySupervision0}}\n\nmybatis-plus:\n  type-aliases-package: com.integrity.flow.domain\n  mapper-locations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: Flow API\n    description: Flow API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\nwarm-flow:\n  enabled: true\n  banner: true\n  key_type: SnowId19\n  ui: true\n  token-name: Authorization\n', 'aab12de003e4c715ab2ecdce41d367dc', '2024-12-14 07:20:46', '2026-07-08 00:35:11', NULL, '127.0.0.1', '', 'public', '定时任务', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (32, 'application-dev.yml', 'DEFAULT_GROUP', 'spring:\n  autoconfigure:\n    exclude: com.alibaba.druid.spring.boot3.autoconfigure.DruidDataSourceAutoConfigure\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: 127.0.0.1:8718\n\nfeign:\n  sentinel:\n    enabled: true\n  okhttp:\n    enabled: true\n  httpclient:\n    enabled: false\n  client:\n    config:\n      default:\n        connectTimeout: 10000\n        readTimeout: 10000\n  compression:\n    request:\n      enabled: true\n      min-request-size: 8192\n    response:\n      enabled: true\n\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \'*\'', 'e642125240036db04cb4599be10c1550', '2026-07-07 14:34:19', '2026-07-08 21:27:35', NULL, '127.0.0.1', '', 'public', '通用配置', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (33, 'integrity-gateway-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  cloud:\n    gateway:\n      discovery:\n        locator:\n          lowerCaseServiceId: true\n          enabled: true\n      routes:\n        - id: integrity-auth\n          uri: lb://integrity-auth\n          predicates:\n            - Path=/auth/**\n          filters:\n            - name: CacheRequestBody\n              args:\n                bodyClass: java.lang.String\n            - ValidateCodeFilter\n            - StripPrefix=1\n        - id: integrity-gen\n          uri: lb://integrity-gen\n          predicates:\n            - Path=/code/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-job\n          uri: lb://integrity-job\n          predicates:\n            - Path=/schedule/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-flow\n          uri: lb://integrity-flow\n          predicates:\n            - Path=/flow/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-system\n          uri: lb://integrity-system\n          predicates:\n            - Path=/system/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-file\n          uri: lb://integrity-file\n          predicates:\n            - Path=/file/**\n          filters:\n            - StripPrefix=1\n\nsecurity:\n  captcha:\n    enabled: true\n    type: math\n  xss:\n    enabled: true\n    excludeUrls:\n      - /system/notice\n  ignore:\n    whites:\n      - /auth/logout\n      - /auth/login\n      - /auth/register\n      - /flow/warm-flow-ui/**\n      - /*/v2/api-docs\n      - /*/v3/api-docs\n      - /csrf\n\nspringdoc:\n  webjars:\n    prefix:\n', '0bb97abfe7ed7925df7db59e4f4d1bde', '2026-07-07 14:34:19', '2026-07-08 00:52:40', NULL, '127.0.0.1', '', 'public', '网关模块', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (34, 'integrity-auth-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n', '72565b1a725e013154ee57c8fd3045c4', '2026-07-07 14:34:19', '2026-07-07 14:34:19', 'nacos_namespace_migrate', '0:0:0:0:0:0:0:1', '', 'public', '认证中心', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (37, 'integrity-gen-dev.yml', 'DEFAULT_GROUP', '# spring配置\nspring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n  datasource:\n    driver-class-name: dm.jdbc.driver.DmDriver\n    url: ${DB_URL:jdbc:dm://${DM_HOST:localhost}:${DM_PORT:5236}/INTEGRITY-CLOUD?schema=${DM_SCHEMA:SYSDBA}}\n    username: ${DB_USERNAME:${DM_USERNAME:SYSDBA}}\n    password: ${DB_PASSWORD:${DM_PASSWORD:IntegritySupervision0}}\n\n# mybatis-plus配置\nmybatis-plus:\n    # 搜索指定包别名\n    type-aliases-package: com.integrity.gen.domain\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapper-locations: classpath:mapper/**/*.xml\n\n# springdoc配置\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    # 是否开启接口文档\n    enabled: true\n  info:\n    # 标题\n    title: \'代码生成接口文档\'\n    # 描述\n    description: \'代码生成接口描述\'\n    # 作者信息\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\n# 代码生成\ngen:\n  # 作者\n  author: integrity\n  # 默认生成包路径 system 需改成自己的模块名称 如 system monitor tool\n  packageName: com.integrity.system\n  # 自动去除表前缀，默认是false\n  autoRemovePre: false\n  # 表前缀（生成类名不会包含表前缀，多个用逗号分隔）\n  tablePrefix: sys_\n  # 是否允许生成文件覆盖到本地（自定义路径），默认不允许\n  allowOverwrite: false', '84f9f0a0b44a5aa685d1c49d07b078fc', '2026-07-07 14:34:19', '2026-07-07 14:34:19', 'nacos_namespace_migrate', '0:0:0:0:0:0:0:1', '', 'public', '代码生成', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (38, 'integrity-job-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  datasource:\n    driver-class-name: dm.jdbc.driver.DmDriver\n    url: ${DB_URL:jdbc:dm://${DM_HOST:localhost}:${DM_PORT:5236}/INTEGRITY-CLOUD?schema=${DM_SCHEMA:SYSDBA}}\n    username: ${DB_USERNAME:${DM_USERNAME:SYSDBA}}\n    password: ${DB_PASSWORD:${DM_PASSWORD:IntegritySupervision0}}\n\nmybatis-plus:\n  type-aliases-package: com.integrity.job.domain\n  mapper-locations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: Job API\n    description: Job API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', 'f98a6eb63954f1ae14bb23061f6b5f39', '2026-07-07 14:34:19', '2026-07-08 12:50:38', 'fix_job_encoding', '192.168.206.196', '', 'public', '定时任务', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (39, 'integrity-file-dev.yml', 'DEFAULT_GROUP', '# 本地文件上传    \nfile:\n    domain: http://127.0.0.1:9300\n    path: D:/integrity-supervision/uploadPath\n    prefix: /statics\n\n# FastDFS配置\nfdfs:\n  domain: http://127.0.0.1\n  soTimeout: 3000\n  connectTimeout: 2000\n  trackerList: 127.0.0.1:22122\n\n# Minio配置\nminio:\n  url: http://127.0.0.1:9000\n  accessKey: minioadmin\n  secretKey: minioadmin\n  bucketName: test\n\n  # 防盗链配置\nreferer:\n  # 防盗链开关\n  enabled: false\n  # 允许的域名列表\n  allowed-domains: localhost,127.0.0.1,integrity-supervision-platform.local\n', '095791a04211d6e3d294359b21357394', '2026-07-07 14:34:19', '2026-07-07 14:34:19', 'nacos_namespace_migrate', '0:0:0:0:0:0:0:1', '', 'public', '文件服务', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (40, 'sentinel-integrity-gateway', 'DEFAULT_GROUP', '[\r\n    {\r\n        \"resource\": \"integrity-auth\",\r\n        \"count\": 500,\r\n        \"grade\": 1,\r\n        \"limitApp\": \"default\",\r\n        \"strategy\": 0,\r\n        \"controlBehavior\": 0\r\n    },\r\n	{\r\n        \"resource\": \"integrity-system\",\r\n        \"count\": 1000,\r\n        \"grade\": 1,\r\n        \"limitApp\": \"default\",\r\n        \"strategy\": 0,\r\n        \"controlBehavior\": 0\r\n    },\r\n	{\r\n        \"resource\": \"integrity-gen\",\r\n        \"count\": 200,\r\n        \"grade\": 1,\r\n        \"limitApp\": \"default\",\r\n        \"strategy\": 0,\r\n        \"controlBehavior\": 0\r\n    },\r\n	{\r\n        \"resource\": \"integrity-job\",\r\n        \"count\": 300,\r\n        \"grade\": 1,\r\n        \"limitApp\": \"default\",\r\n        \"strategy\": 0,\r\n        \"controlBehavior\": 0\r\n    }\r\n]', '9f3a3069261598f74220bc47958ec252', '2026-07-07 14:34:19', '2026-07-07 14:34:19', 'nacos_namespace_migrate', '0:0:0:0:0:0:0:1', '', 'public', '限流策略', NULL, NULL, 'json', NULL, '');
INSERT INTO `config_info` VALUES (47, 'integrity-flow-dev.yml', 'DEFAULT_GROUP', 'spring:\n  main:\n    allow-bean-definition-overriding: true\n  data:\n    redis:\n      host: 127.0.0.1\n      port: 6379\n      password:\n      database: 0\n  datasource:\n    driver-class-name: dm.jdbc.driver.DmDriver\n    url: ${DB_URL:jdbc:dm://${DM_HOST:localhost}:${DM_PORT:5236}/INTEGRITY-CLOUD-FLOW?schema=${DM_SCHEMA:SYSDBA}}\n    username: ${DB_USERNAME:${DM_USERNAME:SYSDBA}}\n    password: ${DB_PASSWORD:${DM_PASSWORD:IntegritySupervision0}}\n\nmybatis-plus:\n  type-aliases-package: com.integrity.flow.domain\n  mapper-locations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: Flow API\n    description: Flow API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\nwarm-flow:\n  enabled: true\n  banner: true\n  key_type: SnowId19\n  ui: true\n  token-name: Authorization\n', 'aab12de003e4c715ab2ecdce41d367dc', '2026-07-07 14:38:00', '2026-07-08 00:35:11', 'nacos_namespace_migrate', '127.0.0.1', '', '', '定时任务', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info` VALUES (48, 'integrity-system-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=5000\n      datasource:\n          master:\n            driver-class-name: dm.jdbc.driver.DmDriver\n            url: ${DB_URL:jdbc:dm://${DM_HOST:localhost}:${DM_PORT:5236}/INTEGRITY-CLOUD?schema=${DM_SCHEMA:SYSDBA}}\n            username: ${DB_USERNAME:${DM_USERNAME:SYSDBA}}\n            password: ${DB_PASSWORD:${DM_PASSWORD:IntegritySupervision0}}\n\nmybatis-plus:\n  type-aliases-package: com.integrity.system\n  mapper-locations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: System API\n    description: System API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', 'de7c09a2c6e0d224cacb3f30be78b802', '2026-07-08 15:55:24', '2026-07-08 15:55:24', 'nacos_namespace_migrate', '192.168.1.12', '', 'public', '系统模块', NULL, NULL, 'yaml', NULL, '');

-- ----------------------------
-- Table structure for config_info_aggr
-- ----------------------------
DROP TABLE IF EXISTS `config_info_aggr`;
CREATE TABLE `config_info_aggr`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'group_id',
  `datum_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'datum_id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内容',
  `gmt_modified` datetime(0) NOT NULL COMMENT '修改时间',
  `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfoaggr_datagrouptenantdatum`(`data_id`, `group_id`, `tenant_id`, `datum_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '增加租户字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for config_info_backup_flow_20260708
-- ----------------------------
DROP TABLE IF EXISTS `config_info_backup_flow_20260708`;
CREATE TABLE `config_info_backup_flow_20260708`  (
  `id` bigint(0) NOT NULL DEFAULT 0 COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'group_id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'app_name',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration description',
  `c_use` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration usage',
  `effect` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置生效的描述',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置的类型',
  `c_schema` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配置的模式',
  `encrypted_data_key` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密钥'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info_backup_flow_20260708
-- ----------------------------
INSERT INTO `config_info_backup_flow_20260708` VALUES (1, 'application-dev.yml', 'DEFAULT_GROUP', 'spring:\n  autoconfigure:\n    exclude: com.alibaba.druid.spring.boot3.autoconfigure.DruidDataSourceAutoConfigure\n\nfeign:\n  sentinel:\n    enabled: true\n  okhttp:\n    enabled: true\n  httpclient:\n    enabled: false\n  client:\n    config:\n      default:\n        connectTimeout: 10000\n        readTimeout: 10000\n  compression:\n    request:\n      enabled: true\n      min-request-size: 8192\n    response:\n      enabled: true\n\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n', '66bb6a6ecf857abdd497817c53429efb', '2020-05-20 12:00:00', '2026-07-08 00:10:32', 'nacos_fix', '127.0.0.1', '', '', '通用配置', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info_backup_flow_20260708` VALUES (32, 'application-dev.yml', 'DEFAULT_GROUP', 'spring:\n  autoconfigure:\n    exclude: com.alibaba.druid.spring.boot3.autoconfigure.DruidDataSourceAutoConfigure\n\nfeign:\n  sentinel:\n    enabled: true\n  okhttp:\n    enabled: true\n  httpclient:\n    enabled: false\n  client:\n    config:\n      default:\n        connectTimeout: 10000\n        readTimeout: 10000\n  compression:\n    request:\n      enabled: true\n      min-request-size: 8192\n    response:\n      enabled: true\n\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n', '66bb6a6ecf857abdd497817c53429efb', '2026-07-07 14:34:19', '2026-07-08 00:10:32', 'nacos_fix', '127.0.0.1', '', 'public', '通用配置', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info_backup_flow_20260708` VALUES (47, 'integrity-flow-dev.yml', 'DEFAULT_GROUP', 'spring:\n  main:\n    allow-bean-definition-overriding: true\n  data:\n    redis:\n      host: 127.0.0.1\n      port: 6379\n      password:\n      database: 1\n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud-flow?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: root\n\nmybatis:\n  typeAliasesPackage: com.integrity.flow.domain\n  mapperLocations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: Flow API\n    description: Flow API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\nwarm-flow:\n  enabled: true\n  banner: true\n  key_type: SnowId19\n  ui: true\n  token-name: Authorization\n', '7160d5d9752b8ffd47581de48bd89080', '2026-07-07 14:38:00', '2026-07-08 00:10:41', 'nacos_namespace_migrate', '127.0.0.1', '', '', '定时任务', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info_backup_flow_20260708` VALUES (31, 'integrity-flow-dev.yml', 'DEFAULT_GROUP', 'spring:\n  main:\n    allow-bean-definition-overriding: true\n  data:\n    redis:\n      host: 127.0.0.1\n      port: 6379\n      password:\n      database: 1\n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud-flow?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: root\n\nmybatis:\n  typeAliasesPackage: com.integrity.flow.domain\n  mapperLocations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: Flow API\n    description: Flow API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\nwarm-flow:\n  enabled: true\n  banner: true\n  key_type: SnowId19\n  ui: true\n  token-name: Authorization\n', '7160d5d9752b8ffd47581de48bd89080', '2024-12-14 07:20:46', '2026-07-08 00:10:42', NULL, '127.0.0.1', '', 'public', '定时任务', NULL, NULL, 'yaml', NULL, '');

-- ----------------------------
-- Table structure for config_info_backup_gateway_20260707
-- ----------------------------
DROP TABLE IF EXISTS `config_info_backup_gateway_20260707`;
CREATE TABLE `config_info_backup_gateway_20260707`  (
  `id` bigint(0) NOT NULL DEFAULT 0 COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'group_id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'app_name',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration description',
  `c_use` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration usage',
  `effect` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置生效的描述',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置的类型',
  `c_schema` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配置的模式',
  `encrypted_data_key` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密钥'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info_backup_gateway_20260707
-- ----------------------------
INSERT INTO `config_info_backup_gateway_20260707` VALUES (2, 'integrity-gateway-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  cloud:\n    gateway:\n      server:\n        webflux:\n          discovery:\n            locator:\n              lowerCaseServiceId: true\n              enabled: true\n          routes:\n            - id: integrity-auth\n              uri: lb://integrity-auth\n              predicates:\n                - Path=/auth/**\n              filters:\n                - name: CacheRequestBody\n                  args:\n                    bodyClass: java.lang.String\n                - ValidateCodeFilter\n                - StripPrefix=1\n            - id: integrity-gen\n              uri: lb://integrity-gen\n              predicates:\n                - Path=/code/**\n              filters:\n                - StripPrefix=1\n            - id: integrity-job\n              uri: lb://integrity-job\n              predicates:\n                - Path=/schedule/**\n              filters:\n                - StripPrefix=1\n            - id: integrity-system\n              uri: lb://integrity-system\n              predicates:\n                - Path=/system/**\n              filters:\n                - StripPrefix=1\n            - id: integrity-file\n              uri: lb://integrity-file\n              predicates:\n                - Path=/file/**\n              filters:\n                - StripPrefix=1\n\nsecurity:\n  captcha:\n    enabled: true\n    type: math\n  xss:\n    enabled: true\n    excludeUrls:\n      - /system/notice\n  ignore:\n    whites:\n      - /auth/logout\n      - /auth/login\n      - /auth/register\n      - /*/v2/api-docs\n      - /*/v3/api-docs\n      - /csrf\n\nspringdoc:\n  webjars:\n    prefix:\n', '64b57c298c4d693da1be5ba3039c8bbc', '2020-05-14 14:17:55', '2026-07-07 23:25:28', 'nacos_namespace_migrate', '127.0.0.1', '', '', '网关模块', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info_backup_gateway_20260707` VALUES (33, 'integrity-gateway-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  cloud:\n    gateway:\n      server:\n        webflux:\n          discovery:\n            locator:\n              lowerCaseServiceId: true\n              enabled: true\n          routes:\n            - id: integrity-auth\n              uri: lb://integrity-auth\n              predicates:\n                - Path=/auth/**\n              filters:\n                - name: CacheRequestBody\n                  args:\n                    bodyClass: java.lang.String\n                - ValidateCodeFilter\n                - StripPrefix=1\n            - id: integrity-gen\n              uri: lb://integrity-gen\n              predicates:\n                - Path=/code/**\n              filters:\n                - StripPrefix=1\n            - id: integrity-job\n              uri: lb://integrity-job\n              predicates:\n                - Path=/schedule/**\n              filters:\n                - StripPrefix=1\n            - id: integrity-system\n              uri: lb://integrity-system\n              predicates:\n                - Path=/system/**\n              filters:\n                - StripPrefix=1\n            - id: integrity-file\n              uri: lb://integrity-file\n              predicates:\n                - Path=/file/**\n              filters:\n                - StripPrefix=1\n\nsecurity:\n  captcha:\n    enabled: true\n    type: math\n  xss:\n    enabled: true\n    excludeUrls:\n      - /system/notice\n  ignore:\n    whites:\n      - /auth/logout\n      - /auth/login\n      - /auth/register\n      - /*/v2/api-docs\n      - /*/v3/api-docs\n      - /csrf\n\nspringdoc:\n  webjars:\n    prefix:\n', '64b57c298c4d693da1be5ba3039c8bbc', '2026-07-07 14:34:19', '2026-07-07 23:25:28', NULL, '127.0.0.1', '', 'public', '网关模块', NULL, NULL, 'yaml', NULL, '');

-- ----------------------------
-- Table structure for config_info_backup_job_20260708
-- ----------------------------
DROP TABLE IF EXISTS `config_info_backup_job_20260708`;
CREATE TABLE `config_info_backup_job_20260708`  (
  `id` bigint(0) NOT NULL DEFAULT 0 COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'group_id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'app_name',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration description',
  `c_use` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration usage',
  `effect` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置生效的描述',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置的类型',
  `c_schema` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配置的模式',
  `encrypted_data_key` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密钥'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info_backup_job_20260708
-- ----------------------------
INSERT INTO `config_info_backup_job_20260708` VALUES (7, 'integrity-job-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: root\n\nmybatis:\n    typeAliasesPackage: com.integrity.job.domain\n    mapperLocations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: \'定时任务接口文档\'\n    description: \'定时任务接口描述\'\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', '46401e305ea7946a6dc7c89446a7bbf6', '2020-11-20 00:00:00', '2026-07-08 12:46:17', 'nacos_namespace_migrate', '192.168.206.196', '', '', '定时任务', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info_backup_job_20260708` VALUES (38, 'integrity-job-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: root\n\nmybatis:\n    typeAliasesPackage: com.integrity.job.domain\n    mapperLocations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: \'定时任务接口文档\'\n    description: \'定时任务接口描述\'\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', '46401e305ea7946a6dc7c89446a7bbf6', '2026-07-07 14:34:19', '2026-07-08 12:46:17', 'nacos', '192.168.206.196', '', 'public', '定时任务', NULL, NULL, 'yaml', NULL, '');

-- ----------------------------
-- Table structure for config_info_backup_monitor_20260708
-- ----------------------------
DROP TABLE IF EXISTS `config_info_backup_monitor_20260708`;
CREATE TABLE `config_info_backup_monitor_20260708`  (
  `id` bigint(0) NOT NULL DEFAULT 0 COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'group_id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'app_name',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration description',
  `c_use` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration usage',
  `effect` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置生效的描述',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置的类型',
  `c_schema` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配置的模式',
  `encrypted_data_key` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密钥'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info_backup_monitor_20260708
-- ----------------------------
INSERT INTO `config_info_backup_monitor_20260708` VALUES (4, 'integrity-monitor-dev.yml', 'DEFAULT_GROUP', '# spring\nspring:\n  security:\n    user:\n      name: admin\n      password: 123456\n  boot:\n    admin:\n      ui:\n        title: 廉政监管平台服务监控\n', '6f122fd2bfb8d45f858e7d6529a9cd44', '2020-11-20 00:00:00', '2024-08-29 12:15:11', 'nacos', '0:0:0:0:0:0:0:1', '', '', '监控中心', 'null', 'null', 'yaml', '', '');
INSERT INTO `config_info_backup_monitor_20260708` VALUES (35, 'integrity-monitor-dev.yml', 'DEFAULT_GROUP', '# spring\nspring:\n  security:\n    user:\n      name: admin\n      password: 123456\n  boot:\n    admin:\n      ui:\n        title: 廉政监管平台服务监控\n', '6f122fd2bfb8d45f858e7d6529a9cd44', '2026-07-07 14:34:19', '2026-07-07 14:34:19', 'nacos_namespace_migrate', '0:0:0:0:0:0:0:1', '', 'public', '监控中心', NULL, NULL, 'yaml', NULL, '');

-- ----------------------------
-- Table structure for config_info_backup_system_20260708
-- ----------------------------
DROP TABLE IF EXISTS `config_info_backup_system_20260708`;
CREATE TABLE `config_info_backup_system_20260708`  (
  `id` bigint(0) NOT NULL DEFAULT 0 COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'group_id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'app_name',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration description',
  `c_use` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'configuration usage',
  `effect` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置生效的描述',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置的类型',
  `c_schema` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配置的模式',
  `encrypted_data_key` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密钥'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info_backup_system_20260708
-- ----------------------------
INSERT INTO `config_info_backup_system_20260708` VALUES (5, 'integrity-system-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n          master:\n            driver-class-name: com.mysql.cj.jdbc.Driver\n            url: jdbc:mysql://localhost:3306/integrity-cloud?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n            username: root\n            password: root\n          # slave:\n            # username: \n            # password: \n            # url: \n            # driver-class-name: \n\nmybatis:\n    typeAliasesPackage: com.integrity.system\n    mapperLocations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: \'系统模块接口文档\'\n    description: \'系统模块接口描述\'\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', '053a7f0be5e9a348e59924927b82d080', '2020-11-20 00:00:00', '2026-07-07 19:30:24', 'nacos_namespace_migrate', '192.168.1.12', '', '', '系统模块', NULL, NULL, 'yaml', NULL, '');
INSERT INTO `config_info_backup_system_20260708` VALUES (36, 'integrity-system-dev.yml', 'DEFAULT_GROUP', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n          master:\n            driver-class-name: com.mysql.cj.jdbc.Driver\n            url: jdbc:mysql://localhost:3306/integrity-cloud?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n            username: root\n            password: root\n          # slave:\n            # username: \n            # password: \n            # url: \n            # driver-class-name: \n\nmybatis:\n    typeAliasesPackage: com.integrity.system\n    mapperLocations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: \'系统模块接口文档\'\n    description: \'系统模块接口描述\'\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', '053a7f0be5e9a348e59924927b82d080', '2026-07-07 14:34:19', '2026-07-07 19:30:24', 'nacos', '192.168.1.12', '', 'public', '系统模块', NULL, NULL, 'yaml', NULL, '');

-- ----------------------------
-- Table structure for config_info_beta
-- ----------------------------
DROP TABLE IF EXISTS `config_info_beta`;
CREATE TABLE `config_info_beta`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'group_id',
  `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'content',
  `beta_ips` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'betaIps',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'source ip',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户字段',
  `encrypted_data_key` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密钥',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfobeta_datagrouptenant`(`data_id`, `group_id`, `tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'config_info_beta' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for config_info_gray
-- ----------------------------
DROP TABLE IF EXISTS `config_info_gray`;
CREATE TABLE `config_info_gray`  (
  `id` bigint unsigned NOT NULL COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'group_id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'md5',
  `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'src_user',
  `src_ip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'src_ip',
  `gmt_create` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT 'gmt_create',
  `gmt_modified` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT 'gmt_modified',
  `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'app_name',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'tenant_id',
  `gray_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'gray_name',
  `gray_rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'gray_rule',
  `encrypted_data_key` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'encrypted_data_key',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfogray_datagrouptenantgray`(`data_id`, `group_id`, `tenant_id`, `gray_name`) USING BTREE,
  INDEX `idx_dataid_gmt_modified`(`data_id`, `gmt_modified`) USING BTREE,
  INDEX `idx_gmt_modified`(`gmt_modified`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'config_info_gray' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for config_info_tag
-- ----------------------------
DROP TABLE IF EXISTS `config_info_tag`;
CREATE TABLE `config_info_tag`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'tenant_id',
  `tag_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'tag_id',
  `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'source ip',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfotag_datagrouptenanttag`(`data_id`, `group_id`, `tenant_id`, `tag_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'config_info_tag' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for config_tags_relation
-- ----------------------------
DROP TABLE IF EXISTS `config_tags_relation`;
CREATE TABLE `config_tags_relation`  (
  `id` bigint(0) NOT NULL COMMENT 'id',
  `tag_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'tag_name',
  `tag_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'tag_type',
  `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'tenant_id',
  `nid` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'nid, 自增长标识',
  PRIMARY KEY (`nid`) USING BTREE,
  UNIQUE INDEX `uk_configtagrelation_configidtag`(`id`, `tag_name`, `tag_type`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'config_tag_relation' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for group_capacity
-- ----------------------------
DROP TABLE IF EXISTS `group_capacity`;
CREATE TABLE `group_capacity`  (
  `id` bigint unsigned NOT NULL COMMENT '主键ID',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
  `quota` int unsigned NOT NULL COMMENT '配额，0表示使用默认值',
  `usage` int unsigned NOT NULL COMMENT '使用量',
  `max_size` int unsigned NOT NULL COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int unsigned NOT NULL COMMENT '聚合子配置最大个数，，0表示使用默认值',
  `max_aggr_size` int unsigned NOT NULL COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int unsigned NOT NULL COMMENT '最大变更历史数量',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_group_id`(`group_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '集群、各Group容量信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for his_config_info
-- ----------------------------
DROP TABLE IF EXISTS `his_config_info`;
CREATE TABLE `his_config_info`  (
  `id` bigint unsigned NOT NULL COMMENT 'id',
  `nid` bigint unsigned NOT NULL COMMENT 'nid, 自增标识',
  `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'group_id',
  `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'source user',
  `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'source ip',
  `op_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'operation type',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '租户字段',
  `encrypted_data_key` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密钥',
  `publish_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'formal' COMMENT 'publish type gray or formal',
  `gray_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'gray name',
  `ext_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'ext info',
  PRIMARY KEY (`nid`) USING BTREE,
  INDEX `idx_gmt_create`(`gmt_create`) USING BTREE,
  INDEX `idx_gmt_modified`(`gmt_modified`) USING BTREE,
  INDEX `idx_did`(`data_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '多租户改造' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of his_config_info
-- ----------------------------
INSERT INTO `his_config_info` VALUES (31, 1, 'integrity-flow-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  main:\n    allow-bean-definition-overriding: true\n  redis:\n    host: 192.168.227.13\n    port: 6379\n    password: \n    database: 1\n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://192.168.227.12:3306/integrity-cloud-flow?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: ENC(1E62C7AC56D89A46A7803C45E316C8673455C4221BCE4E9A63E086855E6C6492)\n\n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.integrity.flow.domain\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/**/*.xml\n\n# springdoc配置\nspringdoc:\n  gatewayUrl: http://localhost:8080/NULL\n  api-docs:\n    # 是否开启接口文档\n    enabled: true\n  info:\n    # 标题\n    title: \'定时任务接口文档\'\n    # 描述\n    description: \'定时任务接口描述\'\n    # 作者信息\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\n# warm-flow工作流配置\nwarm-flow:\n  # 是否开启工作流，默认true\n  enabled: true\n  # 是否显示banner图，默认是\n  banner: true\n  # id生成器类型, 不填默认为orm扩展自带生成器或者warm-flow内置的19位雪花算法, SnowId14:14位，SnowId15:15位，SnowFlake19：19位\n  key_type: SnowId19\n  # 是否开启设计器ui，默认true\n  ui: true\n  ## 如果需要工作流共享业务系统权限，默认Authorization，如果有多个token，用逗号分隔\n  token-name: Authorization\n#  # 填充器，内部有默认实现，如果不满足实际业务，可通过此配置自定义实现\n#  data-fill-handler-path: com.integrity.system.handle.CustomDataFillHandler\n#  # 全局租户处理器，有多租户需要，可以配置自定义实现\n#  tenant_handler_path: com.integrity.system.handle.CustomTenantHandler\n#  # 是否开启逻辑删除（orm框架本身不支持逻辑删除，可通过这种方式开启，比如jpa）\n#  logic_delete: true\n#  # 逻辑删除字段值（开启后默认为2）\n#  logic_delete_value: 2\n#  # 逻辑未删除字段（开启后默认为0）\n#  logic_not_delete_value: 0\n#  # 当使用JPA时指定JpaPersistenceProvider\n#  jpa_persistence_provider: org.springframework.orm.jpa.vendor.SpringHibernateJpaPersistenceProvider', 'dc7cbf2bd9f5ae698cb28595e6a8bccb', '2026-07-07 14:38:00', '2026-07-07 06:38:00', 'nacos', '192.168.206.127', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos\",\"c_desc\":\"定时任务\"}');
INSERT INTO `his_config_info` VALUES (36, 2, 'integrity-system-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n          # 主库数据源\n          master:\n            driver-class-name: com.mysql.cj.jdbc.Driver\n            url: jdbc:mysql://localhost:3306/integrity-cloud?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n            username: root\n            password: password\n          # 从库数据源\n          # slave:\n            # username: \n            # password: \n            # url: \n            # driver-class-name: \n\n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.integrity.system\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/**/*.xml\n\n# springdoc配置\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    # 是否开启接口文档\n    enabled: true\n  info:\n    # 标题\n    title: \'系统模块接口文档\'\n    # 描述\n    description: \'系统模块接口描述\'\n    # 作者信息\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', 'a79ae256018abb7f3bbaba923baeb6af', '2026-07-07 19:28:33', '2026-07-07 11:28:33', 'nacos', '192.168.1.12', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos_namespace_migrate\",\"c_desc\":\"系统模块\"}');
INSERT INTO `his_config_info` VALUES (36, 3, 'integrity-system-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n  datasource:\n    druid:\n      stat-view-servlet:\n        enabled: true\n        loginUsername: admin\n        loginPassword: 123456\n    dynamic:\n      druid:\n        initial-size: 5\n        min-idle: 5\n        maxActive: 20\n        maxWait: 60000\n        connectTimeout: 30000\n        socketTimeout: 60000\n        timeBetweenEvictionRunsMillis: 60000\n        minEvictableIdleTimeMillis: 300000\n        validationQuery: SELECT 1 FROM DUAL\n        testWhileIdle: true\n        testOnBorrow: false\n        testOnReturn: false\n        poolPreparedStatements: true\n        maxPoolPreparedStatementPerConnectionSize: 20\n        filters: stat,slf4j\n        connectionProperties: druid.stat.mergeSql\\=true;druid.stat.slowSqlMillis\\=5000\n      datasource:\n          # 主库数据源\n          master:\n            driver-class-name: com.mysql.cj.jdbc.Driver\n            url: jdbc:mysql://localhost:3306/integrity-cloud?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n            username: root\n            password: root\n          # 从库数据源\n          # slave:\n            # username: \n            # password: \n            # url: \n            # driver-class-name: \n\n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.integrity.system\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/**/*.xml\n\n# springdoc配置\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    # 是否开启接口文档\n    enabled: true\n  info:\n    # 标题\n    title: \'系统模块接口文档\'\n    # 描述\n    description: \'系统模块接口描述\'\n    # 作者信息\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', 'b8733bd203f3197e2b7662901a9b70ba', '2026-07-07 19:30:24', '2026-07-07 11:30:25', 'nacos', '192.168.1.12', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos\",\"c_desc\":\"系统模块\"}');
INSERT INTO `his_config_info` VALUES (31, 4, 'integrity-flow-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  main:\n    allow-bean-definition-overriding: true\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: \n    database: 1\n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud-flow?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: root\n\n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.integrity.flow.domain\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/**/*.xml\n\n# springdoc配置\nspringdoc:\n  gatewayUrl: http://localhost:8080/NULL\n  api-docs:\n    # 是否开启接口文档\n    enabled: true\n  info:\n    # 标题\n    title: \'定时任务接口文档\'\n    # 描述\n    description: \'定时任务接口描述\'\n    # 作者信息\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\n# warm-flow工作流配置\nwarm-flow:\n  # 是否开启工作流，默认true\n  enabled: true\n  # 是否显示banner图，默认是\n  banner: true\n  # id生成器类型, 不填默认为orm扩展自带生成器或者warm-flow内置的19位雪花算法, SnowId14:14位，SnowId15:15位，SnowFlake19：19位\n  key_type: SnowId19\n  # 是否开启设计器ui，默认true\n  ui: true\n  ## 如果需要工作流共享业务系统权限，默认Authorization，如果有多个token，用逗号分隔\n  token-name: Authorization\n#  # 填充器，内部有默认实现，如果不满足实际业务，可通过此配置自定义实现\n#  data-fill-handler-path: com.integrity.system.handle.CustomDataFillHandler\n#  # 全局租户处理器，有多租户需要，可以配置自定义实现\n#  tenant_handler_path: com.integrity.system.handle.CustomTenantHandler\n#  # 是否开启逻辑删除（orm框架本身不支持逻辑删除，可通过这种方式开启，比如jpa）\n#  logic_delete: true\n#  # 逻辑删除字段值（开启后默认为2）\n#  logic_delete_value: 2\n#  # 逻辑未删除字段（开启后默认为0）\n#  logic_not_delete_value: 0\n#  # 当使用JPA时指定JpaPersistenceProvider\n#  jpa_persistence_provider: org.springframework.orm.jpa.vendor.SpringHibernateJpaPersistenceProvider', '61d7ef415a839eac376f5d5930b6f6e3', '2026-07-07 22:47:06', '2026-07-07 14:47:07', 'nacos', '192.168.1.12', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos\",\"c_desc\":\"定时任务\"}');
INSERT INTO `his_config_info` VALUES (32, 5, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  autoconfigure:\n    exclude: com.alibaba.druid.spring.boot3.autoconfigure.DruidDataSourceAutoConfigure\n\nfeign:\n  sentinel:\n    enabled: true\n  okhttp:\n    enabled: true\n  httpclient:\n    enabled: false\n  client:\n    config:\n      default:\n        connectTimeout: 10000\n        readTimeout: 10000\n  compression:\n    request:\n      enabled: true\n      min-request-size: 8192\n    response:\n      enabled: true\n\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n', '66bb6a6ecf857abdd497817c53429efb', '2026-07-07 23:04:53', '2026-07-07 15:04:54', NULL, '127.0.0.1', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos_fix\",\"c_desc\":\"通用配置\"}');
INSERT INTO `his_config_info` VALUES (31, 6, 'integrity-flow-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  main:\n    allow-bean-definition-overriding: true\n  data:\n    redis:\n      host: 127.0.0.1\n      port: 6379\n      password:\n      database: 1\n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud-flow?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: root\n\nmybatis:\n  typeAliasesPackage: com.integrity.flow.domain\n  mapperLocations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: Flow API\n    description: Flow API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\nwarm-flow:\n  enabled: true\n  banner: true\n  key_type: SnowId19\n  ui: true\n  token-name: Authorization\n', 'e8e565337853d6aab59ddc62308eead5', '2026-07-07 23:04:53', '2026-07-07 15:04:54', NULL, '127.0.0.1', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos_fix\",\"c_desc\":\"定时任务\"}');
INSERT INTO `his_config_info` VALUES (33, 7, 'integrity-gateway-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  cloud:\n    gateway:\n      server:\n        webflux:\n          discovery:\n            locator:\n              lowerCaseServiceId: true\n              enabled: true\n          routes:\n            - id: integrity-auth\n              uri: lb://integrity-auth\n              predicates:\n                - Path=/auth/**\n              filters:\n                - name: CacheRequestBody\n                  args:\n                    bodyClass: java.lang.String\n                - ValidateCodeFilter\n                - StripPrefix=1\n            - id: integrity-gen\n              uri: lb://integrity-gen\n              predicates:\n                - Path=/code/**\n              filters:\n                - StripPrefix=1\n            - id: integrity-job\n              uri: lb://integrity-job\n              predicates:\n                - Path=/schedule/**\n              filters:\n                - StripPrefix=1\n            - id: integrity-system\n              uri: lb://integrity-system\n              predicates:\n                - Path=/system/**\n              filters:\n                - StripPrefix=1\n            - id: integrity-file\n              uri: lb://integrity-file\n              predicates:\n                - Path=/file/**\n              filters:\n                - StripPrefix=1\n\nsecurity:\n  captcha:\n    enabled: true\n    type: math\n  xss:\n    enabled: true\n    excludeUrls:\n      - /system/notice\n  ignore:\n    whites:\n      - /auth/logout\n      - /auth/login\n      - /auth/register\n      - /*/v2/api-docs\n      - /*/v3/api-docs\n      - /csrf\n\nspringdoc:\n  webjars:\n    prefix:\n', '64b57c298c4d693da1be5ba3039c8bbc', '2026-07-07 23:25:27', '2026-07-07 15:25:28', NULL, '127.0.0.1', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos_fix\",\"c_desc\":\"网关模块\"}');
INSERT INTO `his_config_info` VALUES (33, 8, 'integrity-gateway-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  cloud:\n    gateway:\n      discovery:\n        locator:\n          lowerCaseServiceId: true\n          enabled: true\n      routes:\n        - id: integrity-auth\n          uri: lb://integrity-auth\n          predicates:\n            - Path=/auth/**\n          filters:\n            - name: CacheRequestBody\n              args:\n                bodyClass: java.lang.String\n            - ValidateCodeFilter\n            - StripPrefix=1\n        - id: integrity-gen\n          uri: lb://integrity-gen\n          predicates:\n            - Path=/code/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-job\n          uri: lb://integrity-job\n          predicates:\n            - Path=/schedule/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-system\n          uri: lb://integrity-system\n          predicates:\n            - Path=/system/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-file\n          uri: lb://integrity-file\n          predicates:\n            - Path=/file/**\n          filters:\n            - StripPrefix=1\n\nsecurity:\n  captcha:\n    enabled: true\n    type: math\n  xss:\n    enabled: true\n    excludeUrls:\n      - /system/notice\n  ignore:\n    whites:\n      - /auth/logout\n      - /auth/login\n      - /auth/register\n      - /*/v2/api-docs\n      - /*/v3/api-docs\n      - /csrf\n\nspringdoc:\n  webjars:\n    prefix:\n', 'd335f24830093c145a63a8355a71dbfb', '2026-07-07 23:34:23', '2026-07-07 15:34:24', NULL, '127.0.0.1', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"fix_gateway_encoding\",\"c_desc\":\"网关模块\"}');
INSERT INTO `his_config_info` VALUES (33, 9, 'integrity-gateway-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  cloud:\n    gateway:\n      discovery:\n        locator:\n          lowerCaseServiceId: true\n          enabled: true\n      routes:\n        - id: integrity-auth\n          uri: lb://integrity-auth\n          predicates:\n            - Path=/auth/**\n          filters:\n            - name: CacheRequestBody\n              args:\n                bodyClass: java.lang.String\n            - ValidateCodeFilter\n            - StripPrefix=1\n        - id: integrity-gen\n          uri: lb://integrity-gen\n          predicates:\n            - Path=/code/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-job\n          uri: lb://integrity-job\n          predicates:\n            - Path=/schedule/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-flow\n          uri: lb://integrity-flow\n          predicates:\n            - Path=/flow/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-system\n          uri: lb://integrity-system\n          predicates:\n            - Path=/system/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-file\n          uri: lb://integrity-file\n          predicates:\n            - Path=/file/**\n          filters:\n            - StripPrefix=1\n\nsecurity:\n  captcha:\n    enabled: true\n    type: math\n  xss:\n    enabled: true\n    excludeUrls:\n      - /system/notice\n  ignore:\n    whites:\n      - /auth/logout\n      - /auth/login\n      - /auth/register\n      - /*/v2/api-docs\n      - /*/v3/api-docs\n      - /csrf\n\nspringdoc:\n  webjars:\n    prefix:\n', '8b9c8ced1f07be3568c05abac32752a6', '2026-07-08 00:07:50', '2026-07-07 16:07:50', NULL, '127.0.0.1', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"fix_gateway_encoding\",\"c_desc\":\"网关模块\"}');
INSERT INTO `his_config_info` VALUES (31, 10, 'integrity-flow-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  main:\n    allow-bean-definition-overriding: true\n  data:\n    redis:\n      host: 127.0.0.1\n      port: 6379\n      password:\n      database: 1\n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud-flow?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: root\n\nmybatis:\n  typeAliasesPackage: com.integrity.flow.domain\n  mapperLocations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: Flow API\n    description: Flow API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\nwarm-flow:\n  enabled: true\n  banner: true\n  key_type: SnowId19\n  ui: true\n  token-name: Authorization\n', '7160d5d9752b8ffd47581de48bd89080', '2026-07-08 00:10:41', '2026-07-07 16:10:42', NULL, '127.0.0.1', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos_fix\",\"c_desc\":\"定时任务\"}');
INSERT INTO `his_config_info` VALUES (31, 11, 'integrity-flow-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  main:\n    allow-bean-definition-overriding: true\n  data:\n    redis:\n      host: 127.0.0.1\n      port: 6379\n      password:\n      database: 1\n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud-flow?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: root\n\nmybatis:\n  typeAliasesPackage: com.integrity.flow.domain\n  mapperLocations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: Flow API\n    description: Flow API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\nwarm-flow:\n  enabled: true\n  banner: true\n  key_type: SnowId19\n  ui: true\n  token-name: Authorization\n', '7160d5d9752b8ffd47581de48bd89080', '2026-07-08 00:18:59', '2026-07-07 16:19:00', NULL, '127.0.0.1', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos_fix\",\"c_desc\":\"定时任务\"}');
INSERT INTO `his_config_info` VALUES (31, 12, 'integrity-flow-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  main:\n    allow-bean-definition-overriding: true\n  data:\n    redis:\n      host: 127.0.0.1\n      port: 6379\n      password:\n      database: 0\n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud-flow?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: root\n\nmybatis:\n  typeAliasesPackage: com.integrity.flow.domain\n  mapperLocations: classpath:mapper/**/*.xml\n\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: Flow API\n    description: Flow API\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n\nwarm-flow:\n  enabled: true\n  banner: true\n  key_type: SnowId19\n  ui: true\n  token-name: Authorization\n', '34384b64ace2921f46cc022399c1ae32', '2026-07-08 00:35:11', '2026-07-07 16:35:11', NULL, '127.0.0.1', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos_fix\",\"c_desc\":\"定时任务\"}');
INSERT INTO `his_config_info` VALUES (33, 13, 'integrity-gateway-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  cloud:\n    gateway:\n      discovery:\n        locator:\n          lowerCaseServiceId: true\n          enabled: true\n      routes:\n        - id: integrity-auth\n          uri: lb://integrity-auth\n          predicates:\n            - Path=/auth/**\n          filters:\n            - name: CacheRequestBody\n              args:\n                bodyClass: java.lang.String\n            - ValidateCodeFilter\n            - StripPrefix=1\n        - id: integrity-gen\n          uri: lb://integrity-gen\n          predicates:\n            - Path=/code/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-job\n          uri: lb://integrity-job\n          predicates:\n            - Path=/schedule/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-flow\n          uri: lb://integrity-flow\n          predicates:\n            - Path=/flow/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-system\n          uri: lb://integrity-system\n          predicates:\n            - Path=/system/**\n          filters:\n            - StripPrefix=1\n        - id: integrity-file\n          uri: lb://integrity-file\n          predicates:\n            - Path=/file/**\n          filters:\n            - StripPrefix=1\n\nsecurity:\n  captcha:\n    enabled: true\n    type: math\n  xss:\n    enabled: true\n    excludeUrls:\n      - /system/notice\n  ignore:\n    whites:\n      - /auth/logout\n      - /auth/login\n      - /auth/register\n      - /flow/warm-flow-ui/**\n      - /*/v2/api-docs\n      - /*/v3/api-docs\n      - /csrf\n\nspringdoc:\n  webjars:\n    prefix:\n', '0bb97abfe7ed7925df7db59e4f4d1bde', '2026-07-08 00:52:40', '2026-07-07 16:52:40', NULL, '127.0.0.1', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"fix_gateway_encoding\",\"c_desc\":\"网关模块\"}');
INSERT INTO `his_config_info` VALUES (38, 14, 'integrity-job-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: password\n\n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.integrity.job.domain\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/**/*.xml\n\n# springdoc配置\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    # 是否开启接口文档\n    enabled: true\n  info:\n    # 标题\n    title: \'定时任务接口文档\'\n    # 描述\n    description: \'定时任务接口描述\'\n    # 作者信息\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', '225445e638148dbcbadda8d9774ce3fd', '2026-07-08 12:38:34', '2026-07-08 04:38:34', 'nacos', '192.168.206.196', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos_namespace_migrate\",\"c_desc\":\"定时任务\"}');
INSERT INTO `his_config_info` VALUES (38, 15, 'integrity-job-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password: \n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: root\n\n# mybatis配置\nmybatis:\n    # 搜索指定包别名\n    typeAliasesPackage: com.integrity.job.domain\n    # 配置mapper的扫描，找到所有的mapper.xml映射文件\n    mapperLocations: classpath:mapper/**/*.xml\n\n# springdoc配置\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    # 是否开启接口文档\n    enabled: true\n  info:\n    # 标题\n    title: \'定时任务接口文档\'\n    # 描述\n    description: \'定时任务接口描述\'\n    # 作者信息\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local\n', '8b6c7caeaaf7d1b0c068adf3ebdb6b2f', '2026-07-08 12:45:07', '2026-07-08 04:45:07', NULL, '127.0.0.1', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos\",\"c_desc\":\"定时任务\"}');
INSERT INTO `his_config_info` VALUES (38, 16, 'integrity-job-dev.yml', 'DEFAULT_GROUP', '', '# spring配置\nspring:\n  data:\n    redis:\n      host: localhost\n      port: 6379\n      password:\n  datasource:\n    driver-class-name: com.mysql.cj.jdbc.Driver\n    url: jdbc:mysql://localhost:3306/integrity-cloud?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8\n    username: root\n    password: root\n\n# mybatis配置\nmybatis:\n    typeAliasesPackage: com.integrity.job.domain\n    mapperLocations: classpath:mapper/**/*.xml\n\n# springdoc配置\nspringdoc:\n  gatewayUrl: http://localhost:8080/${spring.application.name}\n  api-docs:\n    enabled: true\n  info:\n    title: 定时任务接口文档\n    description: 定时任务接口描述\n    contact:\n      name: Integrity-Supervision-Platform\n      url: https://integrity-supervision-platform.local', '5a615bdb3511dd60642e2ab8149e5867', '2026-07-08 12:46:16', '2026-07-08 04:46:17', 'nacos', '192.168.206.196', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"c_desc\":\"定时任务\"}');
INSERT INTO `his_config_info` VALUES (32, 17, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  autoconfigure:\n    exclude: com.alibaba.druid.spring.boot3.autoconfigure.DruidDataSourceAutoConfigure\n\nfeign:\n  sentinel:\n    enabled: true\n  okhttp:\n    enabled: true\n  httpclient:\n    enabled: false\n  client:\n    config:\n      default:\n        connectTimeout: 10000\n        readTimeout: 10000\n  compression:\n    request:\n      enabled: true\n      min-request-size: 8192\n    response:\n      enabled: true\n\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n', '66bb6a6ecf857abdd497817c53429efb', '2026-07-08 21:27:35', '2026-07-08 13:27:35', NULL, '127.0.0.1', 'U', 'public', '', 'formal', '', '{\"type\":\"yaml\",\"src_user\":\"nacos_fix\",\"c_desc\":\"通用配置\"}');

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'role',
  `resource` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'resource',
  `action` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'action',
  UNIQUE INDEX `uk_role_permission`(`role`, `resource`, `action`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pipeline_execution
-- ----------------------------
DROP TABLE IF EXISTS `pipeline_execution`;
CREATE TABLE `pipeline_execution`  (
  `execution_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行ID',
  `resource_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源类型',
  `resource_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源名称',
  `namespace_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '命名空间ID',
  `version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '版本',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行状态',
  `pipeline` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'pipeline节点结果JSON',
  `create_time` bigint(0) NOT NULL COMMENT '创建时间',
  `update_time` bigint(0) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`execution_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI资源发布审核Pipeline执行记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'username',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'role',
  UNIQUE INDEX `idx_user_role`(`username`, `role`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES ('nacos', 'ROLE_ADMIN');

-- ----------------------------
-- Table structure for tenant_capacity
-- ----------------------------
DROP TABLE IF EXISTS `tenant_capacity`;
CREATE TABLE `tenant_capacity`  (
  `id` bigint unsigned NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Tenant ID',
  `quota` int unsigned NOT NULL COMMENT '配额，0表示使用默认值',
  `usage` int unsigned NOT NULL COMMENT '使用量',
  `max_size` int unsigned NOT NULL COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int unsigned NOT NULL COMMENT '聚合子配置最大个数',
  `max_aggr_size` int unsigned NOT NULL COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int unsigned NOT NULL COMMENT '最大变更历史数量',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '租户容量信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tenant_info
-- ----------------------------
DROP TABLE IF EXISTS `tenant_info`;
CREATE TABLE `tenant_info`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `kp` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'kp',
  `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'tenant_id',
  `tenant_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'tenant_name',
  `tenant_desc` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'tenant_desc',
  `create_source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'create_source',
  `gmt_create` bigint(0) NOT NULL COMMENT '创建时间',
  `gmt_modified` bigint(0) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_info_kptenantid`(`kp`, `tenant_id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'tenant_info' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tenant_info
-- ----------------------------
INSERT INTO `tenant_info` VALUES (1, '1', 'dev', 'dev', 'dev', 'nacos', 1732084960383, 1732084960383);
INSERT INTO `tenant_info` VALUES (2, '1', 'sit', 'sit', 'sit', 'nacos', 1732084966300, 1732084966300);
INSERT INTO `tenant_info` VALUES (3, '1', 'uat', 'uat', 'uat', 'nacos', 1732084971853, 1732084971853);
INSERT INTO `tenant_info` VALUES (4, '1', 'prod', 'prod', 'prod', 'nacos', 1732084979302, 1732084979302);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'username',
  `password` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'password',
  `enabled` tinyint(1) NOT NULL COMMENT 'enabled',
  PRIMARY KEY (`username`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', 1);

SET FOREIGN_KEY_CHECKS = 1;



