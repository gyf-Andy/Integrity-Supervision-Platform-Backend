# Review

## Summary

Configured Docker mode to use MinIO for `integrity-file` and aligned Java service selection with `minio.enabled`.

## Changes

- Added MinIO and minio-init services to `docker/docker-compose.infra.yml`.
- Added MinIO environment variables to `docker/.env`, `docker/.env.example`, and app Compose env.
- Added `MINIO_ENDPOINT` support so the service uses `http://minio:9000` internally while returned file URLs use `MINIO_PUBLIC_URL`.
- Switched `ISysFileService` selection to conditional beans:
  - MinIO when `minio.enabled=true`.
  - Local file storage when `minio.enabled=false` or missing.
  - FastDFS only when `fdfs.enabled=true`.
- Kept MinIO upload extension/size validation aligned with local upload validation.
- Documented Docker MinIO usage in `docker/README-docker.md`.

## Verification

- `docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml config` passed.
- `docker compose --env-file docker/.env -f docker/docker-compose.infra.yml -f docker/docker-compose.apps.yml config --services` shows `minio`, `minio-init`, and `integrity-file`.
- `mvn -pl integrity-modules/integrity-file -am test` passed.
- `mvn -pl integrity-modules/integrity-file -am -DskipTests package` passed and generated `integrity-modules-file.jar`.
- `git diff --check` passed.

## External Review

Required CCG double-model analysis/review was attempted.

- antigravity failed because `agy` was not found in PATH.
- Claude wrapper failed with exit status 1.

## Docker Runtime Note

`docker compose ... build integrity-file` could not run because Docker Desktop daemon was not running:

`failed to connect to the docker API at npipe:////./pipe/dockerDesktopLinuxEngine`
