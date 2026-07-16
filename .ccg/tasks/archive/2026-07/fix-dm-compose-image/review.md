## Review

### Result
- The Compose file resolves the `dm` service image to `dm8_single:latest`.
- `docker images` shows no local `dm8_single:latest` or related DM image.
- The startup failure is therefore caused by Docker attempting to pull a local/private DM image name from a remote registry.

### Verification
- `docker compose -f docker/docker-compose.infra.yml config --services` includes `dm`.
- `docker compose -f docker/docker-compose.infra.yml config --images` includes `dm8_single:latest`.
- Local Docker image lookup returned no DM image.

### Next Action
- Load the DM image tar and tag it as `dm8_single:latest`, or set `DM_IMAGE` to a reachable private registry image.
