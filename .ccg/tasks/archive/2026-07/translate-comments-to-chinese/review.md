# Review

## Summary

Replaced the newly added English comments and MinIO troubleshooting prose with Chinese wording.

## Changed Areas

- `MinioConfig.java`: endpoint field comment.
- `docker/.env`: MinIO image fallback comments.
- `docker/.env.example`: MinIO image fallback comments.
- `docker/README-docker.md`: Docker MinIO usage and registry EOF troubleshooting section.

## Verification

- Searched the edited files for the previous English comment phrases; no matches remain.
- `git diff --check` passed.
- `mvn -pl integrity-modules/integrity-file -am test` passed.
- `docker compose -f docker/docker-compose.infra.yml config` still resolves MinIO services correctly.
