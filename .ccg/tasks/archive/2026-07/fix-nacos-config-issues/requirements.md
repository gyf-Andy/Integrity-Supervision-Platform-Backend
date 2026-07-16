# Requirements

- Fix or optimize the Nacos config issues found in the previous review.
- Keep Docker local-development behavior working.
- Do not require pulling new images from public registries.
- Prefer env placeholders over hardcoded host/port/user/password values in Nacos configs.
- Remove incomplete global Sentinel datasource settings that cause non-gateway services to log errors.
- Keep gateway Sentinel rules aligned with gateway routes.
