# Requirements

- Do not start the Compose-managed `dm` service by default.
- Use the host machine's local Dameng database from Docker containers.
- Nacos and application containers should connect to `host.docker.internal:5236` by default.
- Keep the optional `dm` Compose service available for future use without requiring the image in normal startup.
- Update Docker documentation to describe the local DM requirement.
