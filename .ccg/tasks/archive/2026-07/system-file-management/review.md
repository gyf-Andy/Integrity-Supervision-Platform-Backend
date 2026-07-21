## External Review

Required CCG dual-model analysis/review was attempted but could not complete in this environment.

- antigravity backend failed because `agy` is not available in PATH.
- Claude backend failed because the configured model `deepseek-v4-pro` is unavailable or inaccessible.

## Local Review

### Critical

None found.

### Warning

- `sql/system_file_management.sql` uses a standalone table/menu seed script. The `SYSTEM_PARENT_ID` placeholder must be replaced with the real system-management menu id before execution.
- Existing clients that upload directly to the file service `/upload` will still store files but will not create queryable metadata records. New system-management uploads and avatar uploads are recorded.

### Info

- Endpoints follow existing system controller patterns:
  - `GET /file/list`
  - `GET /file/{fileId}`
  - `POST /file/upload`
- Permissions added in code are `system:file:list`, `system:file:view`, and `system:file:upload`.
- Verification passed with `mvn -pl integrity-modules/integrity-system -am test -DskipTests=false`.
