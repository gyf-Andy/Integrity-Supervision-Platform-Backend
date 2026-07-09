/*
 Navicat Premium Data Transfer

 Source Server         : 本地数据库
 Source Server Type    : MySQL
 Source Server Version : 80032
 Source Host           : localhost:3306
 Source Schema         : integrity-cloud

 Target Server Type    : MySQL
 Target Server Version : 80032
 File Encoding         : 65001

 Date: 09/07/2026 10:20:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(0) NOT NULL COMMENT '触发的时间',
  `sched_time` bigint(0) NOT NULL COMMENT '定时器制定的时间',
  `priority` int(0) NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint(0) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(0) NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint(0) NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint(0) NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint(0) NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int(0) NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int(0) NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint(0) NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint(0) NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint(0) NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint(0) NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int(0) NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint(0) NOT NULL COMMENT '开始时间',
  `end_time` bigint(0) NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint(0) NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name`, `job_name`, `job_group`) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES ('1', '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2024-11-20 15:07:09', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES ('2', '用户管理-账号初始密码', 'sys.user.initPassword', 'liangli123321', 'Y', 'admin', '2024-11-20 15:07:09', 'admin', '2024-11-26 20:15:40', '初始化密码 123456');
INSERT INTO `sys_config` VALUES ('3', '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2024-11-20 15:07:10', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES ('4', '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2024-11-20 15:07:10', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES ('5', '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2024-11-20 15:07:11', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES ('6', '定时任务超时时间', 'task_time_out', '1', 'Y', 'admin', '2024-12-05 03:55:55', 'admin', '2024-12-05 03:56:11', '单位（分钟）');
INSERT INTO `sys_config` VALUES ('7', '任务异常通知内容', 'job_exception_notice_content', '尊敬的%s, 任务名称：%s, 跑批日期：%s, 跑批报错，报错内容：%s', 'Y', 'admin', '2024-12-05 06:18:23', '', NULL, NULL);
INSERT INTO `sys_config` VALUES ('8', '检测任务标签', 'detecting_task_label', '日终_1', 'Y', 'admin', '2024-12-09 10:37:29', 'admin', '2024-12-09 18:45:41', '检测任务管理名称为参数键值下的跑批数量');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `parent_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `ancestors` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(0) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES ('100', '0', '0', '廉政监管中心', 0, '廉政监管平台', '13800000000', 'admin@integrity-supervision.local', '0', '0', 'admin', '2024-11-20 15:01:49', '', NULL);
INSERT INTO `sys_dept` VALUES ('101', '100', '0,100', '深圳总公司', 1, '廉政监管平台', '13800000000', 'admin@integrity-supervision.local', '0', '0', 'admin', '2024-11-20 15:01:49', '', NULL);
INSERT INTO `sys_dept` VALUES ('102', '100', '0,100', '长沙分公司', 2, '廉政监管平台', '13800000000', 'admin@integrity-supervision.local', '0', '0', 'admin', '2024-11-20 15:01:50', '', NULL);
INSERT INTO `sys_dept` VALUES ('103', '101', '0,100,101', '研发部门', 1, '廉政监管平台', '13800000000', 'admin@integrity-supervision.local', '0', '0', 'admin', '2024-11-20 15:01:52', '', NULL);
INSERT INTO `sys_dept` VALUES ('104', '101', '0,100,101', '市场部门', 2, '廉政监管平台', '13800000000', 'admin@integrity-supervision.local', '0', '0', 'admin', '2024-11-20 15:01:53', '', NULL);
INSERT INTO `sys_dept` VALUES ('105', '101', '0,100,101', '测试部门', 3, '廉政监管平台', '13800000000', 'admin@integrity-supervision.local', '0', '0', 'admin', '2024-11-20 15:01:53', '', NULL);
INSERT INTO `sys_dept` VALUES ('106', '101', '0,100,101', '财务部门', 4, '廉政监管平台', '13800000000', 'admin@integrity-supervision.local', '0', '0', 'admin', '2024-11-20 15:01:54', '', NULL);
INSERT INTO `sys_dept` VALUES ('107', '101', '0,100,101', '运维部门', 5, '廉政监管平台', '13800000000', 'admin@integrity-supervision.local', '0', '0', 'admin', '2024-11-20 15:01:55', '', NULL);
INSERT INTO `sys_dept` VALUES ('108', '102', '0,100,102', '市场部门', 1, '廉政监管平台', '13800000000', 'admin@integrity-supervision.local', '0', '0', 'admin', '2024-11-20 15:01:55', '', NULL);
INSERT INTO `sys_dept` VALUES ('109', '102', '0,100,102', '财务部门', 2, '廉政监管平台', '13800000000', 'admin@integrity-supervision.local', '0', '0', 'admin', '2024-11-20 15:01:56', '', NULL);
INSERT INTO `sys_dept` VALUES ('SD2024112617542800000002', '101', '0,100,101', '系统管理部', 0, 'll', NULL, NULL, '0', '2', 'admin', '2024-11-26 17:54:27', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '字典编码',
  `dict_sort` int(0) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES ('1', 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2024-11-20 15:06:41', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES ('10', 1, '单任务', 'DEFAULT', 'sys_job_group', '', 'primary', 'Y', '0', 'admin', '2024-11-20 15:06:48', 'admin', '2024-12-09 09:37:50', '默认分组');
INSERT INTO `sys_dict_data` VALUES ('11', 2, '任务组', 'TASK_GROUP', 'sys_job_group', '', 'danger', 'N', '0', 'admin', '2024-11-20 15:06:48', 'admin', '2024-12-09 09:37:56', '系统分组');
INSERT INTO `sys_dict_data` VALUES ('12', 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2024-11-20 15:06:50', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES ('13', 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2024-11-20 15:06:50', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES ('14', 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2024-11-20 15:06:51', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES ('15', 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2024-11-20 15:06:51', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES ('16', 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2024-11-20 15:06:52', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES ('17', 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2024-11-20 15:06:53', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES ('18', 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-11-20 15:06:54', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES ('19', 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-11-20 15:06:54', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES ('2', 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-11-20 15:06:42', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES ('20', 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-11-20 15:06:55', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES ('21', 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-11-20 15:06:58', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES ('22', 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2024-11-20 15:07:00', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES ('23', 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-11-20 15:07:01', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES ('24', 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-11-20 15:07:01', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES ('25', 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-11-20 15:07:02', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES ('27', 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-11-20 15:07:04', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES ('28', 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2024-11-20 15:07:05', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES ('29', 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2024-11-20 15:07:05', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES ('3', 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-11-20 15:06:44', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES ('30', 0, 'iam_remote_verify_identno', 'IdentNo', 'iam_system', '610523199109122918', 'success', 'N', '0', 'admin', '2024-11-26 20:02:09', 'admin', '2024-11-26 20:08:36', NULL);
INSERT INTO `sys_dict_data` VALUES ('31', 0, 'iam_remote_verify_identType', 'IdentType', 'iam_system', NULL, 'success', 'N', '0', 'admin', '2024-11-26 20:02:49', 'admin', '2024-11-26 20:08:31', NULL);
INSERT INTO `sys_dict_data` VALUES ('4', 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2024-11-20 15:06:45', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES ('5', 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2024-11-20 15:06:45', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES ('6', 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2024-11-20 15:06:46', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES ('7', 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2024-11-20 15:06:46', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES ('8', 1, '正在跑批', '0', 'sys_job_status', '', 'info', 'Y', '0', 'admin', '2024-11-20 15:06:47', 'admin', '2024-12-05 03:25:44', '正在跑批');
INSERT INTO `sys_dict_data` VALUES ('9', 2, '跑批完成', '1', 'sys_job_status', '', 'success', 'N', '0', 'admin', '2024-11-20 15:06:47', 'admin', '2024-12-05 03:25:50', '跑批完成');
INSERT INTO `sys_dict_data` VALUES ('SDD2024112620081400000001', 0, 'iam_remote_verify_service_code', 'ServiceCode', 'iam_system', NULL, 'success', 'N', '0', 'admin', '2024-11-26 20:08:14', 'admin', '2024-11-26 20:08:24', NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD2024120316292900000001', 1, '秒任务', 'SECOND', 'batch_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-03 16:29:23', 'admin', '2024-12-07 11:26:34', NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD2024120316301000000002', 2, '分钟任务', 'MINUTE', 'batch_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-03 16:30:04', 'admin', '2024-12-07 11:26:31', NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD2024120316304800000003', 3, '小时任务', 'HOUR', 'batch_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-03 16:30:42', 'admin', '2024-12-07 11:26:28', NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD2024120513274100000001', 0, '跑批异常', '2', 'sys_job_status', NULL, 'danger', 'N', '0', 'admin', '2024-12-05 01:48:57', 'admin', '2024-12-05 03:26:08', '跑批异常');
INSERT INTO `sys_dict_data` VALUES ('SDD2024120514494200000002', 0, '任务超时', '3', 'sys_job_status', NULL, 'warning', 'N', '0', 'admin', '2024-12-05 03:17:48', 'admin', '2024-12-05 03:26:00', '任务超时');
INSERT INTO `sys_dict_data` VALUES ('SDD2024120516452700000003', 0, '立即执行', 'EXECUTE_IMMEDIATELY', 'job_run_mode', NULL, 'primary', 'N', '0', 'admin', '2024-12-05 05:23:12', 'admin', '2024-12-05 05:24:01', NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD2024120516454200000004', 0, '定时执行', 'TIMED_EXECUTION', 'job_run_mode', NULL, 'success', 'N', '0', 'admin', '2024-12-05 05:23:28', 'admin', '2024-12-05 05:24:06', NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD2024120516455900000005', 0, '异常执行', 'EXCEPTION_EXECUTION', 'job_run_mode', NULL, 'danger', 'N', '0', 'admin', '2024-12-05 05:23:47', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD2024120517284600000006', 0, '梁立', '32142423434', 'job_notice_peoples', NULL, 'info', 'N', '0', 'admin', '2024-12-05 06:10:08', 'admin', '2024-12-05 06:10:48', NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD2024120517290800000007', 0, '付鹏', '12343212321', 'job_notice_peoples', NULL, 'info', 'N', '0', 'admin', '2024-12-05 06:10:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD2024120517571700000008', 4, '日批', 'DAY', 'batch_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-05 06:41:01', 'admin', '2024-12-07 11:26:23', '每天执行N次');
INSERT INTO `sys_dict_data` VALUES ('SDD20241207000001', 5, '月批', 'MONTH', 'batch_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-07 11:25:38', 'admin', '2024-12-07 11:26:16', NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241207000002', 6, '年批', 'YEAR', 'batch_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-07 11:25:53', 'admin', '2024-12-07 11:26:10', NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241207000003', 0, 'python', 'python', 'sys_job_actuator_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-07 16:59:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241207000004', 0, 'shell', 'shell', 'sys_job_actuator_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-07 17:00:05', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241207000005', 0, 'bean', 'bean', 'sys_job_actuator_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-07 17:00:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241207000006', 0, '存储过程', 'procedure', 'sys_job_actuator_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-07 17:00:34', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241209000001', 0, 'job_day_switch', 'true', 'job_switch', '', 'primary', 'N', '0', 'admin', '2024-12-09 11:52:33', 'admin', '2024-12-09 13:30:23', '日批切批开关');
INSERT INTO `sys_dict_data` VALUES ('SDD20241209000002', 0, 'job_month_switch', 'true', 'job_switch', NULL, 'primary', 'N', '0', 'admin', '2024-12-09 11:52:57', 'admin', '2024-12-09 11:54:19', '月批切批开关');
INSERT INTO `sys_dict_data` VALUES ('SDD20241209000003', 0, 'job_year_switch', 'true', 'job_switch', NULL, 'primary', 'N', '0', 'admin', '2024-12-09 11:53:54', 'admin', '2024-12-09 11:54:07', '年批切批开关');
INSERT INTO `sys_dict_data` VALUES ('SDD20241209000004', 0, '任务组同一批所有任务等待', '0', 'job_queue_status', NULL, 'primary', 'N', '0', 'admin', '2024-12-09 20:17:28', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241209000005', 0, '任务组同一批所有任务完成', '1', 'job_queue_status', NULL, 'success', 'N', '0', 'admin', '2024-12-09 20:17:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241209000006', 0, '等待调起', '0', 'job_monitor_status', NULL, 'primary', 'N', '0', 'admin', '2024-12-09 20:18:03', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241209000007', 0, '调度完成', '1', 'job_monitor_status', NULL, 'success', 'N', '0', 'admin', '2024-12-09 20:18:12', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241209000008', 0, '调度中', '2', 'job_monitor_status', NULL, 'info', 'N', '0', 'admin', '2024-12-09 20:18:20', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000001', 0, '串行-简单', '0', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2024-12-16 15:45:11', '', NULL, 'leaveFlow-serial1');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000002', 0, '串行-通过互斥', '1', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2024-12-16 15:45:42', '', NULL, 'leaveFlow-serial2');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000003', 0, '并行-汇聚', '2', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2024-12-16 15:46:00', '', NULL, 'leaveFlow-parallel1');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000004', 0, '并行-分开', '3', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2024-12-16 15:46:14', '', NULL, 'leaveFlow-parallel2');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000005', 0, '串行-退回互斥', '4', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2024-12-16 15:46:52', '', NULL, 'leaveFlow-serial3');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000006', 0, '会签', '5', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2024-12-16 15:47:22', '', NULL, 'leaveFlow-meet-sign');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000007', 0, '票签', '6', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2024-12-16 15:47:54', '', NULL, 'leaveFlow-vote-sign');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000008', 0, '串行-复杂互斥', '7', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2024-12-16 15:48:36', '', NULL, 'leaveFlow-serial4');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000009', 0, '并行-串行', '8', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2024-12-16 15:48:52', '', NULL, 'leaveFlow-parallel3');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000010', 0, '办理人权限表达式', '9', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2024-12-16 15:49:06', '', NULL, 'leaveFlow-serial5');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000011', 0, '监听器', '10', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2024-12-16 15:49:34', '', NULL, 'leaveFlow-serial6');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000012', 0, '待提交', '0', 'flow_status', NULL, 'info', 'N', '0', 'admin', '2024-12-16 15:52:03', 'admin', '2024-12-16 15:53:28', '待提交');
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000013', 0, '审批中', '1', 'flow_status', NULL, 'primary', 'N', '0', 'admin', '2024-12-16 15:52:19', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000014', 0, '审批通过', '2', 'flow_status', NULL, 'primary', 'N', '0', 'admin', '2024-12-16 15:52:29', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000015', 0, '自动完成', '3', 'flow_status', NULL, 'primary', 'N', '0', 'admin', '2024-12-16 15:52:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000016', 0, '已完成', '8', 'flow_status', NULL, 'success', 'N', '0', 'admin', '2024-12-16 15:52:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000017', 0, '退回', '9', 'flow_status', NULL, 'warning', 'N', '0', 'admin', '2024-12-16 15:53:08', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000018', 0, '失效', '10', 'flow_status', NULL, 'info', 'N', '0', 'admin', '2024-12-16 15:53:23', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000019', 0, '未发布', '0', 'is_publish', NULL, 'warning', 'N', '0', 'admin', '2024-12-16 15:54:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000020', 0, '已发布', '1', 'is_publish', NULL, 'success', 'N', '0', 'admin', '2024-12-16 15:54:12', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000021', 0, '已失效', '9', 'is_publish', NULL, 'danger', 'N', '0', 'admin', '2024-12-16 15:54:22', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000022', 0, '开始节点', '0', 'node_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-16 15:54:58', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000023', 0, '中间节点', '1', 'node_type', NULL, 'success', 'N', '0', 'admin', '2024-12-16 15:55:08', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000024', 0, '结束节点', '2', 'node_type', NULL, 'success', 'N', '0', 'admin', '2024-12-16 15:55:20', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000025', 0, '互斥网关', '3', 'node_type', NULL, 'warning', 'N', '0', 'admin', '2024-12-16 15:55:34', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000026', 0, '并行网关', '4', 'node_type', NULL, 'warning', 'N', '0', 'admin', '2024-12-16 15:55:48', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000027', 0, '审批', '1', 'cooperate_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-16 15:56:20', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000028', 0, '转办', '2', 'cooperate_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-16 15:56:28', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000029', 0, '委派', '3', 'cooperate_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-16 15:56:36', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000030', 0, '会签', '4', 'cooperate_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-16 15:56:45', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000031', 0, '票签', '5', 'cooperate_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-16 15:56:55', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000032', 0, '加签', '6', 'cooperate_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-16 15:57:05', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES ('SDD20241216000033', 0, '减签', '7', 'cooperate_type', NULL, 'primary', 'N', '0', 'admin', '2024-12-16 15:57:17', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES ('1', '用户性别', 'sys_user_sex', '0', 'admin', '2024-11-20 15:06:10', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES ('10', '系统状态', 'sys_common_status', '0', 'admin', '2024-11-20 15:06:15', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES ('2', '菜单状态', 'sys_show_hide', '0', 'admin', '2024-11-20 15:06:10', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES ('3', '系统开关', 'sys_normal_disable', '0', 'admin', '2024-11-20 15:06:11', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES ('4', '任务状态', 'sys_job_status', '0', 'admin', '2024-11-20 15:06:12', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES ('5', '任务分组', 'sys_job_group', '0', 'admin', '2024-11-20 15:06:13', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES ('6', '系统是否', 'sys_yes_no', '0', 'admin', '2024-11-20 15:06:13', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES ('7', '通知类型', 'sys_notice_type', '0', 'admin', '2024-11-20 15:06:14', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES ('8', '通知状态', 'sys_notice_status', '0', 'admin', '2024-11-20 15:06:14', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES ('9', '操作类型', 'sys_oper_type', '0', 'admin', '2024-11-20 15:06:15', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES ('SDT2024112618002500000003', '统一认证平台', 'iam_system', '0', 'admin', '2024-11-26 18:00:24', '', NULL, '统一认证平台');
INSERT INTO `sys_dict_type` VALUES ('SDT2024120316282900000001', '跑批类型', 'batch_type', '0', 'admin', '2024-12-03 16:28:23', 'admin', '2024-12-07 11:29:26', NULL);
INSERT INTO `sys_dict_type` VALUES ('SDT2024120516444500000001', '任务运行模式', 'job_run_mode', '0', 'admin', '2024-12-05 05:22:27', '', NULL, '任务运行模式');
INSERT INTO `sys_dict_type` VALUES ('SDT2024120517280600000002', '任务通知人', 'job_notice_peoples', '0', 'admin', '2024-12-05 06:09:25', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES ('SDT20241207000001', '跑批管理执行器类型', 'sys_job_actuator_type', '0', 'admin', '2024-12-07 16:59:28', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES ('SDT20241209000001', '定时任务开关', 'job_switch', '0', 'admin', '2024-12-09 11:51:54', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES ('SDT20241209000002', '任务队列状态', 'job_queue_status', '0', 'admin', '2024-12-09 20:16:19', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES ('SDT20241209000003', '任务监控状态', 'job_monitor_status', '0', 'admin', '2024-12-09 20:16:31', 'admin', '2024-12-09 20:19:47', NULL);
INSERT INTO `sys_dict_type` VALUES ('SDT20241216000001', '请假类型', 'leave_type', '0', 'admin', '2024-12-16 15:44:22', '', NULL, '请假类型列表');
INSERT INTO `sys_dict_type` VALUES ('SDT20241216000002', '流程状态', 'flow_status', '0', 'admin', '2024-12-16 15:50:37', '', NULL, '流程状态');
INSERT INTO `sys_dict_type` VALUES ('SDT20241216000003', '是否发布', 'is_publish', '0', 'admin', '2024-12-16 15:50:48', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES ('SDT20241216000004', '节点类型', 'node_type', '0', 'admin', '2024-12-16 15:50:58', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES ('SDT20241216000005', '协作类型', 'cooperate_type', '0', 'admin', '2024-12-16 15:51:10', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES ('SDT20260708000004', '测试', 'sys_dict', '0', 'admin', '2026-07-08 17:16:26', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '任务组名',
  `parent_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '父任务ID',
  `parent_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '父任务名称',
  `batch_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '跑批类型（秒任务，分钟任务，小时任务，日批，月批，年批）',
  `if_dependent` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '是否可被依赖（Y=是,N=否）',
  `invoke_target` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `exception_retry_count` int(0) NULL DEFAULT NULL COMMENT '异常重试次数',
  `exception_wait_second` int(0) NULL DEFAULT NULL COMMENT '异常等待时间',
  `actuator_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT 'shell,procedure,python,bean',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `order_num` int(0) NULL DEFAULT NULL COMMENT '显示顺序',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '备注信息',
  `job_type` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '任务类型',
  PRIMARY KEY (`job_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_job_dependent
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_dependent`;
CREATE TABLE `sys_job_dependent`  (
  `job_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '任务ID',
  `dependent_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `batch_index` int(0) NOT NULL COMMENT '批次',
  `create_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '同步sys_job中job_id状态',
  PRIMARY KEY (`job_id`, `dependent_id`, `batch_index`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '任务日志ID',
  `job_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL COMMENT '异常信息',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `batch_date` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '跑批日期',
  `dependent_id` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL COMMENT '依赖内容',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '开始时间',
  `stop_time` datetime(0) NULL DEFAULT NULL COMMENT '结束时间',
  `run_time` int(0) NULL DEFAULT NULL COMMENT '运行时长（秒）',
  `run_mode` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '运行模式',
  PRIMARY KEY (`job_log_id`) USING BTREE,
  INDEX `idx_job_id_batch_date`(`job_id`, `batch_date`, `run_mode`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_job_monitor
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_monitor`;
CREATE TABLE `sys_job_monitor`  (
  `job_monitor_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '监控ID',
  `job_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '任务ID',
  `dependent_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '依赖ID',
  `parent_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '父任务名称',
  `batch_date` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '跑批日期',
  `batch_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '跑批类型',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '插入时间',
  `invoke_target` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL COMMENT '调用字符串',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '0-等待调起,1-调度完成,2-调度中',
  PRIMARY KEY (`job_monitor_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_job_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_notice`;
CREATE TABLE `sys_job_notice`  (
  `job_notice_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '任务通知id',
  `job_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '任务id',
  `job_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '任务名称',
  `notice_content` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL COMMENT '通知内容',
  `notice_target` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '通知目标（邮件、短信等）',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `batch_date` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '跑批时间',
  `if_handle` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT 'N' COMMENT '是否处理',
  PRIMARY KEY (`job_notice_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_job_queue
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_queue`;
CREATE TABLE `sys_job_queue`  (
  `job_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '任务id',
  `batch_date` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '跑批日期',
  `dependent_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '依赖ID',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '状态(3-等待同批次执行完成)',
  `batch_index` int(0) NULL DEFAULT NULL COMMENT '批次',
  PRIMARY KEY (`dependent_id`, `batch_date`, `job_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_login_info
-- ----------------------------
DROP TABLE IF EXISTS `sys_login_info`;
CREATE TABLE `sys_login_info`  (
  `info_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '提示信息',
  `access_time` datetime(0) NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`access_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_login_info
-- ----------------------------
INSERT INTO `sys_login_info` VALUES ('SLI20241216000001', 'admin', '127.0.0.1', '0', '登录成功', '2024-12-16 15:29:44');
INSERT INTO `sys_login_info` VALUES ('SLI20241216000002', 'admin', '127.0.0.1', '0', '退出成功', '2024-12-16 15:34:37');
INSERT INTO `sys_login_info` VALUES ('SLI20241216000003', 'admin', '127.0.0.1', '0', '登录成功', '2024-12-16 15:34:40');
INSERT INTO `sys_login_info` VALUES ('SLI20260708000017', 'admin', '127.0.0.1', '0', '登录成功', '2026-07-08 17:32:00');
INSERT INTO `sys_login_info` VALUES ('SLI20260708000019', 'admin', '127.0.0.1', '0', '退出成功', '2026-07-08 17:36:02');
INSERT INTO `sys_login_info` VALUES ('SLI20260708000020', 'admin', '127.0.0.1', '0', '登录成功', '2026-07-08 17:36:10');
INSERT INTO `sys_login_info` VALUES ('SLI20260708000021', 'admin', '127.0.0.1', '0', '登录成功', '2026-07-08 21:56:54');
INSERT INTO `sys_login_info` VALUES ('SLI20260708000022', 'admin', '127.0.0.1', '0', '登录成功', '2026-07-08 21:57:22');
INSERT INTO `sys_login_info` VALUES ('SLI20260708000023', 'admin', '127.0.0.1', '0', '登录成功', '2026-07-08 22:02:00');
INSERT INTO `sys_login_info` VALUES ('SLI20260709000001', 'admin', '127.0.0.1', '0', '登录成功', '2026-07-09 09:38:59');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int(0) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int(0) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(0) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1', '系统管理', '0', 2, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-11-20 15:02:25', 'admin', '2024-12-05 04:02:13', '系统管理目录');
INSERT INTO `sys_menu` VALUES ('100', '用户管理', '1', 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-11-20 15:02:33', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES ('1000', '用户查询', '100', 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2024-11-20 15:02:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1001', '用户新增', '100', 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2024-11-20 15:02:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1002', '用户修改', '100', 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2024-11-20 15:02:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1003', '用户删除', '100', 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2024-11-20 15:02:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1004', '用户导出', '100', 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2024-11-20 15:02:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1005', '用户导入', '100', 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2024-11-20 15:02:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1006', '重置密码', '100', 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2024-11-20 15:02:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1007', '角色查询', '101', 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2024-11-20 15:02:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1008', '角色新增', '101', 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2024-11-20 15:02:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1009', '角色修改', '101', 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2024-11-20 15:03:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('101', '角色管理', '1', 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-11-20 15:02:34', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES ('1010', '角色删除', '101', 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2024-11-20 15:03:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1011', '角色导出', '101', 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2024-11-20 15:03:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1012', '菜单查询', '102', 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2024-11-20 15:03:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1013', '菜单新增', '102', 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2024-11-20 15:03:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1014', '菜单修改', '102', 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2024-11-20 15:03:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1015', '菜单删除', '102', 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2024-11-20 15:03:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1016', '部门查询', '103', 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2024-11-20 15:03:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1017', '部门新增', '103', 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2024-11-20 15:03:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1018', '部门修改', '103', 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2024-11-20 15:03:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1019', '部门删除', '103', 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2024-11-20 15:03:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('102', '菜单管理', '1', 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-11-20 15:02:34', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES ('1020', '岗位查询', '104', 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2024-11-20 15:03:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1021', '岗位新增', '104', 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2024-11-20 15:03:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1022', '岗位修改', '104', 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2024-11-20 15:03:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1023', '岗位删除', '104', 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2024-11-20 15:03:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1024', '岗位导出', '104', 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2024-11-20 15:03:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1025', '字典查询', '105', 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2024-11-20 15:03:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1026', '字典新增', '105', 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2024-11-20 15:03:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1027', '字典修改', '105', 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2024-11-20 15:03:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1028', '字典删除', '105', 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2024-11-20 15:03:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1029', '字典导出', '105', 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2024-11-20 15:03:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('103', '部门管理', '1', 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2024-11-20 15:02:35', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES ('1030', '参数查询', '106', 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2024-11-20 15:03:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1031', '参数新增', '106', 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2024-11-20 15:03:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1032', '参数修改', '106', 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2024-11-20 15:03:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1033', '参数删除', '106', 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2024-11-20 15:03:17', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1034', '参数导出', '106', 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2024-11-20 15:03:17', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1035', '公告查询', '107', 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2024-11-20 15:03:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1036', '公告新增', '107', 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2024-11-20 15:03:21', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1037', '公告修改', '107', 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2024-11-20 15:03:21', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1038', '公告删除', '107', 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2024-11-20 15:03:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1039', '操作查询', '500', 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:operatorLog:query', '#', 'admin', '2024-11-20 15:03:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('104', '岗位管理', '1', 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2024-11-20 15:02:35', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES ('1040', '操作删除', '500', 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:operatorLog:remove', '#', 'admin', '2024-11-20 15:03:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1041', '日志导出', '500', 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:operatorLog:export', '#', 'admin', '2024-11-20 15:03:24', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1042', '登录查询', '501', 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:loginInfo:query', '#', 'admin', '2024-11-20 15:03:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1043', '登录删除', '501', 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:loginInfo:remove', '#', 'admin', '2024-11-20 15:03:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1044', '日志导出', '501', 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:loginInfo:export', '#', 'admin', '2024-11-20 15:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1045', '账户解锁', '501', 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:loginInfo:unlock', '#', 'admin', '2024-11-20 15:03:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1046', '在线查询', '109', 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2024-11-20 15:03:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1047', '批量强退', '109', 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2024-11-20 15:03:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1048', '单条强退', '109', 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2024-11-20 15:03:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1049', '任务查询', '110', 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-11-20 15:03:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('105', '字典管理', '1', 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2024-11-20 15:02:36', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES ('1050', '任务新增', '110', 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2024-11-20 15:03:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1051', '任务修改', '110', 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2024-11-20 15:03:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1052', '任务删除', '110', 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2024-11-20 15:03:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1053', '状态修改', '110', 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2024-11-20 15:03:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('1054', '任务导出', '110', 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2024-11-20 15:03:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('106', '参数设置', '1', 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-11-20 15:02:37', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES ('107', '通知公告', '1', 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2024-11-20 15:02:40', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES ('108', '日志管理', '1', 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2024-11-20 15:02:41', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES ('109', '在线用户', '2', 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-11-20 15:02:42', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES ('110', '任务管理', 'SM2024120209280700000001', 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-11-20 15:02:43', 'admin', '2024-12-06 09:11:16', '定时任务菜单');
INSERT INTO `sys_menu` VALUES ('111', 'Sentinel控制台', '2', 3, 'http://localhost:8718', '', '', '', 0, 0, 'C', '0', '0', 'monitor:sentinel:list', 'sentinel', 'admin', '2024-11-20 15:02:44', '', NULL, '流量控制菜单');
INSERT INTO `sys_menu` VALUES ('112', 'Nacos控制台', '2', 4, 'http://192.168.206.196:8085', '', '', '', 0, 0, 'C', '0', '0', 'monitor:nacos:list', 'nacos', 'admin', '2024-11-20 15:02:44', 'admin', '2026-07-08 17:37:51', '服务治理菜单');
INSERT INTO `sys_menu` VALUES ('113', 'Admin控制台', '2', 5, 'http://localhost:9100/login', '', '', '', 0, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-11-20 15:02:45', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES ('116', '系统接口', '2', 3, 'http://localhost:8080/swagger-ui/index.html', '', '', '', 0, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2024-11-20 15:02:47', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES ('2', '系统监控', '0', 3, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2024-11-20 15:02:26', 'admin', '2024-12-05 04:02:18', '系统监控目录');
INSERT INTO `sys_menu` VALUES ('500', '操作日志', '108', 1, 'operlog', 'system/operlog/index', '', '', 1, 0, 'C', '0', '0', 'system:operatorLog:list', 'form', 'admin', '2024-11-20 15:02:49', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES ('501', '登录日志', '108', 2, 'logininfor', 'system/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'system:loginInfo:list', 'logininfor', 'admin', '2024-11-20 15:02:49', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES ('SM2024120209280700000001', '跑批管理', '0', 1, '/job/index', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'job', 'admin', '2024-12-02 09:28:01', 'admin', '2024-12-05 04:02:05', '');
INSERT INTO `sys_menu` VALUES ('SM2024120310463500000005', '任务日志', 'SM2024120209280700000001', 2, 'log', 'monitor/job/log', NULL, '', 1, 0, 'C', '0', '0', '', 'log', 'admin', '2024-12-03 10:46:29', 'admin', '2024-12-05 09:52:09', '');
INSERT INTO `sys_menu` VALUES ('SM2024120516100800000001', '任务详情', 'SM2024120310463500000005', 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-12-05 04:44:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('SM2024120516104100000002', '任务重跑', 'SM2024120310463500000005', 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'monitor:job:refresh', '#', 'admin', '2024-12-05 04:45:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('SM2024120517454800000003', '任务通知', 'SM2024120209280700000001', 3, 'notify', 'monitor/job/notify', NULL, '', 1, 0, 'C', '0', '0', 'monitor:job:notify', 'message', 'admin', '2024-12-05 06:28:35', 'admin', '2024-12-05 09:54:24', '');
INSERT INTO `sys_menu` VALUES ('SM20241209000001', '重要任务', 'SM2024120209280700000001', 4, 'importantNotice', 'monitor/job/importantNotice', NULL, '', 1, 0, 'C', '0', '0', '', 'monitor', 'admin', '2024-12-09 09:01:53', 'admin', '2024-12-09 19:43:24', '');
INSERT INTO `sys_menu` VALUES ('SM20241214000001', '流程管理', '0', 0, 'flow', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'form', 'admin', '2024-12-14 15:26:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('SM20241214000002', '流程定义', 'SM20241214000001', 1, 'definition', 'flow/definition/index', NULL, '', 1, 0, 'C', '0', '0', 'flow:definition:list', 'online', 'admin', '2024-12-14 15:28:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('SM20241214000003', '待办任务', 'SM20241214000001', 2, 'todo', 'flow/task/todo/index', NULL, '', 1, 0, 'C', '0', '0', 'flow:execute:toDoPage', 'guide', 'admin', '2024-12-14 15:29:07', 'admin', '2024-12-14 15:29:35', '');
INSERT INTO `sys_menu` VALUES ('SM20241214000004', '已办任务', 'SM20241214000001', 3, '1', 'flow/task/done/index', NULL, '', 1, 0, 'C', '0', '0', 'flow:execute:donePage', 'clipboard', 'admin', '2024-12-14 15:30:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('SM20241214000005', '抄送任务', 'SM20241214000001', 4, 'notice', 'flow/fnoticy/index', NULL, '', 1, 0, 'C', '0', '0', 'flow:execute:copyPage', 'email', 'admin', '2024-12-14 15:31:13', 'admin', '2024-12-16 15:34:15', '');
INSERT INTO `sys_menu` VALUES ('SM20241214000006', '测试菜单', '0', 0, 'test', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'example', 'admin', '2024-12-14 15:33:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES ('SM20241214000007', 'OA请假申请', 'SM20241214000006', 1, 'leave', 'system/leave/index', NULL, '', 1, 0, 'C', '0', '0', 'system:leave:list', 'documentation', 'admin', '2024-12-14 15:35:09', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_operator_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_operator_log`;
CREATE TABLE `sys_operator_log`  (
  `oper_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(0) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(0) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(0) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(0) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_operator_log
-- ----------------------------
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000001', '菜单管理', 2, 'com.integrity.system.controller.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/menu', '127.0.0.1', '', '{\"children\":[],\"component\":\"flow/fnoticy/index\",\"createTime\":\"2024-12-14 15:31:13\",\"icon\":\"email\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":\"SM20241214000005\",\"menuName\":\"抄送任务\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":\"SM20241214000001\",\"path\":\"notice\",\"perms\":\"flow:execute:copyPage\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:34:15', 24);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000002', '字典类型', 1, 'com.integrity.system.controller.SysDictTypeController.add()', 'POST', 1, 'admin', NULL, '/dict/type', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictId\":\"SDT20241216000001\",\"dictName\":\"请假类型\",\"dictType\":\"leave_type\",\"params\":{},\"remark\":\"请假类型列表\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:44:22', 17);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000003', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000001\",\"dictLabel\":\"串行-简单\",\"dictSort\":0,\"dictType\":\"leave_type\",\"dictValue\":\"0\",\"listClass\":\"default\",\"params\":{},\"remark\":\"leaveFlow-serial1\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:45:11', 4);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000004', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000002\",\"dictLabel\":\"串行-通过互斥\",\"dictSort\":0,\"dictType\":\"leave_type\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"remark\":\"leaveFlow-serial2\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:45:42', 10);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000005', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000003\",\"dictLabel\":\"并行-汇聚\",\"dictSort\":0,\"dictType\":\"leave_type\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"remark\":\"leaveFlow-parallel1\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:46:00', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000006', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000004\",\"dictLabel\":\"并行-分开\",\"dictSort\":0,\"dictType\":\"leave_type\",\"dictValue\":\"3\",\"listClass\":\"default\",\"params\":{},\"remark\":\"leaveFlow-parallel2\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:46:14', 13);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000007', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000005\",\"dictLabel\":\"串行-退回互斥\",\"dictSort\":0,\"dictType\":\"leave_type\",\"dictValue\":\"4\",\"listClass\":\"default\",\"params\":{},\"remark\":\"leaveFlow-serial3\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:46:52', 11);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000008', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000006\",\"dictLabel\":\"会签\",\"dictSort\":0,\"dictType\":\"leave_type\",\"dictValue\":\"5\",\"listClass\":\"default\",\"params\":{},\"remark\":\"leaveFlow-meet-sign\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:47:22', 9);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000009', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000007\",\"dictLabel\":\"票签\",\"dictSort\":0,\"dictType\":\"leave_type\",\"dictValue\":\"6\",\"listClass\":\"default\",\"params\":{},\"remark\":\"leaveFlow-vote-sign\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:47:54', 11);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000010', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000008\",\"dictLabel\":\"串行-复杂互斥\",\"dictSort\":0,\"dictType\":\"leave_type\",\"dictValue\":\"7\",\"listClass\":\"default\",\"params\":{},\"remark\":\"leaveFlow-serial4\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:48:36', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000011', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000009\",\"dictLabel\":\"并行-串行\",\"dictSort\":0,\"dictType\":\"leave_type\",\"dictValue\":\"8\",\"listClass\":\"default\",\"params\":{},\"remark\":\"leaveFlow-parallel3\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:48:52', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000012', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000010\",\"dictLabel\":\"办理人权限表达式\",\"dictSort\":0,\"dictType\":\"leave_type\",\"dictValue\":\"9\",\"listClass\":\"default\",\"params\":{},\"remark\":\"leaveFlow-serial5\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:49:06', 16);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000013', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000011\",\"dictLabel\":\"监听器\",\"dictSort\":0,\"dictType\":\"leave_type\",\"dictValue\":\"10\",\"listClass\":\"default\",\"params\":{},\"remark\":\"leaveFlow-serial6\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:49:34', 13);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000014', '字典类型', 1, 'com.integrity.system.controller.SysDictTypeController.add()', 'POST', 1, 'admin', NULL, '/dict/type', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictId\":\"SDT20241216000002\",\"dictName\":\"流程状态\",\"dictType\":\"flow_status\",\"params\":{},\"remark\":\"流程状态\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:50:37', 2);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000015', '字典类型', 1, 'com.integrity.system.controller.SysDictTypeController.add()', 'POST', 1, 'admin', NULL, '/dict/type', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictId\":\"SDT20241216000003\",\"dictName\":\"是否发布\",\"dictType\":\"is_publish\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:50:48', 15);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000016', '字典类型', 1, 'com.integrity.system.controller.SysDictTypeController.add()', 'POST', 1, 'admin', NULL, '/dict/type', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictId\":\"SDT20241216000004\",\"dictName\":\"节点类型\",\"dictType\":\"node_type\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:50:58', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000017', '字典类型', 1, 'com.integrity.system.controller.SysDictTypeController.add()', 'POST', 1, 'admin', NULL, '/dict/type', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictId\":\"SDT20241216000005\",\"dictName\":\"协作类型\",\"dictType\":\"cooperate_type\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:51:10', 16);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000018', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000012\",\"dictLabel\":\"待提交\",\"dictSort\":0,\"dictType\":\"flow_status\",\"dictValue\":\"0\",\"listClass\":\"default\",\"params\":{},\"remark\":\"待提交\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:52:03', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000019', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000013\",\"dictLabel\":\"审批中\",\"dictSort\":0,\"dictType\":\"flow_status\",\"dictValue\":\"1\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:52:19', 14);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000020', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000014\",\"dictLabel\":\"审批通过\",\"dictSort\":0,\"dictType\":\"flow_status\",\"dictValue\":\"2\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:52:29', 14);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000021', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000015\",\"dictLabel\":\"自动完成\",\"dictSort\":0,\"dictType\":\"flow_status\",\"dictValue\":\"3\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:52:39', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000022', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000016\",\"dictLabel\":\"已完成\",\"dictSort\":0,\"dictType\":\"flow_status\",\"dictValue\":\"8\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:52:49', 1);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000023', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000017\",\"dictLabel\":\"退回\",\"dictSort\":0,\"dictType\":\"flow_status\",\"dictValue\":\"9\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:53:08', 10);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000024', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000018\",\"dictLabel\":\"失效\",\"dictSort\":0,\"dictType\":\"flow_status\",\"dictValue\":\"10\",\"listClass\":\"info\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:53:23', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000025', '字典数据', 2, 'com.integrity.system.controller.SysDictDataController.edit()', 'PUT', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"createTime\":\"2024-12-16 15:52:03\",\"dictCode\":\"SDD20241216000012\",\"dictLabel\":\"待提交\",\"dictSort\":0,\"dictType\":\"flow_status\",\"dictValue\":\"0\",\"isDefault\":\"N\",\"listClass\":\"info\",\"params\":{},\"remark\":\"待提交\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:53:28', 16);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000026', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000019\",\"dictLabel\":\"未发布\",\"dictSort\":0,\"dictType\":\"is_publish\",\"dictValue\":\"0\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:54:02', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000027', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000020\",\"dictLabel\":\"已发布\",\"dictSort\":0,\"dictType\":\"is_publish\",\"dictValue\":\"1\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:54:12', 11);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000028', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000021\",\"dictLabel\":\"已失效\",\"dictSort\":0,\"dictType\":\"is_publish\",\"dictValue\":\"9\",\"listClass\":\"danger\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:54:22', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000029', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000022\",\"dictLabel\":\"开始节点\",\"dictSort\":0,\"dictType\":\"node_type\",\"dictValue\":\"0\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:54:58', 10);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000030', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000023\",\"dictLabel\":\"中间节点\",\"dictSort\":0,\"dictType\":\"node_type\",\"dictValue\":\"1\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:55:08', 15);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000031', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000024\",\"dictLabel\":\"结束节点\",\"dictSort\":0,\"dictType\":\"node_type\",\"dictValue\":\"2\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:55:20', 15);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000032', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000025\",\"dictLabel\":\"互斥网关\",\"dictSort\":0,\"dictType\":\"node_type\",\"dictValue\":\"3\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:55:34', 9);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000033', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000026\",\"dictLabel\":\"并行网关\",\"dictSort\":0,\"dictType\":\"node_type\",\"dictValue\":\"4\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:55:48', 1);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000034', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000027\",\"dictLabel\":\"审批\",\"dictSort\":0,\"dictType\":\"cooperate_type\",\"dictValue\":\"1\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:56:20', 11);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000035', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000028\",\"dictLabel\":\"转办\",\"dictSort\":0,\"dictType\":\"cooperate_type\",\"dictValue\":\"2\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:56:28', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000036', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000029\",\"dictLabel\":\"委派\",\"dictSort\":0,\"dictType\":\"cooperate_type\",\"dictValue\":\"3\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:56:36', 1);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000037', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000030\",\"dictLabel\":\"会签\",\"dictSort\":0,\"dictType\":\"cooperate_type\",\"dictValue\":\"4\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:56:45', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000038', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000031\",\"dictLabel\":\"票签\",\"dictSort\":0,\"dictType\":\"cooperate_type\",\"dictValue\":\"5\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:56:55', 0);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000039', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000032\",\"dictLabel\":\"加签\",\"dictSort\":0,\"dictType\":\"cooperate_type\",\"dictValue\":\"6\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:57:05', 14);
INSERT INTO `sys_operator_log` VALUES ('SOL20241216000040', '字典数据', 1, 'com.integrity.system.controller.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/dict/data', '127.0.0.1', '', '{\"createBy\":\"admin\",\"dictCode\":\"SDD20241216000033\",\"dictLabel\":\"减签\",\"dictSort\":0,\"dictType\":\"cooperate_type\",\"dictValue\":\"7\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-12-16 15:57:17', 9);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(0) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES ('1', 'ceo', '董事长', 1, '0', 'admin', '2024-11-20 15:02:10', '', NULL, '');
INSERT INTO `sys_post` VALUES ('2', 'se', '项目经理', 2, '0', 'admin', '2024-11-20 15:02:11', '', NULL, '');
INSERT INTO `sys_post` VALUES ('3', 'hr', '人力资源', 3, '0', 'admin', '2024-11-20 15:02:11', '', NULL, '');
INSERT INTO `sys_post` VALUES ('4', 'user', '普通员工', 4, '0', 'admin', '2024-11-20 15:02:12', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(0) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '超级管理员', 'admin', 1, '4', 1, 1, '0', '0', 'admin', '2024-11-20 15:02:18', '', '2024-11-26 17:45:45', '超级管理员');
INSERT INTO `sys_role` VALUES ('2', '普通角色', 'common', 2, '4', 1, 1, '0', '0', 'admin', '2024-11-20 15:02:19', '', '2024-11-27 11:40:47', '普通角色');
INSERT INTO `sys_role` VALUES ('SR2024112617423700000002', 'XXX系统', 'system_xxx', 0, '1', 1, 1, '0', '2', 'admin', '2024-11-26 17:42:37', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '角色ID',
  `dept_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '角色ID',
  `menu_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES ('2', '1');
INSERT INTO `sys_role_menu` VALUES ('2', '100');
INSERT INTO `sys_role_menu` VALUES ('2', '1000');
INSERT INTO `sys_role_menu` VALUES ('2', '1001');
INSERT INTO `sys_role_menu` VALUES ('2', '1002');
INSERT INTO `sys_role_menu` VALUES ('2', '1003');
INSERT INTO `sys_role_menu` VALUES ('2', '1004');
INSERT INTO `sys_role_menu` VALUES ('2', '1005');
INSERT INTO `sys_role_menu` VALUES ('2', '1006');
INSERT INTO `sys_role_menu` VALUES ('2', '1007');
INSERT INTO `sys_role_menu` VALUES ('2', '1008');
INSERT INTO `sys_role_menu` VALUES ('2', '1009');
INSERT INTO `sys_role_menu` VALUES ('2', '101');
INSERT INTO `sys_role_menu` VALUES ('2', '1010');
INSERT INTO `sys_role_menu` VALUES ('2', '1011');
INSERT INTO `sys_role_menu` VALUES ('2', '1012');
INSERT INTO `sys_role_menu` VALUES ('2', '1013');
INSERT INTO `sys_role_menu` VALUES ('2', '1014');
INSERT INTO `sys_role_menu` VALUES ('2', '1015');
INSERT INTO `sys_role_menu` VALUES ('2', '1016');
INSERT INTO `sys_role_menu` VALUES ('2', '1017');
INSERT INTO `sys_role_menu` VALUES ('2', '1018');
INSERT INTO `sys_role_menu` VALUES ('2', '1019');
INSERT INTO `sys_role_menu` VALUES ('2', '102');
INSERT INTO `sys_role_menu` VALUES ('2', '1020');
INSERT INTO `sys_role_menu` VALUES ('2', '1021');
INSERT INTO `sys_role_menu` VALUES ('2', '1022');
INSERT INTO `sys_role_menu` VALUES ('2', '1023');
INSERT INTO `sys_role_menu` VALUES ('2', '1024');
INSERT INTO `sys_role_menu` VALUES ('2', '1025');
INSERT INTO `sys_role_menu` VALUES ('2', '1026');
INSERT INTO `sys_role_menu` VALUES ('2', '1027');
INSERT INTO `sys_role_menu` VALUES ('2', '1028');
INSERT INTO `sys_role_menu` VALUES ('2', '1029');
INSERT INTO `sys_role_menu` VALUES ('2', '103');
INSERT INTO `sys_role_menu` VALUES ('2', '1030');
INSERT INTO `sys_role_menu` VALUES ('2', '1031');
INSERT INTO `sys_role_menu` VALUES ('2', '1032');
INSERT INTO `sys_role_menu` VALUES ('2', '1033');
INSERT INTO `sys_role_menu` VALUES ('2', '1034');
INSERT INTO `sys_role_menu` VALUES ('2', '1035');
INSERT INTO `sys_role_menu` VALUES ('2', '1036');
INSERT INTO `sys_role_menu` VALUES ('2', '1037');
INSERT INTO `sys_role_menu` VALUES ('2', '1038');
INSERT INTO `sys_role_menu` VALUES ('2', '1039');
INSERT INTO `sys_role_menu` VALUES ('2', '104');
INSERT INTO `sys_role_menu` VALUES ('2', '1040');
INSERT INTO `sys_role_menu` VALUES ('2', '1041');
INSERT INTO `sys_role_menu` VALUES ('2', '1042');
INSERT INTO `sys_role_menu` VALUES ('2', '1043');
INSERT INTO `sys_role_menu` VALUES ('2', '1044');
INSERT INTO `sys_role_menu` VALUES ('2', '1045');
INSERT INTO `sys_role_menu` VALUES ('2', '1046');
INSERT INTO `sys_role_menu` VALUES ('2', '1047');
INSERT INTO `sys_role_menu` VALUES ('2', '1048');
INSERT INTO `sys_role_menu` VALUES ('2', '1049');
INSERT INTO `sys_role_menu` VALUES ('2', '105');
INSERT INTO `sys_role_menu` VALUES ('2', '1050');
INSERT INTO `sys_role_menu` VALUES ('2', '1051');
INSERT INTO `sys_role_menu` VALUES ('2', '1052');
INSERT INTO `sys_role_menu` VALUES ('2', '1053');
INSERT INTO `sys_role_menu` VALUES ('2', '1054');
INSERT INTO `sys_role_menu` VALUES ('2', '1055');
INSERT INTO `sys_role_menu` VALUES ('2', '1056');
INSERT INTO `sys_role_menu` VALUES ('2', '1057');
INSERT INTO `sys_role_menu` VALUES ('2', '1058');
INSERT INTO `sys_role_menu` VALUES ('2', '1059');
INSERT INTO `sys_role_menu` VALUES ('2', '106');
INSERT INTO `sys_role_menu` VALUES ('2', '1060');
INSERT INTO `sys_role_menu` VALUES ('2', '107');
INSERT INTO `sys_role_menu` VALUES ('2', '108');
INSERT INTO `sys_role_menu` VALUES ('2', '109');
INSERT INTO `sys_role_menu` VALUES ('2', '110');
INSERT INTO `sys_role_menu` VALUES ('2', '111');
INSERT INTO `sys_role_menu` VALUES ('2', '112');
INSERT INTO `sys_role_menu` VALUES ('2', '113');
INSERT INTO `sys_role_menu` VALUES ('2', '114');
INSERT INTO `sys_role_menu` VALUES ('2', '116');
INSERT INTO `sys_role_menu` VALUES ('2', '2');
INSERT INTO `sys_role_menu` VALUES ('2', '3');
INSERT INTO `sys_role_menu` VALUES ('2', '4');
INSERT INTO `sys_role_menu` VALUES ('2', '500');
INSERT INTO `sys_role_menu` VALUES ('2', '501');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `dept_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('ADMIN001', '103', 'admin', '廉政监管平台', '00', 'admin@integrity-supervision.local', '13800000000', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-07-09 09:38:59', 'admin', '2024-11-20 15:02:02', '', '2026-07-09 09:38:59', '管理员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `post_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES ('ADMIN001', '1');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `role_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES ('ADMIN001', '1');

-- ----------------------------
-- Table structure for test_leave
-- ----------------------------
DROP TABLE IF EXISTS `test_leave`;
CREATE TABLE `test_leave`  (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `type` tinyint(0) NOT NULL COMMENT '请假类型',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '请假原因',
  `start_time` datetime(0) NOT NULL COMMENT '开始时间',
  `end_time` datetime(0) NOT NULL COMMENT '结束时间',
  `day` tinyint(0) NULL DEFAULT NULL COMMENT '请假天数',
  `instance_id` bigint(0) NULL DEFAULT NULL COMMENT '流程实例的id',
  `node_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '节点编码',
  `node_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流程节点名称',
  `node_type` tinyint(1) NOT NULL COMMENT '节点类型（0开始节点 1中间节点 2结束结点 3互斥网关 4并行网关）',
  `flow_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流程状态（0待提交 1审批中 2 审批通过 3自动通过 4终止 5作废 6撤销 7取回  8已完成 9已退回 10失效）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OA 请假申请表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;

