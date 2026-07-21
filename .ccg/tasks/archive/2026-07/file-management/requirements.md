# File Management Requirements

## User Request

Add a file management feature under System Management. It must manage files uploaded through the existing file upload API, support querying uploaded file metadata, and preview uploaded files. Complete both backend and frontend work.

Frontend project path:

`D:\CodeProject\antigraviry_repository\Integrity-Supervision-Platform-Frontend`

## Confirmed Context

- The existing upload endpoint is `integrity-file` `POST /upload`, exposed to the frontend as `/file/upload`.
- The file service stores files but currently does not persist file metadata.
- The file service excludes datasource auto-configuration, so metadata persistence should remain in `integrity-system`.
- System management CRUD follows controller/service/mapper XML patterns with `BaseController`, `TableDataInfo`, `AjaxResult`, and `@RequiresPermissions`.
- Frontend routes are loaded from backend menu data. A database/menu SQL script is required for the new System Management entry and permissions.

## Functional Scope

- Record metadata when the existing file upload API succeeds.
- Provide backend management APIs for list, detail, delete, export, and internal save.
- Provide frontend API wrapper and System Management page.
- Support search by original file name, stored file name, content type/suffix, uploader, and upload time range.
- Support preview from the management page:
  - Images use an inline Element Plus image preview.
  - PDFs and other browser-viewable files open by URL in a new tab.
  - Unknown file types still expose the original URL for manual browser handling.

## Constraints

- Do not change existing upload response compatibility; keep returning `name` and `url`.
- Do not add datasource usage to `integrity-file`.
- Do not modify unrelated frontend user changes, especially the existing dirty `src/views/index.vue`.
