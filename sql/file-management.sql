-- File metadata table and System Management menu.
-- Run this script on the system database used by integrity-system.

create table sys_file_info (
    file_id       varchar(64)   not null,
    original_name varchar(255),
    file_name     varchar(255),
    file_suffix   varchar(32),
    content_type  varchar(128),
    file_size     bigint,
    url           varchar(1024) not null,
    create_by     varchar(64),
    create_time   datetime,
    update_by     varchar(64),
    update_time   datetime,
    remark        varchar(500),
    constraint pk_sys_file_info primary key (file_id)
);

create unique index uk_sys_file_info_url on sys_file_info (url);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 'SM_FILE', '文件管理', menu_id, '9', 'file', 'system/file/index', 1, 0, 'C', '0', '0', 'system:file:list', 'upload', 'admin', sysdate(), '', null, '文件管理菜单'
from sys_menu
where path = 'system' and parent_id = '0'
  and not exists (select 1 from sys_menu where menu_id = 'SM_FILE');

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 'SM_FILE_QUERY', '文件查询', 'SM_FILE', '1', '#', '', 1, 0, 'F', '0', '0', 'system:file:query', '#', 'admin', sysdate(), '', null, ''
where not exists (select 1 from sys_menu where menu_id = 'SM_FILE_QUERY');

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 'SM_FILE_REMOVE', '文件删除', 'SM_FILE', '2', '#', '', 1, 0, 'F', '0', '0', 'system:file:remove', '#', 'admin', sysdate(), '', null, ''
where not exists (select 1 from sys_menu where menu_id = 'SM_FILE_REMOVE');

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 'SM_FILE_EXPORT', '文件导出', 'SM_FILE', '3', '#', '', 1, 0, 'F', '0', '0', 'system:file:export', '#', 'admin', sysdate(), '', null, ''
where not exists (select 1 from sys_menu where menu_id = 'SM_FILE_EXPORT');
