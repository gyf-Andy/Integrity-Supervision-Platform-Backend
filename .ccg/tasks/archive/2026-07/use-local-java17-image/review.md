## Review

### Result
- Changed `JAVA17_IMAGE` in `docker/.env` and `docker/.env.example` from `eclipse-temurin:17-jre` to local image `eclipse-temurin:17-jdk`.
- Kept `docker/Dockerfile.java17` parameterized so the base image can still be overridden through env files.

### Verification
- `docker image inspect eclipse-temurin:17-jdk` succeeded.
- `docker compose --env-file docker/.env -f docker/docker-compose.apps.yml config` shows `JAVA17_IMAGE: eclipse-temurin:17-jdk`.
- `docker compose --env-file docker/.env -f docker/docker-compose.apps.yml build integrity-flow` succeeded.
- `docker compose --env-file docker/.env -f docker/docker-compose.apps.yml up -d --build` succeeded.
- `docker compose --env-file docker/.env -f docker/docker-compose.apps.yml ps` shows application and infrastructure containers running.
- `git diff --check` passed.

### Notes
- This was an S complexity, low-risk env default change, so no external model review was required.
