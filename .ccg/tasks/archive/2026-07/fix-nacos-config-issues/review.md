# Review

## Result

- Final status: passed local verification.
- Antigravity review: attempted multiple times, but failed because `agy` is not available in PATH.
- Claude review: completed; blocking findings were addressed.

## Changes Reviewed

- Moved the Sentinel Nacos datasource out of the global app environment and scoped it to `integrity-gateway`.
- Added complete gateway Sentinel datasource settings: server address, username, password, dataId, groupId, data type and `gw-flow` rule type.
- Changed local Docker default to Nacos auth disabled, with empty client username/password so clients do not call `/auth/users/login` in local development.
- Kept `NACOS_AUTH_TOKEN` explicit in `.env` because the current Nacos image startup script requires a non-empty Base64 token even when auth is disabled.
- Added Nacos and Redis healthchecks, and changed application dependencies to `service_healthy`.
- Unified Java 17 base image defaults to `eclipse-temurin:17-jdk`.
- Updated Nacos config DB entries for both blank tenant and `public` tenant:
  - database and Redis values now use environment placeholders;
  - file and MinIO settings now use environment placeholders;
  - gateway Sentinel rules now include `integrity-flow` and `integrity-file`;
  - actuator exposure was narrowed to `health,info,metrics,prometheus`;
  - monitor and Druid credentials were converted to placeholders with local defaults.

## Verification

- `docker compose --env-file docker/.env -f docker/docker-compose.apps.yml config --quiet`
- Recreated Nacos, Redis and all application containers successfully.
- `docker compose ... ps` shows Nacos and Redis healthy, and all app containers running.
- Actuator health checks returned HTTP 200 for gateway, system, gen, job, flow, file and monitor.
- Log scan found no `auth/users/login`, `redirected too many`, `ErrCode:-401`, `ruleType null`, `DataSource ds1 build error`, `getRuleType`, `APPLICATION FAILED` or `Connection refused`.
- Gateway logs show successful subscription and notify for `sentinel-integrity-gateway` with md5 `e3a74b1226aba9e8baabea9eed96a6a9`.

## Residual Notes

- Direct HTTP access to the Nacos config OpenAPI still returns 401 on the current `nacos/nacos-server:latest` image, even with `nacos.core.auth.enabled=false`. Application clients read config successfully through the Nacos client path, so this was left as an image/version behavior rather than a blocker.
- `.env` is currently tracked by git in this repository. It contains local development defaults only, but production secrets should not be committed here.
