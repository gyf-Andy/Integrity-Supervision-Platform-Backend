## Review

### Result
- Translated English comments in `docker/.env` and `docker/.env.example` to Chinese.
- Kept environment variable names and values unchanged.

### Verification
- `git diff --check` passed.
- `docker compose --env-file docker/.env -f docker/docker-compose.infra.yml config --services` succeeded.

### Notes
- This was an S complexity, low-risk comment-only change, so no external model review was required.
