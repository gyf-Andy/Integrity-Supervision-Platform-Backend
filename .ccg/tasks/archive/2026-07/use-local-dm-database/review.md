## Review

### Result
- Default infrastructure startup no longer includes the Compose-managed `dm` service.
- `dm` remains available only through the `dm` profile.
- Nacos and application containers default to `DM_HOST=host.docker.internal`.
- `DM_CONFIG_SCHEMA` is separated from application `DM_SCHEMA`.
- Infrastructure images use `pull_policy: if_not_present` to avoid unnecessary remote checks when local images exist.
- `integrity-file` waits for `minio-init` with `service_completed_successfully`.

### External Review
- Antigravity analysis/review was attempted multiple times, but failed because `agy` is not available in PATH.
- Claude review found critical issues around `DM_CONFIG_SCHEMA`, `integrity-file`/`minio-init` dependency ordering, and optional `dm` healthcheck assumptions.
- Critical issues were fixed and final Claude review approved with non-blocking suggestions.

### Verification
- `Test-NetConnection 127.0.0.1:5236` succeeded.
- `docker compose -f docker/docker-compose.infra.yml config --images` does not include `dm8_single:latest`.
- `docker compose -f docker/docker-compose.infra.yml config --services` does not include `dm`.
- `docker compose -f docker/docker-compose.infra.yml --profile dm config` includes optional `dm`.
- `docker compose -f docker/docker-compose.infra.yml up -d --build` succeeded.
- `docker compose -f docker/docker-compose.infra.yml ps` shows Nacos, Redis, Sentinel, and MinIO running.
- `docker logs integrity-nacos` shows Nacos API and Console started successfully.
- `minio-init` exited with code 0.
- `git diff --check` passed.

### Remaining Notes
- If the optional `dm` profile is used later, set `DM_HOST=dm` and provide the `DM_IMAGE` image locally or through a reachable registry.
- Apps still wait for Nacos/Redis service start rather than health checks; current infra startup was verified successfully.
