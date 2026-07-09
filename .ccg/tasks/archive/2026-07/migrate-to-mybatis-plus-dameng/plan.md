# Implementation Plan

## Scope

This task will implement the first migration layer:

- Replace the explicit MyBatis starter dependency with MyBatis-Plus Spring Boot 3 starter.
- Keep existing XML mapper methods working.
- Add MyBatis-Plus global configuration and pagination interceptor.
- Add Dameng JDBC dependency management and runtime configuration examples.
- Change local and Nacos seed configuration from `mybatis` to `mybatis-plus`.
- Document the remaining SQL dialect migration needed for full Dameng runtime compatibility.

Full conversion of every XML CRUD statement to MyBatis-Plus `BaseMapper`/`IService`, and full conversion of all MySQL-specific XML SQL, is intentionally not done in this first pass because it affects many business queries and needs database-backed verification.

## Steps

1. Update root dependency management.
   - Add `mybatis-plus.version` and `dm.jdbc.version`.
   - Manage `mybatis-plus-spring-boot3-starter`.
   - Manage `com.dameng:DmJdbcDriver18`.
   - Remove direct `org.mybatis:mybatis-spring` dependency management.

2. Update common core dependencies.
   - Replace direct `mybatis-spring` dependency with MyBatis-Plus starter.
   - Keep PageHelper temporarily because current controller pagination API is built around it.

3. Add shared MyBatis-Plus configuration.
   - Create an auto-configuration class in `integrity-common-datasource`.
   - Register `MybatisPlusInterceptor` with `PaginationInnerInterceptor`.
   - Use `DbType.OTHER` so MySQL and Dameng can both run with dynamic datasource; database-specific SQL remains in XML.

4. Update MapperScan.
   - Change centralized scan import to `com.baomidou.mybatisplus.core.mapper.Mapper`.
   - Existing `@MapperScan("com.integrity.**.mapper")` remains the single entry point.

5. Add Dameng selectable datasource configuration.
   - Add Dameng driver dependency to modules that own database connections.
   - Make `integrity-system` local bootstrap driver/url/user/password env-driven.
   - Add commented Dameng sample values.

6. Update Nacos seed SQL.
   - Replace `mybatis:` blocks with `mybatis-plus:`.
   - Add a Dameng sample datasource block in comments where practical.

7. Document remaining SQL dialect work.
   - Add task review notes for `limit`, `date_format`, `information_schema`, `database()`, and `GROUP_CONCAT`.

8. Verify.
   - Run Maven compile/test for affected modules.
   - Run dependency tree checks for MyBatis-Plus and Dameng driver.
   - Run model review where available.
