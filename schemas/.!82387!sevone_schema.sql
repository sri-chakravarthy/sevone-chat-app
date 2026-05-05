/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.6.24-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: net
-- ------------------------------------------------------
-- Server version	10.6.24-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `SDB_destination`
--

DROP TABLE IF EXISTS `SDB_destination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_destination` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id of the destination',
  `name` varchar(255) NOT NULL COMMENT 'The name of the destination',
  `topic` varchar(255) NOT NULL COMMENT 'The topic of the destination',
  `is_live` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'The flag to send live data or historical data',
  `destination_type` enum('KAFKA','PULSAR') DEFAULT NULL COMMENT 'The destination type',
  `customize_settings` text DEFAULT NULL COMMENT 'A set of key=value pair separated by comma.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_type` (`name`,`destination_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the basic information for destinations';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_destination`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_destination` WRITE;
/*!40000 ALTER TABLE `SDB_destination` DISABLE KEYS */;
/*!40000 ALTER TABLE `SDB_destination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDB_destination_kafka`
--

DROP TABLE IF EXISTS `SDB_destination_kafka`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_destination_kafka` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id of the destination',
  `destination_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The destination id for the kafka seting. foreignKey: net.SDB_destination.id',
  `kafka_acks` bigint(20) NOT NULL DEFAULT -1 COMMENT 'ACKs setting for kafka',
  `kafka_retries` bigint(20) NOT NULL DEFAULT -1 COMMENT 'Retires setting for kafka',
  `kafka_lingers` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The linger time for kafka',
  `kafka_batchsizes` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The batch size for kafka',
  `kafka_timeout` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The timeout setting for kafka',
  `kafka_max_request` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The max in flight requests per connection for kafka',
  `sdp_kafka_version` varchar(12) NOT NULL DEFAULT 'auto' COMMENT 'The max in flight requests per connection for kafka',
  PRIMARY KEY (`id`),
  KEY `destination_id` (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores extra param for Kafka destination';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_destination_kafka`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_destination_kafka` WRITE;
/*!40000 ALTER TABLE `SDB_destination_kafka` DISABLE KEYS */;
/*!40000 ALTER TABLE `SDB_destination_kafka` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDB_destination_kafka_bootstrap_servers`
--

DROP TABLE IF EXISTS `SDB_destination_kafka_bootstrap_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_destination_kafka_bootstrap_servers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id of the kafka bootstrap',
  `destination_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The destination id for the kafka destination. foreignKey: net.SDB_destination.id',
  `host` varchar(255) NOT NULL COMMENT 'The host of the server',
  `port` smallint(5) unsigned NOT NULL COMMENT 'The port of the server',
  PRIMARY KEY (`id`),
  UNIQUE KEY `kafka_server_and_port` (`destination_id`,`host`,`port`),
  KEY `destination_id` (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the bootstrap server information for kafka.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_destination_kafka_bootstrap_servers`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_destination_kafka_bootstrap_servers` WRITE;
/*!40000 ALTER TABLE `SDB_destination_kafka_bootstrap_servers` DISABLE KEYS */;
/*!40000 ALTER TABLE `SDB_destination_kafka_bootstrap_servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDB_destination_pulsar`
--

DROP TABLE IF EXISTS `SDB_destination_pulsar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_destination_pulsar` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id of the destination',
  `destination_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The destination id for the pulsar seting. foreignKey: net.SDB_destination.id',
  `tenant` varchar(255) NOT NULL COMMENT 'Tenant setting for pulsar',
  `namespace` varchar(255) NOT NULL COMMENT 'Namespace setting for pulsar',
  `topic_type` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'The topic type setting for pulsar',
  `compression_type` enum('ZLIB','LZ4','ZSTD','SNAPPY') NOT NULL COMMENT 'The compression type for pulsar',
  `use_tls` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'The flag for using TLS for pulsar',
  `tls_secure_connection` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'The flag for  TLS allow secure connection for pulsar',
  `pulsar_batching_max_messages` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The max batch number messages for pulsar',
  `pulsar_batching_enabled` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'The flag for batching message for pulsar',
  `pulsar_block_if_queue_full` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'The flag to block if quere full for pulsar',
  `pulsar_send_timeout` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The send timeout setting for pulsar',
  PRIMARY KEY (`id`),
  KEY `destination_id` (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores extra param for pulsar destination';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_destination_pulsar`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_destination_pulsar` WRITE;
/*!40000 ALTER TABLE `SDB_destination_pulsar` DISABLE KEYS */;
/*!40000 ALTER TABLE `SDB_destination_pulsar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDB_destination_pulsar_client`
--

DROP TABLE IF EXISTS `SDB_destination_pulsar_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_destination_pulsar_client` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id of the client of pulsar destination',
  `destination_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The destination id for the pulsar destination. foreignKey: net.SDB_destination.id',
  `host` varchar(255) NOT NULL COMMENT 'The host of the server',
  `port` smallint(5) unsigned NOT NULL COMMENT 'The port of the server',
  `protocol` enum('pulsar','pulsar+ssl') DEFAULT NULL COMMENT 'The protocol of the server',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pulsar_server_and_port` (`destination_id`,`host`,`port`,`protocol`),
  KEY `destination_id` (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the client information for pulsar.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_destination_pulsar_client`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_destination_pulsar_client` WRITE;
/*!40000 ALTER TABLE `SDB_destination_pulsar_client` DISABLE KEYS */;
/*!40000 ALTER TABLE `SDB_destination_pulsar_client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDB_filter`
--

DROP TABLE IF EXISTS `SDB_filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_filter` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id of the filter',
  `name` varchar(255) NOT NULL COMMENT 'The name of the filter',
  `status` enum('INCLUDE','EXCLUDE') NOT NULL COMMENT 'Status of the filter, to include or exclude',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the various SDB filters.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_filter`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_filter` WRITE;
/*!40000 ALTER TABLE `SDB_filter` DISABLE KEYS */;
INSERT INTO `SDB_filter` VALUES (1,'Everything','INCLUDE');
/*!40000 ALTER TABLE `SDB_filter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDB_filter_rules`
--

DROP TABLE IF EXISTS `SDB_filter_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_filter_rules` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id of the rule',
  `filter_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The filter id this rule belongs to. foreignKey: net.SDB_filter.id',
  `device_group_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The device group id used for the filter. foreignKey: net.devicetags.id',
  `object_group_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The object group id used for the filter. foreignKey: net.objectgroupinfo.id',
  `plugin_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The Plugin id used for the filter. foreignKey: net.plugins.id',
  `device_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The device id used for the filter. foreignKey: net.deviceinfo.id',
  `object_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The object id used for the filter. foreignKey: local.device_object.id',
  PRIMARY KEY (`id`),
  KEY `filter_id` (`filter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the filter rules for SDB';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_filter_rules`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_filter_rules` WRITE;
/*!40000 ALTER TABLE `SDB_filter_rules` DISABLE KEYS */;
INSERT INTO `SDB_filter_rules` VALUES (1,1,2,-1,-1,-1,-1);
/*!40000 ALTER TABLE `SDB_filter_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDB_output_schema`
--

DROP TABLE IF EXISTS `SDB_output_schema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_output_schema` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id for the output shcema config profile',
  `name` varchar(255) NOT NULL COMMENT 'The name for the output schema config profile',
  `output_encoding` enum('AVRO','JSON') NOT NULL COMMENT 'AVRO or JSON',
  `override_cluster_name` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag to use customize cluster name ',
  `custom_cluster_name` varchar(255) DEFAULT NULL COMMENT 'cluster name for output cluster name.',
  `devId` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if devID will be used in the output file schema',
  `devName` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if devName will be used in the output file schema',
  `devIp` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if devIp will be used in the output file schema',
  `objId` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if objId will be used in the output file schema',
  `objName` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if objName will be used in the output file schema',
  `objDesc` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if objDesc will be used in the output file schema',
  `peerId` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if peerId will be used in the output file schema',
  `peerIp` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if peerIp will be used in the output file schema',
  `pluginId` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if pluginId will be used in the output file schema',
  `pluginName` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if pluginName will be used in the output file schema',
  `indicatorId` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if indicatorId will be used in the output file schema',
  `indicatorName` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if indicatorName will be used in the output file schema',
  `objType` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if objType will be used in the output file schema',
  `clusterName` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if clusterName will be used in the output file schema',
  `format` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if format will be used in the output file schema',
  `value` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if value will be used in the output file schema',
  `time` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if will be used in the output file schema',
  `units` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag if unitswill be used in the output file schema',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the SDB output configuation profiles';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_output_schema`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_output_schema` WRITE;
/*!40000 ALTER TABLE `SDB_output_schema` DISABLE KEYS */;
INSERT INTO `SDB_output_schema` VALUES (1,'Default','AVRO',0,NULL,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
/*!40000 ALTER TABLE `SDB_output_schema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDB_publishers`
--

DROP TABLE IF EXISTS `SDB_publishers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_publishers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id of the publisher',
  `name` varchar(255) NOT NULL COMMENT 'The name of the publisher',
  `description` text DEFAULT NULL COMMENT 'The description of the publisher',
  `output_schema_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The output schema for the publisher. foreignKey: net.SDB_output_schema.id',
  `system_config_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The system config for the publisher. foreignKey: net.SDB_sys_config.id',
  `publisher_type` enum('KAFKA','PULSAR') DEFAULT NULL COMMENT 'The publisher type of the publisher',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the basic information for publishers';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_publishers`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_publishers` WRITE;
/*!40000 ALTER TABLE `SDB_publishers` DISABLE KEYS */;
/*!40000 ALTER TABLE `SDB_publishers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDB_publishers_destination_map`
--

DROP TABLE IF EXISTS `SDB_publishers_destination_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_publishers_destination_map` (
  `publisher_id` bigint(20) NOT NULL COMMENT 'publisher id. foreignKey: net.SDB_publishers.id',
  `destination_id` bigint(20) NOT NULL COMMENT 'The destination id associated with the publisher. foreignKey: net.SDB_destination.id',
  PRIMARY KEY (`publisher_id`,`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the publisher- destination map in the system.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_publishers_destination_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_publishers_destination_map` WRITE;
/*!40000 ALTER TABLE `SDB_publishers_destination_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `SDB_publishers_destination_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDB_publishers_filter_map`
--

DROP TABLE IF EXISTS `SDB_publishers_filter_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_publishers_filter_map` (
  `publisher_id` bigint(20) NOT NULL COMMENT 'publisher id. foreignKey: net.SDB_publishers.id',
  `filter_id` bigint(20) NOT NULL COMMENT 'The filter id associated with the publisher. foreignKey: net.SDB_filter.id',
  PRIMARY KEY (`publisher_id`,`filter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the publisher- filter map in the system.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_publishers_filter_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_publishers_filter_map` WRITE;
/*!40000 ALTER TABLE `SDB_publishers_filter_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `SDB_publishers_filter_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDB_sys_config`
--

DROP TABLE IF EXISTS `SDB_sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDB_sys_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id for the system config profile',
  `name` varchar(255) NOT NULL COMMENT 'The name for the system config profile',
  `metrics_log_interval` int(11) NOT NULL DEFAULT 300 COMMENT 'Metrics log interval for SDB',
  `http_enabled` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag for SDB status paging using http. ',
  `http_port` smallint(5) unsigned DEFAULT NULL COMMENT 'HTTP port for SDB status page.',
  `https_enabled` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Flag for SDB status paging using https',
  `https_port` smallint(5) unsigned DEFAULT NULL COMMENT 'HTTPs port for SDB status page.',
  `private_key_pwd` varchar(255) DEFAULT NULL COMMENT 'HTTPS private key password for SDB status page.',
  `keystore_pwd` varchar(255) DEFAULT NULL COMMENT 'HTTPS Keystore password for SDB status page.',
  `keystore_path` varchar(255) DEFAULT NULL COMMENT 'HTTPS Keystore path for SDB status page.',
  `server_cert` varchar(255) DEFAULT NULL,
  `server_key` varchar(255) DEFAULT NULL,
  `log_nth` int(11) NOT NULL DEFAULT 50000 COMMENT 'Log Nth exception for SDB',
  `jaeger_enabled` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flad if jaeger is enabled for SDB',
  `jaeger_sampler_type` enum('CONST','PROBABILISTIC','RATELIMITING','REMOTE') DEFAULT NULL COMMENT 'jaeger_sampler_type, either CONST,PROBABILISTIC,RATELIMITING or REMOTE''',
  `jaeger_sampler_param` double DEFAULT NULL COMMENT 'jaeger_sampler_param setting for SDB',
  `jaeger_service_name` varchar(255) DEFAULT NULL COMMENT 'jaeger_service_name setting for SDB',
  `jaeger_propagation` varchar(255) DEFAULT NULL COMMENT 'jaeger_propagation for SDB',
  `jaeger_agent_host` varchar(255) DEFAULT NULL COMMENT 'jaeger_agent_host settingfor SDB',
  `jaeger_port` smallint(5) unsigned DEFAULT NULL COMMENT 'jaeger_agent_host port for SDB',
  `key_fields` varchar(255) DEFAULT NULL COMMENT 'A list of fields name separated by :.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the SDB system configuation profiles';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDB_sys_config`
--
-- WHERE:  1 limit 10

LOCK TABLES `SDB_sys_config` WRITE;
/*!40000 ALTER TABLE `SDB_sys_config` DISABLE KEYS */;
INSERT INTO `SDB_sys_config` VALUES (1,'Default',300,1,8082,0,NULL,NULL,NULL,NULL,NULL,NULL,50000,0,NULL,NULL,NULL,NULL,NULL,NULL,'deviceId:objectId');
/*!40000 ALTER TABLE `SDB_sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_messages`
--

DROP TABLE IF EXISTS `admin_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_messages` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `severity` tinyint(3) unsigned NOT NULL COMMENT 'This is the severity of the item (0-8).',
  `message` text NOT NULL COMMENT 'This is the message to display.  For example, a Peer may be over capacity.',
  PRIMARY KEY (`id`),
  KEY `severity` (`severity`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the messages that will be presented to administrators when the log into the Web UI.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_messages`
--
-- WHERE:  1 limit 10

LOCK TABLES `admin_messages` WRITE;
/*!40000 ALTER TABLE `admin_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_messages_displaylog`
--

DROP TABLE IF EXISTS `admin_messages_displaylog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_messages_displaylog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uid` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the person that viewed the message foreignKey: access_control.user.uid',
  `displayed` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'This is the timestamp that the user viewed the messages',
  `acknowledged` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'This is the time stamp the user acked the messaged, 0 if they didn''t ack it.',
  `contents` text NOT NULL COMMENT 'This is a serialized version of the messages that were viewed',
  PRIMARY KEY (`id`),
  KEY `acknowledged` (`acknowledged`),
  KEY `displayed` (`displayed`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Records when admin messages were viewed and acknowledged by users and what user did that action.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_messages_displaylog`
--
-- WHERE:  1 limit 10

LOCK TABLES `admin_messages_displaylog` WRITE;
/*!40000 ALTER TABLE `admin_messages_displaylog` DISABLE KEYS */;
INSERT INTO `admin_messages_displaylog` VALUES (1,1,'2025-09-04 15:49:29','2025-09-04 15:49:31','a:1:{i:0;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:44:\"GUI users with default password: SevOneStats\";}}'),(2,1,'2025-09-04 18:27:04','2025-09-04 18:27:05','a:2:{i:0;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:57:\"Peer SevOne Appliance (127.0.0.1) is at 1263.08% capacity\";}i:1;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:44:\"GUI users with default password: SevOneStats\";}}'),(3,1,'2025-09-05 10:08:05','2025-09-05 10:08:08','a:2:{i:0;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:56:\"Peer SevOne Appliance (127.0.0.1) is at 1263.2% capacity\";}i:1;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:44:\"GUI users with default password: SevOneStats\";}}'),(4,1,'2025-09-05 15:29:27','2025-09-05 15:29:29','a:1:{i:0;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:44:\"GUI users with default password: SevOneStats\";}}'),(5,1,'2025-09-05 18:41:00','2025-09-05 18:41:02','a:1:{i:0;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:44:\"GUI users with default password: SevOneStats\";}}'),(6,1,'2025-09-09 13:42:00','2025-09-09 13:42:03','a:1:{i:0;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:44:\"GUI users with default password: SevOneStats\";}}'),(7,1,'2025-09-23 13:56:30','2025-09-23 13:56:32','a:1:{i:0;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:44:\"GUI users with default password: SevOneStats\";}}'),(8,1,'2025-10-06 10:21:43','2025-10-06 10:30:36','a:1:{i:0;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:44:\"GUI users with default password: SevOneStats\";}}'),(9,1,'2025-10-06 12:51:30','2025-10-06 12:51:36','a:1:{i:0;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:44:\"GUI users with default password: SevOneStats\";}}'),(10,1,'2025-10-07 10:37:19','2025-10-07 10:37:27','a:1:{i:0;O:8:\"stdClass\":2:{s:8:\"severity\";s:1:\"2\";s:7:\"message\";s:44:\"GUI users with default password: SevOneStats\";}}');
/*!40000 ALTER TABLE `admin_messages_displaylog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID of alert',
  `severity` int(11) DEFAULT -1 COMMENT 'The severity of the alert (0-8).',
  `closed` int(11) NOT NULL DEFAULT 0 COMMENT '1 if the alert is closed; 0 if it is still active.',
  `closed_key` int(11) DEFAULT 0 COMMENT 'This is a lovely by-product of storing both the open and closed alerts in one table.  This will be set to the ''id'' of the alert when it is closed.  This is part of the unique tuple for the alert, so that when an update to an alert comes in, it will come in with a ''closed_key'' of 0.',
  `origin` enum('system','trap','flow') NOT NULL COMMENT '''trap'' for it the alert was generated by an SNMP trap event; ''system'' otherwise.',
  `dev_id` int(11) DEFAULT -1 COMMENT ' foreignKey: net.deviceinfo.id',
  `plugin_name` varchar(45) DEFAULT NULL COMMENT 'For traps, this is the IP address of the sender.  For Threshold-driven alerts, this is is ''KANKEI_NAI'' (literally, ''does not matter'').  For HTTP polling generated alerts, this is ''HTTP''.',
  `object_id` int(11) DEFAULT -1 COMMENT 'ID of the object that this alert is for. foreignKey: local.device_object.id',
  `poll_id` int(11) DEFAULT -1 COMMENT 'This is the ID of the Trap Event that generated the alert, or -1.',
  `threshold_id` int(11) DEFAULT -1 COMMENT 'This is the ID of the threshold that generated the alert, or -1.',
  `start_time` int(11) DEFAULT 0 COMMENT 'This is the time that the alert was first triggered.',
  `end_time` int(11) DEFAULT 0 COMMENT 'This is the last known time that the alert was triggered.',
  `message` text DEFAULT NULL COMMENT 'The alert text.',
  `assigned_to` int(11) DEFAULT -1 COMMENT 'This is the user assigned to the alert, or -1 for ''unassigned''. foreignKey: access_control.user.uid',
  `comments` text DEFAULT NULL COMMENT 'Any arbitrary user-created comments for the alert.',
  `clear_message` text DEFAULT NULL COMMENT 'This is the message that was given when the alert was cleared.',
  `ackd_by` varchar(128) DEFAULT NULL COMMENT 'This is used by nothing good.  This used to be used to determine the user that acknowledged an alert, but... not so much anymore.',
  `number` int(11) DEFAULT 1 COMMENT 'This is the number of times that the alert was triggered.  The alert starts at 1 and increments every time another trigger happens.',
  `last_processed` int(11) DEFAULT 0 COMMENT 'This is the timestamp at which the alert mailer last looked at the alert (epoch).  This is used to determine if an alert needs to be sent or not.',
  `ignore_until` int(11) DEFAULT 0 COMMENT 'This is the timestamp at which the alert will become active again (epoch).  An ignored alert will not appear in the system.  A value of 0 here means that the alert is not ignored.',
  `ignore_uid` int(11) DEFAULT -1 COMMENT 'This is the ID of the user who ignored the alert.  If it is not ignored, then this is -1. foreignKey: access_control.user.uid',
  `ignore_comment` text DEFAULT NULL COMMENT 'This is the comment that was given when the alert was ignored.  This will justify that action.',
  `suppress_email` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'This indicates if the email is setup, the email will be sent or not. Mainly used for maintenance windows.',
  `is_maintenance_alert` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'This indicates that the alert occurred during a maintenance window.',
  `clear_time` int(11) DEFAULT 0 COMMENT 'This is the time that the alert was cleared.',
  PRIMARY KEY (`id`,`closed`),
  UNIQUE KEY `alert` (`origin`,`dev_id`,`plugin_name`,`object_id`,`poll_id`,`threshold_id`,`closed`,`closed_key`,`is_maintenance_alert`),
  KEY `dev_id` (`dev_id`),
  KEY `maintenance_alert_key` (`is_maintenance_alert`),
  KEY `severity` (`severity`),
  KEY `timerange` (`start_time`,`end_time`),
  KEY `timerangedesc` (`end_time`)
) ENGINE=InnoDB AUTO_INCREMENT=21359 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the open, closed, and ignored alerts.'
 PARTITION BY HASH (`closed`)
PARTITIONS 2;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts`
--
-- WHERE:  1 limit 10

LOCK TABLES `alerts` WRITE;
/*!40000 ALTER TABLE `alerts` DISABLE KEYS */;
INSERT INTO `alerts` VALUES (2418,5,0,0,'trap',281,'127.0.0.1',-1,3,-1,1772100422,1772461212,'Trap received from btjsonadapter.dev.fyre.ibm.com: IF-MIB::linkUp -- Bindings: IF-MIB::ifIndex.111 = 111, IF-MIB::ifAdminStatus.111 = 1, IF-MIB::ifOperStatus.111 = 1, SNMPv2-MIB::snmpTrapEnterprise.0 = .1.3.6.1.4.1.8072.3.2.10, SNMPv2-MIB::snmpTrapEnterprise = 0 -- An interface has come back up.',-1,'','','',28,0,0,-1,NULL,0,0,0),(2419,5,0,0,'trap',281,'127.0.0.1',-1,4,-1,1772115504,1772461212,'Trap received from btjsonadapter.dev.fyre.ibm.com: IF-MIB::linkDown -- Bindings: IF-MIB::ifIndex.110 = 110, IF-MIB::ifAdminStatus.110 = 2, IF-MIB::ifOperStatus.110 = 2, SNMPv2-MIB::snmpTrapEnterprise.0 = .1.3.6.1.4.1.8072.3.2.10, SNMPv2-MIB::snmpTrapEnterprise = 0 -- An interface has gone down.',-1,'','','',9,0,0,-1,NULL,0,0,0),(2420,4,0,0,'trap',281,'127.0.0.1',-1,7,-1,1772135679,1772398850,'Trap received from btjsonadapter.dev.fyre.ibm.com: SNMPv2-MIB::authenticationFailure -- Bindings: SNMPv2-MIB::snmpTrapEnterprise = 0 -- An authentication failure has occurred.',-1,'','','',32,0,0,-1,NULL,0,0,0),(8021,0,0,0,'system',281,'KANKEI_NAI',974784,-1,2647,1772468042,1772468222,'Threshold triggered -- btjsonadapter.dev.fyre.ibm.com\'s SevOne-selfmond\'s Selfmond: master slave active appliance: The value changed over 5.00 minutes',-1,'','','',2,0,0,-1,NULL,0,0,0),(9622,4,0,0,'trap',-1,'127.0.0.1',-1,7,-1,1772485142,1777027424,'Trap received from 127.0.0.1: SNMPv2-MIB::authenticationFailure -- Bindings: SNMPv2-MIB::snmpTrapEnterprise = 0 -- An authentication failure has occurred.',-1,'','','',217,0,0,-1,NULL,0,0,0),(9623,5,0,0,'trap',-1,'127.0.0.1',-1,3,-1,1772538086,1776786030,'Trap received from 127.0.0.1: IF-MIB::linkUp -- Bindings: IF-MIB::ifIndex.48 = 48, IF-MIB::ifAdminStatus.48 = 1, IF-MIB::ifOperStatus.48 = 1, SNMPv2-MIB::snmpTrapEnterprise.0 = .1.3.6.1.4.1.8072.3.2.10, SNMPv2-MIB::snmpTrapEnterprise = 0 -- An interface has come back up.',-1,'','','',169,0,0,-1,NULL,0,0,0),(9624,5,0,0,'trap',-1,'127.0.0.1',-1,4,-1,1772538556,1776776479,'Trap received from 127.0.0.1: IF-MIB::linkDown -- Bindings: IF-MIB::ifIndex.45 = 45, IF-MIB::ifAdminStatus.45 = 2, IF-MIB::ifOperStatus.45 = 2, SNMPv2-MIB::snmpTrapEnterprise.0 = .1.3.6.1.4.1.8072.3.2.10, SNMPv2-MIB::snmpTrapEnterprise = 0 -- An interface has gone down.',-1,'','','',13,0,0,-1,NULL,0,0,0),(9625,5,0,0,'trap',-1,'127.0.0.1',-1,5,-1,1772622706,1773245897,'Trap received from 127.0.0.1: SNMPv2-MIB::coldStart -- Bindings: SNMPv2-MIB::snmpTrapEnterprise = 0 -- The device was powered up.',-1,'','','',9,0,0,-1,NULL,0,0,0),(21347,3,0,0,'trap',-1,'DEFERRED',0,0,-1,1773850196,1773851221,'Some Random Alert Message 2/10/10',-1,'','','',12,0,0,-1,NULL,0,0,0),(21348,3,0,0,'trap',601,'DEFERRED',0,0,-1,1773851521,1776158736,'Some Random Alert Message 1/10/10',-1,'','','',7416,0,0,-1,NULL,0,0,0);
/*!40000 ALTER TABLE `alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alerts_flowfalcon`
--

DROP TABLE IF EXISTS `alerts_flowfalcon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerts_flowfalcon` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `alert_id` int(11) NOT NULL COMMENT ' foreignKey: net.alerts.id',
  `device_id` int(11) NOT NULL COMMENT ' foreignKey: net.netflowdeviceinfo.id',
  `interface_id` int(11) NOT NULL COMMENT 'number of the flow interface foreignKey: local.netflowinterface.id',
  `direction_id` int(11) NOT NULL COMMENT 'flow direction foreignKey: local.netflowdirection.id',
  `filter_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.flowfalconfilters.id',
  `view_id` int(11) NOT NULL COMMENT ' foreignKey: net.flowfalconview.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `alert` (`alert_id`),
  UNIQUE KEY `flowfalcon_alert` (`alert_id`,`device_id`,`interface_id`,`direction_id`,`filter_id`,`view_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='flowfalcon-specific information for the alert.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts_flowfalcon`
--
-- WHERE:  1 limit 10

LOCK TABLES `alerts_flowfalcon` WRITE;
/*!40000 ALTER TABLE `alerts_flowfalcon` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerts_flowfalcon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ap_inventory`
--

DROP TABLE IF EXISTS `ap_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ap_inventory` (
  `ap_name` varchar(255) DEFAULT NULL COMMENT 'Name of the AP',
  `wlc_name` varchar(255) DEFAULT NULL COMMENT 'Name of the WLC to which the AP is(or was) connected',
  `ap_id` int(10) unsigned NOT NULL COMMENT 'ID of AP , this will be same as ID in deviceinfotable',
  `wlc_id` int(10) unsigned DEFAULT NULL COMMENT 'ID of WLC to which AP is(or was) connected , this will be same as ID in deviceinfotable',
  `wlc_status` enum('up','down') DEFAULT 'down' COMMENT 'Provides WLC status (up or down)',
  `ap_status` enum('associated','disassociated','unknown') DEFAULT 'unknown' COMMENT 'This provides info on connection status with WLC ',
  `switch_data` longtext DEFAULT NULL COMMENT 'Holds switch information in JSON format having switch_name, switch_ip, switch_port details',
  `last_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Latest time at which AP status was changed',
  PRIMARY KEY (`ap_id`),
  UNIQUE KEY `unique_ap_name` (`ap_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table maintains the Status of Access Points';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_inventory`
--
-- WHERE:  1 limit 10

LOCK TABLES `ap_inventory` WRITE;
/*!40000 ALTER TABLE `ap_inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authentication`
--

DROP TABLE IF EXISTS `authentication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `authentication` (
  `name` varchar(64) DEFAULT NULL COMMENT 'The special capital-letter ''id'' of the authentication type.  This may be one of: LDAP.',
  `guest` int(11) DEFAULT NULL COMMENT 'If there is a ''guest'' account set for the particular authentication type, then this is the user Id for the SevOne account to use; otherwise, this is NULL or 0. foreignKey: access_control.user.uid',
  `authentication_plugin_table` varchar(32) DEFAULT NULL COMMENT 'This is the table (in ''net'') to use for any mechanism-specific things.  Again, this was made with the best of intentions.',
  `last_active_ldap_server_id` int(11) NOT NULL DEFAULT 0 COMMENT 'LDAP server ID of last successful user login. foreignKey: net.ldapsettings.id',
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines the different 3rd-party authentication mechanisms. It had the best of intentions behind it, but is pretty crappy. -- Burke, Doug, and Taysir';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authentication`
--
-- WHERE:  1 limit 10

LOCK TABLES `authentication` WRITE;
/*!40000 ALTER TABLE `authentication` DISABLE KEYS */;
INSERT INTO `authentication` VALUES ('LDAP',0,'ldapsettings',0);
/*!40000 ALTER TABLE `authentication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `awsdeviceinfo`
--

DROP TABLE IF EXISTS `awsdeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `awsdeviceinfo` (
  `dev_id` bigint(20) NOT NULL COMMENT 'ID of device that corresponds to this AWS plugin configuration. foreignKey: net.deviceinfo.id',
  `account_id` char(12) NOT NULL COMMENT 'ID of the AWS account to be monitored.',
  `access_key_id` varchar(64) NOT NULL COMMENT 'Access Key ID of the AWS access key created for the collector.',
  `secret_access_key` varchar(497) NOT NULL COMMENT 'Secret Access Key of the AWS access key created for the collector.',
  `regions` longtext NOT NULL COMMENT 'JSON object string containing AWS regions from which the collector will collect data. Keys are AWS regions and values are 1. I.e., ''{"us-east-1":1,"ca-central-1":1}''.',
  `cloudwatch_sqs_queue` text NOT NULL COMMENT 'Name of the SQS queue that contains S3 object creation event notifications for CloudWatch metrics.',
  `iam_role_arn` text NOT NULL COMMENT 'ARN of the IAM role assumed by the collector to access AWS.',
  `vpc_flow_logs_enabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'If 1, collect VPC Flow Logs for this device and show configuration in the Device Manager.',
  `vpc_flow_logs_sqs_queue` text NOT NULL COMMENT 'Name of the SQS queue that contains S3 object creation event notifications for VPC Flow Logs.',
  `flow_logs_peer_id` int(11) DEFAULT NULL COMMENT 'If NULL, the Flow Logs peer is not selected and will be configured to the least loaded peer with DNC priority. Otherwise, Flow Logs for this device are being collected on the specified peer.',
  PRIMARY KEY (`dev_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines AWS-specific information about a Device.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `awsdeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `awsdeviceinfo` WRITE;
/*!40000 ALTER TABLE `awsdeviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `awsdeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `azuredeviceinfo`
--

DROP TABLE IF EXISTS `azuredeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `azuredeviceinfo` (
  `dev_id` bigint(20) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `tenant_id` varchar(36) NOT NULL COMMENT 'Azure tenant id',
  `client_id` varchar(64) NOT NULL COMMENT 'Azure client id',
  `secret_key` varchar(497) NOT NULL COMMENT 'Azure secret key',
  `subscription_id` varchar(36) NOT NULL COMMENT 'Azure subscription id',
  PRIMARY KEY (`dev_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines Azure-specific information about a Device.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `azuredeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `azuredeviceinfo` WRITE;
/*!40000 ALTER TABLE `azuredeviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `azuredeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `baseline_manager`
--

DROP TABLE IF EXISTS `baseline_manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `baseline_manager` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `object_group` int(11) NOT NULL DEFAULT -1 COMMENT 'The Object Group for the rule, or -1 for n/a. foreignKey: net.objectgroupinfo.id',
  `device_group` int(11) NOT NULL DEFAULT -1 COMMENT 'The Device Group for the rule, or -1 for n/a. foreignKey: net.devicetags.id',
  `plugin` int(11) NOT NULL DEFAULT -1 COMMENT 'The Plugin for the rule, or -1 for n/a. foreignKey: net.plugins.id',
  `object_type` int(11) NOT NULL DEFAULT -1 COMMENT 'The Plugin-specific Object Type for the rule, or -1 for n/a.  For this to be set, ''plugin'' must also be set. foreignKey: net.plugin_object_type.id',
  `indicator_type` int(11) NOT NULL DEFAULT -1 COMMENT 'The Plugin-specific Indicator Type for the rule, or -1 for n/a.  For this to be set, ''plugin'' and ''object_type'' must also be set. foreignKey: net.plugin_indicator_type.id',
  `is_enabled` int(11) NOT NULL DEFAULT 1 COMMENT '1 if this rule enables baselining; 0 if it disables baselining.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines the rules for when to enable or disable baseline calculations.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `baseline_manager`
--
-- WHERE:  1 limit 10

LOCK TABLES `baseline_manager` WRITE;
/*!40000 ALTER TABLE `baseline_manager` DISABLE KEYS */;
INSERT INTO `baseline_manager` VALUES (1,-1,-1,-1,-1,-1,1);
/*!40000 ALTER TABLE `baseline_manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `baseline_reset`
--

DROP TABLE IF EXISTS `baseline_reset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `baseline_reset` (
  `reset_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Reset ID',
  `reset_hash` varchar(40) NOT NULL COMMENT 'Reset Hash',
  `user_id` int(11) NOT NULL COMMENT 'User ID initiated the reset. foreignKey: access_control.user.uid',
  `peer_id` int(11) NOT NULL COMMENT 'Peer where should be the baseline reset run. foreignKey: net.peers.server_id',
  `filters` varchar(1024) NOT NULL COMMENT 'Filters posted from the GUI',
  `status` enum('new','working','done','error') NOT NULL COMMENT 'Status of the request.',
  `core_pid` int(11) DEFAULT NULL COMMENT 'The PID of the process ran at the peer',
  `is_blocked` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Is Blocked',
  `time_inserted` int(11) NOT NULL COMMENT 'Time inserted',
  `time_start` int(11) DEFAULT NULL COMMENT 'Time start',
  `time_end` int(11) DEFAULT NULL COMMENT 'Time end',
  `total_count` int(11) NOT NULL COMMENT 'Total count',
  `success_count` int(11) NOT NULL DEFAULT 0 COMMENT 'Success count',
  `error_count` int(11) NOT NULL DEFAULT 0 COMMENT 'Error count',
  PRIMARY KEY (`reset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Baseline reset requests per peer and their corresponding status.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `baseline_reset`
--
-- WHERE:  1 limit 10

LOCK TABLES `baseline_reset` WRITE;
/*!40000 ALTER TABLE `baseline_reset` DISABLE KEYS */;
/*!40000 ALTER TABLE `baseline_reset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulkdata_device_types_found`
--

DROP TABLE IF EXISTS `bulkdata_device_types_found`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulkdata_device_types_found` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `source_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.bulkdata_sources.id',
  `existing_device_type_id` int(11) DEFAULT NULL COMMENT 'When device types exist this will point to the primary key of the device type',
  `name` varchar(255) DEFAULT NULL COMMENT 'The name of this type as presented by a xStats file',
  `first_seen` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'The first time this device type was seen',
  `last_seen` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'The most recent time this device type was seen',
  `is_ignore` tinyint(4) DEFAULT 0 COMMENT 'Should this object be ignored by discovery 1 is should ignore 0 is should not ignore',
  PRIMARY KEY (`id`),
  UNIQUE KEY `source_and_name` (`source_id`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is a future proofing table for when device types work';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulkdata_device_types_found`
--
-- WHERE:  1 limit 10

LOCK TABLES `bulkdata_device_types_found` WRITE;
/*!40000 ALTER TABLE `bulkdata_device_types_found` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulkdata_device_types_found` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulkdata_devices_found`
--

DROP TABLE IF EXISTS `bulkdata_devices_found`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulkdata_devices_found` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `source_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.bulkdata_sources.id',
  `found_device_type_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.bulkdata_device_types_found.id',
  `existing_device_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `name` varchar(255) DEFAULT NULL COMMENT 'The name as presented by a xStats file',
  `ip` varbinary(40) DEFAULT NULL COMMENT 'The ip of the device as presented by the xStats file',
  `first_seen` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'The first time this device was seen',
  `last_seen` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'The most recent time this device was seen. This is not updated as this table is in net so that all peers have a valid mapping of devices they find to existing devices. As this is global any modification to this column are written to the cluster master. Also as this column must be updated on every new file processed, writing to master would present unnecessary latency (100ms) in processing files and was therfore eliminated.',
  `is_ignore` tinyint(4) DEFAULT 0 COMMENT 'Should this object be ignored by discovery 1 is should ignore 0 is should not ignore',
  PRIMARY KEY (`id`),
  UNIQUE KEY `source_and_name` (`source_id`,`name`),
  KEY `existing_device_id` (`existing_device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Mapping table for net.deviceinfo';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulkdata_devices_found`
--
-- WHERE:  1 limit 10

LOCK TABLES `bulkdata_devices_found` WRITE;
/*!40000 ALTER TABLE `bulkdata_devices_found` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulkdata_devices_found` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulkdata_missing_types`
--

DROP TABLE IF EXISTS `bulkdata_missing_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulkdata_missing_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_type` varchar(255) NOT NULL COMMENT 'The name of the Object Type.',
  `indicator_type` varchar(255) NOT NULL COMMENT 'The name of the Object Type.',
  `format` enum('GAUGE','COUNTER32','COUNTER64') NOT NULL DEFAULT 'GAUGE' COMMENT 'How this Indicator Type is measured.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`object_type`,`indicator_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This contains xstats-ingested types that did not correspond to any real object type.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulkdata_missing_types`
--
-- WHERE:  1 limit 10

LOCK TABLES `bulkdata_missing_types` WRITE;
/*!40000 ALTER TABLE `bulkdata_missing_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulkdata_missing_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulkdata_source_post_requests`
--

DROP TABLE IF EXISTS `bulkdata_source_post_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulkdata_source_post_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) NOT NULL COMMENT 'The name of the request',
  `code` blob NOT NULL COMMENT 'The code associated with this request',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table lists all the post requests for bulkdata sources';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulkdata_source_post_requests`
--
-- WHERE:  1 limit 10

LOCK TABLES `bulkdata_source_post_requests` WRITE;
/*!40000 ALTER TABLE `bulkdata_source_post_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulkdata_source_post_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulkdata_source_type_file_processors`
--

DROP TABLE IF EXISTS `bulkdata_source_type_file_processors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulkdata_source_type_file_processors` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) NOT NULL COMMENT 'The name used for the file processor.',
  `code` mediumblob DEFAULT NULL COMMENT 'The code.',
  `version` int(11) DEFAULT 0 COMMENT 'Version',
  `type` varchar(255) DEFAULT 'php' COMMENT 'Type',
  `internal` tinyint(4) DEFAULT 0 COMMENT 'Internal',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Contains the information for the file processors for the bulkdata source types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulkdata_source_type_file_processors`
--
-- WHERE:  1 limit 10

LOCK TABLES `bulkdata_source_type_file_processors` WRITE;
/*!40000 ALTER TABLE `bulkdata_source_type_file_processors` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulkdata_source_type_file_processors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulkdata_source_type_files`
--

DROP TABLE IF EXISTS `bulkdata_source_type_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulkdata_source_type_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `source_type_id` int(11) NOT NULL COMMENT 'The Source Type to use for this mapping foreignKey: net.bulkdata_source_types.id',
  `file_processor_id` int(11) NOT NULL COMMENT 'The File Processor to use for this mapping foreignKey: net.bulkdata_source_type_file_processors.id',
  `filename_expression` varchar(255) NOT NULL COMMENT 'The Regular Expression to check the filename against to match this parser',
  `position` int(11) NOT NULL DEFAULT 999999 COMMENT 'The ordinality of this processor',
  PRIMARY KEY (`id`),
  UNIQUE KEY `source_processor` (`source_type_id`,`file_processor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Mapping Table for bulkdata source type to their file processors';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulkdata_source_type_files`
--
-- WHERE:  1 limit 10

LOCK TABLES `bulkdata_source_type_files` WRITE;
/*!40000 ALTER TABLE `bulkdata_source_type_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulkdata_source_type_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulkdata_source_type_processors`
--

DROP TABLE IF EXISTS `bulkdata_source_type_processors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulkdata_source_type_processors` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) NOT NULL COMMENT 'Name of processor',
  `code` mediumblob DEFAULT NULL COMMENT 'the processor code',
  `version` int(11) DEFAULT 0 COMMENT 'version of the processor',
  `type` varchar(255) DEFAULT 'php' COMMENT 'type',
  `internal` tinyint(4) DEFAULT 0 COMMENT 'internal',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Bulk data source type processors.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulkdata_source_type_processors`
--
-- WHERE:  1 limit 10

LOCK TABLES `bulkdata_source_type_processors` WRITE;
/*!40000 ALTER TABLE `bulkdata_source_type_processors` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulkdata_source_type_processors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulkdata_source_types`
--

DROP TABLE IF EXISTS `bulkdata_source_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulkdata_source_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary KEy',
  `name` varchar(255) NOT NULL COMMENT 'Source Type Name',
  `retrieval_method` enum('ftp','sftp','localfilesystem','http','https','https-post') NOT NULL COMMENT 'The retrieval method',
  `retrieval_order` enum('asc','desc') DEFAULT 'asc' COMMENT 'Should process files in ascending of decending order',
  `retrieval_directory` varchar(255) DEFAULT NULL COMMENT 'The default directroy for this source to pull from',
  `processor_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.bulkdata_source_type_processors.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='xStats (bulkdata) Source Types';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulkdata_source_types`
--
-- WHERE:  1 limit 10

LOCK TABLES `bulkdata_source_types` WRITE;
/*!40000 ALTER TABLE `bulkdata_source_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulkdata_source_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulkdata_sources`
--

DROP TABLE IF EXISTS `bulkdata_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulkdata_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(255) NOT NULL COMMENT 'Source Name',
  `peer_id` int(11) DEFAULT NULL COMMENT 'Peer that owns the source. foreignKey: net.peers.server_id',
  `ip` varbinary(40) DEFAULT NULL COMMENT 'IP of the source',
  `source_type_id` int(11) NOT NULL COMMENT ' foreignKey: net.bulkdata_source_types.id',
  `frequency` int(11) NOT NULL DEFAULT 20 COMMENT 'Frequency to try and collect from this source',
  `username` varchar(497) DEFAULT NULL COMMENT 'Username to use to connect to this source',
  `password` varchar(497) DEFAULT NULL COMMENT 'Password to use to connect to this source',
  `retrieval_directory` varchar(255) DEFAULT NULL COMMENT 'Directory to look for files in',
  `last_successful_fetch` datetime DEFAULT NULL COMMENT 'Time of last successful fetch',
  `last_attempted_fetch` datetime DEFAULT NULL COMMENT 'Time of last attempted fetch',
  `post_request_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.bulkdata_source_post_requests.id',
  `automatic_device_creation` tinyint(4) DEFAULT 1 COMMENT 'Should devices be created automatically',
  `expect_unique_files` tinyint(4) DEFAULT 1 COMMENT 'Should we only fetch unique files',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='xStats (bulkdata) Sources';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulkdata_sources`
--
-- WHERE:  1 limit 10

LOCK TABLES `bulkdata_sources` WRITE;
/*!40000 ALTER TABLE `bulkdata_sources` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulkdata_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificates`
--

DROP TABLE IF EXISTS `certificates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `certificates` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The row id.',
  `name` varchar(255) DEFAULT NULL COMMENT 'The file name of the certificate.',
  `is_root` tinyint(4) DEFAULT NULL COMMENT 'Whether the certificates is root.',
  `contents` longblob DEFAULT NULL COMMENT 'The content of the certificate.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Contains all uploaded certificates.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificates`
--
-- WHERE:  1 limit 10

LOCK TABLES `certificates` WRITE;
/*!40000 ALTER TABLE `certificates` DISABLE KEYS */;
/*!40000 ALTER TABLE `certificates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cluster_health_job`
--

DROP TABLE IF EXISTS `cluster_health_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_health_job` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `status` enum('PASS','FAIL','WORKING') NOT NULL COMMENT 'This returns the current cluster job.  If it is in progress, it is set to working.  When the job completes, it is set to PASS or FAIL',
  `start_time` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'This is the timestamp the job started',
  `end_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'This is the timestamp the job ended.  It will be null if the job is in progress',
  PRIMARY KEY (`id`),
  KEY `start_time` (`start_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This store the cluster health job information.  It stores the status of every job that has been run, including those in progress';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cluster_health_job`
--
-- WHERE:  1 limit 10

LOCK TABLES `cluster_health_job` WRITE;
/*!40000 ALTER TABLE `cluster_health_job` DISABLE KEYS */;
/*!40000 ALTER TABLE `cluster_health_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cluster_state`
--

DROP TABLE IF EXISTS `cluster_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_state` (
  `flag` enum('UPGRADE_CHECK','UPGRADE_FETCH_FAILED','UPGRADE_CLUSTER_UNHEALTHY','CLUSTER_ACTION_IN_PROGRESS') NOT NULL COMMENT 'The flag raised for the whole cluster.',
  `value` varchar(255) NOT NULL COMMENT 'Meaningful value associated with this flag. Should ideally mean something to the thing raising the flag.',
  `message` text DEFAULT NULL COMMENT 'Optional, human-readable text associated with the flag.',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'timestamp when the flag was raised.',
  PRIMARY KEY (`flag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Describes random cluster-wide state stuff that needs to be handled at a relatively low level. Some things use this for locks, some just for arbitrary flags, or to indicate some failure condition the entire cluster cares about. The different flags should be listed in the ENUM making up the ''flag'' column.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cluster_state`
--
-- WHERE:  1 limit 10

LOCK TABLES `cluster_state` WRITE;
/*!40000 ALTER TABLE `cluster_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `cluster_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `connection`
--

DROP TABLE IF EXISTS `connection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `connection` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `map_id` int(11) DEFAULT NULL COMMENT 'The map this connection is in. foreignKey: net.map.id',
  `nodeA_id` int(11) DEFAULT NULL COMMENT 'The first node that this connection is associated with. foreignKey: net.node.id',
  `nodeB_id` int(11) DEFAULT NULL COMMENT 'The second node that this connection is associated with. foreignKey: net.node.id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all the connections associated with maps.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `connection`
--
-- WHERE:  1 limit 10

LOCK TABLES `connection` WRITE;
/*!40000 ALTER TABLE `connection` DISABLE KEYS */;
/*!40000 ALTER TABLE `connection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `connection_join`
--

DROP TABLE IF EXISTS `connection_join`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `connection_join` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `connection_id` int(11) NOT NULL COMMENT 'The connection this join is associated with foreignKey: net.connection.id',
  `device_id` int(11) DEFAULT NULL COMMENT 'The device id for this join foreignKey: net.deviceinfo.id',
  `plugin_id` int(11) DEFAULT NULL COMMENT 'The plugin id for this join foreignKey: net.plugins.id',
  `object_id` int(11) DEFAULT NULL COMMENT 'The object id for this join foreignKey: local.device_object.id',
  `object_group_id` int(11) DEFAULT NULL COMMENT 'The object group id of this join foreignKey: net.objectgroupinfo.id',
  `device_group_id` int(11) DEFAULT NULL COMMENT 'The device group id of this join foreignKey: net.devicetags.id',
  `map_id` int(11) DEFAULT NULL COMMENT 'The map id of this join foreignKey: net.map.id',
  `report_id` int(11) DEFAULT NULL COMMENT 'The report id of this join. foreignKey: net.surf.id',
  PRIMARY KEY (`id`),
  KEY `connection_id` (`connection_id`),
  KEY `device_group_id` (`device_group_id`),
  KEY `device_id` (`device_id`),
  KEY `map_id` (`map_id`),
  KEY `object_group_id` (`object_group_id`),
  KEY `object_id` (`object_id`),
  KEY `plugin_id` (`plugin_id`),
  KEY `report_id` (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all the associated data to connections. Each entry in this table corresponds to an associated device/object/group/etc. There may also be a report associated with this join on top of any SevOne entities.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `connection_join`
--
-- WHERE:  1 limit 10

LOCK TABLES `connection_join` WRITE;
/*!40000 ALTER TABLE `connection_join` DISABLE KEYS */;
/*!40000 ALTER TABLE `connection_join` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `code` varchar(2) NOT NULL COMMENT 'Code',
  `country` varchar(255) DEFAULT NULL COMMENT 'The name of the country',
  `display` enum('0','1') DEFAULT NULL COMMENT 'This stored if the country should be displayed',
  PRIMARY KEY (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is used to store country codes.  This might be a candidate for deletion';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--
-- WHERE:  1 limit 10

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES ('AF','AFGHANISTAN','0'),('AX','&#x00C5;LAND ISLANDS','0'),('AL','ALBANIA','0'),('DZ','ALGERIA','0'),('AS','AMERICAN SAMOA','0'),('AD','ANDORRA','0'),('AO','ANGOLA','0'),('AI','ANGUILLA','0'),('AQ','ANTARCTICA','0'),('AG','ANTIGUA AND BARBUDA','0');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_page`
--

DROP TABLE IF EXISTS `custom_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'This is the ID of the custom page entry.',
  `header` varchar(32) NOT NULL COMMENT 'This is the header under which the custom page link should go.',
  `name` varchar(32) NOT NULL COMMENT 'This is the name of the custom page as it will display in the navigation menu.',
  `url` varchar(256) NOT NULL COMMENT 'This is the url to which the custom page links to and will create a window to.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines the list of custom page navigation pages. These entries will show in a navigation menu item for custom page definitions.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_page`
--
-- WHERE:  1 limit 10

LOCK TABLES `custom_page` WRITE;
/*!40000 ALTER TABLE `custom_page` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_candidate_scans`
--

DROP TABLE IF EXISTS `device_candidate_scans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_candidate_scans` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name of the scan',
  `watched_subnet` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Flag denoting whether this is a watched subnet.',
  `ip_start` varbinary(40) DEFAULT NULL COMMENT 'The start of an IP range denoting a subnet.',
  `ip_end` varbinary(40) DEFAULT NULL COMMENT 'The end of an IP range denoting a subnet.',
  `peer_id` int(11) NOT NULL DEFAULT 0 COMMENT 'The ID of the peer that this scan is on. foreignKey: net.peers.server_id',
  `scheduling` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Flag denoting whether there is scheduling for this scan, in device_candidate_scans_scheduling.',
  `last_run` int(11) DEFAULT NULL COMMENT 'Timestamp for the last tiem this scan ran.',
  `check_snmp` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Flag for whether running this scan should SNMP for found IPs.',
  `action` enum('ADD_CANDIDATE','ADD_DEVICE') DEFAULT 'ADD_CANDIDATE' COMMENT 'Action to be taken on candidates found.',
  `devicetag_id` int(11) DEFAULT NULL COMMENT 'Device Tag corresponding to this scan, where new devices must be added.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `peer_start_end_ip` (`peer_id`,`ip_start`,`ip_end`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Stores information about device scans, which may be grouping for existing candidates, or a definition of a subnet which may be used to generate new candidates.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_candidate_scans`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_candidate_scans` WRITE;
/*!40000 ALTER TABLE `device_candidate_scans` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_candidate_scans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_candidate_scans_scheduling`
--

DROP TABLE IF EXISTS `device_candidate_scans_scheduling`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_candidate_scans_scheduling` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The id of the scheduling entry',
  `scan_id` int(11) DEFAULT NULL COMMENT 'The id of the scan this schedule is associated with. foreignKey: net.device_candidate_scans.id',
  `mon` tinyint(4) DEFAULT 0 COMMENT 'Does this scan run on Monday?!?!?',
  `tue` tinyint(4) DEFAULT 0 COMMENT 'Does this scan run on Tuesday?!?!?!',
  `wed` tinyint(4) DEFAULT 0 COMMENT 'Does this scan run on Wednesday?!?!',
  `thu` tinyint(4) DEFAULT 0 COMMENT 'Does this scan run on Tuesday?!?! Nah, just kidding. Does this scan run on Thursday?!?!',
  `fri` tinyint(4) DEFAULT 0 COMMENT 'Does this scan run on Friday?!?!? Probably not, it''s Friday. Be real.',
  `sat` tinyint(4) DEFAULT 0 COMMENT 'Does this scan run on Saturday?!?!? Or Funday?',
  `sun` tinyint(4) DEFAULT 0 COMMENT 'Does this scan run on Sunday?!?!? NO! It''s the sabboth unless that was Saturday...',
  `start_hr` int(11) DEFAULT NULL COMMENT 'The hour at which the scan is supposed to start',
  `start_min` int(11) DEFAULT NULL COMMENT 'The minute at which the scan is supposed to start',
  `timezone` varchar(64) DEFAULT NULL COMMENT 'The timezone in which the scan should take place allowing localization of scan times',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This holds the scheduling details for when scans are meant to run';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_candidate_scans_scheduling`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_candidate_scans_scheduling` WRITE;
/*!40000 ALTER TABLE `device_candidate_scans_scheduling` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_candidate_scans_scheduling` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_candidates`
--

DROP TABLE IF EXISTS `device_candidates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_candidates` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID',
  `scan_id` int(11) DEFAULT NULL COMMENT 'ID of scan, used for grouping. foreignKey: net.device_candidate_scans.id',
  `ip` varbinary(40) DEFAULT NULL COMMENT 'IP of candidate',
  `device_id` int(11) DEFAULT NULL COMMENT 'Device ID corresponding to IP and peer foreignKey: net.deviceinfo.id',
  `first_found` int(11) DEFAULT NULL COMMENT 'UNIX timestamp for the first time the candidate was found',
  `last_found` int(11) DEFAULT NULL COMMENT 'UNIX timestamp for the last time the candidate was found',
  `add_device` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Bool to indicate whether the candidate should be added to SevOne',
  `is_blocked` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Bool to indicate if this candidate is blocked from being added to SevOne',
  `name` varchar(255) DEFAULT NULL COMMENT 'Name to be used for device',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description to be used for device',
  `group1` varchar(255) DEFAULT NULL COMMENT 'Group to add device to (1)',
  `group2` varchar(255) DEFAULT NULL COMMENT 'Group to add device to (2)',
  `group3` varchar(255) DEFAULT NULL COMMENT 'Group to add device to (3)',
  `group4` varchar(255) DEFAULT NULL COMMENT 'Group to add device to (4)',
  `group5` varchar(255) DEFAULT NULL COMMENT 'Group to add device to (5)',
  `poll_frequency` int(11) NOT NULL DEFAULT 300 COMMENT 'Polling frequency for device',
  `timezone` varchar(255) DEFAULT 'UTC' COMMENT 'Timezone for device',
  `peer_id` int(11) NOT NULL DEFAULT 0 COMMENT 'ID of peer that the candidate corresponds to foreignKey: net.peers.server_id',
  `has_icmp` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Bool indicating if ICMP testing succeeded for candidate',
  `has_snmp` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Bool indicating if SNMP testing succeeded for candidate',
  `snmp_version` smallint(6) DEFAULT NULL COMMENT 'SNMP version to use for device',
  `snmp_port` int(11) DEFAULT 161 COMMENT 'SNMP port to use for device',
  `snmp_ro_string` varchar(497) DEFAULT NULL COMMENT 'SNMP RO community string to use for device',
  `snmp_rw_string` varchar(497) DEFAULT NULL COMMENT 'SNMP RW community string to use for device',
  `snmp_username` varchar(497) DEFAULT NULL COMMENT 'SNMPv3 username to use for device',
  `snmp_auth_protocol` enum('','MD5','SHA','SHA-224','SHA-256','SHA-384','SHA-512') DEFAULT NULL COMMENT 'SNMPv3 authentication protocol to use for device',
  `snmp_auth_password` varchar(497) DEFAULT NULL COMMENT 'SNMPv3 authentication password to use for device',
  `snmp_encryption_protocol` enum('','AES','AES192','AES256','AES192C','AES256C') DEFAULT NULL COMMENT 'SNMPv3 encryption protocol to use for device',
  `snmp_encryption_password` varchar(497) DEFAULT NULL COMMENT 'SNMPv3 encryption password to use for device',
  `snmp_context_name` varchar(497) DEFAULT NULL COMMENT 'SNMPv3 context name to use for device',
  `has_vmware` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Bool indicating if VMware testing succeeded for candidate',
  `vmware_name` varchar(255) DEFAULT NULL COMMENT 'VMware name to be used for device',
  `vmware_vcenter_device_id` int(11) DEFAULT NULL COMMENT 'VMware vCenter Device ID to be used for device foreignKey: net.deviceinfo.id',
  `vmware_type_vcenter` tinyint(4) DEFAULT NULL COMMENT 'VMware type of vCenter, to be set for device',
  `vmware_type_esx` tinyint(4) DEFAULT NULL COMMENT 'VMware type of ESX Host, to be set for device',
  `vmware_type_vm` tinyint(4) DEFAULT NULL COMMENT 'VMware type of VM, to be set for device',
  `dns_resolve` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Bool to indicate whether the the name should be automatically resolved from the ip',
  `check_snmp` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Bool to indicate whether the candidate will be tested for snmp availability',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip` (`peer_id`,`scan_id`,`ip`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Stores device candidates derived from any number of sources. e.g. Watched subnets, CSV import, VMware vcenter auto-updates, etc. They may or may not be grouped by device_candidate_scan entries, via scan_id.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_candidates`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_candidates` WRITE;
/*!40000 ALTER TABLE `device_candidates` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_candidates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_devicetag_map`
--

DROP TABLE IF EXISTS `device_devicetag_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_devicetag_map` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique ID',
  `device_id` int(11) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `devicetag_id` int(11) NOT NULL COMMENT ' foreignKey: net.devicetags.id',
  `is_automatic` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT '1 if this mapping was created by the system; 0 if a user did it.',
  `date_added` datetime DEFAULT NULL COMMENT 'The date at which this mapping was created.',
  `date_modified` datetime DEFAULT NULL COMMENT 'The date at which this mapping was last updated.',
  `is_inherited` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Select if you want to use unrestricted device grouping.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `device_id_devicetag_id` (`device_id`,`devicetag_id`),
  UNIQUE KEY `devicetag_id_device_id` (`devicetag_id`,`device_id`)
) ENGINE=InnoDB AUTO_INCREMENT=148356077 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This maps a Device to a Device Group.  Device Groups were originally called Device Tags.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_devicetag_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_devicetag_map` WRITE;
/*!40000 ALTER TABLE `device_devicetag_map` DISABLE KEYS */;
INSERT INTO `device_devicetag_map` VALUES (303,49,1,0,'2025-11-20 11:32:13',NULL,0),(304,49,2,0,'2025-11-20 11:32:13',NULL,0),(305,49,42,0,'2025-11-20 11:32:13',NULL,0),(306,50,1,0,'2025-11-20 11:32:13',NULL,0),(307,50,2,0,'2025-11-20 11:32:13',NULL,0),(308,50,42,0,'2025-11-20 11:32:13',NULL,0),(312,50,43,1,'2025-11-20 11:34:02',NULL,0),(318,49,43,1,'2025-11-20 11:34:02',NULL,0),(321,51,1,0,'2025-11-24 17:03:23',NULL,0),(322,51,2,0,'2025-11-24 17:03:23',NULL,0);
/*!40000 ALTER TABLE `device_devicetag_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_devicetag_ownership`
--

DROP TABLE IF EXISTS `device_devicetag_ownership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_devicetag_ownership` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID',
  `device_id` int(11) NOT NULL COMMENT 'Device ID. foreignKey: net.deviceinfo.id',
  `devicetag_id` int(11) NOT NULL COMMENT 'Devicetag ID. foreignKey: net.devicetags.id',
  `owner_id` int(11) NOT NULL COMMENT 'Devicetag Owner ID. foreignKey: net.devicetags.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `device_id_devicetag_id_owner_id` (`device_id`,`devicetag_id`,`owner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=112971126 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Device Devicetag Ownership';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_devicetag_ownership`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_devicetag_ownership` WRITE;
/*!40000 ALTER TABLE `device_devicetag_ownership` DISABLE KEYS */;
INSERT INTO `device_devicetag_ownership` VALUES (112964713,49,24,24),(112964744,49,25,25),(112964682,49,27,27),(112965814,49,40,40),(112966325,49,41,41),(112967514,49,227,227),(112968551,49,238,238),(112969587,49,239,239),(112964714,50,24,24),(112964745,50,25,25);
/*!40000 ALTER TABLE `device_devicetag_ownership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_relationships`
--

DROP TABLE IF EXISTS `device_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_relationships` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `parent_device_id` int(11) NOT NULL COMMENT 'parent_device_id foreignKey: net.deviceinfo.id',
  `child_device_id` int(11) NOT NULL COMMENT 'child_device_id foreignKey: net.deviceinfo.id',
  `relationship_type` enum('virtualizes','tests','manages','routes','switches') DEFAULT NULL COMMENT 'relationship_type',
  `date_started` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'date_started',
  `date_ended` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'date_ended',
  `is_automatic` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'is_automatic',
  `is_discovered` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'is_discovered',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`parent_device_id`,`child_device_id`,`relationship_type`,`date_ended`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Device Relationship';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_relationships`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_relationships` WRITE;
/*!40000 ALTER TABLE `device_relationships` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_type_image_map`
--

DROP TABLE IF EXISTS `device_type_image_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_type_image_map` (
  `device_type_id` int(11) NOT NULL COMMENT 'device_type_id foreignKey: net.devicetags.id',
  `image_id` int(11) NOT NULL COMMENT 'image_id foreignKey: net.image_store.id',
  `date_uploaded` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'date_uploaded',
  PRIMARY KEY (`device_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This maps a Device Type to the image that should be used to identify it in Topology graphs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_type_image_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_type_image_map` WRITE;
/*!40000 ALTER TABLE `device_type_image_map` DISABLE KEYS */;
INSERT INTO `device_type_image_map` VALUES (1,1,'2015-12-17 22:49:50'),(163,11,'2016-03-24 13:37:30'),(164,7,'2016-03-24 13:37:30'),(165,12,'2016-03-24 13:37:30'),(166,3,'2016-03-24 13:37:30'),(167,19,'2016-03-24 13:37:30');
/*!40000 ALTER TABLE `device_type_image_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_type_metadata_namespace_map`
--

DROP TABLE IF EXISTS `device_type_metadata_namespace_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_type_metadata_namespace_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `devicetype_id` int(11) NOT NULL COMMENT ' foreignKey: net.devicetags.id',
  `namespace_id` int(11) NOT NULL COMMENT '  foreignKey: net.metadata_namespace.id',
  `is_editable` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'The MAP between Namespace Id and Device Type Id is editable or not.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `devicetype_id_namespace_id` (`devicetype_id`,`namespace_id`),
  UNIQUE KEY `namespace_id_devicetype_id` (`namespace_id`,`devicetype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores mapping between device type and Metadata namespaces.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_type_metadata_namespace_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_type_metadata_namespace_map` WRITE;
/*!40000 ALTER TABLE `device_type_metadata_namespace_map` DISABLE KEYS */;
INSERT INTO `device_type_metadata_namespace_map` VALUES (1,42,12,0),(2,42,13,0);
/*!40000 ALTER TABLE `device_type_metadata_namespace_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_type_object_type_map`
--

DROP TABLE IF EXISTS `device_type_object_type_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_type_object_type_map` (
  `device_type_id` int(11) NOT NULL COMMENT ' foreignKey: net.devicetags.id',
  `object_type_id` int(11) NOT NULL COMMENT ' foreignKey: net.plugin_object_type.id',
  PRIMARY KEY (`device_type_id`,`object_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This maps a Device Type to an Object Type';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_type_object_type_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_type_object_type_map` WRITE;
/*!40000 ALTER TABLE `device_type_object_type_map` DISABLE KEYS */;
INSERT INTO `device_type_object_type_map` VALUES (43,272),(43,274),(43,279),(43,296),(43,299),(43,306),(43,310),(43,311),(43,313),(43,314);
/*!40000 ALTER TABLE `device_type_object_type_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devicegrouprules`
--

DROP TABLE IF EXISTS `devicegrouprules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `devicegrouprules` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `group_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to the group tables foreignKey: net.devicetags.id',
  `name_expression` text DEFAULT NULL COMMENT 'Name Expression',
  `description_expression` text DEFAULT NULL COMMENT 'Description Expression',
  `mgt_ip_expression` text DEFAULT NULL COMMENT 'Management Ip expression',
  `sys_descr_expression` text DEFAULT NULL COMMENT 'System Description expression',
  `sys_location_expression` text DEFAULT NULL COMMENT 'System Location Expression',
  `sys_name_expression` text DEFAULT NULL COMMENT 'System Location Expression',
  `sys_object_id_expression` text DEFAULT NULL COMMENT 'System Object Id Expression',
  `sys_contact_expression` text DEFAULT NULL COMMENT 'System Contact Expression',
  `walk_check_oid` text DEFAULT NULL COMMENT 'walk_check_oid',
  `namespace_id` int(11) DEFAULT NULL COMMENT 'Metadata Namespace id. foreignKey: net.metadata_namespace.id',
  `attribute_id` int(11) DEFAULT NULL COMMENT 'Metadata Attribute id. foreignKey: net.metadata_attribute.id',
  `metadata_value_expression` text DEFAULT NULL COMMENT 'Metadata Value Expression',
  `is_include_rule` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Device Group Rule Include Exclude',
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=266 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Device Group Rules';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devicegrouprules`
--
-- WHERE:  1 limit 10

LOCK TABLES `devicegrouprules` WRITE;
/*!40000 ALTER TABLE `devicegrouprules` DISABLE KEYS */;
INSERT INTO `devicegrouprules` VALUES (1,6,'router','','','','','','',NULL,NULL,NULL,NULL,NULL,1),(2,6,'^Router','','','','','','',NULL,NULL,NULL,NULL,NULL,1),(6,13,'','','','Cisco','','','',NULL,NULL,NULL,NULL,NULL,1),(8,12,'','','','','','','.1.3.6.1.4.1.27207.3','',NULL,NULL,NULL,'',1),(9,14,'','','','Juniper','','','',NULL,NULL,NULL,NULL,NULL,1),(10,14,'','','','junos','','','',NULL,NULL,NULL,NULL,NULL,1),(11,25,'','','\\.','','','','',NULL,NULL,NULL,NULL,NULL,1),(12,26,'','',':','','','','',NULL,NULL,NULL,NULL,NULL,1),(13,19,'','','','HP','','','',NULL,NULL,NULL,NULL,NULL,1),(14,37,'','','','CAT-OS','','','',NULL,NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `devicegrouprules` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_devicegrouprules_insert` AFTER INSERT
ON `net`.`devicegrouprules` FOR EACH ROW
INSERT INTO net.devicegrouprules_info (device_group_id, created_at, modified_at) VALUES (NEW.id, NOW(), NOW()) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_devicegrouprules_update` AFTER UPDATE
ON `net`.`devicegrouprules` FOR EACH ROW
IF EXISTS (SELECT * FROM net.devicegrouprules_info WHERE device_group_id = NEW.id) THEN UPDATE net.devicegrouprules_info SET modified_at = NOW() WHERE device_group_id = NEW.id;
ELSE INSERT INTO net.devicegrouprules_info (device_group_id, created_at, modified_at) VALUES (NEW.id, NOW(), NOW()); 
END IF */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_devicegrouprules_delete` AFTER DELETE
ON `net`.`devicegrouprules` FOR EACH ROW
IF EXISTS (SELECT * FROM net.devicegrouprules_info WHERE device_group_id = OLD.id) THEN UPDATE net.devicegrouprules_info SET deleted_at = NOW() WHERE device_group_id = OLD.id;
ELSE INSERT INTO net.devicegrouprules_info (device_group_id, deleted_at) VALUES (OLD.id, NOW());
END IF */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `devicegrouprules_info`
--

DROP TABLE IF EXISTS `devicegrouprules_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `devicegrouprules_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `device_group_id` int(11) DEFAULT NULL COMMENT 'Device group ID grouprule entry. foreignKey: net.devicetags.id ',
  `created_at` datetime DEFAULT NULL COMMENT 'Created time for grouprule entry ',
  `modified_at` datetime DEFAULT NULL COMMENT 'Modified time for grouprule entry ',
  `deleted_at` datetime DEFAULT NULL COMMENT 'Deleted time for grouprule entry ',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=259 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the created/modifed/deleted devicegrouprules';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devicegrouprules_info`
--
-- WHERE:  1 limit 10

LOCK TABLES `devicegrouprules_info` WRITE;
/*!40000 ALTER TABLE `devicegrouprules_info` DISABLE KEYS */;
INSERT INTO `devicegrouprules_info` VALUES (1,147,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(2,148,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(3,149,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(4,150,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(5,1,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(6,2,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(7,21,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(8,22,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(9,152,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(10,153,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL);
/*!40000 ALTER TABLE `devicegrouprules_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devicegrouptrapdestination`
--

DROP TABLE IF EXISTS `devicegrouptrapdestination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `devicegrouptrapdestination` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `group_id` int(10) DEFAULT NULL COMMENT 'group_id foreignKey: net.devicetags.id',
  `trap_destination_id` int(10) DEFAULT NULL COMMENT 'trap_destination_id foreignKey: net.trapdestination.id',
  `is_enabled` smallint(6) DEFAULT 0 COMMENT 'is_enabled',
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_key` (`group_id`,`trap_destination_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Device Group Trap Destination';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devicegrouptrapdestination`
--
-- WHERE:  1 limit 10

LOCK TABLES `devicegrouptrapdestination` WRITE;
/*!40000 ALTER TABLE `devicegrouptrapdestination` DISABLE KEYS */;
/*!40000 ALTER TABLE `devicegrouptrapdestination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deviceinfo`
--

DROP TABLE IF EXISTS `deviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `deviceinfo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The ID of the device',
  `name` varchar(128) NOT NULL COMMENT 'The name of the Device; this is super-unique.',
  `mgt_address` varbinary(40) DEFAULT NULL COMMENT 'This is the management IP address of the Device.  This may be IPv4 or IPv6.',
  `ro_community` varchar(497) DEFAULT NULL COMMENT 'SNMP: The read-only community string.',
  `rw_community` varchar(497) NOT NULL COMMENT 'SNMP: The read-write community string.',
  `description` varchar(255) DEFAULT NULL COMMENT 'An arbitrary description of the Device.  Used for searching.',
  `alt_name` varchar(128) DEFAULT '' COMMENT 'An ''alternative'' name for the Device.  Used for searching.',
  `snmp_version` smallint(6) DEFAULT 1 COMMENT 'SNMP: The version; this may be 1, 2, or 3.  ''2'' implies SNMPv2c.',
  `lock_snmp_version` smallint(6) DEFAULT 1 COMMENT '1 if a user has requested that the SNMP version not change; 0 if the system is free to manipulate the SNMP version.',
  `snmp_port` int(11) DEFAULT 161 COMMENT 'SNMP: The UDP port on which to communicate.',
  `snmp_test_oid` varchar(255) DEFAULT '.1.3.6.1.2.1.1.1.0' COMMENT 'This is the OID to test for SNMP connectivity at discovery time.  This defaults to ''sysDescr.0''.',
  `num_ints` int(11) DEFAULT 0 COMMENT 'This is the number of enabled Objects for the Device.  This is populated by discovery.',
  `date_added` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'This is the date at which the Device was added.',
  `last_discovery` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'This is the date at which the Device was last discovered.',
  `is_deleted` smallint(6) NOT NULL DEFAULT 0 COMMENT '1 if the Device should be deleted; 0 otherwise.',
  `poll_frequency` int(11) NOT NULL DEFAULT 300 COMMENT 'The polling interval, in seconds.',
  `peer` int(11) NOT NULL DEFAULT 0 COMMENT 'The ID of the Peer that owns this Device. foreignKey: net.peers.server_id',
  `new` int(11) NOT NULL DEFAULT 1 COMMENT '1 if the Device is ''new'' and has not yet been discovered; 0 otherwise.',
  `disable_polling` int(11) DEFAULT 0 COMMENT '1 if polling should be disabled for the Device; 0 otherwise.',
  `disable_concurrent_polling` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if this Device should only poll with one instance at a time; 0 for the default behavior of allowing stacked polling.',
  `disable_thresholds` int(11) DEFAULT 0 COMMENT '1 if threshold-checking should be disabled for the Device; 0 otherwise.',
  `timezone` varchar(255) DEFAULT 'UTC' COMMENT 'The timezone for the device.  TODO: What does this reference?',
  `synchronize_objects_admin_status` int(11) DEFAULT -1 COMMENT '1 if Objects should be disabled for being administratively down; 0 to ignore this state; -1 to use the value from the setting ''synchronize_objects_admin_status''.',
  `synchronize_objects_oper_status` int(11) DEFAULT -1 COMMENT '1 if Objects should be disabled for being operationally down; 0 to ignore this state; -1 to use the value from the setting ''synchronize_objects_oper_status''.',
  `enable_snmp_ip_query` int(11) DEFAULT 1 COMMENT '1 if discovery should attempt to determine the IP addresses for the interfaces of this Device; 0 otherwise.',
  `enable_snmp_trapd` tinyint(4) DEFAULT -1 COMMENT '1 if discovery should attempt to determine the SNMP trap receivers for this Device; 0 otherwise.',
  `authentication_username` varchar(497) DEFAULT NULL COMMENT 'SNMP: The v3 username.',
  `authentication_protocol` enum('','MD5','SHA','SHA-224','SHA-256','SHA-384','SHA-512') NOT NULL DEFAULT '' COMMENT 'SNMP: The v3 authentication protocol.',
  `authentication_passphrase` varchar(497) DEFAULT NULL COMMENT 'SNMP: The v3 password.',
  `encryption_protocol` enum('','AES','AES192','AES256','AES192C','AES256C') NOT NULL DEFAULT '' COMMENT 'SNMP: The v3 encryption protocol.',
  `encryption_passphrase` varchar(497) DEFAULT NULL COMMENT 'SNMP: The v3 encryption password.',
  `context_name` varchar(497) DEFAULT NULL COMMENT 'SNMP: The v3 context name.',
  `snmp_delay` double NOT NULL DEFAULT 0 COMMENT 'SNMP: The amount of time, in seconds, to wait between SNMP queries.',
  `snmp_delay_on_failure` double NOT NULL DEFAULT 0 COMMENT 'SNMP: The amount of time, in seconds, to wait between a failed SNMP query and the next query.',
  `snmp_interface_support_rfc2233` tinyint(4) DEFAULT -1 COMMENT '1 if RFC-2233 should be supported; 0 to not support it; -1 to use the value of the setting ''snmp_interface_support_rfc2233''.',
  `snmp_counter_prefer_64bit` tinyint(4) DEFAULT 1 COMMENT '0 to have no preference; 1 if 64-bit counters should be preferred over 32-bit counters; 2 to prefer 32-bit counters over 64-bit counters; -1 to use the value of the setting ''snmp_counter_prefer_64bit''.',
  `snmp_max_pdu` int(11) NOT NULL DEFAULT 0 COMMENT 'SNMP: This is the maximum size of a PDU to send to the Device.  If this is 0, then we will trust net-snmp''s judgement on the matter.',
  `snmp_discover_pdu` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 if discovery should attempt to discovery ''snmp_max_pdu''; 0 otherwise.',
  `snmp_walk_max_repetitions` int(11) NOT NULL DEFAULT 0 COMMENT 'SNMP: This is the maximum number of repetitions used when performing a SNMP walk. If this is 0, then this is not passed to the client and the default is used.',
  `allow_delete` int(11) NOT NULL DEFAULT 1 COMMENT '1 if this Device can be deleted; 0 otherwise.',
  `workhours_group_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.workhours_groups.id',
  `name_masked` varchar(64) DEFAULT NULL COMMENT 'The ''masked'' version of the name, after taking into account the rules in ''net.devicename_masks''.',
  `plugin_manager_id` int(11) DEFAULT NULL COMMENT 'This column is no longer used',
  `manual_mgt_address` int(11) NOT NULL DEFAULT 0 COMMENT '1 if mgt_address is manual added and can not be changed automatically; 0 otherwise.',
  `queued_for_deletion` smallint(6) NOT NULL DEFAULT 0 COMMENT '1 if device is queued for deletion 0 otherwise.',
  `queued_user` int(11) DEFAULT NULL COMMENT 'This is User ID of user who have added a device in deletion queue.',
  `queued_time` timestamp NULL DEFAULT NULL COMMENT 'This is the date at which the Device added to deletion queue.',
  `enable_vendor_metadata_discovery` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Default value is 1 . if flag is 1 , then nms discovery will override vendor metadata .',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ip` (`mgt_address`),
  KEY `peer` (`peer`),
  KEY `peer_plugin_manager_id` (`peer`,`plugin_manager_id`)
) ENGINE=InnoDB AUTO_INCREMENT=627 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the basic information about Devices.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `deviceinfo` WRITE;
/*!40000 ALTER TABLE `deviceinfo` DISABLE KEYS */;
INSERT INTO `deviceinfo` VALUES (49,'CSVDevice2','01010101',NULL,'','Device Automatically Created By SevOne-dispatchd','',1,1,161,'.1.3.6.1.2.1.1.1.0',0,'2025-11-20 11:32:13','2026-04-30 04:00:04',0,300,1,0,0,0,0,'UTC',-1,-1,1,-1,NULL,'',NULL,'',NULL,NULL,0,0,-1,1,0,1,0,1,1,NULL,NULL,0,0,NULL,NULL,1),(50,'CSVDevice1','01010101',NULL,'','Device Automatically Created By SevOne-dispatchd','',1,1,161,'.1.3.6.1.2.1.1.1.0',0,'2025-11-20 11:32:13','2026-04-30 04:00:04',0,300,1,0,0,0,0,'UTC',-1,-1,1,-1,NULL,'',NULL,'',NULL,NULL,0,0,-1,1,0,1,0,1,1,NULL,NULL,0,0,NULL,NULL,1),(51,'zeu-uk-lon99-b-sla01',NULL,NULL,'','Created by JSON Adpater','zeu-uk-lon99-b-sla01',1,1,161,'.1.3.6.1.2.1.1.1.0',12,'2025-11-24 17:03:23','2026-04-30 04:00:05',0,300,1,0,1,1,1,'America/New_York',-1,-1,1,-1,NULL,'',NULL,'',NULL,NULL,0,0,-1,1,0,1,0,1,1,NULL,NULL,0,0,NULL,NULL,1),(52,'zeu-ch-scun-u310-sla01',NULL,NULL,'','Created by JSON Adpater','zeu-ch-scun-u310-sla01',1,1,161,'.1.3.6.1.2.1.1.1.0',12,'2025-11-24 17:03:24','2026-04-30 04:00:06',0,300,1,0,0,0,1,'Europe/London',-1,-1,1,-1,NULL,'',NULL,'',NULL,NULL,0,0,-1,1,0,1,0,1,1,NULL,NULL,0,0,NULL,NULL,1),(55,'IPSLA Report',NULL,NULL,'','Device Automatically Created By SevOne-dispatchd','',1,1,161,'.1.3.6.1.2.1.1.1.0',0,'2026-01-14 12:00:08','2026-04-30 04:00:08',0,300,1,0,0,0,0,'UTC',-1,-1,1,-1,NULL,'',NULL,'',NULL,NULL,0,0,-1,1,0,1,0,1,1,NULL,NULL,0,0,NULL,NULL,1),(57,'zeu-uk-lon1-b-new01',NULL,NULL,'','Created by JSON Adpater','zeu-uk-lon1-b-new01',1,1,161,'.1.3.6.1.2.1.1.1.0',12,'2026-02-03 09:05:52','2026-04-30 04:00:08',0,300,1,0,0,0,0,'America/New_York',-1,-1,1,-1,NULL,'',NULL,'',NULL,NULL,0,0,-1,1,0,1,0,1,1,NULL,NULL,0,0,NULL,NULL,1),(58,'zeu-ch-scun-u1-new01',NULL,NULL,'','Created by JSON Adpater','zeu-ch-scun-u1-new01',1,1,161,'.1.3.6.1.2.1.1.1.0',12,'2026-02-03 09:05:53','2026-04-30 04:00:08',0,300,1,0,0,0,0,'America/New_York',-1,-1,1,-1,NULL,'',NULL,'',NULL,NULL,0,0,-1,1,0,1,0,1,1,NULL,NULL,0,0,NULL,NULL,1),(59,'zeu-uk-lon2-b-new01',NULL,NULL,'','Created by JSON Adpater','zeu-uk-lon2-b-new01',1,1,161,'.1.3.6.1.2.1.1.1.0',12,'2026-02-03 09:05:53','2026-04-30 04:00:10',0,300,1,0,0,0,0,'America/New_York',-1,-1,1,-1,NULL,'',NULL,'',NULL,NULL,0,0,-1,1,0,1,0,1,1,NULL,NULL,0,0,NULL,NULL,1),(60,'zeu-ch-scun-u2-new01',NULL,NULL,'','Created by JSON Adpater','zeu-ch-scun-u2-new01',1,1,161,'.1.3.6.1.2.1.1.1.0',12,'2026-02-03 09:05:53','2026-04-30 04:00:10',0,300,1,0,0,0,0,'America/New_York',-1,-1,1,-1,NULL,'',NULL,'',NULL,NULL,0,0,-1,1,0,1,0,1,1,NULL,NULL,0,0,NULL,NULL,1),(61,'zeu-uk-lon3-b-new01',NULL,NULL,'','Created by JSON Adpater','zeu-uk-lon3-b-new01',1,1,161,'.1.3.6.1.2.1.1.1.0',12,'2026-02-03 09:05:54','2026-04-30 04:00:10',0,300,1,0,0,0,0,'America/New_York',-1,-1,1,-1,NULL,'',NULL,'',NULL,NULL,0,0,-1,1,0,1,0,1,1,NULL,NULL,0,0,NULL,NULL,1);
/*!40000 ALTER TABLE `deviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deviceips`
--

DROP TABLE IF EXISTS `deviceips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `deviceips` (
  `dev_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `ip` varbinary(40) DEFAULT NULL COMMENT 'The IPv4 address.',
  `netmask` varbinary(40) DEFAULT NULL COMMENT 'The IPv4 netmask.',
  `snmp_object_id` int(11) DEFAULT NULL COMMENT 'The SNMP index (ifIndex) to which this applies.',
  UNIQUE KEY `device_and_ip` (`dev_id`,`ip`),
  KEY `ipkey` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This lists the known IP addresses of a Device, determined through SNMP discovery.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deviceips`
--
-- WHERE:  1 limit 10

LOCK TABLES `deviceips` WRITE;
/*!40000 ALTER TABLE `deviceips` DISABLE KEYS */;
INSERT INTO `deviceips` VALUES (281,'FE80000000000000C4DA47FF0FE5E19D','FFFFFFFFFFFFFFFF0000000000000000',36),(281,'FE8000000000000066A162A5F6EE307F','FFFFFFFFFFFFFFFF0000000000000000',2),(281,'FE80000000000000034394FFFEBFAD17','FFFFFFFFFFFFFFFF0000000000000000',6),(281,'FE80000000000000345C69FFFE740A0B','FFFFFFFFFFFFFFFF0000000000000000',3),(281,'FE8000000000000040CD78FFFE19786A','FFFFFFFFFFFFFFFF0000000000000000',8),(281,'FE8000000000000014DD61FFFE8141AF','FFFFFFFFFFFFFFFF0000000000000000',39),(281,'0A580001','FFFF0000',3),(281,'00000000000000000000000000000001','FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF',1),(281,'7F000001','FF000000',1),(281,'0A161F04','FFFFF000',2);
/*!40000 ALTER TABLE `deviceips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deviceipsinfo`
--

DROP TABLE IF EXISTS `deviceipsinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `deviceipsinfo` (
  `dev_id` int(11) NOT NULL COMMENT 'The ID of the device foreignKey: net.deviceinfo.id',
  `ips_update_time` double NOT NULL DEFAULT 0 COMMENT 'ips_update_time',
  `ips15min` double NOT NULL DEFAULT 0 COMMENT 'ips15min',
  `ips1hour` double NOT NULL DEFAULT 0 COMMENT 'ips1hour',
  `ips2hour` double NOT NULL DEFAULT 0 COMMENT 'ips2hour',
  `ips6hour` double NOT NULL DEFAULT 0 COMMENT 'ips6hour',
  `ips24hour` double NOT NULL DEFAULT 0 COMMENT 'ips24hour',
  `ips7day` double NOT NULL DEFAULT 0 COMMENT 'ips7day',
  `backfilled_ips15min` double NOT NULL DEFAULT 0 COMMENT 'backfilled_ips15min',
  `backfilled_ips1hour` double NOT NULL DEFAULT 0 COMMENT 'backfilled_ips1hour',
  `backfilled_ips2hour` double NOT NULL DEFAULT 0 COMMENT 'backfilled_ips2hour',
  `backfilled_ips6hour` double NOT NULL DEFAULT 0 COMMENT 'backfilled_ips6hour',
  `backfilled_ips24hour` double NOT NULL DEFAULT 0 COMMENT 'backfilled_ips24hour',
  `backfilled_ips7day` double NOT NULL DEFAULT 0 COMMENT 'backfilled_ips7day',
  PRIMARY KEY (`dev_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores information about indicators per second of each Devices.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deviceipsinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `deviceipsinfo` WRITE;
/*!40000 ALTER TABLE `deviceipsinfo` DISABLE KEYS */;
INSERT INTO `deviceipsinfo` VALUES (49,1777543200.000114,0,0,0,0,0,0,0,0,0,0,0,0),(50,1777543200.000114,0,0,0,0,0,0,0,0,0,0,0,0),(51,1777543200.000114,0,0,0,0,0,0,0,0,0,0,0,0),(52,1777543200.000114,0.64,0.64,0.64,0.64,0.64,0.639683,0,0,0,0,0,0),(55,1777543200.000114,0,0,0,0,0,0,0,0,0,0,0,0),(57,1777543200.000114,0.64,0.64,0.64,0.64,0.64,0.64,0,0,0,0,0,0),(58,1777543200.000114,0.64,0.64,0.64,0.64,0.64,0.64,0,0,0,0,0,0),(59,1777543200.000114,0.64,0.64,0.64,0.64,0.64,0.639683,0,0,0,0,0,0),(60,1777543200.000114,0.64,0.64,0.64,0.64,0.64,0.64,0,0,0,0,0,0),(61,1777543200.000114,0.64,0.64,0.64,0.64,0.64,0.639683,0,0,0,0,0,0);
/*!40000 ALTER TABLE `deviceipsinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devicelock`
--

DROP TABLE IF EXISTS `devicelock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `devicelock` (
  `dev_id` int(11) NOT NULL COMMENT 'The Device that is locked. foreignKey: net.deviceinfo.id',
  `process` varchar(255) DEFAULT NULL COMMENT 'The name of the process that owns the lock.',
  `lock_time` int(11) DEFAULT NULL COMMENT 'The time at which the Device was locked (epoch).',
  PRIMARY KEY (`dev_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table is responsible for ''locking'' a Device so that other processes may not manipulate it.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devicelock`
--
-- WHERE:  1 limit 10

LOCK TABLES `devicelock` WRITE;
/*!40000 ALTER TABLE `devicelock` DISABLE KEYS */;
/*!40000 ALTER TABLE `devicelock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devicemove`
--

DROP TABLE IF EXISTS `devicemove`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `devicemove` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `dev_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `source_peer` int(11) DEFAULT NULL COMMENT ' foreignKey: net.peers.server_id',
  `destination_peer` int(11) DEFAULT NULL COMMENT ' foreignKey: net.peers.server_id',
  `move_data` int(11) DEFAULT 1 COMMENT 'Which data to move',
  `move_notes` int(11) DEFAULT 1 COMMENT 'Notes about this move',
  `move_log` int(11) DEFAULT 1 COMMENT 'The log of this move',
  `restore_discovery_allow_automatic_to` int(11) NOT NULL DEFAULT 1 COMMENT 'What should the automatic setting for discovery be set to',
  `restore_discovery_allow_manual_to` int(11) NOT NULL DEFAULT 1 COMMENT 'What should the manual setting for discovery be set to',
  `time_added` int(11) DEFAULT 0 COMMENT 'Time this move was added',
  `time_started` int(11) DEFAULT 0 COMMENT 'The the move was started',
  `time_finished` int(11) DEFAULT 0 COMMENT 'Time the move was finished',
  `is_ready` int(11) DEFAULT 0 COMMENT 'If this device is ready to be moved',
  `is_completed` int(11) DEFAULT 0 COMMENT 'Is this move complete',
  `is_working` int(11) DEFAULT 0 COMMENT 'Is the move currently active',
  `failed` tinyint(4) DEFAULT 0 COMMENT 'Did this job fail',
  `failed_reason` enum('PEER_HEALTH','PEER_LOCK_ON_DEVICE','DEVICE_MOVE_INFO_INCORRECT','PEER_REPLICATION','PEER_DIVERGENCE','PEER_DB_CONNECTIVITY','PEER_DESTINATION_IP','DEVICE_CONNECTIVITY_FROM_DESTINATION') DEFAULT NULL COMMENT 'reason for failure',
  `override` int(11) DEFAULT 0 COMMENT 'Force device move done by user if device health fail',
  PRIMARY KEY (`id`),
  UNIQUE KEY `dev_id` (`dev_id`),
  KEY `is_completed` (`is_completed`),
  KEY `is_ready` (`is_ready`),
  KEY `is_working` (`is_working`),
  KEY `source_peer` (`source_peer`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Device Move Jobs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devicemove`
--
-- WHERE:  1 limit 10

LOCK TABLES `devicemove` WRITE;
/*!40000 ALTER TABLE `devicemove` DISABLE KEYS */;
/*!40000 ALTER TABLE `devicemove` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devicename_masks`
--

DROP TABLE IF EXISTS `devicename_masks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `devicename_masks` (
  `string` varchar(255) DEFAULT NULL COMMENT 'string',
  `num` int(11) NOT NULL COMMENT 'num'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the basic information about Device name masks.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devicename_masks`
--
-- WHERE:  1 limit 10

LOCK TABLES `devicename_masks` WRITE;
/*!40000 ALTER TABLE `devicename_masks` DISABLE KEYS */;
INSERT INTO `devicename_masks` VALUES ('\\.sevone\\.com$',1);
/*!40000 ALTER TABLE `devicename_masks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devicetag_topologysource_map`
--

DROP TABLE IF EXISTS `devicetag_topologysource_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `devicetag_topologysource_map` (
  `devicetag_id` int(11) NOT NULL COMMENT 'The ID of the device type associated with source. foreignKey: net.devicetags.id',
  `source_id` int(11) NOT NULL COMMENT 'This is the ID of the Topology Source. foreignKey: net.topology_sources.id',
  `is_enabled` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if the tuple (devicetag, topologysource) is enabled; 0 otherwise.',
  PRIMARY KEY (`devicetag_id`,`source_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table gives control to user to specify which devices to have topology discovery, by specifying device type and topology source';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devicetag_topologysource_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `devicetag_topologysource_map` WRITE;
/*!40000 ALTER TABLE `devicetag_topologysource_map` DISABLE KEYS */;
INSERT INTO `devicetag_topologysource_map` VALUES (42,7,0),(42,1,1),(42,2,1),(42,3,1),(42,4,1),(42,5,1),(42,6,1),(42,8,1),(42,9,1),(42,11,1);
/*!40000 ALTER TABLE `devicetag_topologysource_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devicetags`
--

DROP TABLE IF EXISTS `devicetags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `devicetags` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `lft` int(11) unsigned DEFAULT NULL COMMENT 'The left boundary of the set (nested set model)',
  `rgt` int(11) unsigned DEFAULT NULL COMMENT 'The right boundary of the set (nested set model)',
  `parent_id` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'The direct parent of this node (de-normalized from lft, rgt, depth). Root node has parent_id 0. foreignKey: net.devicetags.id',
  `sets` geometry NOT NULL COMMENT 'The line extending from points (-1, lft) to (1,rgt) used for down-up lookups. De-normalized value built from lft and rgt columns.',
  `depth` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'The depth of the node from the tree root (de-normalized for lft and rgt columns).',
  `name` varchar(128) DEFAULT NULL COMMENT 'The human-readable name of the device group.',
  `readonly` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Boolean flag used to mark a device tag read-only.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `lft` (`lft`),
  UNIQUE KEY `uniquecheck` (`parent_id`,`name`),
  KEY `depth` (`depth`),
  KEY `parent_id` (`parent_id`),
  SPATIAL KEY `sets` (`sets`)
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This describes the individual nodes in the device group tree. The tree is stored as a nested set model with normalized columns id, name, lft, and rgt. The depth, parent_id, and sets columns are de-normalized fields to facilitate up-down and left-right tree-traversal since such operations are costly with only the normalized fields.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devicetags`
--
-- WHERE:  1 limit 10

LOCK TABLES `devicetags` WRITE;
/*!40000 ALTER TABLE `devicetags` DISABLE KEYS */;
