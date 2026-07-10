## Requirement

Configure the backend runtime to use the user-provided Dameng database connection information after migrating away from MySQL.

## Dameng Mapping

- `integrity-cloud` -> `INTEGRITY-CLOUD`
- `integrity-cloud-flow` -> `INTEGRITY-CLOUD-FLOW`
- `integrity-config` -> `INTEGRITY-CONFIG`
- `integrity-seata` -> `INTEGRITY-SEATA`
- username: `SYSDBA`
- password: `IntegritySupervision0`
- default port: `5236`
- default schema: `SYSDBA`

## Scope

- Switch local service datasource fallback configuration from MySQL to Dameng.
- Switch active Nacos `config_info` datasource records from MySQL to Dameng and refresh their md5 values.
- Switch Docker Nacos datasource properties from MySQL to Dameng.
- Preserve historical Nacos backup/history records.

## Risk Notes

- Nacos official datasource support requires a datasource plugin for non-default databases such as Dameng.
- Existing business SQL/DDL may still contain MySQL dialect syntax and needs separate runtime verification against the migrated Dameng schemas.
