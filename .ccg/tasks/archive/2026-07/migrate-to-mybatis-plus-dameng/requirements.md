# Requirements

## User Request

1. 将系统持久层框架换成 MyBatis-Plus。
2. 系统需要既能使用 MySQL，也能使用达梦数据库。

## Current Findings

- Project is a Spring Boot 3.3.5 / Spring Cloud 2023.0.3 multi-module backend.
- Existing persistence layer uses MyBatis XML mapper files and `org.mybatis:mybatis-spring`.
- Pagination currently uses PageHelper through `PageUtils.startPage()` and `BaseController#getDataTable`.
- Dynamic datasource is already based on `com.baomidou:dynamic-datasource-spring-boot3-starter`.
- Runtime datasource config exists in both local `bootstrap.yml` and Nacos seed SQL (`sql/integrity-config.sql`).
- Mapper XML contains MySQL-specific constructs such as `limit 1`, `date_format`, `information_schema`, `database()`, and `GROUP_CONCAT`.
- MyBatis-Plus Spring Boot 3 starter latest version on Maven Central is `3.5.17`.
- Dameng JDBC Maven Central coordinate is `com.dameng:DmJdbcDriver18`, latest `8.1.3.140`.

## Acceptance Direction

- Introduce MyBatis-Plus as the application persistence starter while preserving existing XML mapper behavior.
- Add shared MyBatis-Plus configuration for mapper XML scanning, aliases, and pagination dialect support.
- Add selectable MySQL/Dameng datasource dependencies and documented/env-driven datasource configuration.
- Keep existing business APIs stable.
- Identify and migrate database-specific SQL paths needed for Dameng compatibility.
