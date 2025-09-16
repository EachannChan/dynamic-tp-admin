-- MySQL dump 10.13  Distrib 9.3.0, for macos15.2 (arm64)
--
-- Host: 127.0.0.1    Database: dynamic_tp_admin
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `man_client`
--

DROP TABLE IF EXISTS `man_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `man_client` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `client_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端ID（客户端地址）',
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端名称',
  `service_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '服务名称',
  `client_ip` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '客户端IP地址',
  `client_port` int DEFAULT NULL COMMENT '客户端端口',
  `server_ip` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '服务端IP地址',
  `server_port` int DEFAULT NULL COMMENT '服务端端口',
  `is_online` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否在线(0:离线,1:在线)',
  `last_heartbeat_time` datetime DEFAULT NULL COMMENT '最后心跳时间',
  `last_connect_time` datetime DEFAULT NULL COMMENT '最后连接时间',
  `last_disconnect_time` datetime DEFAULT NULL COMMENT '最后断开时间',
  `connect_count` int NOT NULL DEFAULT '0' COMMENT '连接次数',
  `total_online_time` bigint NOT NULL DEFAULT '0' COMMENT '总在线时长(秒)',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ENABLE' COMMENT '状态（ENABLE:启用,DISABLE:禁用）',
  `remark` text COLLATE utf8mb4_unicode_ci COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建人',
  `create_user_id` bigint DEFAULT NULL COMMENT '创建用户ID',
  `update_user` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新人',
  `update_user_id` bigint DEFAULT NULL COMMENT '更新用户ID',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_client_id` (`client_id`) COMMENT '客户端ID唯一索引',
  UNIQUE KEY `uk_service_name` (`service_name`) COMMENT '服务名称唯一索引',
  KEY `idx_client_name` (`client_name`) COMMENT '客户端名称索引',
  KEY `idx_is_online` (`is_online`) COMMENT '在线状态索引',
  KEY `idx_status` (`status`) COMMENT '状态索引',
  KEY `idx_create_time` (`create_time`) COMMENT '创建时间索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户端管理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `man_client`
--

LOCK TABLES `man_client` WRITE;
/*!40000 ALTER TABLE `man_client` DISABLE KEYS */;
INSERT INTO `man_client` (`id`, `client_id`, `client_name`, `service_name`, `client_ip`, `client_port`, `server_ip`, `server_port`, `is_online`, `last_heartbeat_time`, `last_connect_time`, `last_disconnect_time`, `connect_count`, `total_online_time`, `status`, `remark`, `create_time`, `update_time`, `create_user`, `create_user_id`, `update_user`, `update_user_id`, `is_deleted`) VALUES (1954108931706327042,'127.0.0.1:51524','dynamic-tp-admin-demo','dynamic-tp-admin-demo:service','127.0.0.1',51524,'127.0.0.1',8989,1,NULL,'2025-08-15 15:29:04',NULL,267,0,'ENABLE',NULL,'2025-08-09 17:14:10','2025-08-15 15:29:04','管理员',1740288148287545345,NULL,NULL,0);
/*!40000 ALTER TABLE `man_client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `man_notify_platform`
--

DROP TABLE IF EXISTS `man_notify_platform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `man_notify_platform` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `platform_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '告警平台ID',
  `platform` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '告警平台名称',
  `url_key` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL密钥',
  `secret` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密钥',
  `webhook` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Webhook地址',
  `receivers` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all' COMMENT '接收者，多个用逗号分隔',
  `timeout` int NOT NULL DEFAULT '3000' COMMENT 'HTTP请求超时时间（毫秒）',
  `proxy_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DIRECT' COMMENT 'HTTP请求代理类型',
  `proxy_host` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'HTTP请求代理主机',
  `proxy_port` int DEFAULT '0' COMMENT 'HTTP请求代理端口',
  `client_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端ID',
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端名称',
  `status` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ENABLE' COMMENT '配置状态（ENABLE:启用,DISABLE:禁用）',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `create_user` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建用户名称',
  `create_user_id` bigint DEFAULT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_user` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新用户名称',
  `update_user_id` bigint DEFAULT NULL COMMENT '更新用户ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_platform_client` (`platform`,`client_name`),
  KEY `idx_platform_id` (`platform_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_client_name` (`client_name`),
  KEY `idx_platform` (`platform`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=1955925226965131267 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='告警渠道管理表 - 完全对齐NotifyPlatform结构';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `man_notify_platform`
--

LOCK TABLES `man_notify_platform` WRITE;
/*!40000 ALTER TABLE `man_notify_platform` DISABLE KEYS */;
INSERT INTO `man_notify_platform` (`id`, `platform_id`, `platform`, `url_key`, `secret`, `webhook`, `receivers`, `timeout`, `proxy_type`, `proxy_host`, `proxy_port`, `client_id`, `client_name`, `status`, `remark`, `create_user`, `create_user_id`, `create_time`, `update_user`, `update_user_id`, `update_time`, `is_deleted`) VALUES (1955925226965131266,'11b68ab7-8012-4cfa-993c-297638c3e243','dingtalk','admin','kt123456','f80dad441fcd655438f4a08dcd6a','all',3000,'DIRECT','',0,'127.0.0.1:58635','dynamic-tp-admin-demo','ENABLE','','管理员',1740288148287545345,'2025-08-14 17:31:28',NULL,NULL,'2025-08-14 17:31:28',0);
/*!40000 ALTER TABLE `man_notify_platform` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `man_notify_item`
--

DROP TABLE IF EXISTS `man_notify_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `man_notify_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `thread_pool_id` bigint NOT NULL COMMENT '线程池ID',
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知类型',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用通知',
  `threshold` int NOT NULL DEFAULT '70' COMMENT '指标检测阈值',
  `count` int NOT NULL DEFAULT '1' COMMENT '触发告警的次数',
  `period` int NOT NULL DEFAULT '120' COMMENT '检测周期（秒）',
  `silence_period` int NOT NULL DEFAULT '120' COMMENT '静默期（秒）',
  `cluster_limit` int NOT NULL DEFAULT '1' COMMENT '集群通知限制',
  `receivers` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT 'all' COMMENT '接收者���多个用逗号分隔',
  `platform_ids` text COLLATE utf8mb4_unicode_ci COMMENT '通知平台ID列表，JSON格式存储',
  `client_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端ID',
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端名称',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ENABLE' COMMENT '配置状态（ENABLE:启用,DISABLE:禁用）',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `create_user` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建用户名称',
  `create_user_id` bigint DEFAULT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_user` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新用户名称',
  `update_user_id` bigint DEFAULT NULL COMMENT '更新用户ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  KEY `idx_thread_pool_id` (`thread_pool_id`) COMMENT '线程池ID索引',
  KEY `idx_type` (`type`) COMMENT '通知类型索引',
  KEY `idx_enabled` (`enabled`) COMMENT '启用状态索引',
  KEY `idx_status` (`status`) COMMENT '配置状态索引',
  KEY `idx_client_id` (`client_id`) COMMENT '客户端ID索引',
  KEY `idx_client_name` (`client_name`) COMMENT '客户端名称索引',
  KEY `idx_create_time` (`create_time`) COMMENT '创建时间索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='线程池通知配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `man_notify_item`
--

LOCK TABLES `man_notify_item` WRITE;
/*!40000 ALTER TABLE `man_notify_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `man_notify_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `man_thread_pool`
--

DROP TABLE IF EXISTS `man_thread_pool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `man_thread_pool` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `thread_pool_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '线程池名称',
  `thread_pool_alias_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '线程池别名',
  `core_pool_size` int NOT NULL DEFAULT '10' COMMENT '核心线程数',
  `maximum_pool_size` int NOT NULL DEFAULT '20' COMMENT '最大线程数',
  `queue_capacity` int NOT NULL DEFAULT '1000' COMMENT '队列容量',
  `queue_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'LinkedBlockingQueue' COMMENT '队列类型',
  `rejected_execution_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'AbortPolicy' COMMENT '拒绝策略',
  `executor_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'common' COMMENT '执行器类型',
  `keep_alive_time` bigint NOT NULL DEFAULT '60' COMMENT '线程存活时间（秒）',
  `allow_core_thread_time_out` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否允许核心线程超时',
  `thread_name_prefix` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'thread-pool-' COMMENT '线程名称前缀',
  `run_timeout` bigint DEFAULT '0' COMMENT '执行超时时间（毫秒）',
  `queue_timeout` bigint DEFAULT '0' COMMENT '队列超时时间（毫秒）',
  `task_wrapper_names` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '任务包装器名称列表，逗号分隔',
  `wait_for_tasks_to_complete_on_shutdown` tinyint(1) DEFAULT '0' COMMENT '关闭时是否等待任务完成',
  `await_termination_seconds` bigint DEFAULT '0' COMMENT '等待终止的秒数',
  `pre_start_all_core_threads` tinyint(1) DEFAULT '0' COMMENT '是否预启动所有核心线程',
  `client_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端ID',
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '客户端名称',
  `status` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ENABLE' COMMENT '配置状态（ENABLE:启用,DISABLE:禁用）',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `create_user` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建用户名称',
  `create_user_id` bigint DEFAULT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_user` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新用户名称',
  `update_user_id` bigint DEFAULT NULL COMMENT '更新用户ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_thread_pool_name_client` (`thread_pool_name`,`client_name`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_client_name` (`client_name`),
  KEY `idx_thread_pool_name` (`thread_pool_name`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=1955463781058502658 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='线程池管理表 - 完全对齐DtpExecutorProps结构';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `man_thread_pool`
--

LOCK TABLES `man_thread_pool` WRITE;
/*!40000 ALTER TABLE `man_thread_pool` DISABLE KEYS */;
INSERT INTO `man_thread_pool` (`id`, `thread_pool_name`, `thread_pool_alias_name`, `core_pool_size`, `maximum_pool_size`, `queue_capacity`, `queue_type`, `rejected_execution_type`, `executor_type`, `keep_alive_time`, `allow_core_thread_time_out`, `thread_name_prefix`, `run_timeout`, `queue_timeout`, `task_wrapper_names`, `wait_for_tasks_to_complete_on_shutdown`, `await_termination_seconds`, `pre_start_all_core_threads`, `client_id`, `client_name`, `status`, `remark`, `create_user`, `create_user_id`, `create_time`, `update_user`, `update_user_id`, `update_time`, `is_deleted`) VALUES (1955463781058502657,'11','11',11,20,1000,'LinkedBlockingQueue','AbortPolicy','common',60,0,'thread-pool-',0,0,'',0,0,0,'127.0.0.1:54676','dynamic-tp-admin-demo','ENABLE','','管理员',1740288148287545345,'2025-08-13 10:57:51','管理员',1740288148287545345,'2025-08-15 11:04:48',0);
/*!40000 ALTER TABLE `man_thread_pool` ENABLE KEYS */;
UNLOCK TABLES;



--
-- Table structure for table `mon_logs_error`
--

DROP TABLE IF EXISTS `mon_logs_error`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_logs_error` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `request_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '请求ID',
  `ip` varchar(20) NOT NULL COMMENT 'IP',
  `ip_addr` varchar(45) NOT NULL COMMENT 'IP所属地',
  `user_agent` varchar(200) DEFAULT NULL COMMENT '登录代理',
  `request_uri` varchar(100) DEFAULT NULL COMMENT '请求URI',
  `request_method` varchar(20) DEFAULT NULL COMMENT '请求方式',
  `content_type` varchar(100) DEFAULT NULL COMMENT '请求内容类型',
  `operation` varchar(200) DEFAULT NULL COMMENT '接口说明',
  `method_name` varchar(64) DEFAULT NULL COMMENT '方法名称',
  `method_params` longtext COMMENT '请求参数',
  `use_time` bigint DEFAULT NULL COMMENT '请求耗时',
  `exception_message` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '异常信息',
  `exception_class` varchar(200) DEFAULT NULL COMMENT '异常类',
  `line` int DEFAULT NULL COMMENT '异常行号',
  `stack_trace` longtext COMMENT '堆栈信息',
  `create_user` varchar(40) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(40) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='错误异常日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_logs_error`
--

LOCK TABLES `mon_logs_error` WRITE;
/*!40000 ALTER TABLE `mon_logs_error` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_logs_error` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_logs_login`
--

DROP TABLE IF EXISTS `mon_logs_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_logs_login` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(40) NOT NULL COMMENT '用户名称',
  `user_real_name` varchar(20) DEFAULT NULL COMMENT '真实姓名',
  `ip` varchar(20) NOT NULL COMMENT 'IP',
  `ip_addr` varchar(45) NOT NULL COMMENT 'IP所属地',
  `user_agent` varchar(200) DEFAULT NULL COMMENT '登录代理',
  `status` varchar(2) DEFAULT '1' COMMENT '登录状态(0:失败 1:成功)',
  `message` varchar(200) DEFAULT NULL COMMENT '登录错误日志',
  `create_user` varchar(40) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(40) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='登录日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_logs_login`
--

LOCK TABLES `mon_logs_login` WRITE;
/*!40000 ALTER TABLE `mon_logs_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_logs_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_logs_operation`
--

DROP TABLE IF EXISTS `mon_logs_operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_logs_operation` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `request_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '请求ID',
  `ip` varchar(20) NOT NULL COMMENT 'IP',
  `ip_addr` varchar(45) NOT NULL COMMENT 'IP所属地',
  `user_agent` varchar(200) DEFAULT NULL COMMENT '登录代理',
  `request_uri` varchar(100) DEFAULT NULL COMMENT '请求URI',
  `request_method` varchar(20) DEFAULT NULL COMMENT '请求方式',
  `content_type` varchar(100) DEFAULT NULL COMMENT '请求内容类型',
  `operation` varchar(200) DEFAULT NULL COMMENT '接口说明',
  `method_name` varchar(64) DEFAULT NULL COMMENT '方法名称',
  `method_params` longtext COMMENT '请求参数',
  `use_time` bigint DEFAULT NULL COMMENT '请求耗时',
  `create_user` varchar(40) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(40) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_logs_operation`
--

LOCK TABLES `mon_logs_operation` WRITE;
/*!40000 ALTER TABLE `mon_logs_operation` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_logs_operation` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `mon_qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `mon_qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_qrtz_blob_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(190) NOT NULL,
  `TRIGGER_GROUP` varchar(190) NOT NULL,
  `BLOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `SCHED_NAME` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `mon_qrtz_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `mon_qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_qrtz_blob_triggers`
--

LOCK TABLES `mon_qrtz_blob_triggers` WRITE;
/*!40000 ALTER TABLE `mon_qrtz_blob_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_qrtz_blob_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_qrtz_calendars`
--

DROP TABLE IF EXISTS `mon_qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_qrtz_calendars` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `CALENDAR_NAME` varchar(190) NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_qrtz_calendars`
--

LOCK TABLES `mon_qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `mon_qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `mon_qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_qrtz_cron_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(190) NOT NULL,
  `TRIGGER_GROUP` varchar(190) NOT NULL,
  `CRON_EXPRESSION` varchar(120) NOT NULL,
  `TIME_ZONE_ID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `mon_qrtz_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `mon_qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_qrtz_cron_triggers`
--

LOCK TABLES `mon_qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `mon_qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `mon_qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_qrtz_fired_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `ENTRY_ID` varchar(95) NOT NULL,
  `TRIGGER_NAME` varchar(190) NOT NULL,
  `TRIGGER_GROUP` varchar(190) NOT NULL,
  `INSTANCE_NAME` varchar(190) NOT NULL,
  `FIRED_TIME` bigint NOT NULL,
  `SCHED_TIME` bigint NOT NULL,
  `PRIORITY` int NOT NULL,
  `STATE` varchar(16) NOT NULL,
  `JOB_NAME` varchar(190) DEFAULT NULL,
  `JOB_GROUP` varchar(190) DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`),
  KEY `IDX_mon_qrtz_FT_TRIG_INST_NAME` (`SCHED_NAME`,`INSTANCE_NAME`),
  KEY `IDX_mon_qrtz_FT_INST_JOB_REQ_RCVRY` (`SCHED_NAME`,`INSTANCE_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_mon_qrtz_FT_J_G` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_mon_qrtz_FT_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_mon_qrtz_FT_T_G` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_mon_qrtz_FT_TG` (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_qrtz_fired_triggers`
--

LOCK TABLES `mon_qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `mon_qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_qrtz_job_details`
--

DROP TABLE IF EXISTS `mon_qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_qrtz_job_details` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `JOB_NAME` varchar(190) NOT NULL,
  `JOB_GROUP` varchar(190) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) NOT NULL,
  `IS_DURABLE` varchar(1) NOT NULL,
  `IS_NONCONCURRENT` varchar(1) NOT NULL,
  `IS_UPDATE_DATA` varchar(1) NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) NOT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_mon_qrtz_J_REQ_RECOVERY` (`SCHED_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_mon_qrtz_J_GRP` (`SCHED_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_qrtz_job_details`
--

LOCK TABLES `mon_qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `mon_qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_qrtz_locks`
--

DROP TABLE IF EXISTS `mon_qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_qrtz_locks` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_qrtz_locks`
--

LOCK TABLES `mon_qrtz_locks` WRITE;
/*!40000 ALTER TABLE `mon_qrtz_locks` DISABLE KEYS */;
INSERT INTO `mon_qrtz_locks` (`SCHED_NAME`, `LOCK_NAME`) VALUES ('scheduler','STATE_ACCESS'),('scheduler','TRIGGER_ACCESS');
/*!40000 ALTER TABLE `mon_qrtz_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `mon_qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_qrtz_paused_trigger_grps` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_GROUP` varchar(190) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_qrtz_paused_trigger_grps`
--

LOCK TABLES `mon_qrtz_paused_trigger_grps` WRITE;
/*!40000 ALTER TABLE `mon_qrtz_paused_trigger_grps` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_qrtz_paused_trigger_grps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `mon_qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_qrtz_scheduler_state` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `INSTANCE_NAME` varchar(190) NOT NULL,
  `LAST_CHECKIN_TIME` bigint NOT NULL,
  `CHECKIN_INTERVAL` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_qrtz_scheduler_state`
--

LOCK TABLES `mon_qrtz_scheduler_state` WRITE;
/*!40000 ALTER TABLE `mon_qrtz_scheduler_state` DISABLE KEYS */;
INSERT INTO `mon_qrtz_scheduler_state` (`SCHED_NAME`, `INSTANCE_NAME`, `LAST_CHECKIN_TIME`, `CHECKIN_INTERVAL`) VALUES ('scheduler','localhost1755229541724',1755243336693,10000);
/*!40000 ALTER TABLE `mon_qrtz_scheduler_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `mon_qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_qrtz_simple_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(190) NOT NULL,
  `TRIGGER_GROUP` varchar(190) NOT NULL,
  `REPEAT_COUNT` bigint NOT NULL,
  `REPEAT_INTERVAL` bigint NOT NULL,
  `TIMES_TRIGGERED` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `mon_qrtz_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `mon_qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_qrtz_simple_triggers`
--

LOCK TABLES `mon_qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `mon_qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `mon_qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_qrtz_simprop_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(190) NOT NULL,
  `TRIGGER_GROUP` varchar(190) NOT NULL,
  `STR_PROP_1` varchar(512) DEFAULT NULL,
  `STR_PROP_2` varchar(512) DEFAULT NULL,
  `STR_PROP_3` varchar(512) DEFAULT NULL,
  `INT_PROP_1` int DEFAULT NULL,
  `INT_PROP_2` int DEFAULT NULL,
  `LONG_PROP_1` bigint DEFAULT NULL,
  `LONG_PROP_2` bigint DEFAULT NULL,
  `DEC_PROP_1` decimal(13,4) DEFAULT NULL,
  `DEC_PROP_2` decimal(13,4) DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `mon_qrtz_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `mon_qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_qrtz_simprop_triggers`
--

LOCK TABLES `mon_qrtz_simprop_triggers` WRITE;
/*!40000 ALTER TABLE `mon_qrtz_simprop_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_qrtz_simprop_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_qrtz_triggers`
--

DROP TABLE IF EXISTS `mon_qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_qrtz_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(190) NOT NULL,
  `TRIGGER_GROUP` varchar(190) NOT NULL,
  `JOB_NAME` varchar(190) NOT NULL,
  `JOB_GROUP` varchar(190) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint DEFAULT NULL,
  `PREV_FIRE_TIME` bigint DEFAULT NULL,
  `PRIORITY` int DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) NOT NULL,
  `TRIGGER_TYPE` varchar(8) NOT NULL,
  `START_TIME` bigint NOT NULL,
  `END_TIME` bigint DEFAULT NULL,
  `CALENDAR_NAME` varchar(190) DEFAULT NULL,
  `MISFIRE_INSTR` smallint DEFAULT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_mon_qrtz_T_J` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_mon_qrtz_T_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_mon_qrtz_T_C` (`SCHED_NAME`,`CALENDAR_NAME`),
  KEY `IDX_mon_qrtz_T_G` (`SCHED_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_mon_qrtz_T_STATE` (`SCHED_NAME`,`TRIGGER_STATE`),
  KEY `IDX_mon_qrtz_T_N_STATE` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_mon_qrtz_T_N_G_STATE` (`SCHED_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_mon_qrtz_T_NEXT_FIRE_TIME` (`SCHED_NAME`,`NEXT_FIRE_TIME`),
  KEY `IDX_mon_qrtz_T_NFT_ST` (`SCHED_NAME`,`TRIGGER_STATE`,`NEXT_FIRE_TIME`),
  KEY `IDX_mon_qrtz_T_NFT_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`),
  KEY `IDX_mon_qrtz_T_NFT_ST_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_STATE`),
  KEY `IDX_mon_qrtz_T_NFT_ST_MISFIRE_GRP` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  CONSTRAINT `mon_qrtz_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `mon_qrtz_job_details` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_qrtz_triggers`
--

LOCK TABLES `mon_qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `mon_qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `sys_data_scope`
--

DROP TABLE IF EXISTS `sys_data_scope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_data_scope` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(50) NOT NULL COMMENT '名称',
  `code` varchar(50) NOT NULL COMMENT '标识',
  `menu_id` bigint DEFAULT NULL COMMENT '菜单 ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `permission_id` bigint NOT NULL COMMENT '权限资源 ID',
  `permission_resource` varchar(200) NOT NULL COMMENT '权限资源标识',
  `permission_name` varchar(50) NOT NULL COMMENT '权限资源名称',
  `scope_type` varchar(2) NOT NULL COMMENT '数据权限类型',
  `scope_type_name` varchar(20) NOT NULL COMMENT '数据权限类型名称(全部数据权限/本部门及下级数据权限/本部门数据权限/本人及下级组织单位数据权限/自定义数据权限/仅本人数据权限)',
  `custom_fields` varchar(200) DEFAULT NULL COMMENT '自定义可见字段',
  `custom_rules` varchar(500) DEFAULT NULL COMMENT '自定义规则',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `sort` int DEFAULT '0' COMMENT '排序',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `status` char(1) DEFAULT '1' COMMENT '是否启用(0:禁用,1:启用)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据权限管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_data_scope`
--

LOCK TABLES `sys_data_scope` WRITE;
/*!40000 ALTER TABLE `sys_data_scope` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_data_scope` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict`
--

DROP TABLE IF EXISTS `sys_dict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(64) DEFAULT NULL COMMENT '字典名称',
  `code` varchar(64) NOT NULL COMMENT '字典编码',
  `type` varchar(2) DEFAULT '1' COMMENT '字典类型(1:系统字典,2:业务字典)',
  `sort` int DEFAULT '999' COMMENT '排序值',
  `description` varchar(500) DEFAULT NULL COMMENT '字典描述',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `status` varchar(2) DEFAULT '1' COMMENT '是否启用(0:禁用,1:启用)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据字典管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict`
--

LOCK TABLES `sys_dict` WRITE;
/*!40000 ALTER TABLE `sys_dict` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_dict` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_item`
--

DROP TABLE IF EXISTS `sys_dict_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_item` (
  `id` bigint NOT NULL COMMENT '主键',
  `dict_id` bigint DEFAULT NULL COMMENT '父字典ID',
  `dict_code` varchar(64) NOT NULL COMMENT '父字典编码',
  `value` varchar(64) NOT NULL COMMENT '数据值',
  `zh_cn` varchar(64) NOT NULL COMMENT '中文名称',
  `en_us` varchar(64) DEFAULT NULL COMMENT '英文名称',
  `type` varchar(20) DEFAULT NULL COMMENT '类型(前端渲染类型)',
  `sort` int DEFAULT '999' COMMENT '排序值',
  `description` varchar(500) DEFAULT NULL COMMENT '字典描述',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `status` varchar(2) DEFAULT '1' COMMENT '是否启用(0:禁用,1:启用)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据字典子项管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_item`
--

LOCK TABLES `sys_dict_item` WRITE;
/*!40000 ALTER TABLE `sys_dict_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_dict_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `id` bigint NOT NULL COMMENT '主键',
  `parent_id` bigint DEFAULT NULL COMMENT '父菜单ID',
  `type` varchar(20) NOT NULL COMMENT '菜单类型 1:目录 2:菜单',
  `name` varchar(50) NOT NULL COMMENT '菜单名称',
  `i18n_key` varchar(100) NOT NULL COMMENT '多语言标题',
  `route_name` varchar(50) NOT NULL COMMENT '路由名称',
  `route_path` varchar(255) NOT NULL COMMENT '菜单路径',
  `icon` varchar(50) DEFAULT NULL COMMENT '菜单图标',
  `icon_type` varchar(2) DEFAULT NULL COMMENT '图标类型 1:iconify icon 2:local icon',
  `component` varchar(60) DEFAULT NULL COMMENT '路由组件',
  `keep_alive` varchar(2) DEFAULT '1' COMMENT '缓存页面(Y:是,N:否)',
  `hide` varchar(2) DEFAULT '0' COMMENT '是否隐藏(Y:是,N:否)',
  `href` varchar(64) DEFAULT NULL COMMENT '外部链接',
  `sort` int DEFAULT '999' COMMENT '排序值',
  `multi_tab` varchar(2) DEFAULT NULL COMMENT '支持多标签(Y:是,N:否)',
  `fixed_index_in_tab` int DEFAULT NULL COMMENT '固定在页签中的序号',
  `iframe_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '内链URL',
  `query` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '路��查询参数',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `status` varchar(2) DEFAULT '1' COMMENT '是否启用(0:禁用,1:启用)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `sys_org_units`
--

DROP TABLE IF EXISTS `sys_org_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_org_units` (
  `id` bigint NOT NULL COMMENT '主键',
  `parent_id` bigint DEFAULT NULL COMMENT '父组织/部门/子部门ID',
  `name` varchar(200) NOT NULL COMMENT '组织/部门/子部门名称',
  `code` varchar(100) DEFAULT NULL COMMENT '组织/部门/子部门编码',
  `abbr` varchar(50) DEFAULT NULL COMMENT '组织/部门/子部门名称简写',
  `level` int NOT NULL DEFAULT '0' COMMENT '组织/部门/子��门层级',
  `ancestors` varchar(500) NOT NULL COMMENT '祖先节点',
  `description` varchar(500) DEFAULT NULL COMMENT '组织/部门/子部门描述',
  `sort` int DEFAULT '999' COMMENT '排序值',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `status` varchar(2) DEFAULT '1' COMMENT '是否启用(0:禁用,1:启用)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`),
  KEY `idx_ancestors_query` (`ancestors`,`id`),
  KEY `idx_ancestors_prefix` (`ancestors`(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='组织/部门/子部门管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_org_units`
--

LOCK TABLES `sys_org_units` WRITE;
/*!40000 ALTER TABLE `sys_org_units` DISABLE KEYS */;
INSERT INTO `sys_org_units` (`id`, `parent_id`, `name`, `code`, `abbr`, `level`, `ancestors`, `description`, `sort`, `create_user`, `create_user_id`, `create_time`, `update_user`, `update_user_id`, `update_time`, `status`, `is_deleted`) VALUES (1811413292597325825,0,'XXX 网络有限公司','XXX','XXX 公司',1,'0','',1,'管理员',1740288148287545345,'2024-07-11 22:52:38','管理员',1740288148287545345,'2024-07-16 17:45:19','1',0),(1813110675992604674,1811413292597325825,'业务部门','XXX-02','业务部',2,'0,1811413292597325825','',2,'管理员',1740288148287545345,'2024-07-16 15:17:26','管理员',1740288148287545345,'2024-07-16 16:21:32','1',0),(1813126760666099713,1811413292597325825,'技术部门','XXX-01','技术部',2,'0,1811413292597325825','',1,'管理员',1740288148287545345,'2024-07-16 16:21:21',NULL,NULL,NULL,'1',0),(1813126899820523522,1813126760666099713,'研发部','XXX-01-01','研发部',3,'0,1811413292597325825,1813126760666099713','',1,'管理员',1740288148287545345,'2024-07-16 16:21:54',NULL,NULL,NULL,'1',0),(1813126973426364417,1813126760666099713,'测试部','XXX-01-02','测试部',3,'0,1811413292597325825,1813126760666099713','',2,'管理员',1740288148287545345,'2024-07-16 16:22:11',NULL,NULL,NULL,'1',0),(1813127063759089666,1811413292597325825,'产品部门','XXX-03','产品部',2,'0,1811413292597325825','',3,'管理员',1740288148287545345,'2024-07-16 16:22:33',NULL,NULL,NULL,'1',0),(1813127185335185409,1811413292597325825,'设计部门','XXX-04','设计部',2,'0,1811413292597325825','',4,'管理员',1740288148287545345,'2024-07-16 16:23:02',NULL,NULL,NULL,'1',0),(1813127251865235457,1811413292597325825,'市场营销部门','XXX-05','市场营销部',2,'0,1811413292597325825','',5,'管理员',1740288148287545345,'2024-07-16 16:23:18',NULL,NULL,NULL,'1',0),(1813127307477512193,1811413292597325825,'运营部门','XXX-06','运营部',2,'0,1811413292597325825','',6,'管��员',1740288148287545345,'2024-07-16 16:23:31',NULL,NULL,NULL,'1',0),(1813127372849934338,1811413292597325825,'人力资源部门','XXX-07','人力资源部',2,'0,1811413292597325825','',7,'管理员',1740288148287545345,'2024-07-16 16:23:47',NULL,NULL,NULL,'1',0),(1813127433059168258,1811413292597325825,'财务部门','XXX-08','财务部',2,'0,1811413292597325825','',8,'管理员',1740288148287545345,'2024-07-16 16:24:01',NULL,NULL,NULL,'1',0),(1813146334140592129,0,'测试公司','T','T 公司',1,'0','',1,'管理员',1740288148287545345,'2024-07-16 17:39:07','管理员',1740288148287545345,'2024-07-16 17:45:15','1',0),(1813146357674831874,1813146334140592129,'法务部门','T-01','法务部',2,'0,1813146334140592129','',1,'管理员',1740288148287545345,'2024-07-16 17:39:13','管理员',1740288148287545345,'2024-07-16 22:08:44','1',0),(1813147751387525121,1813146357674831874,'网络组','T-01-01','网络组',3,'0,1813146334140592129,1813146357674831874','',1,'管理员',1740288148287545345,'2024-07-16 17:44:45',NULL,NULL,NULL,'1',0);
/*!40000 ALTER TABLE `sys_org_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_permission`
--

DROP TABLE IF EXISTS `sys_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_permission` (
  `id` bigint NOT NULL COMMENT '主键',
  `menu_id` bigint DEFAULT NULL COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `name` varchar(50) NOT NULL COMMENT '权限(按钮)名称',
  `resource` varchar(500) NOT NULL COMMENT '权限资源',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `status` varchar(2) DEFAULT '1' COMMENT '是否启用(0:禁用,1:启用)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='权限(按钮)管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_permission`
--

LOCK TABLES `sys_permission` WRITE;
/*!40000 ALTER TABLE `sys_permission` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_position`
--

DROP TABLE IF EXISTS `sys_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_position` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(200) NOT NULL COMMENT '岗位名称',
  `code` varchar(100) DEFAULT NULL COMMENT '岗位编码',
  `abbr` varchar(50) DEFAULT NULL COMMENT '岗位名称简写',
  `description` varchar(500) DEFAULT NULL COMMENT '岗位描述',
  `sort` int DEFAULT '999' COMMENT '排序值',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '���改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `status` varchar(2) DEFAULT '1' COMMENT '是否启用(0:禁用,1:启用)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='岗位管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_position`
--

LOCK TABLES `sys_position` WRITE;
/*!40000 ALTER TABLE `sys_position` DISABLE KEYS */;
INSERT INTO `sys_position` (`id`, `name`, `code`, `abbr`, `description`, `sort`, `create_user`, `create_user_id`, `create_time`, `update_user`, `update_user_id`, `update_time`, `status`, `is_deleted`) VALUES (1806240801177497602,'总经理','General Manager','GM','',1,'管理员',1740288148287545345,'2024-06-27 16:19:00','管理员',1740288148287545345,'2024-07-08 22:34:51','1',0),(1806241301570547713,'副总裁','Vice President','VP','',2,'管理员',1740288148287545345,'2024-06-27 16:20:59',NULL,NULL,NULL,'1',0),(1806242713427800066,'第一副总裁','First Vice President','FVP','',3,'管理员',1740288148287545345,'2024-06-27 16:26:36',NULL,NULL,NULL,'1',0),(1806242735305289729,'副总裁助理','Assistant Vice President','AVP','',4,'管理员',1740288148287545345,'2024-06-27 16:26:41',NULL,NULL,NULL,'1',0),(1806242759749693442,'首席执行官','Chief Executive Officer','CEO','',5,'管理员',1740288148287545345,'2024-06-27 16:26:47',NULL,NULL,NULL,'1',0),(1806242803462729729,'首席运营官','Chief Operations Officer','COO','',6,'管理员',1740288148287545345,'2024-06-27 16:26:57',NULL,NULL,NULL,'1',0),(1806242824534913026,'首席财务官','Chief Financial Officer','CFO','',7,'管理员',1740288148287545345,'2024-06-27 16:27:02',NULL,NULL,NULL,'1',0),(1806242857070129154,'首席信息官','Chief Information Officer','CIO','',8,'管理员',1740288148287545345,'2024-06-27 16:27:10',NULL,NULL,NULL,'1',0),(1806242885364903937,'首席技术官','Chief technology officer','CTO','',9,'管理员',1740288148287545345,'2024-06-27 16:27:17',NULL,NULL,NULL,'1',0),(1806242912464302082,'人力资源总监','Human Resource Director','HRD','',10,'管理员',1740288148287545345,'2024-06-27 16:27:23',NULL,NULL,NULL,'1',0),(1806243899446947842,'运营总监','Operations Director','OD','',11,'管理员',1740288148287545345,'2024-06-27 16:31:19',NULL,NULL,NULL,'1',0),(1806243917671198722,'市场总监','Marketing Director','MD','',12,'管理员',1740288148287545345,'2024-06-27 16:31:23',NULL,NULL,NULL,'1',0),(1806243962055323649,'运作经理','Operations Manager','OM','',13,'管理员',1740288148287545345,'2024-06-27 16:31:34',NULL,NULL,NULL,'1',0),(1806243973979729922,'项目经理','Project Manager','PM','',14,'管理员',1740288148287545345,'2024-06-27 16:31:36',NULL,NULL,NULL,'1',0),(1806243997388140546,'技术经理','Technical Manager','TM','',15,'管理员',1740288148287545345,'2024-06-27 16:31:42',NULL,NULL,NULL,'1',0),(1806244021291479042,'项目组长','Project Leader','PL','',16,'管理员',1740288148287545345,'2024-06-27 16:31:48',NULL,NULL,NULL,'1',0),(1806244030279872514,'小组组长','Team Leader','TL','',17,'管理员',1740288148287545345,'2024-06-27 16:31:50',NULL,NULL,NULL,'1',0),(1806244038974664706,'系统工程师','System Engineer','SE','',18,'管理员',1740288148287545345,'2024-06-27 16:31:52',NULL,NULL,NULL,'1',0),(1806244046436331521,'研发','Development','DEV','',19,'管理员',1740288148287545345,'2024-06-27 16:31:54',NULL,NULL,NULL,'1',0),(1806245308242358274,'测试','Quality Assurance','QA','',20,'管理员',1740288148287545345,'2024-06-27 16:36:55',NULL,NULL,NULL,'1',0);
/*!40000 ALTER TABLE `sys_position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `id` bigint NOT NULL COMMENT '主键',
  `parent_id` bigint DEFAULT '0' COMMENT '父主键',
  `role_name` varchar(50) NOT NULL COMMENT '角色名称',
  `role_code` varchar(50) NOT NULL COMMENT '角色编码',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `sort` int NOT NULL DEFAULT '999' COMMENT '排序',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `status` varchar(2) DEFAULT '1' COMMENT '是否启用(0:禁用,1:启用)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` (`id`, `parent_id`, `role_name`, `role_code`, `description`, `sort`, `create_user`, `create_user_id`, `create_time`, `update_user`, `update_user_id`, `update_time`, `status`, `is_deleted`) VALUES (1741390832464809986,0,'管理员','ADMIN','',1,'管理员',1740288148287545345,'2023-12-31 17:28:23','管理员',1740288148287545345,'2024-11-12 13:35:57','1',0),(1741390915314896897,0,'普通用户','COMMON','',2,'管理员',1740288148287545345,'2023-12-31 17:28:42','管理员',1740288148287545345,'2025-03-23 21:39:16','1',1);
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_data_scope`
--

DROP TABLE IF EXISTS `sys_role_data_scope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_data_scope` (
  `id` bigint NOT NULL COMMENT '主键',
  `role_id` bigint DEFAULT NULL COMMENT '角色 ID',
  `data_scope_id` bigint NOT NULL COMMENT '数据权限管理 ID',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_scope` (`role_id`,`data_scope_id`),
  KEY `idx_data_scope_id` (`data_scope_id`),
  CONSTRAINT `fk_role_data_scope_id` FOREIGN KEY (`data_scope_id`) REFERENCES `sys_data_scope` (`id`),
  CONSTRAINT `fk_role_data_scope_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色数据权限关联管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_data_scope`
--

LOCK TABLES `sys_role_data_scope` WRITE;
/*!40000 ALTER TABLE `sys_role_data_scope` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_data_scope` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `id` bigint NOT NULL,
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色菜单管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_permission`
--

DROP TABLE IF EXISTS `sys_role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_permission` (
  `id` bigint NOT NULL,
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色权限管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_permission`
--

LOCK TABLES `sys_role_permission` WRITE;
/*!40000 ALTER TABLE `sys_role_permission` DISABLE KEYS */;
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `create_user`, `create_user_id`, `create_time`, `update_user`, `update_user_id`, `update_time`, `is_deleted`) VALUES (1784192408660922369,1741390832464809986,1782303333037305858,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,1),(1784192408690282497,1741390832464809986,1741018053920913284,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,1),(1784192408707059713,1741390832464809986,1741018265053558032,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192408723836929,1741390832464809986,1741018053920913286,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192408736419841,1741390832464809986,1741018209721401971,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192408744808449,1741390832464809986,1741018053920213292,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192408769974273,1741390832464809986,1741018053920913287,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192408820305922,1741390832464809986,1741018013920913291,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192408837083138,1741390832464809986,1741018053924913282,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192408870637570,1741390832464809986,1782299348175892482,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192408883220481,1741390832464809986,1741018053920913282,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,1),(1784192408895803393,1741390832464809986,1741018053920913283,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,1),(1784192408908386305,1741390832464809986,1741018053920913292,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192408958717954,1741390832464809986,1741018013920113291,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192408971300866,1741390832464809986,1741018053920913288,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192408983883777,1741390832464809986,1741018053420913285,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192409000660993,1741390832464809986,1741018209721801971,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192409021632513,1741390832464809986,1741018265053858032,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192409034215426,1741390832464809986,1784174588657082370,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192409050992642,1741390832464809986,1782301676815708162,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784192409071964161,1741390832464809986,1782299465184391169,'管理员',1740288148287545345,'2024-04-27 20:06:34',NULL,NULL,NULL,0),(1784193419924393985,1741390832464809986,1784175362741051394,'管理员',1740288148287545345,'2024-04-27 20:10:35',NULL,NULL,NULL,0),(1784206770863828993,1741390915314896897,1782299348175892482,'管理员',1740288148287545345,'2024-04-27 21:03:38',NULL,NULL,NULL,0),(1784206770880606209,1741390915314896897,1782299465184391169,'管理员',1740288148287545345,'2024-04-27 21:03:38',NULL,NULL,NULL,0),(1784215196041977858,1741390915314896897,1741018053924913282,'管理员',1740288148287545345,'2024-04-27 21:37:07',NULL,NULL,NULL,1),(1786821001844838401,1741390832464809986,1786765590395572226,'管理员',1740288148287545345,'2024-05-05 02:11:39',NULL,NULL,NULL,0),(1786821001890975745,1741390832464809986,1786765451362783233,'管理员',1740288148287545345,'2024-05-05 02:11:39',NULL,NULL,NULL,0),(1791342529832001538,1741390832464809986,1787770631341694977,'管理员',1740288148287545345,'2024-05-17 13:38:35',NULL,NULL,NULL,0),(1791342529848778753,1741390832464809986,1787125846288338946,'管理员',1740288148287545345,'2024-05-17 13:38:35',NULL,NULL,NULL,0),(1791342529861361666,1741390832464809986,1787400109093228545,'管理员',1740288148287545345,'2024-05-17 13:38:35',NULL,NULL,NULL,0),(1791342570034405377,1741390915314896897,1782301676815708162,'管理员',1740288148287545345,'2024-05-17 13:38:45',NULL,NULL,NULL,0),(1792836638606233601,1741390832464809986,1792836232505331714,'管理员',1740288148287545345,'2024-05-21 16:35:39',NULL,NULL,NULL,0),(1792836638639788033,1741390832464809986,1792835921493495810,'管理员',1740288148287545345,'2024-05-21 16:35:39',NULL,NULL,NULL,0),(1792836638648176641,1741390832464809986,1792836461925371905,'管理员',1740288148287545345,'2024-05-21 16:35:39',NULL,NULL,NULL,0),(1792836638656565249,1741390832464809986,1792836535111782401,'管理员',1740288148287545345,'2024-05-21 16:35:39',NULL,NULL,NULL,0),(1792836638664953857,1741390832464809986,1792835760448999425,'管理员',1740288148287545345,'2024-05-21 16:35:39',NULL,NULL,NULL,0),(1792836638694313986,1741390832464809986,1792836600127688706,'管理员',1740288148287545345,'2024-05-21 16:35:39',NULL,NULL,NULL,1),(1792836638698508289,1741390832464809986,1792836147600035841,'管理员',1740288148287545345,'2024-05-21 16:35:39',NULL,NULL,NULL,0),(1792836638706896897,1741390832464809986,1792836379381469186,'管理员',1740288148287545345,'2024-05-21 16:35:39',NULL,NULL,NULL,0),(1793107463071879169,1741390832464809986,1792836600127688706,'管理员',1740288148287545345,'2024-05-22 10:31:48',NULL,NULL,NULL,0),(1793657807186083842,1741390832464809986,1793657309158621186,'管理员',1740288148287545345,'2024-05-23 22:58:40',NULL,NULL,NULL,0),(1796179284636684289,1741390832464809986,1796179230710517761,'管理员',1740288148287545345,'2024-05-30 21:58:08',NULL,NULL,NULL,0),(1798244607619702786,1741390915314896897,1741018209721401971,'管理员',1740288148287545345,'2024-06-05 14:44:59',NULL,NULL,NULL,1),(1798244607640674305,1741390915314896897,1741018053920913287,'管理员',1740288148287545345,'2024-06-05 14:44:59',NULL,NULL,NULL,1),(1798244626368241665,1741390915314896897,1741018053920913286,'管理员',1740288148287545345,'2024-06-05 14:45:03',NULL,NULL,NULL,1),(1798244626410184705,1741390915314896897,1741018053920213292,'管理员',1740288148287545345,'2024-06-05 14:45:03',NULL,NULL,NULL,1),(1798244666230906882,1741390915314896897,1741018265053558032,'管理员',1740288148287545345,'2024-06-05 14:45:13',NULL,NULL,NULL,1),(1798244666247684097,1741390915314896897,1741018053920913288,'管理员',1740288148287545345,'2024-06-05 14:45:13',NULL,NULL,NULL,1),(1806217844929626114,1741390832464809986,1806217570009776129,'管理员',1740288148287545345,'2024-06-27 14:47:47',NULL,NULL,NULL,0),(1806217844988346370,1741390832464809986,1806217435271954434,'管理员',1740288148287545345,'2024-06-27 14:47:47',NULL,NULL,NULL,0),(1806217845009317889,1741390832464809986,1806217499063123970,'管理员',1740288148287545345,'2024-06-27 14:47:47',NULL,NULL,NULL,1),(1806217845030289409,1741390832464809986,1806217647818309634,'管理员',1740288148287545345,'2024-06-27 14:47:47',NULL,NULL,NULL,0),(1806672679600680961,1741390915314896897,1741018053920913287,'管理员',1740288148287545345,'2024-06-28 20:55:08',NULL,NULL,NULL,1),(1806673183776980994,1741390915314896897,1741018053420913285,'管理员',1740288148287545345,'2024-06-28 20:57:08',NULL,NULL,NULL,1),(1806673229067075586,1741390832464809986,1806217499063123970,'管理员',1740288148287545345,'2024-06-28 20:57:19',NULL,NULL,NULL,0),(1806678929575006209,1741390915314896897,1741018013920913291,'管理员',1740288148287545345,'2024-06-28 21:19:58',NULL,NULL,NULL,0),(1806683465702199298,1741390915314896897,1782303333037305858,'管理员',1740288148287545345,'2024-06-28 21:37:59',NULL,NULL,NULL,1),(1806685940614287362,1741390915314896897,1741018053920913283,'管理员',1740288148287545345,'2024-06-28 21:47:50',NULL,NULL,NULL,1),(1806686556988231681,1741390915314896897,1741018053920913284,'管理员',1740288148287545345,'2024-06-28 21:50:16',NULL,NULL,NULL,0),(1806686557021786113,1741390915314896897,1782303333037305858,'管理员',1740288148287545345,'2024-06-28 21:50:16',NULL,NULL,NULL,1),(1806686557055340546,1741390915314896897,1741018053924913282,'管理员',1740288148287545345,'2024-06-28 21:50:16',NULL,NULL,NULL,0),(1806686557076312066,1741390915314896897,1741018053920913283,'管理员',1740288148287545345,'2024-06-28 21:50:16',NULL,NULL,NULL,0),(1806686557101477890,1741390915314896897,1741018265053858032,'管理员',1740288148287545345,'2024-06-28 21:50:16',NULL,NULL,NULL,1),(1806688538901729281,1741390915314896897,1741018053920913282,'管理员',1740288148287545345,'2024-06-28 21:58:09',NULL,NULL,NULL,0),(1806688788303433730,1741390915314896897,1741018053920913292,'管理员',1740288148287545345,'2024-06-28 21:59:08',NULL,NULL,NULL,0),(1806688788336988162,1741390915314896897,1741018209721801971,'管理员',1740288148287545345,'2024-06-28 21:59:08',NULL,NULL,NULL,1),(1806713588505759745,1741390832464809986,1741018053920913282,'管理员',1740288148287545345,'2024-06-28 23:37:41',NULL,NULL,NULL,0),(1806713631224745986,1741390832464809986,1782303333037305858,'管理员',1740288148287545345,'2024-06-28 23:37:51',NULL,NULL,NULL,0),(1806713631245717505,1741390832464809986,1741018053920913284,'管理员',1740288148287545345,'2024-06-28 23:37:51',NULL,NULL,NULL,0),(1806713631262494721,1741390832464809986,1741018053920913283,'管理员',1740288148287545345,'2024-06-28 23:37:51',NULL,NULL,NULL,0),(1807681982369394689,1741390832464809986,1807679147762331650,'管理员',1740288148287545345,'2024-07-01 15:45:44',NULL,NULL,NULL,1),(1807681982394560513,1741390832464809986,1807679874199007234,'管理员',1740288148287545345,'2024-07-01 15:45:44',NULL,NULL,NULL,0),(1807681982423920641,1741390832464809986,1807679322329264130,'管理员',1740288148287545345,'2024-07-01 15:45:44',NULL,NULL,NULL,0),(1807681982444892161,1741390832464809986,1807678994527629314,'管理员',1740288148287545345,'2024-07-01 15:45:44',NULL,NULL,NULL,1),(1807681982465863682,1741390832464809986,1807679237059063809,'管理员',1740288148287545345,'2024-07-01 15:45:44',NULL,NULL,NULL,0),(1807682873306673153,1741390832464809986,1807682691185799169,'管理员',1740288148287545345,'2024-07-01 15:49:17',NULL,NULL,NULL,0),(1807682873327644674,1741390832464809986,1807682767815733249,'管理员',1740288148287545345,'2024-07-01 15:49:17',NULL,NULL,NULL,0),(1807682873348616193,1741390832464809986,1807682833620168706,'管理员',1740288148287545345,'2024-07-01 15:49:17',NULL,NULL,NULL,0),(1807682873357004802,1741390832464809986,1807682572201783298,'管理员',1740288148287545345,'2024-07-01 15:49:17',NULL,NULL,NULL,0),(1811276075091640322,1741390832464809986,1811276017843585026,'管理员',1740288148287545345,'2024-07-11 13:47:23',NULL,NULL,NULL,0),(1811276075112611842,1741390832464809986,1807678994527629314,'管理员',1740288148287545345,'2024-07-11 13:47:23',NULL,NULL,NULL,0),(1811276075125194753,1741390832464809986,1811275866294992898,'管理员',1740288148287545345,'2024-07-11 13:47:23',NULL,NULL,NULL,0),(1811276075141971969,1741390832464809986,1811275731649445889,'管理员',1740288148287545345,'2024-07-11 13:47:23',NULL,NULL,NULL,0),(1811276075150360578,1741390832464809986,1807679147762331650,'管理员',1740288148287545345,'2024-07-11 13:47:23',NULL,NULL,NULL,0),(1811276075158749185,1741390832464809986,1811275923626934274,'管理员',1740288148287545345,'2024-07-11 13:47:23',NULL,NULL,NULL,0),(1811276075171332098,1741390832464809986,1811275664121151490,'管理员',1740288148287545345,'2024-07-11 13:47:23',NULL,NULL,NULL,0),(1811276209129013249,1741390915314896897,1784175362741051394,'管理员',1740288148287545345,'2024-07-11 13:47:55',NULL,NULL,NULL,0),(1815226642809761793,1741390832464809986,1815226590536151041,'管理员',1740288148287545345,'2024-07-22 11:25:32',NULL,NULL,NULL,0),(1829426665465188354,1741390832464809986,1829424333151248385,'管理员',1740288148287545345,'2024-08-30 15:51:21',NULL,NULL,NULL,0),(1829426665486159873,1741390832464809986,1829426267987775490,'管理员',1740288148287545345,'2024-08-30 15:51:21',NULL,NULL,NULL,0),(1829426665511325697,1741390832464809986,1829424580808122369,'管理员',1740288148287545345,'2024-08-30 15:51:21',NULL,NULL,NULL,0),(1829708670878863361,1741390832464809986,1829708626939334657,'管理员',1740288148287545345,'2024-08-31 10:31:56',NULL,NULL,NULL,0),(1829708670891446273,1741390832464809986,1829708488179175426,'管理员',1740288148287545345,'2024-08-31 10:31:56',NULL,NULL,NULL,0),(1829708670904029185,1741390832464809986,1829708293911597057,'管理员',1740288148287545345,'2024-08-31 10:31:56',NULL,NULL,NULL,0),(1829708670920806401,1741390832464809986,1829708415949066241,'管理员',1740288148287545345,'2024-08-31 10:31:56',NULL,NULL,NULL,0),(1830847328281374722,1741390832464809986,1830846777963524097,'管理员',1740288148287545345,'2024-09-03 13:56:33',NULL,NULL,NULL,1),(1830847328289763330,1741390832464809986,1830846565668827137,'管理员',1740288148287545345,'2024-09-03 13:56:33',NULL,NULL,NULL,0),(1830856331099070465,1741390832464809986,1830856070821535745,'管理员',1740288148287545345,'2024-09-03 14:32:20',NULL,NULL,NULL,0),(1830881436361527297,1741390832464809986,1830881358318112769,'管理员',1740288148287545345,'2024-09-03 16:12:05',NULL,NULL,NULL,1),(1855987112695750658,1741390832464809986,1855986717491650562,'管理员',1740288148287545345,'2024-11-11 22:53:05',NULL,NULL,NULL,0),(1855987112708333570,1741390832464809986,1855986820122075138,'管理员',1740288148287545345,'2024-11-11 22:53:05',NULL,NULL,NULL,0),(1855987112716722177,1741390832464809986,1855986910387691522,'管理员',1740288148287545345,'2024-11-11 22:53:05',NULL,NULL,NULL,0),(1855987112729305090,1741390832464809986,1855986967639941122,'管理员',1740288148287545345,'2024-11-11 22:53:05',NULL,NULL,NULL,0),(1859143687698608129,1741390832464809986,1859143607910363138,'管理员',1740288148287545345,'2024-11-20 15:56:11',NULL,NULL,NULL,0),(1859168171247738881,1741390832464809986,1859167581289521154,'管理员',1740288148287545345,'2024-11-20 17:33:28',NULL,NULL,NULL,0),(1861262470689054722,1741390832464809986,1861261635963838466,'管理员',1740288148287545345,'2024-11-26 12:15:28',NULL,NULL,NULL,0),(1861413091014504450,1741390832464809986,1861412801834020866,'管理员',1740288148287545345,'2024-11-26 22:13:59',NULL,NULL,NULL,0),(1929843632599252993,1741390832464809986,1908789924844216321,'管理员',1740288148287545345,'2025-06-03 18:12:31',NULL,NULL,NULL,0),(1929843632641196033,1741390832464809986,1925800765334433794,'管理员',1740288148287545345,'2025-06-03 18:12:31',NULL,NULL,NULL,0),(1929843632666361858,1741390832464809986,1925800104492478465,'管理员',1740288148287545345,'2025-06-03 18:12:31',NULL,NULL,NULL,0),(1929843632678944770,1741390832464809986,1925800304594333697,'管理员',1740288148287545345,'2025-06-03 18:12:31',NULL,NULL,NULL,0),(1929843632687333377,1741390832464809986,1925800168141041665,'管理员',1740288148287545345,'2025-06-03 18:12:31',NULL,NULL,NULL,0),(1929843632712499202,1741390832464809986,1908790085196652545,'管理员',1740288148287545345,'2025-06-03 18:12:31',NULL,NULL,NULL,0),(1929843632729276417,1741390832464809986,1925552213727346689,'管理员',1740288148287545345,'2025-06-03 18:12:31',NULL,NULL,NULL,0),(1949758838869254146,1741390832464809986,1949758442331365377,'管理员',1740288148287545345,'2025-07-28 17:08:27',NULL,NULL,NULL,0),(1950473155749662722,1741390832464809986,1950473123310915586,'管理员',1740288148287545345,'2025-07-30 16:26:53',NULL,NULL,NULL,0),(1950566703383752705,1741390832464809986,1950566659058348033,'管理员',1740288148287545345,'2025-07-30 22:38:37',NULL,NULL,NULL,0),(1951120806090407937,1741390832464809986,1951120658480267265,'管理员',1740288148287545345,'2025-08-01 11:20:25',NULL,NULL,NULL,0),(1951120806115573762,1741390832464809986,1951119394832949250,'管理员',1740288148287545345,'2025-08-01 11:20:25',NULL,NULL,NULL,0),(1951120806123962369,1741390832464809986,1951119540706648066,'管理员',1740288148287545345,'2025-08-01 11:20:25',NULL,NULL,NULL,0),(1951120806132350978,1741390832464809986,1951119176439734274,'管理员',1740288148287545345,'2025-08-01 11:20:25',NULL,NULL,NULL,0),(1951120806132350979,1741390832464809986,1951118841763635201,'管理员',1740288148287545345,'2025-08-01 11:20:25',NULL,NULL,NULL,0),(1951120806136545281,1741390832464809986,1951118977176739841,'管理员',1740288148287545345,'2025-08-01 11:20:25',NULL,NULL,NULL,0),(1951120806140739585,1741390832464809986,1951119650249285633,'管理员',1740288148287545345,'2025-08-01 11:20:25',NULL,NULL,NULL,0),(1951126913982689281,1741390832464809986,1951126285373960193,'管理员',1740288148287545345,'2025-08-01 11:44:41',NULL,NULL,NULL,0),(1951126914007855105,1741390832464809986,1951126585719681025,'管理员',1740288148287545345,'2025-08-01 11:44:41',NULL,NULL,NULL,0),(1951126914016243714,1741390832464809986,1951126436519899137,'管理员',1740288148287545345,'2025-08-01 11:44:41',NULL,NULL,NULL,0),(1951470458283278337,1741390832464809986,1951470286513946626,'管理员',1740288148287545345,'2025-08-02 10:29:48',NULL,NULL,NULL,0),(1951470458300055554,1741390832464809986,1951470123087085569,'管理员',1740288148287545345,'2025-08-02 10:29:48',NULL,NULL,NULL,0),(1951470458304249858,1741390832464809986,1951470395880423426,'管理员',1740288148287545345,'2025-08-02 10:29:48',NULL,NULL,NULL,0),(1955916831340060673,1741390832464809986,1955916766756167682,'管理员',1740288148287545345,'2025-08-14 16:58:06',NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `user_name` varchar(40) NOT NULL COMMENT '用户名称',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `nick_name` varchar(20) DEFAULT NULL COMMENT '昵称',
  `real_name` varchar(20) NOT NULL COMMENT '真实姓名',
  `avatar` varchar(200) DEFAULT NULL COMMENT '头像',
  `email` varchar(45) NOT NULL COMMENT '邮箱',
  `phone` varchar(45) DEFAULT NULL COMMENT '手机',
  `gender` varchar(2) DEFAULT '0' COMMENT '性别 0保密 1男 2女',
  `create_user` varchar(40) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(40) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `salt` varchar(6) DEFAULT NULL COMMENT 'MD5的盐值',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `update_password_time` datetime DEFAULT NULL COMMENT '修改密码时间',
  `status` varchar(2) DEFAULT '1' COMMENT '是否启用(0:禁用,1:启用)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` (`id`, `user_name`, `password`, `nick_name`, `real_name`, `avatar`, `email`, `phone`, `gender`, `create_user`, `create_user_id`, `create_time`, `update_user`, `update_user_id`, `update_time`, `salt`, `last_login_time`, `update_password_time`, `status`, `is_deleted`) VALUES (1740288148287545345,'admin','cf0fbe2e8676d16e13e7b7d6e5f1eaf9f3c8e773db729c753e4803b3d395529b','管理员','管理员','http://dummyimage.com/100x100','t.ujvc2kyn@qq.com','19885041727','1','管理员',0,'2023-12-28 16:08:02','管理员',1740288148287545345,'2025-08-15 14:32:37','VECaJx','2025-08-15 14:32:37','2025-07-31 10:33:51','1',0),(1740288148287545346,'test','acd9a0d21631fc6b477780fb03bcdde481fcfe72d9697ed104d7dddd46df2152','测试账户','测试账户','https://i.pravatar.cc/100','m.qck@qq.com','13888888881','1','管理员',1740288148287545345,'2023-12-28 16:26:48','管理员',1740288148287545345,'2024-11-08 15:52:55','vnoZmL','2024-06-28 22:16:41',NULL,'1',0),(1780505023092850690,'demo','b5cd08ccac0081d04a1f5ce2593d49918aae51040fce0a3ece1bff9a069f47e7','示例','测试账户','https://i.pravatar.cc/100','test@qq.com','13888888888','0','管理员',1740288148287545345,'2024-04-17 15:54:12','管理员',1740288148287545345,'2024-07-22 12:19:55','nrSEQF',NULL,'2024-07-22 12:19:55','1',0),(1816767622867206145,'fdsa','5e89d3deb9432de43765c1939a721699575599a2aea887924d3962b2d37d3127','dasf','sadf','https://i.pravatar.cc/100','asdf@qq.com','13265444110','0','管理员',1740288148287545345,'2024-07-26 17:28:50','管理员',1740288148287545345,'2024-11-08 15:54:06','fkFAkW',NULL,NULL,'1',1),(1816768633111474178,'bbbfdas答复','cd7336956be74978ebe48b22d2b4e2ad9a8206f47acd6353257fef50266be28f','','123123',NULL,'5@qq.com','13312341234','0','管理员',1740288148287545345,'2024-07-26 17:32:51','管理员',1740288148287545345,'2024-11-08 15:54:06','RJBeNT',NULL,NULL,'1',1);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_org`
--

DROP TABLE IF EXISTS `sys_user_org`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_org` (
  `id` bigint NOT NULL COMMENT '主键',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `org_id` bigint DEFAULT NULL COMMENT '组织/部门/子部门ID',
  `principal` varchar(2) DEFAULT '0' COMMENT '组织/部门/子部门负责人(0:否,1:是)',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`),
  KEY `idx_user_org` (`user_id`,`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户组织/部门/子部门管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_org`
--

LOCK TABLES `sys_user_org` WRITE;
/*!40000 ALTER TABLE `sys_user_org` DISABLE KEYS */;
INSERT INTO `sys_user_org` (`id`, `user_id`, `org_id`, `principal`, `create_user`, `create_user_id`, `create_time`, `update_user`, `update_user_id`, `update_time`, `is_deleted`) VALUES (1815210347691278337,1780505023092850690,1813126899820523522,'1','管理员',1740288148287545345,'2024-07-22 10:20:47',NULL,NULL,NULL,1),(1815210347708055554,1780505023092850690,1813126973426364417,'0','管理员',1740288148287545345,'2024-07-22 10:20:47',NULL,NULL,NULL,1),(1815210402020098050,1780505023092850690,1813126899820523522,'0','管理员',1740288148287545345,'2024-07-22 10:20:59',NULL,NULL,NULL,1),(1815210402036875266,1780505023092850690,1813127185335185409,'0','管理员',1740288148287545345,'2024-07-22 10:20:59',NULL,NULL,NULL,1),(1815210402045263873,1780505023092850690,1813126973426364417,'1','管理员',1740288148287545345,'2024-07-22 10:20:59',NULL,NULL,NULL,1),(1815210402057846786,1780505023092850690,1813127063759089666,'1','管理员',1740288148287545345,'2024-07-22 10:20:59',NULL,NULL,NULL,1),(1815212567014965250,1780505023092850690,1813126899820523522,'0','管理员',1740288148287545345,'2024-07-22 10:29:36',NULL,NULL,NULL,1),(1815212567027548161,1780505023092850690,1813127185335185409,'0','管理��',1740288148287545345,'2024-07-22 10:29:36',NULL,NULL,NULL,1),(1815212567040131074,1780505023092850690,1813126973426364417,'1','管理员',1740288148287545345,'2024-07-22 10:29:36',NULL,NULL,NULL,1),(1815212567048519682,1780505023092850690,1813127063759089666,'1','管理员',1740288148287545345,'2024-07-22 10:29:36',NULL,NULL,NULL,1),(1815212705095647233,1780505023092850690,1813127185335185409,'0','管理员',1740288148287545345,'2024-07-22 10:30:09',NULL,NULL,NULL,0),(1815212705108230145,1780505023092850690,1813127063759089666,'1','管理员',1740288148287545345,'2024-07-22 10:30:09',NULL,NULL,NULL,1),(1815238477758824450,1780505023092850690,1813110675992604674,'1','管理员',1740288148287545345,'2024-07-22 12:12:33',NULL,NULL,NULL,1),(1815238652921348097,1780505023092850690,1813126899820523522,'0','管理员',1740288148287545345,'2024-07-22 12:13:15',NULL,NULL,NULL,1),(1815238652933931009,1780505023092850690,1813126973426364417,'0','管理员',1740288148287545345,'2024-07-22 12:13:15',NULL,NULL,NULL,1),(1815239995954278401,1780505023092850690,1813126899820523522,'0','管理员',1740288148287545345,'2024-07-22 12:18:35',NULL,NULL,NULL,1),(1815239995983638530,1780505023092850690,1813126973426364417,'1','管理员',1740288148287545345,'2024-07-22 12:18:35',NULL,NULL,NULL,1),(1815274038738608129,1780505023092850690,1813126899820523522,'0','管理员',1740288148287545345,'2024-07-22 14:33:52',NULL,NULL,NULL,0),(1815274038755385346,1780505023092850690,1813126973426364417,'1','管理员',1740288148287545345,'2024-07-22 14:33:52',NULL,NULL,NULL,0),(1853701694570819585,1740288148287545345,1813126899820523522,'1','管理员',1740288148287545345,'2024-11-05 15:31:39',NULL,NULL,NULL,1),(1853711097294417921,1740288148287545346,1813110675992604674,'0','管理员',1740288148287545345,'2024-11-05 16:09:01',NULL,NULL,NULL,1),(1853711097323778049,1740288148287545346,1813147751387525121,'0','管理员',1740288148287545345,'2024-11-05 16:09:01',NULL,NULL,NULL,0),(1853711097332166658,1740288148287545346,1813127063759089666,'0','管理员',1740288148287545345,'2024-11-05 16:09:01',NULL,NULL,NULL,1),(1949449670710972418,1740288148287545345,1813126899820523522,'1','管理员',1740288148287545345,'2025-07-27 20:39:55',NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `sys_user_org` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_position`
--

DROP TABLE IF EXISTS `sys_user_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_position` (
  `id` bigint NOT NULL COMMENT '主键',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `position_id` bigint DEFAULT NULL COMMENT '岗位ID',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户岗位管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_position`
--

LOCK TABLES `sys_user_position` WRITE;
/*!40000 ALTER TABLE `sys_user_position` DISABLE KEYS */;
INSERT INTO `sys_user_position` (`id`, `user_id`, `position_id`, `create_user`, `create_user_id`, `create_time`, `update_user`, `update_user_id`, `update_time`, `is_deleted`) VALUES (1815210347544477698,1780505023092850690,1806241301570547713,'管理员',1740288148287545345,'2024-07-22 10:20:46',NULL,NULL,NULL,1),(1815211643898986498,1780505023092850690,1806242735305289729,'管理员',1740288148287545345,'2024-07-22 10:25:56',NULL,NULL,NULL,1),(1815211643907375105,1780505023092850690,1806241301570547713,'管理员',1740288148287545345,'2024-07-22 10:25:56',NULL,NULL,NULL,1),(1815211643911569409,1780505023092850690,1806242759749693442,'管理员',1740288148287545345,'2024-07-22 10:25:56',NULL,NULL,NULL,1),(1815212480947847170,1780505023092850690,1806241301570547713,'管理员',1740288148287545345,'2024-07-22 10:29:15',NULL,NULL,NULL,1),(1815212480964624385,1780505023092850690,1806242713427800066,'管理员',1740288148287545345,'2024-07-22 10:29:15',NULL,NULL,NULL,1),(1815212498391957506,1780505023092850690,1806242759749693442,'管理员',1740288148287545345,'2024-07-22 10:29:19',NULL,NULL,NULL,1),(1815212522169466881,1780505023092850690,1806242824534913026,'管理员',1740288148287545345,'2024-07-22 10:29:25',NULL,NULL,NULL,1),(1815274038520504322,1780505023092850690,1806243997388140546,'管理员',1740288148287545345,'2024-07-22 14:33:52',NULL,NULL,NULL,0),(1815274038583418882,1780505023092850690,1806244021291479042,'管理员',1740288148287545345,'2024-07-22 14:33:52',NULL,NULL,NULL,0),(1844024688337887233,1780505023092850690,1806243973979729922,'管理员',1740288148287545345,'2024-10-09 22:38:41',NULL,NULL,NULL,0),(1949449670648057858,1740288148287545345,1806240801177497602,'管理员',1740288148287545345,'2025-07-27 20:39:55',NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `sys_user_position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `create_user` varchar(64) NOT NULL COMMENT '创建用户',
  `create_user_id` bigint NOT NULL COMMENT '创建用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改用户',
  `update_user_id` bigint DEFAULT NULL COMMENT '修改用户ID',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `status` varchar(2) DEFAULT '1' COMMENT '是否启用(0:禁用,1:启用)',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT '是否删除(0:否,1:是)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户角色管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `create_user`, `create_user_id`, `create_time`, `update_user`, `update_user_id`, `update_time`, `status`, `is_deleted`) VALUES (1750772104422334466,1740288148287545345,1741390832464809986,'管理员',1740288148287545345,'2024-01-26 14:46:12',NULL,NULL,NULL,'1',0),(1776904883046944769,1740288148287545346,1741390915314896897,'管理员',1740288148287545345,'2024-04-07 17:28:32',NULL,NULL,NULL,'1',1),(1776905102690062337,1740288148287545346,1741390915314896897,'管理员',1740288148287545345,'2024-04-07 17:29:24',NULL,NULL,NULL,'1',1),(1776905102698450945,1740288148287545346,1741390832464809986,'管理员',1740288148287545345,'2024-04-07 17:29:24',NULL,NULL,NULL,'1',1),(1776905161087356930,1740288148287545346,1741390915314896897,'管理员',1740288148287545345,'2024-04-07 17:29:38',NULL,NULL,NULL,'1',0),(1780505023277400065,1780505023092850690,1741390915314896897,'管理员',1740288148287545345,'2024-04-17 15:54:12',NULL,NULL,NULL,'1',1),(1815211052061720577,1780505023092850690,1741390915314896897,'管理员',1740288148287545345,'2024-07-22 10:23:34',NULL,NULL,NULL,'1',1),(1815211052086886402,1780505023092850690,1741390832464809986,'管理员',1740288148287545345,'2024-07-22 10:23:34',NULL,NULL,NULL,'1',1),(1815211107111960577,1780505023092850690,1741390915314896897,'管理员',1740288148287545345,'2024-07-22 10:23:48',NULL,NULL,NULL,'1',1),(1815215081818959874,1780505023092850690,1741390832464809986,'管理员',1740288148287545345,'2024-07-22 10:39:35',NULL,NULL,NULL,'1',1),(1815215123720056834,1780505023092850690,1741390915314896897,'管理员',1740288148287545345,'2024-07-22 10:39:45',NULL,NULL,NULL,'1',0);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-15 15:35:36
