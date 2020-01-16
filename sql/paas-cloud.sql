/*
Navicat MySQL Data Transfer

Source Server         : k8s-prod
Source Server Version : 50725
Source Host           : rm-wz9jzt458dl4demldao.mysql.rds.aliyuncs.com:3306
Source Database       : k8s

Target Server Type    : MYSQL
Target Server Version : 50725
File Encoding         : 65001

Date: 2020-01-16 15:06:51
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for access
-- ----------------------------
DROP TABLE IF EXISTS `access`;
CREATE TABLE `access` (
  `access_id` int(11) NOT NULL AUTO_INCREMENT,
  `access_code` char(1) DEFAULT NULL,
  `comment` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`access_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of access
-- ----------------------------
INSERT INTO `access` VALUES ('1', 'M', 'Management access for project');
INSERT INTO `access` VALUES ('2', 'R', 'Read access for project');
INSERT INTO `access` VALUES ('3', 'W', 'Write access for project');
INSERT INTO `access` VALUES ('4', 'D', 'Delete access for project');
INSERT INTO `access` VALUES ('5', 'S', 'Search access for project');

-- ----------------------------
-- Table structure for access_log
-- ----------------------------
DROP TABLE IF EXISTS `access_log`;
CREATE TABLE `access_log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `project_id` int(11) NOT NULL,
  `repo_name` varchar(256) DEFAULT NULL,
  `repo_tag` varchar(128) DEFAULT NULL,
  `GUID` varchar(64) DEFAULT NULL,
  `operation` varchar(20) NOT NULL,
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `pid_optime` (`project_id`,`op_time`)
) ENGINE=InnoDB AUTO_INCREMENT=21480 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS `alembic_version`;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of alembic_version
-- ----------------------------
INSERT INTO `alembic_version` VALUES ('1.5.0');

-- ----------------------------
-- Table structure for clair_vuln_timestamp
-- ----------------------------
DROP TABLE IF EXISTS `clair_vuln_timestamp`;
CREATE TABLE `clair_vuln_timestamp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace` varchar(128) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `namespace` (`namespace`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of clair_vuln_timestamp
-- ----------------------------

-- ----------------------------
-- Table structure for harbor_label
-- ----------------------------
DROP TABLE IF EXISTS `harbor_label`;
CREATE TABLE `harbor_label` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` text,
  `color` varchar(16) DEFAULT NULL,
  `level` char(1) NOT NULL,
  `scope` char(1) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_label` (`name`,`scope`,`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of harbor_label
-- ----------------------------

-- ----------------------------
-- Table structure for harbor_resource_label
-- ----------------------------
DROP TABLE IF EXISTS `harbor_resource_label`;
CREATE TABLE `harbor_resource_label` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label_id` int(11) NOT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `resource_name` varchar(256) DEFAULT NULL,
  `resource_type` char(1) NOT NULL,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_label_resource` (`label_id`,`resource_id`,`resource_name`,`resource_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of harbor_resource_label
-- ----------------------------

-- ----------------------------
-- Table structure for img_scan_job
-- ----------------------------
DROP TABLE IF EXISTS `img_scan_job`;
CREATE TABLE `img_scan_job` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(64) NOT NULL,
  `repository` varchar(256) NOT NULL,
  `tag` varchar(128) NOT NULL,
  `digest` varchar(128) DEFAULT NULL,
  `job_uuid` varchar(64) DEFAULT NULL,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_digest` (`digest`),
  KEY `idx_uuid` (`job_uuid`),
  KEY `idx_repository_tag` (`repository`,`tag`)
) ENGINE=InnoDB AUTO_INCREMENT=168736 DEFAULT CHARSET=utf8;



-- ----------------------------
-- Table structure for img_scan_overview
-- ----------------------------
DROP TABLE IF EXISTS `img_scan_overview`;
CREATE TABLE `img_scan_overview` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `image_digest` varchar(128) NOT NULL,
  `scan_job_id` int(11) NOT NULL,
  `severity` int(11) NOT NULL DEFAULT '0',
  `components_overview` varchar(2048) DEFAULT NULL,
  `details_key` varchar(128) DEFAULT NULL,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `image_digest` (`image_digest`)
) ENGINE=InnoDB AUTO_INCREMENT=5800 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `project_id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`project_id`),
  UNIQUE KEY `name` (`name`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `project_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for project_member
-- ----------------------------
DROP TABLE IF EXISTS `project_member`;
CREATE TABLE `project_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `entity_type` char(1) NOT NULL,
  `role` int(11) NOT NULL,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_project_entity_type` (`project_id`,`entity_id`,`entity_type`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for project_metadata
-- ----------------------------
DROP TABLE IF EXISTS `project_metadata`;
CREATE TABLE `project_metadata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_project_id_and_name` (`project_id`,`name`),
  CONSTRAINT `project_metadata_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for properties
-- ----------------------------
DROP TABLE IF EXISTS `properties`;
CREATE TABLE `properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `k` varchar(64) NOT NULL,
  `v` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `k` (`k`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `BLOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `SCHED_NAME` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `CALENDAR_NAME` varchar(200) NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `CRON_EXPRESSION` varchar(120) NOT NULL,
  `TIME_ZONE_ID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------
INSERT INTO `qrtz_cron_triggers` VALUES ('DefaultQuartzScheduler', 'ES日志清除', '１', '0 0 9 * * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('DefaultQuartzScheduler', '清除监控告警数据', '1', '0 0 8 * * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('DefaultQuartzScheduler', '监控告警通知任务', '1', '0 0/5 * * * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('SchedulerFactory', '统计存储', '1', '0 0/30 * * * ? ', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('SchedulerFactory', '统计平台健康', '1', '0 0/10 * * * ? ', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('SchedulerFactory', '统计平台团队', '1', '0 0/30 * * * ? ', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('SchedulerFactory', '统计平台应用', '1', '0 0/1 * * * ? ', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('SchedulerFactory', '统计平台空间', '1', '0 0/30 * * * ? ', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('SchedulerFactory', '统计平台镜像', '1', '0 0/30 * * * ? ', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('SchedulerFactory', '统计空间应用', '1', '0 0/10 * * * ? ', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('SchedulerFactory', '统计空间镜像', '1', '0 0/30 * * * ? ', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('SchedulerFactory', '统计计算节点', '1', '0 0/10 * * * ? ', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` VALUES ('SchedulerFactory', '预警处理(短息/邮件)', '1', '0 0/1 * * * ? ', 'Asia/Shanghai');

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `ENTRY_ID` varchar(95) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `SCHED_TIME` bigint(13) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STATE` varchar(16) NOT NULL,
  `JOB_NAME` varchar(200) DEFAULT NULL,
  `JOB_GROUP` varchar(200) DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`),
  KEY `IDX_QRTZ_FT_TRIG_INST_NAME` (`SCHED_NAME`,`INSTANCE_NAME`),
  KEY `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY` (`SCHED_NAME`,`INSTANCE_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_FT_J_G` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_T_G` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_FT_TG` (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) NOT NULL,
  `IS_DURABLE` varchar(1) NOT NULL,
  `IS_NONCONCURRENT` varchar(1) NOT NULL,
  `IS_UPDATE_DATA` varchar(1) NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) NOT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_J_REQ_RECOVERY` (`SCHED_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_J_GRP` (`SCHED_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------
INSERT INTO `qrtz_job_details` VALUES ('DefaultQuartzScheduler', 'ES日志清除', '１', '定期清除ElasticSearch日志，只保留30天，每天9点执行', 'com.nlelpct.paas.task.jobdetail.ESlogstashJob', '0', '0', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('DefaultQuartzScheduler', '清除监控告警数据', '1', '每天8点执行', 'com.nlelpct.paas.task.jobdetail.ClearAlarmJob', '0', '0', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('DefaultQuartzScheduler', '监控告警通知任务', '1', '每5分钟执行一次', 'com.nlelpct.paas.task.jobdetail.AlarmMessageJob', '0', '0', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('SchedulerFactory', '统计存储', '1', '每30分钟执行一次', 'com.nlelpct.paas.task.jobdetail.StatsStorageJob', '0', '0', '0', '0', 0xEFBFBDEFBFBD0005737200156F72672E71756172747A2E4A6F62446174614D6170EFBFBDEFBFBDEFBFBDE8BFA9EFBFBDEFBFBD020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D6170EFBFBD08EFBFBDEFBFBDEFBFBDEFBFBD5D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013EFBFBD2EEFBFBD28760AEFBFBD0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507EFBFBDEFBFBDEFBFBD1660EFBFBD03000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('SchedulerFactory', '统计平台健康', '1', '每10分钟执行一次', 'com.nlelpct.paas.task.jobdetail.StatsHealthJob', '0', '0', '0', '0', 0xEFBFBDEFBFBD0005737200156F72672E71756172747A2E4A6F62446174614D6170EFBFBDEFBFBDEFBFBDE8BFA9EFBFBDEFBFBD020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D6170EFBFBD08EFBFBDEFBFBDEFBFBDEFBFBD5D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013EFBFBD2EEFBFBD28760AEFBFBD0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507EFBFBDEFBFBDEFBFBD1660EFBFBD03000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('SchedulerFactory', '统计平台团队', '1', '每30分钟执行一次', 'com.nlelpct.paas.task.jobdetail.StatsTeamJob', '0', '0', '0', '0', 0xEFBFBDEFBFBD0005737200156F72672E71756172747A2E4A6F62446174614D6170EFBFBDEFBFBDEFBFBDE8BFA9EFBFBDEFBFBD020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D6170EFBFBD08EFBFBDEFBFBDEFBFBDEFBFBD5D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013EFBFBD2EEFBFBD28760AEFBFBD0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507EFBFBDEFBFBDEFBFBD1660EFBFBD03000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('SchedulerFactory', '统计平台应用', '1', '每1分钟执行一次', 'com.nlelpct.paas.task.jobdetail.StatsAppJob', '0', '0', '0', '0', 0xEFBFBDEFBFBD0005737200156F72672E71756172747A2E4A6F62446174614D6170EFBFBDEFBFBDEFBFBDE8BFA9EFBFBDEFBFBD020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D6170EFBFBD08EFBFBDEFBFBDEFBFBDEFBFBD5D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013EFBFBD2EEFBFBD28760AEFBFBD0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507EFBFBDEFBFBDEFBFBD1660EFBFBD03000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('SchedulerFactory', '统计平台空间', '1', '每30分钟执行一次', 'com.nlelpct.paas.task.jobdetail.StatsNamespaceJob', '0', '0', '0', '0', 0xEFBFBDEFBFBD0005737200156F72672E71756172747A2E4A6F62446174614D6170EFBFBDEFBFBDEFBFBDE8BFA9EFBFBDEFBFBD020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D6170EFBFBD08EFBFBDEFBFBDEFBFBDEFBFBD5D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013EFBFBD2EEFBFBD28760AEFBFBD0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507EFBFBDEFBFBDEFBFBD1660EFBFBD03000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('SchedulerFactory', '统计平台镜像', '1', '每30分钟执行一次', 'com.nlelpct.paas.task.jobdetail.StatsImagesJob', '0', '0', '0', '0', 0xEFBFBDEFBFBD0005737200156F72672E71756172747A2E4A6F62446174614D6170EFBFBDEFBFBDEFBFBDE8BFA9EFBFBDEFBFBD020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D6170EFBFBD08EFBFBDEFBFBDEFBFBDEFBFBD5D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013EFBFBD2EEFBFBD28760AEFBFBD0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507EFBFBDEFBFBDEFBFBD1660EFBFBD03000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('SchedulerFactory', '统计空间应用', '1', '每10分钟执行一次', 'com.nlelpct.paas.task.jobdetail.StatsNamespaceAppJob', '0', '0', '0', '0', 0xEFBFBDEFBFBD0005737200156F72672E71756172747A2E4A6F62446174614D6170EFBFBDEFBFBDEFBFBDE8BFA9EFBFBDEFBFBD020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D6170EFBFBD08EFBFBDEFBFBDEFBFBDEFBFBD5D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013EFBFBD2EEFBFBD28760AEFBFBD0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507EFBFBDEFBFBDEFBFBD1660EFBFBD03000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('SchedulerFactory', '统计空间镜像', '1', '每30分钟执行一次', 'com.nlelpct.paas.task.jobdetail.StatsNamespaceImagesJob', '0', '0', '0', '0', 0xEFBFBDEFBFBD0005737200156F72672E71756172747A2E4A6F62446174614D6170EFBFBDEFBFBDEFBFBDE8BFA9EFBFBDEFBFBD020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D6170EFBFBD08EFBFBDEFBFBDEFBFBDEFBFBD5D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013EFBFBD2EEFBFBD28760AEFBFBD0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507EFBFBDEFBFBDEFBFBD1660EFBFBD03000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('SchedulerFactory', '统计计算节点', '1', '每10分钟执行一次', 'com.nlelpct.paas.task.jobdetail.StatsNodeJob', '0', '0', '0', '0', 0xEFBFBDEFBFBD0005737200156F72672E71756172747A2E4A6F62446174614D6170EFBFBDEFBFBDEFBFBDE8BFA9EFBFBDEFBFBD020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D6170EFBFBD08EFBFBDEFBFBDEFBFBDEFBFBD5D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013EFBFBD2EEFBFBD28760AEFBFBD0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507EFBFBDEFBFBDEFBFBD1660EFBFBD03000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `qrtz_job_details` VALUES ('SchedulerFactory', '预警处理(短息/邮件)', '1', '每1分钟执行一次', 'com.nlelpct.paas.task.jobdetail.AlarmJob', '0', '0', '0', '0', 0xEFBFBDEFBFBD0005737200156F72672E71756172747A2E4A6F62446174614D6170EFBFBDEFBFBDEFBFBDE8BFA9EFBFBDEFBFBD020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D6170EFBFBD08EFBFBDEFBFBDEFBFBDEFBFBD5D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013EFBFBD2EEFBFBD28760AEFBFBD0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507EFBFBDEFBFBDEFBFBD1660EFBFBD03000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------
INSERT INTO `qrtz_locks` VALUES ('DefaultQuartzScheduler', 'STATE_ACCESS');
INSERT INTO `qrtz_locks` VALUES ('DefaultQuartzScheduler', 'TRIGGER_ACCESS');
INSERT INTO `qrtz_locks` VALUES ('SchedulerFactory', 'STATE_ACCESS');
INSERT INTO `qrtz_locks` VALUES ('SchedulerFactory', 'TRIGGER_ACCESS');

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL,
  `CHECKIN_INTERVAL` bigint(13) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------
INSERT INTO `qrtz_scheduler_state` VALUES ('DefaultQuartzScheduler', 'dep-paas-task-575dd8d984-cs5z71579156111649', '1579158446269', '2000');
INSERT INTO `qrtz_scheduler_state` VALUES ('SchedulerFactory', 'dep-paas-job-7c77d47ff6-9gfvh1565072334513', '1565227908041', '2000');

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL,
  `REPEAT_INTERVAL` bigint(12) NOT NULL,
  `TIMES_TRIGGERED` bigint(10) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `STR_PROP_1` varchar(512) DEFAULT NULL,
  `STR_PROP_2` varchar(512) DEFAULT NULL,
  `STR_PROP_3` varchar(512) DEFAULT NULL,
  `INT_PROP_1` int(11) DEFAULT NULL,
  `INT_PROP_2` int(11) DEFAULT NULL,
  `LONG_PROP_1` bigint(20) DEFAULT NULL,
  `LONG_PROP_2` bigint(20) DEFAULT NULL,
  `DEC_PROP_1` decimal(13,4) DEFAULT NULL,
  `DEC_PROP_2` decimal(13,4) DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PREV_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PRIORITY` int(11) DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) NOT NULL,
  `TRIGGER_TYPE` varchar(8) NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) DEFAULT NULL,
  `MISFIRE_INSTR` smallint(2) DEFAULT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_J` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_C` (`SCHED_NAME`,`CALENDAR_NAME`),
  KEY `IDX_QRTZ_T_G` (`SCHED_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_STATE` (`SCHED_NAME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_STATE` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_G_STATE` (`SCHED_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NEXT_FIRE_TIME` (`SCHED_NAME`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST` (`SCHED_NAME`,`TRIGGER_STATE`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `qrtz_job_details` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------
INSERT INTO `qrtz_triggers` VALUES ('DefaultQuartzScheduler', 'ES日志清除', '１', 'ES日志清除', '１', null, '1579222800000', '1579157778372', '5', 'WAITING', 'CRON', '1577412328000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('DefaultQuartzScheduler', '清除监控告警数据', '1', '清除监控告警数据', '1', null, '1579219200000', '-1', '5', 'WAITING', 'CRON', '1579156645000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('DefaultQuartzScheduler', '监控告警通知任务', '1', '监控告警通知任务', '1', null, '1579158600000', '1579158300000', '5', 'WAITING', 'CRON', '1579156550000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('SchedulerFactory', '统计存储', '1', '统计存储', '1', null, '1536224400000', '1536222600000', '5', 'WAITING', 'CRON', '1514352445000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('SchedulerFactory', '统计平台健康', '1', '统计平台健康', '1', null, '1535532600000', '1535532000000', '5', 'PAUSED', 'CRON', '1514290209000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('SchedulerFactory', '统计平台团队', '1', '统计平台团队', '1', null, '1536224400000', '1536222600000', '5', 'WAITING', 'CRON', '1514352533000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('SchedulerFactory', '统计平台应用', '1', '统计平台应用', '1', null, '1536222960000', '1536222900000', '5', 'WAITING', 'CRON', '1514351667000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('SchedulerFactory', '统计平台空间', '1', '统计平台空间', '1', null, '1536224400000', '1536222600000', '5', 'WAITING', 'CRON', '1514352245000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('SchedulerFactory', '统计平台镜像', '1', '统计平台镜像', '1', null, '1536224400000', '1536222600000', '5', 'WAITING', 'CRON', '1514352052000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('SchedulerFactory', '统计空间应用', '1', '统计空间应用', '1', null, '1536223200000', '1536222600000', '5', 'WAITING', 'CRON', '1514352130000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('SchedulerFactory', '统计空间镜像', '1', '统计空间镜像', '1', null, '1536224400000', '1536222600000', '5', 'WAITING', 'CRON', '1514352186000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('SchedulerFactory', '统计计算节点', '1', '统计计算节点', '1', null, '1536223200000', '1536222600000', '5', 'WAITING', 'CRON', '1514352316000', '0', null, '0', '');
INSERT INTO `qrtz_triggers` VALUES ('SchedulerFactory', '预警处理(短息/邮件)', '1', '预警处理(短息/邮件)', '1', null, '1535076840000', '1535076780000', '5', 'PAUSED', 'CRON', '1515408424000', '0', null, '0', '');

-- ----------------------------
-- Table structure for replication_immediate_trigger
-- ----------------------------
DROP TABLE IF EXISTS `replication_immediate_trigger`;
CREATE TABLE `replication_immediate_trigger` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_id` int(11) NOT NULL,
  `namespace` varchar(256) NOT NULL,
  `on_push` tinyint(1) NOT NULL DEFAULT '0',
  `on_deletion` tinyint(1) NOT NULL DEFAULT '0',
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of replication_immediate_trigger
-- ----------------------------

-- ----------------------------
-- Table structure for replication_job
-- ----------------------------
DROP TABLE IF EXISTS `replication_job`;
CREATE TABLE `replication_job` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(64) NOT NULL,
  `policy_id` int(11) NOT NULL,
  `repository` varchar(256) NOT NULL,
  `operation` varchar(64) NOT NULL,
  `tags` varchar(16384) DEFAULT NULL,
  `job_uuid` varchar(64) DEFAULT NULL,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `policy` (`policy_id`),
  KEY `poid_uptime` (`policy_id`,`update_time`),
  KEY `poid_status` (`policy_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of replication_job
-- ----------------------------

-- ----------------------------
-- Table structure for replication_policy
-- ----------------------------
DROP TABLE IF EXISTS `replication_policy`;
CREATE TABLE `replication_policy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `project_id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `description` text,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `cron_str` varchar(256) DEFAULT NULL,
  `filters` varchar(1024) DEFAULT NULL,
  `replicate_deletion` tinyint(1) NOT NULL DEFAULT '0',
  `start_time` timestamp NULL DEFAULT NULL,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of replication_policy
-- ----------------------------

-- ----------------------------
-- Table structure for replication_target
-- ----------------------------
DROP TABLE IF EXISTS `replication_target`;
CREATE TABLE `replication_target` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `url` varchar(64) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `target_type` tinyint(1) NOT NULL DEFAULT '0',
  `insecure` tinyint(1) NOT NULL DEFAULT '0',
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of replication_target
-- ----------------------------

-- ----------------------------
-- Table structure for repository
-- ----------------------------
DROP TABLE IF EXISTS `repository`;
CREATE TABLE `repository` (
  `repository_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `project_id` int(11) NOT NULL,
  `description` text,
  `pull_count` int(11) NOT NULL DEFAULT '0',
  `star_count` int(11) NOT NULL DEFAULT '0',
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`repository_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1030 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of repository
-- ----------------------------
INSERT INTO `repository` VALUES ('24', 'devin-pass/apiroute', '8', '', '7', '0', '2019-01-10 08:24:32', '2019-04-29 07:08:02');
INSERT INTO `repository` VALUES ('25', 'devin-pass/app', '8', '', '10', '0', '2019-01-10 08:24:32', '2019-03-21 08:36:42');
INSERT INTO `repository` VALUES ('26', 'devin-pass/job', '8', '', '5', '0', '2019-01-10 08:24:32', '2019-02-25 01:52:20');
INSERT INTO `repository` VALUES ('27', 'devin-pass/log', '8', '', '14', '0', '2019-01-10 08:24:32', '2019-02-26 06:09:57');
INSERT INTO `repository` VALUES ('28', 'devin-pass/monitor', '8', '', '9', '0', '2019-01-10 08:24:32', '2019-08-08 10:15:19');
INSERT INTO `repository` VALUES ('29', 'devin-pass/openjre-debian', '8', '', '7', '0', '2019-01-10 08:24:32', '2019-10-15 09:45:52');
INSERT INTO `repository` VALUES ('30', 'devin-pass/user', '8', '', '13', '0', '2019-01-10 08:24:32', '2019-08-15 05:21:05');
INSERT INTO `repository` VALUES ('31', 'devin-pass/view', '8', '', '11', '0', '2019-01-10 08:24:32', '2019-10-10 02:21:49');
INSERT INTO `repository` VALUES ('32', 'ns-paas/nginx', '9', '', '11', '0', '2019-01-10 14:34:44', '2019-10-30 07:36:51');
INSERT INTO `repository` VALUES ('148', 'devin-pass/heapster-influxdb-amd64', '8', '', '4', '0', '2019-02-25 03:34:58', '2019-10-30 09:24:17');
INSERT INTO `repository` VALUES ('149', 'devin-pass/heapster-amd64', '8', '', '3', '0', '2019-02-25 03:45:31', '2019-10-30 09:24:11');
INSERT INTO `repository` VALUES ('162', 'prons/arch-auth', '15', '', '20', '0', '2019-02-27 10:27:19', '2019-12-04 09:50:57');
INSERT INTO `repository` VALUES ('163', 'prons/arch-center', '15', '', '18', '0', '2019-02-27 10:27:26', '2019-12-04 09:51:06');
INSERT INTO `repository` VALUES ('164', 'prons/arch-gateway', '15', '', '18', '0', '2019-02-27 10:27:42', '2019-12-04 09:50:42');
INSERT INTO `repository` VALUES ('167', 'prons/customer-center', '15', '', '20', '0', '2019-02-27 10:28:34', '2019-12-04 09:50:36');
INSERT INTO `repository` VALUES ('168', 'prons/exam-manager', '15', '', '20', '0', '2019-02-27 10:28:35', '2019-12-04 09:50:48');
INSERT INTO `repository` VALUES ('169', 'prons/person-center-back', '15', '', '24', '0', '2019-02-27 10:29:13', '2019-12-17 19:24:16');
INSERT INTO `repository` VALUES ('171', 'prons/front-management', '15', '', '19', '0', '2019-02-27 10:30:20', '2019-12-04 09:51:13');
INSERT INTO `repository` VALUES ('172', 'prons/score-inquiry', '15', '', '19', '0', '2019-02-27 10:32:51', '2019-12-04 09:50:48');
INSERT INTO `repository` VALUES ('173', 'prons/sys-manager', '15', '', '27', '0', '2019-02-27 10:33:02', '2019-12-04 09:51:38');
INSERT INTO `repository` VALUES ('207', 'devin-pass/tomcat8', '8', '', '0', '0', '2019-04-12 03:30:32', '2019-04-12 03:30:32');
INSERT INTO `repository` VALUES ('209', 'devin-pass/tomcat7', '8', '', '6', '0', '2019-04-12 05:36:46', '2020-01-15 06:24:29');
INSERT INTO `repository` VALUES ('210', 'prons/certificate-manager', '15', '', '17', '0', '2019-04-24 07:19:00', '2019-12-04 09:51:01');
INSERT INTO `repository` VALUES ('211', 'prons/person-center-vue', '15', '', '20', '0', '2019-04-25 02:32:38', '2019-12-04 09:51:17');
INSERT INTO `repository` VALUES ('212', 'prons/common-service', '15', '', '15', '0', '2019-04-25 07:24:48', '2019-12-04 09:51:18');
INSERT INTO `repository` VALUES ('265', 'lims/lims', '31', '', '36', '0', '2019-05-13 09:49:45', '2020-01-14 09:45:13');
INSERT INTO `repository` VALUES ('269', 'devspace/common-service-pintai', '30', '', '3', '0', '2019-05-17 06:13:25', '2019-05-20 03:24:00');
INSERT INTO `repository` VALUES ('270', 'devspace/arch-auth', '30', '', '1', '0', '2019-05-17 06:16:22', '2019-05-17 06:39:28');
INSERT INTO `repository` VALUES ('271', 'devspace/arch-center', '30', '', '1', '0', '2019-05-17 06:16:52', '2019-05-17 06:38:58');
INSERT INTO `repository` VALUES ('272', 'devspace/arch-gateway', '30', '', '1', '0', '2019-05-17 06:17:16', '2019-05-17 06:40:08');
INSERT INTO `repository` VALUES ('273', 'devspace/authorise-manager', '30', '', '7', '0', '2019-05-17 06:18:21', '2019-05-23 15:32:06');
INSERT INTO `repository` VALUES ('274', 'devspace/common-service', '30', '', '7', '0', '2019-05-17 06:31:57', '2019-05-23 15:32:32');
INSERT INTO `repository` VALUES ('275', 'devspace/material-fundermental', '30', '', '8', '0', '2019-05-17 06:34:24', '2019-05-23 15:32:14');
INSERT INTO `repository` VALUES ('276', 'devspace/material-io', '30', '', '8', '0', '2019-05-17 06:34:46', '2019-05-23 15:32:22');
INSERT INTO `repository` VALUES ('277', 'devspace/frontend-material-management', '30', '', '10', '0', '2019-05-17 06:35:12', '2019-05-23 15:31:57');
INSERT INTO `repository` VALUES ('278', 'devspace/arch-center-pm', '30', '', '1', '0', '2019-05-17 06:35:21', '2019-05-17 06:38:49');
INSERT INTO `repository` VALUES ('279', 'devspace/auth-architecture', '30', '', '1', '0', '2019-05-17 06:35:41', '2019-05-17 06:40:38');
INSERT INTO `repository` VALUES ('280', 'devspace/arch-gateway-pm', '30', '', '1', '0', '2019-05-17 06:36:01', '2019-05-17 06:40:26');
INSERT INTO `repository` VALUES ('281', 'devspace/http-service', '30', '', '1', '0', '2019-05-17 06:36:22', '2019-05-17 06:40:56');
INSERT INTO `repository` VALUES ('282', 'devspace/person-manage-platform', '30', '', '5', '0', '2019-05-17 06:36:59', '2019-05-21 13:13:17');
INSERT INTO `repository` VALUES ('352', 'ggfwgl/common-service-pintai', '29', '', '3', '0', '2019-06-26 08:47:38', '2019-07-15 03:13:31');
INSERT INTO `repository` VALUES ('353', 'qyyhgl/arch-center-pm', '28', '', '4', '0', '2019-06-26 09:11:10', '2019-06-27 02:16:09');
INSERT INTO `repository` VALUES ('354', 'qyyhgl/arch-gateway-pm', '28', '', '3', '0', '2019-06-26 09:11:31', '2019-07-11 07:09:59');
INSERT INTO `repository` VALUES ('355', 'qyyhgl/auth-architecture', '28', '', '4', '0', '2019-06-26 09:11:40', '2019-07-11 06:29:00');
INSERT INTO `repository` VALUES ('356', 'qyyhgl/http-service', '28', '', '5', '0', '2019-06-26 09:11:48', '2019-07-11 06:28:51');
INSERT INTO `repository` VALUES ('357', 'qyyhgl/person-manage-platform', '28', '', '5', '0', '2019-06-26 09:11:55', '2019-07-11 06:28:43');
INSERT INTO `repository` VALUES ('421', 'devin-pass/yk-venus-vue-view', '8', '', '2', '0', '2019-07-22 02:24:51', '2019-10-09 09:42:35');
INSERT INTO `repository` VALUES ('471', 'lims/cdcq', '31', '', '52', '0', '2019-07-29 06:44:40', '2020-01-08 01:27:55');
INSERT INTO `repository` VALUES ('472', 'lims/ws-specimen', '31', '', '6', '0', '2019-07-29 09:23:18', '2019-07-30 01:04:54');
INSERT INTO `repository` VALUES ('476', 'lims/rpc', '31', '', '28', '0', '2019-07-31 07:31:18', '2019-11-29 08:23:24');
INSERT INTO `repository` VALUES ('517', 'ns-paas/yk-venus-server-apiroute', '9', '', '10', '0', '2019-08-09 09:55:17', '2019-12-31 06:58:40');
INSERT INTO `repository` VALUES ('522', 'ns-paas/yk-venus-server-app', '9', '', '18', '0', '2019-08-09 09:56:51', '2019-12-31 07:40:32');
INSERT INTO `repository` VALUES ('523', 'ns-paas/yk-venus-server-user', '9', '', '19', '0', '2019-08-09 09:57:19', '2019-12-31 06:59:19');
INSERT INTO `repository` VALUES ('524', 'ns-paas/yk-venus-server-monitor', '9', '', '22', '0', '2019-08-09 09:57:43', '2019-12-31 06:59:12');
INSERT INTO `repository` VALUES ('801', 'ggfwgl/common-html-to-pdf-server', '29', '', '22', '0', '2019-09-27 08:18:15', '2019-11-12 03:43:54');
INSERT INTO `repository` VALUES ('802', 'ggfwgl/common-mail-pay-server', '29', '', '18', '0', '2019-09-27 08:18:32', '2019-11-12 03:43:49');
INSERT INTO `repository` VALUES ('803', 'ggfwgl/common-sms-log-server', '29', '', '6', '0', '2019-09-27 08:18:52', '2019-11-12 03:44:04');
INSERT INTO `repository` VALUES ('819', 'prons/exam-task', '15', '', '15', '0', '2019-09-28 08:52:47', '2019-12-04 09:50:31');
INSERT INTO `repository` VALUES ('847', 'ns-paas/yk-venus-vue-view', '9', '', '18', '0', '2019-10-10 02:42:25', '2019-12-30 02:06:18');
INSERT INTO `repository` VALUES ('885', 'elnprod/eln-frontend-vue', '37', '', '1', '0', '2019-10-31 06:32:21', '2019-10-31 07:52:19');
INSERT INTO `repository` VALUES ('886', 'elnprod/eln-arch-auth', '37', '', '2', '0', '2019-10-31 06:32:43', '2019-10-31 08:14:33');
INSERT INTO `repository` VALUES ('887', 'elnprod/eln-arch-center', '37', '', '2', '0', '2019-10-31 06:33:04', '2019-10-31 07:50:28');
INSERT INTO `repository` VALUES ('888', 'elnprod/eln-arch-gateway', '37', '', '3', '0', '2019-10-31 06:33:28', '2019-12-05 02:07:41');
INSERT INTO `repository` VALUES ('889', 'elnprod/eln-authorise-manager', '37', '', '3', '0', '2019-10-31 06:33:53', '2019-10-31 08:17:02');
INSERT INTO `repository` VALUES ('890', 'elnprod/eln-common-service', '37', '', '2', '0', '2019-10-31 06:34:19', '2019-10-31 08:16:48');
INSERT INTO `repository` VALUES ('891', 'elnprod/eln-fundermental', '37', '', '4', '0', '2019-10-31 06:34:43', '2019-12-05 02:09:40');
INSERT INTO `repository` VALUES ('892', 'elnprod/eln-manage', '37', '', '8', '0', '2019-10-31 06:35:08', '2019-10-31 09:12:34');
INSERT INTO `repository` VALUES ('893', 'elnprod/eln-mycheck', '37', '', '8', '0', '2019-10-31 06:35:33', '2019-10-31 08:16:32');
INSERT INTO `repository` VALUES ('894', 'elnprod/eln-template', '37', '', '8', '0', '2019-10-31 06:35:57', '2019-10-31 08:16:40');
INSERT INTO `repository` VALUES ('895', 'qyyhgl/pm-auth-architecture', '28', '', '11', '0', '2019-10-31 08:33:29', '2019-10-31 08:56:04');
INSERT INTO `repository` VALUES ('896', 'qyyhgl/pm-http-service', '28', '', '2', '0', '2019-10-31 08:34:01', '2019-10-31 08:44:48');
INSERT INTO `repository` VALUES ('897', 'qyyhgl/pm-person-manage-platform', '28', '', '2', '0', '2019-10-31 08:34:12', '2019-10-31 08:44:41');
INSERT INTO `repository` VALUES ('898', 'qyyhgl/pm-arch-gateway', '28', '', '2', '0', '2019-10-31 08:34:22', '2019-10-31 08:45:06');
INSERT INTO `repository` VALUES ('952', 'devin-pass/alertmanager', '8', '', '3', '0', '2019-11-15 02:18:35', '2020-01-06 05:49:28');
INSERT INTO `repository` VALUES ('953', 'devin-pass/configmap-reload', '8', '', '6', '0', '2019-11-15 02:20:56', '2020-01-06 05:49:31');
INSERT INTO `repository` VALUES ('954', 'devin-pass/kube-state-metrics', '8', '', '4', '0', '2019-11-15 02:23:38', '2020-01-06 05:50:46');
INSERT INTO `repository` VALUES ('955', 'devin-pass/addon-resizer', '8', '', '4', '0', '2019-11-15 02:27:13', '2020-01-06 05:50:47');
INSERT INTO `repository` VALUES ('956', 'devin-pass/node-exporter', '8', '', '8', '0', '2019-11-15 02:28:33', '2019-12-18 05:46:46');
INSERT INTO `repository` VALUES ('957', 'devin-pass/prometheus', '8', '', '4', '0', '2019-11-15 02:32:45', '2019-12-27 08:50:17');
INSERT INTO `repository` VALUES ('958', 'devin-pass/grafana', '8', '', '3', '0', '2019-11-15 02:34:58', '2019-11-18 03:36:16');
INSERT INTO `repository` VALUES ('959', 'devin-pass/busybox', '8', '', '5', '0', '2019-11-19 06:49:35', '2019-12-27 08:50:14');
INSERT INTO `repository` VALUES ('967', 'testns/material-frontend-management', '14', '', '53', '0', '2019-11-29 08:38:12', '2020-01-13 07:13:52');
INSERT INTO `repository` VALUES ('968', 'testns/material-arch-auth', '14', '', '51', '0', '2019-12-02 07:35:24', '2020-01-13 07:14:55');
INSERT INTO `repository` VALUES ('969', 'testns/material-arch-center', '14', '', '50', '0', '2019-12-02 07:35:41', '2020-01-13 07:13:42');
INSERT INTO `repository` VALUES ('970', 'testns/material-arch-gateway', '14', '', '50', '0', '2019-12-02 07:36:04', '2020-01-13 07:13:44');
INSERT INTO `repository` VALUES ('971', 'testns/material-authorise-manager', '14', '', '50', '0', '2019-12-02 07:36:29', '2020-01-13 07:14:17');
INSERT INTO `repository` VALUES ('972', 'testns/material-common-service', '14', '', '50', '0', '2019-12-02 07:36:53', '2020-01-13 07:15:17');
INSERT INTO `repository` VALUES ('973', 'testns/material-material-fundermental', '14', '', '50', '0', '2019-12-02 07:37:19', '2020-01-13 07:14:35');
INSERT INTO `repository` VALUES ('974', 'testns/material-io', '14', '', '50', '0', '2019-12-02 07:37:42', '2020-01-13 07:13:57');
INSERT INTO `repository` VALUES ('975', 'testns/eln-frontend-vue', '14', '', '12', '0', '2019-12-03 06:29:02', '2020-01-15 06:07:03');
INSERT INTO `repository` VALUES ('976', 'testns/eln-arch-auth', '14', '', '1', '0', '2019-12-03 06:29:25', '2019-12-03 06:32:49');
INSERT INTO `repository` VALUES ('977', 'testns/eln-arch-center', '14', '', '5', '0', '2019-12-03 06:29:45', '2020-01-15 06:06:13');
INSERT INTO `repository` VALUES ('978', 'testns/eln-arch-gateway', '14', '', '14', '0', '2019-12-03 06:30:10', '2020-01-15 06:06:17');
INSERT INTO `repository` VALUES ('979', 'testns/eln-authorise-manager', '14', '', '3', '0', '2019-12-03 06:30:35', '2019-12-23 04:04:36');
INSERT INTO `repository` VALUES ('980', 'testns/eln-common-service', '14', '', '22', '0', '2019-12-03 06:31:01', '2020-01-15 06:06:23');
INSERT INTO `repository` VALUES ('981', 'testns/eln-fundermental', '14', '', '1', '0', '2019-12-03 06:31:25', '2019-12-03 06:33:24');
INSERT INTO `repository` VALUES ('982', 'testns/eln-manage', '14', '', '71', '0', '2019-12-03 06:31:50', '2020-01-15 06:07:01');
INSERT INTO `repository` VALUES ('983', 'testns/eln-mycheck', '14', '', '13', '0', '2019-12-03 06:32:14', '2020-01-15 06:06:39');
INSERT INTO `repository` VALUES ('984', 'testns/eln-template', '14', '', '26', '0', '2019-12-03 06:32:35', '2020-01-15 06:35:13');
INSERT INTO `repository` VALUES ('985', 'testns/arch-auth', '14', '', '3', '0', '2019-12-04 01:12:35', '2019-12-06 06:24:10');
INSERT INTO `repository` VALUES ('986', 'testns/arch-center', '14', '', '3', '0', '2019-12-04 01:12:51', '2019-12-06 06:24:11');
INSERT INTO `repository` VALUES ('987', 'testns/arch-gateway', '14', '', '3', '0', '2019-12-04 01:13:09', '2019-12-06 06:24:50');
INSERT INTO `repository` VALUES ('988', 'testns/certificate-manager', '14', '', '3', '0', '2019-12-04 01:13:44', '2019-12-06 06:24:26');
INSERT INTO `repository` VALUES ('989', 'testns/common-service', '14', '', '3', '0', '2019-12-04 01:14:07', '2019-12-06 06:25:00');
INSERT INTO `repository` VALUES ('990', 'testns/customer-center', '14', '', '3', '0', '2019-12-04 01:14:30', '2019-12-06 06:25:18');
INSERT INTO `repository` VALUES ('991', 'testns/front-management', '14', '', '3', '0', '2019-12-04 01:16:40', '2019-12-06 06:24:21');
INSERT INTO `repository` VALUES ('992', 'testns/exam-manager', '14', '', '3', '0', '2019-12-04 01:17:01', '2019-12-06 06:25:37');
INSERT INTO `repository` VALUES ('993', 'testns/person-center-back', '14', '', '3', '0', '2019-12-04 01:17:22', '2019-12-06 06:25:57');
INSERT INTO `repository` VALUES ('994', 'testns/person-center-vue', '14', '', '4', '0', '2019-12-04 01:18:46', '2019-12-06 06:26:20');
INSERT INTO `repository` VALUES ('995', 'testns/score-inquiry', '14', '', '3', '0', '2019-12-04 01:19:05', '2019-12-06 06:24:25');
INSERT INTO `repository` VALUES ('996', 'testns/sys-manager', '14', '', '3', '0', '2019-12-04 01:19:25', '2019-12-06 06:26:27');
INSERT INTO `repository` VALUES ('997', 'testns/exam-task', '14', '', '3', '0', '2019-12-04 01:19:43', '2019-12-06 06:24:38');
INSERT INTO `repository` VALUES ('998', 'devin-pass/elasticsearch', '8', '', '6', '0', '2019-12-16 02:57:58', '2019-12-16 03:22:27');
INSERT INTO `repository` VALUES ('999', 'devin-pass/kibana', '8', '', '2', '0', '2019-12-16 02:59:07', '2019-12-17 05:01:07');
INSERT INTO `repository` VALUES ('1000', 'devin-pass/fluentd', '8', '', '8', '0', '2019-12-16 02:59:49', '2019-12-18 05:46:56');
INSERT INTO `repository` VALUES ('1001', 'devin-pass/elasticsearch-cert', '8', '', '8', '0', '2019-12-17 03:27:31', '2019-12-18 06:12:44');
INSERT INTO `repository` VALUES ('1009', 'ns-paas/paas-gateway-server', '9', '', '2', '0', '2020-01-10 07:41:04', '2020-01-16 06:26:32');
INSERT INTO `repository` VALUES ('1010', 'ns-paas/paas-user-server', '9', '', '2', '0', '2020-01-10 07:42:02', '2020-01-16 06:26:51');
INSERT INTO `repository` VALUES ('1011', 'ns-paas/paas-log-server', '9', '', '2', '0', '2020-01-10 07:42:32', '2020-01-16 06:26:35');
INSERT INTO `repository` VALUES ('1012', 'ns-paas/paas-monitor-server', '9', '', '2', '0', '2020-01-10 07:43:05', '2020-01-16 06:26:41');
INSERT INTO `repository` VALUES ('1013', 'ns-paas/paas-task-server', '9', '', '2', '0', '2020-01-10 07:43:57', '2020-01-16 06:26:30');
INSERT INTO `repository` VALUES ('1014', 'ns-paas/paas-app-server', '9', '', '2', '0', '2020-01-10 07:45:39', '2020-01-16 06:26:26');
INSERT INTO `repository` VALUES ('1016', 'ns-paas/paas-cloud-view', '9', '', '2', '0', '2020-01-10 07:54:45', '2020-01-16 06:26:45');
INSERT INTO `repository` VALUES ('1018', 'testns/ucm-manage', '14', '', '8', '0', '2020-01-13 05:39:18', '2020-01-14 09:31:35');
INSERT INTO `repository` VALUES ('1019', 'wlglxt/material-authorise-manager', '27', '', '2', '0', '2020-01-14 05:41:26', '2020-01-14 06:13:58');
INSERT INTO `repository` VALUES ('1020', 'wlglxt/material-frontend-management', '27', '', '2', '0', '2020-01-14 05:42:20', '2020-01-14 06:13:53');
INSERT INTO `repository` VALUES ('1021', 'wlglxt/material-common-service', '27', '', '2', '0', '2020-01-14 05:42:33', '2020-01-14 06:13:45');
INSERT INTO `repository` VALUES ('1022', 'wlglxt/material-material-fundermental', '27', '', '0', '0', '2020-01-14 05:42:50', '2020-01-14 05:42:50');
INSERT INTO `repository` VALUES ('1023', 'wlglxt/material-io', '27', '', '3', '0', '2020-01-14 05:42:59', '2020-01-14 22:34:17');
INSERT INTO `repository` VALUES ('1024', 'wlglxt/material-fundermental', '27', '', '2', '0', '2020-01-14 05:54:49', '2020-01-14 06:14:27');
INSERT INTO `repository` VALUES ('1025', 'testns/material-fundermental', '14', '', '0', '0', '2020-01-14 05:54:56', '2020-01-14 05:54:56');
INSERT INTO `repository` VALUES ('1026', 'wlglxt/material-arch-auth', '27', '', '2', '0', '2020-01-14 05:58:03', '2020-01-14 06:13:52');
INSERT INTO `repository` VALUES ('1027', 'wlglxt/material-arch-center', '27', '', '2', '0', '2020-01-14 05:58:11', '2020-01-14 06:14:22');
INSERT INTO `repository` VALUES ('1028', 'wlglxt/material-arch-gateway', '27', '', '2', '0', '2020-01-14 05:58:23', '2020-01-14 06:14:43');
INSERT INTO `repository` VALUES ('1029', 'lims/data-tool', '31', '', '16', '0', '2020-01-15 06:41:45', '2020-01-15 08:18:59');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_mask` int(11) NOT NULL DEFAULT '0',
  `role_code` varchar(20) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '0', 'MDRWS', 'projectAdmin');
INSERT INTO `role` VALUES ('2', '0', 'RWS', 'developer');
INSERT INTO `role` VALUES ('3', '0', 'RS', 'guest');

-- ----------------------------
-- Table structure for t_app_domain_name
-- ----------------------------
DROP TABLE IF EXISTS `t_app_domain_name`;
CREATE TABLE `t_app_domain_name` (
  `id` varchar(32) NOT NULL COMMENT '主键ID',
  `port` int(6) NOT NULL COMMENT '域名对应的端口',
  `name` varchar(120) NOT NULL COMMENT '域名',
  `ingress_name` varchar(150) NOT NULL,
  `app_name_kube` varchar(120) NOT NULL COMMENT '域名所属的应用',
  `service_name` varchar(120) NOT NULL COMMENT '服务名称',
  `namespace` varchar(120) NOT NULL COMMENT '空间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_update_time` datetime NOT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_app_domain_name
-- ----------------------------

-- ----------------------------
-- Table structure for t_app_health
-- ----------------------------
DROP TABLE IF EXISTS `t_app_health`;
CREATE TABLE `t_app_health` (
  `id` varchar(32) NOT NULL,
  `app_name` varchar(100) NOT NULL,
  `app_host` varchar(50) NOT NULL,
  `app_port` varchar(10) NOT NULL,
  `health_url` varchar(100) DEFAULT NULL,
  `namespace` varchar(200) NOT NULL,
  `app_status` int(1) NOT NULL DEFAULT '1',
  `last_updated_time` bigint(20) DEFAULT NULL,
  `create_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `namespace_host_port_uk` (`app_host`,`app_port`,`namespace`) USING BTREE,
  KEY `namespace_idx` (`namespace`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of t_app_health
-- ----------------------------
INSERT INTO `t_app_health` VALUES ('01699a5a2a59445d8cce5bfabf7ed30f', 'ELN基础资料服务', 'service-eln-fundermental-pro.elnprod', '8080', '/actuator/health', 'elnprod', '1', '1579158447754', '1575442789447');
INSERT INTO `t_app_health` VALUES ('19b19cfb93b14169acd051fe997db79b', 'ELN鉴权服务', 'service-eln-arch-auth-pro.elnprod', '8080', '/actuator/health', 'elnprod', '1', '1579158447747', '1575442498047');
INSERT INTO `t_app_health` VALUES ('2348be044bf9410aa457245c645784c3', '平台后台监控服务', 'svc-paas-monitor.ns-paas', '8080', '/actuator/health', 'ns-paas', '1', '1579158447787', '1563937687402');
INSERT INTO `t_app_health` VALUES ('311fea3f3bad4aeda70a84a1484e26a4', 'ELN注册中心', 'service-eln-arch-center-pro.elnprod', '8080', '/actuator/health', 'elnprod', '1', '1579158447752', '1575442537695');
INSERT INTO `t_app_health` VALUES ('4256b70afdc04a5fab20ad4cf6bd3773', '平台用户服务', 'svc-paas-user.ns-paas', '8080', '/actuator/health', 'ns-paas', '1', '1579158447751', '1563937728458');
INSERT INTO `t_app_health` VALUES ('47627ca98e404e029f5d1c3485f8bf5c', '平台任务服务', 'svc-paas-task.ns-paas', '8080', '/actuator/health', 'ns-paas', '1', '1579158447980', '1563937874073');
INSERT INTO `t_app_health` VALUES ('4a18eece0c874fc8b01e018ee5d14eb1', 'ELN核心管理服务', 'service-eln-manage-pro.elnprod', '8080', '/actuator/health', 'elnprod', '1', '1579158447776', '1575442831010');
INSERT INTO `t_app_health` VALUES ('4d74114c68e14b049fa28c951ae71814', '平台前端', 'svc-paas-cloud-view.ns-paas', '80', '/#/login', 'ns-paas', '1', '1579158447780', '1563938178627');
INSERT INTO `t_app_health` VALUES ('5aa2307d42004c5384deafbd639d7597', 'ELN模板服务', 'service-eln-template-pro.elnprod', '8080', '/actuator/health', 'elnprod', '1', '1579158447788', '1575442908714');
INSERT INTO `t_app_health` VALUES ('6074d1ad34754932af7a359587d068ff', 'ELN菜单权限', 'service-eln-authorise-manager-pro.elnprod', '8080', '/actuator/health', 'elnprod', '1', '1579158447789', '1575442686804');
INSERT INTO `t_app_health` VALUES ('6475a44f0a9d470e84c4a118bbaf7cf9', 'ELN网关', 'service-eln-arch-gateway-pro.elnprod', '8080', '/actuator/health', 'elnprod', '1', '1579158447782', '1575442574150');
INSERT INTO `t_app_health` VALUES ('a6d1d434dbcf4f8983bd4dc0a3854b68', 'ELN前端服务', 'service-eln-frontend-vue-pro.elnprod', '8080', '/#/login', 'elnprod', '1', '1579158447790', '1575442753072');
INSERT INTO `t_app_health` VALUES ('b296ec1bc7a14e17a30fd5fb84a79120', '细胞检测证书验证系统', 'service-cdcq.lims', '8080', '/actuator/health', 'lims', '1', '1579158447808', '1564707184447');
INSERT INTO `t_app_health` VALUES ('b4adf3c0b8484dceb87a8d149c07cce2', '平台后台应用服务', 'svc-paas-app.ns-paas', '8080', '/actuator/health', 'ns-paas', '1', '1579158447784', '1563937799047');
INSERT INTO `t_app_health` VALUES ('be59db3a3c2f4b5b98825a34b29f1c29', 'ELN待复核服务', 'service-eln-mycheck-pro.elnprod', '8080', '/actuator/health', 'elnprod', '1', '1579158447791', '1575442876810');
INSERT INTO `t_app_health` VALUES ('d556c1270bbc479c90cd4cf68293b631', '平台后台接口服务', 'svc-paas-gateway.ns-paas', '8080', '/actuator/health', 'ns-paas', '1', '1579158447808', '1563937999575');
INSERT INTO `t_app_health` VALUES ('da06c8bc9afa4c2e8e4dcc980cd145e3', '送检样本检验报告查询系统', 'service-reports-coustomer.lims', '8080', '/index.html', 'lims', '1', '1579158447787', '1564707089605');
INSERT INTO `t_app_health` VALUES ('dd2737bc20ce429fae2b44459cd9b94a', 'lims', 'service-kenuolims.lims', '8080', '/NCL/login.action', 'lims', '1', '1579158447807', '1564708385297');
INSERT INTO `t_app_health` VALUES ('edb15e3d58054dc1b4ec9d2fd57fa8c6', '平台后台日志服务', 'svc-paas-log.ns-paas', '8080', '/actuator/health', 'ns-paas', '1', '1579158447788', '1563938108643');

-- ----------------------------
-- Table structure for t_app_health_his
-- ----------------------------
DROP TABLE IF EXISTS `t_app_health_his`;
CREATE TABLE `t_app_health_his` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `app_id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `down_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_app_manage
-- ----------------------------
DROP TABLE IF EXISTS `t_app_manage`;
CREATE TABLE `t_app_manage` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `app_name` varchar(32) NOT NULL COMMENT '应用名称',
  `app_name_kube` varchar(128) NOT NULL COMMENT '应用名(k8s集群)',
  `app_kind` varchar(64) NOT NULL COMMENT '应用资源类型',
  `image_name` varchar(128) NOT NULL COMMENT '镜像名',
  `image_version` varchar(64) NOT NULL COMMENT '镜像版本',
  `described` varchar(200) NOT NULL COMMENT '应用描述',
  `namespace` varchar(32) NOT NULL COMMENT '应用所属空间名',
  `deploy_type` int(1) NOT NULL DEFAULT '0' COMMENT '应用部署方式',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_update_time` datetime NOT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_app_manage
-- ----------------------------
INSERT INTO `t_app_manage` VALUES ('006f7f575fee4e6f845d27f010471c99', 'lims', 'lims', 'Deployment', 'jcdev/lims', 'v1.0.4', 'lims', 'jcdev', '1', '2019-04-12 13:55:51', '2019-05-06 14:22:46');
INSERT INTO `t_app_manage` VALUES ('011edbfad30c409893eb504a6a7b5b72', '专业职称---注册中心', 'arch-center-t', 'Deployment', 'testns/arch-center', 'v12061413', 'eureka注册中心', 'testns', '1', '2019-02-25 14:42:06', '2019-12-06 00:24:00');
INSERT INTO `t_app_manage` VALUES ('05a52e27ae8c42f4af54658594d08b33', '平台公共服务---HTML转PDF', 'common-html-to-pdf-server', 'Deployment', 'testns/common-html-to-pdf-server', 'v11211203', '平台公共服务---HTML转PDF', 'testns', '1', '2019-02-25 14:38:25', '2019-11-20 22:05:19');
INSERT INTO `t_app_manage` VALUES ('075b0f704841447b99f48eea8b90e568', '物料管理---注册中心', 'arch-center-wl', 'Deployment', 'devspace/arch-center', 'v1.0.8', '物料---测试注册中心', 'devspace', '1', '2019-05-07 13:40:40', '2019-05-24 10:45:32');
INSERT INTO `t_app_manage` VALUES ('09f69f90333d46a1b37429cc10425785', '物料管理---出库入库-测试', 'material-io-test', 'Deployment', 'testns/material-io', 'v01131507', '物料管理---出库入库-测试', 'testns', '1', '2019-06-14 16:16:09', '2020-01-13 01:13:36');
INSERT INTO `t_app_manage` VALUES ('0a84de46969546ecb78a08d8899c1c27', 'eureka服务注册中心', 'arch-center', 'Deployment', 'gddev/arch-center', 'v1.0.17', '服务注册中心', 'gddev', '1', '2019-01-24 09:49:48', '2019-01-30 11:54:03');
INSERT INTO `t_app_manage` VALUES ('0edf8a665afe40a3a42a3dd988188d8a', '用户及企业管理---网关', 'arch-gateway-pcm', 'Deployment', 'devspace/arch-gateway-pm', 'v1.0.12', '用户及企业管理---网关', 'devspace', '1', '2019-05-07 12:00:33', '2019-05-24 10:46:09');
INSERT INTO `t_app_manage` VALUES ('147e358995ad441bb98ecb174079eefe', '物料管理---出库入库', 'material-io', 'Deployment', 'devspace/material-io', 'v1.0.13', '物料管理---出库入库 测试', 'devspace', '1', '2019-05-07 14:01:27', '2019-05-24 10:45:07');
INSERT INTO `t_app_manage` VALUES ('1cffed30a7a54287b226cfd9ec3cf8c3', '专业职称--任务', 'exam-task-test', 'Deployment', 'testns/exam-task', 'v12061413', '专业职称--任务', 'testns', '1', '2019-02-25 14:38:28', '2019-12-06 00:24:16');
INSERT INTO `t_app_manage` VALUES ('1f293127edcb4d4ba1c570f3b7c1e9e7', '用户及企业管理---用户企业管理', 'person-manage-platform', 'Deployment', 'devspace/person-manage-platform', 'v1.0.10', '用户及企业管理---测试', 'devspace', '1', '2019-05-07 12:11:17', '2019-05-24 10:45:43');
INSERT INTO `t_app_manage` VALUES ('1fa2262613bb4ba3991a68ea0f15d889', '专业职称---个人中心后台', 'person-center-back-t', 'Deployment', 'testns/person-center-back', 'v12061413', '个人中心后台服务', 'testns', '1', '2019-02-25 14:54:44', '2019-12-06 00:24:10');
INSERT INTO `t_app_manage` VALUES ('23f745d393a84e64a0929caeff38c725', '物料管理---VUE页面-测试', 'frontend-material-management-test', 'Deployment', 'testns/material-frontend-management', 'v01131507', '物料管理---VUE页面-测试', 'testns', '1', '2019-05-17 17:00:50', '2020-01-13 01:13:40');
INSERT INTO `t_app_manage` VALUES ('241004e199bd4909a56250cd37b95b0a', '用户企业---管理平台', 'person-manage-platform-pro', 'Deployment', 'qyyhgl/pm-person-manage-platform', 'v10310000', '用户及企业管理', 'qyyhgl', '1', '2019-06-26 17:53:42', '2019-10-31 03:37:29');
INSERT INTO `t_app_manage` VALUES ('25ec51cca0ee418faa13e3ffa2039827', '专业职称--任务-生产', 'exam-task-pro', 'Deployment', 'prons/exam-task', 'v12041740', '专业职称--任务-生产', 'prons', '1', '2019-09-28 04:11:08', '2019-12-04 03:50:20');
INSERT INTO `t_app_manage` VALUES ('27855218e89a4244a86f07e6a11aa613', 'ELN---基础资料', 'eln-fundermental-test', 'Deployment', 'testns/eln-fundermental', 'v01151359', 'ELN---基础资料', 'testns', '1', '2019-08-01 18:01:10', '2020-01-15 00:06:08');
INSERT INTO `t_app_manage` VALUES ('27855218e89a4244a86f07e6a1assdd', 'ELN---基础资料', 'eln-fundermental-pro', 'Deployment', 'elnprod/eln-fundermental', 'v10311418', 'ELN---基础资料', 'elnprod', '1', '2019-09-01 18:01:10', '2019-10-31 03:09:23');
INSERT INTO `t_app_manage` VALUES ('289d1a08cc12495ab3ff7d76cc6e2f3c', '专业职称--客服中心服务-生产', 'customer-center-p', 'Deployment', 'prons/customer-center', 'v12041740', '客服中心服务', 'prons', '1', '2019-03-05 17:44:50', '2019-12-04 03:50:24');
INSERT INTO `t_app_manage` VALUES ('2a02261517fa4aca8f46ffc914aba7a6', '物料管理---菜单权限模块-测试', 'authorise-manager-test', 'Deployment', 'testns/material-authorise-manager', 'v01131507', '物料管理---菜单权限模块-测试', 'testns', '1', '2019-05-17 16:45:28', '2020-01-13 01:13:43');
INSERT INTO `t_app_manage` VALUES ('31d3ca1731294bfba4b1ea7e55785981', '报告录入接口服务', 'ws-specimen', 'Deployment', 'lims/ws-specimen', '7046', '报告录入接口服务', 'lims', '1', '2019-07-29 17:25:58', '2019-07-30 09:15:35');
INSERT INTO `t_app_manage` VALUES ('34348fd12dc4447586943542a453083c', '用户及企业管理---注册中心-测试', 'arch-center-pm-test', 'Deployment', 'testns/pm-arch-center', 'v10221639', '用户及企业管理---注册中心-测试', 'testns', '1', '2019-05-17 15:12:57', '2019-10-22 03:52:18');
INSERT INTO `t_app_manage` VALUES ('364341c522b34c9dbb7dcddfb063b2ba', '物料管理---基础资料-测试', 'material-fundermental-test', 'Deployment', 'testns/material-fundermental', 'v01131507', '物料管理---基础资料-测试', 'testns', '1', '2019-05-17 16:49:04', '2020-01-13 01:13:47');
INSERT INTO `t_app_manage` VALUES ('3722351e87e44ac59ccfbe488c1f0044', '平台公共服务---日志短信服务', 'system-common', 'Deployment', 'devspace/common-service-pintai', 'v1.0.19', '平台公共服务---系统公共', 'devspace', '1', '2019-05-07 14:53:31', '2019-05-24 10:44:47');
INSERT INTO `t_app_manage` VALUES ('37d094a9a9b244e19d8e357fd99f480f', '专业职称--服务网关-生产', 'arch-gateway-p', 'Deployment', 'prons/arch-gateway', 'v12041740', '服务网关', 'prons', '1', '2019-03-05 17:58:29', '2019-12-04 03:50:26');
INSERT INTO `t_app_manage` VALUES ('39ab865651814186929a26636d14a788', '专业职称--考试管理服务-生产', 'exam-manager-p', 'Deployment', 'prons/exam-manager', 'v12041740', '考试管理服务', 'prons', '1', '2019-03-05 17:46:51', '2019-12-04 03:50:29');
INSERT INTO `t_app_manage` VALUES ('406a5a55e70b4b2c9bf38ca2028141dc', '专业职称--认证服务-生产', 'arch-auth-p', 'Deployment', 'prons/arch-auth', 'v12041740', '认证服务', 'prons', '1', '2019-03-05 17:54:37', '2019-12-04 03:50:31');
INSERT INTO `t_app_manage` VALUES ('4365712e8b8b41d8b6688b8534ed47ad', '专业职称--eureka注册中心-生产', 'arch-center-p', 'Deployment', 'prons/arch-center', 'v12041740', 'eureka注册中心', 'prons', '1', '2019-03-05 17:56:31', '2019-12-04 03:50:33');
INSERT INTO `t_app_manage` VALUES ('44d7b3b8a49e42cb956b4d8a4e4edf41', '专业职称---考试管理', 'exam-manager-t', 'Deployment', 'testns/exam-manager', 'v12061413', '考试管理', 'testns', '1', '2019-02-25 15:10:25', '2019-12-06 00:24:09');
INSERT INTO `t_app_manage` VALUES ('4802db69f8a8456b97dda26019674885', '用户企业---用户登录授权', 'auth-architecture-pro', 'Deployment', 'qyyhgl/pm-auth-architecture', 'v10310000', 'JWT登录授权', 'qyyhgl', '1', '2019-06-26 17:48:19', '2019-10-31 03:37:41');
INSERT INTO `t_app_manage` VALUES ('4bec8de5600244819019730f5871cfca', '专业职称---公共服务', 'common-service-t', 'Deployment', 'testns/common-service', 'v12061413', '公共服务', 'testns', '1', '2019-03-13 15:33:56', '2019-12-06 00:24:05');
INSERT INTO `t_app_manage` VALUES ('4eae81ba894a4aef838ab23698037b8e', 'ELN---公共服务', 'eln-common-service-test', 'Deployment', 'testns/eln-common-service', 'v01151359', 'ELN---公共服务', 'testns', '1', '2019-08-01 18:04:40', '2020-01-15 00:06:10');
INSERT INTO `t_app_manage` VALUES ('4eae81ba894a4aef838ab2369803ttt', 'ELN---公共服务', 'eln-common-service-pro', 'Deployment', 'elnprod/eln-common-service', 'v10311418', 'ELN---公共服务', 'elnprod', '1', '2019-09-01 18:04:40', '2019-10-31 03:09:09');
INSERT INTO `t_app_manage` VALUES ('4ec4e56264c640f7b008c0b2123ed8f8', '用户及企业管理---网关-测试', 'arch-gateway-pm-test', 'Deployment', 'testns/pm-arch-gateway', 'v10221639', '用户及企业管理---网关-测试', 'testns', '1', '2019-05-17 15:39:47', '2019-10-22 03:52:20');
INSERT INTO `t_app_manage` VALUES ('503b7cf3dd01467b8c916e61c8121444', '专业职称--系统管理前端-生产', 'front-management-p', 'Deployment', 'prons/front-management', 'v12041740', '系统管理前端', 'prons', '1', '2019-03-06 12:58:37', '2019-12-04 03:50:35');
INSERT INTO `t_app_manage` VALUES ('5102b394d58448eab12b013ebb364b26', '专业职称---客服中心', 'customer-center-t', 'Deployment', 'testns/customer-center', 'v12061413', '客服中心', 'testns', '1', '2019-02-25 14:50:36', '2019-12-06 00:24:06');
INSERT INTO `t_app_manage` VALUES ('52f233c8c880448f8a522fe869e57586', '专业职称--成绩管理服务-生产', 'score-inquiry-p', 'Deployment', 'prons/score-inquiry', 'v12041740', '成绩管理服务', 'prons', '1', '2019-03-05 17:52:28', '2019-12-04 03:50:37');
INSERT INTO `t_app_manage` VALUES ('53a2a7c4a0c342fcaa2facf926b23d4c', '物料管理---基础资料', 'material-fundermental', 'Deployment', 'devspace/material-fundermental', 'v1.0.15', '物料管理---基础资料 测试', 'devspace', '1', '2019-05-07 13:58:29', '2019-05-24 10:45:13');
INSERT INTO `t_app_manage` VALUES ('5459466683444cdd95e1ecfdc88480a2', 'ELN---模板', 'eln-template-test', 'Deployment', 'testns/eln-template', 'v2001151433', 'ELN---模板', 'testns', '1', '2019-08-12 01:43:34', '2020-01-15 00:35:01');
INSERT INTO `t_app_manage` VALUES ('5459466683444cdd95e1ecfdc88480w3', 'ELN---模板', 'eln-template-pro', 'Deployment', 'elnprod/eln-template', 'v10311418', 'ELN---模板', 'elnprod', '1', '2019-09-12 01:43:34', '2019-10-31 02:50:03');
INSERT INTO `t_app_manage` VALUES ('57c87bbd2808461ab8a612bfcf1db3c9', '专业职称--个人中心后台服务-生产', 'person-center-back-p', 'Deployment', 'prons/person-center-back', 'v12041740', '个人中心后台服务', 'prons', '1', '2019-03-05 17:50:27', '2019-12-04 03:50:40');
INSERT INTO `t_app_manage` VALUES ('57eb1dc907af4662b3f5c9afee69a4dc', '用户企业---HTTP接口', 'http-service-pro', 'Deployment', 'qyyhgl/pm-http-service', 'v10310000', 'HTTP调用服务', 'qyyhgl', '1', '2019-06-26 17:51:02', '2019-10-31 03:37:36');
INSERT INTO `t_app_manage` VALUES ('58afa64539504df4aa4e9637547c6f17', '黄磊测试', 'swalikh', 'StatefulSet', 'jcdev/common-service', 'v1.0.1', '啊啊啊啊啊啊啊啊啊啊AA', 'jcdev', '1', '2019-04-30 16:57:38', '2019-04-30 16:57:38');
INSERT INTO `t_app_manage` VALUES ('5c99829d28294e2b90cd9415be255e9c', '物料---物料公共', 'common-service-pro', 'Deployment', 'wlglxt/material-common-service', 'v01141407', '物料---物料公共', 'wlglxt', '1', '2019-06-26 18:36:15', '2020-01-14 00:13:34');
INSERT INTO `t_app_manage` VALUES ('5cd8502c6ac349ca941a38d16a5ec5d9', '用户企业---注册中心', 'arch-center-pm-pro', 'Deployment', 'qyyhgl/pm-arch-center', 'v1.0.2', '用户及企业管理注册中心', 'qyyhgl', '1', '2019-06-26 17:27:46', '2019-06-27 10:15:58');
INSERT INTO `t_app_manage` VALUES ('65b9cd3e8648413abf736c16da4f2953', '专业职称---个人中心前端', 'person-center-vue-t', 'Deployment', 'testns/person-center-vue', 'v12061413', '个人中心前端页面', 'testns', '1', '2019-02-25 15:02:37', '2019-12-06 00:24:12');
INSERT INTO `t_app_manage` VALUES ('6a236228136541fb95033c9efb1dcb2c', '专业职称--公共服务-生产', 'common-service-p', 'Deployment', 'prons/common-service', 'v12041740', '公共服务', 'prons', '1', '2019-03-06 12:42:02', '2019-12-04 03:50:42');
INSERT INTO `t_app_manage` VALUES ('702e981deefe4725a836a0d6c76828cf', '物料---鉴权', 'arch-auth-pro', 'Deployment', 'wlglxt/material-arch-auth', 'v01141407', '物料---鉴权', 'wlglxt', '1', '2019-06-26 18:24:58', '2020-01-14 00:13:36');
INSERT INTO `t_app_manage` VALUES ('74931ef58fc24709b7470a5431a33c43', 'ELN---待复核', 'eln-mycheck-test', 'Deployment', 'testns/eln-mycheck', 'v01151359', 'ELN---检查', 'testns', '1', '2019-08-12 01:42:08', '2020-01-15 00:06:15');
INSERT INTO `t_app_manage` VALUES ('74931ef58fc24709b7470a5431a33hy', 'ELN---待复核', 'eln-mycheck-pro', 'Deployment', 'elnprod/eln-mycheck', 'v10311418', 'ELN---检查', 'elnprod', '1', '2019-09-12 01:42:08', '2019-10-31 02:52:01');
INSERT INTO `t_app_manage` VALUES ('7731942bfb3645009049563ea9734679', '用户及企业管理---HTTP', 'http-service-dev', 'Deployment', 'devspace/http-service', 'v1.0.4', '测试', 'devspace', '1', '2019-05-07 12:07:45', '2019-05-24 10:45:51');
INSERT INTO `t_app_manage` VALUES ('779985a4506a4ce09924fbe5d8a4a5a1', '专业职称---网关', 'arch-gateway-t', 'Deployment', 'testns/arch-gateway', 'v12061413', '服务网关', 'testns', '1', '2019-02-25 14:44:53', '2019-12-06 00:24:02');
INSERT INTO `t_app_manage` VALUES ('7a1e98f5a29a415f9f1fbbf10c303804', '用户企业---网关', 'arch-gateway-pm-pro', 'Deployment', 'qyyhgl/pm-arch-gateway', 'v10310000', '网关', 'qyyhgl', '1', '2019-06-26 17:29:36', '2019-10-31 03:37:48');
INSERT INTO `t_app_manage` VALUES ('7aa7de6dabf04f998a4870d378da2153', 'ELN---VUE页面', 'eln-frontend-vue-test', 'Deployment', 'testns/eln-frontend-vue', 'v01151359', 'ELN---VUE页面', 'testns', '1', '2019-08-01 18:10:11', '2020-01-15 00:06:11');
INSERT INTO `t_app_manage` VALUES ('7aa7de6dabf04f998a4870d378dawssd', 'ELN---VUE页面', 'eln-frontend-vue-pro', 'Deployment', 'elnprod/eln-frontend-vue', 'v10311418', 'ELN---VUE页面', 'elnprod', '1', '2019-09-01 18:10:11', '2019-10-31 02:52:07');
INSERT INTO `t_app_manage` VALUES ('7c0a5150683a48b281713dbeaffc8d29', '送检样本检验报告查询服务', 'reports-coustomer', 'Deployment', 'lims/rpc', '10021', '送检样本检验报告查询服务', 'lims', '1', '2019-07-31 17:17:26', '2019-11-29 02:23:13');
INSERT INTO `t_app_manage` VALUES ('7ce41a6b95e7493da5b33575d038ceb9', '专业职称--证书管理服务-生产', 'certificate-mamager-p', 'Deployment', 'prons/certificate-manager', 'v12041740', '证书管理服务', 'prons', '1', '2019-03-05 09:57:40', '2019-12-04 03:50:44');
INSERT INTO `t_app_manage` VALUES ('8121fe436732436a996913c6f5689a88', '平台公共服务---日志短信服务-生产', 'common-service-pintai', 'Deployment', 'ggfwgl/common-sms-log-server', 'v11121129', '日志的存储读取  阿里云短信发送', 'ggfwgl', '1', '2019-06-26 16:52:35', '2019-11-11 21:43:59');
INSERT INTO `t_app_manage` VALUES ('812ab7c9532242a0a5a702bc2561773e', '用户企业管理---注册中心', 'arch-center-pm', 'Deployment', 'jcdev/arch-center', 'v1.0.4', 'arch-center-pm', 'jcdev', '1', '2019-05-06 14:31:36', '2019-05-06 14:31:36');
INSERT INTO `t_app_manage` VALUES ('84d9be8255da455db3fdfcb674737ce6', '平台公共服务---HTML转PDF-生产', 'common-html-to-pdf-server-pro', 'Deployment', 'ggfwgl/common-html-to-pdf-server', 'v11121129', '平台公共服务---HTML转PDF-生产', 'ggfwgl', '1', '2019-09-28 02:29:44', '2019-11-11 21:43:52');
INSERT INTO `t_app_manage` VALUES ('883783ebc2d14dfda2110134640a548e', '物料管理---网关-测试', 'arch-gateway-test', 'Deployment', 'testns/material-arch-gateway', 'v01131507', '物料管理---网关-测试', 'testns', '1', '2019-05-17 16:41:58', '2020-01-13 01:13:33');
INSERT INTO `t_app_manage` VALUES ('8889d45c576841248adfb35827191c14', '物料---菜单权限管理', 'authorise-manager-pro', 'Deployment', 'wlglxt/material-authorise-manager', 'v01141407', '物料---菜单权限管理', 'wlglxt', '1', '2019-06-26 18:29:21', '2020-01-14 00:13:37');
INSERT INTO `t_app_manage` VALUES ('8a3853825e8a4d4483db4fd0f0c05e30', '专业职称--系统管理后端服务-生产', 'sys-mamager-p', 'Deployment', 'prons/sys-manager', 'v12041740', '系统管理后端服务', 'prons', '1', '2019-03-06 12:43:28', '2019-12-04 03:50:46');
INSERT INTO `t_app_manage` VALUES ('8b8b648cf748441c963a341395205247', '物料---出入库', 'material-io-pro', 'Deployment', 'wlglxt/material-io', 'v01141407', '物料---出入库', 'wlglxt', '1', '2019-10-10 04:44:02', '2020-01-14 00:13:38');
INSERT INTO `t_app_manage` VALUES ('8ed6f79c2dd4424ca6b67667a767e86d', '专业职称---证书管理', 'centificate-manager-t', 'Deployment', 'testns/certificate-manager', 'v12061413', '证书管理', 'testns', '1', '2019-02-25 14:46:41', '2019-12-06 00:24:03');
INSERT INTO `t_app_manage` VALUES ('94f30c695c2943f7b2412dd47ac70289', 'CDCQ服务', 'cdcq', 'Deployment', 'lims/cdcq', '10660', 'CDCQ服务', 'lims', '1', '2019-07-29 14:52:34', '2020-01-07 19:27:44');
INSERT INTO `t_app_manage` VALUES ('96b11d11a7284612beae051088458005', '细胞质量比对小工具', 'data-tool', 'Deployment', 'lims/data-tool', 'v01151605', '细胞质量比对小工具', 'lims', '1', '2020-01-15 00:56:54', '2020-01-15 02:06:39');
INSERT INTO `t_app_manage` VALUES ('982339d615c043009eb025f9e0985235', '物料管理---菜单权限模块', 'authorise-manager', 'Deployment', 'devspace/authorise-manager', 'v1.0.16', '物料管理---菜单权限模块 测试', 'devspace', '1', '2019-05-07 13:52:00', '2019-05-24 10:45:18');
INSERT INTO `t_app_manage` VALUES ('9e45769d086f401597fa13b712cdab86', '专业职称---门户首页', 'exam-index-t', 'Deployment', 'testns/exam-index', 'v1.0.1', '内容展示', 'testns', '1', '2019-02-25 14:38:27', '2019-11-21 21:59:05');
INSERT INTO `t_app_manage` VALUES ('a35bff2075474f7b888319e9843f6b39', '专业职称---后台管理前端', 'front-management-t', 'Deployment', 'testns/front-management', 'v12061413', '系统管理前端页面', 'testns', '1', '2019-02-25 14:56:28', '2019-12-06 00:24:07');
INSERT INTO `t_app_manage` VALUES ('a5675efd853e4b65a129a12d72d9b79f', '物料管理---VUE页面', 'frontend-material-vue', 'Deployment', 'devspace/frontend-material-management', 'v1.0.21', '物料管理---VUE页面', 'devspace', '1', '2019-05-07 13:31:58', '2019-05-24 10:45:38');
INSERT INTO `t_app_manage` VALUES ('a7d08b7e6f2a4507b5448d92926c71dd', '物料管理---鉴权模块-测试', 'arch-auth-test', 'Deployment', 'testns/material-arch-auth', 'v01131507', '物料管理---鉴权模块-测试', 'testns', '1', '2019-05-17 16:43:56', '2020-01-13 01:13:50');
INSERT INTO `t_app_manage` VALUES ('aa3fc45ed4d7437db72f1b864e8e4820', '平台公共服务---邮箱和支付服务', 'common-mailbox-and-payment-server-test', 'Deployment', 'testns/common-mail-pay-server', 'v11211203', '平台公共服务---邮箱和支付服务', 'testns', '1', '2019-02-25 14:38:26', '2019-11-20 22:05:21');
INSERT INTO `t_app_manage` VALUES ('app_001', '平台前端', 'dep-paas-cloud-view', 'Deployment', 'ns-paas/paas-cloud-view', 'v2.0.2', '容器云平台前端', 'ns-paas', '1', '2018-08-28 15:44:59', '2020-01-16 00:31:34');
INSERT INTO `t_app_manage` VALUES ('app_002', '平台后台接口', 'dep-paas-gateway', 'Deployment', 'ns-paas/paas-gateway-server', '10957', '容器云平台后台接口', 'ns-paas', '1', '2018-08-28 16:15:26', '2020-01-16 00:32:13');
INSERT INTO `t_app_manage` VALUES ('app_003', '平台后台用户模块', 'dep-paas-user', 'Deployment', 'ns-paas/paas-user-server', '10957', '容器云平台后台用户模块', 'ns-paas', '1', '2018-08-28 15:44:59', '2020-01-16 00:32:28');
INSERT INTO `t_app_manage` VALUES ('app_004', '平台后台应用模块', 'dep-paas-app', 'Deployment', 'ns-paas/paas-app-server', '10957', '容器云平台后台应用模块', 'ns-paas', '1', '2018-08-28 16:15:26', '2020-01-16 00:32:20');
INSERT INTO `t_app_manage` VALUES ('app_005', '平台后台日志模块', 'dep-paas-log', 'Deployment', 'ns-paas/paas-log-server', '10957', '平台后台日志模块', 'ns-paas', '1', '2018-08-28 08:32:35', '2020-01-16 00:32:34');
INSERT INTO `t_app_manage` VALUES ('app_006', '平台任务模块', 'dep-paas-task', 'Deployment', 'ns-paas/paas-task-server', '10957', '平台后台任务模块', 'ns-paas', '1', '2019-02-25 15:00:39', '2020-01-16 00:32:05');
INSERT INTO `t_app_manage` VALUES ('app_07', '平台后台监控服务', 'dep-paas-monitor', 'Deployment', 'ns-paas/paas-monitor-server', '10957', '平台后台监控服务', 'ns-paas', '1', '2019-07-23 14:43:31', '2020-01-16 00:32:00');
INSERT INTO `t_app_manage` VALUES ('b0026e82325a4c07b1e636bef8707acb', '物料管理---公共模块-测试', 'common-service-test', 'Deployment', 'testns/material-common-service', 'v01131507', '物料管理---公共模块-测试', 'testns', '1', '2019-05-17 16:47:21', '2020-01-13 01:13:52');
INSERT INTO `t_app_manage` VALUES ('b2c4e62fba8744f2843af512115f64d6', 'ELN---核心管理', 'eln-manage-test', 'Deployment', 'testns/eln-manage', 'v01151359', 'ELN---核心管理', 'testns', '1', '2019-08-12 01:37:48', '2020-01-15 00:06:13');
INSERT INTO `t_app_manage` VALUES ('b2c4e62fba8744f2843af512115f6jjj', 'ELN---核心管理', 'eln-manage-pro', 'Deployment', 'elnprod/eln-manage', 'v10311418', 'ELN---核心管理', 'elnprod', '1', '2019-09-12 01:37:48', '2019-10-31 02:52:38');
INSERT INTO `t_app_manage` VALUES ('b2e84bc1ab6245d492153fe3bb23d78a', '物料---注册中心', 'arch-center-pro', 'Deployment', 'wlglxt/material-arch-center', 'v01141407', '物料---注册中心', 'wlglxt', '1', '2019-06-26 18:04:15', '2020-01-14 00:13:39');
INSERT INTO `t_app_manage` VALUES ('b4761b1ef527438babc63573aea51c6d', '专业职称--个人中心前端-生产', 'person-center-vue-p', 'Deployment', 'prons/person-center-vue', 'v12041740', '个人中心前端页面', 'prons', '1', '2019-03-06 12:45:37', '2019-12-04 03:50:49');
INSERT INTO `t_app_manage` VALUES ('b5abf7a00abb4cb28a5979f34be9739a', 'UCM-用户企业管理系统', 'ucm-manage-test', 'Deployment', 'testns/ucm-manage', 'v01141730', 'UCM-用户企业管理系统', 'testns', '1', '2020-01-12 23:45:32', '2020-01-14 03:31:23');
INSERT INTO `t_app_manage` VALUES ('b7f0273adb1b4c78a033439ac25e94ed', 'ELN---网关', 'eln-arch-gateway-test', 'Deployment', 'testns/eln-arch-gateway', 'v01151359', 'ELN---网关', 'testns', '1', '2019-08-01 17:48:59', '2020-01-15 00:06:05');
INSERT INTO `t_app_manage` VALUES ('b7f0273adb1b4c78a033439ac25e98yy', 'ELN---网关', 'eln-arch-gateway-pro', 'Deployment', 'elnprod/eln-arch-gateway', 'v10311418', 'ELN---网关', 'elnprod', '1', '2019-09-01 17:48:59', '2019-10-31 02:51:01');
INSERT INTO `t_app_manage` VALUES ('b842ead8d0e1462b95add6b2b88951d4', '物料---基础资料', 'material-fundermental-pro', 'Deployment', 'wlglxt/material-fundermental', 'v01141407', '物料---基础资料', 'wlglxt', '1', '2019-06-26 18:33:49', '2020-01-14 00:13:41');
INSERT INTO `t_app_manage` VALUES ('ba2cc140e43e4da6b7a80f7efcfea53b', '专业职称---权限认证', 'arch-auth-t', 'Deployment', 'testns/arch-auth', 'v12061413', '认证服务', 'testns', '1', '2019-02-25 14:38:29', '2019-12-06 00:23:59');
INSERT INTO `t_app_manage` VALUES ('bb0902c4b9814d14b19675036f95e5a7', 'ELN---菜单权限', 'eln-authorise-manager-test', 'Deployment', 'testns/eln-authorise-manager', 'v01151359', 'ELN---菜单权限', 'testns', '1', '2019-08-01 17:57:12', '2020-01-15 00:06:07');
INSERT INTO `t_app_manage` VALUES ('bb0902c4b9814d14b19675036f95ep00', 'ELN---菜单权限', 'eln-authorise-manager-pro', 'Deployment', 'elnprod/eln-authorise-manager', 'v10311418', 'ELN---菜单权限', 'elnprod', '1', '2019-09-01 17:57:12', '2019-10-31 03:09:16');
INSERT INTO `t_app_manage` VALUES ('c4c8b20d2be04bb9987942dc134f1a9f', '用户及企业管理---HTTP-测试', 'http-service-test', 'Deployment', 'testns/pm-http-service', 'v10221639', '用户及企业管理---HTTP-测试', 'testns', '1', '2019-05-17 15:43:42', '2019-10-22 03:52:21');
INSERT INTO `t_app_manage` VALUES ('c61b53e6b6a9468ba187d672043a2e12', '用户及企业管理---JWT授权-测试', 'auth-architecture-test', 'Deployment', 'testns/pm-auth-architecture', 'v10221639', '用户及企业管理---JWT授权-测试', 'testns', '1', '2019-05-17 15:42:04', '2019-10-22 03:52:22');
INSERT INTO `t_app_manage` VALUES ('ca830da0cdbb4c5cb0d34f6738e86653', '平台公共服务---邮箱和支付服务-生产', 'common-mail-pay-server-pro', 'Deployment', 'ggfwgl/common-mail-pay-server', 'v11121129', '平台公共服务---邮箱和支付服务-生产', 'ggfwgl', '1', '2019-09-28 03:19:38', '2019-11-11 21:43:46');
INSERT INTO `t_app_manage` VALUES ('ca961e74a11844e1a686a1e716ce747b', '用户及企业管理---用户企业管理-测试', 'person-manage-platform-test', 'Deployment', 'testns/pm-person-manage-platform', 'v10221639', '用户及企业管理---用户企业管理-测试', 'testns', '1', '2019-05-17 15:46:46', '2019-10-22 03:52:24');
INSERT INTO `t_app_manage` VALUES ('ccef08e4e5d245ed9ddc5b72161097f7', '物料管理---公共模块', 'common-service', 'Deployment', 'devspace/common-service', 'v1.0.23', '物料管理---公共模块 测试', 'devspace', '1', '2019-05-07 14:07:10', '2019-05-24 10:44:55');
INSERT INTO `t_app_manage` VALUES ('cdc29706622042a485d85f512965a2ff', '物料管理---注册中心-测试', 'arch-center-test', 'Deployment', 'testns/material-arch-center', 'v01131507', '物料管理---注册中心-测试', 'testns', '1', '2019-05-17 16:16:58', '2020-01-13 01:13:29');
INSERT INTO `t_app_manage` VALUES ('d122529f7f1842a185ed04c9d0fa36yu', 'ELN---注册中心', 'eln-arch-center-pro', 'Deployment', 'elnprod/eln-arch-center', 'v10311418', 'ELN---注册中心', 'elnprod', '1', '2019-09-01 14:35:12', '2019-10-31 02:50:17');
INSERT INTO `t_app_manage` VALUES ('d122529f7f1842a185ed04c9d0fa6438', 'ELN---注册中心', 'eln-arch-center-test', 'Deployment', 'testns/eln-arch-center', 'v01151359', 'ELN---注册中心', 'testns', '1', '2019-08-01 14:35:12', '2020-01-15 00:06:02');
INSERT INTO `t_app_manage` VALUES ('d194a04ccce64abaa6691ffb1c1215da', '平台公共服务---日志短信服务-测试', 'common-service-pintai-test', 'Deployment', 'testns/common-sms-log-server', 'v11211203', '平台公共服务---系统公共-测试', 'testns', '1', '2019-02-25 14:38:24', '2019-11-20 22:05:22');
INSERT INTO `t_app_manage` VALUES ('d23256ef4222459f98b6ea660032c95b', '物料管理---网关', 'arch-gateway', 'Deployment', 'devspace/arch-gateway', 'v1.0.11', 'arch-gateway', 'devspace', '1', '2019-05-07 13:49:01', '2019-05-24 10:45:24');
INSERT INTO `t_app_manage` VALUES ('d7091b11d0e445498a29f4913d4c6655', '专业职称---成绩管理', 'score-inquiry-t', 'Deployment', 'testns/score-inquiry', 'v12061413', '成绩管理服务', 'testns', '1', '2019-02-25 14:57:56', '2019-12-06 00:24:13');
INSERT INTO `t_app_manage` VALUES ('e1d14e6028684c55b980be36cdd6aef8', '用户及企业管理---JWT授权', 'auth-architecture-dev', 'Deployment', 'devspace/auth-architecture', 'v1.0.8', '用户及企业管理---JWT授权', 'devspace', '1', '2019-05-07 12:04:09', '2019-05-24 10:45:59');
INSERT INTO `t_app_manage` VALUES ('e680970ba6b4404485517a9fbfa112yf', 'ELN---鉴权', 'eln-arch-auth-pro', 'Deployment', 'elnprod/eln-arch-auth', 'v10311418', 'ELN---鉴权', 'elnprod', '1', '2019-09-01 17:39:28', '2019-10-31 02:50:54');
INSERT INTO `t_app_manage` VALUES ('e680970ba6b4404485517a9fbfa2046f', 'ELN---鉴权', 'eln-arch-auth-test', 'Deployment', 'testns/eln-arch-auth', 'v01151359', 'ELN---鉴权', 'testns', '1', '2019-08-01 17:39:28', '2020-01-15 00:06:04');
INSERT INTO `t_app_manage` VALUES ('e725587cd13c447a84d47e82c1536742', '物料管理---鉴权模块', 'arch-auth-dev', 'Deployment', 'devspace/arch-auth', 'v1.0.7', '物料管理---鉴权模块', 'devspace', '1', '2019-05-07 14:04:37', '2019-05-24 10:45:01');
INSERT INTO `t_app_manage` VALUES ('ebfc99038f564170bc4ff40f06e9655e', '用户及企业管理---注册中心', 'arch-center-pcm', 'Deployment', 'devspace/arch-center-pm', 'v1.0.9', '用户及企业管理注册中心', 'devspace', '1', '2019-05-07 11:52:27', '2019-05-24 10:46:18');
INSERT INTO `t_app_manage` VALUES ('ede0985ebb0741d7b9cebd05a635d1ee', '物料---前端页面', 'frontend-material-management-pro', 'Deployment', 'wlglxt/material-frontend-management', 'v01141407', '物料---前端页面', 'wlglxt', '1', '2019-06-26 18:39:16', '2020-01-14 00:13:42');
INSERT INTO `t_app_manage` VALUES ('f06ee46c03484cafacee2598d7dbf7f6', 'kenuolims', 'kenuolims', 'Deployment', 'lims/lims', 'v1.0.3', 'kenuolims', 'lims', '1', '2019-05-13 15:27:27', '2019-11-07 03:55:44');
INSERT INTO `t_app_manage` VALUES ('f3573db7c6e14c3b8b06c7d586150f7e', '认证服务', 'arch-auth', 'Deployment', 'gddev/arch-auth', 'v1.0.16', '权限管理', 'gddev', '1', '2019-01-24 09:47:37', '2019-01-30 11:54:16');
INSERT INTO `t_app_manage` VALUES ('feb2d6f4ac724007994e3ce755cfe5d1', '物料---网关', 'arch-gateway-pro', 'Deployment', 'wlglxt/material-arch-gateway', 'v01141407', '物料---网关', 'wlglxt', '1', '2019-06-26 18:20:20', '2020-01-14 00:13:43');
INSERT INTO `t_app_manage` VALUES ('ffd48f80bf7e44c4b2aebaa058b25933', '专业职称---系统管理后端', 'sys-manager-back-t', 'Deployment', 'testns/sys-manager', 'v12061413', '系统管理后端服务', 'testns', '1', '2019-02-25 15:00:39', '2019-12-06 00:24:14');

-- ----------------------------
-- Table structure for t_app_type
-- ----------------------------
DROP TABLE IF EXISTS `t_app_type`;
CREATE TABLE `t_app_type` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name` varchar(50) NOT NULL COMMENT '类型名称',
  `Described` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `last_update_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_app_type
-- ----------------------------
INSERT INTO `t_app_type` VALUES ('2770245c5284481882cb936f9f82a06b', '消息中间件', '消息中间件', '2018-06-06 17:03:58', '2018-06-06 17:03:58');
INSERT INTO `t_app_type` VALUES ('5a776d2c3dc544f2b12490fff8848515', 'web应用', 'web应用', '2017-09-28 15:09:39', '2019-08-08 02:58:44');
INSERT INTO `t_app_type` VALUES ('a42ebcc1eda64912af0bf9e5654362ac', '数据库', '数据库', '2017-09-28 15:09:05', '2019-08-08 03:02:35');

-- ----------------------------
-- Table structure for t_ex_log
-- ----------------------------
DROP TABLE IF EXISTS `t_ex_log`;
CREATE TABLE `t_ex_log` (
  `id` varchar(32) NOT NULL,
  `user` varchar(32) NOT NULL,
  `type` varchar(20) NOT NULL COMMENT '异常类型(业务异常,系统异常)',
  `code` int(10) NOT NULL,
  `msg` text COMMENT '异常消息',
  `Create_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_oper_log_par
-- ----------------------------
DROP TABLE IF EXISTS `t_oper_log_par`;
CREATE TABLE `t_oper_log_par` (
  `id` varchar(32) NOT NULL,
  `Fun_level_one` varchar(50) NOT NULL DEFAULT '' COMMENT '一级功能名称',
  `Fun_level_two` varchar(50) NOT NULL DEFAULT '' COMMENT '二级功能名称',
  `Oper_type` varchar(50) NOT NULL COMMENT '操作类型',
  `class_name` varchar(200) NOT NULL DEFAULT '' COMMENT 'class类名全路径',
  `Method_name` varchar(100) NOT NULL DEFAULT '' COMMENT 'server方法名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_physical_group
-- ----------------------------
DROP TABLE IF EXISTS `t_physical_group`;
CREATE TABLE `t_physical_group` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name_cn` varchar(50) NOT NULL COMMENT '名称(中文)(全表不能重复)',
  `name_en` varchar(100) NOT NULL COMMENT '名称(英文)(全表不能重复)',
  `type` int(1) NOT NULL DEFAULT '0' COMMENT '类型0:共享物理组1:平台专用物理组2:应用系统物理组',
  `described` varchar(255) DEFAULT '' COMMENT '描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_update_time` datetime NOT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='物理分组表';

-- ----------------------------
-- Records of t_physical_group
-- ----------------------------
INSERT INTO `t_physical_group` VALUES ('0d313307d35e4347ae65ee3aa0994ede', '专业职称认证系统', 'zyzcrzxt', '2', '专业职称认证系统', '2019-01-14 09:11:43', '2019-01-14 09:11:43');
INSERT INTO `t_physical_group` VALUES ('45134bf0590b4b4aa950912aec908406', '实验室管理系统', 'lims', '2', '', '2019-05-13 16:04:31', '2019-05-13 16:04:31');
INSERT INTO `t_physical_group` VALUES ('478f78cfe5ac459aace8750b2ce8b47e', '开发测试资源', 'devtest', '0', '开发测试资源', '2019-01-14 09:09:55', '2019-01-14 09:09:55');
INSERT INTO `t_physical_group` VALUES ('6d75d8a950e84b09ae26c329bb28034d', '公共对外服务', 'ggdwfu', '2', '对外公共服务', '2019-09-28 03:22:45', '2019-09-28 03:22:45');
INSERT INTO `t_physical_group` VALUES ('73a184a548f54d1d86352c3e8fe47545', '测试环境外网服务', 'outservicetest', '1', '测试环境外网服务', '2019-09-18 04:03:50', '2019-09-18 04:03:50');
INSERT INTO `t_physical_group` VALUES ('group_001', '容器云平台专用物理组', 'group-paas', '1', '容器云平台专用物理组', '2018-01-08 13:25:02', '2018-01-08 13:25:02');
INSERT INTO `t_physical_group` VALUES ('group_002', 'k8s-master专用物理组', 'group-master', '1', '容器云平台专用物理组', '2017-11-06 14:43:32', '2017-11-06 14:43:32');

-- ----------------------------
-- Table structure for t_repository_app_store
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_app_store`;
CREATE TABLE `t_repository_app_store` (
  `id` varchar(32) NOT NULL,
  `name` varchar(100) NOT NULL COMMENT '镜像名称',
  `app_type` varchar(32) NOT NULL COMMENT '应用类型',
  `Described` varchar(100) NOT NULL COMMENT '应用描述',
  `create_time` datetime NOT NULL,
  `last_update_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_repository_app_store
-- ----------------------------

-- ----------------------------
-- Table structure for t_repository_public
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_public`;
CREATE TABLE `t_repository_public` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name` varchar(100) NOT NULL COMMENT '镜像名称(不能重复)',
  `create_time` datetime NOT NULL,
  `last_update_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_repository_public
-- ----------------------------

-- ----------------------------
-- Table structure for t_role
-- ----------------------------
DROP TABLE IF EXISTS `t_role`;
CREATE TABLE `t_role` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name` varchar(50) NOT NULL COMMENT '角色名称',
  `described` varchar(50) DEFAULT NULL COMMENT '角色描述',
  `is_superadmin` int(1) NOT NULL DEFAULT '0' COMMENT '是否超级管理员(0:否,1:是)',
  `function` text COMMENT '功能,多个逗号隔开.如果是超级管理员则给空',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_update_time` datetime NOT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Records of t_role
-- ----------------------------
INSERT INTO `t_role` VALUES ('297457123bf6451dabe41c237a8c7fc7', '运维人员', '运维人员', '0', '[\"006cf789591944e2aa2db2fd0d555af5\",\"90d1c93fca1e4b139af2b2ac35d8fccd\",\"e004e72d28594988ba2a31cf15fc3418\",\"5c0dac514a4b454f8d3adb19d92a05b3\",\"51d2ba09aa3b4e47b3d6cdb06767620b\",\"60f43249279748069ebd38692c6d73e7\",\"bb8122a7dcde418e875f64b4edbdd419\",\"15d3751d17ca4038a59c20b94f838e51\",\"863de1333f6643bfa1a263d9897143c6\",\"8a993489b1db4f1ebcc870b05d296b1b\",\"a7d60cb6acaf4e64a8b212094e92f6c4\",\"1e054fe0a8ef49349cfea54ccd0d1287\",\"7456c2fdb22645659ebeba51d195bbda\",\"751084f783d44eafaf483fa1053e5164\",\"9af4f05f91fc4a0e8c50d402b3c180ca\",\"6b7edd7864ed44f187da3f85156251d0\"]', '2017-09-28 14:31:16', '2018-01-17 10:36:22');
INSERT INTO `t_role` VALUES ('30b310ce7c3740fba29183c21c5c450a', '测试人员', '测试人员', '0', '[\"006cf789591944e2aa2db2fd0d555af5\",\"4749f9a9734a480487852e1578bf6c23\",\"15d3751d17ca4038a59c20b94f838e51\",\"863de1333f6643bfa1a263d9897143c6\",\"8a993489b1db4f1ebcc870b05d296b1b\",\"a7d60cb6acaf4e64a8b212094e92f6c4\",\"e0f75f0bc32d48fd966291991d861fe4\",\"90d1c93fca1e4b139af2b2ac35d8fccd\",\"e004e72d28594988ba2a31cf15fc3418\",\"1e054fe0a8ef49349cfea54ccd0d1287\",\"7456c2fdb22645659ebeba51d195bbda\",\"751084f783d44eafaf483fa1053e5164\",\"9af4f05f91fc4a0e8c50d402b3c180ca\",\"6b7edd7864ed44f187da3f85156251d0\",\"a14481b99ea44a5384d914ccf1916913\",\"fd60fddf434241aebc49bb60f0fdf4ca\",\"5c0dac514a4b454f8d3adb19d92a05b3\",\"60f43249279748069ebd38692c6d73e7\"]', '2017-09-28 14:30:28', '2018-03-27 06:41:30');
INSERT INTO `t_role` VALUES ('6c746caee9244e51b7e923af429367d6', '日志查看', '日志查看，只读角色', '0', '[\"60f43249279748069ebd38692c6d73e7\"]', '2019-08-08 10:48:56', '2019-08-08 10:48:56');
INSERT INTO `t_role` VALUES ('734e54deae8847a4944d59a85a2af963', '开发人员', '开发人员', '0', '[\"006cf789591944e2aa2db2fd0d555af5\",\"25db373c5ed9411a9091e0e5d745ad11\",\"3b14a577880b4013a59eb4e7b90170d7\",\"4749f9a9734a480487852e1578bf6c23\",\"90d1c93fca1e4b139af2b2ac35d8fccd\",\"e004e72d28594988ba2a31cf15fc3418\",\"5c0dac514a4b454f8d3adb19d92a05b3\",\"9750ac0cdf76437797b059ea97e3bddc\",\"ffc3e52a6285426a8df71bb7a249d7cc\",\"0b21bf96c448470db4eacd2504574c96\",\"60f43249279748069ebd38692c6d73e7\",\"bb8122a7dcde418e875f64b4edbdd419\",\"15d3751d17ca4038a59c20b94f838e51\",\"863de1333f6643bfa1a263d9897143c6\",\"8a993489b1db4f1ebcc870b05d296b1b\",\"a7d60cb6acaf4e64a8b212094e92f6c4\",\"e0f75f0bc32d48fd966291991d861fe4\",\"1e054fe0a8ef49349cfea54ccd0d1287\",\"7456c2fdb22645659ebeba51d195bbda\",\"751084f783d44eafaf483fa1053e5164\",\"9af4f05f91fc4a0e8c50d402b3c180ca\"]', '2017-09-28 14:27:32', '2019-10-17 21:04:16');
INSERT INTO `t_role` VALUES ('73ddf369f50c43adb3ae923a27fed378', '日志查看全部', '查看平台所有日志', '0', '[\"3b14a577880b4013a59eb4e7b90170d7\",\"0b21bf96c448470db4eacd2504574c96\",\"60f43249279748069ebd38692c6d73e7\",\"bb8122a7dcde418e875f64b4edbdd419\"]', '2019-08-14 21:42:38', '2019-08-14 21:42:38');
INSERT INTO `t_role` VALUES ('a175a8df9c5e40f982e2b89c2b62c27c', '超级管理员', '超级管理员', '1', '', '2017-09-11 11:14:30', '2017-09-15 13:50:27');

-- ----------------------------
-- Table structure for t_team
-- ----------------------------
DROP TABLE IF EXISTS `t_team`;
CREATE TABLE `t_team` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name_cn` varchar(50) NOT NULL COMMENT '名称(中文)(全表不能重复)',
  `name_en` varchar(100) NOT NULL COMMENT '名称(英文)(全表不能重复)',
  `User` varchar(32) NOT NULL COMMENT '团队所属用户id(一般是系统管理员)',
  `described` varchar(100) DEFAULT NULL COMMENT '团队描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_update_time` datetime NOT NULL COMMENT '最后更新时间',
  `status` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='团队表';

-- ----------------------------
-- Records of t_team
-- ----------------------------
INSERT INTO `t_team` VALUES ('169986f4c0a3404587ec397252f6c3fe', '开发组', 'gddev', '8b4deb2218627236b38bdbcbf58b9b13', '开发团队', '2019-01-10 15:35:27', '2019-01-10 15:35:27', '1');
INSERT INTO `t_team` VALUES ('4aeceb03326c49df99d1e59a4ea8de8f', '电子试验记录本', 'ELN', '8b4deb2218627236b38bdbcbf58b9b13', '电子试验记录本', '2019-10-29 22:05:36', '2019-10-29 22:05:36', '1');
INSERT INTO `t_team` VALUES ('89a837b344ed48afb3a22ae5666405af', '测试环境外网服务', 'outservicesTest', '8b4deb2218627236b38bdbcbf58b9b13', '测试环境外网服务', '2019-09-18 04:01:36', '2019-09-18 04:01:36', '0');
INSERT INTO `t_team` VALUES ('98463a51205d4dd2815c0c59ae6fae6d', '实验室管理系统', 'LIMS', '8b4deb2218627236b38bdbcbf58b9b13', '实验室管理系统', '2019-05-09 15:50:45', '2019-05-09 15:50:45', '1');
INSERT INTO `t_team` VALUES ('9a8d5bc8d9fe469088a79d3176a1b396', '物料管理系统', 'wlglxt', '8b4deb2218627236b38bdbcbf58b9b13', '物料管理系统', '2019-05-05 15:54:33', '2019-05-05 15:54:33', '1');
INSERT INTO `t_team` VALUES ('c33c70f38902473295222b47c7c1fdef', '企业及用户管理', 'usermanager', '8b4deb2218627236b38bdbcbf58b9b13', '企业及用户管理', '2019-05-05 15:54:10', '2019-05-05 15:54:10', '1');
INSERT INTO `t_team` VALUES ('c6673bce146042bfb65291e7d59f19cd', '专业职称认证系统', 'zyzcrz', '8b4deb2218627236b38bdbcbf58b9b13', '专业职称认证系统', '2019-01-16 09:05:42', '2019-01-16 09:05:42', '1');
INSERT INTO `t_team` VALUES ('e1fc398a6ad240ca8eb394252edad947', '测试组', 'gdtest', '8b4deb2218627236b38bdbcbf58b9b13', '测试组', '2019-01-10 15:50:16', '2019-01-10 15:50:16', '1');
INSERT INTO `t_team` VALUES ('eae77a55ebe64b048a17e746f1c5c0f2', '公共服务', 'commonServices', '8b4deb2218627236b38bdbcbf58b9b13', '公共服务管理', '2019-05-05 15:53:30', '2019-05-05 15:53:30', '1');
INSERT INTO `t_team` VALUES ('team_001', '细胞治疗云', 'ns-paas', '8b4deb2218627236b38bdbcbf58b9b13', '细胞治疗云', '2018-08-28 15:33:43', '2018-08-28 15:33:46', '1');
INSERT INTO `t_team` VALUES ('team_002', '集群系统空间\r\n', 'kube-system', '8b4deb2218627236b38bdbcbf58b9b13', '集群系统空间\r\n', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '1');

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `login_name` varchar(50) NOT NULL COMMENT '登录名(全表不能重复)',
  `login_password` varchar(100) NOT NULL COMMENT '登录密码',
  `name` varchar(50) NOT NULL COMMENT '真实姓名',
  `sex` int(1) NOT NULL COMMENT '性别 0:男 1:女',
  `phone` varchar(20) NOT NULL COMMENT '手机号',
  `email` varchar(50) NOT NULL COMMENT 'Email',
  `role` varchar(32) NOT NULL COMMENT '角色id',
  `token` varchar(32) DEFAULT NULL COMMENT '登录token(用户控制只能有一人登录)',
  `login_time` datetime DEFAULT NULL COMMENT '登录时间(用户控制session失效)',
  `session_expire_time` int(11) DEFAULT NULL COMMENT 'Session保留时间 单位为s',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_update_time` datetime NOT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES ('04215d3dc20d47e9ac47bdca1be9f8e4', 'yangyunjun', 'e10adc3949ba59abbe56e057f20f883e', '杨运君', '0', '13800000000', 'yunjun@nlelpct.com', 'a175a8df9c5e40f982e2b89c2b62c27c', 'c1de848eef914d6bb83089652eeca27d', '2020-01-16 00:56:23', '1800', '2019-06-27 10:49:11', '2019-06-27 10:49:11');
INSERT INTO `t_user` VALUES ('0a858a1f8db144209e67649b3004d7ee', 'zhoufei', 'e10adc3949ba59abbe56e057f20f883e', '周飞', '0', '13800000000', 'zhoufei@nlaelpct.com', '734e54deae8847a4944d59a85a2af963', 'a65ade9158eb432db26f065384951b18', '2020-01-15 01:20:28', '1800', '2019-06-10 09:31:03', '2019-06-10 09:31:03');
INSERT INTO `t_user` VALUES ('3b246737e71f4b19bc7442f03d81b3f4', 'machangle', 'e10adc3949ba59abbe56e057f20f883e', '马常乐', '0', '13800138000', 'machangle@nlelpct.com', 'a175a8df9c5e40f982e2b89c2b62c27c', 'c078ff4212df44fbbc44a0460e59341c', '2020-01-15 03:26:49', '1800', '2019-11-11 02:50:42', '2019-11-11 02:50:42');
INSERT INTO `t_user` VALUES ('3c7a7d12407a49b9b55ed2cecdd2c2dc', 'zyh', 'ee3a1847654a1c5965981c80e3779bd7', 'zyh', '0', '13576894488', 'scotttom@163.com', 'a175a8df9c5e40f982e2b89c2b62c27c', 'f79c3b2490fe4a38977372eda19b210f', '2019-04-12 14:57:43', '1800', '2019-01-11 10:56:19', '2019-01-11 10:56:19');
INSERT INTO `t_user` VALUES ('42629b8413cf418dafbd64c3e831fbb3', 'wanghaijun', '94cb16566b349e62ce4bb628a23dafd2', '王海军', '0', '13800138000', 'haijun@nlaelpct.com', 'a175a8df9c5e40f982e2b89c2b62c27c', 'c609c2e28c0646ecb5c5b5245217bf31', '2019-12-23 22:01:52', '1800', '2019-08-02 10:12:26', '2019-08-02 10:12:26');
INSERT INTO `t_user` VALUES ('5f718e1180a742f2ba909e64d2fe483e', 'longtx', 'eb0dff1c3d6739e71d7360c6e0aa4510', '龙土兴', '0', '13800000000', 'tuxing@nlaelpct.com', '734e54deae8847a4944d59a85a2af963', 'cfac8c385dcc4f4da12a52bc288343e1', '2020-01-12 19:12:01', '1800', '2019-01-15 10:23:49', '2019-01-15 10:23:49');
INSERT INTO `t_user` VALUES ('777ff8667ff24c9a8aa44a19d4f3468b', 'huanglei', 'fc7fc678608590b123692867f176fe63', '黄磊', '0', '18986800424', 'aad@fdfds.com', 'a175a8df9c5e40f982e2b89c2b62c27c', 'ca745b75b6764f87a62ce0e091faf793', '2020-01-16 01:07:18', '999999999', '2019-04-29 15:54:00', '2019-04-29 15:54:00');
INSERT INTO `t_user` VALUES ('8b4deb2218627236b38bdbcbf58b9b13', 'admin', '94cb16566b349e62ce4bb628a23dafd2', 'devin', '1', '18696167082', '11@kenuo.com', 'a175a8df9c5e40f982e2b89c2b62c27c', '14f545a672704e4fa824b90458d7cf8d', '2020-01-15 22:32:21', '60000000', '2017-09-04 19:24:47', '2017-09-04 19:25:06');
INSERT INTO `t_user` VALUES ('92ebeba717f34a8b8920e45d1352a3de', 'chenzk', 'eb0dff1c3d6739e71d7360c6e0aa4510', '陈振凯', '0', '13800000000', 'zhenkai@nlaelpct.com', '734e54deae8847a4944d59a85a2af963', '', null, '1800', '2019-01-15 10:22:42', '2019-01-15 10:22:42');
INSERT INTO `t_user` VALUES ('9a04e493dc3b4b68b7f06befb86656eb', 'xiaosongzhao', '8b5adb4d9e9c542ffcce3174d1c85451', '肖松钊', '0', '13800000000', 'songzhao@nlelpct.com', 'a175a8df9c5e40f982e2b89c2b62c27c', '0693efd054454ff28181c86f394f5e6c', '2020-01-16 00:14:20', '1800', '2019-05-21 11:38:06', '2019-05-21 11:38:06');
INSERT INTO `t_user` VALUES ('9d683433cb04493f9104cbd73774f616', 'chenjx', '94cb16566b349e62ce4bb628a23dafd2', '陈建欣', '0', '13800000000', 'jianxin@nlaelpct.com', '297457123bf6451dabe41c237a8c7fc7', '4fd8db31a102450aac71cf791d409f08', '2019-02-20 15:34:10', '1800', '2019-01-14 16:26:52', '2019-01-14 16:26:52');
INSERT INTO `t_user` VALUES ('a12dfdf6fa8c4079a4b4f9e74f3c2089', 'BOT', '01eaf7f4757314fc9def53a5e4d3f75d', '自动发布机器人', '0', '18986800424', '1111@qq.com', 'a175a8df9c5e40f982e2b89c2b62c27c', '8ce1a198269c4d1f933d8c0762684fd4', '2020-01-15 00:06:16', '1800', '2019-08-09 00:46:50', '2019-08-09 00:46:50');
INSERT INTO `t_user` VALUES ('a512eba5fbcd40d79c637d5eae068d1f', 'lianhm', 'eb0dff1c3d6739e71d7360c6e0aa4510', '练华民', '0', '13800000000', 'huamin@nlaelpct.com', '734e54deae8847a4944d59a85a2af963', '9a2055a0f71148b88340fb213778ad99', '2020-01-10 03:22:11', '1800', '2019-01-15 10:23:21', '2019-01-15 10:23:21');
INSERT INTO `t_user` VALUES ('ad51e56061814782abbee2f91de2cc0d', 'logcheck', 'd9f9cba07e0e54594edee3f32a20c830', 'log', '0', '18100000000', '18100000000@163.com', '6c746caee9244e51b7e923af429367d6', 'a7edd9a1b2f74a29ba2d4819a1589561', '2019-08-21 20:39:00', '99999', '2019-08-08 10:50:56', '2019-08-08 10:50:56');
INSERT INTO `t_user` VALUES ('d2fa851d0c4e41e58c84ee4785417a59', 'liuwen', '2198d45569dbbd23dce3a48c77497b59', '刘文', '1', '13000000000', '123@qq.com', '734e54deae8847a4944d59a85a2af963', '', null, '1800', '2019-07-16 17:20:24', '2019-07-16 17:20:24');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(40) NOT NULL,
  `realname` varchar(255) NOT NULL,
  `comment` varchar(30) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `reset_uuid` varchar(40) DEFAULT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `sysadmin_flag` tinyint(1) DEFAULT NULL,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'admin', 'admin@example.com', 'd2e1c5423255cf2d00267d3b439e7f49', 'system admin', 'admin user', '0', null, '5dgoowgtdj6e1nnpel55wpjvst107mqw', '1', '2019-01-10 16:23:00', '2018-08-14 09:02:17');
INSERT INTO `user` VALUES ('2', 'anonymous', 'anonymous@example.com', '', 'anonymous user', 'anonymous user', '1', null, null, '0', '2018-08-14 09:02:17', '2018-08-14 09:02:17');
INSERT INTO `user` VALUES ('3', 'jaosn', 'simsq@vip.qq.com', '96f407eb278776f5318b6f3f5a6b598f', 'sq', '', '0', null, 'oggss3kq1ropbjauj3b7r26o296ufxni', '0', '2019-02-28 07:59:35', '2019-02-28 07:59:35');
INSERT INTO `user` VALUES ('4', 'xsz', 'xsz@163.com', '89d6242b723bf718b3fe1f41b4dee9ce', 'xsz', '', '0', null, 'mj4nh8k7cflwa5z6f3w7f1iso7w9g50l', '1', '2019-06-20 17:20:12', '2019-05-24 01:13:47');

-- ----------------------------
-- Table structure for user_group
-- ----------------------------
DROP TABLE IF EXISTS `user_group`;
CREATE TABLE `user_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) NOT NULL,
  `group_type` int(11) DEFAULT '0',
  `ldap_group_dn` varchar(512) NOT NULL,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_group
-- ----------------------------
