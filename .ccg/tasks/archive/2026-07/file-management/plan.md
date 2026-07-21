# File Management Plan

## Phase 1 - Backend

1. Extend the shared `SysFile` DTO with metadata fields while preserving `name` and `url`.
2. Add an internal Feign client from `integrity-file` to `integrity-system` for file metadata registration.
3. Enable Feign support in `integrity-file`, upload metadata after storage succeeds, and tolerate metadata registration failure without breaking file storage response only if the fallback returns failure.
4. Add `integrity-system` domain, mapper, service, controller, and XML for file metadata management.
5. Add SQL script for the metadata table, System Management menu, and permissions.

## Phase 2 - Frontend

1. Add `src/api/system/file.js`.
2. Add `src/views/system/file/index.vue` with search, table, detail dialog, image preview, open preview, delete, and export.
3. Reuse existing Element Plus/permission patterns and avoid touching existing dirty files.

## Phase 3 - Verification

1. Run Maven compile for affected backend modules.
2. Run frontend production build.
3. Review git diff for scope.
4. Run CCG review. Antigravity may be unavailable in this environment because the wrapper cannot find `agy`; record that if repeated.
