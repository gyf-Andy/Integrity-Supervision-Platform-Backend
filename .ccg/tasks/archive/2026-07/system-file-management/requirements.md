## Requirement

Add a backend file management capability under system management so administrators can query and view files uploaded by users.

## Scope

- Add persistent file metadata in the system module.
- Add paginated list and detail endpoints following existing system controller patterns.
- Add a system-side upload endpoint that uploads through the existing file service and records metadata.
- Record user avatar uploads in the new file metadata table.
- Provide SQL for the new table and menu permissions.

## Notes

- The existing file service only stores files and returns `SysFile{name,url}`; it does not have datasource dependencies.
- The system module owns database, permissions, and system management endpoints, so metadata management belongs there.
- Existing direct calls to the file service upload endpoint remain compatible but cannot be queried unless callers use the new system-side upload endpoint or explicitly record metadata.

