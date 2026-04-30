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
INSERT INTO `devicetags` VALUES (1,1,440,0,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð¿\0\0\0\0\0\0ð?\0\0\0\0\0\0ð?\0\0\0\0\0€{@',0,'SevOne:root',0),(2,2,191,1,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð¿\0\0\0\0\0\0\0@\0\0\0\0\0\0ð?\0\0\0\0\0àg@',1,'All Device Groups',0),(3,3,4,2,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð¿\0\0\0\0\0\0@\0\0\0\0\0\0ð?\0\0\0\0\0\0@',2,'Location',0),(4,5,12,2,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð¿\0\0\0\0\0\0@\0\0\0\0\0\0ð?\0\0\0\0\0\0(@',2,'Type',0),(6,6,7,4,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð¿\0\0\0\0\0\0@\0\0\0\0\0\0ð?\0\0\0\0\0\0@',3,'Router',0),(7,8,9,4,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð¿\0\0\0\0\0\0 @\0\0\0\0\0\0ð?\0\0\0\0\0\0\"@',3,'Switch',0),(8,10,11,4,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð¿\0\0\0\0\0\0$@\0\0\0\0\0\0ð?\0\0\0\0\0\0&@',3,'Server',0),(10,13,14,2,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð¿\0\0\0\0\0\0*@\0\0\0\0\0\0ð?\0\0\0\0\0\0,@',2,'Unclassified',0),(11,15,46,2,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð¿\0\0\0\0\0\0.@\0\0\0\0\0\0ð?\0\0\0\0\0\0G@',2,'Manufacturer',0),(12,16,17,11,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ð¿\0\0\0\0\0\00@\0\0\0\0\0\0ð?\0\0\0\0\0\01@',3,'SevOne',0);
/*!40000 ALTER TABLE `devicetags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devicetrapdestination`
--

DROP TABLE IF EXISTS `devicetrapdestination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `devicetrapdestination` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `dev_id` int(10) DEFAULT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `trap_destination_id` int(10) DEFAULT NULL COMMENT ' foreignKey: net.trapdestination.id',
  `is_discovered` smallint(6) DEFAULT 0 COMMENT '1 if this relationship was determined by discovery; 0 if it was determined by a user.',
  `is_enabled` smallint(6) DEFAULT 0 COMMENT '1 to actually use this trap destination for the Device; 0 to pretend like it doesn''t exist.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `dev_key` (`dev_id`,`trap_destination_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table maps a Device to trap destinations.  Trap destinations may be manually applied, or they may be determined automatically at discovery time.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devicetrapdestination`
--
-- WHERE:  1 limit 10

LOCK TABLES `devicetrapdestination` WRITE;
/*!40000 ALTER TABLE `devicetrapdestination` DISABLE KEYS */;
/*!40000 ALTER TABLE `devicetrapdestination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discovery_hook_type`
--

DROP TABLE IF EXISTS `discovery_hook_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `discovery_hook_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(50) NOT NULL COMMENT 'Hook type name',
  `insert_allowed` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Flag if hook of this type could be inserted.',
  `delete_allowed` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Flag if hook of this type could be deleted.',
  `update_allowed` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Flag if hook of this type could be updated.',
  `read_allowed` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Flag if hook of this type could be read.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This lists the discovery hook types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discovery_hook_type`
--
-- WHERE:  1 limit 10

LOCK TABLES `discovery_hook_type` WRITE;
/*!40000 ALTER TABLE `discovery_hook_type` DISABLE KEYS */;
INSERT INTO `discovery_hook_type` VALUES (1,'sevone',0,0,1,1),(2,'sitespecific',1,1,1,1);
/*!40000 ALTER TABLE `discovery_hook_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discovery_hooks`
--

DROP TABLE IF EXISTS `discovery_hooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `discovery_hooks` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `filename` varchar(255) NOT NULL COMMENT 'Hook filename',
  `date_added` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Date of installation.',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Flag if the hook is enabled.',
  `md5_checksum` varchar(128) NOT NULL COMMENT 'The md5 checksum of the installed file.',
  `level` enum('ObjectType','ObjectGroup','DeviceTag') NOT NULL DEFAULT 'DeviceTag' COMMENT 'The hook working level.',
  `ids` varchar(255) DEFAULT NULL COMMENT 'The ids form of type level for which the hook will work. all - for all ids.',
  `discovery_hook_type_id` int(11) NOT NULL DEFAULT 1 COMMENT 'Refecrence to the type of the hook (sevone, sitespecific). foreignKey: net.discovery_hook_type.id',
  `profiler_enabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'The md5 checksum of the installed file.',
  `priority` varchar(50) NOT NULL DEFAULT '1' COMMENT 'The hook''s priority.',
  `args` varchar(1024) NOT NULL DEFAULT '' COMMENT 'The hook''s arguments.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniquecheck` (`filename`)
) ENGINE=MyISAM AUTO_INCREMENT=3615 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This lists the installed discovery hooks.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discovery_hooks`
--
-- WHERE:  1 limit 10

LOCK TABLES `discovery_hooks` WRITE;
/*!40000 ALTER TABLE `discovery_hooks` DISABLE KEYS */;
INSERT INTO `discovery_hooks` VALUES (1,'HelloWorld','2023-08-09 21:48:44',0,'c834a32bc61d04a2abc3561299bcde8d','DeviceTag','all',1,1,'1','{\"testArgs\":23}'),(3613,'CheckHSAConnectivityDeviceHookv8','2026-04-26 00:00:08',0,'6905d37a7cd047f6ba60ebbd0d59820d','DeviceTag','all',2,0,'1','{}'),(3614,'SetQoSDeviceHookv8','2026-04-26 00:00:11',0,'df7335531a4b3898e0772be5260efd5b','DeviceTag','all',2,0,'1','{\"objectTypeName\":\"QoS\"}'),(3611,'SetViptelaDeviceHookV8','2026-04-26 00:00:04',0,'536626526668f3e5646db52b27df018f','DeviceTag','all',2,0,'1','{\"objectTypeName\":\"Interface (Viptela)\"}'),(3612,'SetADSLDeviceHookv8','2026-04-26 00:00:06',0,'f1fe54cfc3438a17e85fd387ab13e530','DeviceTag','all',2,0,'1','{\"objectTypeName\":\"Interface\"}'),(3586,'DeviceMetadataUpdate','2026-03-11 16:43:20',1,'4d934c6cbdc607cb84366113f22cbcd5','DeviceTag','all',2,0,'1','{\"deviceTypeName\":\"Linux (Net-SNMP)\"}');
/*!40000 ALTER TABLE `discovery_hooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discoverydeviceinfo`
--

DROP TABLE IF EXISTS `discoverydeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `discoverydeviceinfo` (
  `device_id` int(11) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `allow_automatic` tinyint(4) DEFAULT 1 COMMENT '1 if this Device may be scheduled for normal, ''nightly'' discovery; 0 otherwise.',
  `allow_manual` tinyint(4) DEFAULT 1 COMMENT '1 if this Device may be manually scheled for discovery (including on-demand actions like saving or adding Objects); 0 otherwise.',
  `log_level` tinyint(4) NOT NULL DEFAULT -1 COMMENT 'The syslog level to use when discovering this Device.  Use -1 if you want to use the global setting instead.',
  `queue` enum('','high','low','cancel') NOT NULL COMMENT 'If this Device is queued for discovery, then this will be set to ''high'' or ''low''.',
  `is_working` tinyint(4) DEFAULT 0 COMMENT '1 if this Device is currently being discovered; 0 otherwise.',
  `time_queued` int(11) DEFAULT 0 COMMENT 'The time at which this Device was queued for discovery (epoch).',
  `time_updated` int(11) DEFAULT 0 COMMENT 'The time at which this Device''s discovery information (priority, in particular) was last updated (epoch).',
  `time_started` int(11) DEFAULT 0 COMMENT 'The time at which this Device began discovery (epoch).',
  `time_completed` int(11) DEFAULT 0 COMMENT 'The time at which this Device completed discovery (epoch).',
  `times_discovered` int(11) DEFAULT 0 COMMENT 'The number of times that this Device was successfully discovered; this will be updated when ''time_completed'' is updated.',
  PRIMARY KEY (`device_id`),
  KEY `queue` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines the discovery information and status for a Device.  A Device MUST have an entry in this table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discoverydeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `discoverydeviceinfo` WRITE;
/*!40000 ALTER TABLE `discoverydeviceinfo` DISABLE KEYS */;
INSERT INTO `discoverydeviceinfo` VALUES (49,1,1,-1,'',0,1777521602,1777521602,1777521603,1777521604,141),(50,1,1,-1,'',0,1777521602,1777521602,1777521603,1777521604,141),(51,1,1,-1,'',0,1777521602,1777521602,1777521603,1777521605,1357),(52,1,1,-1,'',0,1777521602,1777521602,1777521605,1777521606,1602),(55,1,1,-1,'',0,1777521602,1777521602,1777521607,1777521608,105),(57,1,1,-1,'',0,1777521602,1777521602,1777521607,1777521608,303),(58,1,1,-1,'',0,1777521602,1777521602,1777521607,1777521608,303),(59,1,1,-1,'',0,1777521602,1777521602,1777521609,1777521610,303),(60,1,1,-1,'',0,1777521602,1777521602,1777521609,1777521610,302),(61,1,1,-1,'',0,1777521602,1777521602,1777521609,1777521610,302);
/*!40000 ALTER TABLE `discoverydeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dispatch_deviceinfo`
--

DROP TABLE IF EXISTS `dispatch_deviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispatch_deviceinfo` (
  `dev_id` int(10) unsigned NOT NULL COMMENT 'The ID of the device foreignKey: net.deviceinfo.id',
  `dispatch_identifier` varchar(1024) NOT NULL COMMENT 'The dispatch indentifier.',
  UNIQUE KEY `identifier` (`dispatch_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='net.dispatch_deviceinfo stores the SevOne-dispatchd information about Devices.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispatch_deviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `dispatch_deviceinfo` WRITE;
/*!40000 ALTER TABLE `dispatch_deviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispatch_deviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ext_asn`
--

DROP TABLE IF EXISTS `ext_asn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ext_asn` (
  `asn` int(11) NOT NULL COMMENT 'The autonomous system code',
  `country` varchar(2) NOT NULL COMMENT 'The country of the autonomous system',
  `type` varchar(64) NOT NULL COMMENT 'The type of the autonomous system',
  `name` varchar(128) NOT NULL COMMENT 'The name of the autonomous system',
  `domain` varchar(128) NOT NULL COMMENT 'The domain of the autonomous system',
  PRIMARY KEY (`asn`)
) ENGINE=CONNECT DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table holds autonomous system (AS) lookup values' `file_name`='/var/lib/mysql-files/external/asn.csv' `header`=0 `quoted`=0 `sep_char`=',' `table_type`=CSV;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ext_asn_ip_range`
--

DROP TABLE IF EXISTS `ext_asn_ip_range`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ext_asn_ip_range` (
  `id` int(11) NOT NULL COMMENT 'id',
  `ip_from` varchar(32) NOT NULL COMMENT 'The hex string representation of the ip4/ip6 from address',
  `ip_to` varchar(32) NOT NULL COMMENT 'The hex string representation of the ip4/ip6 to address',
  `asn` int(11) NOT NULL COMMENT 'The autonomous system code',
  PRIMARY KEY (`id`),
  KEY `asn` (`asn`)
) ENGINE=CONNECT DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table holds autonomous system (AS) ip4/ip6 ranges' `file_name`='/var/lib/mysql-files/external/asn_ip_range.csv' `header`=0 `quoted`=0 `sep_char`=',' `table_type`=CSV;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ext_devicefingerprints`
--

DROP TABLE IF EXISTS `ext_devicefingerprints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ext_devicefingerprints` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key id ',
  `vendorname` varchar(255) NOT NULL COMMENT 'Vendor name',
  `fingerprint` text NOT NULL COMMENT 'Finger Print Regex',
  PRIMARY KEY (`id`),
  UNIQUE KEY `vendor` (`vendorname`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table stores information regarding vendor';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ext_devicefingerprints`
--
-- WHERE:  1 limit 10

LOCK TABLES `ext_devicefingerprints` WRITE;
/*!40000 ALTER TABLE `ext_devicefingerprints` DISABLE KEYS */;
INSERT INTO `ext_devicefingerprints` VALUES (1,'Juniper','^Juniper Networks, Inc. (?:(?:Dell|DELL) )?(?<model>\\S+).*, kernel (?<os_family>\\S+?) (?<os_version>\\S+?),? |^Juniper Networks, Inc. (?<model>\\S+) Edge Routing Switch SW Version : ((?<os_version>\\S+) \\S+ [BuildId \\d+])|^Juniper Networks (\\S+(?: \\S+)?) Switch, SW Version (\\S+)$|(?<os_family>BXOS) (?<model>([\\w]+)) (?<os_version>([\\w.]+))|^(?<model>\\S+) version (?<os_version>([\\w.]+)).*'),(2,'Cisco','^Cisco (?<os_family>(Internetwork Operating System|Adaptive Security Appliance|NX-OS|IOS XR|IOS|IOS-XE|Catalyst|ISR|Nexus))(?:.*?), Version (?<os_version>[^\\s,]+)'),(3,'Linux','^(?<os_family>Linux|SONiC) (?:Software Version:|(.*?))(?<os_version>[0-9]+(?:\\.[0-9]+){2}(?:-[\\w.-]+)?(?:\\.[\\w.-]+)?)'),(4,'VMware','^VMware (?<os_family>(.*)) (?<os_version>(\\d.\\d+.\\d+)) build-\\d+ VMware, Inc. (\\S+)$'),(5,'Nokia','^(?<os_family>(TiMOS))-\\w-(?<os_version>([0-9.\\w]+))'),(6,'IBM','^(?<os_family>Linux) (.*?) (?<os_version>([0-9]+.[0-9]+.[0-9]+S*)).* (?:[0-9]{4}|[A-Z][A-Z][A-Z]{1,2}|+[0-9]+|Local time.*(?:manual|zic|mS*)) (S+)'),(7,'Microsoft','Software: (?<os_family>(Windows.*)) Version (?<os_version>([\\w.]+))'),(8,'F5','(?<model>(BIG-IP [\\w]+)) : .*(?<os_family>(BIG-IP)) software release (?<os_version>([\\w.]+))'),(9,'Aruba','^(?<os_family>ArubaOS).*MODEL: (?<model>([\\w\\-\\_.]+))\\), Version (?<os_version>([\\w.]+))|^(?<os_family_1>Aruba) (?<model_1>([\\w\\-\\_.\\s\\(\\)]+)), .*Version (?<os_version_1>([\\w.]+))'),(10,'DrayTek','Model: (?<model>([\\w]+)), Version: (?<os_version>([\\w.]+)),');
/*!40000 ALTER TABLE `ext_devicefingerprints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ext_enterprisenumbers`
--

DROP TABLE IF EXISTS `ext_enterprisenumbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ext_enterprisenumbers` (
  `enterprisenumber` int(11) unsigned NOT NULL COMMENT 'Primary Key the enterprisenumber',
  `organisation` varchar(255) DEFAULT NULL COMMENT 'organisation name',
  `contact` varchar(255) DEFAULT NULL COMMENT 'contact person',
  `emailaddress` varchar(255) DEFAULT NULL COMMENT 'contact person email address',
  `shortname` varchar(255) DEFAULT NULL COMMENT 'short name provided by IBM SevOne',
  PRIMARY KEY (`enterprisenumber`),
  UNIQUE KEY `organisation` (`organisation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the information about enterprisenumbers. The first 4 fields will always be taken directly from the IANA master source file. The shortname field is SevOne proprietary and will be populated by us (as and when needed).';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ext_enterprisenumbers`
--
-- WHERE:  1 limit 10

LOCK TABLES `ext_enterprisenumbers` WRITE;
/*!40000 ALTER TABLE `ext_enterprisenumbers` DISABLE KEYS */;
INSERT INTO `ext_enterprisenumbers` VALUES (0,'Reserved','Internet Assigned Numbers Authority','iana&iana.org',NULL),(1,'NxNetworks','Michael Kellen','OID.Admin&NxNetworks.com',NULL),(2,'IBM (https://w3.ibm.com/standards )','Glenn Daly','gdaly&us.ibm.com','IBM'),(3,'Carnegie Mellon','Mark Poepping','host-master&andrew.cmu.edu',NULL),(4,'Unix','Keith Sklower','sklower&okeeffe.berkeley.edu',NULL),(5,'ACC','Art Berggreen','art&SALT.ACC.COM',NULL),(6,'TWG','John Lunny','jlunny&eco.twg.com',NULL),(7,'CAYMAN','Beth Miaoulis','beth&cayman.com',NULL),(8,'PSI','Marty Schoffstahl','schoff&NISC.NYSER.NET',NULL),(9,'ciscoSystems','Dave Jones','davej&cisco.com','Cisco');
/*!40000 ALTER TABLE `ext_enterprisenumbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ext_flow_service_categories`
--

DROP TABLE IF EXISTS `ext_flow_service_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ext_flow_service_categories` (
  `id` int(11) NOT NULL COMMENT 'Primary Key',
  `vendor_id` int(10) NOT NULL DEFAULT 0 COMMENT 'This is the third-party vendor id (SevOne = 0)',
  `vendor_category_id` int(10) NOT NULL DEFAULT 0 COMMENT 'This is the category id assigned by the third-party vendor',
  `service_category_name` varchar(64) NOT NULL DEFAULT '' COMMENT 'This is the name of the App Category.',
  `service_category_desc` varchar(128) NOT NULL DEFAULT '' COMMENT 'This is the description of the App Category.',
  `deprecation_date` datetime DEFAULT NULL COMMENT 'A deprecated category will not be used to stamp new flow.  It only provides report resolution.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `service_category_name` (`service_category_name`),
  UNIQUE KEY `vendor` (`vendor_id`,`vendor_category_id`)
) ENGINE=CONNECT DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines app categories for app profiles' `file_name`='/var/lib/mysql-files/external/flow_service_categories.csv' `header`=0 `quoted`=1 `sep_char`=',' `table_type`=CSV;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ext_flow_service_ip_range`
--

DROP TABLE IF EXISTS `ext_flow_service_ip_range`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ext_flow_service_ip_range` (
  `id` int(11) NOT NULL COMMENT 'Primary Key',
  `vendor_id` int(10) NOT NULL DEFAULT 0 COMMENT 'This is the third-party vendor id (SevOne = 0)',
  `vendor_application_id` int(10) NOT NULL DEFAULT 0 COMMENT 'This is application id assigned by the the third-party',
  `ip_from` varchar(32) NOT NULL DEFAULT '' COMMENT 'The hex representation of the ip4/ip6 from address using INET6_ATON',
  `ip_to` varchar(32) NOT NULL DEFAULT '' COMMENT 'The hex representation of the ip4/ip6 to address using INET6_ATON',
  PRIMARY KEY (`id`),
  KEY `vendor` (`vendor_id`,`vendor_application_id`)
) ENGINE=CONNECT DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the ip range rules of the flow_services system for NetFlow.' `file_name`='/var/lib/mysql-files/external/flow_service_ip_range.csv' `header`=0 `quoted`=0 `sep_char`=',' `table_type`=CSV;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ext_flow_service_logos`
--

DROP TABLE IF EXISTS `ext_flow_service_logos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ext_flow_service_logos` (
  `id` int(11) NOT NULL COMMENT 'Primary Key',
  `vendor_id` int(10) NOT NULL DEFAULT 0 COMMENT 'This is the third-party vendor id (SevOne = 0)',
  `vendor_application_id` int(10) NOT NULL DEFAULT 0 COMMENT 'This is application id assigned by the the third-party',
  `vendor_logo_uri` varchar(16360) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '' COMMENT 'This is the image/png base64 URI of the logo.',
  PRIMARY KEY (`id`),
  KEY `vendor` (`vendor_id`,`vendor_application_id`)
) ENGINE=CONNECT DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the flow service app logos for NetFlow.' `file_name`='/var/lib/mysql-files/external/flow_service_logos.json' `lrecl`=16384 `option_list`='pretty=0' `table_type`=JSON;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ext_flow_service_profiles`
--

DROP TABLE IF EXISTS `ext_flow_service_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ext_flow_service_profiles` (
  `id` int(11) NOT NULL COMMENT 'Primary Key',
  `vendor_id` int(10) NOT NULL DEFAULT 0 COMMENT 'This is the third-party vendor id (SevOne = 0)',
  `vendor_application_id` int(10) NOT NULL DEFAULT 0 COMMENT 'This is the application id assigned by the third-party vendor',
  `service_category_id` int(11) NOT NULL DEFAULT 1 COMMENT 'Foreign key to the net.ext_flow_service_categories table foreignKey: net.ext_flow_service_categories.id',
  `service_name` varchar(64) NOT NULL DEFAULT '' COMMENT 'This is the name of the App Profile.  This is typically short.',
  `service_desc` varchar(256) DEFAULT '' COMMENT 'This is the description of the App Profile.  This is typically long.',
  `deprecation_date` datetime DEFAULT NULL COMMENT 'A deprecated profile will not be used to stamp new flow.  It only provides report resolution.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`service_name`),
  UNIQUE KEY `vendor` (`vendor_id`,`vendor_application_id`)
) ENGINE=CONNECT DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines app profiles for apps and applications' `file_name`='/var/lib/mysql-files/external/flow_service_profiles.csv' `header`=0 `quoted`=1 `sep_char`=',' `table_type`=CSV;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ext_sysobjectids`
--

DROP TABLE IF EXISTS `ext_sysobjectids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ext_sysobjectids` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key id ',
  `sysobjectid` varchar(255) DEFAULT NULL COMMENT 'sysobjectid',
  `snmpobjectname` varchar(255) DEFAULT NULL COMMENT 'object name',
  `snmpobjectdescription` varchar(255) DEFAULT NULL COMMENT 'object description',
  `productshortname` varchar(255) DEFAULT NULL COMMENT 'product short name',
  `type` varchar(255) DEFAULT NULL COMMENT 'Device Types',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33356 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table stores information regarding sysObjectId for SNMP devices';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ext_sysobjectids`
--
-- WHERE:  1 limit 10

LOCK TABLES `ext_sysobjectids` WRITE;
/*!40000 ALTER TABLE `ext_sysobjectids` DISABLE KEYS */;
INSERT INTO `ext_sysobjectids` VALUES (1,'1.3.6.1.4.1.10418.16.1.1',NULL,NULL,'CYCLADES ACS 6016','Module'),(2,'1.3.6.1.4.1.11.2.14.10.2.10','icfVgRepeaterMib',NULL,'ICFVGREPEATERMIB','Router'),(3,'1.3.6.1.4.1.10418.16.1.2',NULL,NULL,'CYCLADES ACS 6032','Terminal Server'),(4,'1.3.6.1.4.1.11.2.14.11.7.1.4.1','hpSRPowerSupply8756A','HP J8754A Secure Router 7306dl powersupply','HPSRPOWERSUPPLY8756A','Router'),(5,'1.3.6.1.4.1.11.2.3.7.11.34.1','hpSwitchModuleJ4900A','J4900A HP 2626 24-port 10/100-T + 2-port Gig module','HPSWITCHMODULEJ4900A','Switch'),(6,'1.3.6.1.4.1.10418.16.1.3',NULL,NULL,'CYCLADES ACS 6048','Terminal Server'),(7,'1.3.6.1.4.1.11.2.14.10.2.11','hpicfVgRptrMib',NULL,'HPICFVGRPTRMIB','Module'),(8,'1.3.6.1.4.1.11.2.14.11.7.2','hpWANModules',NULL,'HPWANMODULES','Module'),(9,NULL,NULL,'- 1 path attribute flag octet',NULL,NULL),(10,'1.3.6.1.4.1.11.2.3.7.11.126.1','hpSwitchModuleJ9587','HP E3800-24G-PoE+-2XG Switch','HPSWITCHMODULEJ9587','Switch');
/*!40000 ALTER TABLE `ext_sysobjectids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ext_vendors`
--

DROP TABLE IF EXISTS `ext_vendors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ext_vendors` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key the ID',
  `vendorname` varchar(255) DEFAULT NULL COMMENT 'vendor name',
  `vendorprimarywww` varchar(255) DEFAULT NULL COMMENT 'primary url',
  `vendorsupportwww` varchar(255) DEFAULT NULL COMMENT 'support url',
  `vendorwarrantycheck` varchar(255) DEFAULT NULL COMMENT 'warranty check url',
  `vendorwikiwww` varchar(255) DEFAULT NULL COMMENT 'wiki url',
  PRIMARY KEY (`id`),
  UNIQUE KEY `vendorname` (`vendorname`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the information about vendors.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ext_vendors`
--
-- WHERE:  1 limit 10

LOCK TABLES `ext_vendors` WRITE;
/*!40000 ALTER TABLE `ext_vendors` DISABLE KEYS */;
INSERT INTO `ext_vendors` VALUES (1,'Cisco','https://www.cisco.com/','https://www.cisco.com/c/en/us/support/all-products.html','https://connectthedots.cisco.com/connectdots/serviceWarrantyFinderRequest?fl=sf','https://en.wikipedia.org/wiki/Cisco'),(2,'Juniper','https://www.juniper.net/','https://support.juniper.net/','https://entitlementsearch.juniper.net/entitlementsearch/','https://en.wikipedia.org/wiki/Juniper_Networks'),(3,'VMware','https://www.vmware.com/','https://customerconnect.vmware.com/',NULL,'https://en.wikipedia.org/wiki/VMware'),(4,'Nokia','https://www.nokia.com/','https://www.nokia.com/networks/business-support/',NULL,'https://en.wikipedia.org/wiki/Nokia'),(5,'IBM','https://www.ibm.com/','https://www.ibm.com/mysupport/',NULL,'https://en.wikipedia.org/wiki/IBM'),(6,'Microsoft','https://www.microsoft.com/','https://support.microsoft.com/',NULL,'https://en.wikipedia.org/wiki/Microsoft'),(7,'F5','https://www.f5.com/','https://www.f5.com/support',NULL,'https://en.wikipedia.org/wiki/F5,_Inc.'),(8,'Aruba','https://www.arubanetworks.com/','https://networkingsupport.hpe.com/',NULL,'https://en.wikipedia.org/wiki/Aruba_Networks'),(9,'DrayTek','https://www.draytek.com/','https://www.draytek.com/support',NULL,'https://en.wikipedia.org/wiki/DrayTek'),(10,'Ruckus Wireless, Inc.','https://www.ruckusnetworks.com/','https://www.ruckusnetworks.com/support/',NULL,'https://en.wikipedia.org/wiki/Ruckus_Networks');
/*!40000 ALTER TABLE `ext_vendors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_rules`
--

DROP TABLE IF EXISTS `flow_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_rules` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Auto increment Id',
  `resource_type` enum('DEVICE','DEVICEGROUP') DEFAULT 'DEVICE' COMMENT 'Enumeration that indicates rules is with DEVICE or DEVICEGROUP',
  `peer_id` int(11) DEFAULT 0 COMMENT 'This represents the peer id. foreignKey: net.peers.server_id',
  `device_ip` varbinary(64) DEFAULT NULL COMMENT 'The IPv4 / IPv6 address of the device originating the flows.',
  `device_group_id` int(11) DEFAULT NULL COMMENT 'An integer representing the device group id. foreignKey: net.devicetags.id',
  `interface_number` bigint(20) NOT NULL DEFAULT -1 COMMENT 'The integer representing the interface generating flows for the given source_ip.',
  `direction` int(11) DEFAULT -1 COMMENT 'An integer representing the direction the the flow in/out of the given interface for a given source_ip.  Undefined = -1, Incoming = 1 Outgoing = 2.',
  `permission` int(11) DEFAULT 0 COMMENT 'Boolean that indicates if the given device_ip/interface/direction is permitted to record flows. 0 = Not Permitted, 1 = Permitted.',
  `reapply_enabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Boolean that indicates if flow rule is reapplied or not.',
  `object_group_id` int(11) NOT NULL DEFAULT -1 COMMENT 'An integer representing the object group id. foreignKey: net.objectgroupinfo.id',
  `interface_resource_type` enum('INTERFACE','OBJECTGROUP') DEFAULT 'INTERFACE' COMMENT 'Enumeration that indicates resource type is with INTERFACE or OBJECTGROUP',
  `priority` smallint(2) NOT NULL DEFAULT 2 COMMENT 'Enumeration that indicates priority of a rule',
  `rank` int(12) NOT NULL DEFAULT 0 COMMENT 'Enumeration that indicates rank of rule within a priority ',
  PRIMARY KEY (`id`),
  UNIQUE KEY `device` (`peer_id`,`device_ip`,`interface_number`,`direction`,`object_group_id`),
  UNIQUE KEY `device_group` (`peer_id`,`device_group_id`,`interface_number`,`direction`,`object_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains the current set of the SevOne NMS netflow generic rules';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_rules`
--
-- WHERE:  1 limit 10

LOCK TABLES `flow_rules` WRITE;
/*!40000 ALTER TABLE `flow_rules` DISABLE KEYS */;
INSERT INTO `flow_rules` VALUES (1,'DEVICE',1,'00000000',NULL,-1,-1,0,0,-1,'INTERFACE',3,1),(2,'DEVICE',1,'00000000000000000000000000000000',NULL,-1,-1,0,0,-1,'INTERFACE',3,2);
/*!40000 ALTER TABLE `flow_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_service_categories`
--

DROP TABLE IF EXISTS `flow_service_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_service_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `service_category_name` varchar(64) NOT NULL COMMENT 'This is the name of the App Category.',
  `service_category_desc` varchar(128) DEFAULT NULL COMMENT 'This is the description of the App Category.',
  `vendor_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the third-party vendor id (SevOne = 0)',
  `vendor_category_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the category id assigned by the third-party vendor',
  `is_custom` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'true if categories added by a customer',
  `deprecation_date` datetime DEFAULT NULL COMMENT 'A deprecated category will not be used to stamp new flow.  It only provides report resolution.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`service_category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines app categories for app profiles from net.flow_service_categories';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_service_categories`
--
-- WHERE:  1 limit 10

LOCK TABLES `flow_service_categories` WRITE;
/*!40000 ALTER TABLE `flow_service_categories` DISABLE KEYS */;
INSERT INTO `flow_service_categories` VALUES (1,'Other','Other',0,0,0,NULL),(2,'Enterprise Application','Enterprise Application',0,0,0,NULL),(3,'Routing Protocol','Routing Protocol',0,0,0,NULL),(4,'Database','Database',0,0,0,NULL),(5,'Network Management','Network Management',0,0,0,NULL),(6,'Network Mail Services','Network Mail Services',0,0,0,NULL),(7,'Directory','Directory',0,0,0,NULL),(8,'Streaming Media','Streaming Media',0,0,0,NULL),(9,'Internet Fileshare','Internet Fileshare',0,0,0,NULL),(10,'Internet Browsing','Internet Browsing',0,0,0,NULL);
/*!40000 ALTER TABLE `flow_service_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_service_profiles`
--

DROP TABLE IF EXISTS `flow_service_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_service_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `vendor_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the third-party vendor id (SevOne = 0)',
  `vendor_application_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the application id assigned by the third-party vendor',
  `service_name` varchar(64) NOT NULL COMMENT 'This is the name of the App Profile.  This is typically short.',
  `service_desc` varchar(128) DEFAULT NULL COMMENT 'This is the description of the App Profile.  This is typically long.',
  `aggregation_port` int(11) DEFAULT NULL COMMENT 'This is aggregation port/high port number into which all entries for this app profile will be aggregated.',
  `enable_aggregation_port` smallint(6) NOT NULL DEFAULT 0 COMMENT '1 if Aggregation port is used to aggregate app; 0 for other default behaviour ',
  `service_category_id` int(11) NOT NULL DEFAULT 1 COMMENT 'Points to the id of one of: net.flow_service_categories, net.ext_flow_service_categories',
  `deprecation_date` datetime DEFAULT NULL COMMENT 'A deprecated profile will not be used to stamp new flow.  It only provides report resolution.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`service_name`),
  UNIQUE KEY `port` (`aggregation_port`)
) ENGINE=InnoDB AUTO_INCREMENT=5045 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines app profiles for apps and applications from net.flow_services' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_service_profiles`
--
-- WHERE:  1 limit 10

LOCK TABLES `flow_service_profiles` WRITE;
/*!40000 ALTER TABLE `flow_service_profiles` DISABLE KEYS */;
INSERT INTO `flow_service_profiles` VALUES (1,0,0,'tcpmux','TCP Port Service Multiplexer',NULL,0,1,NULL),(2,0,0,'compressnet','Management Utility',NULL,0,1,NULL),(3,0,0,'rje','Remote Job Entry',NULL,0,1,NULL),(4,0,0,'echo','Echo',NULL,0,1,NULL),(5,0,0,'discard','Discard',NULL,0,1,NULL),(6,0,0,'systat','Active Users',NULL,0,1,NULL),(7,0,0,'daytime','Daytime (RFC 867)',NULL,0,1,NULL),(8,0,0,'qotd','Quote of the Day',NULL,0,1,NULL),(9,0,0,'msp','Message Send Protocol',NULL,0,1,NULL),(10,0,0,'chargen','Character Generator',NULL,0,1,NULL);
/*!40000 ALTER TABLE `flow_service_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_services`
--

DROP TABLE IF EXISTS `flow_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `vendor_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the third-party vendor id (SevOne = 0)',
  `service_num` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the port number of the application.',
  `service_num_max` int(11) NOT NULL DEFAULT 0 COMMENT 'If the application uses a range of ports, this is the upper bound.  Otherwise, this should be set to the same value as ''service_num''.',
  `protocol_num` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the protocol for this application. foreignKey: net.protocol.protocol_num',
  `service_profile_id` int(11) DEFAULT NULL COMMENT 'This is Service Profile Id for services and applications. foreignKey: net.flow_service_profiles.id',
  `minToS` int(11) DEFAULT NULL COMMENT 'This defines minimun value from ToS (Type of Service) range.',
  `maxToS` int(11) DEFAULT NULL COMMENT 'This defines maximum value from ToS (Type of Service) range.',
  `ip` varchar(50) DEFAULT '0.0.0.0/0' COMMENT 'This is the IPv4 mask to apply to the application.  For example, if this were set to ''192.168.50.0/0'', then this application would only apply to those flows that had an IP address of 192.168.50.*.',
  `destination_ip` varchar(50) DEFAULT NULL COMMENT 'This is the destination IPv4 mask to apply to the application.  For example, if this were set to ''192.168.50.0/0'', then this application would only apply to those flows that had an IP address of 192.168.50.*.',
  `destination_service_num` int(11) DEFAULT NULL COMMENT 'This is the destination port number of the application.',
  `destination_service_num_max` int(11) DEFAULT NULL COMMENT 'If the application uses a range of destination ports, this is the upper bound.  Otherwise, this should be set to the same value as ''destination_service_num''.',
  `is_unidirectional` smallint(6) NOT NULL DEFAULT 1 COMMENT '1 if the app is unidirectinal/source only, Otherwise 0 if app is bidirectinal/Source-Desination.',
  PRIMARY KEY (`id`),
  KEY `service_num` (`service_num`),
  KEY `service_num_max` (`service_num_max`),
  KEY `service_profile_id` (`service_profile_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9978 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the ''flow_services'' or ''applications'' for NetFlow (essentially IP/port mapping).' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_services`
--
-- WHERE:  1 limit 10

LOCK TABLES `flow_services` WRITE;
/*!40000 ALTER TABLE `flow_services` DISABLE KEYS */;
INSERT INTO `flow_services` VALUES (1,0,1,1,6,1,NULL,NULL,'0.0.0.0/0',NULL,NULL,NULL,1),(2,0,1,1,17,1,NULL,NULL,'0.0.0.0/0',NULL,NULL,NULL,1),(3,0,2,2,6,2,NULL,NULL,'0.0.0.0/0',NULL,NULL,NULL,1),(4,0,2,2,17,2,NULL,NULL,'0.0.0.0/0',NULL,NULL,NULL,1),(5,0,3,3,6,2,NULL,NULL,'0.0.0.0/0',NULL,NULL,NULL,1),(6,0,3,3,17,2,NULL,NULL,'0.0.0.0/0',NULL,NULL,NULL,1),(7,0,5,5,6,3,NULL,NULL,'0.0.0.0/0',NULL,NULL,NULL,1),(8,0,5,5,17,3,NULL,NULL,'0.0.0.0/0',NULL,NULL,NULL,1),(9,0,7,7,6,4,NULL,NULL,'0.0.0.0/0',NULL,NULL,NULL,1),(10,0,7,7,17,4,NULL,NULL,'0.0.0.0/0',NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `flow_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flowfalconfilterentries`
--

DROP TABLE IF EXISTS `flowfalconfilterentries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flowfalconfilterentries` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `filter_id` int(11) DEFAULT 0 COMMENT 'filter_id foreignKey: net.flowfalconfilters.id',
  `template_key` bigint(20) DEFAULT 0 COMMENT 'template_key foreignKey: net.netflow_fields.element_id',
  `is_equal` int(11) DEFAULT 1 COMMENT 'This control if the boolean output of the operation should be inverted',
  `operation` varchar(128) DEFAULT '=' COMMENT 'This is <,<=,=,>,>=,between,subnet,mask.  This is a candidate for an enum',
  `value1` varchar(128) DEFAULT '' COMMENT 'the first value, needed by all.',
  `value2` varchar(128) DEFAULT '' COMMENT 'Only used by between, subnet and mask',
  PRIMARY KEY (`id`),
  KEY `report_id` (`filter_id`),
  KEY `report_key` (`template_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is stores the rules for a given filter';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flowfalconfilterentries`
--
-- WHERE:  1 limit 10

LOCK TABLES `flowfalconfilterentries` WRITE;
/*!40000 ALTER TABLE `flowfalconfilterentries` DISABLE KEYS */;
/*!40000 ALTER TABLE `flowfalconfilterentries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flowfalconfilters`
--

DROP TABLE IF EXISTS `flowfalconfilters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flowfalconfilters` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `report_only` smallint(6) DEFAULT 0 COMMENT 'The controls if this is an anonymous filter. 1 - This belongs to a specific, saved reporti, and is anonymous. 0 - This is a generic reusable filter',
  `name` varchar(256) DEFAULT NULL COMMENT 'This is the name of the filter.  The name SHOULD be unique.  Please add an index',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is a filter for a flow falcon report.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flowfalconfilters`
--
-- WHERE:  1 limit 10

LOCK TABLES `flowfalconfilters` WRITE;
/*!40000 ALTER TABLE `flowfalconfilters` DISABLE KEYS */;
/*!40000 ALTER TABLE `flowfalconfilters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flowfalconkeyindicator`
--

DROP TABLE IF EXISTS `flowfalconkeyindicator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flowfalconkeyindicator` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `view_id` int(11) DEFAULT NULL COMMENT 'view_id foreignKey: net.flowfalconview.id',
  `key_index` bigint(20) DEFAULT -1 COMMENT 'key_index foreignKey: net.netflow_fields.element_id',
  `order_number` int(11) DEFAULT NULL COMMENT 'This is the ordinal position of the column in the aggregated netflow table',
  PRIMARY KEY (`id`),
  UNIQUE KEY `template_and_key` (`view_id`,`key_index`)
) ENGINE=MyISAM AUTO_INCREMENT=393 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all the keys for a template. The rows are very important, and SevOne should keep a set in version control ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flowfalconkeyindicator`
--
-- WHERE:  1 limit 10

LOCK TABLES `flowfalconkeyindicator` WRITE;
/*!40000 ALTER TABLE `flowfalconkeyindicator` DISABLE KEYS */;
INSERT INTO `flowfalconkeyindicator` VALUES (3,3,116855322750925,0),(42,16,4,0),(50,20,16,0),(51,21,17,0),(52,22,16,0),(53,22,17,1),(54,23,9,0),(55,24,13,0),(56,25,5,0),(84,32,116855322750920,0);
/*!40000 ALTER TABLE `flowfalconkeyindicator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flowfalconmetricindicator`
--

DROP TABLE IF EXISTS `flowfalconmetricindicator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flowfalconmetricindicator` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `view_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.flowfalconview.id',
  `metric_index` bigint(20) DEFAULT -1 COMMENT ' foreignKey: net.netflow_fields.element_id',
  `order_number` int(11) DEFAULT NULL COMMENT 'This is the ordinal position of the column in the aggregated netflow table',
  `aggregation_method` int(11) DEFAULT 0 COMMENT '0: Sum; 1: Average; 2 Average Non Zero',
  PRIMARY KEY (`id`),
  UNIQUE KEY `template_and_value` (`view_id`,`metric_index`,`aggregation_method`)
) ENGINE=MyISAM AUTO_INCREMENT=460 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contrinat the five metrics that are tracked for a give metric teplate.   The rows are very important, and SevOne should keep a set in version control.  The count(*) grouped on metric_template_id should be equal to 5 exactly.  This is super duper important.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flowfalconmetricindicator`
--
-- WHERE:  1 limit 10

LOCK TABLES `flowfalconmetricindicator` WRITE;
/*!40000 ALTER TABLE `flowfalconmetricindicator` DISABLE KEYS */;
INSERT INTO `flowfalconmetricindicator` VALUES (1,3,1,0,0),(2,3,2,1,0),(3,3,0,2,0),(4,3,19,3,0),(5,3,20,4,0),(6,16,1,0,0),(7,16,2,1,0),(8,16,0,2,0),(9,16,19,3,0),(10,16,20,4,0);
/*!40000 ALTER TABLE `flowfalconmetricindicator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flowfalconview`
--

DROP TABLE IF EXISTS `flowfalconview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flowfalconview` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(255) DEFAULT NULL COMMENT 'Name of the template',
  `category` varchar(255) DEFAULT NULL COMMENT 'Name of the category.  Usede to group templates',
  `is_aggregated` int(11) DEFAULT 0 COMMENT '0 if no aggregated, 1 if it is aggregated',
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 if disabled, 1 if enabled',
  `default_sort_order` int(11) NOT NULL DEFAULT 0 COMMENT '0 for DESC, 1 for ASC',
  `last_update` int(11) DEFAULT 0 COMMENT 'The last time this was updated.  Candidate for auto-update',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='These are the templates that are used for running reports in flow falcon.  They can also be marked to aggregate.  The rows are very important, and SevOne should keep a set in version control.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flowfalconview`
--
-- WHERE:  1 limit 10

LOCK TABLES `flowfalconview` WRITE;
/*!40000 ALTER TABLE `flowfalconview` DISABLE KEYS */;
INSERT INTO `flowfalconview` VALUES (3,'Top Next Hops','IP Reports',0,1,0,1235123140),(16,'Top Protocols','App and Protocol Reports',0,1,0,1235123140),(20,'Top Source AS','Network Reports',0,1,0,1235123140),(21,'Top Destination AS','Network Reports',0,1,0,1235123140),(22,'Top Conversations AS','Network Reports',0,1,0,1235123140),(23,'Top Source Mask','Network Reports',0,1,0,1235123140),(24,'Top Destination Mask','Network Reports',0,1,0,1235123140),(25,'Top Types of Service','QoS Reports',0,1,0,1235123140),(32,'Top Applications (Bandwidth, Packets, Flows)','App and Protocol Reports',0,1,0,1260976565),(33,'Top Applications with Next Hop and ToS','QoS Reports',0,1,0,1260976565);
/*!40000 ALTER TABLE `flowfalconview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ftp_servers`
--

DROP TABLE IF EXISTS `ftp_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ftp_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `host` varchar(64) DEFAULT '' COMMENT 'This is the host name or IP address of the servers',
  `port` int(11) DEFAULT 21 COMMENT 'This is the port to connect on',
  `user` varchar(497) DEFAULT NULL COMMENT 'This is the user credentials',
  `passwd` varchar(497) DEFAULT NULL COMMENT 'This is the password for the user',
  `path` varchar(255) DEFAULT '' COMMENT 'This is the path to store the files in',
  PRIMARY KEY (`id`),
  UNIQUE KEY `server` (`host`,`path`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the ftp server credentials that are used for exporting reports';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ftp_servers`
--
-- WHERE:  1 limit 10

LOCK TABLES `ftp_servers` WRITE;
/*!40000 ALTER TABLE `ftp_servers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ftp_servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gcpdeviceinfo`
--

DROP TABLE IF EXISTS `gcpdeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gcpdeviceinfo` (
  `device_id` int(10) unsigned NOT NULL COMMENT 'foreignKey: net.deviceinfo.id',
  `project_id` varchar(64) NOT NULL COMMENT 'GCP project id',
  `private_key` varchar(4096) NOT NULL COMMENT 'GCP private secret key',
  `service_account_id` varchar(128) NOT NULL COMMENT 'GCP service account email id',
  PRIMARY KEY (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines GCP-specific information about a Device.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gcpdeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `gcpdeviceinfo` WRITE;
/*!40000 ALTER TABLE `gcpdeviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `gcpdeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gnmideviceinfo`
--

DROP TABLE IF EXISTS `gnmideviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gnmideviceinfo` (
  `device_id` int(10) unsigned NOT NULL COMMENT 'foreignKey: net.deviceinfo.id',
  `port` int(16) unsigned NOT NULL COMMENT 'Port where gNMI is served on the device',
  `username` varchar(256) NOT NULL COMMENT 'Username used to authenticate with the device',
  `password` varchar(256) NOT NULL COMMENT 'Password used to authenticate with the device',
  `insecure` tinyint(1) NOT NULL COMMENT 'Use an unencrypted connection to communicate with the device',
  `encoding` varchar(256) NOT NULL DEFAULT 'AUTO' COMMENT 'Encoding used by gNMI when subscribing',
  `skip_verify` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Skip the signature verification steps, in case TLS connection is used',
  PRIMARY KEY (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines gNMI-specific information about a Device.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gnmideviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `gnmideviceinfo` WRITE;
/*!40000 ALTER TABLE `gnmideviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `gnmideviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `icmpdeviceinfo`
--

DROP TABLE IF EXISTS `icmpdeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `icmpdeviceinfo` (
  `device_id` int(11) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `packet_number` int(11) NOT NULL DEFAULT 5 COMMENT 'For new Objects, the number of packets to send.',
  `packet_size` int(11) NOT NULL DEFAULT 56 COMMENT 'For new Objects, the size, in bytes, of each packet.',
  `packet_interval` int(11) NOT NULL DEFAULT 0 COMMENT 'For new Objects, the interval, in milliseconds, between packets.',
  UNIQUE KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table stores Device-specific information about the ICMP Plugin.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `icmpdeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `icmpdeviceinfo` WRITE;
/*!40000 ALTER TABLE `icmpdeviceinfo` DISABLE KEYS */;
INSERT INTO `icmpdeviceinfo` VALUES (281,10,56,0),(353,10,56,0);
/*!40000 ALTER TABLE `icmpdeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image_store`
--

DROP TABLE IF EXISTS `image_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `image_store` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `mime_type` varchar(128) NOT NULL COMMENT 'The MIME type of the image',
  `image_name` varchar(255) DEFAULT '' COMMENT 'Icon file name',
  `image_data` longtext NOT NULL COMMENT 'The base64-encoded image data',
  `is_system` tinyint(4) DEFAULT 0 COMMENT 'Whether or not the icon shipped is by default with the NMS',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all images stored by the ImageStore library.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image_store`
--
-- WHERE:  1 limit 10

LOCK TABLES `image_store` WRITE;
/*!40000 ALTER TABLE `image_store` DISABLE KEYS */;
INSERT INTO `image_store` VALUES (1,'image/svg+xml','','PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjwhLS0gR2VuZXJhdG9yOiBBZG9iZSBJbGx1c3RyYXRvciAxNi4wLjMsIFNWRyBFeHBvcnQgUGx1Zy1JbiAuIFNWRyBWZXJzaW9uOiA2LjAwIEJ1aWxkIDApICAtLT4NCjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+DQo8c3ZnIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeD0iMHB4IiB5PSIwcHgiIHdpZHRoPSIxNnB4Ig0KCSBoZWlnaHQ9IjE2cHgiIHZpZXdCb3g9IjAgMCAxNiAxNiIgZW5hYmxlLWJhY2tncm91bmQ9Im5ldyAwIDAgMTYgMTYiIHhtbDpzcGFjZT0icHJlc2VydmUiPg0KPGcgaWQ9IkJhY2tncm91bmQiIGRpc3BsYXk9Im5vbmUiPg0KCTxyZWN0IHg9Ii0xOTAiIHk9Ii0xOTY0IiBkaXNwbGF5PSJpbmxpbmUiIGZpbGw9IiNGOUY5RjkiIHdpZHRoPSI2MjAiIGhlaWdodD0iMjQ0NSIvPg0KCTxnIGlkPSJHdWlkZXMiIGRpc3BsYXk9ImlubGluZSI+DQoJCTxyZWN0IGZpbGw9IiNGRkZGRkYiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIvPg0KCTwvZz4NCgk8ZyBpZD0iRGVzY3JpcHRpb25zIiBkaXNwbGF5PSJpbmxpbmUiPg0KCTwvZz4NCjwvZz4NCjxnIGlkPSJMYXllcl8yIj4NCgk8ZyBpZD0iZGV2aWNlIj4NCgkJPHJlY3QgeT0iNSIgZmlsbD0iIzYxNjE2MSIgd2lkdGg9IjE2IiBoZWlnaHQ9IjYiLz4NCgkJPHJlY3QgeD0iMSIgeT0iNyIgZmlsbD0iI0ZGRkZGRiIgd2lkdGg9IjUiIGhlaWdodD0iMSIvPg0KCQk8Y2lyY2xlIGZpbGw9IiNGRkZGRkYiIGN4PSIxMC41IiBjeT0iNy41IiByPSIwLjc1Ii8+DQoJCTxjaXJjbGUgZmlsbD0iI0ZGRkZGRiIgY3g9IjEyLjUiIGN5PSI3LjUiIHI9IjAuNzUiLz4NCgkJPGNpcmNsZSBmaWxsPSIjRkZGRkZGIiBjeD0iMTQuNSIgY3k9IjcuNSIgcj0iMC43NSIvPg0KCTwvZz4NCjwvZz4NCjwvc3ZnPg0K',0),(2,'image/png','topo-device-flat.png','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',1),(3,'image/svg+xml','controller.svg','PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjwhLS0gR2VuZXJhdG9yOiBBZG9iZSBJbGx1c3RyYXRvciAxOS4xLjAsIFNWRyBFeHBvcnQgUGx1Zy1JbiAuIFNWRyBWZXJzaW9uOiA2LjAwIEJ1aWxkIDApICAtLT4NCjxzdmcgdmVyc2lvbj0iMS4xIiBpZD0iTGF5ZXJfMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeD0iMHB4IiB5PSIwcHgiDQoJIHZpZXdCb3g9IjAgMCAxNiAxNiIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgMTYgMTY7IiB4bWw6c3BhY2U9InByZXNlcnZlIj4NCjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+DQoJLnN0MHtmaWxsOiNGRkZGRkY7fQ0KCS5zdDF7ZmlsbDojNDQ5NEQ4O30NCgkuc3Qye2ZpbGw6IzYxNjE2MTt9DQoJLnN0M3tmaWxsOiM4NkM1NzY7fQ0KCS5zdDR7ZmlsbDojMkJBRUJEO30NCgkuc3Q1e2ZpbGw6I0EwQTBBMDt9DQoJLnN0NntmaWxsOiNGQjZGNTQ7fQ0KCS5zdDd7ZmlsbDojRjc5MzMyO30NCgkuc3Q4e2ZpbGw6IzQ1NzRBNjt9DQoJLnN0OXtmaWxsOiNGRjhBMDA7fQ0KPC9zdHlsZT4NCjxnIGlkPSJjb250cm9sbGVyIj4NCgk8cGF0aCBjbGFzcz0ic3QzIiBkPSJNMTYsNy41YzAtMS44MDU3LTEuMzczLTMuMjc1NC0zLjEyOTktMy40NjI5QzEyLjQzNzUsMi4yOTU5LDEwLjg3NSwxLDksMUM2Ljc5MSwxLDUsMi43OTEsNSw1DQoJCUMzLjM0MzgsNSwyLDYuMzQzOCwyLDhjMCwwLjM2MzMsMC4wNzQyLDAuNzA4LDAuMTkzNCwxLjAzMTJDMC45NTksOS4xODM2LDAsMTAuMjI0NiwwLDExLjVDMCwxMi44ODA5LDEuMTE5MSwxNCwyLjUsMTQNCgkJYzAuMzg0OCwwLDAuNzQ2MS0wLjA5NDcsMS4wNzIzLTAuMjVDNC4xMTcyLDE0LjUwMzksNC45OTgsMTUsNiwxNWMxLjEzMTgsMCwyLjEwNTUtMC42MzM4LDIuNjE1Mi0xLjU1ODYNCgkJQzkuMTYwMiwxMy43OTEsOS44MDQ3LDE0LDEwLjUsMTRjMS44Nzg5LDAsMy4zOTk0LTEuNDg0NCwzLjQ4NDQtMy4zNDE4QzE1LjE3MTksMTAuMDk4NiwxNiw4Ljg5OTQsMTYsNy41eiIvPg0KCTxwYXRoIGNsYXNzPSJzdDAiIGQ9Ik00LDcuNXYyQzQsOS43NzYxLDQuMjIzOSwxMCw0LjUsMTBoOGMwLjI3NjEsMCwwLjUtMC4yMjM5LDAuNS0wLjV2LTJDMTMsNy4yMjM5LDEyLjc3NjEsNywxMi41LDdoLTgNCgkJQzQuMjIzOSw3LDQsNy4yMjM5LDQsNy41eiBNNyw4LjhDNyw4LjkxLDYuOTEsOSw2LjgsOUg1LjJDNS4wOSw5LDUsOC45MSw1LDguOFY4LjJDNSw4LjA5LDUuMDksOCw1LjIsOGgxLjZDNi45MSw4LDcsOC4wOSw3LDguMg0KCQlWOC44eiBNOS41LDkuMjQ5Yy0wLjQxNDEsMC0wLjc1LTAuMzM1LTAuNzUtMC43NDlTOS4wODU5LDcuNzUsOS41LDcuNzVzMC43NSwwLjMzNTksMC43NSwwLjc1UzkuOTE0MSw5LjI0OSw5LjUsOS4yNDl6IE0xMS41LDkuMjUNCgkJYy0wLjQxNDEsMC0wLjc1LTAuMzM1OS0wLjc1LTAuNzVzMC4zMzU5LTAuNzUsMC43NS0wLjc1czAuNzUsMC4zMzU5LDAuNzUsMC43NVMxMS45MTQxLDkuMjUsMTEuNSw5LjI1eiIvPg0KPC9nPg0KPC9zdmc+DQo=',1),(4,'image/png','topo-router.png','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',1),(5,'image/png','topo-cloud-flat.png','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',1),(6,'image/png','topo-controller.png','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',1),(7,'image/svg+xml','vm.svg','PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjwhLS0gR2VuZXJhdG9yOiBBZG9iZSBJbGx1c3RyYXRvciAxOS4xLjAsIFNWRyBFeHBvcnQgUGx1Zy1JbiAuIFNWRyBWZXJzaW9uOiA2LjAwIEJ1aWxkIDApICAtLT4NCjxzdmcgdmVyc2lvbj0iMS4xIiBpZD0iTGF5ZXJfMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeD0iMHB4IiB5PSIwcHgiDQoJIHZpZXdCb3g9IjAgMCAxNiAxNiIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgMTYgMTY7IiB4bWw6c3BhY2U9InByZXNlcnZlIj4NCjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+DQoJLnN0MHtmaWxsOiNGRkZGRkY7fQ0KCS5zdDF7ZmlsbDojNDQ5NEQ4O30NCgkuc3Qye2ZpbGw6IzYxNjE2MTt9DQoJLnN0M3tmaWxsOiM4NkM1NzY7fQ0KCS5zdDR7ZmlsbDojMkJBRUJEO30NCgkuc3Q1e2ZpbGw6I0EwQTBBMDt9DQoJLnN0NntmaWxsOiNGQjZGNTQ7fQ0KCS5zdDd7ZmlsbDojRjc5MzMyO30NCgkuc3Q4e2ZpbGw6IzQ1NzRBNjt9DQoJLnN0OXtmaWxsOiNGRjhBMDA7fQ0KPC9zdHlsZT4NCjxnIGlkPSJ2bSI+DQoJPHBhdGggY2xhc3M9InN0NCIgZD0iTTE1LjY0NzEsOC4zNTI5bC03LjI5NDIsNy4yOTQyYy0wLjE5NDksMC4xOTQ5LTAuNTEwOSwwLjE5NDktMC43MDU4LDBMMC4zNTI5LDguMzUyOQ0KCQljLTAuMTk0OS0wLjE5NDktMC4xOTQ5LTAuNTEwOSwwLTAuNzA1OGw3LjI5NDItNy4yOTQyYzAuMTk0OS0wLjE5NDksMC41MTA5LTAuMTk0OSwwLjcwNTgsMGw3LjI5NDIsNy4yOTQyDQoJCUMxNS44NDIsNy44NDIsMTUuODQyLDguMTU4LDE1LjY0NzEsOC4zNTI5eiIvPg0KCTxwYXRoIGNsYXNzPSJzdDAiIGQ9Ik02LjYyOTksNi4yNTJoMC42MzU3TDUuOTUzMSwxMEg1LjMwNzZMNCw2LjI1MmgwLjYzMDlMNS40MTI2LDguNTgyYzAuMDQxLDAuMTExMywwLjA4NDUsMC4yNTQ5LDAuMTMwNCwwLjQyOTcNCgkJYzAuMDQ2NCwwLjE3NDgsMC4wNzYyLDAuMzA1NywwLjA4OTgsMC4zOTA2YzAuMDIyNS0wLjEyOTksMC4wNTY2LTAuMjgwMywwLjEwMjUtMC40NTEyYzAuMDQ2NC0wLjE3MDksMC4wODQtMC4yOTY5LDAuMTEyOC0wLjM3ODkNCgkJTDYuNjI5OSw2LjI1MnoiLz4NCgk8cGF0aCBjbGFzcz0ic3QwIiBkPSJNOS4zODA0LDEwTDguMjkzNSw2Ljg3MDFIOC4yNzI5QzguMzAyMiw3LjMzNSw4LjMxNjQsNy43NzA1LDguMzE2NCw4LjE3NzdWMTBINy43NjAzVjYuMjUySDguNjI0DQoJCWwxLjA0MSwyLjk4MTRoMC4wMTU2TDEwLjc1Miw2LjI1MmgwLjg2NjJWMTBoLTAuNTg5NFY4LjE0NjVjMC0wLjE4NjUsMC4wMDQ5LTAuNDI4NywwLjAxNDItMC43Mjc1DQoJCWMwLjAwOTMtMC4yOTk4LDAuMDE3Ni0wLjQ4MDUsMC4wMjQ0LTAuNTQzOWgtMC4wMjA1TDkuOTIxNCwxMEg5LjM4MDR6Ii8+DQo8L2c+DQo8L3N2Zz4NCg==',1),(8,'image/png','topo-server-flat.png','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',1),(9,'image/png','topo-firewall-flat.png','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',1),(10,'image/png','topo-wireless-flat.png','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',1);
/*!40000 ALTER TABLE `image_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipsla_supported_protocols`
--

DROP TABLE IF EXISTS `ipsla_supported_protocols`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ipsla_supported_protocols` (
  `device_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.deviceinfo.id',
  `protocol` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the protocol identifier.',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if the Device supports it; 2 if it does not.',
  PRIMARY KEY (`device_id`,`protocol`),
  KEY `protocol` (`protocol`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='The kinds of IP SLA tests each have one or more protocols defined by Cisco.  Each Device reports which protocols it supports.  This table maps a Device to those protocols.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipsla_supported_protocols`
--
-- WHERE:  1 limit 10

LOCK TABLES `ipsla_supported_protocols` WRITE;
/*!40000 ALTER TABLE `ipsla_supported_protocols` DISABLE KEYS */;
/*!40000 ALTER TABLE `ipsla_supported_protocols` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipsla_supported_types`
--

DROP TABLE IF EXISTS `ipsla_supported_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ipsla_supported_types` (
  `device_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.deviceinfo.id',
  `type` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the test type; this directly corresponds to an IP SLA Object Type, as well.',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if the Device supports it; 2 if it does not.',
  PRIMARY KEY (`device_id`,`type`),
  KEY `type` (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='The kinds of IP SLA tests each have an ID defined by Cisco.  Each Device reports which tests it supports.  This table maps a Device to those tests.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipsla_supported_types`
--
-- WHERE:  1 limit 10

LOCK TABLES `ipsla_supported_types` WRITE;
/*!40000 ALTER TABLE `ipsla_supported_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `ipsla_supported_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipsladeviceinfo`
--

DROP TABLE IF EXISTS `ipsladeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ipsladeviceinfo` (
  `dev_id` int(11) NOT NULL AUTO_INCREMENT COMMENT ' foreignKey: net.deviceinfo.id',
  `set_responder` int(11) DEFAULT 0 COMMENT '0: do not change; 1: turn on the responder; 2: turn off the responder.',
  `responder` int(11) DEFAULT 0 COMMENT '1 if the responder was last known to be on; 2 if it was last known to be off; 0 otherwise.',
  `version` varchar(32) DEFAULT NULL COMMENT 'The arbitrary (and totally useless) IP SLA version information that Cisco reports.',
  `compliance_revision` int(11) DEFAULT 0 COMMENT 'A rough stereotype in which to place this Device.  A ''compliance revision'' represents a chunk of features, functionality, and support within IP SLA, and things with larger values support more OIDs.  This is used during polling to determine exactly what OIDs should be tried.',
  `override_compliance_revision` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if ''compliance_revision'' has been set by a user; 0 if it was set by the system.',
  `allow_ipsla_creation` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 if Device Discovery is allowed to provision IP SLAs on the Device itself; 0 otherwise.',
  PRIMARY KEY (`dev_id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the Cisco IP SLA information for a Device.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipsladeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `ipsladeviceinfo` WRITE;
/*!40000 ALTER TABLE `ipsladeviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `ipsladeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipslamessages`
--

DROP TABLE IF EXISTS `ipslamessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ipslamessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `device_id` int(11) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `time` int(10) unsigned NOT NULL COMMENT 'The time of the event.',
  `message` text NOT NULL COMMENT 'The information about the event; this is usually an error or success message.',
  `command` text NOT NULL COMMENT 'This is the command that had tried to be run.',
  `retries` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the number of times that the command has been retried.',
  `success` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'This is whether or not the command was successful; 1 if it was; 0 if it wasn''t.',
  PRIMARY KEY (`id`),
  KEY `device_id` (`device_id`),
  KEY `time` (`time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains messages about the actions taken for a Device in relation to IP SLA.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipslamessages`
--
-- WHERE:  1 limit 10

LOCK TABLES `ipslamessages` WRITE;
/*!40000 ALTER TABLE `ipslamessages` DISABLE KEYS */;
/*!40000 ALTER TABLE `ipslamessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jmxdeviceinfo`
--

DROP TABLE IF EXISTS `jmxdeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jmxdeviceinfo` (
  `dev_id` int(10) unsigned NOT NULL COMMENT 'dev_id foreignKey: net.deviceinfo.id',
  `hostname` varchar(256) DEFAULT NULL COMMENT 'hostname',
  `port` int(6) DEFAULT NULL COMMENT 'port',
  `authentication` enum('none','basic') DEFAULT NULL COMMENT 'authentication',
  `username` varchar(497) DEFAULT NULL COMMENT 'to read this field  use: sevone_decrypt(<fieldname>), to write to it: sevone_encrypt(<value>).',
  `password` varchar(497) DEFAULT NULL COMMENT 'to read this field  use: sevone_decrypt(<fieldname>), to write to it: sevone_encrypt(<value>).',
  `suffix` varchar(255) DEFAULT NULL COMMENT 'suffix',
  `nameFilter` varchar(255) DEFAULT NULL COMMENT 'nameFilter',
  `domainFilter` varchar(255) DEFAULT NULL COMMENT 'domainFilter',
  `typeFilter` varchar(255) DEFAULT NULL COMMENT 'typeFilter',
  `objectFilter` varchar(255) DEFAULT NULL COMMENT 'objectFilter',
  `keystore_password` varchar(497) DEFAULT NULL COMMENT 'to read this field  use: sevone_decrypt(<fieldname>), to write to it: sevone_encrypt(<value>).',
  `keystore` longblob DEFAULT NULL COMMENT 'keystore',
  `truststore` longblob DEFAULT NULL COMMENT 'truststore',
  `truststore_password` varchar(497) DEFAULT NULL COMMENT 'to read this field  use: sevone_decrypt(<fieldname>), to write to it: sevone_encrypt(<value>).',
  `connection_type` enum('JSR160','AdminClient') NOT NULL DEFAULT 'JSR160' COMMENT 'connection_type',
  PRIMARY KEY (`dev_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Jmxdeviceinfo';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jmxdeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `jmxdeviceinfo` WRITE;
/*!40000 ALTER TABLE `jmxdeviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `jmxdeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ldapsettings`
--

DROP TABLE IF EXISTS `ldapsettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ldapsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) DEFAULT '' COMMENT 'name',
  `host` varchar(255) DEFAULT NULL COMMENT 'host',
  `port` int(10) unsigned DEFAULT NULL COMMENT 'port',
  `base_DN` varchar(255) DEFAULT NULL COMMENT 'base_DN',
  `use_SSL` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'use_SSL',
  `use_startTLS` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'use_startTLS',
  `bind_DN` varchar(497) DEFAULT NULL COMMENT 'to read this field  use: sevone_decrypt(<fieldname>), to write to it: sevone_encrypt(<value>).',
  `bind_password` varchar(497) DEFAULT NULL COMMENT 'to read this field  use: sevone_decrypt(<fieldname>), to write to it: sevone_encrypt(<value>).',
  `username_field` varchar(255) NOT NULL DEFAULT 'sAMAccountName' COMMENT 'username_field',
  PRIMARY KEY (`id`),
  UNIQUE KEY `host_port` (`host`,`port`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Ldapsettings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ldapsettings`
--
-- WHERE:  1 limit 10

LOCK TABLES `ldapsettings` WRITE;
/*!40000 ALTER TABLE `ldapsettings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ldapsettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `license_statistics`
--

DROP TABLE IF EXISTS `license_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `license_statistics` (
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Timestamp when data will be dumped in the database.',
  `object_present` int(10) DEFAULT NULL COMMENT 'Count of present objects.',
  `object_capacity` int(10) DEFAULT NULL COMMENT 'Capacity of objects.',
  `device_present` int(10) DEFAULT NULL COMMENT 'Count of present devices.',
  `device_capacity` int(10) DEFAULT NULL COMMENT 'Capacity of devices.',
  `flow_present` int(10) DEFAULT NULL COMMENT 'Count of present flow.',
  `flow_capacity` int(10) DEFAULT NULL COMMENT 'Capacity of flows.',
  `group_poller_device_count` int(11) DEFAULT 0 COMMENT 'Count of group poller devices',
  `group_poller_object_count` int(11) DEFAULT 0 COMMENT 'Count of group poller objects',
  `selfmon_device_count` int(11) DEFAULT 0 COMMENT 'Count of SelfMon devices',
  `selfmon_object_count` int(11) DEFAULT 0 COMMENT 'Count of SelfMon objects',
  `coc_device_count` int(11) DEFAULT 0 COMMENT 'Count of COC devices',
  `managed_client_device_count` int(11) DEFAULT 0 COMMENT 'Count of Managed Client devices',
  `licensed_device_count` int(11) DEFAULT 0 COMMENT 'Count of Licensed devices',
  `managed_device_count` int(11) DEFAULT 0 COMMENT 'Count of Managed devices',
  `indicators_per_second` double DEFAULT 0 COMMENT 'Value of Indicators per second ',
  `ips_capacity` int(11) DEFAULT 0 COMMENT 'Indicators per second capacity for the cluster',
  `flow_device_count` int(11) DEFAULT 0 COMMENT 'Count of flow devices',
  `unknown_flow_device_count` int(11) DEFAULT 0 COMMENT 'Count of unknown flow devices',
  `fps_capacity` int(11) DEFAULT 0 COMMENT 'flows per second capacity ',
  `flow_interface_capacity` int(11) DEFAULT 0 COMMENT 'Flows interface capacity ',
  `total_fps` double DEFAULT 0 COMMENT 'Total flows per second ',
  `total_flow_interfaces` int(11) DEFAULT 0 COMMENT 'Total flows interfaces ',
  `icmp_device_count` int(11) DEFAULT 0 COMMENT 'Count of ICMP devices ',
  PRIMARY KEY (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the table that stores the overall information of license.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `license_statistics`
--
-- WHERE:  1 limit 10

LOCK TABLES `license_statistics` WRITE;
/*!40000 ALTER TABLE `license_statistics` DISABLE KEYS */;
INSERT INTO `license_statistics` VALUES ('2025-09-04 12:00:02',100,5000,1,0,0,5000,0,0,1,92,0,0,0,0,3,333,0,0,4500,15,0,0,0),('2025-09-04 18:00:01',63154,5000,2,0,0,5000,0,0,1,100,0,0,1,1,87,333,0,0,4500,15,0,0,0),('2025-09-05 00:00:01',63154,5000,2,0,0,5000,0,0,1,100,0,0,1,1,3,333,0,0,4500,15,0,0,0),('2025-09-05 06:00:01',63160,5000,2,0,0,5000,0,0,1,106,0,0,1,1,3,333,0,0,4500,15,0,0,0),('2025-09-05 12:00:02',106,5000,1,0,0,5000,0,0,1,106,0,0,0,0,3,333,0,0,4500,15,0,0,0),('2025-09-05 18:00:01',106,5000,2,0,0,5000,0,0,1,106,0,0,1,1,3,333,0,0,4500,15,0,0,0),('2025-09-06 00:00:02',63160,5000,2,0,0,5000,0,0,1,106,0,0,1,1,3,333,0,0,4500,15,0,0,0),('2025-09-06 06:00:02',63160,5000,2,0,0,5000,0,0,1,106,0,0,1,1,3,333,0,0,4500,15,0,0,0),('2025-09-06 12:00:01',111,5000,2,0,0,5000,0,0,1,106,0,0,1,1,3,333,0,0,4500,15,0,0,0),('2025-09-06 18:00:02',111,5000,2,0,0,5000,0,0,1,106,0,0,1,1,3,333,0,0,4500,15,0,0,0);
/*!40000 ALTER TABLE `license_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenance_windows`
--

DROP TABLE IF EXISTS `maintenance_windows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance_windows` (
  `id` binary(16) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0' COMMENT 'UUID for maintenance windows',
  `name` varchar(128) NOT NULL COMMENT 'Name of the window',
  `event_type` enum('PLANNED') NOT NULL COMMENT 'Type of the window',
  `entity_type` enum('DEVICE','OBJECT','DEVICE_GROUP','OBJECT_GROUP') NOT NULL COMMENT 'Type of entities to which the window is applied',
  `is_repeating` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Define if this is a repeating or single-instance window.',
  `schedule_instance_id` int(10) unsigned DEFAULT NULL COMMENT 'Reference to the event for a single-instance window. foreignKey: net.schedule_instance.id',
  `notes` text DEFAULT NULL COMMENT 'Additional notes on the window.',
  `actions` set('EXCLUDE_DATA_FROM_BASELINES','EXCLUDE_DATA_FROM_AGGREGATION','SUPPRESS_ALERT_NOTIFICATIONS','CATEGORIZE_ALERTS') NOT NULL COMMENT 'Set of actions that the maintenance window applies to the system.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores maintenance windows';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance_windows`
--
-- WHERE:  1 limit 10

LOCK TABLES `maintenance_windows` WRITE;
/*!40000 ALTER TABLE `maintenance_windows` DISABLE KEYS */;
/*!40000 ALTER TABLE `maintenance_windows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenance_windows_deviceinfo_map`
--

DROP TABLE IF EXISTS `maintenance_windows_deviceinfo_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance_windows_deviceinfo_map` (
  `maintenance_window_id` binary(16) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0' COMMENT 'Reference to the window to which the entity belongs. foreignKey: net.maintenance_windows.id',
  `device_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Reference to a device. foreignKey: net.deviceinfo.id',
  PRIMARY KEY (`maintenance_window_id`,`device_id`),
  KEY `maintenance_window` (`maintenance_window_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the mapping between maintenance windows and devices';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance_windows_deviceinfo_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `maintenance_windows_deviceinfo_map` WRITE;
/*!40000 ALTER TABLE `maintenance_windows_deviceinfo_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `maintenance_windows_deviceinfo_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenance_windows_devicetag_map`
--

DROP TABLE IF EXISTS `maintenance_windows_devicetag_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance_windows_devicetag_map` (
  `maintenance_window_id` binary(16) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0' COMMENT 'Reference to the window to which the entity belongs. foreignKey: net.maintenance_windows.id',
  `devicetag_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Reference to a device group. foreignKey: net.devicetags.id',
  PRIMARY KEY (`maintenance_window_id`,`devicetag_id`),
  KEY `maintenance_window` (`maintenance_window_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the mapping between maintenance windows and device groups';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance_windows_devicetag_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `maintenance_windows_devicetag_map` WRITE;
/*!40000 ALTER TABLE `maintenance_windows_devicetag_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `maintenance_windows_devicetag_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `map`
--

DROP TABLE IF EXISTS `map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `map` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(256) DEFAULT NULL COMMENT 'The name of the map',
  `map_image_id` int(11) DEFAULT NULL COMMENT 'The map image to use as the background of this map foreignKey: net.mapimages.id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all defined maps that are in the product. Maps contain nodes and paths.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `map`
--
-- WHERE:  1 limit 10

LOCK TABLES `map` WRITE;
/*!40000 ALTER TABLE `map` DISABLE KEYS */;
/*!40000 ALTER TABLE `map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mapimages`
--

DROP TABLE IF EXISTS `mapimages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mapimages` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `name` varchar(64) DEFAULT NULL COMMENT 'This is the name of the map image',
  `image` longblob DEFAULT NULL COMMENT 'The image itself ( yes this is stored in our database )',
  `image_size` int(11) DEFAULT NULL COMMENT 'The size of the image',
  `image_mime_type` varchar(256) DEFAULT NULL COMMENT 'The mime type of the image',
  `map_id` int(11) DEFAULT NULL COMMENT 'The map that this map image is associated with ( this column may not actually be used ) foreignKey: net.map.id',
  `thumbnail` longblob DEFAULT NULL COMMENT 'The thumbnail of the image',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all the images that can be used as maps.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mapimages`
--
-- WHERE:  1 limit 10

LOCK TABLES `mapimages` WRITE;
/*!40000 ALTER TABLE `mapimages` DISABLE KEYS */;
/*!40000 ALTER TABLE `mapimages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metadata_attribute`
--

DROP TABLE IF EXISTS `metadata_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `metadata_attribute` (
  `singleton` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Whether or not to allow duplicate values for this attribute. Phase 1, this will only ever be 1.',
  `validation_expression` text DEFAULT NULL COMMENT 'The expression used to validate metadata for this attribute.',
  `entity_types` set('device','object','devicegroup','objectgroup','objecttype','indicatortype') NOT NULL COMMENT 'The entities this attribute may be applied to.',
  `type` enum('integer','ip','mac','url','dateTime','regex','latLong','string','lldpportid','acceptedValues') NOT NULL COMMENT 'The attribute types allowed to store metadata for.',
  `namespace_id` int(11) NOT NULL COMMENT ' foreignKey: net.metadata_namespace.id',
  `name` varchar(255) NOT NULL COMMENT 'The name of the attribute.',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The id of the attribute.',
  `is_value_editable` tinyint(11) NOT NULL DEFAULT 1 COMMENT 'Whether or not to allow user to edit attribute values.',
  `is_attribute_editable` tinyint(11) NOT NULL DEFAULT 1 COMMENT 'Whether or not to allow user to edit attribute name, type & target.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`namespace_id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=290 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the basic information about Metadata attributes.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metadata_attribute`
--
-- WHERE:  1 limit 10

LOCK TABLES `metadata_attribute` WRITE;
/*!40000 ALTER TABLE `metadata_attribute` DISABLE KEYS */;
INSERT INTO `metadata_attribute` VALUES (1,NULL,'device','string',1,'sysName',1,0,0),(1,NULL,'device','string',1,'sysDescr',2,0,0),(1,NULL,'device','string',1,'sysLocation',3,0,0),(1,NULL,'device','string',1,'sysObjectID',4,0,0),(1,NULL,'device','string',1,'sysContact',5,0,0),(1,NULL,'devicegroup','string',1,'Log Volume Name',6,0,0),(1,NULL,'devicegroup','string',1,'Log Volume Token',7,0,0),(1,NULL,'device','string',1,'LLDPLocalChassis',8,0,0),(0,NULL,'device,object','mac',1,'MAC Address',9,0,0),(0,NULL,'device,object','ip',1,'IP Address',10,0,0);
/*!40000 ALTER TABLE `metadata_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metadata_attribute_icons`
--

DROP TABLE IF EXISTS `metadata_attribute_icons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `metadata_attribute_icons` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The id of the attribute.',
  `attribute_id` int(11) NOT NULL COMMENT 'foreignKey: net.metadata_attribute.id',
  `attribute_value` varchar(256) NOT NULL COMMENT 'foreignKey: net.metadata_attribute_values.value',
  `attribute_icon` varchar(32000) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '' COMMENT 'This is the image/png base64 URI of the logo.',
  PRIMARY KEY (`id`),
  KEY `attribute` (`attribute_id`,`attribute_value`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores icons for Metadata attributes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metadata_attribute_icons`
--
-- WHERE:  1 limit 10

LOCK TABLES `metadata_attribute_icons` WRITE;
/*!40000 ALTER TABLE `metadata_attribute_icons` DISABLE KEYS */;
INSERT INTO `metadata_attribute_icons` VALUES (1,149,'icon_bare-metal-server--01','data:image/svg+xml;base64,PHN2ZyBpZD0iaWNvbiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiI+CiAgPGRlZnM+CiAgICA8c3R5bGU+CiAgICAgIC5jbHMtMSB7CiAgICAgICAgZmlsbDogbm9uZTsKICAgICAgfQogICAgPC9zdHlsZT4KICA8L2RlZnM+CiAgPHBvbHlnb24gcG9pbnRzPSIxNyAyOCAxNyAyMiAxNSAyMiAxNSAyOCA1IDI4IDUgMzAgMjcgMzAgMjcgMjggMTcgMjgiLz4KICA8Y2lyY2xlIGN4PSI5IiBjeT0iMTYiIHI9IjEiLz4KICA8cGF0aCBkPSJNMjYsMjBINmEyLjAwMjMsMi4wMDIzLDAsMCwxLTItMlYxNGEyLjAwMjMsMi4wMDIzLDAsMCwxLDItMkgyNmEyLjAwMjMsMi4wMDIzLDAsMCwxLDIsMnY0QTIuMDAyMywyLjAwMjMsMCwwLDEsMjYsMjBaTTYsMTR2NEgyNlYxNFoiLz4KICA8cmVjdCBpZD0iX1RyYW5zcGFyZW50X1JlY3RhbmdsZV8iIGRhdGEtbmFtZT0iJmx0O1RyYW5zcGFyZW50IFJlY3RhbmdsZSZndDsiIGNsYXNzPSJjbHMtMSIgd2lkdGg9IjMyIiBoZWlnaHQ9IjMyIi8+Cjwvc3ZnPgo='),(2,149,'icon_cloud--infrastructure-management','data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRvcjogQWRvYmUgSWxsdXN0cmF0b3IgMjYuMS4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVyc2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjxzdmcgdmVyc2lvbj0iMS4xIiBpZD0iTGF5ZXJfMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeD0iMHB4IiB5PSIwcHgiCgkgdmlld0JveD0iMCAwIDMyIDMyIiBzdHlsZT0iZW5hYmxlLWJhY2tncm91bmQ6bmV3IDAgMCAzMiAzMjsiIHhtbDpzcGFjZT0icHJlc2VydmUiPgo8cGF0aCBpZD0iY2xvdWQtLWluZnJhc3RydWN0dXJlLW1hbmFnZW1lbnRfMDAwMDAwNTg1OTEzNjk5NDU0MjA5MjU3MTAwMDAwMDM3NzU5MjMxMzQwMTc3NTIyNDBfIiBkPSJNMjksMzAuMzYKCWMtMS4zMDIsMC0yLjM2LTEuMDU5LTIuMzYtMi4zNmMwLTEuMTc5LDAuODY5LTIuMTU5LDItMi4zMzNWMjIuMzZIMTYuMzZ2My4zMDdjMS4xMzEsMC4xNzQsMiwxLjE1NCwyLDIuMzMzCgljMCwxLjMwMi0xLjA1OSwyLjM2LTIuMzYsMi4zNnMtMi4zNi0xLjA1OS0yLjM2LTIuMzZjMC0xLjE3OSwwLjg2OS0yLjE1OSwyLTIuMzMzVjIyLjM2SDMuMzZ2My4zMDdjMS4xMzEsMC4xNzQsMiwxLjE1NCwyLDIuMzMzCgljMCwxLjMwMi0xLjA1OSwyLjM2LTIuMzYsMi4zNlMwLjY0LDI5LjMwMiwwLjY0LDI4YzAtMS4xNzksMC44NjktMi4xNTksMi0yLjMzM1YyMmMwLTAuMTk5LDAuMTYxLTAuMzYsMC4zNi0wLjM2aDEyLjY0VjE4aDAuNzIKCXYzLjY0SDI5YzAuMTk5LDAsMC4zNiwwLjE2MSwwLjM2LDAuMzZ2My42NjdjMS4xMzEsMC4xNzQsMiwxLjE1NCwyLDIuMzMzQzMxLjM2LDI5LjMwMiwzMC4zMDIsMzAuMzYsMjksMzAuMzZ6IE0yOSwyNi4zNgoJYy0wLjkwNCwwLTEuNjQsMC43MzUtMS42NCwxLjY0czAuNzM1LDEuNjQsMS42NCwxLjY0czEuNjQtMC43MzUsMS42NC0xLjY0UzI5LjkwNCwyNi4zNiwyOSwyNi4zNnogTTE2LDI2LjM2CgljLTAuOTA0LDAtMS42NCwwLjczNS0xLjY0LDEuNjRzMC43MzYsMS42NCwxLjY0LDEuNjRjMC45MDQsMCwxLjY0LTAuNzM1LDEuNjQtMS42NFMxNi45MDQsMjYuMzYsMTYsMjYuMzZ6IE0zLDI2LjM2CgljLTAuOTA0LDAtMS42NCwwLjczNS0xLjY0LDEuNjRTMi4wOTYsMjkuNjQsMywyOS42NFM0LjY0LDI4LjkwNCw0LjY0LDI4UzMuOTA0LDI2LjM2LDMsMjYuMzZ6IE0yNiwxNi4zNkgxNgoJYy0wLjE5OSwwLTAuMzYtMC4xNjEtMC4zNi0wLjM2VjdjMC0wLjE5OSwwLjE2MS0wLjM2LDAuMzYtMC4zNmgxMGMwLjE5OSwwLDAuMzYsMC4xNjEsMC4zNiwwLjM2djkKCUMyNi4zNiwxNi4xOTksMjYuMTk5LDE2LjM2LDI2LDE2LjM2eiBNMTYuMzYsMTUuNjRoOS4yOHYtMi4yOGgtOS4yOFYxNS42NHogTTE2LjM2LDEyLjY0aDkuMjh2LTIuMjhoLTkuMjhWMTIuNjR6IE0xNi4zNiw5LjY0aDkuMjgKCVY3LjM2aC05LjI4VjkuNjR6IE0xNC42NjcsMTYuMzZoLTQuMDUxYy0yLjc0MywwLTQuOTc1LTIuMjg2LTQuOTc1LTUuMDk3YzAtMy4wNzMsMi41ODMtNS41MzMsNS41NjktNS4xNjUKCWMxLjM1OC0yLjM1OCwzLjEzLTMuNDU4LDUuNTYtMy40NThjMS45MjIsMCwzLjY3NCwwLjkwMyw0LjkzNCwyLjU0M2wtMC41NywwLjQzOGMtMS4xMjEtMS40NTgtMi42Ny0yLjI2Mi00LjM2NC0yLjI2MgoJYy0yLjIxMywwLTMuODE4LDEuMDUtNS4wNTIsMy4zMDRjLTAuMDc0LDAuMTM1LTAuMjI1LDAuMjEtMC4zNzgsMC4xODJjLTIuNjA0LTAuNDU0LTQuOTgsMS43MzgtNC45OCw0LjQxOAoJYzAsMi40MTQsMS45MDksNC4zNzcsNC4yNTUsNC4zNzdoNC4wNTFMMTQuNjY3LDE2LjM2TDE0LjY2NywxNi4zNnogTTE4LjUsMTQuODZoLTF2LTAuNzJoMVYxNC44NnogTTE4LjUsMTEuODZoLTF2LTAuNzJoMVYxMS44NnoKCSBNMTguNSw4Ljg2aC0xVjguMTRoMVY4Ljg2eiIvPgo8cmVjdCBpZD0iX1RyYW5zcGFyZW50X1JlY3RhbmdsZSIgc3R5bGU9ImZpbGw6bm9uZTsiIHdpZHRoPSIzMiIgaGVpZ2h0PSIzMiIvPgo8L3N2Zz4K'),(3,149,'icon_connection-signal','data:image/svg+xml;base64,PHN2ZyBpZD0iaWNvbiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94PSIwIDAgMzIgMzIiPjxkZWZzPjxzdHlsZT4uY2xzLTF7ZmlsbDpub25lO308L3N0eWxlPjwvZGVmcz48dGl0bGU+bW9iaWxlLWRhdGE8L3RpdGxlPjxyZWN0IHg9IjE1IiB5PSIxMiIgd2lkdGg9IjIiIGhlaWdodD0iMTgiLz48cGF0aCBkPSJNMTEuMzMsMTguMjJhNyw3LDAsMCwxLDAtMTAuNDRsMS4zNCwxLjQ5YTUsNSwwLDAsMCwwLDcuNDZaIi8+PHBhdGggZD0iTTIwLjY3LDE4LjIybC0xLjM0LTEuNDlhNSw1LDAsMCwwLDAtNy40NmwxLjM0LTEuNDlhNyw3LDAsMCwxLDAsMTAuNDRaIi8+PHBhdGggZD0iTTguNCwyMS44YTExLDExLDAsMCwxLDAtMTcuNkw5LjYsNS44YTksOSwwLDAsMCwwLDE0LjRaIi8+PHBhdGggZD0iTTIzLjYsMjEuOGwtMS4yLTEuNmE5LDksMCwwLDAsMC0xNC40bDEuMi0xLjZhMTEsMTEsMCwwLDEsMCwxNy42WiIvPjxyZWN0IGlkPSJfVHJhbnNwYXJlbnRfUmVjdGFuZ2xlXyIgZGF0YS1uYW1lPSImbHQ7VHJhbnNwYXJlbnQgUmVjdGFuZ2xlJmd0OyIgY2xhc3M9ImNscy0xIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiLz48L3N2Zz4='),(4,149,'icon_file-storage','data:image/svg+xml;base64,PHN2ZyBpZD0iaWNvbiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiI+CiAgPGRlZnM+CiAgICA8c3R5bGU+CiAgICAgIC5jbHMtMSB7CiAgICAgICAgZmlsbDogbm9uZTsKICAgICAgfQogICAgPC9zdHlsZT4KICA8L2RlZnM+CiAgPHBhdGggZD0iTTI4LDIwSDI2djJoMnY2SDRWMjJINlYyMEg0YTIuMDAyNCwyLjAwMjQsMCwwLDAtMiwydjZhMi4wMDI0LDIuMDAyNCwwLDAsMCwyLDJIMjhhMi4wMDI0LDIuMDAyNCwwLDAsMCwyLTJWMjJBMi4wMDI0LDIuMDAyNCwwLDAsMCwyOCwyMFoiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDAgMCkiLz4KICA8Y2lyY2xlIGN4PSI3IiBjeT0iMjUiIHI9IjEiLz4KICA8cGF0aCBkPSJNMjIuNzA3LDcuMjkzbC01LTVBMSwxLDAsMCwwLDE3LDJIMTFBMi4wMDIzLDIuMDAyMywwLDAsMCw5LDRWMjBhMi4wMDIzLDIuMDAyMywwLDAsMCwyLDJIMjFhMi4wMDIzLDIuMDAyMywwLDAsMCwyLTJWOEExLDEsMCwwLDAsMjIuNzA3LDcuMjkzWk0yMC41ODU3LDhIMTdWNC40MTQxWk0xMSwyMFY0aDRWOGEyLjAwMjMsMi4wMDIzLDAsMCwwLDIsMmg0VjIwWiIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMCAwKSIvPgogIDxyZWN0IGlkPSJfVHJhbnNwYXJlbnRfUmVjdGFuZ2xlXyIgZGF0YS1uYW1lPSImbHQ7VHJhbnNwYXJlbnQgUmVjdGFuZ2xlJmd0OyIgY2xhc3M9ImNscy0xIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiLz4KPC9zdmc+Cg=='),(5,149,'icon_firewall--classic','data:image/svg+xml;base64,PHN2ZyBpZD0iaWNvbiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiI+CiAgPGRlZnM+CiAgICA8c3R5bGU+CiAgICAgIC5jbHMtMSB7CiAgICAgICAgZmlsbDogIzFjMWMxYzsKICAgICAgfQoKICAgICAgLmNscy0yIHsKICAgICAgICBmaWxsOiBub25lOwogICAgICB9CiAgICA8L3N0eWxlPgogIDwvZGVmcz4KICA8cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Ik0yOCwyMFYxN2E0LDQsMCwwLDAtOCwwdjNhMi4wMDIzLDIuMDAyMywwLDAsMC0yLDJ2NmEyLjAwMjMsMi4wMDIzLDAsMCwwLDIsMmg4YTIuMDAyMywyLjAwMjMsMCwwLDAsMi0yVjIyQTIuMDAyMywyLjAwMjMsMCwwLDAsMjgsMjBabS02LTNhMiwyLDAsMCwxLDQsMHYzSDIyWm02LDExSDIwVjIyaDhaIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwIDApIi8+CiAgPHBhdGggY2xhc3M9ImNscy0xIiBkPSJNMTUsMjdINGEyLDIsMCwwLDEtMi0yVjIyYTIsMiwwLDAsMSwyLTJIMTV2Mkg0djNIMTVaIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwIDApIi8+CiAgPHBhdGggY2xhc3M9ImNscy0xIiBkPSJNMTcsMThIOGEyLDIsMCwwLDEtMi0yVjEzYTIsMiwwLDAsMSwyLTJIMTl2Mkg4djNoOVoiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDAgMCkiLz4KICA8cGF0aCBjbGFzcz0iY2xzLTEiIGQ9Ik0yMiw5SDRBMiwyLDAsMCwxLDIsN1Y0QTIsMiwwLDAsMSw0LDJIMjJhMiwyLDAsMCwxLDIsMlY3QTIsMiwwLDAsMSwyMiw5Wk00LDdIMjJWNEg0WiIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMCAwKSIvPgogIDxyZWN0IGlkPSJfVHJhbnNwYXJlbnRfUmVjdGFuZ2xlXyIgZGF0YS1uYW1lPSImbHQ7VHJhbnNwYXJlbnQgUmVjdGFuZ2xlJmd0OyIgY2xhc3M9ImNscy0yIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiLz4KPC9zdmc+Cg=='),(6,149,'icon_flow--data','data:image/svg+xml;base64,PHN2ZyBpZD0iaWNvbiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94PSIwIDAgMzIgMzIiPjxkZWZzPjxzdHlsZT4uY2xzLTF7ZmlsbDojMDAwMDAwO30uY2xzLTJ7ZmlsbDpub25lO308L3N0eWxlPjwvZGVmcz48dGl0bGU+Zmxvdy0tZGF0YTwvdGl0bGU+PHBhdGggY2xhc3M9ImNscy0xIiBkPSJNMjAsMjNIMTEuODZhNC4xNyw0LjE3LDAsMCwwLS40My0xTDIyLDExLjQzQTMuODYsMy44NiwwLDAsMCwyNCwxMmE0LDQsMCwxLDAtMy44Ni01SDExLjg2YTQsNCwwLDEsMCwwLDJoOC4yOGE0LjE3LDQuMTcsMCwwLDAsLjQzLDFMMTAsMjAuNTdBMy44NiwzLjg2LDAsMCwwLDgsMjBhNCw0LDAsMSwwLDMuODYsNUgyMHYzaDhWMjBIMjBaTTgsMTBhMiwyLDAsMSwxLDItMkEyLDIsMCwwLDEsOCwxMFpNMjQsNmEyLDIsMCwxLDEtMiwyQTIsMiwwLDAsMSwyNCw2Wk04LDI2YTIsMiwwLDEsMSwyLTJBMiwyLDAsMCwxLDgsMjZabTE0LTRoNHY0SDIyWiIvPjxyZWN0IGlkPSJfVHJhbnNwYXJlbnRfUmVjdGFuZ2xlXyIgZGF0YS1uYW1lPSImbHQ7VHJhbnNwYXJlbnQgUmVjdGFuZ2xlJmd0OyIgY2xhc3M9ImNscy0yIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiLz48L3N2Zz4='),(7,149,'icon_gateway--vpn','data:image/svg+xml;base64,PHN2ZyBpZD0iaWNvbiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiI+CiAgPGRlZnM+CiAgICA8c3R5bGU+CiAgICAgIC5jbHMtMSB7CiAgICAgICAgZmlsbDogbm9uZTsKICAgICAgfQogICAgPC9zdHlsZT4KICA8L2RlZnM+CiAgPHBhdGggZD0iTTIwLDE0LjI3ODNWMTJhNCw0LDAsMCwwLTgsMHYyLjI3ODNBMS45OTI5LDEuOTkyOSwwLDAsMCwxMSwxNnY1YTIuMDAyMywyLjAwMjMsMCwwLDAsMiwyaDZhMi4wMDIzLDIuMDAyMywwLDAsMCwyLTJWMTZBMS45OTI5LDEuOTkyOSwwLDAsMCwyMCwxNC4yNzgzWk0xNiwxMGEyLjAwMjMsMi4wMDIzLDAsMCwxLDIsMnYySDE0VjEyQTIuMDAyMywyLjAwMjMsMCwwLDEsMTYsMTBabTMsMTFIMTNWMTZoNloiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDAgMCkiLz4KICA8cGF0aCBkPSJNMzAuNDE0MSwxNy40MTQxYTEuOTk5NSwxLjk5OTUsMCwwLDAsMC0yLjgyODJMMjQuNjI3Miw4Ljc5OTNsMi45MDA2LTIuODYyOGEyLjAwMTgsMi4wMDE4LDAsMSwwLTEuNDQxNi0xLjM4NzJMMjMuMjEyOSw3LjM4NDgsMTcuNDE0MSwxLjU4NTlhMS45OTk1LDEuOTk5NSwwLDAsMC0yLjgyODIsMEw4Ljc5OTMsNy4zNzI2LDUuOTM2OCw0LjQ3MTdBMi4wMDIsMi4wMDIsMCwxLDAsNC41NSw1LjkxMzZsMi44MzUsMi44NzM1TDEuNTg1OSwxNC41ODU5YTEuOTk5NSwxLjk5OTUsMCwwLDAsMCwyLjgyODJsNS43OTg5LDUuNzk4OEw0LjU1LDI2LjA4NjRhMS45OTc3LDEuOTk3NywwLDEsMCwxLjM4NywxLjQ0MTlsMi44NjI1LTIuOTAwOSw1Ljc4NjYsNS43ODY3YTEuOTk5NSwxLjk5OTUsMCwwLDAsMi44MjgyLDBsNS43OTg4LTUuNzk4OSwyLjg3MzMsMi44MzU1YTEuOTk4LDEuOTk4LDAsMSwwLDEuNDQxNi0xLjM4NzJsLTIuOTAwNi0yLjg2MjhaTTE2LDI5LDMsMTYsMTYsMywyOSwxNloiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDAgMCkiLz4KICA8cmVjdCBpZD0iX1RyYW5zcGFyZW50X1JlY3RhbmdsZV8iIGRhdGEtbmFtZT0iJmx0O1RyYW5zcGFyZW50IFJlY3RhbmdsZSZndDsiIGNsYXNzPSJjbHMtMSIgd2lkdGg9IjMyIiBoZWlnaHQ9IjMyIi8+Cjwvc3ZnPgo='),(8,149,'icon_help','data:image/svg+xml;base64,PHN2ZyBpZD0iaWNvbiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94PSIwIDAgMzIgMzIiPjxkZWZzPjxzdHlsZT4uY2xzLTF7ZmlsbDpub25lO308L3N0eWxlPjwvZGVmcz48dGl0bGU+aGVscDwvdGl0bGU+PHBhdGggZD0iTTE2LDJBMTQsMTQsMCwxLDAsMzAsMTYsMTQsMTQsMCwwLDAsMTYsMlptMCwyNkExMiwxMiwwLDEsMSwyOCwxNiwxMiwxMiwwLDAsMSwxNiwyOFoiLz48Y2lyY2xlIGN4PSIxNiIgY3k9IjIzLjUiIHI9IjEuNSIvPjxwYXRoIGQ9Ik0xNyw4SDE1LjVBNC40OSw0LjQ5LDAsMCwwLDExLDEyLjVWMTNoMnYtLjVBMi41LDIuNSwwLDAsMSwxNS41LDEwSDE3YTIuNSwyLjUsMCwwLDEsMCw1SDE1djQuNWgyVjE3YTQuNSw0LjUsMCwwLDAsMC05WiIvPjxyZWN0IGNsYXNzPSJjbHMtMSIgd2lkdGg9IjMyIiBoZWlnaHQ9IjMyIi8+PC9zdmc+'),(9,149,'icon_iot--platform','data:image/svg+xml;base64,PHN2ZyBpZD0iaWNvbiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiI+PGRlZnM+PHN0eWxlPi5jbHMtMXtmaWxsOm5vbmU7fTwvc3R5bGU+PC9kZWZzPjx0aXRsZT5pb3QtLXBsYXRmb3JtPC90aXRsZT48cGF0aCBkPSJNMzAsMTlIMjZWMTVIMjR2OUg4VjhsOS0uMDAwOVY2SDEzVjJIMTFWNkg4QTIuMDAyLDIuMDAyLDAsMCwwLDYsOHYzSDJ2Mkg2djZIMnYySDZ2M2EyLjAwMjMsMi4wMDIzLDAsMCwwLDIsMmgzdjRoMlYyNmg2djRoMlYyNmgzYTIuMDAyNywyLjAwMjcsMCwwLDAsMi0yVjIxaDRaIi8+PHBhdGggZD0iTTIxLDIxSDExVjExSDIxWm0tOC0yaDZWMTNIMTNaIi8+PHBhdGggZD0iTTMxLDEzSDI5QTEwLjAxMTcsMTAuMDExNywwLDAsMCwxOSwzVjFBMTIuMDEzMSwxMi4wMTMxLDAsMCwxLDMxLDEzWiIvPjxwYXRoIGQ9Ik0yNiwxM0gyNGE1LjAwNTksNS4wMDU5LDAsMCwwLTUtNVY2QTcuMDA4NSw3LjAwODUsMCwwLDEsMjYsMTNaIi8+PHJlY3QgaWQ9Il9UcmFuc3BhcmVudF9SZWN0YW5nbGVfIiBkYXRhLW5hbWU9IiZsdDtUcmFuc3BhcmVudCBSZWN0YW5nbGUmZ3Q7IiBjbGFzcz0iY2xzLTEiIHdpZHRoPSIzMiIgaGVpZ2h0PSIzMiIvPjwvc3ZnPg=='),(10,149,'icon_kubernetes--pod','data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyBpZD0iaWNvbiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiI+CiAgPGRlZnM+CiAgICA8c3R5bGU+CiAgICAgIC5jbHMtMSB7CiAgICAgICAgZmlsbDogbm9uZTsKICAgICAgfQogICAgPC9zdHlsZT4KICA8L2RlZnM+CiAgPHBhdGggZD0ibTIyLjUwNDYsMTEuNjM2OGwtNS45ODgzLTMuNWMtLjE1OTQtLjA5MzMtLjMzODEtLjEzODctLjUxNjQtLjEzNjctLjE2OTkuMDAyLS4zMzk0LjA0NzQtLjQ5MTUuMTM1N2wtNi4wMTE3LDMuNWMtLjMwNzYuMTc5Mi0uNDk2OC41MDgzLS40OTY4Ljg2NDN2N2MwLC4zNTYuMTg5Mi42ODUxLjQ5NjguODY0M2w2LjAxMTcsMy41Yy4xNTU1LjA5MDMuMzE3Ni4xMzU3LjQ5MTUuMTM1Ny4xNzQzLDAsLjM2MDQtLjA0NTQuNTE2NC0uMTM2N2w1Ljk4ODMtMy41Yy4zMDY5LS4xNzkyLjQ5NTQtLjUwNzguNDk1NC0uODYzM3YtN2MwLS4zNTU1LS4xODg1LS42ODQxLS40OTU0LS44NjMzWm0tNi40OTM5LTEuNDc5bDQuMDA3NiwyLjM0MjMtNC4wMDc2LDIuMzQyMy00LjAyMzItMi4zNDIzLDQuMDIzMi0yLjM0MjNabS01LjAxMDcsNC4wODE1bDQsMi4zMjkxdjQuNjg1NWwtNC0yLjMyOTF2LTQuNjg1NVptNiw3LjAyNDl2LTQuNjgzNmw0LTIuMzM3OXY0LjY4MzZsLTQsMi4zMzc5WiIvPgogIDxwYXRoIGQ9Im0xNiwzMWMtLjE3NDEsMC0uMzQ4MS0uMDQ1NC0uNTAzOS0uMTM2MmwtMTItN2MtLjMwNzEtLjE3OTItLjQ5NjEtLjUwODEtLjQ5NjEtLjg2Mzh2LTE0YzAtLjM1NTcuMTg5LS42ODQ2LjQ5NjEtLjg2MzhMMTUuNDk2MSwxLjEzNjJjLjE1NTgtLjA5MDguMzI5OC0uMTM2Mi41MDM5LS4xMzYycy4zNDgxLjA0NTQuNTAzOS4xMzYybDExLDYuNDE2Ni0xLjAwNzgsMS43Mjc1LTEwLjQ5NjEtNi4xMjI3LTExLDYuNDE2NnYxMi44NTEzbDExLDYuNDE2NiwxMS02LjQxNjZ2LTcuNDI1N2gydjhjMCwuMzU1Ny0uMTg5LjY4NDYtLjQ5NjEuODYzOGwtMTIsN2MtLjE1NTguMDkwOC0uMzI5OC4xMzYyLS41MDM5LjEzNjJaIi8+CiAgPHJlY3QgaWQ9Il9UcmFuc3BhcmVudF9SZWN0YW5nbGVfIiBkYXRhLW5hbWU9IiZhbXA7bHQ7VHJhbnNwYXJlbnQgUmVjdGFuZ2xlJmFtcDtndDsiIGNsYXNzPSJjbHMtMSIgd2lkdGg9IjMyIiBoZWlnaHQ9IjMyIi8+Cjwvc3ZnPg==');
/*!40000 ALTER TABLE `metadata_attribute_icons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metadata_attribute_values`
--

DROP TABLE IF EXISTS `metadata_attribute_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `metadata_attribute_values` (
  `namespace_id` int(11) NOT NULL COMMENT ' foreignKey: net.metadata_namespace.id',
  `attribute_id` int(11) NOT NULL COMMENT ' foreignKey: net.metadata_attribute.id',
  `value` varchar(256) NOT NULL COMMENT 'The name of the attribute.',
  PRIMARY KEY (`namespace_id`,`attribute_id`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the Metadata attribute values';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metadata_attribute_values`
--
-- WHERE:  1 limit 10

LOCK TABLES `metadata_attribute_values` WRITE;
/*!40000 ALTER TABLE `metadata_attribute_values` DISABLE KEYS */;
INSERT INTO `metadata_attribute_values` VALUES (1,84,'ACTIVE'),(1,84,'PASSIVE'),(1,84,'UNKNOWN'),(12,149,'icon_bare-metal-server--01'),(12,149,'icon_cloud--infrastructure-management'),(12,149,'icon_connection-signal'),(12,149,'icon_data--center'),(12,149,'icon_file-storage'),(12,149,'icon_firewall--classic'),(12,149,'icon_flow--data');
/*!40000 ALTER TABLE `metadata_attribute_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metadata_map`
--

DROP TABLE IF EXISTS `metadata_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `metadata_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The ID of the metadata map value',
  `attribute_id` int(11) NOT NULL COMMENT ' foreignKey: net.metadata_attribute.id',
  `entity_type` enum('devicegroup','objectgroup','objecttype','indicatortype') NOT NULL COMMENT 'The entity type to which this value is mapped',
  `entity_id` int(11) NOT NULL COMMENT 'The ID of the entity to which this value is mapped. This is a foreign key but the key does not directly point to a specific table but points to the table that the entity type tells us to point to.',
  `string_value` varchar(1024) DEFAULT NULL COMMENT 'The value of the attribute mapped to the given entity.',
  `blob_value` blob DEFAULT NULL COMMENT 'The blob value of the attribute mapped to the given entity.',
  `updated_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'This is the date at which metadata was updated.',
  PRIMARY KEY (`id`),
  KEY `attribute` (`attribute_id`),
  KEY `entity` (`entity_id`,`entity_type`),
  KEY `string_value` (`string_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the mappings of what entities are assigned what string attributes.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metadata_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `metadata_map` WRITE;
/*!40000 ALTER TABLE `metadata_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `metadata_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metadata_namespace`
--

DROP TABLE IF EXISTS `metadata_namespace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `metadata_namespace` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `name` varchar(255) NOT NULL COMMENT 'The name of the metadata namespace.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the basic information about Metadata namespaces.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metadata_namespace`
--
-- WHERE:  1 limit 10

LOCK TABLES `metadata_namespace` WRITE;
/*!40000 ALTER TABLE `metadata_namespace` DISABLE KEYS */;
INSERT INTO `metadata_namespace` VALUES (24,'BFG_NMDB_Enrichment'),(25,'csvNamespace'),(12,'Device'),(11,'Flow'),(20,'GHtesting'),(19,'Infoblox_Object_Enrichment'),(13,'Location'),(29,'Random Device 3 Data'),(26,'Random Device Data'),(28,'Random Object 2 Data');
/*!40000 ALTER TABLE `metadata_namespace` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mustgather`
--

DROP TABLE IF EXISTS `mustgather`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mustgather` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'MustGather request id',
  `case_id` varchar(32) NOT NULL COMMENT 'Sevone Support Case ID used to track mustgathers requeted against a case',
  `state` varchar(32) NOT NULL COMMENT 'State of the must gather process used to determine internal conditions',
  `status` varchar(32) NOT NULL COMMENT 'Aggregated status of the mustgather across requested peers',
  `sigterm` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Used as a signal to cancel the ongoing mustgather request',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Timestamp when mustgather request intiated',
  `last_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Timestamp when last updated the Status/State',
  `file_path` text DEFAULT NULL COMMENT 'Path to the evidence file (if available)',
  `result` varchar(255) DEFAULT NULL COMMENT 'Used to describe the status of the request or error if any',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table maintains the Status of mustgather requests';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mustgather`
--
-- WHERE:  1 limit 10

LOCK TABLES `mustgather` WRITE;
/*!40000 ALTER TABLE `mustgather` DISABLE KEYS */;
/*!40000 ALTER TABLE `mustgather` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mustgather_peers`
--

DROP TABLE IF EXISTS `mustgather_peers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mustgather_peers` (
  `request_id` int(11) unsigned NOT NULL COMMENT 'MustGather request id',
  `peer_id` int(11) unsigned NOT NULL COMMENT 'Peer ID',
  `appliance_type` varchar(32) NOT NULL COMMENT 'appliance type. primary/secondary',
  `modules` varchar(255) NOT NULL COMMENT 'Modules for evidence collection, comma separated values',
  `status` varchar(32) NOT NULL COMMENT 'Mustgather execution status on peer',
  `file_path` text DEFAULT NULL COMMENT 'Path to the evidence file in the peer (if available)',
  `result` varchar(255) DEFAULT NULL COMMENT 'Used to describe the  status of the request or error if any',
  PRIMARY KEY (`request_id`,`peer_id`,`appliance_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table maintains the Status of mustgather requests on a peer';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mustgather_peers`
--
-- WHERE:  1 limit 10

LOCK TABLES `mustgather_peers` WRITE;
/*!40000 ALTER TABLE `mustgather_peers` DISABLE KEYS */;
/*!40000 ALTER TABLE `mustgather_peers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_complex_fields`
--

DROP TABLE IF EXISTS `netflow_complex_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_complex_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `ref_netflow_field_id` bigint(20) DEFAULT NULL COMMENT 'This is the source column id foreignKey: net.netflow_fields.element_id',
  `syn_netflow_field_id` bigint(20) DEFAULT NULL COMMENT 'This is the destination column id. foreignKey: net.netflow_fields.element_id',
  `bit_position` int(11) DEFAULT NULL COMMENT 'Offset in bits from the LSB within the word, starting with bit 0',
  `bit_size` int(11) DEFAULT NULL COMMENT 'This is the number of bits to extract starting at the bit position, towards the MSB.  ',
  PRIMARY KEY (`id`),
  UNIQUE KEY `syn_id_key` (`syn_netflow_field_id`),
  KEY `ref_id_key` (`ref_netflow_field_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This store information about ''special fields''.  This is used for decomposing single fields in to multiple fields.  It is used to help reporting, because SQL can''t pull out individual bits from a column in a query.  The rows are very important, and SevOne should keep a set in version control';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_complex_fields`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_complex_fields` WRITE;
/*!40000 ALTER TABLE `netflow_complex_fields` DISABLE KEYS */;
INSERT INTO `netflow_complex_fields` VALUES (3,6,140,0,6),(4,6,141,0,3),(5,6,355,3,3),(6,6,356,3,4);
/*!40000 ALTER TABLE `netflow_complex_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_enterprise_fields`
--

DROP TABLE IF EXISTS `netflow_enterprise_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_enterprise_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `enterpriseID` int(11) NOT NULL COMMENT 'This is the organization''s enterprise identification number assigned by The Internet Assigned Numbers Authority.',
  `organization` varchar(256) DEFAULT NULL COMMENT 'This is the organization associated with the enterprise identification number.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `enterpriseID_key` (`enterpriseID`)
) ENGINE=MyISAM AUTO_INCREMENT=46331 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is an enumeration of all registered organizations and their certified enterprise identification numbers assigned by The Internet Assigned Numbers Authority (IANA). The official source for this information is https://www.iana.org/assignments/enterprise-numbers/enterprise-numbers.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_enterprise_fields`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_enterprise_fields` WRITE;
/*!40000 ALTER TABLE `netflow_enterprise_fields` DISABLE KEYS */;
INSERT INTO `netflow_enterprise_fields` VALUES (1,0,'Reserved'),(2,1,'NxNetworks'),(3,2,'IBM'),(4,3,'Carnegie Mellon'),(5,4,'Unix'),(6,5,'ACC'),(7,6,'TWG'),(8,7,'CAYMAN'),(9,8,'PSI'),(10,9,'ciscoSystems');
/*!40000 ALTER TABLE `netflow_enterprise_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_fields`
--

DROP TABLE IF EXISTS `netflow_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `name` varchar(256) DEFAULT NULL COMMENT 'This is a textual identifier of the field displayed on reports.  This is displayed to the user.',
  `description` varchar(256) DEFAULT NULL COMMENT 'This is a human readable description of the field.  This is displayed to the user.',
  `element_id` bigint(20) DEFAULT NULL COMMENT 'This is the netflow field ID.  It is the field identification number specified by v5, v9 or v10 RFCs. For an example, see RFC 3954 (link at top).  We also use this for synthetic field ids that are created by SevOne to identitfy fields the are derived from other soruces',
  `byte_size` int(11) DEFAULT NULL COMMENT 'The number of bytes in the field for fields that can have multiple by sizes.  It should be the largest.',
  `field_type` varchar(32) DEFAULT NULL COMMENT 'This column is a string used to determine the type of field for the SevOneNMS systems.  It can format fields and filter certain field types.  It should become and enumeration',
  `database_type` varchar(32) DEFAULT NULL COMMENT 'This controls the type of database column used for the field.  It should become an enumeration.',
  `is_key` tinyint(1) DEFAULT NULL COMMENT 'This is used for documenting if the field is a netflow key or a netflow metric.  1 for a netflow key, 0 for netflow metric',
  `is_supported` tinyint(1) DEFAULT NULL COMMENT 'This is used to skip over fields that we don''t want to display.  Double check with Brad if dealing with this field.',
  `is_synthetic` tinyint(1) DEFAULT NULL COMMENT 'This is a field that requires ''special'' handling to extract the bitfields within a word as synthetic values',
  `is_custom` tinyint(1) DEFAULT 0 COMMENT 'Is this field added by the system or by the user',
  `default_aggregation` tinyint(1) DEFAULT 0 COMMENT 'Default aggregation for this metric field',
  `data_units` varchar(32) DEFAULT 'number' COMMENT 'This metric field''s values are stored in this scale',
  `display_units` varchar(32) DEFAULT 'number' COMMENT 'This metric field''s values should be displyed as this sacle',
  PRIMARY KEY (`id`),
  UNIQUE KEY `element_id_key` (`element_id`),
  UNIQUE KEY `name_key` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=739 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is an enumeration of all of the field types that netflow supports. This includes native fields from all templates, and synthetic fields that are derived from native template information and other sources.  See the following for more information RFC 3954 at http://www.ietf.org/rfc/rfc3954.txt.  This ships with default information.  The rows are very important, and SevOne should keep a set in version control';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_fields`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_fields` WRITE;
/*!40000 ALTER TABLE `netflow_fields` DISABLE KEYS */;
INSERT INTO `netflow_fields` VALUES (1,'NetFlow Information',NULL,-1,NULL,'ignore',NULL,0,1,0,0,0,'ignore','ignore'),(2,'Flows','stores the cumulative number of flows for a particular aggregation filter set',0,-1,'number','BIGINT UNSIGNED',0,1,0,0,0,'number','number'),(3,'Bandwidth','Incoming counter with length N x 8 bits for number of bytes associated with an IP Flow.',1,8,'bytes','BIGINT UNSIGNED',0,1,0,0,0,'bytes','bytes'),(4,'Packets','Incoming counter with length N x 8 bits for the number of packets associated with an IP Flow.',2,8,'number','BIGINT UNSIGNED',0,1,0,0,0,'number','number'),(5,'Protocol','IP protocol byte.',4,1,'protocol','TINYINT UNSIGNED',1,1,0,0,0,NULL,NULL),(6,'ToS','Type of Service byte setting when entering incoming interface.',5,1,'','TINYINT UNSIGNED',1,1,0,0,0,NULL,NULL),(7,'TCP Control Bits','Cumulative of all the TCP flags seen for this flow.',6,1,'tcp','TINYINT UNSIGNED',1,1,0,0,0,NULL,NULL),(8,'Source Port','TCP/UDP source port number ie : FTP, Telnet, or equivalent.',7,2,'port','SMALLINT UNSIGNED',1,1,0,0,0,NULL,NULL),(9,'Source IP','IPv4 source address.',8,4,'ip','INT UNSIGNED',1,1,0,0,0,NULL,NULL),(10,'Source Prefix','The number of contiguous bits in the source address subnet mask ie: the submask in slash notation.',9,1,'','TINYINT UNSIGNED',1,1,0,0,0,NULL,NULL);
/*!40000 ALTER TABLE `netflow_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_lookup_table`
--

DROP TABLE IF EXISTS `netflow_lookup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_lookup_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `name` varchar(255) NOT NULL COMMENT 'The name of the lookup table',
  `version` varchar(15) DEFAULT NULL COMMENT 'The version of the lookup table',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table holds all key lookup tables';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_lookup_table`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_lookup_table` WRITE;
/*!40000 ALTER TABLE `netflow_lookup_table` DISABLE KEYS */;
INSERT INTO `netflow_lookup_table` VALUES (1,'NBAR2','60.0(0)'),(2,'Velocloud vcPriority','1.0'),(3,'Velocloud vcRouteType','1.0'),(4,'Velocloud vcLinkPolicy','1.0'),(5,'Velocloud vcTrafficType','1.0'),(6,'Velocloud vcFlowPath','1.0'),(7,'BiFlow Direction','1.0');
/*!40000 ALTER TABLE `netflow_lookup_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_lookup_table_code`
--

DROP TABLE IF EXISTS `netflow_lookup_table_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_lookup_table_code` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `table_id` int(11) NOT NULL COMMENT ' foreignKey: net.netflow_lookup_table.id',
  `code` varchar(50) NOT NULL COMMENT 'The key of the lookup',
  `value` varchar(50) NOT NULL COMMENT 'The resolve value of the lookup',
  PRIMARY KEY (`id`),
  UNIQUE KEY `table_id_code` (`table_id`,`code`),
  KEY `table_id` (`table_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1525 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table holds all lookup table code values';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_lookup_table_code`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_lookup_table_code` WRITE;
/*!40000 ALTER TABLE `netflow_lookup_table_code` DISABLE KEYS */;
INSERT INTO `netflow_lookup_table_code` VALUES (1,1,'50332277','3com-amp3'),(2,1,'50331754','3com-tsmux'),(3,1,'16777250','3pc'),(4,1,'50331859','914c/g'),(5,1,'50332212','9pfs'),(6,1,'50332322','acap'),(7,1,'50331710','acas'),(8,1,'50332536','accessbuilder'),(9,1,'50332347','accessnetwork'),(10,1,'50332247','acp');
/*!40000 ALTER TABLE `netflow_lookup_table_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_lookup_table_field`
--

DROP TABLE IF EXISTS `netflow_lookup_table_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_lookup_table_field` (
  `table_id` int(11) NOT NULL COMMENT ' foreignKey: net.netflow_lookup_table.id',
  `element_id` bigint(20) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.netflow_fields.element_id',
  PRIMARY KEY (`table_id`,`element_id`),
  UNIQUE KEY `field_id` (`element_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table holds which element the lookup table is responsible for';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_lookup_table_field`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_lookup_table_field` WRITE;
/*!40000 ALTER TABLE `netflow_lookup_table_field` DISABLE KEYS */;
INSERT INTO `netflow_lookup_table_field` VALUES (1,95),(2,194761734500298),(3,194761734500299),(4,194761734500300),(5,194761734500301),(6,194761734500303),(7,239);
/*!40000 ALTER TABLE `netflow_lookup_table_field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_options_template_elements`
--

DROP TABLE IF EXISTS `netflow_options_template_elements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_options_template_elements` (
  `netflow_option_template_id` int(11) unsigned NOT NULL COMMENT 'option template id refers to id in the netflow_options_templates table foreignKey: net.netflow_options_templates.id',
  `element_id` bigint(20) NOT NULL COMMENT 'field id',
  `length` int(11) DEFAULT 0 COMMENT 'length of netflow field',
  `order_number` int(11) DEFAULT 0 COMMENT 'the order number of netflow field in option template',
  `is_scope_field` tinyint(1) DEFAULT 0 COMMENT 'this is the lable to check if the field is scope field',
  `is_variable_length` tinyint(1) DEFAULT 0 COMMENT 'Is the field variable length',
  PRIMARY KEY (`netflow_option_template_id`,`element_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='The table contains all of the fields that belong to option templates accross the cluster. ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_options_template_elements`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_options_template_elements` WRITE;
/*!40000 ALTER TABLE `netflow_options_template_elements` DISABLE KEYS */;
INSERT INTO `netflow_options_template_elements` VALUES (1,149,4,0,1,0),(1,304,2,1,0,0),(1,305,4,2,0,0),(1,306,4,3,0,0),(2,145,2,0,1,0),(2,2738041651214,2,1,1,0),(2,304,2,2,0,0),(2,305,4,3,0,0),(2,306,4,4,0,0);
/*!40000 ALTER TABLE `netflow_options_template_elements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_options_template_resolvers`
--

DROP TABLE IF EXISTS `netflow_options_template_resolvers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_options_template_resolvers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `netflow_option_template_id` int(11) unsigned NOT NULL COMMENT 'netflow option template id refers to netflow_options_templates.id. foreignKey: net.netflow_options_templates.id',
  `element_id_resolver` bigint(20) NOT NULL COMMENT 'the sevone-assigned id of the synthetic key containing the resolved expression. foreignKey: net.netflow_fields.element_id',
  `expression` text NOT NULL COMMENT 'the string expression that determines the format of the resolved value. It must be compromised of element_id''s seen as part of the options template associated with this resolver',
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'this is the label to check if this resolved is enabled by user',
  PRIMARY KEY (`id`),
  UNIQUE KEY `template_resolver` (`netflow_option_template_id`,`element_id_resolver`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the mapping between ''resolvers'' (sevone-assigned synthetic keys) and options templates. Note that while one row will exist in this table for every options template that uses the same element_id_resolver, the expression will be the same for all of them';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_options_template_resolvers`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_options_template_resolvers` WRITE;
/*!40000 ALTER TABLE `netflow_options_template_resolvers` DISABLE KEYS */;
/*!40000 ALTER TABLE `netflow_options_template_resolvers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_options_template_resolvers_element_id_map`
--

DROP TABLE IF EXISTS `netflow_options_template_resolvers_element_id_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_options_template_resolvers_element_id_map` (
  `element_id_resolver` bigint(20) NOT NULL COMMENT 'the sevone-assigned id of the synthetic key containing the resolved expression. foreignKey: net.netflow_fields.element_id',
  `element_id` bigint(20) NOT NULL COMMENT 'a resolve key present in both the options and data flow. foreignKey: net.netflow_fields.element_id',
  PRIMARY KEY (`element_id_resolver`,`element_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the set of resolve keys for every sevone-assigned synthetic key associated with options template resolvers';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_options_template_resolvers_element_id_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_options_template_resolvers_element_id_map` WRITE;
/*!40000 ALTER TABLE `netflow_options_template_resolvers_element_id_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `netflow_options_template_resolvers_element_id_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_options_templates`
--

DROP TABLE IF EXISTS `netflow_options_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_options_templates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(256) DEFAULT NULL COMMENT 'name of option template. configured by user',
  `hash` binary(16) NOT NULL COMMENT 'this is the md5 hash value of option template',
  `last_seen` int(11) unsigned NOT NULL COMMENT 'This is the last time we saw this template',
  PRIMARY KEY (`id`),
  UNIQUE KEY `hash` (`hash`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='These are the option templates that the netflow sources have sent to the appliance. ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_options_templates`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_options_templates` WRITE;
/*!40000 ALTER TABLE `netflow_options_templates` DISABLE KEYS */;
INSERT INTO `netflow_options_templates` VALUES (1,NULL,'ðÂwGSì— ¨ûaˆ“e',1766553241),(2,NULL,'äŽå§&\'mmŸyiÉÀ?',1766553266),(3,NULL,'þW ¹êŠoNÀ#9Ùn',1766553267);
/*!40000 ALTER TABLE `netflow_options_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowdeviceinfo`
--

DROP TABLE IF EXISTS `netflowdeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowdeviceinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `origin_ip` varbinary(40) DEFAULT NULL COMMENT 'This is the ip where the flows came from.  We only want one entry per IP address.  This column does not support IPv6',
  `versions` varchar(64) DEFAULT '' COMMENT 'This is list of version of the flows in presentation format',
  `peer` int(11) DEFAULT -1 COMMENT 'This is the peer the netflow is going to.  This is the peer id foreignKey: net.peers.server_id',
  `name` varchar(255) DEFAULT NULL COMMENT 'This name of the device.  This does not map directly to devices per se.  The end user can set this to anything.',
  `system_name` varchar(255) DEFAULT NULL COMMENT 'This is the name of the device based on the snmp information.  This could potentially replaced with a convential foriegn key to the device id',
  `override_name` tinyint(4) DEFAULT 0 COMMENT 'This controls if the system resets the name to what it discovers.  However, the functionallity was not implemented as of Feb 22, 2013',
  `visible` tinyint(4) DEFAULT 0 COMMENT 'This controls if it shows up in the gui',
  PRIMARY KEY (`id`),
  UNIQUE KEY `peer_ip` (`peer`,`origin_ip`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the list of devices in the network sending flows to the appliance.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowdeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowdeviceinfo` WRITE;
/*!40000 ALTER TABLE `netflowdeviceinfo` DISABLE KEYS */;
INSERT INTO `netflowdeviceinfo` VALUES (1,'64400065','v10',1,'CSVDevice1','CSVDevice1',0,0);
/*!40000 ALTER TABLE `netflowdeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowdevicemove`
--

DROP TABLE IF EXISTS `netflowdevicemove`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowdevicemove` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `dev_id` int(11) NOT NULL COMMENT 'Foreign Key to net.netflowdeviceinfo. foreignKey: net.netflowdeviceinfo.id',
  `new_dev_id` int(11) NOT NULL COMMENT 'New netflow device id. foreignKey: net.netflowdeviceinfo.id',
  `source_peer` int(11) DEFAULT NULL COMMENT 'Source peer of this device. foreignKey: net.peers.server_id',
  `destination_peer` int(11) DEFAULT NULL COMMENT 'Destination peer of this device. foreignKey: net.peers.server_id',
  `time_added` int(11) DEFAULT 0 COMMENT 'Time this move was added',
  `time_started` int(11) DEFAULT 0 COMMENT 'The the move was started',
  `time_finished` int(11) DEFAULT 0 COMMENT 'Time the move was finished',
  `move_log` text DEFAULT NULL COMMENT 'The log of this move',
  `label` varchar(128) NOT NULL COMMENT 'The label used for moving the device',
  `is_exporting` int(11) DEFAULT 0 COMMENT 'If this device is exporting when true',
  `is_transferring` int(11) DEFAULT 0 COMMENT 'If this device is transferring when true',
  `is_importing` int(11) DEFAULT 0 COMMENT 'If this device is importing when true',
  `is_completed` int(11) DEFAULT 0 COMMENT 'Is this move complete',
  `is_working` int(11) DEFAULT 0 COMMENT 'Is the move currently active',
  `failed` tinyint(4) DEFAULT 0 COMMENT 'Did this job fail',
  PRIMARY KEY (`id`),
  KEY `is_completed` (`is_completed`),
  KEY `is_working` (`is_working`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Device Move Jobs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowdevicemove`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowdevicemove` WRITE;
/*!40000 ALTER TABLE `netflowdevicemove` DISABLE KEYS */;
/*!40000 ALTER TABLE `netflowdevicemove` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowpeerstats`
--

DROP TABLE IF EXISTS `netflowpeerstats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowpeerstats` (
  `peer_id` int(11) NOT NULL COMMENT ' foreignKey: net.peers.server_id',
  `device_count` int(11) NOT NULL COMMENT 'The number of devices we are collecting flow for on this peer',
  `interface_count` int(11) NOT NULL COMMENT 'The number of interfaces that we are collecting flows for on this peer.',
  `flows_per_second` int(11) NOT NULL COMMENT 'This is the number of flows per second that are arriving at the appliance.  This is a rolling average over the past minute',
  `flows_per_second_processed` int(11) NOT NULL COMMENT 'This is the number of flows per second that are arriving at the appliance and made it past the netflow firewall.  This is a rolling average over the past minute',
  `flows_per_second_dropped` int(11) NOT NULL COMMENT 'This is the number of flows per second that are arriving at the appliance and DID NOT MAKE it past the netflow firewall.  This is a rolling average over the past minute',
  `flow_only_device_count` int(11) NOT NULL DEFAULT 0 COMMENT 'Total flow only devices for that peer',
  UNIQUE KEY `peer_id_key` (`peer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This are statistics about various things collected per peer.  It is possible reproduce this information from the net.netflowdeviceinfo, local.netflowinterface, and local.netflowstats tables.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowpeerstats`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowpeerstats` WRITE;
/*!40000 ALTER TABLE `netflowpeerstats` DISABLE KEYS */;
INSERT INTO `netflowpeerstats` VALUES (1,0,0,0,0,0,0);
/*!40000 ALTER TABLE `netflowpeerstats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowpluginmap`
--

DROP TABLE IF EXISTS `netflowpluginmap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowpluginmap` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `netflow_device_id` int(11) DEFAULT NULL COMMENT 'netflow_device_id foreignKey: net.netflowdeviceinfo.id',
  `direction_id` int(11) DEFAULT NULL COMMENT ' foreignKey: local.netflowdirection.id',
  `device_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `peer` int(11) DEFAULT -1 COMMENT ' foreignKey: net.peers.server_id',
  `plugin_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.plugins.id',
  `object_id` int(11) DEFAULT NULL COMMENT ' foreignKey: local.device_object.id',
  `indicator_id` int(11) DEFAULT NULL COMMENT ' foreignKey: local.device_indicator.id',
  `automatic` tinyint(4) DEFAULT 1 COMMENT 'This is 1 if the SevOne script added this to the table, a 0 if the user set it.',
  `filter_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.flowfalconfilters.id',
  `view_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.flowfalconview.id',
  `allow` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'allow',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_device_mapping` (`netflow_device_id`,`device_id`,`automatic`),
  UNIQUE KEY `unique_tuple` (`direction_id`,`device_id`,`indicator_id`,`peer`),
  KEY `device_id` (`device_id`),
  KEY `peer` (`peer`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table maps between netflow directions and indications in the SevONe plugin architecture.  This is used to have netflow play nice with SURF.  This table is automatically populated for inOctets, outOctets, inHCOctets,outHCOctets, totalOctets, and totalHCOctets';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowpluginmap`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowpluginmap` WRITE;
/*!40000 ALTER TABLE `netflowpluginmap` DISABLE KEYS */;
INSERT INTO `netflowpluginmap` VALUES (1,1,NULL,50,-1,NULL,NULL,NULL,0,NULL,NULL,1);
/*!40000 ALTER TABLE `netflowpluginmap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowsubnetcategories`
--

DROP TABLE IF EXISTS `netflowsubnetcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowsubnetcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the category.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='A NetFlow ''subnet category'' is a named container that will hold any number of network segments.  The category is used to differentiate between different KINDS of network segments; thus, network segments in different categories may overlap.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowsubnetcategories`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowsubnetcategories` WRITE;
/*!40000 ALTER TABLE `netflowsubnetcategories` DISABLE KEYS */;
/*!40000 ALTER TABLE `netflowsubnetcategories` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `netflowsubnetcategories_push_subnet_category_name` AFTER UPDATE
ON `net`.`netflowsubnetcategories` FOR EACH ROW
UPDATE netflowsubnets SET netflowsubnets.netflow_subnet_category_name = ( SELECT name FROM netflowsubnetcategories WHERE netflowsubnetcategories.id = netflowsubnets.netflow_subnet_category_id ) WHERE netflow_subnet_category_id = NEW.id */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `netflowsubnets`
--

DROP TABLE IF EXISTS `netflowsubnets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowsubnets` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name of the subnet. Subnets with the same name with be aggregated in the report',
  `ip` varbinary(40) DEFAULT NULL COMMENT 'The ip of the subnet.  E.g. for 192.168.91.0/24, this would be 192.168.91.0',
  `prefix` int(11) DEFAULT 0 COMMENT 'This is the size of the prefix mask.  E.g. for 192.168.91.0/24, this would be 24',
  `netflow_subnet_category_id` int(11) DEFAULT 0 COMMENT ' foreignKey: net.netflowsubnetcategories.id',
  `netflow_subnet_category_name` varchar(32) DEFAULT NULL COMMENT 'This is the denormalized category name.  Perhaps this can be properly normalized, investigate performance',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`ip`,`prefix`,`netflow_subnet_category_id`),
  KEY `category_name__name` (`netflow_subnet_category_name`,`name`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This contains the subnets that belong to they given netflow subnet category';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowsubnets`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowsubnets` WRITE;
/*!40000 ALTER TABLE `netflowsubnets` DISABLE KEYS */;
/*!40000 ALTER TABLE `netflowsubnets` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `netflowsubnets_get_subnet_category_name` BEFORE INSERT
ON `net`.`netflowsubnets` FOR EACH ROW
SET NEW.netflow_subnet_category_name = ( SELECT name FROM netflowsubnetcategories WHERE netflowsubnetcategories.id = NEW.netflow_subnet_category_id ) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `networkoverview_indicators`
--

DROP TABLE IF EXISTS `networkoverview_indicators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `networkoverview_indicators` (
  `template_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.networkoverview_templates.id',
  `plugin_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.plugins.id',
  `object_type` int(11) DEFAULT NULL COMMENT ' foreignKey: net.plugin_object_type.id',
  `sub_type` int(11) DEFAULT NULL COMMENT ' foreignKey: net.objectsubtypes.id',
  `plugin_indicator_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_indicator_type.id',
  `percentable` int(11) DEFAULT 0 COMMENT 'If this is percentable',
  `filter_op` varchar(32) DEFAULT NULL COMMENT 'Which Filter op should we use',
  `filter_value` double DEFAULT NULL COMMENT 'What filter value should we use',
  `filter_units` varchar(64) DEFAULT NULL COMMENT 'Which Filter units should we use',
  `aggregate_op` varchar(32) DEFAULT NULL COMMENT 'Is there an Aggreation Operation',
  `alias` varchar(128) DEFAULT '' COMMENT 'Is there an alias',
  `sorted` smallint(6) DEFAULT 0 COMMENT 'Is this sorted',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `device_type_id` int(11) NOT NULL COMMENT ' foreignKey: net.devicetags.id',
  `percentile_value` double DEFAULT NULL COMMENT 'Percentile values used in percentile calculations',
  `column_order` int(11) DEFAULT NULL COMMENT 'Secifies the order of the secondary indicators',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniquecheck` (`template_id`,`sub_type`,`plugin_indicator_type_id`,`aggregate_op`,`percentile_value`),
  KEY `template_id` (`template_id`)
) ENGINE=InnoDB AUTO_INCREMENT=872 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Indicator in network overview templates';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `networkoverview_indicators`
--
-- WHERE:  1 limit 10

LOCK TABLES `networkoverview_indicators` WRITE;
/*!40000 ALTER TABLE `networkoverview_indicators` DISABLE KEYS */;
INSERT INTO `networkoverview_indicators` VALUES (1,1,274,-1,51,1,'>',0,'Bytes','AVG','in',1,1,43,NULL,NULL),(1,1,274,-1,52,1,'>',0,'Bytes','AVG','out',1,2,43,NULL,NULL),(1,1,274,-1,20,1,'>',0,'Bytes','AVG','out',1,3,43,NULL,NULL),(1,1,274,-1,19,1,'>',0,'Bytes','AVG','in',1,4,43,NULL,NULL),(2,1,274,-1,35,0,'>',0,'Number','AVG','in',1,5,43,NULL,NULL),(2,1,274,-1,36,0,'>',0,'Number','AVG','out',1,6,43,NULL,NULL),(3,1,274,-1,37,0,'>',0,'Number','AVG','in',1,7,43,NULL,NULL),(3,1,274,-1,38,0,'>',0,'Number','AVG','out',1,8,43,NULL,NULL),(4,1,274,-1,5,0,'>',0,'Number','AVG','in',1,9,43,NULL,NULL),(4,1,274,-1,7,0,'>',0,'Number','AVG','out',1,10,43,NULL,NULL);
/*!40000 ALTER TABLE `networkoverview_indicators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `networkoverview_templates`
--

DROP TABLE IF EXISTS `networkoverview_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `networkoverview_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `name` varchar(120) DEFAULT NULL COMMENT 'The name of the template.',
  `custom` smallint(6) DEFAULT NULL COMMENT '1 if it was made by a user; 0 if it came with the system.',
  `common` smallint(6) DEFAULT 1 COMMENT 'This is not used.',
  `direction` enum('ASC','DESC') NOT NULL DEFAULT 'DESC' COMMENT 'DESC if larger values should be at the top of the results; ASC if smaller values should be at the top.',
  `order_number` int(11) DEFAULT NULL COMMENT 'The order in which to display the templates.  This is only used for custom=0 templates, and may not actually be used anymore.  ZOMG RESEARCH.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the ''views'' that are used with the Top N report system.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `networkoverview_templates`
--
-- WHERE:  1 limit 10

LOCK TABLES `networkoverview_templates` WRITE;
/*!40000 ALTER TABLE `networkoverview_templates` DISABLE KEYS */;
INSERT INTO `networkoverview_templates` VALUES (1,'Most Utilized Interfaces (in & out)',0,1,'DESC',1),(2,'Most Errored Interfaces (in & out)',0,1,'DESC',2),(3,'Most Discarding Interfaces (in & out)',0,1,'DESC',3),(4,'Most Packets Transmitted (in & out)',0,1,'DESC',4),(5,'Least Reachable Devices',0,1,'ASC',5),(6,'Highest Maximum Ping Times',0,1,'DESC',6),(7,'Highest Average Ping Times',0,1,'DESC',7),(8,'Highest Packet Loss',0,1,'DESC',8),(9,'Least Available TCP Ports',0,1,'ASC',9),(10,'Highest TCP Response Times',0,1,'DESC',10);
/*!40000 ALTER TABLE `networkoverview_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nms_upgrade_history`
--

DROP TABLE IF EXISTS `nms_upgrade_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `nms_upgrade_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The ID of the upgrade history',
  `starting_version` varchar(25) NOT NULL DEFAULT '' COMMENT 'The starting version of NMS when upgrade is going to happen.',
  `forward_version` varchar(25) NOT NULL DEFAULT '' COMMENT 'The forward version of NMS when upgrade finished.',
  `status` enum('COMPLETED','FAILED') NOT NULL DEFAULT 'FAILED' COMMENT 'Status of NMS upgrade',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Finish time of upgrade',
  PRIMARY KEY (`id`),
  UNIQUE KEY `starting_version_forward_version_key` (`starting_version`,`forward_version`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the upgrade version history of NMS which was happened through SevOne-gui-installer.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nms_upgrade_history`
--
-- WHERE:  1 limit 10

LOCK TABLES `nms_upgrade_history` WRITE;
/*!40000 ALTER TABLE `nms_upgrade_history` DISABLE KEYS */;
INSERT INTO `nms_upgrade_history` VALUES (1,'8.0.0','8.0.3','COMPLETED','2025-12-01 17:35:55'),(2,'8.0.3','8.0.5','COMPLETED','2026-03-04 16:28:52');
/*!40000 ALTER TABLE `nms_upgrade_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node`
--

DROP TABLE IF EXISTS `node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `node` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `map_id` int(11) DEFAULT NULL COMMENT 'The map that this node is in foreignKey: net.map.id',
  `x` double DEFAULT NULL COMMENT 'The x position in percent from the left where this node exists in the map',
  `y` double DEFAULT NULL COMMENT 'The y position in percent from the top where this node exists in the map',
  `name` varchar(128) DEFAULT NULL COMMENT 'The display name of the node',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all the nodes on all the maps that are defined in the product';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node`
--
-- WHERE:  1 limit 10

LOCK TABLES `node` WRITE;
/*!40000 ALTER TABLE `node` DISABLE KEYS */;
/*!40000 ALTER TABLE `node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_join`
--

DROP TABLE IF EXISTS `node_join`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `node_join` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `node_id` int(11) NOT NULL COMMENT 'The node this join is associated with foreignKey: net.node.id',
  `device_id` int(11) DEFAULT NULL COMMENT 'The device id of this join foreignKey: net.deviceinfo.id',
  `plugin_id` int(11) DEFAULT NULL COMMENT 'The plugin id of this join foreignKey: net.plugins.id',
  `object_id` int(11) DEFAULT NULL COMMENT 'The object id of this join foreignKey: local.device_object.id',
  `object_group_id` int(11) DEFAULT NULL COMMENT 'The object group id of this join foreignKey: net.objectgroupinfo.id',
  `device_group_id` int(11) DEFAULT NULL COMMENT 'The device group id of this join foreignKey: net.devicetags.id',
  `map_id` int(11) DEFAULT NULL COMMENT 'The map id of this join foreignKey: net.map.id',
  `report_id` int(11) DEFAULT NULL COMMENT 'The report id of this join. foreignKey: net.surf.id',
  PRIMARY KEY (`id`),
  KEY `device_group_id` (`device_group_id`),
  KEY `device_id` (`device_id`),
  KEY `map_id` (`map_id`),
  KEY `node_id` (`node_id`),
  KEY `object_group_id` (`object_group_id`),
  KEY `object_id` (`object_id`),
  KEY `plugin_id` (`plugin_id`),
  KEY `report_id` (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all the associated data to nodes that are in maps. Each node will be associated with a device, some group, multiple objects, etc. Nodes may also be associated to a report.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_join`
--
-- WHERE:  1 limit 10

LOCK TABLES `node_join` WRITE;
/*!40000 ALTER TABLE `node_join` DISABLE KEYS */;
/*!40000 ALTER TABLE `node_join` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `object_rule_conditions`
--

DROP TABLE IF EXISTS `object_rule_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `object_rule_conditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `object_rule_id` int(11) NOT NULL COMMENT 'object rule id foreignKey: net.object_rules.id',
  `field_name` enum('NAME','DESCRIPTION') NOT NULL COMMENT 'The field to check for match',
  `do_match` tinyint(4) unsigned NOT NULL COMMENT 'match or not match',
  `expression` varchar(255) NOT NULL DEFAULT '' COMMENT 'Regular expression for matching',
  `case_sensitive` tinyint(4) unsigned NOT NULL DEFAULT 1 COMMENT 'Specify if the matching is case sensitive',
  PRIMARY KEY (`id`),
  KEY `object_rule_id` (`object_rule_id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Object rule conditions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `object_rule_conditions`
--
-- WHERE:  1 limit 10

LOCK TABLES `object_rule_conditions` WRITE;
/*!40000 ALTER TABLE `object_rule_conditions` DISABLE KEYS */;
INSERT INTO `object_rule_conditions` VALUES (1,1,'NAME',1,'^nbd',1),(2,2,'NAME',1,'^loop',1),(5,4,'NAME',1,'^/proc',1),(6,4,'DESCRIPTION',1,'^/proc',1),(7,5,'DESCRIPTION',1,'^null',0),(8,6,'NAME',1,'^[/]?proc',0),(9,7,'NAME',1,'^[/]?proc',0),(10,8,'NAME',1,'^[/]?proc',0);
/*!40000 ALTER TABLE `object_rule_conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `object_rules`
--

DROP TABLE IF EXISTS `object_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `object_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `rank` int(11) NOT NULL COMMENT 'The order of the rules, this matters. Larger number means higher priority.',
  `rule_type` enum('INCLUDE','EXCLUDE','BLOCK') NOT NULL COMMENT 'deny, allow, or block',
  `plugin_id` int(11) NOT NULL DEFAULT -1 COMMENT 'Plugin id. foreignKey: net.plugins.id',
  `device_group_id` int(11) NOT NULL COMMENT 'Foreign Key to net.devicetags foreignKey: net.devicetags.id',
  `object_type_id` int(11) NOT NULL COMMENT 'Foreign Key to net.plugin_object_type foreignKey: net.plugin_object_type.id',
  `object_subtype_id` int(11) NOT NULL COMMENT 'Foreign Key to net.objectsubtypes foreignKey: net.objectsubtypes.id',
  `comment` varchar(255) NOT NULL DEFAULT '' COMMENT 'The comment for the rule to display',
  `is_enabled` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'The rule is enabled or not',
  PRIMARY KEY (`id`),
  KEY `device_group_id` (`device_group_id`),
  KEY `object_subtype_id` (`object_subtype_id`),
  KEY `object_type_id` (`object_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Object Rules';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `object_rules`
--
-- WHERE:  1 limit 10

LOCK TABLES `object_rules` WRITE;
/*!40000 ALTER TABLE `object_rules` DISABLE KEYS */;
INSERT INTO `object_rules` VALUES (1,6,'EXCLUDE',-1,11,321,-1,'',1),(2,7,'EXCLUDE',-1,11,321,-1,'',1),(4,14,'EXCLUDE',-1,41,271,-1,'',1),(5,17,'EXCLUDE',-1,41,274,-1,'Ignoring null interfaces',1),(6,18,'EXCLUDE',-1,41,272,-1,'Ignoring proc file system, which is always full',1),(7,19,'EXCLUDE',-1,41,280,-1,'Ignoring proc file system, which is always full',1),(8,20,'EXCLUDE',-1,41,321,-1,'Ignoring proc file system',1);
/*!40000 ALTER TABLE `object_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objectgroupinfo`
--

DROP TABLE IF EXISTS `objectgroupinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `objectgroupinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(128) DEFAULT NULL COMMENT 'This is the name of the Object Group (or ''Class'').',
  `parent_id` int(11) DEFAULT NULL COMMENT 'This is the ID of the parent of the Object Group; this is 0 for a ''Class''. foreignKey: net.objectgroupinfo.id',
  `is_class` tinyint(4) DEFAULT NULL COMMENT '1 if this row represents a ''Class''; 0 if this row represents a ''Group''.',
  `readonly` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 if the object group in the UI is readonly; 0 if not.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `object_name` (`name`,`parent_id`)
) ENGINE=MyISAM AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines an Object Group.  Object Groups are stored in a 2-tier hierarchy where the top tier is called a ''class''.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectgroupinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `objectgroupinfo` WRITE;
/*!40000 ALTER TABLE `objectgroupinfo` DISABLE KEYS */;
INSERT INTO `objectgroupinfo` VALUES (3,'Interface',0,1,0),(4,'CPU',0,1,0),(5,'IP SLA Probe',0,1,0),(6,'10G Interfaces',3,0,0),(7,'Ethernet',3,0,0),(8,'Serial',3,0,0),(9,'Wireless',3,0,0),(10,'Loopback',3,0,0),(11,'Cisco CPUs',4,0,0),(12,'Linux CPUs',4,0,0);
/*!40000 ALTER TABLE `objectgroupinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objectgrouprules`
--

DROP TABLE IF EXISTS `objectgrouprules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `objectgrouprules` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `group_id` int(11) NOT NULL COMMENT 'Foreign Key to groups. foreignKey: net.objectgroupinfo.id',
  `device_group` int(11) DEFAULT -1 COMMENT 'Foreign Key to Device Group. foreignKey: net.devicetags.id',
  `name_expression` text DEFAULT NULL COMMENT 'The name expression for this rule',
  `description_expression` text DEFAULT NULL COMMENT 'The description expression for this rule',
  `object_type` int(11) DEFAULT 0 COMMENT 'Object Type Filter for this rule. foreignKey: net.plugin_object_type.id',
  `subtype` int(11) DEFAULT 0 COMMENT 'Subtype filter for this rule. foreignKey: net.objectsubtypes.id',
  `plugin_id` int(11) DEFAULT NULL COMMENT 'Link to the plugin for this rule. foreignKey: net.plugins.id',
  `device_type` int(11) DEFAULT -1 COMMENT 'Foreign Key to Device Type. foreignKey: net.devicetags.id',
  `namespace_id` int(11) DEFAULT NULL COMMENT 'Metadata Namespace id. foreignKey: net.metadata_namespace.id',
  `attribute_id` int(11) DEFAULT NULL COMMENT 'Metadata Attribute id. foreignKey: net.metadata_attribute.id',
  `metadata_value_expression` text DEFAULT NULL COMMENT 'Metadata Value Expression',
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='List of Object Group Rules';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectgrouprules`
--
-- WHERE:  1 limit 10

LOCK TABLES `objectgrouprules` WRITE;
/*!40000 ALTER TABLE `objectgrouprules` DISABLE KEYS */;
INSERT INTO `objectgrouprules` VALUES (11,6,-1,'^Te[0-9]','',274,0,1,-1,0,0,''),(12,6,-1,'','TenGig',274,0,1,-1,0,0,''),(13,7,2,'','',274,6,1,-1,0,0,''),(14,7,2,'','',274,26,1,-1,0,0,''),(15,7,2,'','',274,62,1,-1,0,0,''),(16,7,2,'','',274,69,1,-1,0,0,''),(17,8,-1,'','',274,22,1,-1,0,0,''),(18,9,41,'','',274,157,1,-1,NULL,NULL,NULL),(19,9,41,'','',274,181,1,-1,NULL,NULL,NULL),(20,9,41,'','',274,180,1,-1,NULL,NULL,NULL);
/*!40000 ALTER TABLE `objectgrouprules` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_objectgrouprules_insert` AFTER INSERT
ON `net`.`objectgrouprules` FOR EACH ROW
INSERT INTO net.objectgrouprules_info (object_group_id, created_at, modified_at) VALUES (NEW.id, NOW(), NOW()) */;;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_objectgrouprules_update` AFTER UPDATE
ON `net`.`objectgrouprules` FOR EACH ROW
IF EXISTS (SELECT * FROM net.objectgrouprules_info WHERE object_group_id = NEW.id) THEN UPDATE net.objectgrouprules_info SET modified_at = NOW() WHERE object_group_id = NEW.id;
ELSE INSERT INTO net.objectgrouprules_info (object_group_id, created_at, modified_at) VALUES (NEW.id, NOW(), NOW());
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_objectgrouprules_delete` AFTER DELETE
ON `net`.`objectgrouprules` FOR EACH ROW
IF EXISTS (SELECT * FROM net.objectgrouprules_info WHERE object_group_id = OLD.id) THEN UPDATE net.objectgrouprules_info SET deleted_at = NOW() WHERE object_group_id = OLD.id;
ELSE INSERT INTO net.objectgrouprules_info (object_group_id, deleted_at) VALUES (OLD.id, NOW());
END IF */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `objectgrouprules_info`
--

DROP TABLE IF EXISTS `objectgrouprules_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `objectgrouprules_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID of a grouprule entry ',
  `object_group_id` int(11) DEFAULT NULL COMMENT 'Object group ID grouprule entry. foreignKey: net.objectgroupinfo.id',
  `created_at` datetime DEFAULT NULL COMMENT 'Created time for grouprule entry ',
  `modified_at` datetime DEFAULT NULL COMMENT 'Modified time for grouprule entry ',
  `deleted_at` datetime DEFAULT NULL COMMENT 'Deleted time for grouprule entry ',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the created/modifed/deleted objectgrouprules';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectgrouprules_info`
--
-- WHERE:  1 limit 10

LOCK TABLES `objectgrouprules_info` WRITE;
/*!40000 ALTER TABLE `objectgrouprules_info` DISABLE KEYS */;
INSERT INTO `objectgrouprules_info` VALUES (1,11,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(2,12,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(3,60,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(4,13,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(5,14,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(6,15,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(7,16,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(8,17,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(9,18,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL),(10,19,'2025-09-04 09:51:37','2025-09-04 09:51:37',NULL);
/*!40000 ALTER TABLE `objectgrouprules_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objectsubtypes`
--

DROP TABLE IF EXISTS `objectsubtypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `objectsubtypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `plugin_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.plugins.id',
  `object_type` int(11) NOT NULL COMMENT 'The ID of the Plugin-specific Object Type. foreignKey: net.plugin_object_type.id',
  `common` int(11) DEFAULT 1 COMMENT '1 if this is ''common''; 0 otherwise.  This column is stupid.',
  `name` varchar(255) DEFAULT NULL COMMENT 'The name of the Subtype.',
  `description` varchar(255) DEFAULT NULL COMMENT 'A longer description for the Subtype (not mandatory).',
  PRIMARY KEY (`id`),
  UNIQUE KEY `object_type_and_sub_type` (`plugin_id`,`object_type`,`name`)
) ENGINE=MyISAM AUTO_INCREMENT=1448 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the Object Subtypes.  A Subtype is conceptually an Object Type UNDERNEATH another one.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectsubtypes`
--
-- WHERE:  1 limit 10

LOCK TABLES `objectsubtypes` WRITE;
/*!40000 ALTER TABLE `objectsubtypes` DISABLE KEYS */;
INSERT INTO `objectsubtypes` VALUES (1,1,274,0,'other','none of the following'),(2,1,274,0,'regular1822',''),(3,1,274,0,'hdh1822',''),(4,1,274,0,'ddnX25',''),(5,1,274,0,'rfc877x25',''),(6,1,274,1,'ethernetCsmacd','for all ethernet-like interfaces regardless of speed, as per RFC3635'),(7,1,274,0,'iso88023Csmacd','Deprecated via RFC-draft-ietf-hubmib-etherif-mib-v3  ethernetCsmacd should be used instead'),(8,1,274,0,'iso88024TokenBus',''),(9,1,274,0,'iso88025TokenRing',''),(10,1,274,0,'iso88026Man','');
/*!40000 ALTER TABLE `objectsubtypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objectsubtypes_rule_process`
--

DROP TABLE IF EXISTS `objectsubtypes_rule_process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `objectsubtypes_rule_process` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `plugin_object_type_id` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the Process Object Type ID. foreignKey: net.plugin_object_type.id',
  `subtype_id` int(11) NOT NULL DEFAULT 0 COMMENT 'The Subtype that this rule applies to. foreignKey: net.objectsubtypes.id',
  `run_name` varchar(255) DEFAULT NULL COMMENT 'The name to match (exactly), or NULL to ignore.',
  `run_path` varchar(255) DEFAULT NULL COMMENT 'The path to match (exactly), or NULL to ignore.',
  `run_args` varchar(255) DEFAULT NULL COMMENT 'The arguments to match (exactly), or NULL to ignore.',
  PRIMARY KEY (`id`),
  KEY `plugin_object_type_id` (`plugin_object_type_id`),
  KEY `subtype_id` (`subtype_id`)
) ENGINE=MyISAM AUTO_INCREMENT=148 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines rules that map HOST-RESOURCES-MIB entries found on Devices with existing Process Object Subtypes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectsubtypes_rule_process`
--
-- WHERE:  1 limit 10

LOCK TABLES `objectsubtypes_rule_process` WRITE;
/*!40000 ALTER TABLE `objectsubtypes_rule_process` DISABLE KEYS */;
INSERT INTO `objectsubtypes_rule_process` VALUES (1,270,1378,'abtntsrv.exe',NULL,NULL),(2,270,1379,'acesrvc_be.exe',NULL,NULL),(3,270,1386,'adc.exe',NULL,NULL),(4,270,1387,'AntigenIMC.exe',NULL,NULL),(5,270,1336,'AntigenInternet.exe',NULL,NULL),(6,270,1337,'AntigenMonitor.exe',NULL,NULL),(7,270,1338,'AntigenRealtime.exe',NULL,NULL),(8,270,1339,'AntigenService.exe',NULL,NULL),(9,270,1340,'AntigenStore.exe',NULL,NULL),(10,270,1302,'apache2',NULL,NULL);
/*!40000 ALTER TABLE `objectsubtypes_rule_process` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objectsubtypes_rule_snmp`
--

DROP TABLE IF EXISTS `objectsubtypes_rule_snmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `objectsubtypes_rule_snmp` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `plugin_object_type_id` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the SNMP Object Type ID. foreignKey: net.plugin_object_type.id',
  `subtype_id` int(11) NOT NULL DEFAULT 0 COMMENT 'The Subtype that this rule applies to. foreignKey: net.objectsubtypes.id',
  `identifier` varchar(255) NOT NULL DEFAULT '0' COMMENT 'This is the arbitrary text that is found at discovery time for the ''Subtype Expression''.',
  PRIMARY KEY (`id`),
  KEY `plugin_object_type_id` (`plugin_object_type_id`),
  KEY `subtype_id` (`subtype_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This maps an SNMP ''subtype'' value to a particular Subtype ID.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectsubtypes_rule_snmp`
--
-- WHERE:  1 limit 10

LOCK TABLES `objectsubtypes_rule_snmp` WRITE;
/*!40000 ALTER TABLE `objectsubtypes_rule_snmp` DISABLE KEYS */;
INSERT INTO `objectsubtypes_rule_snmp` VALUES (1,274,1,'1'),(2,274,2,'2'),(3,274,3,'3'),(4,274,4,'4'),(5,274,5,'5'),(6,274,6,'6'),(7,274,7,'7'),(8,274,8,'8'),(9,274,9,'9'),(10,274,10,'10');
/*!40000 ALTER TABLE `objectsubtypes_rule_snmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peermon_deviceinfo`
--

DROP TABLE IF EXISTS `peermon_deviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `peermon_deviceinfo` (
  `device_id` int(11) NOT NULL COMMENT 'The ID of the device foreignKey: net.deviceinfo.id',
  PRIMARY KEY (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This notes which devices are peermon devices.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peermon_deviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `peermon_deviceinfo` WRITE;
/*!40000 ALTER TABLE `peermon_deviceinfo` DISABLE KEYS */;
INSERT INTO `peermon_deviceinfo` VALUES (281),(353);
/*!40000 ALTER TABLE `peermon_deviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peers`
--

DROP TABLE IF EXISTS `peers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `peers` (
  `server_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'server_id',
  `name` varchar(43) NOT NULL DEFAULT '' COMMENT 'The name of the peer displayed to the user.',
  `ip` varbinary(40) DEFAULT NULL COMMENT 'Current ip address of the peer.',
  `primary_ip` varbinary(40) DEFAULT NULL COMMENT 'ip address of the primary appliance.',
  `secondary_ip` varbinary(40) DEFAULT NULL COMMENT 'ip address of the secondary appliacne.',
  `active_appliance` enum('PRIMARY','SECONDARY') DEFAULT NULL COMMENT 'The applaince that is currently polling and not an hsa.',
  `disabled` int(11) DEFAULT 0 COMMENT 'Marks appliances that should not be interacted with in any way in a 2-bit mask corresponding to primary and secondary. Managed by SevOne-clusterd, must be respected by everything else.',
  `virtual_ip` varbinary(40) DEFAULT NULL COMMENT 'The virtual ip address that the peer pair will use.',
  `master` int(11) NOT NULL DEFAULT 0 COMMENT 'whether not this appliance is the master',
  `user` varchar(32) DEFAULT NULL COMMENT 'username to use',
  `pass` varchar(64) DEFAULT NULL COMMENT 'password to use',
  `capacity` int(11) NOT NULL DEFAULT 0 COMMENT 'number of elements this appliance is capable of monitoring',
  `interface_limit` int(11) DEFAULT 0 COMMENT 'number of interfaces for to get flows from',
  `flow_limit` int(11) DEFAULT 0 COMMENT 'number of flows this peer can receive',
  `netflow_interface_count` int(11) DEFAULT 0 COMMENT 'number of interfaces that are collecting flows',
  `server_load` int(11) NOT NULL DEFAULT 0 COMMENT 'how full the server is',
  `flow_load` int(11) DEFAULT 0 COMMENT 'how full the peer is with flows',
  `model` varchar(32) DEFAULT 'PAS' COMMENT 'model type of the peer',
  `group_poller_device_count` int(11) DEFAULT 0 COMMENT 'number of group poller devices for this peer',
  `group_poller_object_count` int(11) DEFAULT 0 COMMENT 'number of group poller objects for this peer',
  `selfmon_device_count` int(11) DEFAULT 0 COMMENT 'number of SelfMon devices on this peer',
  `selfmon_object_count` int(11) DEFAULT 0 COMMENT 'number of SelfMon objects on this peer',
  `coc_device_count` int(11) DEFAULT 0 COMMENT 'number of COC devices on this peer',
  `indicators_per_second` double DEFAULT 0 COMMENT 'indicators per second on this peer',
  PRIMARY KEY (`server_id`),
  UNIQUE KEY `name` (`name`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Contains the information of the appliances in the cluster and their HSA status.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peers`
--
-- WHERE:  1 limit 10

LOCK TABLES `peers` WRITE;
/*!40000 ALTER TABLE `peers` DISABLE KEYS */;
INSERT INTO `peers` VALUES (1,'SevOne Appliance','0A161F04','0A161F04','0A17CF9F','PRIMARY',0,NULL,1,'root','',100000,15,4500,0,6018,0,'PAS',1,1,2,193,202,0);
/*!40000 ALTER TABLE `peers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_indicator_type`
--

DROP TABLE IF EXISTS `plugin_indicator_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_indicator_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `plugin_id` smallint(5) unsigned NOT NULL COMMENT 'plugin id foreignKey: net.plugins.id',
  `plugin_object_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_object_type.id',
  `is_enabled` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 if this is administratively enabled; 0 otherwise.',
  `is_default` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 if this should be discovered by default; 0 if it requires manual mapping.',
  `name` varchar(255) NOT NULL COMMENT 'The name of the Indicator Type.',
  `description` varchar(255) NOT NULL COMMENT 'A more human-readable version of the name.',
  `format` enum('GAUGE','COUNTER32','COUNTER64') DEFAULT 'GAUGE' COMMENT 'How this Indicator Type is measured.',
  `has_precalculated_deltas` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if this Indicator Type is COUNTERXX and the polled data represents precalculated deltas.',
  `allow_maximum_value` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 if this Indicator Type, in theory, allows maximum values.',
  `data_units` varchar(32) DEFAULT NULL COMMENT 'The units in which the data is measured.',
  `display_units` varchar(32) DEFAULT NULL COMMENT 'The units in which to display the data, when possible.',
  `synthetic_expression` varchar(2048) DEFAULT NULL COMMENT 'If non-NULL, then this is a Synthetic Indicator Type.  In that case, this is the expression.',
  `synthetic_maximum_expression` varchar(2048) DEFAULT NULL COMMENT 'If non-NULL, then this Synthetic Indicator Type has a maximum value; this is that expression.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_key` (`plugin_object_type_id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14983 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the Plugin Indicator Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_indicator_type`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_indicator_type` WRITE;
/*!40000 ALTER TABLE `plugin_indicator_type` DISABLE KEYS */;
INSERT INTO `plugin_indicator_type` VALUES (3,1,276,1,1,'enterprises.9.9.109.1.1.1.1.5','CPU 5 Minute Average','GAUGE',0,1,'Percent','Percent',NULL,NULL),(5,1,274,1,1,'ifInUcastPkts','In Unicast Packets','COUNTER32',0,0,'Number','Number',NULL,NULL),(6,1,274,1,0,'ifInNUcastPkts','In Non-Unicast Packets','COUNTER32',0,0,'Number','Number',NULL,NULL),(7,1,274,1,1,'ifOutUcastPkts','Out Unicast Packets','COUNTER32',0,0,'Number','Number',NULL,NULL),(8,1,274,1,0,'ifOutNUcastPkts','Out Non-Unicast Packets','COUNTER32',0,0,'Number','Number',NULL,NULL),(13,1,274,1,0,'ifOutQLen','Output Queue','GAUGE',0,0,'Number','Number',NULL,NULL),(16,1,273,1,1,'ciscoMemoryPoolUsed','Used Memory','GAUGE',0,1,'Bytes','Bytes',NULL,NULL),(17,1,273,1,1,'ciscoMemoryPoolFree','Free Memory','GAUGE',0,1,'Bytes','Bytes',NULL,NULL),(18,1,272,1,1,'hrStorageUsed','Storage Used','GAUGE',0,1,'Bytes','Bytes','(${auto_hrStorageUsed} * ${auto_hrStorageAllocationUnits})','(${auto_hrStorageUsed} * ${auto_hrStorageAllocationUnits})'),(19,1,274,1,1,'ifHCInOctets','HC In Octets','COUNTER64',0,1,'Bytes','Bytes',NULL,NULL);
/*!40000 ALTER TABLE `plugin_indicator_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_indicator_type_ext_bulkdata`
--

DROP TABLE IF EXISTS `plugin_indicator_type_ext_bulkdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_indicator_type_ext_bulkdata` (
  `plugin_indicator_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_indicator_type.id',
  `field_identifiers` varchar(255) NOT NULL COMMENT 'ZOMG TODO TODO TODO',
  `is_ignore` tinyint(4) NOT NULL COMMENT 'ZOMG TODO TODO TODO',
  PRIMARY KEY (`plugin_indicator_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the xStats extensions for Indicator Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_indicator_type_ext_bulkdata`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_indicator_type_ext_bulkdata` WRITE;
/*!40000 ALTER TABLE `plugin_indicator_type_ext_bulkdata` DISABLE KEYS */;
INSERT INTO `plugin_indicator_type_ext_bulkdata` VALUES (13032,'',0),(13033,'',0),(13034,'',0),(13035,'',0),(13036,'',0),(13037,'',0),(13038,'',0),(13039,'',0),(13040,'',0),(13041,'',0);
/*!40000 ALTER TABLE `plugin_indicator_type_ext_bulkdata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_indicator_type_ext_gnmi`
--

DROP TABLE IF EXISTS `plugin_indicator_type_ext_gnmi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_indicator_type_ext_gnmi` (
  `plugin_indicator_type_id` int(10) unsigned NOT NULL COMMENT 'foreignKey: net.plugin_indicator_type.id',
  `indicator_path` varchar(255) NOT NULL DEFAULT '' COMMENT 'YANG path associated with indicator',
  PRIMARY KEY (`plugin_indicator_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the gNMI extensions for Indicator Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_indicator_type_ext_gnmi`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_indicator_type_ext_gnmi` WRITE;
/*!40000 ALTER TABLE `plugin_indicator_type_ext_gnmi` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugin_indicator_type_ext_gnmi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_indicator_type_ext_ipsla`
--

DROP TABLE IF EXISTS `plugin_indicator_type_ext_ipsla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_indicator_type_ext_ipsla` (
  `plugin_indicator_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_indicator_type.id',
  `base` varchar(64) NOT NULL COMMENT 'If this Indicator Type is pretty much a test-specific way to do a generic thing, then the generic thing is listed here.  This is used by polling.',
  `minimum_compliance_revision` int(11) NOT NULL COMMENT 'The minimum compliance revision of the Device required in order to attempt to poll this Indicator Type.',
  PRIMARY KEY (`plugin_indicator_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the IP SLA extensions for Indicator Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_indicator_type_ext_ipsla`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_indicator_type_ext_ipsla` WRITE;
/*!40000 ALTER TABLE `plugin_indicator_type_ext_ipsla` DISABLE KEYS */;
INSERT INTO `plugin_indicator_type_ext_ipsla` VALUES (6993,'availability',0),(6994,'avgtime',0),(6995,'availability',0),(6996,'avgtime',0),(6997,'availability',0),(6998,'avgtime',0),(6999,'',0),(7000,'availability',0),(7001,'',0),(7002,'',0);
/*!40000 ALTER TABLE `plugin_indicator_type_ext_ipsla` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_indicator_type_ext_jmx`
--

DROP TABLE IF EXISTS `plugin_indicator_type_ext_jmx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_indicator_type_ext_jmx` (
  `plugin_indicator_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_indicator_type.id',
  `attribute` varchar(255) DEFAULT NULL COMMENT 'The JMX Attribute that this indicator is a part of',
  `expression` longtext DEFAULT NULL COMMENT 'If this is not NULL then evaluate the expression and indicator is the result',
  `max_value_expression` longtext DEFAULT NULL COMMENT 'If this is populated it is the maximum value for this indicator',
  PRIMARY KEY (`plugin_indicator_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the JMX extensions for Indicator Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_indicator_type_ext_jmx`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_indicator_type_ext_jmx` WRITE;
/*!40000 ALTER TABLE `plugin_indicator_type_ext_jmx` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugin_indicator_type_ext_jmx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_indicator_type_ext_snmp`
--

DROP TABLE IF EXISTS `plugin_indicator_type_ext_snmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_indicator_type_ext_snmp` (
  `plugin_indicator_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_indicator_type.id',
  `expression` mediumtext NOT NULL COMMENT 'The OID to query when polling.',
  `oid_high` mediumtext DEFAULT NULL COMMENT 'TODO: Document me',
  `speed_oid` varchar(128) NOT NULL COMMENT 'The S3 expression for the maximum value, used during discovery.',
  `speed_units` varchar(32) NOT NULL COMMENT 'The units that ''speed_oid'' is measured in.',
  PRIMARY KEY (`plugin_indicator_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the SNMP extensions for Indicator Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_indicator_type_ext_snmp`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_indicator_type_ext_snmp` WRITE;
/*!40000 ALTER TABLE `plugin_indicator_type_ext_snmp` DISABLE KEYS */;
INSERT INTO `plugin_indicator_type_ext_snmp` VALUES (3,'.1.3.6.1.4.1.9.9.109.1.1.1.1.5',NULL,'100','Percent'),(5,'.1.3.6.1.2.1.2.2.1.11',NULL,'','Bits'),(6,'.1.3.6.1.2.1.2.2.1.12',NULL,'','Bits'),(7,'.1.3.6.1.2.1.2.2.1.17',NULL,'','Bits'),(8,'.1.3.6.1.2.1.2.2.1.18',NULL,'','Bits'),(13,'.1.3.6.1.2.1.2.2.1.21',NULL,'','Bits'),(12979,'.1.3.6.1.4.1.2021.11.61',NULL,'100 * `[numberOfCpus]`','Centiseconds'),(16,'.1.3.6.1.4.1.9.9.48.1.1.1.5',NULL,'.1.3.6.1.4.1.9.9.48.1.1.1.5 + .1.3.6.1.4.1.9.9.48.1.1.1.6','Bytes'),(17,'.1.3.6.1.4.1.9.9.48.1.1.1.6',NULL,'.1.3.6.1.4.1.9.9.48.1.1.1.5 + .1.3.6.1.4.1.9.9.48.1.1.1.6','Bytes'),(18,'',NULL,'.1.3.6.1.2.1.25.2.3.1.5 * .1.3.6.1.2.1.25.2.3.1.4','Bytes');
/*!40000 ALTER TABLE `plugin_indicator_type_ext_snmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_indicator_type_ext_wmi`
--

DROP TABLE IF EXISTS `plugin_indicator_type_ext_wmi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_indicator_type_ext_wmi` (
  `plugin_indicator_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_indicator_type.id',
  `discovered` tinyint(1) unsigned NOT NULL COMMENT '1 if this was discovered; 0 if it was added manually.',
  `property_name` varchar(255) NOT NULL COMMENT 'The WMI property name that maps to this Indicator Type.',
  PRIMARY KEY (`plugin_indicator_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the WMI extensions for Indicator Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_indicator_type_ext_wmi`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_indicator_type_ext_wmi` WRITE;
/*!40000 ALTER TABLE `plugin_indicator_type_ext_wmi` DISABLE KEYS */;
INSERT INTO `plugin_indicator_type_ext_wmi` VALUES (10321,1,'DebuggingRequests'),(10322,1,'EngineFlushNotifications'),(10323,1,'ErrorsDuringScriptRuntime'),(10324,1,'ErrorsFromASPPreprocessor'),(10325,1,'ErrorsFromScriptCompilers'),(10326,1,'ErrorsPerSec'),(10327,1,'InMemoryTemplateCacheHitRate'),(10328,1,'InMemoryTemplatesCached'),(10329,1,'RequestBytesInTotal'),(10330,1,'RequestBytesOutTotal');
/*!40000 ALTER TABLE `plugin_indicator_type_ext_wmi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_map`
--

DROP TABLE IF EXISTS `plugin_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_map` (
  `dev_id` int(11) NOT NULL DEFAULT 0 COMMENT 'The ID of the Device. foreignKey: net.deviceinfo.id',
  `plugin_id` int(11) NOT NULL DEFAULT 0 COMMENT 'The ID of the Plugin. foreignKey: net.plugins.id',
  `enabled` int(11) NOT NULL DEFAULT 0 COMMENT '1 if the Plugin is enabled; 0 if it is disabled; 2 if it was enabled and now should be disabled (deleting all historical data) at the next discovery.',
  `status` tinyint(4) DEFAULT 0 COMMENT '1 if the Plugin was found to be working at the last discovery; 0 otherwise.',
  `element_count` int(11) DEFAULT 0 COMMENT 'This is the number of elements consumed by this Plugin for this Device.',
  `status_realtime` tinyint(4) DEFAULT 1 COMMENT 'Latest value of status.',
  `status_realtime_timestamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Timestamp when status_realtime was last updated.',
  UNIQUE KEY `dev_plugin` (`dev_id`,`plugin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This maps a Device to a Plugin and stores some extra information about the Plugin''s status.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_map` WRITE;
/*!40000 ALTER TABLE `plugin_map` DISABLE KEYS */;
INSERT INTO `plugin_map` VALUES (49,1,0,0,0,0,'2025-11-20 11:32:13'),(49,2,0,0,0,0,'2025-11-20 11:32:13'),(49,3,0,0,0,0,'2025-11-20 11:32:13'),(49,4,0,0,0,0,'2025-11-20 11:32:13'),(49,5,0,0,0,0,'2025-11-20 11:32:13'),(49,6,0,0,0,1,'2025-11-20 11:32:13'),(49,7,0,0,0,0,'2025-11-20 11:32:13'),(49,8,0,0,0,0,'2025-11-20 11:32:13'),(49,9,0,0,0,0,'2025-11-20 11:32:13'),(49,10,1,1,0,1,'2025-11-20 11:32:13');
/*!40000 ALTER TABLE `plugin_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_netflow_map`
--

DROP TABLE IF EXISTS `plugin_netflow_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_netflow_map` (
  `indicator_type_id` int(11) unsigned NOT NULL COMMENT 'indicator type id. foreignKey: net.plugin_indicator_type.id',
  `netflow_mapping` enum('yes','no') NOT NULL COMMENT 'Set to YES if netflow mapping allowed else set to NO.',
  `direction` varchar(10) NOT NULL COMMENT 'Direction of flow - incoming, outgoing or both direction',
  PRIMARY KEY (`indicator_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the Plugin netflow mapping.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_netflow_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_netflow_map` WRITE;
/*!40000 ALTER TABLE `plugin_netflow_map` DISABLE KEYS */;
INSERT INTO `plugin_netflow_map` VALUES (19,'yes','incoming'),(20,'yes','outgoing'),(51,'yes','incoming'),(52,'yes','outgoing'),(3266,'yes','incoming'),(3267,'yes','outgoing'),(3271,'yes','incoming'),(3277,'yes','outgoing'),(3287,'yes','incoming'),(3288,'yes','outgoing');
/*!40000 ALTER TABLE `plugin_netflow_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_object_type`
--

DROP TABLE IF EXISTS `plugin_object_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_object_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `plugin_id` smallint(5) unsigned NOT NULL COMMENT 'plugin_id foreignKey: net.plugins.id',
  `is_enabled` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 if this Object Type is administratively enabled; 0 otherwise.',
  `name` varchar(255) NOT NULL COMMENT 'The name of the Object Type.',
  `parent_object_type_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'parent_object_type_id foreignKey: net.plugin_object_type.id',
  `is_editable` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if this Object Type can be edited or deleted by the user. 0 otherwise.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_key` (`parent_object_type_id`,`plugin_id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=85595 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the Plugin Object Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_object_type`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_object_type` WRITE;
/*!40000 ALTER TABLE `plugin_object_type` DISABLE KEYS */;
INSERT INTO `plugin_object_type` VALUES (64,10,1,'SevOne Appliance',0,1),(65,10,1,'MySQL Database',0,1),(67,10,1,'Raid Array',0,1),(68,10,1,'Raid Array Disk',0,1),(69,8,1,'DNS Data',0,0),(70,4,1,'Website Data',0,0),(71,2,1,'Ping Data',0,0),(72,9,1,'Echo',0,0),(73,9,1,'UDP Echo',0,0),(74,9,1,'TCP Connect',0,0);
/*!40000 ALTER TABLE `plugin_object_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_object_type_ext_bulkdata`
--

DROP TABLE IF EXISTS `plugin_object_type_ext_bulkdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_object_type_ext_bulkdata` (
  `plugin_object_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_object_type.id',
  `field_identifiers` varchar(255) NOT NULL COMMENT 'ZOMG TODO TODO TODO',
  `is_ignore` tinyint(4) NOT NULL COMMENT 'ZOMG TODO TODO TODO',
  PRIMARY KEY (`plugin_object_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the xStats extensions for Object Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_object_type_ext_bulkdata`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_object_type_ext_bulkdata` WRITE;
/*!40000 ALTER TABLE `plugin_object_type_ext_bulkdata` DISABLE KEYS */;
INSERT INTO `plugin_object_type_ext_bulkdata` VALUES (1587,'',0),(1588,'',0),(1589,'',0),(1590,'',0),(1591,'',0),(1592,'',0),(1593,'',0),(1594,'',0),(1595,'',0),(1596,'',0);
/*!40000 ALTER TABLE `plugin_object_type_ext_bulkdata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_object_type_ext_gnmi`
--

DROP TABLE IF EXISTS `plugin_object_type_ext_gnmi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_object_type_ext_gnmi` (
  `plugin_object_type_id` int(10) unsigned NOT NULL COMMENT 'foreignKey: net.plugin_object_type.id',
  `subscribe_path` varchar(255) NOT NULL DEFAULT '' COMMENT 'YANG path to subscribe to',
  `name_path` varchar(255) NOT NULL DEFAULT '' COMMENT 'Path to the gNMI path element that contains the key to be used for object naming',
  `name_key` varchar(255) NOT NULL DEFAULT '' COMMENT 'Key that can be found at name_path to be used for object naming',
  PRIMARY KEY (`plugin_object_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the gNMI extensions for Object Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_object_type_ext_gnmi`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_object_type_ext_gnmi` WRITE;
/*!40000 ALTER TABLE `plugin_object_type_ext_gnmi` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugin_object_type_ext_gnmi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_object_type_ext_ipsla`
--

DROP TABLE IF EXISTS `plugin_object_type_ext_ipsla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_object_type_ext_ipsla` (
  `plugin_object_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_object_type.id',
  `ipsla_id` int(11) NOT NULL DEFAULT 0 COMMENT 'The Cisco-defined ID for the IP SLA type.',
  `ipsla_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The Cisco-defined ID for the IP SLA type.',
  PRIMARY KEY (`plugin_object_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the IP SLA extensions for Object Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_object_type_ext_ipsla`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_object_type_ext_ipsla` WRITE;
/*!40000 ALTER TABLE `plugin_object_type_ext_ipsla` DISABLE KEYS */;
INSERT INTO `plugin_object_type_ext_ipsla` VALUES (72,1,'echo'),(73,5,'udpEcho'),(74,6,'tcpConnect'),(75,9,'jitter'),(76,11,'dhcp'),(77,10,'dlsw'),(78,8,'dns'),(79,13,'voip'),(80,7,'http'),(81,16,'icmpjitter');
/*!40000 ALTER TABLE `plugin_object_type_ext_ipsla` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_object_type_ext_jmx`
--

DROP TABLE IF EXISTS `plugin_object_type_ext_jmx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_object_type_ext_jmx` (
  `plugin_object_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_object_type.id',
  `alias` varchar(255) NOT NULL COMMENT 'ZOMG TODO TODO TODO',
  `class_name` varchar(255) NOT NULL COMMENT 'The class name.',
  `discovered` tinyint(1) NOT NULL COMMENT '1 if this was discovered; 0 if it was created by a user.',
  `domain` varchar(255) NOT NULL COMMENT 'ZOMG TODO TODO TODO',
  `rediscover` tinyint(4) NOT NULL COMMENT 'ZOMG TODO TODO TODO',
  `type` varchar(255) NOT NULL COMMENT 'ZOMG TODO TODO TODO',
  `index_expression` longtext DEFAULT NULL COMMENT 'The expression to use to get a list of objects ( must return and array )',
  `name_expression` longtext DEFAULT NULL COMMENT 'The expression to use to get the objects name',
  PRIMARY KEY (`plugin_object_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the JMX extensions for Object Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_object_type_ext_jmx`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_object_type_ext_jmx` WRITE;
/*!40000 ALTER TABLE `plugin_object_type_ext_jmx` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugin_object_type_ext_jmx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_object_type_ext_snmp`
--

DROP TABLE IF EXISTS `plugin_object_type_ext_snmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_object_type_ext_snmp` (
  `plugin_object_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_object_type.id',
  `admin_status_expression` varchar(255) DEFAULT NULL COMMENT 'The S3 expression for the admin-status.',
  `assert` varchar(255) DEFAULT NULL COMMENT 'The S3 expression to use to filter out unwanted instances.',
  `description_oid` varchar(128) DEFAULT NULL COMMENT 'The S3 expression for the description.',
  `index_oid` varchar(128) DEFAULT NULL COMMENT 'The OID to walk to determine the instances.',
  `index_reverse` int(11) DEFAULT NULL COMMENT '1 if discovery should reverse-engineer the index.  This is what you want to do.',
  `index_sig_octets` varchar(32) DEFAULT NULL COMMENT 'A series of letters that define how to interpret the index.',
  `last_change_oid` varchar(255) DEFAULT NULL COMMENT 'The OID to check to determine if a major administrative change has occured on the Object.',
  `name_oid` varchar(255) DEFAULT NULL COMMENT 'The S3 expression for the name.',
  `oper_status_expression` varchar(255) DEFAULT NULL COMMENT 'The S3 expression for the oper-status.',
  `type_oid` varchar(128) DEFAULT NULL COMMENT 'The OID for the identifier that will be used in matching against a Subtype.',
  `variables` mediumtext DEFAULT NULL COMMENT 'Any additional S3 that can be used in any of the S3 fields.',
  PRIMARY KEY (`plugin_object_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the SNMP extensions for Object Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_object_type_ext_snmp`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_object_type_ext_snmp` WRITE;
/*!40000 ALTER TABLE `plugin_object_type_ext_snmp` DISABLE KEYS */;
INSERT INTO `plugin_object_type_ext_snmp` VALUES (344,'','','\'Remote AS \' .1.3.6.1.2.1.15.3.1.9','.1.3.6.1.2.1.15.3.1.1',1,'iiii','','\'Peer IP \' .1.3.6.1.2.1.15.3.1.1','','',''),(296,'','','\'Chassis\'','.1.3.6.1.4.1.232.6.2.6.1',1,'i','','`Chassis[INDEX]`','','',''),(299,'','','.1.3.6.1.2.1.25.3.2.1.3','.1.3.6.1.2.1.25.3.3.1.2',1,'i','','`CPU[INDEX]`','','',''),(272,'','.1.3.6.1.2.1.25.2.3.1.2==\'.1.3.6.1.2.1.25.2.1.4\'','\'Disk\'','.1.3.6.1.2.1.25.2.3.1.1',0,'i','','.1.3.6.1.2.1.25.2.3.1.3','','',''),(306,'','','\'Fan Condition\'','.1.3.6.1.4.1.232.6.2.6.7.1.9',1,'ii','','`Fan Condition[INDEX]`','','',''),(638,'','1.3.6.1.4.1.9.9.91.1.1.1.1.1==10','\'Fan Speed Sensor\'','.1.3.6.1.4.1.9.9.91.1.1.1.1.4',1,'i','','.1.3.6.1.2.1.47.1.1.1.1.7\' RPM\'','','',''),(668,'','','\'ICMP\'','.1.3.6.1.2.1.5.1',1,'i','','\'ICMP\'','','',''),(274,'.1.3.6.1.2.1.2.2.1.7','','.1.3.6.1.2.1.31.1.1.1.18?.1.3.6.1.2.1.31.1.1.1.18:.1.3.6.1.2.1.2.2.1.2','.1.3.6.1.2.1.2.2.1.1',0,'i','.1.3.6.1.2.1.2.2.1.9','.1.3.6.1.2.1.31.1.1.1.1','.1.3.6.1.2.1.2.2.1.8','.1.3.6.1.2.1.2.2.1.3',''),(681,'','','\'IP Group\'','.1.3.6.1.2.1.4.1',1,'i','','\'IP\'','','',''),(319,'','.1.3.6.1.2.1.25.2.3.1.2==\'.1.3.6.1.2.1.25.2.1.3\' || .1.3.6.1.2.1.25.2.3.1.2==\'.1.3.6.1.2.1.25.2.1.2\'','\'Memory\'','.1.3.6.1.2.1.25.2.3.1.1',0,'i','','.1.3.6.1.2.1.25.2.3.1.3','','','');
/*!40000 ALTER TABLE `plugin_object_type_ext_snmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_object_type_ext_wmi`
--

DROP TABLE IF EXISTS `plugin_object_type_ext_wmi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_object_type_ext_wmi` (
  `plugin_object_type_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.plugin_object_type.id',
  `alias` varchar(256) NOT NULL COMMENT 'ZOMG TODO TODO TODO',
  `class_name` varchar(255) NOT NULL COMMENT 'The name of the class.',
  `discovered` tinyint(1) unsigned NOT NULL COMMENT '1 if this was discovered; 0 if it was added manually.',
  PRIMARY KEY (`plugin_object_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the WMI extensions for Object Types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_object_type_ext_wmi`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugin_object_type_ext_wmi` WRITE;
/*!40000 ALTER TABLE `plugin_object_type_ext_wmi` DISABLE KEYS */;
INSERT INTO `plugin_object_type_ext_wmi` VALUES (1054,'ActiveServerPages','Win32_PerfFormattedData_ASP_ActiveServerPages',1),(1055,'DHCPServer','Win32_PerfFormattedData_DHCPServer_DHCPServer',1),(1056,'DNS','Win32_PerfFormattedData_DNS_DNS',1),(1057,'IASAccountingClients','Win32_PerfFormattedData_IAS_IASAccountingClients',1),(1058,'IASAccountingProxy','Win32_PerfFormattedData_IAS_IASAccountingProxy',1),(1059,'IASAccountingServer','Win32_PerfFormattedData_IAS_IASAccountingServer',1),(1060,'IASAuthenticationClients','Win32_PerfFormattedData_IAS_IASAuthenticationClients',1),(1061,'IASAuthenticationProxy','Win32_PerfFormattedData_IAS_IASAuthenticationProxy',1),(1062,'IASAuthenticationServer','Win32_PerfFormattedData_IAS_IASAuthenticationServer',1),(1063,'IASRemoteAccountingServers','Win32_PerfFormattedData_IAS_IASRemoteAccountingServers',1);
/*!40000 ALTER TABLE `plugin_object_type_ext_wmi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugins`
--

DROP TABLE IF EXISTS `plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugins` (
  `id` int(11) NOT NULL COMMENT 'This is the ID of the Plugin; it is statically assigned and consistent across all of SevOne NMS.',
  `name` varchar(32) DEFAULT NULL COMMENT 'This is the name of the Plugin.',
  `object_string` varchar(16) DEFAULT NULL COMMENT 'This is a system-used string to identify the Plugin.',
  `dir` varchar(64) DEFAULT NULL COMMENT 'This is the lower-case version of ''object_string''; it was historically used as the ''directory'' in which to put plugin-specific data.',
  `plottable` int(11) NOT NULL DEFAULT 0 COMMENT 'This was historically used to distinguish between proper Plugins and discovery hacks.  This is no longer used.',
  `hidden` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'When this is 1, hide a work-in-progress or deprecated plugin in the UI.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `object_string` (`object_string`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines the Plugins.  Note that the Plugins are statically defined and that this table exists for database convenience.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugins`
--
-- WHERE:  1 limit 10

LOCK TABLES `plugins` WRITE;
/*!40000 ALTER TABLE `plugins` DISABLE KEYS */;
INSERT INTO `plugins` VALUES (1,'SNMP Poller','SNMP','snmp',1,0),(2,'ICMP Poller','ICMP','icmp',1,0),(3,'Process Poller','PROCESS','process',1,0),(4,'HTTP Poller','HTTP','http',1,0),(5,'Proxy Ping Poller','PROXYPING','proxyping',1,0),(6,'NBAR Poller','NBAR','nbar',1,0),(7,'Portshaker Poller','PORTSHAKER','portshaker',1,0),(8,'DNS Poller','DNS','dns',1,0),(9,'IP SLA Poller','IPSLA','ipsla',1,0),(10,'Deferred Data','DEFERRED','deferred',1,0);
/*!40000 ALTER TABLE `plugins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy`
--

DROP TABLE IF EXISTS `policy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `name` varchar(255) DEFAULT NULL COMMENT 'The name of the policy; this should be fairly clear and descriptive.',
  `description` varchar(1024) DEFAULT NULL COMMENT 'This should be enough information to tell someone the goal of this policy and why it should remain in the system.',
  `is_device_group` int(11) DEFAULT NULL COMMENT '1 if this policy applies to a Device Group; 0 if it applies to an Object Group.',
  `is_member_of_any` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'true if this policy applies to devices/objects in the union of device/object groups; false if it applies to devices/objects in the intersection of device/object groups.',
  `plugin_id` int(11) DEFAULT NULL COMMENT 'A Policy may only use ONE Object Type, which implies ONE Plugin. foreignKey: net.plugins.id',
  `object_type_id` int(11) DEFAULT NULL COMMENT 'This is the Object Type for the Policy.  ZOMG REFERENCE foreignKey: net.plugin_object_type.id',
  `object_sub_type_id` int(11) DEFAULT NULL COMMENT 'This is the ''subtype'' ID, specific to the Object Type.  This may be -1 for n/a. foreignKey: net.objectsubtypes.id',
  `severity` int(11) DEFAULT NULL COMMENT 'The severity of the alert to generate (0-8).',
  `trigger_expression` varchar(1024) DEFAULT NULL COMMENT 'This is the DNF of the logic to use to evaluate the threshold. '','' is AND; ''|'' is OR. ANDs are evaluated first; then ORs.  Numbers are condition IDs (see net.policyconditions.id).',
  `clear_expression` varchar(1024) DEFAULT NULL COMMENT 'This is the DNF of the logic to use to clear the threshold. '','' is AND; ''|'' is OR. ANDs are evaluated first; then ORs.  Numbers are condition IDs (see net.policyconditions.id).',
  `user_enabled` int(11) DEFAULT 1 COMMENT '1 if the policy has been enabled by a user; 0 otherwise.',
  `mail_to` varchar(1024) DEFAULT NULL COMMENT 'This is a comma-separated list of email addresses (both real and SevOne user and SevOne group addresses).',
  `mail_once` smallint(6) DEFAULT 1 COMMENT '1 if only one email should be sent about any thresholds generated by this policy (once an alert is generated); 0 if an email should be sent each time it triggers.',
  `mail_period` int(11) NOT NULL DEFAULT 900 COMMENT 'If ''mail_once'' is 0, then this is how often to send the emails (minimum time in seconds).',
  `last_updated` int(11) DEFAULT NULL COMMENT 'The time at which this policy was last updated (epoch).',
  `use_default_traps` smallint(6) DEFAULT 1 COMMENT '1 if the system-default SNMP trap destinations should be used; 0 otherwise.',
  `use_device_traps` smallint(6) DEFAULT 1 COMMENT '1 if the Device-specific SNMP trap destinations should be used; 0 otherwise.',
  `use_custom_traps` smallint(6) DEFAULT 0 COMMENT '1 if this policy has its own set of SNMP trap destinations configured; 0 otherwise.',
  `trigger_message` text DEFAULT NULL COMMENT 'This is the message to use to create the alert text when the threshold is triggered.',
  `clear_message` text DEFAULT NULL COMMENT 'This is the message to use to create the clear text when the threshold is cleared.',
  `append_condition_messages` smallint(6) DEFAULT 1 COMMENT '1 if, in addition to ''trigger_message'' or ''clear_message'', a series of messages about the conditions that triggered should be appended to the alert text; 0 otherwise.',
  `type` enum('other','flow') NOT NULL DEFAULT 'other' COMMENT 'Type of policy: flow - netflow, other - everything else',
  `folder_id` bigint(20) unsigned NOT NULL DEFAULT 2 COMMENT 'The folder id where this policies resides',
  `use_device_work_hours` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if the Device Work Hours should be used instead of ''Shedule'' options; 0 otherwise.',
  `is_service_alerts` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'true if this policy is a flow app alerts policy.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_key` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the Threshold Policies in the system.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy`
--
-- WHERE:  1 limit 10

LOCK TABLES `policy` WRITE;
/*!40000 ALTER TABLE `policy` DISABLE KEYS */;
INSERT INTO `policy` VALUES (1,'Ethernet Interface Traffic Over 95% - 32 Bit Counters','Ethernet Interface Traffic - 32 Bit Counters',1,1,1,274,6,3,'58|60','62|64',1,'',1,900,1300459134,1,1,0,'','',1,'other',2,0,0),(2,'Cisco IOS Memory Over 95%','Used Memory Alerts',1,1,1,273,-1,3,'66','68',1,'',1,900,1300459485,1,1,0,'','',1,'other',2,0,0),(3,'Disk Over 90%','Generic Disk Used Alerts',1,1,1,272,-1,4,'5','6',1,'',1,900,1300459545,1,1,0,'','',1,'other',2,0,0),(4,'TCP Port Availability Under 100%','TCP Connect Alerts',1,1,7,269,-1,2,'264','265',1,'',1,900,1300459793,1,1,0,'','',1,'other',2,0,0),(5,'Website Alerts','Website Alerts',1,1,4,70,-1,1,'269|270|132','134|135|136',1,'',1,900,1300460054,1,1,0,'','',1,'other',2,0,0),(6,'ICMP Packet Loss Over 60%','ICMP Alerts',1,1,2,71,-1,0,'271','272',1,'',1,900,1300460199,1,1,0,'','',1,'other',2,0,0),(7,'Cisco IPSLA Echo High Response Time','Cisco IPSLA Echo Alerts',1,1,9,72,-1,0,'140','277',1,'',1,900,1300460369,1,1,0,'','',1,'other',2,0,0),(8,'Ethernet Interface Traffic Over 95% - 64 Bit Counters','Ethernet Interface Traffic - 64 Bit Counters',1,1,1,274,6,3,'141|142','143|144',1,'',1,900,1300458881,1,1,0,'','',1,'other',2,0,0),(9,'Interface Errors and Discards Over 100 in 15 Minutes','Interface Errors',1,1,1,274,-1,3,'278|279|280|281','282,283,284,285',1,'',1,900,1300460691,1,1,0,'','',1,'other',2,0,0),(10,'CallManager Server Status','CallManager Server Status',1,1,1,446,-1,0,'160|161','162',1,'',1,900,1300460839,1,1,0,'','',1,'other',2,0,0);
/*!40000 ALTER TABLE `policy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_absolutetime`
--

DROP TABLE IF EXISTS `policy_absolutetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_absolutetime` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PRimary Key',
  `policy_id` int(11) NOT NULL COMMENT 'Foreign Key to net.policy foreignKey: net.policy.id',
  `start_time` int(11) NOT NULL DEFAULT 0 COMMENT 'Start Time',
  `end_time` int(11) NOT NULL DEFAULT 0 COMMENT 'End Time',
  `on_off` int(11) NOT NULL DEFAULT 0 COMMENT 'If this is on or off',
  `time_zone` varchar(255) DEFAULT 'UTC' COMMENT 'The time zone this policy',
  PRIMARY KEY (`id`),
  KEY `policy_id` (`policy_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='The time for the policys';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_absolutetime`
--
-- WHERE:  1 limit 10

LOCK TABLES `policy_absolutetime` WRITE;
/*!40000 ALTER TABLE `policy_absolutetime` DISABLE KEYS */;
/*!40000 ALTER TABLE `policy_absolutetime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_conditions_flowfalcon`
--

DROP TABLE IF EXISTS `policy_conditions_flowfalcon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_conditions_flowfalcon` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `condition_id` int(11) NOT NULL COMMENT 'Foreign key to net.policyconditions foreignKey: net.policyconditions.id',
  `element_id` bigint(20) NOT NULL COMMENT 'Foreign Key to net.netflow_fields foreignKey: net.netflow_fields.element_id',
  `policy_trigger_id` int(11) NOT NULL COMMENT 'Foreign key to net.policy_triggers foreignKey: net.policy_triggers.id',
  `unit_scale` enum('','k','M','G','T','P','E') NOT NULL COMMENT 'Scale of the policy_conditions.unit that should be used only when presenting policy_conditions.value to the User',
  PRIMARY KEY (`id`),
  UNIQUE KEY `condition_id` (`condition_id`),
  KEY `policy_trigger_id` (`policy_trigger_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='List of Policy conditions for netflow';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_conditions_flowfalcon`
--
-- WHERE:  1 limit 10

LOCK TABLES `policy_conditions_flowfalcon` WRITE;
/*!40000 ALTER TABLE `policy_conditions_flowfalcon` DISABLE KEYS */;
INSERT INTO `policy_conditions_flowfalcon` VALUES (1,318,1,1,''),(2,319,1,2,''),(3,320,0,3,''),(4,321,0,4,'');
/*!40000 ALTER TABLE `policy_conditions_flowfalcon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_flowfalcon`
--

DROP TABLE IF EXISTS `policy_flowfalcon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_flowfalcon` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `policy_id` int(11) NOT NULL COMMENT 'Foreign Key to net.policy foreignKey: net.policy.id',
  `view_id` int(11) NOT NULL COMMENT 'Foreign Key to net.flowfalconview foreignKey: net.flowfalconview.id',
  `direction` int(11) DEFAULT NULL COMMENT 'Flow direction',
  `filter_id` int(11) DEFAULT NULL COMMENT 'Foreign key to net.flowfalconfilters foreignKey: net.flowfalconfilters.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `policy_id` (`policy_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='List of Flowfalcon Policies';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_flowfalcon`
--
-- WHERE:  1 limit 10

LOCK TABLES `policy_flowfalcon` WRITE;
/*!40000 ALTER TABLE `policy_flowfalcon` DISABLE KEYS */;
INSERT INTO `policy_flowfalcon` VALUES (1,34,89,-1,NULL),(2,35,68,-1,NULL);
/*!40000 ALTER TABLE `policy_flowfalcon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_folders`
--

DROP TABLE IF EXISTS `policy_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_folders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(256) DEFAULT NULL COMMENT 'The name of the folder',
  `parent_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the parent folder. foreignKey: net.policy_folders.id',
  `is_editable` smallint(6) NOT NULL DEFAULT 1 COMMENT '0 if folder and policies under it are non-editable; 1 otherwise.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_id` (`parent_id`,`name`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the table that stores the policy folders information.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_folders`
--
-- WHERE:  1 limit 10

LOCK TABLES `policy_folders` WRITE;
/*!40000 ALTER TABLE `policy_folders` DISABLE KEYS */;
INSERT INTO `policy_folders` VALUES (1,'All Policies',0,1),(2,'Default',1,1),(3,'Selfmon Alerts',1,0),(4,'JSON',1,1);
/*!40000 ALTER TABLE `policy_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_group_map`
--

DROP TABLE IF EXISTS `policy_group_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_group_map` (
  `policy_id` int(11) NOT NULL COMMENT 'Policy id. foreignKey: net.policy.id',
  `group_id` int(11) NOT NULL COMMENT 'The group id associated with the policy, either devicetags or objectgroupinfo, depending on net.policy.is_device_group',
  PRIMARY KEY (`policy_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the policy-device/object group map in the system.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_group_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `policy_group_map` WRITE;
/*!40000 ALTER TABLE `policy_group_map` DISABLE KEYS */;
INSERT INTO `policy_group_map` VALUES (1,41),(2,41),(3,41),(4,41),(5,41),(6,41),(7,41),(8,41),(9,41),(10,41);
/*!40000 ALTER TABLE `policy_group_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_relativetime`
--

DROP TABLE IF EXISTS `policy_relativetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_relativetime` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `policy_id` int(11) NOT NULL COMMENT 'Foreign Key to net.policy. foreignKey: net.policy.id',
  `monday` int(11) NOT NULL DEFAULT 0 COMMENT 'Relative Time for Monday',
  `tuesday` int(11) NOT NULL DEFAULT 0 COMMENT 'Relative Time for Tuesday',
  `wednesday` int(11) NOT NULL DEFAULT 0 COMMENT 'Relative Time for Wednesday',
  `thursday` int(11) NOT NULL DEFAULT 0 COMMENT 'Relative Time for Thursday',
  `friday` int(11) NOT NULL DEFAULT 0 COMMENT 'Relative Time for Friday',
  `saturday` int(11) NOT NULL DEFAULT 0 COMMENT 'Relative Time for Saturday',
  `sunday` int(11) NOT NULL DEFAULT 0 COMMENT 'Relative Time for Sunday',
  `start_hr` int(11) NOT NULL DEFAULT 0 COMMENT 'Starting Hour',
  `start_min` int(11) NOT NULL DEFAULT 0 COMMENT 'Starting Minute',
  `end_hr` int(11) NOT NULL DEFAULT 0 COMMENT 'Ending Hour',
  `end_min` int(11) NOT NULL DEFAULT 0 COMMENT 'Ending Minute',
  `time_zone` varchar(255) DEFAULT 'UTC' COMMENT 'Time Zone',
  `on_off` int(11) DEFAULT 0 COMMENT 'Is This On or Off',
  PRIMARY KEY (`id`),
  KEY `policy_id` (`policy_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Realative Time Options for the Policys';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_relativetime`
--
-- WHERE:  1 limit 10

LOCK TABLES `policy_relativetime` WRITE;
/*!40000 ALTER TABLE `policy_relativetime` DISABLE KEYS */;
/*!40000 ALTER TABLE `policy_relativetime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_rules`
--

DROP TABLE IF EXISTS `policy_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `policy_id` int(11) NOT NULL COMMENT 'Foreign Key to net.policy foreignKey: net.policy.id',
  `rule_number` smallint(6) NOT NULL COMMENT 'Determines the logical association between rule conditions',
  `condition_id` int(11) NOT NULL COMMENT 'Foreign key to net.policyconditions foreignKey: net.policyconditions.id',
  `policy_trigger_id` int(11) NOT NULL COMMENT 'Foreign key to net.policy_triggers foreignKey: net.policy_triggers.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `policy_rule_condition` (`policy_id`,`rule_number`,`condition_id`),
  KEY `policy_trigger_id` (`policy_trigger_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='List of Policy rules';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_rules`
--
-- WHERE:  1 limit 10

LOCK TABLES `policy_rules` WRITE;
/*!40000 ALTER TABLE `policy_rules` DISABLE KEYS */;
INSERT INTO `policy_rules` VALUES (1,34,1,318,1),(2,34,1,319,2),(3,35,1,320,3),(4,35,1,321,4);
/*!40000 ALTER TABLE `policy_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_service_profiles`
--

DROP TABLE IF EXISTS `policy_service_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_service_profiles` (
  `policy_id` int(11) NOT NULL COMMENT 'Policy id. foreignKey: net.policy.id',
  `service_profile_id` int(11) NOT NULL COMMENT 'The app profile id associated with the policy. This can refer to the `id` in either net.flow_service_profiles or net.ext_flow_service_profiles',
  PRIMARY KEY (`policy_id`,`service_profile_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the policy-app profile map in the system.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_service_profiles`
--
-- WHERE:  1 limit 10

LOCK TABLES `policy_service_profiles` WRITE;
/*!40000 ALTER TABLE `policy_service_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `policy_service_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_triggers`
--

DROP TABLE IF EXISTS `policy_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_triggers` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `type` enum('trigger','clear') NOT NULL COMMENT 'Type of trigger',
  `duration` int(11) NOT NULL COMMENT 'Duration after which the trigger/clear condition is applied',
  `policy_id` int(11) NOT NULL COMMENT 'Foreign key to net.policy foreignKey: net.policy.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `policy_condition_type` (`policy_id`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='List of Policy triggers';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_triggers`
--
-- WHERE:  1 limit 10

LOCK TABLES `policy_triggers` WRITE;
/*!40000 ALTER TABLE `policy_triggers` DISABLE KEYS */;
INSERT INTO `policy_triggers` VALUES (1,'trigger',1,34),(2,'clear',1,34),(3,'trigger',5,35),(4,'clear',1,35),(5,'trigger',1,51),(6,'clear',1,51),(7,'trigger',1,52),(8,'clear',1,52),(9,'trigger',1,53),(10,'clear',1,53);
/*!40000 ALTER TABLE `policy_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policy_webhooks`
--

DROP TABLE IF EXISTS `policy_webhooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_webhooks` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `policy_id` int(11) NOT NULL COMMENT 'PolicyId. foreignKey: net.policy.id',
  `type` enum('trigger','clear') NOT NULL COMMENT 'Type of a webhook Trigger/ Clear',
  `override_single_webhook_per_alert` tinyint(4) DEFAULT NULL COMMENT 'OverrideSingleWebhookPerAlert',
  `start_time` datetime DEFAULT NULL COMMENT 'StartTime',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`policy_id`,`type`),
  KEY `policy_id` (`policy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the basic information about Devices.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_webhooks`
--
-- WHERE:  1 limit 10

LOCK TABLES `policy_webhooks` WRITE;
/*!40000 ALTER TABLE `policy_webhooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `policy_webhooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policyconditions`
--

DROP TABLE IF EXISTS `policyconditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policyconditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `policy_id` int(11) DEFAULT 0 COMMENT 'Foreign Key to net.policy foreignKey: net.policy.id',
  `indicator_type_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to net.plugin_indicator_type foreignKey: net.plugin_indicator_type.id',
  `type` int(11) DEFAULT NULL COMMENT 'Type',
  `is_trigger` int(11) DEFAULT NULL COMMENT 'If this confition is a trigger',
  `value` double DEFAULT NULL COMMENT 'The value of this condition',
  `unit` varchar(32) DEFAULT NULL COMMENT 'Unit',
  `comparison` smallint(6) DEFAULT NULL COMMENT 'What kind of comparison',
  `aggregation` smallint(6) DEFAULT NULL COMMENT 'Aggregation',
  `duration` int(11) DEFAULT NULL COMMENT 'The Duration',
  `message` varchar(1024) DEFAULT NULL COMMENT 'Message to set as part of this policy',
  `sigma_direction` smallint(6) DEFAULT NULL COMMENT 'Sigma Direction',
  `value2` double DEFAULT NULL COMMENT 'The second value against which to compare the data e.g. ''count of values'' or ''time interval'' or ''% values/time'' that the condtion is true. The meaning is determined by the aggregation value.',
  PRIMARY KEY (`id`),
  KEY `policy_id` (`policy_id`)
) ENGINE=InnoDB AUTO_INCREMENT=359 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='List of Policy Conditions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policyconditions`
--
-- WHERE:  1 limit 10

LOCK TABLES `policyconditions` WRITE;
/*!40000 ALTER TABLE `policyconditions` DISABLE KEYS */;
INSERT INTO `policyconditions` VALUES (5,3,18,0,1,90,'Percent',0,2,900,'',NULL,NULL),(6,3,18,0,0,75,'Percent',1,2,900,'',NULL,NULL),(58,1,51,0,1,95,'Percent',0,2,900,'',NULL,NULL),(60,1,52,0,1,95,'Percent',0,2,900,'',NULL,NULL),(62,1,51,0,0,85,'Percent',1,2,900,'',NULL,NULL),(64,1,52,0,0,85,'Percent',1,2,900,'',NULL,NULL),(66,2,16,0,1,95,'Percent',0,2,900,'',NULL,NULL),(68,2,16,0,0,85,'Percent',1,2,900,'',NULL,NULL),(132,5,6983,0,1,100,'Percent',1,2,900,'',NULL,NULL),(134,5,6980,0,0,20,'Milliseconds',1,2,300,'',NULL,NULL);
/*!40000 ALTER TABLE `policyconditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policytrapdestination`
--

DROP TABLE IF EXISTS `policytrapdestination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `policytrapdestination` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `policy_id` int(10) DEFAULT NULL COMMENT 'policy_id foreignKey: net.policy.id',
  `trap_destination_id` int(10) DEFAULT NULL COMMENT 'trap_destination_id foreignKey: net.trapdestination.id',
  `is_enabled` smallint(6) DEFAULT 0 COMMENT 'is_enabled',
  PRIMARY KEY (`id`),
  UNIQUE KEY `policy_key` (`policy_id`,`trap_destination_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Policy trap destination';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policytrapdestination`
--
-- WHERE:  1 limit 10

LOCK TABLES `policytrapdestination` WRITE;
/*!40000 ALTER TABLE `policytrapdestination` DISABLE KEYS */;
/*!40000 ALTER TABLE `policytrapdestination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `port_checker_tcp`
--

DROP TABLE IF EXISTS `port_checker_tcp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `port_checker_tcp` (
  `port` smallint(5) unsigned NOT NULL COMMENT 'This is the port number',
  `required` tinyint(1) NOT NULL COMMENT 'If the port is considered "required"',
  PRIMARY KEY (`port`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines Port Checker TCP';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `port_checker_tcp`
--
-- WHERE:  1 limit 10

LOCK TABLES `port_checker_tcp` WRITE;
/*!40000 ALTER TABLE `port_checker_tcp` DISABLE KEYS */;
INSERT INTO `port_checker_tcp` VALUES (22,1),(25,0),(53,0),(80,0),(389,0),(443,1),(636,0),(873,0),(3306,1),(3307,1);
/*!40000 ALTER TABLE `port_checker_tcp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `port_checker_udp`
--

DROP TABLE IF EXISTS `port_checker_udp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `port_checker_udp` (
  `port` smallint(5) unsigned NOT NULL COMMENT 'This is the port number',
  `required` tinyint(1) NOT NULL COMMENT 'If the port is considered "required"',
  PRIMARY KEY (`port`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines Port Checker UDP';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `port_checker_udp`
--
-- WHERE:  1 limit 10

LOCK TABLES `port_checker_udp` WRITE;
/*!40000 ALTER TABLE `port_checker_udp` DISABLE KEYS */;
INSERT INTO `port_checker_udp` VALUES (53,0),(123,0),(161,0),(162,0),(514,0),(5900,0),(5901,0),(6343,0),(6831,0),(9996,0);
/*!40000 ALTER TABLE `port_checker_udp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `protocol`
--

DROP TABLE IF EXISTS `protocol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `protocol` (
  `protocol_num` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the protocol number; see http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xml.',
  `protocol_name` varchar(32) DEFAULT NULL COMMENT 'The name of the protocol.  This is the ''Keyword'' in the document above.',
  `protocol_desc` varchar(128) DEFAULT NULL COMMENT 'The more descriptive name of the protocol.  This is the ''Protocol'' in the document above.',
  PRIMARY KEY (`protocol_num`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the networking protocols for use with NetFlow reporting.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `protocol`
--
-- WHERE:  1 limit 10

LOCK TABLES `protocol` WRITE;
/*!40000 ALTER TABLE `protocol` DISABLE KEYS */;
INSERT INTO `protocol` VALUES (0,'HOPOPT','IPv6 Hop-by-Hop Option'),(1,'ICMP','Internet Control Message'),(2,'IGMP','Internet Group Management'),(3,'GGP','Gateway-to-Gateway'),(4,'IP','IP in IP (encapsulation)'),(5,'ST','Stream'),(6,'TCP','Transmission Control'),(7,'CBT','CBT'),(8,'EGP','Exterior Gateway Protocol'),(9,'IGP','any private interior gateway');
/*!40000 ALTER TABLE `protocol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proxies`
--

DROP TABLE IF EXISTS `proxies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `proxies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key the ID of the proxy',
  `name` varchar(128) NOT NULL COMMENT 'User input name',
  `description` varchar(255) DEFAULT NULL COMMENT 'User input description',
  `host` varbinary(40) NOT NULL COMMENT 'IP address (v4/v6) or hostname of the proxy',
  `port` int(11) NOT NULL COMMENT 'TCP port number, 1-65535',
  `username` varchar(128) DEFAULT NULL COMMENT 'Username for authentication',
  `password` varchar(255) DEFAULT NULL COMMENT 'Password for authentication',
  `type` enum('WMI','HTTP','NONE') NOT NULL DEFAULT 'NONE' COMMENT 'Type of the proxy, currently one of WMI, HTTP, or NONE',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the information about Proxies.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proxies`
--
-- WHERE:  1 limit 10

LOCK TABLES `proxies` WRITE;
/*!40000 ALTER TABLE `proxies` DISABLE KEYS */;
/*!40000 ALTER TABLE `proxies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proxypingdeviceinfo`
--

DROP TABLE IF EXISTS `proxypingdeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `proxypingdeviceinfo` (
  `dev_id` int(11) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `type` int(11) NOT NULL COMMENT '1: Cisco; 2: DISMAN; 3: DISMAN (net-snmp variant 2); 4: DISMAN (net-snmp variant 1); 0: unknown.',
  PRIMARY KEY (`dev_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table maps a Device to a particular _kind_ of Proxyping mechanism.  This is because there are many ways to issue a remote ping, and this Plugin supports them all.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proxypingdeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `proxypingdeviceinfo` WRITE;
/*!40000 ALTER TABLE `proxypingdeviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `proxypingdeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule_instance`
--

DROP TABLE IF EXISTS `schedule_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_instance` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for the table.',
  `is_deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Mark event as deleted.',
  `start_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Start date and time of the event.',
  `end_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'End date and time of the event.',
  `create_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Creation date and time of the event.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores single events in our scheduler';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_instance`
--
-- WHERE:  1 limit 10

LOCK TABLES `schedule_instance` WRITE;
/*!40000 ALTER TABLE `schedule_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedule_instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sdndeviceinfo`
--

DROP TABLE IF EXISTS `sdndeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sdndeviceinfo` (
  `dev_id` bigint(20) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `apic_url` longtext NOT NULL COMMENT 'SDN apic url',
  `apic_uid` longtext DEFAULT NULL COMMENT 'SDN apic user id',
  `apic_password` longtext DEFAULT NULL COMMENT 'SDN apic user password',
  `mso_enabled` tinyint(1) unsigned DEFAULT 0 COMMENT 'SDN mso enabled',
  `prefix_enabled` tinyint(1) unsigned DEFAULT 0 COMMENT 'SDN Device prefix enabled',
  `prefix_name` longtext DEFAULT NULL COMMENT 'SDN Device prefix name',
  `settings` longtext DEFAULT NULL COMMENT 'SDN Device extra settings',
  `cert_based_auth` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'If 1, SDN will use cert file. If 0, SDN will use password.',
  `cert_file_path` text DEFAULT NULL COMMENT 'SDN cert file path.',
  PRIMARY KEY (`dev_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines SDN-specific information about a Device.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sdndeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `sdndeviceinfo` WRITE;
/*!40000 ALTER TABLE `sdndeviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `sdndeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sdwandeviceinfo`
--

DROP TABLE IF EXISTS `sdwandeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sdwandeviceinfo` (
  `dev_id` bigint(20) NOT NULL COMMENT 'foreignKey: net.deviceinfo.id',
  `vendor` varchar(255) NOT NULL COMMENT 'fortinet vendor',
  `username` varchar(255) NOT NULL COMMENT 'username of the device',
  `password` varchar(255) NOT NULL COMMENT 'encrypted password of the device',
  `url` varchar(512) NOT NULL COMMENT 'URL of FortiManager',
  `settings` longtext NOT NULL COMMENT ' ',
  PRIMARY KEY (`dev_id`),
  CONSTRAINT `settings_valid` CHECK (json_valid(`settings`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all SDWAN Device information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sdwandeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `sdwandeviceinfo` WRITE;
/*!40000 ALTER TABLE `sdwandeviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `sdwandeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `setting` varchar(128) DEFAULT NULL COMMENT 'The name of the setting.',
  `value` varchar(1500) DEFAULT NULL COMMENT 'The value of the setting.',
  UNIQUE KEY `setting` (`setting`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the various key/value settings for the cluster.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--
-- WHERE:  1 limit 10

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES ('short_term_duration','14400'),('netflow_duration','86400'),('netflow_write_interval','60'),('thread_pool_max','60'),('debug_level','4'),('mailserver',''),('mail_user',''),('mail_password',''),('mail_sender',''),('mail_client_hostname','localhost.localdomain');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sftp_servers`
--

DROP TABLE IF EXISTS `sftp_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sftp_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `host` varchar(64) DEFAULT '' COMMENT 'This is the host name or IP address of the servers',
  `port` int(11) DEFAULT 22 COMMENT 'This is the port to connect on',
  `user` varchar(64) DEFAULT '' COMMENT 'This is the user credentials',
  `passwd` varchar(64) DEFAULT '' COMMENT 'This is the password for the user',
  `path` varchar(255) DEFAULT '' COMMENT 'This is the path to store the files in',
  PRIMARY KEY (`id`),
  UNIQUE KEY `server` (`host`,`path`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the sftp server credentials that are used for exporting reports';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sftp_servers`
--
-- WHERE:  1 limit 10

LOCK TABLES `sftp_servers` WRITE;
/*!40000 ALTER TABLE `sftp_servers` DISABLE KEYS */;
/*!40000 ALTER TABLE `sftp_servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snmp_mibs`
--

DROP TABLE IF EXISTS `snmp_mibs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `snmp_mibs` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'This is the name of the MIB, as given by the ''* DEFINITIONS ::= BEGIN'' section.',
  `date_added` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the timestamp at which the MIB was added to the system (epoch).',
  `date_updated` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the timestamp at which the MIB was last updated (epoch).',
  `revision` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the number of times that the MIB has been updated; note that this always starts at 1.',
  `notes` text DEFAULT NULL COMMENT 'Any relevant notes about the MIB; this is currently not used.',
  `contents` longblob DEFAULT NULL COMMENT 'This is full file contents of the MIB; this is used to populate actual files on disk in /usr/local/snmp/mibs.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=171 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the SNMP MIBs that are used to translate from OID numbers to OID names.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snmp_mibs`
--
-- WHERE:  1 limit 10

LOCK TABLES `snmp_mibs` WRITE;
/*!40000 ALTER TABLE `snmp_mibs` DISABLE KEYS */;
INSERT INTO `snmp_mibs` VALUES (1,'ADTRAN-IADROUTER-MIB',1756979642,1756979642,1,'','ADTRAN-IADROUTER-MIB   DEFINITIONS ::= BEGIN\r\n\r\n-- TITLE:       ADTRAN adIadRouter MIB\r\n-- FILENAME:    adIadRouter.mi2\r\n-- AUTHOR:      Steve Shown\r\n-- DATE:        04/26/02\r\n\r\n\r\nIMPORTS\r\n    DisplayString, MacAddress, RowStatus\r\n        FROM SNMPv2-TC\r\n    frDlcmiIfIndex, frCircuitDlci\r\n        FROM FRAME-RELAY-DTE-MIB\r\n    ifIndex, InterfaceIndex\r\n        FROM IF-MIB\r\n    Integer32, Unsigned32, Gauge32,\r\n    Counter32, IpAddress,\r\n    OBJECT-TYPE, MODULE-IDENTITY\r\n        FROM SNMPv2-SMI\r\n    MODULE-COMPLIANCE, OBJECT-GROUP\r\n        FROM SNMPv2-CONF\r\n    adShared\r\n        FROM ADTRAN-MIB;\r\n\r\n\r\nadIadRouter MODULE-IDENTITY\r\n        LAST-UPDATED \"0301160000Z\"\r\n        ORGANIZATION \"ADTRAN, Inc.\"\r\n        CONTACT-INFO\r\n               \"        Technical Support Dept.\r\n                Postal: ADTRAN, Inc.\r\n                        901 Explorer Blvd.\r\n                        Huntsville, AL 35806\r\n\r\n                   Tel: +1 800 726-8663\r\n                   Fax: +1 256 963 6217\r\n                E-mail: support@adtran.com\"\r\n        DESCRIPTION\r\n            \"The MIB module for IAD Router management.\"\r\n\r\n        REVISION    \"0301160000Z\"\r\n        DESCRIPTION\r\n            \"Obsoleted adIadNatAddrMode\r\n             Created adIadNatAddrModeRev030116Z\"\r\n\r\n        REVISION    \"0212200000Z\"\r\n        DESCRIPTION\r\n            \"Added ATM provsioning items.\r\n             Added adIadEther2ndaryIpNatMode.\r\n             Added adIadNatTranslateUnmappedPorts.\r\n             Added adIadPppForcePeerIp.\r\n             Added adIadPppKeepAlivePeriod\"\r\n\r\n        REVISION    \"0204260000Z\"\r\n        DESCRIPTION\r\n            \"Initial revision of the module.\"\r\n        ::= { adShared 33 }\r\n\r\n--\r\n--  Card Provisioning group\r\n--\r\n\r\nadIadRouterProv        OBJECT IDENTIFIER ::= { adIadRouter 1 }\r\nadIadRouterTest        OBJECT IDENTIFIER ::= { adIadRouter 2 }\r\nadIadRouterStatus      OBJECT IDENTIFIER ::= { adIadRouter 3 }\r\nadIadRouterConformance OBJECT IDENTIFIER ::= { adIadRouter 4 }\r\n\r\nadIadBaseRtProv        OBJECT IDENTIFIER ::= { adIadRouterProv 1 }\r\nadIadInterfaceIpProv   OBJECT IDENTIFIER ::= { adIadRouterProv 2 }\r\nadIadStaticRtProv      OBJECT IDENTIFIER ::= { adIadRouterProv 3 }\r\nadIadUdpRelayProv      OBJECT IDENTIFIER ::= { adIadRouterProv 4 }\r\nadIadProtocolProv      OBJECT IDENTIFIER ::= { adIadRouterProv 5 }\r\nadIadNatProv           OBJECT IDENTIFIER ::= { adIadRouterProv 6 }\r\nadIadFilterProv        OBJECT IDENTIFIER ::= { adIadRouterProv 7 }\r\nadIadXConnectProv      OBJECT IDENTIFIER ::= { adIadRouterProv 8 }\r\n\r\nadIadLayer2Prov        OBJECT IDENTIFIER ::= { adIadProtocolProv 1 }\r\nadIadPppProv           OBJECT IDENTIFIER ::= { adIadProtocolProv 2 }\r\nadIadFrameProv         OBJECT IDENTIFIER ::= { adIadProtocolProv 3 }\r\nadIadBridgeProv        OBJECT IDENTIFIER ::= { adIadProtocolProv 4 }\r\nadIadAtmProv           OBJECT IDENTIFIER ::= { adIadProtocolProv 5 }\r\n\r\nadIadBaseRtStat        OBJECT IDENTIFIER ::= { adIadRouterStatus 1 }\r\nadIadProtocolStat      OBJECT IDENTIFIER ::= { adIadRouterStatus 2 }\r\nadIadBridgeStat        OBJECT IDENTIFIER ::= { adIadRouterStatus 3 }\r\n\r\nadIadRouterCompliances OBJECT IDENTIFIER ::= { adIadRouterConformance 1 }\r\nadIadRouterMIBGroups   OBJECT IDENTIFIER ::= { adIadRouterConformance 2 }\r\n\r\n\r\n--\r\n-- Base Routing\r\n--\r\n\r\nadIadDhcpMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               disabled(1),\r\n               enabled(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Enable/Disable DHCP operation\"\r\n    ::= { adIadBaseRtProv 1 }\r\n\r\nadIadDhcpRenewalTime OBJECT-TYPE\r\n    SYNTAX     Integer32 (0..255)\r\n    UNITS      \"hours\"\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"DHCP Renewal Time\"\r\n    ::= { adIadBaseRtProv 2 }\r\n\r\nadIadDomainName OBJECT-TYPE\r\n    SYNTAX     DisplayString (SIZE(1..16))\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Domain Name\"\r\n    ::= { adIadBaseRtProv 3 }\r\n\r\nadIadPrimaryDNSaddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Primary DNS Server Address\"\r\n    ::= { adIadBaseRtProv 4 }\r\n\r\nadIad2ndaryDNSaddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Secondary DNS Server Address\"\r\n    ::= { adIadBaseRtProv 5 }\r\n\r\nadIadPrimaryWINSaddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Primary NBNS/WINS Server Address\"\r\n    ::= { adIadBaseRtProv 6 }\r\n\r\nadIad2ndaryWINSaddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Secondary NBNS/WINS Server Address\"\r\n    ::= { adIadBaseRtProv 7 }\r\n\r\nadIadUdpRelay OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               disabled(1),\r\n               enabled(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Enable/Disable UDP Relay operation\"\r\n    ::= { adIadBaseRtProv 8 }\r\n\r\nadIadRtrDefaultGateway OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Router Default Gateway Address\"\r\n    ::= { adIadBaseRtProv 9 }\r\n\r\n--\r\n--  Configure IP Interface\r\n--\r\n\r\nadIadInterfaceIpTable  OBJECT-TYPE\r\n    SYNTAX      SEQUENCE OF AdIadInterfaceIpEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS      current\r\n    DESCRIPTION\r\n        \"The Router MIB Interface Provisioning Table.\"\r\n    ::= { adIadInterfaceIpProv 1 }\r\n\r\nadIadInterfaceIpEntry  OBJECT-TYPE\r\n    SYNTAX      AdIadInterfaceIpEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Router MIB Interface Provisioning\r\n        Table.\"\r\n    INDEX    {ifIndex }\r\n    ::=  { adIadInterfaceIpTable 1 }\r\n\r\nAdIadInterfaceIpEntry ::=      SEQUENCE {\r\n        adIadInterfaceAddressMode   INTEGER,\r\n        adIadInterfaceLocalIpAddr   IpAddress,\r\n        adIadInterfaceNetMask       IpAddress,\r\n        adIadInterfaceFarEnd        IpAddress\r\n    }\r\n\r\nadIadInterfaceAddressMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               userSpecified(1),\r\n               iarp(2),\r\n               ipcp(3),\r\n               dhcpClient(4)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Method for obtaining Interface IP address\"\r\n    ::= { adIadInterfaceIpEntry 1 }\r\n\r\n\r\nadIadInterfaceLocalIpAddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Interface\'s local IP address\"\r\n    ::= { adIadInterfaceIpEntry 2 }\r\n\r\nadIadInterfaceNetMask OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Interface\'s Address Netmask\"\r\n    ::= { adIadInterfaceIpEntry 3 }\r\n\r\nadIadInterfaceFarEnd OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Interface\'s Next-Hop Address\"\r\n    ::= { adIadInterfaceIpEntry 4 }\r\n\r\n--\r\n-- Ethernet Primary\r\n--\r\n\r\nadIadEtherPrimaryProv OBJECT IDENTIFIER ::= { adIadInterfaceIpProv 2 }\r\n\r\nadIadEtherPrimaryIpAddr OBJECT-TYPE\r\n    SYNTAX       IpAddress\r\n    MAX-ACCESS   read-write\r\n    STATUS       current\r\n    DESCRIPTION\r\n        \"Ethernet primary IP address\"\r\n    ::= { adIadEtherPrimaryProv 1 }\r\n\r\nadIadEtherPrimaryIpNetMask OBJECT-TYPE\r\n    SYNTAX       IpAddress\r\n    MAX-ACCESS   read-write\r\n    STATUS       current\r\n    DESCRIPTION\r\n        \"Ethernet\'s primary IP netMask\"\r\n    ::= { adIadEtherPrimaryProv 2 }\r\n\r\nadIadEtherPrimaryProxyARP OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               disabled(1),\r\n               enabled(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Enable/Disable Proxy ARP on Ethernet\'s primary IP\r\n        address.\"\r\n    ::= { adIadEtherPrimaryProv 3 }\r\n\r\n\r\n--\r\n-- Ethernet Secondary IP address Table\r\n--\r\n\r\nadIadEther2ndaryIpTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadEther2ndaryIpEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The Router MIB Ethernet\'s Secondary IP address table.\"\r\n    ::= { adIadInterfaceIpProv 3 }\r\n\r\nadIadEther2ndaryIpEntry  OBJECT-TYPE\r\n    SYNTAX      AdIadEther2ndaryIpEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Router Ethernet\'s Secondary IP address\r\n        table.\"\r\n    INDEX    {ifIndex, adIadEther2ndaryIpIndex }\r\n    ::=  { adIadEther2ndaryIpTable 1 }\r\n\r\nAdIadEther2ndaryIpEntry ::=  SEQUENCE {\r\n        adIadEther2ndaryIpIndex     Integer32,\r\n        adIadEther2ndaryIpAddr      IpAddress,\r\n        adIadEther2ndaryNetMask     IpAddress,\r\n        adIadEther2ndaryIpStatus    RowStatus,\r\n        adIadEther2ndaryIpNatMode   INTEGER\r\n    }\r\n\r\nadIadEther2ndaryIpIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Ethernet\'s Secondary IP address table row index\"\r\n    ::= { adIadEther2ndaryIpEntry 1 }\r\n\r\nadIadEther2ndaryIpAddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Ethernet\'s Secondary IP address\"\r\n    ::= { adIadEther2ndaryIpEntry 2 }\r\n\r\nadIadEther2ndaryNetMask OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Ethernet\'s Secondary IP netmask\"\r\n    ::= { adIadEther2ndaryIpEntry 3 }\r\n\r\nadIadEther2ndaryIpStatus OBJECT-TYPE\r\n    SYNTAX     RowStatus\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The status of this conceptual row.\r\n\r\n        Until instances of all corresponding columns are\r\n        appropriately configured, the value of the corresponding\r\n        instance of the adIadEther2ndaryIpStatus is \'notReady\'.\"\r\n    ::= { adIadEther2ndaryIpEntry 4 }\r\n\r\nadIadEther2ndaryIpNatMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               private(1),\r\n               public(2),\r\n               invalid(3)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The NAT pass through.\r\n         private - If NAT is enabled, NAT will also be applied\r\n                   to this interface.\r\n         public -  NAT is not applied to this interface.\r\n         invalid - this cannot be SET.\"\r\n\r\n    ::= { adIadEther2ndaryIpEntry 5 }\r\n\r\n--\r\n-- Provision RIP\r\n--\r\n\r\nadIadRipTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadRipEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The Router MIB RIP Provisioning Table.\"\r\n    ::= { adIadInterfaceIpProv 4 }\r\n\r\nadIadRipEntry  OBJECT-TYPE\r\n    SYNTAX      AdIadRipEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Router MIB RIP Provisioning Table.\"\r\n    INDEX   { ifIndex }\r\n    ::=  { adIadRipTable 1 }\r\n\r\nAdIadRipEntry ::=  SEQUENCE {\r\n        adIadRipVersion        INTEGER,\r\n        adIadRipMethod         INTEGER,\r\n        adIadRipDirection      INTEGER,\r\n        adIadRipSecret         DisplayString\r\n    }\r\n\r\nadIadRipVersion OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               disabled(1),\r\n               v1(2),\r\n               v2(3)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Either disable RIP or set the desired version to be\r\n         utilized.\"\r\n    ::= { adIadRipEntry 1 }\r\n\r\nadIadRipMethod OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               poisonReverse(1),\r\n               splitHorizon(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Select the RIP method for addressing convergence\r\n        problems.\"\r\n    ::= { adIadRipEntry 2 }\r\n\r\nadIadRipDirection OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               txAndRx(1),\r\n               txOnly(2),\r\n               rxOnly(3)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Specify the direction RIP messages are to be\r\n        transmitted &/or received. \"\r\n    ::= { adIadRipEntry 3 }\r\n\r\nadIadRipSecret OBJECT-TYPE\r\n    SYNTAX      DisplayString (SIZE(1..16))\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Specify the secret for RIP V2 operation.\"\r\n    ::= { adIadRipEntry 4 }\r\n\r\n--\r\n--  Define Static Routes\r\n--\r\n\r\nadIadStaticRtTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadStaticRtEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The Static Route Table.\"\r\n    ::= { adIadStaticRtProv 1 }\r\n\r\nadIadStaticRtEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadStaticRtEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Static Route Table.\r\n\r\n         NOTE: Changes to static IP Routes\r\n         can only be made when adIadStaticRtState\r\n         or adIadStaticRtStatus is set to \'inactive\'\r\n         or \'notInService\' respectively.\"\r\n    INDEX    { adIadStaticRtIndex }\r\n    ::=  { adIadStaticRtTable 1 }\r\n\r\nAdIadStaticRtEntry ::=  SEQUENCE {\r\n       adIadStaticRtIndex     Integer32,\r\n       adIadStaticRtState     INTEGER,\r\n       adIadStaticRtAddr      IpAddress,\r\n       adIadStaticRtNetMask   IpAddress,\r\n       adIadStaticRtGateway   IpAddress,\r\n       adIadStaticRtHops      Integer32,\r\n       adIadStaticRtPrivate   INTEGER,\r\n       adIadStaticRtStatus    RowStatus\r\n    }\r\n\r\nadIadStaticRtIndex OBJECT-TYPE\r\n    SYNTAX     Integer32 ( 0..16 )\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Static Route Table row index\"\r\n    ::= { adIadStaticRtEntry 1 }\r\n\r\nadIadStaticRtState OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               active(1),\r\n               inactive(2)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Whether or not the defined route is active.\"\r\n    ::= { adIadStaticRtEntry 2 }\r\n\r\nadIadStaticRtAddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Static Route IP address\"\r\n    ::= { adIadStaticRtEntry 3 }\r\n\r\nadIadStaticRtNetMask OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Static Route NetMask\"\r\n    ::= { adIadStaticRtEntry 4 }\r\n\r\nadIadStaticRtGateway OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Address of Static Route IP Gateway\"\r\n    ::= { adIadStaticRtEntry 5 }\r\n\r\nadIadStaticRtHops OBJECT-TYPE\r\n    SYNTAX     Integer32 ( 1..16 )\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Static Route IP address number of hops\"\r\n    ::= { adIadStaticRtEntry 6 }\r\n\r\nadIadStaticRtPrivate OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               yes(1),\r\n               no(2)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Whether or not the route is private (i.e. not\r\n        advertised\"\r\n    ::= { adIadStaticRtEntry 7 }\r\n\r\nadIadStaticRtStatus OBJECT-TYPE\r\n    SYNTAX     RowStatus\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The status of this conceptual row.\r\n\r\n        Until instances of all corresponding columns are\r\n        appropriately configured, the value of the corresponding\r\n        instance of the adIadStaticRtStatus is \'notReady\'.\"\r\n    ::= { adIadStaticRtEntry 8 }\r\n\r\n--\r\n--   UDP Relay Table\r\n--\r\n\r\nadIadUdpRelayTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadUdpRelayEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The UDP Relay Address Table.\"\r\n    ::= { adIadUdpRelayProv 1 }\r\n\r\nadIadUdpRelayEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadUdpRelayEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the UDP Relay Address Table.\"\r\n    INDEX    { adIadUdpRelayIndex }\r\n    ::=  { adIadUdpRelayTable 1 }\r\n\r\nAdIadUdpRelayEntry ::=  SEQUENCE {\r\n        adIadUdpRelayIndex     Integer32,\r\n        adIadUdpRelayIpAddr    IpAddress,\r\n        adIadUdpRelayPortType  INTEGER,\r\n        adIadUdpRelayPort1     Integer32,\r\n        adIadUdpRelayPort2     Integer32,\r\n        adIadUdpRelayPort3     Integer32,\r\n        adIadUdpRelayStatus    RowStatus\r\n    }\r\n\r\nadIadUdpRelayIndex OBJECT-TYPE\r\n    SYNTAX     Integer32  (1..4)\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"UDP Relay Address Table row index\"\r\n    ::= { adIadUdpRelayEntry 1 }\r\n\r\nadIadUdpRelayIpAddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"UDP Relay IP address\"\r\n    ::= { adIadUdpRelayEntry 2 }\r\n\r\nadIadUdpRelayPortType OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               standard(1),\r\n               specified(2)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"UDP Relay Port type selection. Set to \'specified\' to\r\n        select a specific address. Otherwise select \'standard\'.\"\r\n    ::= { adIadUdpRelayEntry 3 }\r\n\r\nadIadUdpRelayPort1 OBJECT-TYPE\r\n    SYNTAX     Integer32  (0..65535)\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"UDP Relay Address Port 1 value. Not used if\r\n         adIadUdpRelayPortType is set to \'standard\'.\"\r\n    ::= { adIadUdpRelayEntry 4 }\r\n\r\nadIadUdpRelayPort2 OBJECT-TYPE\r\n    SYNTAX     Integer32  (0..65535)\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"UDP Relay Address Port 2 value. Not used if\r\n         adIadUdpRelayPortType is set to \'standard\'.\"\r\n    ::= { adIadUdpRelayEntry 5 }\r\n\r\nadIadUdpRelayPort3 OBJECT-TYPE\r\n    SYNTAX     Integer32  (0..65535)\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"UDP Relay Address Port 3 value. Not used if\r\n         adIadUdpRelayPortType is set to \'standard\'.\"\r\n    ::= { adIadUdpRelayEntry 6 }\r\n\r\nadIadUdpRelayStatus OBJECT-TYPE\r\n    SYNTAX     RowStatus\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The status of this conceptual row.\r\n\r\n        Until instances of all corresponding columns are\r\n        appropriately configured, the value of the corresponding\r\n        instance of the adIadUdpRelayStatus is \'notReady\'.\"\r\n    ::= { adIadUdpRelayEntry 7 }\r\n\r\n\r\n--\r\n--  Map Layer 2 Protocols\r\n--\r\n\r\nadIadLayer2Table  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadLayer2Entry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of interfaces which can be\r\n        assigned layer 2 protocols.\"\r\n    ::= { adIadLayer2Prov 1 }\r\n\r\nadIadLayer2Entry  OBJECT-TYPE\r\n    SYNTAX     AdIadLayer2Entry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Layer 2 protocol Provisioning Table.\"\r\n    INDEX    { ifIndex }\r\n    ::=  { adIadLayer2Table 1 }\r\n\r\nAdIadLayer2Entry ::=  SEQUENCE {\r\n        adIadLayer2Protocol       INTEGER\r\n    }\r\n\r\nadIadLayer2Protocol OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               none(1),\r\n               iso88023Csmacd(7),\r\n               ppp(23),\r\n               frameRelay(32),\r\n               atm(37)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The selected Layer 2 protocol for the physical interface.\r\n\r\n         Note: Layer 2 Protocols are very specific to the\r\n         physical interface below them.\r\n         1. Only Ethernet interfaces can use iso88023Csmacd\r\n         2. Only V.35 interfaces can use Frame Relay or none\r\n            (transparent).\r\n         3. Only WAN interfaces can support PPP, ATM, or\r\n            FrameRelay\r\n\r\n         Some L2 protocols cannot be changed (such as ATM)\r\n         because of firmware/hardware limitations.\"\r\n\r\n    ::= { adIadLayer2Entry 1 }\r\n\r\n--\r\n--  Frame Relay Configuration\r\n--\r\n\r\nadIadFrameTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadFrameEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table extending the interface table for Frame Relay\r\n        interfaces.\"\r\n    ::= { adIadFrameProv 1 }\r\n\r\nadIadFrameEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadFrameEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Frame Relay Provisioning Table.\"\r\n    INDEX    { frDlcmiIfIndex }\r\n    ::=  { adIadFrameTable 1 }\r\n\r\nAdIadFrameEntry ::=  SEQUENCE {\r\n        adIadFrameSignaling       INTEGER,\r\n        adIadFrameT391            Integer32,\r\n        adIadFrameBECNtimeout     Integer32\r\n    }\r\n\r\nadIadFrameSignaling OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               annexD(1),   -- ANSI T1 617.D\r\n               annexA(2),   -- ITU Q933A\r\n               conLMI(3),\r\n               none(4)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     obsolete\r\n    DESCRIPTION\r\n        \"Signaling type for the Frame Relay management\r\n        interface.\"\r\n    ::= { adIadFrameEntry 1 }\r\n\r\nadIadFrameT391 OBJECT-TYPE\r\n    SYNTAX     Integer32 (5..30)\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Sets the polling interval in seconds for the Frame\r\n        Relay management interface.\"\r\n    ::= { adIadFrameEntry 2 }\r\n\r\nadIadFrameBECNtimeout    OBJECT-TYPE\r\n    SYNTAX     Integer32 (50..5000)\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Sets the BECN timeout in milli-seconds for the Frame\r\n        Relay management interface.\"\r\n    ::= { adIadFrameEntry 3 }\r\n\r\n--\r\n--  Frame Relay Circuit Configuration\r\n--\r\n\r\nadIadFrDlciTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadFrDlciEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table extending the interface table for Frame Relay\r\n        interfaces for each PVC (identified by DLCI).\"\r\n    ::= { adIadFrameProv 2 }\r\n\r\nadIadFrDlciEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadFrDlciEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Frame Relay Circuit Provisioning\r\n        Table.\"\r\n    INDEX    { frDlcmiIfIndex, frCircuitDlci }\r\n    ::=  { adIadFrDlciTable 1 }\r\n\r\nAdIadFrDlciEntry ::=  SEQUENCE {\r\n        adIadFrDlciRtrMode       INTEGER\r\n    }\r\n\r\nadIadFrDlciRtrMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               routed(1),\r\n               bridged(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n    \"The router\'s mode for the circuit, Routed or Bridged.\"\r\n    ::= { adIadFrDlciEntry 1 }\r\n\r\n--\r\n-- Bridge Configuration\r\n--\r\n\r\nadIadBridgeTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadBridgeEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of configurable Bridge\r\n        entries.\"\r\n    ::= { adIadBridgeProv 1 }\r\n\r\nadIadBridgeEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadBridgeEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Bridge Provisioning Table.\"\r\n    INDEX    { ifIndex }\r\n    ::=  { adIadBridgeTable 1 }\r\n\r\nAdIadBridgeEntry ::=  SEQUENCE {\r\n        adIadBridgeActive        INTEGER\r\n    }\r\n\r\nadIadBridgeActive OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               no(1),\r\n               yes(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Enable/Disable Bridging for this interface.\"\r\n    ::= { adIadBridgeEntry 1 }\r\n\r\nadIadBridgeAddrTblAging OBJECT-TYPE\r\n    SYNTAX     Integer32 ( 0..65535 )\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Set Bridging\'s Address Table Aging value\"\r\n    ::= { adIadBridgeProv 2 }\r\n\r\n--\r\n-- ATM Configuration\r\n--\r\n\r\n--\r\n-- ATM Port Configuration\r\n--\r\n\r\nadIadAtmTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadAtmEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of configurable ATM\r\n        entries.\"\r\n    ::= { adIadAtmProv 1 }\r\n\r\nadIadAtmEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadAtmEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the ATM Provisioning Table.\"\r\n    INDEX    { ifIndex }\r\n    ::=  { adIadAtmTable 1 }\r\n\r\nAdIadAtmEntry ::=  SEQUENCE {\r\n        adIadAtmIdleCells        INTEGER,\r\n        adIadAtmDataScrambling   INTEGER,\r\n        adIadAtmHecCoset         INTEGER\r\n    }\r\n\r\nadIadAtmIdleCells OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               atmForumUnassigned(1),\r\n               ituIdle(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object configures the idle cell format for this\r\n        ATM port.\"\r\n    ::= { adIadAtmEntry 1 }\r\n\r\nadIadAtmDataScrambling OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               disabled(1),\r\n               enabled(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object enables/disables the data scrambling for\r\n        this ATM port.\"\r\n    ::= { adIadAtmEntry 2 }\r\n\r\nadIadAtmHecCoset OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               enabled(1),\r\n               disabled(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object enables/disables HEC coset for this ATM\r\n        port.\"\r\n    ::= { adIadAtmEntry 3 }\r\n\r\n--\r\n-- ATM PVC Configuration\r\n--\r\n\r\nadIadAtmPvcTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadAtmPvcEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of configurable ATM PVC\r\n        entries.\"\r\n    ::= { adIadAtmProv 2 }\r\n\r\nadIadAtmPvcEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadAtmPvcEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the ATM PVC Table.\"\r\n    INDEX    { ifIndex,\r\n               adIadAtmPvcVpi,\r\n               adIadAtmPvcVci }\r\n    ::=  { adIadAtmPvcTable 1 }\r\n\r\nAdIadAtmPvcEntry ::=  SEQUENCE {\r\n        adIadAtmPvcVpi              Integer32,\r\n        adIadAtmPvcVci              Integer32,\r\n        adIadAtmPvcActive           INTEGER,\r\n        adIadAtmPvcProtocol         INTEGER,\r\n        adIadAtmPvcMode             INTEGER,\r\n        adIadAtmPvcQos              INTEGER,\r\n        adIadAtmPvcPCR              Integer32\r\n    }\r\n\r\nadIadAtmPvcVpi OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This Virtual Path Identifer for this PVC.\"\r\n    ::= { adIadAtmPvcEntry 1 }\r\n\r\nadIadAtmPvcVci OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This Virtual Channel Identifer for this PVC.\"\r\n    ::= { adIadAtmPvcEntry 2 }\r\n\r\nadIadAtmPvcActive OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               no(1),\r\n               yes(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object specifies whether the PVC is active or\r\n        not.\"\r\n    ::= { adIadAtmPvcEntry 3 }\r\n\r\nadIadAtmPvcProtocol OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               rfc1483Ip(1),\r\n               pppOverAtm(2),\r\n               frf5Frf8(3),\r\n               voice(4)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object specifies upper protocol for this ATM\r\n        PVC.\r\n\r\n        frf5Frf8(3) is chosen if this PVC is to be used for\r\n        Internetworking Functionality (IWF). The user should\r\n        choose FRF.5 or FRF.8 via adIadIwfMode object of\r\n        adIadIwf.mi2.\"\r\n    ::= { adIadAtmPvcEntry 4 }\r\n\r\nadIadAtmPvcMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               undefined(1),\r\n               routeIp(2),\r\n               bridgeAll(3),\r\n               routeIpBridgeOther(4)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object specifies the mode for this PVC when\r\n         adIadAtmPvcProtocol is either PPP or IP. An attempt\r\n         to SET this object when adIadAtmPvcProtocol is not\r\n         IP or PPP will return an error. An attempt to GET\r\n         this object when adIadAtmPvcProtocol is not IP or\r\n         PPP will return undefined(1).\"\r\n    ::= { adIadAtmPvcEntry 5 }\r\n\r\nadIadAtmPvcQos OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               ubr(1),\r\n               rtVbr(2),\r\n               nrtVbr(3)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object specifies the Quality of Service for this\r\n         PVC. rtVbr(2) is automatically selected when\r\n         adIadAtmPvcProtocol is voice(5) and cannot be changed.\"\r\n    ::= { adIadAtmPvcEntry 6 }\r\n\r\nadIadAtmPvcPCR OBJECT-TYPE\r\n    SYNTAX     Integer32(1..3623)\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object specifies the Peak Cell Rate for this\r\n         PVC. The maximum PCR is 3623. This object is not\r\n         applicable when adIadAtmPvcProtocol is set to\r\n         voice(5).\"\r\n    ::= { adIadAtmPvcEntry 7 }\r\n\r\n--\r\n-- ATM Voice PVC Configuration Table\r\n--\r\n\r\nadIadAtmVoicePvcTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadAtmVoicePvcEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of configurable ATM Voice\r\n         PVC entries.\"\r\n    ::= { adIadAtmProv 4 }\r\n\r\nadIadAtmVoicePvcEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadAtmVoicePvcEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the ATM PVC Table.\"\r\n    INDEX    { ifIndex,\r\n               adIadAtmVoicePvcVpi,\r\n               adIadAtmVoicePvcVci }\r\n    ::=  { adIadAtmVoicePvcTable 1 }\r\n\r\nAdIadAtmVoicePvcEntry ::=  SEQUENCE {\r\n        adIadAtmVoicePvcVpi                        Integer32,\r\n        adIadAtmVoicePvcVci                        Integer32,\r\n        adIadAtmVoicePvcCallControl                INTEGER,\r\n        adIadAtmVoicePvcLesProfile                 INTEGER,\r\n        adIadAtmVoicePvcLesCasGwSim                INTEGER,\r\n        adIadAtmVoicePvcTollBridgeIadIpAddr        IpAddress\r\n    }\r\n\r\nadIadAtmVoicePvcVpi OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This Virtual Path Identifer for this PVC.\"\r\n    ::= { adIadAtmVoicePvcEntry 1 }\r\n\r\nadIadAtmVoicePvcVci OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This Virtual Channel Identifer for this PVC.\"\r\n    ::= { adIadAtmVoicePvcEntry 2 }\r\n\r\nadIadAtmVoicePvcCallControl OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               jetStream(1),\r\n               copperCom(2),\r\n               tollBridge(3),\r\n               lesCas(4)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object specifies the Call Control algorithm for\r\n         this voice PVC. \"\r\n    ::= { adIadAtmVoicePvcEntry 3 }\r\n\r\nadIadAtmVoicePvcLesProfile OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               undefined(1),\r\n               ituProfileOne(2),\r\n               atmForumProfileNine(3),\r\n               atmForumProfileTen(4)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object specifies the LES-CAS profile to be used\r\n         for this voice PVC. Note that this object is valid if\r\n         adIadAtmVoicePvcCallControl is set to lesCas(4). \"\r\n    ::= { adIadAtmVoicePvcEntry 4 }\r\n\r\nadIadAtmVoicePvcLesCasGwSim OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               disabled(1),\r\n               enabled(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object enables/disables the LES-CAS Gateway\r\n         Sim. Note that this object is valid if\r\n         adIadAtmVoicePvcCallControl is set to lesCas(4). \"\r\n    ::= { adIadAtmVoicePvcEntry 5 }\r\n\r\nadIadAtmVoicePvcTollBridgeIadIpAddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object specifies the IAD IP Address to the\r\n         TollBridge Gateway. Note that this object is valid\r\n         only if adIadAtmVoicePvcCallControl is set to\r\n         tollBridge(3).\"\r\n    ::= { adIadAtmVoicePvcEntry 6 }\r\n\r\n--\r\n--  NAT Configuration\r\n--\r\n\r\nadIadNatTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadNatEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A table containing a list of interfaces which can\r\n        support NAT.\"\r\n    ::= { adIadNatProv 1 }\r\n\r\nadIadNatEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadNatEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the NAT Provisioning Table.\"\r\n    INDEX    { ifIndex }\r\n    ::=  { adIadNatTable 1 }\r\n\r\nAdIadNatEntry ::=  SEQUENCE {\r\n        adIadNatState        INTEGER,\r\n        adIadNatAddrMode     INTEGER,\r\n        adIadNatSpecAddr     IpAddress,\r\n        adIadNatNAPTaddr     IpAddress,\r\n        adIadNatEntryCnt     Gauge32,\r\n        adIadNatEntryOvrFlw  Counter32,\r\n        adIadNatTranslateUnmappedPorts  INTEGER,\r\n        adIadNatAddrModeRev030116Z      INTEGER\r\n    }\r\n\r\nadIadNatState OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               enabled(1),\r\n               disabled(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Enable/Disable NAT for the interface.\"\r\n    ::= { adIadNatEntry 1 }\r\n\r\n\r\nadIadNatAddrMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               interfaceIP(1),\r\n               specified(2),\r\n               dhcpClient(3)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     obsolete\r\n    DESCRIPTION\r\n        \"Select the IP address to be used for the public\r\n        address.\r\n\r\n        \'interfaceIP\': uses IP address assigned to the\r\n        utilized interface\r\n        \'specified\':   uses IP address specified in\r\n        adIadNatSpecAddr\r\n        \'dhcpClient\':  uses IP address received from a DHCP\r\n        server\"\r\n    ::= { adIadNatEntry 2 }\r\n\r\nadIadNatSpecAddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Specified NAT Address if adIadNatAddrMode is set to\r\n        specified(2), otherwise, should be 0.0.0.0\"\r\n    ::= { adIadNatEntry 3 }\r\n\r\nadIadNatNAPTaddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The public address being used for NAT, depends on the\r\n        selected NAT Address Mode.\"\r\n    ::= { adIadNatEntry 4 }\r\n\r\nadIadNatEntryCnt OBJECT-TYPE\r\n    SYNTAX     Gauge32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Number of entries in the NAT View Table\"\r\n    ::= { adIadNatEntry 5 }\r\n\r\nadIadNatEntryOvrFlw OBJECT-TYPE\r\n    SYNTAX     Counter32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Number of entries dropped from NAT due to low memory.\"\r\n    ::= { adIadNatEntry 6 }\r\n\r\nadIadNatTranslateUnmappedPorts OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               no(1),\r\n               yes(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Translate the body of packets with unmapped ports.\"\r\n    ::= { adIadNatEntry 7 }\r\n\r\nadIadNatAddrModeRev030116Z OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               interfaceIP(1),\r\n               specified(2)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Select the IP address to be used for the public\r\n        address.\r\n\r\n        \'interfaceIP\': uses IP address assigned to the\r\n        utilized interface\r\n        \'specified\':   uses IP address specified in\r\n        adIadNatSpecAddr.\"\r\n    ::= { adIadNatEntry 8 }\r\n--\r\n--\r\n--\r\n\r\nadIadNatXlateTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadNatXlateEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of NAT Translations\"\r\n    ::= { adIadNatProv 2 }\r\n\r\nadIadNatXlateEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadNatXlateEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the NAT Translation Table.\"\r\n    INDEX    { ifIndex,  adIadNatXlateIndex}\r\n    ::=  { adIadNatXlateTable 1 }\r\n\r\nAdIadNatXlateEntry ::=  SEQUENCE {\r\n        adIadNatXlateIndex          Integer32,\r\n        adIadNatXPubAddrMode        INTEGER,\r\n        adIadNatXPubSpecAddr        IpAddress,\r\n        adIadNatXProtocolMode       INTEGER,\r\n        adIadNatXProtocolNum        Integer32,\r\n        adIadNatXProtocolType       DisplayString,\r\n        adIadNatXPubPortMode        INTEGER,\r\n        adIadNatXSpecPubPortStart   Integer32,\r\n        adIadNatXSpecPubPortEnd     Integer32,\r\n        adIadNatXPrvAddrMode        INTEGER,\r\n        adIadNatXPrvSpecAddr        IpAddress,\r\n        adIadNatXPrvPortMode        INTEGER,\r\n        adIadNatXSpecPrvPort        Integer32,\r\n        adIadNatXlateBody           INTEGER,\r\n        adIadNatXlateStatus         RowStatus\r\n    }\r\n\r\nadIadNatXlateIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Index of this translation Entry\"\r\n    ::= { adIadNatXlateEntry 1 }\r\n\r\nadIadNatXPubAddrMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               napt(1),    -- the Interfaces Public Address\r\n               specified(2)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Public address mode. The public IP address used for\r\n        this translation entry; can be the NAPT IP address\r\n        assigned to the link or can be specified. Specifiying\r\n        an address allows one to direct packets with certain\r\n        protocols to different servers\"\r\n    ::= { adIadNatXlateEntry 2 }\r\n\r\nadIadNatXPubSpecAddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Specified Public IP address. This IP address is used\r\n        to translate from the private address(es).\"\r\n    ::= { adIadNatXlateEntry 3 }\r\n\r\nadIadNatXProtocolMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               tcp(1),\r\n               udp(2),\r\n               icmp(3),\r\n               tcpudp(4),\r\n               any(5),  -- any udp, tcp and icmp\r\n               all(6),\r\n               specified(7),\r\n               none(8)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Protocol mode. This is the upper layer protocol that\r\n        is to be monitored for translation.\r\n\r\n        For TCP and UDP, a port number must also be specified.\r\n\r\n        \'Any\':       translates all TCP, UDP and ICMP packets.\r\n\r\n        \'All\':       translates all packets regardless of the\r\n                     layer 4 protocol. In \'ALL\' mode, it is\r\n                     recommended that a one-to-one mapping be\r\n                     used for public addresses, since unknown\r\n                     protocols cannot be multiplexed onto a\r\n                     single public IP address.\r\n\r\n        \'Specified\': translates all packets that match the\r\n                     layer 4 protocol specified in\r\n                     adIadNatXProtocolNum.  As in \'ALL\' mode,\r\n                     it is recommended that a one-to-one\r\n                     mapping be used for public addresses.\"\r\n    ::= { adIadNatXlateEntry 4 }\r\n\r\nadIadNatXProtocolNum OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Specified Protocol Number. This is the protocol number\r\n        associated with this translation table entry.  Any\r\n        packets received with this protocol from the given\r\n        private IP address will be translated to the public IP\r\n        address and vice versa. It is recommended that these\r\n        be one-to-one translations, since most protocols do not\r\n        have ports that can be used to demultiplex inbound\r\n        packets to different private side hosts.\r\n        Some common protocol numbers are:\r\n           GRE      - 47\r\n           SIPP-ESP - 50\r\n        Refer to RFC 1700 for a complete list of protocol\r\n        numbers.\"\r\n    ::= { adIadNatXlateEntry 5 }\r\n\r\nadIadNatXProtocolType OBJECT-TYPE\r\n    SYNTAX     DisplayString (SIZE(1..16))\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"String reflecting the protocol number specified.\"\r\n    ::= { adIadNatXlateEntry 6 }\r\n\r\nadIadNatXPubPortMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               anyPort(1),\r\n               specified(2)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Public address mode. The public destination port\r\n        associated with this entry can be specified to add\r\n        more control over certain types of traffic.  Leave as\r\n        \'AnyPort\' to cover all port types.\"\r\n    ::= { adIadNatXlateEntry 7 }\r\n\r\nadIadNatXSpecPubPortStart OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Specified Port/Protocol. This is the starting port\r\n        number associated with the protocol on this\r\n        translation table entry. All packets received with\r\n        this port/protocol from the given private IP address\r\n        will be translated to the public IP address and vice\r\n        versa. It is recommended that these be one-to-one\r\n        translations, since most protocols do not have ports\r\n        that can be used to demultiplex inbound packets to\r\n        different private side hosts.\r\n        Some common port numbers are:\r\n           Protocol TCP:\r\n           HTTP - 80\r\n           FTP  - 21\r\n        Refer to RFC 1700 for a complete list of port numbers.\"\r\n    ::= { adIadNatXlateEntry 8 }\r\n\r\nadIadNatXSpecPubPortEnd OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Specified Port/Protocol. This is the ending port number\r\n        associated with the protocol on this translation table\r\n        entry. All packets received with this port/protocol\r\n        from the given private IP address will be translated\r\n        to the public IP address and vice versa.  It is\r\n        recommended that these be one-to-one translations,\r\n        since most protocols do not have ports that can be\r\n        used to demultiplex inbound packets to different\r\n        private side hosts.\r\n        Some common port numbers are:\r\n           Protocol TCP:\r\n           HTTP - 80\r\n           FTP  - 21\r\n        Refer to RFC 1700 for a complete list of port numbers.\"\r\n    ::= { adIadNatXlateEntry 9 }\r\n\r\nadIadNatXPrvAddrMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               anyInternal(1),\r\n               specified(2)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Private address mode.  The private IP address can be\r\n        specfied to steer certain protocols and ports to\r\n        specific servers in the private network.  Likewise,\r\n        internal hosts can be steered to certain servers on\r\n        the public network.\r\n        A new request from the public network matching this\r\n        entry\'s public parameters will be dropped if this mode\r\n        is set to \'AnyInternal\'.\"\r\n    ::= { adIadNatXlateEntry 10 }\r\n\r\nadIadNatXPrvSpecAddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Specified Private address. This IP address is used to\r\n        translate from the public address for unsolicited\r\n        requests from the public address space.  Also, used to\r\n        specify how a private address is translated to the\r\n        public network.\"\r\n    ::= { adIadNatXlateEntry 11 }\r\n\r\nadIadNatXPrvPortMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               any(1),\r\n               specified(2)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Protocol mode. The private destination port associated\r\n        with this entry can be specified to add more control\r\n        over certain type of traffic.  Leave as \'AnyPort\' to\r\n        cover all port types.\"\r\n    ::= { adIadNatXlateEntry 12 }\r\n\r\nadIadNatXSpecPrvPort OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Specified Port. This is the port number that replaces\r\n        the public port number during translation of inbound\r\n        packets. Outbound packets from the private address\r\n        space that match this protocol are sent to the\r\n        specified public address and port, if any\"\r\n    ::= { adIadNatXlateEntry 13 }\r\n\r\nadIadNatXlateBody       OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               enabled(1),\r\n               disabled(2)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Translate message body.  By default, the application\r\n        payload in the packet is scanned for occurances of the\r\n        private/public IP address in binary or ASCII form. Set\r\n        this to \'No\' for applications where this will cause\r\n        problems.\"\r\n    ::= { adIadNatXlateEntry 14 }\r\n\r\nadIadNatXlateStatus OBJECT-TYPE\r\n    SYNTAX     RowStatus\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The status of this conceptual row.\r\n\r\n        Until instances of all corresponding columns are\r\n        appropriately configured, the value of the corresponding\r\n        instance of the adIadNatXlateStatus is \'notReady\'.\"\r\n    ::= { adIadNatXlateEntry 15 }\r\n\r\n--\r\n--  Filter Definition\r\n--\r\nadIadFilteringTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadFilteringEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing the general filtering rules for an\r\n        interface. \"\r\n    ::= { adIadFilterProv 1 }\r\n\r\nadIadFilteringEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadFilteringEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry for the general filtering rules for an\r\n        interface.\"\r\n        INDEX   { ifIndex }\r\n    ::=  { adIadFilteringTable 1 }\r\n\r\nAdIadFilteringEntry ::=  SEQUENCE {\r\n        adIadFilteringIncoming    INTEGER,\r\n        adIadFilteringOutgoing    INTEGER\r\n    }\r\n\r\nadIadFilteringIncoming OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               disabled(1),\r\n               blockAll(2),\r\n               forwardAll(3)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Inbound filter mode for this interface.\"\r\n    ::= { adIadFilteringEntry 1 }\r\n\r\nadIadFilteringOutgoing OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               disabled(1),\r\n               blockAll(2),\r\n               forwardAll(3)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Outbound filter mode for this interface.\"\r\n    ::= { adIadFilteringEntry 2 }\r\n\r\n--\r\n--  Inbound Traffic Filters\r\n--\r\n\r\nadIadInFilterTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadInFilterEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of inbound Filter rules.\"\r\n    ::= { adIadFilterProv 2 }\r\n\r\nadIadInFilterEntry  OBJECT-TYPE\r\n    SYNTAX      AdIadInFilterEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Inbound Filter Rules Table.\"\r\n        INDEX   { ifIndex, adIadInFilterIndex }\r\n    ::=  { adIadInFilterTable 1 }\r\n\r\nAdIadInFilterEntry ::=  SEQUENCE {\r\n        adIadInFilterIndex       Integer32,\r\n        adIadInFilterState       INTEGER,\r\n        adIadInFilterRuleType    INTEGER,\r\n        adIadInFilterRuleIndex   Integer32,\r\n        adIadInFilterNextOp      INTEGER,\r\n        adIadInFilterStatus      RowStatus\r\n    }\r\n\r\nadIadInFilterIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Sequential index of inbound filter rule\r\n        specifications.\"\r\n    ::= { adIadInFilterEntry 1 }\r\n\r\nadIadInFilterState OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               active(1),\r\n               inActive(2)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"(De-)Activate this rule in the overall inbound\r\n        filter.\"\r\n    ::= { adIadInFilterEntry 2 }\r\n\r\nadIadInFilterRuleType OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               mac(1),\r\n               pattern(2),\r\n               ip(3)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Select the type of filter, MAC address, Character\r\n        pattern or IP address/port\"\r\n    ::= { adIadInFilterEntry 3 }\r\n\r\nadIadInFilterRuleIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The index of the desired row in the respective MAC,\r\n        Pattern or IP Rule table\"\r\n    ::= { adIadInFilterEntry 4 }\r\n\r\nadIadInFilterNextOp OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               end(1),\r\n               and(2),\r\n               or(3)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Logical operator to use with the following rule. Note\r\n        that if \'end\' is selected, any other trailing rules\r\n        will not be applied.\"\r\n    ::= { adIadInFilterEntry 5 }\r\n\r\nadIadInFilterStatus OBJECT-TYPE\r\n    SYNTAX     RowStatus\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The status of this conceptual row.\r\n\r\n        Until instances of all corresponding columns are\r\n        appropriately configured, the value of the corresponding\r\n        instance of the adIadInFilterStatus is \'notReady\'.\"\r\n    ::= { adIadInFilterEntry  6 }\r\n\r\n--\r\n--  Outbound Traffic Filters\r\n--\r\n\r\nadIadOutFilterTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadOutFilterEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of outbound Filter rules.\"\r\n    ::= { adIadFilterProv 3 }\r\n\r\nadIadOutFilterEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadOutFilterEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Outbound Filter Rules Table.\"\r\n        INDEX   { ifIndex, adIadOutFilterIndex }\r\n    ::=  { adIadOutFilterTable 1 }\r\n\r\nAdIadOutFilterEntry ::=  SEQUENCE {\r\n        adIadOutFilterIndex       Integer32,\r\n        adIadOutFilterState       INTEGER,\r\n        adIadOutFilterRuleType    INTEGER,\r\n        adIadOutFilterRuleIndex   Integer32,\r\n        adIadOutFilterNextOp      INTEGER,\r\n        adIadOutFilterStatus      RowStatus\r\n    }\r\n\r\nadIadOutFilterIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Sequential index of outbound filter rule\r\n        specifications.\"\r\n    ::= { adIadOutFilterEntry 1 }\r\n\r\nadIadOutFilterState OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               active(1),\r\n               inActive(2)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"(De-)Activate this rule in the overall outbound\r\n        filter.\"\r\n    ::= { adIadOutFilterEntry 2 }\r\n\r\nadIadOutFilterRuleType OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               mac(1),\r\n               pattern(2),\r\n               ip(3)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Select the type of filter, MAC address, Character\r\n        pattern or IP address/port\"\r\n    ::= { adIadOutFilterEntry 3 }\r\n\r\nadIadOutFilterRuleIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The index of the desired row in the respective MAC,\r\n        Pattern or IP Rule table\"\r\n    ::= { adIadOutFilterEntry 4 }\r\n\r\nadIadOutFilterNextOp OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               end(1),\r\n               and(2),\r\n               or(3)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Logical operator to use with the following rule. Note\r\n        that if \'end\' is selected, any other trailing rules\r\n        will not be applied.\"\r\n    ::= { adIadOutFilterEntry 5 }\r\n\r\nadIadOutFilterStatus OBJECT-TYPE\r\n    SYNTAX     RowStatus\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The status of this conceptual row.\r\n\r\n        Until instances of all corresponding columns are\r\n        appropriately configured, the value of the corresponding\r\n        instance of the adIadOutFilterStatus is \'notReady\'.\"\r\n    ::= { adIadOutFilterEntry  6 }\r\n\r\n--\r\n-- MAC Address Rules\r\n--\r\n\r\nadIadMacRuleTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadMacRuleEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of MAC Address Rules to be\r\n        used in Filter specification.\"\r\n    ::= { adIadFilterProv 4 }\r\n\r\nadIadMacRuleEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadMacRuleEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the MAC Address Rules Table.\"\r\n        INDEX   {  adIadMacRuleIndex}\r\n    ::=  { adIadMacRuleTable 1 }\r\n\r\nAdIadMacRuleEntry ::=  SEQUENCE {\r\n    adIadMacRuleIndex      Integer32,\r\n    adIadMacRuleName       DisplayString,\r\n    adIadMacRuleSrcAddr    MacAddress,\r\n    adIadMacRuleSrcMask    MacAddress,\r\n    adIadMacRuleDestAddr   MacAddress,\r\n    adIadMacRuleDestMask   MacAddress,\r\n    adIadMacRuleType       OCTET STRING,\r\n    adIadMacRuleTypeMask   OCTET STRING,\r\n    adIadMacRuleStatus     RowStatus\r\n    }\r\n\r\nadIadMacRuleIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"MAC Rule definition index.\"\r\n    ::= { adIadMacRuleEntry 1 }\r\n\r\nadIadMacRuleName OBJECT-TYPE\r\n    SYNTAX     DisplayString (SIZE(0..32))\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"MAC Rule name.\"\r\n    ::= { adIadMacRuleEntry 2 }\r\n\r\nadIadMacRuleSrcAddr OBJECT-TYPE\r\n    SYNTAX     MacAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"MAC Rule Source Address.\"\r\n    ::= { adIadMacRuleEntry 3 }\r\n\r\nadIadMacRuleSrcMask OBJECT-TYPE\r\n    SYNTAX     MacAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"MAC Rule Source Address Mask. Non-zero bits are must\r\n        -match bits.\"\r\n    ::= { adIadMacRuleEntry 4 }\r\n\r\nadIadMacRuleDestAddr OBJECT-TYPE\r\n    SYNTAX     MacAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"MAC Rule Destination Address.\"\r\n    ::= { adIadMacRuleEntry 5 }\r\n\r\nadIadMacRuleDestMask OBJECT-TYPE\r\n    SYNTAX     MacAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"MAC Rule Destination Address Mask. Non-zero bits are\r\n        must-match bits.\"\r\n    ::= { adIadMacRuleEntry 6 }\r\n\r\nadIadMacRuleType OBJECT-TYPE\r\n    SYNTAX     OCTET STRING(SIZE (2))\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"MAC Rule Type.\"\r\n    ::= { adIadMacRuleEntry 7 }\r\n\r\nadIadMacRuleTypeMask OBJECT-TYPE\r\n    SYNTAX     OCTET STRING(SIZE (2))\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"MAC Rule Type Mask.\"\r\n    ::= { adIadMacRuleEntry 8 }\r\n\r\nadIadMacRuleStatus OBJECT-TYPE\r\n    SYNTAX     RowStatus\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The status of this conceptual row.\r\n\r\n        Until instances of all corresponding columns are\r\n        appropriately configured, the value of the corresponding\r\n        instance of the adIadMacRuleStatus is \'notReady\'.\"\r\n    ::= { adIadMacRuleEntry 9 }\r\n\r\n--\r\n-- Text Pattern Rules\r\n--\r\n\r\nadIadPatternRuleTable  OBJECT-TYPE\r\n    SYNTAX      SEQUENCE OF AdIadPatternRuleEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of Text Pattern Rules to be\r\n        used in Filter specification.\"\r\n    ::= { adIadFilterProv 5 }\r\n\r\nadIadPatternRuleEntry  OBJECT-TYPE\r\n    SYNTAX      AdIadPatternRuleEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Text Pattern Rule Table.\"\r\n        INDEX   {  adIadPatternRuleIndex}\r\n    ::=  { adIadPatternRuleTable 1 }\r\n\r\nAdIadPatternRuleEntry ::=  SEQUENCE {\r\n        adIadPatternRuleIndex      Integer32,\r\n        adIadPatternRuleName       DisplayString,\r\n        adIadPatternRuleOffset     Unsigned32,\r\n        adIadPatternRulePattern    OCTET STRING,\r\n        adIadPatternRuleMask       OCTET STRING,\r\n        adIadPatternRuleStatus     RowStatus\r\n    }\r\n\r\nadIadPatternRuleIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Pattern Rule definition index.\"\r\n    ::= { adIadPatternRuleEntry 1 }\r\n\r\nadIadPatternRuleName OBJECT-TYPE\r\n    SYNTAX     DisplayString (SIZE(0..32))\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Character Pattern Rule name.\"\r\n    ::= { adIadPatternRuleEntry 2 }\r\n\r\nadIadPatternRuleOffset OBJECT-TYPE\r\n    SYNTAX     Unsigned32\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Character Pattern Rule byte offset into message.\"\r\n    ::= { adIadPatternRuleEntry 3 }\r\n\r\nadIadPatternRulePattern OBJECT-TYPE\r\n    SYNTAX     OCTET STRING (SIZE(8))\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Character Pattern Rule Pattern. Octets to match\"\r\n    ::= { adIadPatternRuleEntry 4 }\r\n\r\nadIadPatternRuleMask OBJECT-TYPE\r\n    SYNTAX     OCTET STRING (SIZE(8))\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Character Pattern Rule Pattern mask. Non-zero bits\r\n        are must-match bits.\"\r\n    ::= { adIadPatternRuleEntry 5 }\r\n\r\nadIadPatternRuleStatus OBJECT-TYPE\r\n    SYNTAX     RowStatus\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The status of this conceptual row.\r\n\r\n        Until instances of all corresponding columns are\r\n        appropriately configured, the value of the corresponding\r\n        instance of the adIadPatternRuleStatus is \'notReady\'.\"\r\n    ::= { adIadPatternRuleEntry  6 }\r\n\r\n--\r\n--  IP Rules\r\n--\r\n\r\nadIadIpRuleTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadIpRuleEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of IP address Rules to be\r\n        used in Filter specification.\"\r\n    ::= { adIadFilterProv 6 }\r\n\r\nadIadIpRuleEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadIpRuleEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the IP address Rules Table.\"\r\n    INDEX    {  adIadIpRuleIndex}\r\n    ::=  { adIadIpRuleTable 1 }\r\n\r\nAdIadIpRuleEntry ::=  SEQUENCE {\r\n        adIadIpRuleIndex          Integer32,\r\n        adIadIpRuleName           DisplayString,\r\n        adIadIpRuleSrcAddr        IpAddress,\r\n        adIadIpRuleSrcMask        IpAddress,\r\n        adIadIpRuleDestAddr       IpAddress,\r\n        adIadIpRuleDestMask       IpAddress,\r\n        adIadIpRuleSrcPort        Integer32,\r\n        adIadIpRuleSrcPortComp    INTEGER,\r\n        adIadIpRuleDestPort       Integer32,\r\n        adIadIpRuleDestPortComp   INTEGER,\r\n        adIadIpRuleProtoPort      Integer32,\r\n        adIadIpRuleProtoPortComp  INTEGER,\r\n        adIadIpRuleTCPestablish   INTEGER,\r\n        adIadIpRuleStatus         RowStatus\r\n    }\r\n\r\nadIadIpRuleIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule definition index.\"\r\n    ::= { adIadIpRuleEntry 1 }\r\n\r\nadIadIpRuleName OBJECT-TYPE\r\n    SYNTAX     DisplayString (SIZE(0..32))\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule name.\"\r\n    ::= { adIadIpRuleEntry 2 }\r\n\r\nadIadIpRuleSrcAddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule Source Address.\"\r\n    ::= { adIadIpRuleEntry 3 }\r\n\r\nadIadIpRuleSrcMask OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule Source mask. Non-zero bits are must\r\n        -match bits.\"\r\n    ::= { adIadIpRuleEntry 4 }\r\n\r\nadIadIpRuleDestAddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule Destination Address\"\r\n    ::= { adIadIpRuleEntry 5 }\r\n\r\nadIadIpRuleDestMask OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule Destination mask. Non-zero bits are\r\n        must-match bits.\"\r\n    ::= { adIadIpRuleEntry 6 }\r\n\r\nadIadIpRuleSrcPort OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule Source Port.\"\r\n    ::= { adIadIpRuleEntry 7 }\r\n\r\nadIadIpRuleSrcPortComp OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               none(1),\r\n               equal(2),\r\n               notEqual(3),\r\n               greaterThan(4),\r\n               lessThan(5)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule Source Port Comparator.\"\r\n    ::= { adIadIpRuleEntry 8 }\r\n\r\nadIadIpRuleDestPort OBJECT-TYPE\r\n    SYNTAX      Integer32\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule Source Port.\"\r\n    ::= { adIadIpRuleEntry 9 }\r\n\r\nadIadIpRuleDestPortComp OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               none(1),\r\n               equal(2),\r\n               notEqual(3),\r\n               greaterThan(4),\r\n               lessThan(5)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule Source Port Comparator.\"\r\n    ::= { adIadIpRuleEntry 10 }\r\n\r\nadIadIpRuleProtoPort OBJECT-TYPE\r\n    SYNTAX      Integer32\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule Protocol Port.\"\r\n    ::= { adIadIpRuleEntry 11 }\r\n\r\nadIadIpRuleProtoPortComp OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               none(1),\r\n               equal(2),\r\n               notEqual(3),\r\n               greaterThan(4),\r\n               lessThan(5)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IP address Rule Protocol Port Comparator.\"\r\n    ::= { adIadIpRuleEntry 12 }\r\n\r\nadIadIpRuleTCPestablish OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               ignore(1),\r\n               yes(2),\r\n               no(3)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Monitor for TCP establishing.\"\r\n    ::= { adIadIpRuleEntry 13 }\r\n\r\nadIadIpRuleStatus OBJECT-TYPE\r\n    SYNTAX     RowStatus\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The status of this conceptual row.\r\n\r\n        Until instances of all corresponding columns are\r\n        appropriately configured, the value of the corresponding\r\n        instance of the adIadIpRuleStatus is \'notReady\'.\"\r\n    ::= { adIadIpRuleEntry  14 }\r\n\r\n--\r\n-- PPP Provision\r\n--\r\n\r\nadIadPppProvTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadPppProvEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"A Table containing a list of PPP interfaces.\"\r\n    ::= { adIadPppProv 1 }\r\n\r\nadIadPppProvEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadPppProvEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the PPP Table.\"\r\n    INDEX    { ifIndex }\r\n    ::=  { adIadPppProvTable 1 }\r\n\r\nAdIadPppProvEntry ::=  SEQUENCE {\r\n        adIadPppAuthTxMethod      INTEGER,\r\n        adIadPppAuthTxUsrName     DisplayString,\r\n        adIadPppAuthTxPasswd      DisplayString,\r\n        adIadPppAuthRxMethod      INTEGER,\r\n        adIadPppAuthRxUsrName     DisplayString,\r\n        adIadPppAuthRxPasswd      DisplayString,\r\n        adIadPppMaxConfig         INTEGER,\r\n        adIadPppMaxTimer          INTEGER,\r\n        adIadPppMaxFail           INTEGER,\r\n        adIadPppMode              INTEGER,\r\n        adIadPppForcePeerIp       INTEGER,\r\n        adIadPppKeepAlivePeriod   INTEGER\r\n    }\r\n\r\n\r\nadIadPppAuthTxMethod OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               none(1),\r\n               papChapEap(2),  -- PAP, CHAP, or EAP\r\n               chapEap(3),     -- CHAP or EAP\r\n               eap(4),         -- EAP only\r\n               pap(5)          -- PAP only\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"PPP Tx Authentication method.\"\r\n    ::= { adIadPppProvEntry 1 }\r\n\r\nadIadPppAuthTxUsrName OBJECT-TYPE\r\n    SYNTAX      DisplayString (SIZE(1..32))\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"PPP Tx Authentication UserName. Used only if an Tx\r\n        Authentication Method is selected.\"\r\n    ::= { adIadPppProvEntry 2 }\r\n\r\nadIadPppAuthTxPasswd OBJECT-TYPE\r\n    SYNTAX      DisplayString (SIZE(1..16))\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"PPP Tx Authentication Password.  Used only if an Tx\r\n        Authentication Method is selected.\"\r\n    ::= { adIadPppProvEntry 3 }\r\n\r\nadIadPppAuthRxMethod OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               none(1),\r\n               papChapEap(2),   -- PAP, CHAP, or EAP\r\n               chapEap(3),      -- CHAP or EAP\r\n               eap(4)           -- EAP only\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"PPP Rx Authentication method.\"\r\n    ::= { adIadPppProvEntry 4 }\r\n\r\nadIadPppAuthRxUsrName OBJECT-TYPE\r\n    SYNTAX     DisplayString (SIZE(1..32))\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"PPP Rx Authentication UserName. Only necessary if an\r\n        Rx Authentication Method is selected\"\r\n    ::= { adIadPppProvEntry 5 }\r\n\r\nadIadPppAuthRxPasswd OBJECT-TYPE\r\n    SYNTAX     DisplayString (SIZE(1..16))\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"PPP Rx Authentication Password. Only necessary if an\r\n         Rx Authentication Method is selected\"\r\n    ::= { adIadPppProvEntry 6 }\r\n\r\nadIadPppMaxConfig OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               five(1),\r\n               ten(2),\r\n               fifteen(3),\r\n               twenty(4)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Maximum number of PPP connections.\"\r\n    ::= { adIadPppProvEntry 7 }\r\n\r\nadIadPppMaxTimer OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               one(1),\r\n               two(2),\r\n               three(3),\r\n               five(4),\r\n               ten(5)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"PPP Maximum Timer.\"\r\n    ::= { adIadPppProvEntry 8 }\r\n\r\nadIadPppMaxFail OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               five(1),\r\n               ten(2),\r\n               fifteen(3),\r\n               twenty(4)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"PPP Maximum Failure.\"\r\n    ::= { adIadPppProvEntry 9 }\r\n\r\nadIadPppMode OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               route(1),\r\n               bridge(2),\r\n               rtbrg(3)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Operational mode of the PPP interface;\r\n         \'route\':    operate in router mode\r\n         \'bridge\':   operate in bridge mode\r\n         \'rtbrg\':    route all IP traffic & bridge all other\"\r\n    ::= { adIadPppProvEntry 10 }\r\n\r\nadIadPppForcePeerIp OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               no(1),\r\n               yes(2)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object determines if near-end unit will force\r\n         the far-end IP address.\"\r\n    ::= { adIadPppProvEntry 11 }\r\n\r\nadIadPppKeepAlivePeriod OBJECT-TYPE\r\n    SYNTAX INTEGER {\r\n               off(1),\r\n               oneMin(2),\r\n               twoMins(3),\r\n               fiveMins(4)\r\n           }\r\n    MAX-ACCESS read-create\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"This object defines the length (in minutes) of the\r\n         PPP keep-alive.\"\r\n    ::= { adIadPppProvEntry 12 }\r\n\r\n--\r\n--   Cross Connect Table\r\n--\r\n\r\nadIadXConnectInitTable  OBJECT-TYPE\r\n    SYNTAX INTEGER  {\r\n               copyOnline(1),\r\n               d4(2),\r\n               d1d(3),\r\n               clear(4)\r\n           }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Initialize the working DS0 map with the specified\r\n         settings.\r\n         \'copyOnline\':  populate working map with a duplicate\r\n                        of the online map\r\n         \'d4\':          assign all module\'s ports in a D4\r\n                        channelbank manner.\r\n         \'d1d\':         assign all module\'s ports in an\r\n                        alternating pattern\r\n         \'clear\':       reset all mappings\"\r\n    ::= { adIadXConnectProv 1 }\r\n\r\nadIadXConnectApplyTable  OBJECT-TYPE\r\n    SYNTAX INTEGER  {\r\n                apply(1)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Transfer table to online map.\"\r\n    ::= { adIadXConnectProv 2 }\r\n\r\nadIadXConnectTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadXConnectEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The IAD Cross Connect Table.\"\r\n    ::= { adIadXConnectProv 3 }\r\n\r\nadIadXConnectEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadXConnectEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the IAD Cross Connect Table.\"\r\n    INDEX   { adIadXConnectDS0 }\r\n    ::=  { adIadXConnectTable 1 }\r\n\r\nAdIadXConnectEntry ::=  SEQUENCE {\r\n        adIadXConnectDS0      Integer32,\r\n        adIadXConnectifIndex  InterfaceIndex\r\n    }\r\n\r\nadIadXConnectDS0 OBJECT-TYPE\r\n    SYNTAX     Integer32  (1..24)\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IAD Cross Connect Table row index; each DS0\"\r\n    ::= { adIadXConnectEntry 1 }\r\n\r\nadIadXConnectifIndex OBJECT-TYPE\r\n    SYNTAX     InterfaceIndex\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Interface Index to map to DS0 or 0 for none\"\r\n    ::= { adIadXConnectEntry 2 }\r\n\r\nadIadXConnectAvailTable  OBJECT-TYPE\r\n    SYNTAX      SEQUENCE OF AdIadXConnectAvailEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The IAD Cross Connect Availability Table.  A list of\r\n        interfaces available for mapping to a DSO in the Cross\r\n        Connect Table\"\r\n    ::= { adIadXConnectProv 4 }\r\n\r\nadIadXConnectAvailEntry  OBJECT-TYPE\r\n    SYNTAX      AdIadXConnectAvailEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the IAD Cross Connect Availability Table.\"\r\n    INDEX   { adIadXConnectAvailIndex }\r\n    ::=  { adIadXConnectAvailTable 1 }\r\n\r\nAdIadXConnectAvailEntry ::=  SEQUENCE {\r\n        adIadXConnectAvailIndex     Integer32,\r\n        adIadXConnectAvailifIndex   InterfaceIndex\r\n    }\r\n\r\nadIadXConnectAvailIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"IAD Cross Connect Availability Table row index.\"\r\n    ::= { adIadXConnectAvailEntry 1 }\r\n\r\nadIadXConnectAvailifIndex OBJECT-TYPE\r\n    SYNTAX     InterfaceIndex\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Interface Index not currently mapped to a DS0\"\r\n    ::= { adIadXConnectAvailEntry 2 }\r\n\r\n--\r\n--  Router Statistics\r\n--\r\n\r\nadIadIpRouteTableTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadIpRouteTableEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The current IP route table for this IAD.\"\r\n    ::= { adIadBaseRtStat 1 }\r\n\r\nadIadIpRouteTableEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadIpRouteTableEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the IP route table.\"\r\n    INDEX   {adIadIpRouteTableIpAddr}\r\n    ::=  { adIadIpRouteTableTable 1 }\r\n\r\nAdIadIpRouteTableEntry ::=  SEQUENCE {\r\n        adIadIpRouteTableIpAddr     IpAddress,\r\n        adIadIpRouteTableNetMask    IpAddress,\r\n        adIadIpRouteTableGateway    IpAddress,\r\n        adIadIpRouteTableIfIndex    Integer32,\r\n        adIadIpRouteTableUse        Integer32,\r\n        adIadIpRouteTableFlags      DisplayString,\r\n        adIadIpRouteTableHops       Integer32,\r\n        adIadIpRouteTableTTL        Integer32\r\n    }\r\n\r\nadIadIpRouteTableIpAddr OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The IP address of this route.\"\r\n    ::= { adIadIpRouteTableEntry 1 }\r\n\r\nadIadIpRouteTableNetMask OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The IP Netmask of this route.\"\r\n    ::= { adIadIpRouteTableEntry 2 }\r\n\r\nadIadIpRouteTableGateway OBJECT-TYPE\r\n    SYNTAX     IpAddress\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The default gateway of this route.\"\r\n    ::= { adIadIpRouteTableEntry 3 }\r\n\r\nadIadIpRouteTableIfIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The physical port associated with this route.\"\r\n    ::= { adIadIpRouteTableEntry 4 }\r\n\r\nadIadIpRouteTableUse OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The use count of this route.\"\r\n    ::= { adIadIpRouteTableEntry 5 }\r\n\r\nadIadIpRouteTableFlags OBJECT-TYPE\r\n    SYNTAX     DisplayString\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The flags associated with this route entry:\r\n         H   - route is a host route\r\n         G   - route is a gateway route\r\n         DR  - route learned dynamically from RIP\r\n         DO  - intra-area route learned dynamically from OSPF\r\n         DOa - inter-area route learned dynamically from OSPF\r\n         DOe - external route learned dynamically from OSPF\r\n         A   - route learned from IARP\r\n         I   - route learned from an ICMP redirect\r\n         P   - route is private and is not advertised with RIP\r\n         T   - route is to a triggered port (updated only when\r\n               table changes.\"\r\n    ::= { adIadIpRouteTableEntry 6 }\r\n\r\nadIadIpRouteTableHops OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The number of hops from the IAD to the destination IP\r\n        Address.\"\r\n    ::= { adIadIpRouteTableEntry 7 }\r\n\r\nadIadIpRouteTableTTL OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The Time To Live counter for packets on this route.\"\r\n    ::= { adIadIpRouteTableEntry 8 }\r\n\r\n--\r\n-- PPP Statistics\r\n--\r\n\r\nadIadPppStatTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadPppStatEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The current PPP statistics.\"\r\n    ::= { adIadProtocolStat 1 }\r\n\r\nadIadPppStatEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadPppStatEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the PPP Statistics table.  An entry\r\n        exists for every PPP interface on the IAD.\"\r\n        INDEX   { ifIndex }\r\n    ::=  { adIadPppStatTable 1 }\r\n\r\nAdIadPppStatEntry ::=  SEQUENCE {\r\n        adIadPppStatLcpState      DisplayString,\r\n        adIadPppStatBcpState      DisplayString,\r\n        adIadPppStatIpcpState     DisplayString,\r\n        adIadPppStatUpTime        DisplayString,\r\n        adIadPppStatTxPkts        Counter32,\r\n        adIadPppStatRxPkts        Counter32,\r\n        adIadPppStatTxBytes       Counter32,\r\n        adIadPppStatRxBytes       Counter32\r\n    }\r\n\r\nadIadPppStatLcpState OBJECT-TYPE\r\n    SYNTAX     DisplayString\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The LCP state for the PPP port\"\r\n    ::= { adIadPppStatEntry 1 }\r\n\r\nadIadPppStatBcpState OBJECT-TYPE\r\n    SYNTAX     DisplayString\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The BCP state for the PPP port\"\r\n    ::= { adIadPppStatEntry 2 }\r\n\r\nadIadPppStatIpcpState OBJECT-TYPE\r\n    SYNTAX     DisplayString\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The IPCP state for the PPP port\"\r\n    ::= { adIadPppStatEntry 3 }\r\n\r\nadIadPppStatUpTime OBJECT-TYPE\r\n    SYNTAX     DisplayString\r\n    UNITS      \"hours\"\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The Up time for the PPP port (in seconds)\"\r\n    ::= { adIadPppStatEntry 4 }\r\n\r\nadIadPppStatTxPkts OBJECT-TYPE\r\n    SYNTAX     Counter32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The total number of transmitted PPP packets for the\r\n        port\"\r\n    ::= { adIadPppStatEntry 5 }\r\n\r\nadIadPppStatRxPkts OBJECT-TYPE\r\n    SYNTAX     Counter32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The total number of received PPP packets for the port\"\r\n    ::= { adIadPppStatEntry 6 }\r\n\r\nadIadPppStatTxBytes OBJECT-TYPE\r\n    SYNTAX     Counter32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The total number of transmitted data bytes for the\r\n        port\"\r\n    ::= { adIadPppStatEntry 7 }\r\n\r\nadIadPppStatRxBytes OBJECT-TYPE\r\n    SYNTAX     Counter32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The total number of received data bytes for the port\"\r\n    ::= { adIadPppStatEntry 8 }\r\n\r\n--\r\n-- Bridging Statistics\r\n--\r\n\r\nadIadBridgeStatTable  OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadBridgeStatEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The current Bridge statistics for the IAD.\"\r\n    ::= { adIadBridgeStat 1 }\r\n\r\nadIadBridgeStatEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadBridgeStatEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Bridge Statistics table.\"\r\n        INDEX   { adIadBridgeStatBridgeIndex }\r\n    ::=  { adIadBridgeStatTable 1 }\r\n\r\nAdIadBridgeStatEntry ::=   SEQUENCE {\r\n        adIadBridgeStatBridgeIndex Integer32,\r\n        adIadBridgeStatIfIndex    Integer32,\r\n        adIadBridgeStatMacAddr     MacAddress,\r\n        adIadBridgeStatTtl         Integer32\r\n    }\r\n\r\nadIadBridgeStatBridgeIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The index into the bridge connection table.\"\r\n    ::= { adIadBridgeStatEntry 1 }\r\n\r\nadIadBridgeStatIfIndex OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The ifIndex of the Bridge connection\"\r\n    ::= { adIadBridgeStatEntry 2 }\r\n\r\nadIadBridgeStatMacAddr OBJECT-TYPE\r\n    SYNTAX     MacAddress\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The MAC Address of the Bridge connection\"\r\n    ::= { adIadBridgeStatEntry 3 }\r\n\r\nadIadBridgeStatTtl OBJECT-TYPE\r\n    SYNTAX     Integer32\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The Time to Live value for the Bridge connection\"\r\n    ::= { adIadBridgeStatEntry 4 }\r\n\r\n--\r\n-- Compliance Statements\r\n--\r\n\r\nadIadRouterCompliance MODULE-COMPLIANCE\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The compliance statements for SNMPv2 entities which\r\n        implement the adIadRtr MIB.\"\r\n\r\n    MODULE\r\n    MANDATORY-GROUPS {\r\n        adIadRouterBaseGroup\r\n    }\r\n\r\n    ::= { adIadRouterCompliances 1 }\r\n\r\n-- units of conformance\r\n\r\nadIadRouterBaseGroup OBJECT-GROUP\r\n    OBJECTS {\r\n        adIadDhcpMode,\r\n        adIadDhcpRenewalTime,\r\n        adIadDomainName,\r\n        adIadPrimaryDNSaddr,\r\n        adIad2ndaryDNSaddr,\r\n        adIadPrimaryWINSaddr,\r\n        adIad2ndaryWINSaddr,\r\n        adIadUdpRelay,\r\n        adIadRtrDefaultGateway,\r\n        adIadInterfaceAddressMode,\r\n        adIadInterfaceLocalIpAddr,\r\n        adIadInterfaceNetMask,\r\n        adIadInterfaceFarEnd,\r\n        adIadEtherPrimaryIpAddr,\r\n        adIadEtherPrimaryIpNetMask,\r\n        adIadEtherPrimaryProxyARP,\r\n        adIadEther2ndaryIpIndex,\r\n        adIadEther2ndaryIpAddr,\r\n        adIadEther2ndaryNetMask,\r\n        adIadEther2ndaryIpStatus,\r\n        adIadEther2ndaryIpNatMode,\r\n        adIadRipVersion,\r\n        adIadRipMethod,\r\n        adIadRipDirection,\r\n        adIadRipSecret,\r\n        adIadStaticRtIndex,\r\n        adIadStaticRtState,\r\n        adIadStaticRtAddr,\r\n        adIadStaticRtNetMask,\r\n        adIadStaticRtGateway,\r\n        adIadStaticRtHops,\r\n        adIadStaticRtPrivate,\r\n        adIadStaticRtStatus,\r\n        adIadUdpRelayIndex,\r\n        adIadUdpRelayIpAddr,\r\n        adIadUdpRelayPortType,\r\n        adIadUdpRelayPort1,\r\n        adIadUdpRelayPort2,\r\n        adIadUdpRelayPort3,\r\n        adIadUdpRelayStatus,\r\n        adIadLayer2Protocol,\r\n        adIadFrameSignaling,\r\n        adIadFrameT391,\r\n        adIadFrameBECNtimeout,\r\n        adIadFrDlciRtrMode,\r\n        adIadBridgeActive,\r\n        adIadBridgeAddrTblAging,\r\n        adIadAtmPvcActive,\r\n        adIadAtmPvcProtocol,\r\n        adIadNatState,\r\n        adIadNatAddrModeRev030116Z,\r\n        adIadNatSpecAddr,\r\n        adIadNatNAPTaddr,\r\n        adIadNatEntryCnt,\r\n        adIadNatEntryOvrFlw,\r\n        adIadNatXlateIndex,\r\n        adIadNatXPubAddrMode,\r\n        adIadNatXPubSpecAddr,\r\n        adIadNatXProtocolMode,\r\n        adIadNatXProtocolNum,\r\n        adIadNatXProtocolType,\r\n        adIadNatXPubPortMode,\r\n        adIadNatXSpecPubPortStart,\r\n        adIadNatXSpecPubPortEnd,\r\n        adIadNatXPrvAddrMode,\r\n        adIadNatXPrvSpecAddr,\r\n        adIadNatXPrvPortMode,\r\n        adIadNatXSpecPrvPort,\r\n        adIadNatXlateBody,\r\n        adIadNatXlateStatus,\r\n        adIadMacRuleIndex,\r\n        adIadMacRuleName,\r\n        adIadMacRuleSrcAddr,\r\n        adIadMacRuleSrcMask,\r\n        adIadMacRuleDestAddr,\r\n        adIadMacRuleDestMask,\r\n        adIadMacRuleType,\r\n        adIadMacRuleTypeMask,\r\n        adIadMacRuleStatus,\r\n        adIadPatternRuleIndex,\r\n        adIadPatternRuleName,\r\n        adIadPatternRuleOffset,\r\n        adIadPatternRulePattern,\r\n        adIadPatternRuleMask,\r\n        adIadPatternRuleStatus,\r\n        adIadIpRuleIndex,\r\n        adIadIpRuleName,\r\n        adIadIpRuleSrcAddr,\r\n        adIadIpRuleSrcMask,\r\n        adIadIpRuleDestAddr,\r\n        adIadIpRuleDestMask,\r\n        adIadIpRuleSrcPort,\r\n        adIadIpRuleSrcPortComp,\r\n        adIadIpRuleDestPort,\r\n        adIadIpRuleDestPortComp,\r\n        adIadIpRuleProtoPort,\r\n        adIadIpRuleProtoPortComp,\r\n        adIadIpRuleTCPestablish,\r\n        adIadIpRuleStatus,\r\n        adIadPppAuthTxMethod,\r\n        adIadPppAuthTxUsrName,\r\n        adIadPppAuthTxPasswd,\r\n        adIadPppAuthRxMethod,\r\n        adIadPppAuthRxUsrName,\r\n        adIadPppAuthRxPasswd,\r\n        adIadPppMaxConfig,\r\n        adIadPppMaxTimer,\r\n        adIadPppMaxFail,\r\n        adIadPppMode,\r\n        adIadPppForcePeerIp,\r\n        adIadPppKeepAlivePeriod,\r\n        adIadFilteringIncoming,\r\n        adIadFilteringOutgoing,\r\n        adIadInFilterIndex,\r\n        adIadInFilterState,\r\n        adIadInFilterRuleType,\r\n        adIadInFilterRuleIndex,\r\n        adIadInFilterNextOp,\r\n        adIadInFilterStatus,\r\n        adIadOutFilterIndex,\r\n        adIadOutFilterState,\r\n        adIadOutFilterRuleType,\r\n        adIadOutFilterRuleIndex,\r\n        adIadOutFilterNextOp,\r\n        adIadOutFilterStatus,\r\n        adIadXConnectInitTable,\r\n        adIadXConnectApplyTable,\r\n        adIadXConnectDS0,\r\n        adIadXConnectifIndex,\r\n        adIadXConnectAvailIndex,\r\n        adIadXConnectAvailifIndex,\r\n        adIadIpRouteTableIpAddr,\r\n        adIadIpRouteTableNetMask,\r\n        adIadIpRouteTableGateway,\r\n        adIadIpRouteTableIfIndex,\r\n        adIadIpRouteTableUse,\r\n        adIadIpRouteTableFlags,\r\n        adIadIpRouteTableHops,\r\n        adIadIpRouteTableTTL,\r\n        adIadPppStatLcpState,\r\n        adIadPppStatBcpState,\r\n        adIadPppStatIpcpState,\r\n        adIadPppStatUpTime,\r\n        adIadPppStatTxPkts,\r\n        adIadPppStatRxPkts,\r\n        adIadPppStatTxBytes,\r\n        adIadPppStatRxBytes,\r\n        adIadBridgeStatBridgeIndex,\r\n        adIadBridgeStatIfIndex,\r\n        adIadBridgeStatMacAddr,\r\n        adIadBridgeStatTtl\r\n    }\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The IAD Router Base Group.\"\r\n\r\n    ::= { adIadRouterMIBGroups 1 }\r\n\r\nadIadRouterAtmGroup OBJECT-GROUP\r\n    OBJECTS {\r\n        adIadAtmIdleCells,\r\n        adIadAtmDataScrambling,\r\n        adIadAtmPvcActive,\r\n        adIadAtmPvcProtocol,\r\n        adIadAtmPvcMode,\r\n        adIadAtmPvcQos,\r\n        adIadAtmPvcPCR,\r\n        adIadAtmVoicePvcCallControl,\r\n        adIadAtmVoicePvcLesCasGwSim,\r\n        adIadAtmVoicePvcTollBridgeIadIpAddr,\r\n        adIadAtmHecCoset\r\n    }\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The IAD Router Group that supports configuring\r\n        and monitoring the ATM protocol.\"\r\n    ::= { adIadRouterMIBGroups 2 }\r\n\r\nEND\r\n'),(2,'ADTRAN-IADVOICE-MIB',1756979642,1756979642,1,'','ADTRAN-IADVOICE-MIB   DEFINITIONS ::= BEGIN\r\n\r\n-- TITLE:       ADTRAN adIadVoice MIB\r\n-- FILENAME:    adIadVoice.MIB\r\n-- AUTHOR:      Steve Shown\r\n-- DATE:        04/25/02\r\n\r\nIMPORTS\r\n\r\n    DisplayString\r\n        FROM SNMPv2-TC\r\n    ifIndex\r\n        FROM IF-MIB\r\n    Integer32, OBJECT-TYPE, MODULE-IDENTITY,\r\n    OBJECT-IDENTITY, NOTIFICATION-TYPE\r\n        FROM SNMPv2-SMI\r\n    MODULE-COMPLIANCE, OBJECT-GROUP,\r\n    NOTIFICATION-GROUP\r\n        FROM SNMPv2-CONF\r\n   sysName, sysLocation\r\n        FROM SNMPv2-MIB\r\n    adShared\r\n        FROM ADTRAN-MIB;\r\n\r\n\r\nadIadVoice MODULE-IDENTITY\r\n        LAST-UPDATED \"0301140000Z\"\r\n        ORGANIZATION \"ADTRAN, Inc.\"\r\n        CONTACT-INFO\r\n               \"        Technical Support Dept.\r\n                Postal: ADTRAN, Inc.\r\n                        901 Explorer Blvd.\r\n                        Huntsville, AL 35806\r\n\r\n                   Tel: +1 800 726-8663\r\n                   Fax: +1 256 963 6217\r\n                E-mail: support@adtran.com\"\r\n        DESCRIPTION\r\n            \"The MIB module for IAD Voice Module management.\"\r\n\r\n        REVISION    \"0301140000Z\"\r\n        DESCRIPTION\r\n            \"Changed syntax of TxLTP and RxLTP.\r\n             Added adIadVoiceProvSvcMode.\r\n             Obsoleted and created new entries\"\r\n\r\n        REVISION    \"0208050000Z\"\r\n        DESCRIPTION\r\n            \"Added Notification definitions.\"\r\n\r\n        REVISION    \"0205220000Z\"\r\n        DESCRIPTION\r\n            \"Initial revision of this module.\"\r\n\r\n       ::= { adShared 34 }\r\n\r\n--\r\n--  IAD Voice Module Provisioning group\r\n--\r\n\r\nadIadVoiceProv        OBJECT IDENTIFIER ::= { adIadVoice 1 }\r\nadIadVoiceTest        OBJECT IDENTIFIER ::= { adIadVoice 2 }\r\nadIadVoiceStatus      OBJECT IDENTIFIER ::= { adIadVoice 3 }\r\nadIadVoiceConformance OBJECT IDENTIFIER ::= { adIadVoice 4 }\r\n\r\nadIadVoiceCompliances OBJECT IDENTIFIER ::= { adIadVoiceConformance 1 }\r\nadIadVoiceMIBGroups   OBJECT IDENTIFIER ::= { adIadVoiceConformance 2 }\r\n\r\nadIadVoiceProvTable  OBJECT-TYPE\r\n    SYNTAX      SEQUENCE OF AdIadVoiceProvEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS      current\r\n    DESCRIPTION\r\n        \"The Voice MIB Provisioning Table.\"\r\n    ::= { adIadVoiceProv 1 }\r\n\r\nadIadVoiceProvEntry  OBJECT-TYPE\r\n    SYNTAX      AdIadVoiceProvEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS      current\r\n    DESCRIPTION\r\n        \"An entry in the Voice MIB Provisioning Table.\"\r\n    INDEX    {ifIndex }\r\n    ::=  { adIadVoiceProvTable 1 }\r\n\r\nAdIadVoiceProvEntry ::= SEQUENCE {\r\n    adIadVoiceProvMode          INTEGER,\r\n    adIadVoiceProvTXTLP         Integer32,\r\n    adIadVoiceProvRXTLP         Integer32,\r\n    adIadVoiceProvSvcMode       INTEGER,\r\n    adIadVoiceProvTXTLPString   DisplayString,\r\n    adIadVoiceProvRXTLPString   DisplayString\r\n    }\r\n\r\nadIadVoiceProvMode OBJECT-TYPE\r\n    SYNTAX     INTEGER {\r\n                   loopStart(1),\r\n                   groundStart(2),\r\n                   tro8Singleparty(3),\r\n                   tro8UniversalVG(4),\r\n                   dpo(5),\r\n                   tandem(6),\r\n                   dpt(7)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Voice card operational Mode -\r\n            1 = Loopstart\r\n            2 = Groundstart\r\n            3 = TRO8 Single Party\r\n            4 = TRO8 Universal VG\r\n            5 = DPO       (FXS only)\r\n            6 = Tandem    (FXS only)\r\n            7 = DPT       (FXO only)\"\r\n    ::= { adIadVoiceProvEntry 1 }\r\n\r\nadIadVoiceProvTXTLP OBJECT-TYPE\r\n    SYNTAX     Integer32 (0..90)\r\n    MAX-ACCESS read-write\r\n    STATUS     obsolete\r\n    DESCRIPTION\r\n        \"TRANSMIT TLP (All values are multiplied by ten;\r\n         ie: 61 = 6.1dB) 0dB to 9.0dB\"\r\n    ::= { adIadVoiceProvEntry 2 }\r\n\r\nadIadVoiceProvRXTLP OBJECT-TYPE\r\n    SYNTAX     Integer32 (0..90)\r\n    MAX-ACCESS read-write\r\n    STATUS     obsolete\r\n    DESCRIPTION\r\n        \"RECEIVE TLP (All values are multiplied by ten;\r\n         ie:  61 = 6.1dB) 0dB to 9.0dB\"\r\n    ::= { adIadVoiceProvEntry 3 }\r\n\r\nadIadVoiceProvSvcMode OBJECT-TYPE\r\n    SYNTAX     INTEGER {\r\n                   inService(1),\r\n                   outOfService(2)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Voice card service mode -\r\n            1 = In Service - available for use.\r\n            2 = Out of Service - port is now offline \"\r\n    ::= { adIadVoiceProvEntry 4 }\r\n\r\nadIadVoiceProvTXTLPString OBJECT-TYPE\r\n    SYNTAX     DisplayString (SIZE(0..4))\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"TRANSMIT TLP 0dB to 9.0dB\"\r\n    ::= { adIadVoiceProvEntry 5 }\r\n\r\nadIadVoiceProvRXTLPString OBJECT-TYPE\r\n    SYNTAX     DisplayString (SIZE(0..4))\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"RECEIVE TLP  0dB to 9.0dB\"\r\n    ::= { adIadVoiceProvEntry 6 }\r\n\r\nadIadFxsProvTable  OBJECT-TYPE\r\n    SYNTAX      SEQUENCE OF AdIadFxsProvEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS      current\r\n    DESCRIPTION\r\n        \"The FXS MIB Provisioning Table.\"\r\n    ::=  { adIadVoiceProv 2 }\r\n\r\nadIadFxsProvEntry  OBJECT-TYPE\r\n    SYNTAX      AdIadFxsProvEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS      current\r\n    DESCRIPTION\r\n        \"An entry in the FXS MIB Provisioning Table.\"\r\n    INDEX { ifIndex }\r\n    ::=  { adIadFxsProvTable 1 }\r\n\r\nAdIadFxsProvEntry ::= SEQUENCE  {\r\n    adIadFxsProvLineImpedance     INTEGER,\r\n    adIadFxsProvMsgIndicator      INTEGER,\r\n    adIadFxsProvConversionMode    INTEGER,\r\n    adIadFxsProvSupervision       INTEGER,\r\n    adIadFxsProvFwdDiscBatt       INTEGER,\r\n    adIadFxsProvDialTone          INTEGER,\r\n    adIadFxsProvTandRingBack      INTEGER,\r\n    adIadFxsProvForwardDelay      INTEGER,\r\n    adIadFxsProvDNIS              INTEGER,\r\n    adIadFxsProvDNISDelay         INTEGER,\r\n    adIadFxsProvAnswerSupervision INTEGER\r\n    }\r\n\r\nadIadFxsProvLineImpedance OBJECT-TYPE\r\n    SYNTAX     INTEGER {\r\n                   ohm600(1),\r\n                   ohm900(2),\r\n                   ohm600Plus216mF(3),\r\n                   ohm900Plus216mF(4),\r\n                   auto(5)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"2 Wire Line Impedance - 600 or 900 ohms,\r\n         600 or 900 ohms plus 2.16uF & automatic\"\r\n    ::= { adIadFxsProvEntry 1 }\r\n\r\nadIadFxsProvMsgIndicator  OBJECT-TYPE\r\n    SYNTAX     INTEGER {\r\n                   disabled(1),\r\n                   enabled(2)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Message Indicator:\r\n         1 = Disabled\r\n         2 = Enabled\"\r\n     ::= { adIadFxsProvEntry 2 }\r\n\r\nadIadFxsProvConversionMode  OBJECT-TYPE\r\n    SYNTAX     INTEGER {\r\n                   loopStart(1),\r\n                   groundStart(2)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Conversion Mode Options:\r\n         1 = Loopstart\r\n         2 = Groundstart\"\r\n     ::= { adIadFxsProvEntry 3 }\r\n\r\nadIadFxsProvSupervision  OBJECT-TYPE\r\n    SYNTAX     INTEGER {\r\n                   immediate(1),\r\n                   wink(2)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Supervision Options:\r\n         1 = Immediate Start\r\n         2 = Wink Start\"\r\n    ::= { adIadFxsProvEntry 4 }\r\n\r\nadIadFxsProvFwdDiscBatt    OBJECT-TYPE\r\n    SYNTAX     INTEGER {\r\n                   remove(1),\r\n                   reverse(2)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Tandem Battery Options:\r\n         1 = Normal Battery\r\n         2 = Reverse Battery\"\r\n    ::= {adIadFxsProvEntry 5 }\r\n\r\nadIadFxsProvDialTone OBJECT-TYPE\r\n    SYNTAX     INTEGER  {\r\n                   disabled(1),\r\n                   enabled(2)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Dial Tone Options:\r\n         1 = Disabled\r\n         2 = Enabled\"\r\n    ::= { adIadFxsProvEntry 6 }\r\n\r\nadIadFxsProvTandRingBack OBJECT-TYPE\r\n    SYNTAX     INTEGER  {\r\n                   disabled(1),\r\n                   enabled(2)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Ringback Tone Options:\r\n         1 = Disabled\r\n         2 = Enabled\"\r\n    ::= { adIadFxsProvEntry 7 }\r\n\r\nadIadFxsProvForwardDelay OBJECT-TYPE\r\n    SYNTAX     INTEGER  {\r\n                   twoFiftyMSec(1),\r\n                   fiveHundredMSec(2),\r\n                   sevenFiftyMSec(3),\r\n                   oneSec(4),\r\n                   twoSec(5)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Forward Disconnect Delay Options\r\n         1 = 250ms\r\n         2 = 500ms\r\n         3 = 750ms\r\n         4 = 1s\r\n         5 = 2s\"\r\n    ::= { adIadFxsProvEntry 8 }\r\n\r\nadIadFxsProvDNIS OBJECT-TYPE\r\n    SYNTAX     INTEGER  {\r\n                   disabled(1),\r\n                   enabled(2),\r\n                   enabledNoAnswer(3)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"DNIS Options\r\n         1 = Disabled\r\n         2 = DNIS Enabled\r\n         3 = DNIS Enabled with No Answer Wink\"\r\n    ::= { adIadFxsProvEntry 9 }\r\n\r\nadIadFxsProvDNISDelay  OBJECT-TYPE\r\n    SYNTAX     INTEGER {\r\n                   halfSec(1),\r\n                   oneSec(2),\r\n                   oneAndHalfSec(3),\r\n                   twoSec(4),\r\n                   twoAndHalfSec(5),\r\n                   threeSec(6),\r\n                   fiveSec(7)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"DNIS Delay\r\n         1 = 0.5 seconds\r\n         2 = 1.0 seconds\r\n         3 = 1.5 seconds\r\n         4 = 2.0 seconds\r\n         5 = 2.5 seconds\r\n         6 = 3.0 seconds\r\n         7 = 5.0 seconds\"\r\n    ::= { adIadFxsProvEntry 10 }\r\n\r\nadIadFxsProvAnswerSupervision  OBJECT-TYPE\r\n    SYNTAX     INTEGER {\r\n                   disabled(1),\r\n                   enabled(2)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Answer Supervision\r\n         1 = Disabled\r\n         2 = Enabled\"\r\n    ::= { adIadFxsProvEntry 11 }\r\n\r\n--\r\n--  Voice Module Test Group\r\n--\r\n\r\nadIadVoiceTestTable OBJECT-TYPE\r\n    SYNTAX      SEQUENCE OF AdIadVoiceTestEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS      current\r\n    DESCRIPTION\r\n         \"The Voice MIB Test Table.\"\r\n    ::= { adIadVoiceTest 1 }\r\n\r\nadIadVoiceTestEntry  OBJECT-TYPE\r\n    SYNTAX      AdIadVoiceTestEntry\r\n    MAX-ACCESS  not-accessible\r\n    STATUS      current\r\n    DESCRIPTION\r\n        \"An entry in the Voice MIB Test Table.\"\r\n    INDEX    { ifIndex }\r\n    ::= { adIadVoiceTestTable 1 }\r\n\r\nAdIadVoiceTestEntry ::= SEQUENCE {\r\n    adIadVoiceTestStatus     DisplayString,\r\n    adIadFxsTestCmd          INTEGER,\r\n    adIadFxoTestCmd          INTEGER\r\n    }\r\n\r\nadIadVoiceTestStatus  OBJECT-TYPE\r\n    SYNTAX     DisplayString (SIZE(0..32))\r\n    MAX-ACCESS read-only\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Status of Current Test\"\r\n    ::= {adIadVoiceTestEntry 1 }\r\n\r\nadIadFxsTestCmd  OBJECT-TYPE\r\n    SYNTAX     INTEGER {\r\n                   noTest(1),\r\n                   digitalNetLpbk(2),\r\n                   onHook(3),\r\n                   offHook(4),\r\n                   testToneNear(5),\r\n                   testToneFar(6),\r\n                   customerRing(7)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Network Hook Test Options:\r\n             1 = No Test\r\n             2 = Digital Network Loopback\r\n             3 = Network On Hook Test\r\n             4 = Network Off Hook Test\r\n             5 = 1kHz Tone - Near End\r\n             6 = 1kHz Tone - Far End\r\n             7 = Customer Ring Test\"\r\n    ::= {adIadVoiceTestEntry 2 }\r\n\r\nadIadFxoTestCmd  OBJECT-TYPE\r\n    SYNTAX     INTEGER {\r\n                   noTest(1),\r\n                   digitalNetLpbk(2),\r\n                   onHook(3),\r\n                   offHook(4),\r\n                   toneGen(5)\r\n               }\r\n    MAX-ACCESS read-write\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"Network Hook Test Options:\r\n             1 = No Test\r\n             2 = Digital Network Loopback\r\n             3 = Network On Hook Test\r\n             4 = Network Off Hook Test\r\n             5 = 1004 Hz-0dbm0 Tone Gen\"\r\n    ::= {adIadVoiceTestEntry 3 }\r\n\r\n--\r\n--  Voice Module Status Group\r\n--\r\n\r\nadIadVoiceStatusTable OBJECT-TYPE\r\n    SYNTAX     SEQUENCE OF AdIadVoiceStatusEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n         \"The Voice MIB Status Table.\"\r\n    ::= { adIadVoiceStatus 1 }\r\n\r\nadIadVoiceStatusEntry  OBJECT-TYPE\r\n    SYNTAX     AdIadVoiceStatusEntry\r\n    MAX-ACCESS not-accessible\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"An entry in the Voice MIB Status Table.\"\r\n    INDEX { ifIndex }\r\n    ::= { adIadVoiceStatusTable 1 }\r\n\r\nAdIadVoiceStatusEntry ::= SEQUENCE {\r\n    adIadVoiceSignalStatus   DisplayString\r\n    }\r\n\r\nadIadVoiceSignalStatus     OBJECT-TYPE\r\n    SYNTAX      DisplayString (SIZE(15))\r\n     MAX-ACCESS read-only\r\n     STATUS     current\r\n     DESCRIPTION\r\n         \"Current status of Signaling Bits formatted:\r\n          \'TxAB:nn RxAB:nn\' where n is either \'0\' or \'1\'\"\r\n     ::= {  adIadVoiceStatusEntry 1 }\r\n\r\n--\r\n--  Generic IAD Voice Module NOTIFICATIONS\r\n--\r\n\r\nadIadVoiceEvents OBJECT-IDENTITY\r\n    STATUS   current\r\n    DESCRIPTION\r\n        \"Events for IAD Voice modules\"\r\n    ::= { adIadVoice 0 }\r\n\r\nadIadVoiceTestStatusActive  NOTIFICATION-TYPE\r\n--    OBJECTS        {  }        ???  ifName, AlarmState\r\n    STATUS      current\r\n    DESCRIPTION\r\n        \"Indicates that the Voice card is in a test condition\"\r\n    --#TYPE        \"Status - Voice card in test\"\r\n    --#SUMMARY     \"VOICE 1001900: Interface under Test\"\r\n    --#ARGUMENTS   { }\r\n    --#SEVERITY    MINOR\r\n    --#GENERIC     6\r\n    --#CATEGORY    \"STATUS EVENTS\"\r\n    --#SOURCE_ID   \"A\"\r\n    --#TIMEINDEX    0\r\n        ::= { adIadVoiceEvents 1003401 }\r\n\r\nadIadVoiceTestStatusClear  NOTIFICATION-TYPE\r\n--    OBJECTS        { }        ???  ifName, AlarmState\r\n    STATUS      current\r\n    DESCRIPTION\r\n        \"Indicates that the Voice card test status has cleared\"\r\n    --#TYPE        \"Status - Voice card test cleared\"\r\n    --#SUMMARY     \"Voice Module: Interface Test Cleared\"\r\n    --#ARGUMENTS   {}\r\n    --#SEVERITY    MINOR\r\n    --#GENERIC     6\r\n    --#CATEGORY    \"STATUS EVENTS\"\r\n    --#SOURCE_ID   \"A\"\r\n    --#TIMEINDEX    0\r\n        ::= { adIadVoiceEvents 1003402 }\r\n\r\nadIadVoiceAlarmBitActive  NOTIFICATION-TYPE\r\n--    OBJECTS        { }       ???  ifName, AlarmState\r\n    STATUS      current\r\n    DESCRIPTION\r\n        \"Indicates that the Voice card is in an alarm condition\"\r\n    --#TYPE        \"Status - Voice card in alarm\"\r\n    --#SUMMARY     \"Voice Module:  Alarm\"\r\n    --#ARGUMENTS   {}\r\n    --#SEVERITY     MINOR\r\n    --#GENERIC      6\r\n    --#CATEGORY     \"STATUS EVENTS\"\r\n    --#SOURCE_ID    \"A\"\r\n    --#TIMEINDEX    0\r\n        ::= { adIadVoiceEvents 1003403 }\r\n\r\nadIadVoiceaAlarmBitInactive  NOTIFICATION-TYPE\r\n--    OBJECTS        { }        ???  ifName, AlarmState\r\n    STATUS      current\r\n    DESCRIPTION\r\n         \"Indicates that the Voice card is in a test condition\"\r\n    --#TYPE        \"Status - Voice card out of alarm\"\r\n    --#SUMMARY     \"Voice MOdule:  Alarm cleared\"\r\n    --#ARGUMENTS   {}\r\n    --#SEVERITY    MINOR\r\n    --#GENERIC     6\r\n    --#CATEGORY    \"STATUS EVENTS\"\r\n    --#SOURCE_ID   \"A\"\r\n    --#TIMEINDEX    0\r\n        ::= { adIadVoiceEvents 1003404 }\r\n\r\nadIadVoiceaGatewayDown  NOTIFICATION-TYPE\r\n    OBJECTS     {\r\n                sysName,\r\n                sysLocation\r\n                }\r\n    STATUS      current\r\n    DESCRIPTION\r\n            \"This trap indicates that the Voice Gateway is down.\"\r\n    --#TYPE       \"Major - Voice Gateway is down.\"\r\n    --#SUMMARY    \"TA Router: %s Location: %s  Voice Gateway \"\r\n    --#SUMMARY    \"is down.\"\r\n    --#ARGUMENTS  {0,1}\r\n    --#SEVERITY   MAJOR\r\n    --#GENERIC    6\r\n    --#CATEGORY   \"STATUS EVENTS\"\r\n    --#SOURCE_ID  \"A\"\r\n    --#TIMEINDEX  0\r\n        ::= { adIadVoiceEvents 1003405 }\r\n\r\n adIadVoiceaGatewayUp  NOTIFICATION-TYPE\r\n    OBJECTS     {\r\n                sysName,\r\n                sysLocation\r\n                }\r\n    STATUS      current\r\n    DESCRIPTION\r\n            \"This trap indicates that the Voice Gateway is up.\"\r\n    --#TYPE       \"Minor - Voice Gateway is up.\"\r\n    --#SUMMARY    \"TA Router: %s Location: %s  Voice Gateway \"\r\n    --#SUMMARY    \"is up.\"\r\n    --#ARGUMENTS  {0,1}\r\n    --#SEVERITY   MINOR\r\n    --#GENERIC    6\r\n    --#CATEGORY   \"STATUS EVENTS\"\r\n    --#SOURCE_ID  \"A\"\r\n    --#TIMEINDEX  0\r\n        ::= { adIadVoiceEvents 1003406 }\r\n\r\nadIadVoiceaLifeLineActivated  NOTIFICATION-TYPE\r\n    OBJECTS     {\r\n                sysName,\r\n                sysLocation\r\n                }\r\n    STATUS      current\r\n    DESCRIPTION\r\n        \"This trap indicates that Life Line POTS has been activated.\"\r\n    --#TYPE       \"Major - Life Line POTS has been activated.\"\r\n    --#SUMMARY    \"TA Router: %s Location: %s  Life Line POTS \"\r\n    --#SUMMARY    \"has been activated . \"\r\n    --#ARGUMENTS  {0,1}\r\n    --#SEVERITY   MAJOR\r\n    --#GENERIC    6\r\n    --#CATEGORY   \"STATUS EVENTS\"\r\n    --#SOURCE_ID  \"A\"\r\n    --#TIMEINDEX  0\r\n        ::= { adIadVoiceEvents 1003407 }\r\n\r\nadIadVoiceaLifeLineDeactivated  NOTIFICATION-TYPE\r\n    OBJECTS     {\r\n                sysName,\r\n                sysLocation\r\n                }\r\n    STATUS      current\r\n    DESCRIPTION\r\n        \"This trap indicates that Life Line POTS has been\r\n        deactivated.\"\r\n    --#TYPE       \"Minor - Life Line POTS has been deactivated.\"\r\n    --#SUMMARY    \"TA Router: %s Location: %s  Life Line POTS \"\r\n    --#SUMMARY    \"has been deactivated. \"\r\n    --#ARGUMENTS  {0,1}\r\n    --#SEVERITY   MINOR\r\n    --#GENERIC    6\r\n    --#CATEGORY   \"STATUS EVENTS\"\r\n    --#SOURCE_ID  \"A\"\r\n    --#TIMEINDEX  0\r\n        ::= { adIadVoiceEvents 1003408 }\r\n\r\n--\r\n-- Compliance Statements\r\n--\r\n\r\nadIadVoiceCompliance MODULE-COMPLIANCE\r\n    STATUS  current\r\n    DESCRIPTION\r\n        \"The compliance statement for SNMPv2 entities which\r\n        implement the adUnit MIB.\"\r\n\r\n    MODULE\r\n    MANDATORY-GROUPS {\r\n        adIadVoiceBaseGroup\r\n    }\r\n\r\n    GROUP    adIadFxsGroup\r\n    DESCRIPTION\r\n        \"Support for this group is mandatory for FXS cards\"\r\n\r\n    GROUP    adIadFxoGroup\r\n    DESCRIPTION\r\n        \"Support for this group is mandatory for FXO cards\"\r\n\r\n    ::= { adIadVoiceCompliances 1 }\r\n\r\n-- units of conformance\r\n\r\nadIadVoiceBaseGroup OBJECT-GROUP\r\n    OBJECTS {\r\n        adIadVoiceProvMode,\r\n        adIadVoiceTestStatus,\r\n        adIadVoiceSignalStatus,\r\n        adIadVoiceProvSvcMode,\r\n        adIadVoiceProvTXTLPString,\r\n        adIadVoiceProvRXTLPString\r\n    }\r\n    STATUS  current\r\n    DESCRIPTION\r\n        \"The IAD Voice Base Group.\"\r\n\r\n    ::= { adIadVoiceMIBGroups 1 }\r\n\r\nadIadFxsGroup OBJECT-GROUP\r\n    OBJECTS {\r\n    adIadFxsProvLineImpedance,\r\n    adIadFxsProvMsgIndicator,\r\n    adIadFxsProvConversionMode,\r\n    adIadFxsProvSupervision,\r\n    adIadFxsProvFwdDiscBatt,\r\n    adIadFxsProvDialTone,\r\n    adIadFxsProvTandRingBack,\r\n    adIadFxsProvForwardDelay,\r\n    adIadFxsProvDNIS,\r\n    adIadFxsProvDNISDelay,\r\n    adIadFxsProvAnswerSupervision,\r\n    adIadFxsTestCmd\r\n    }\r\n    STATUS  current\r\n    DESCRIPTION\r\n        \"The IAD Voice FXS Only Group.  Variables in this group\r\n        are only supported by FXS modules\"\r\n    ::= { adIadVoiceMIBGroups 2 }\r\n\r\nadIadFxoGroup OBJECT-GROUP\r\n    OBJECTS {\r\n    adIadFxoTestCmd\r\n    }\r\n    STATUS  current\r\n    DESCRIPTION\r\n        \"The IAD Voice FXO Only Group.  Variables in this group\r\n        are only supported by FXO modules\"\r\n    ::= { adIadVoiceMIBGroups 3 }\r\n\r\nadIadVoiceEventGroup NOTIFICATION-GROUP\r\n    NOTIFICATIONS {\r\n        adIadVoiceTestStatusActive,\r\n        adIadVoiceTestStatusClear,\r\n        adIadVoiceAlarmBitActive,\r\n        adIadVoiceaAlarmBitInactive,\r\n        adIadVoiceaGatewayDown,\r\n        adIadVoiceaGatewayUp,\r\n        adIadVoiceaLifeLineActivated,\r\n        adIadVoiceaLifeLineDeactivated\r\n    }\r\n    STATUS  current\r\n    DESCRIPTION\r\n        \"The IAD Voice Notification Group.\"\r\n    ::= { adIadVoiceMIBGroups 4 }\r\n\r\nEND\r\n'),(3,'ADTRAN-MIB',1756979642,1756979642,1,'','\r\n    ADTRAN-MIB  DEFINITIONS ::= BEGIN\r\n\r\n    -- TITLE:       ADTRAN MIB Definitions (SMIv2)\r\n    -- FILENAME:    ADTRAN.MIB\r\n    -- AUTHOR:      Jeff Wells\r\n    -- DATE:        97/06/13\r\n    --\r\n    -- MODIFICATIONS:\r\n    --   98/04/10 SLS added adShared node for shared function mibs\r\n    --   98/05/05 SLS correct adShared & add adPerform shared function mibs\r\n    --   98/09/17 SLS added adProductID & adProdTransType (both optional)\r\n    --   98/09/24 BED revised description of adProdPhysAddress\r\n    --   01/07/19 pnb Added adIdentity nodes for SMIv2 modules\r\n    --   02/04/02 sls Converted to SMIv2\r\n    --   02/08/09 pnb/sls add nodes for module identity, module compliance,\r\n    --                and agent capabilities advances using SMIv2\r\n\r\n    -- *** ENSURE ANY UPDATES TO THIS FILE ARE ALSO REFLECTED IN ADTRAN.MIB ***\r\n\r\n    -- {iso org(3) dod(6) internet(1) private(4) enterprises(1) adtran(664) }\r\n    -- The ADTRAN-MIB defines the \"adtran\" enterprise tree node.  This MIB\r\n    -- provides the basis for the definition of all other ADTRAN MIBs.\r\n    -- The \"adProducts\" sub-node under \"adtran\" lists all SNMP manageable\r\n    -- products.  Product specific MIBs are defined under \"adMgmt\".\r\n    -- Management information common to all ADTRAN products appears under\r\n    -- the \"adAdmin\" sub-node.\r\n\r\n    IMPORTS\r\n    enterprises, OBJECT-TYPE, MODULE-IDENTITY\r\n           FROM SNMPv2-SMI\r\n    DisplayString,PhysAddress\r\n           FROM SNMPv2-TC\r\n    MODULE-COMPLIANCE, OBJECT-GROUP\r\n           FROM SNMPv2-CONF;\r\n\r\nadtran MODULE-IDENTITY\r\n        LAST-UPDATED \"0208090000Z\"\r\n        ORGANIZATION \"ADTRAN, Inc.\"\r\n        CONTACT-INFO\r\n               \"        Technical Support Dept.\r\n                Postal: ADTRAN, Inc.\r\n                        901 Explorer Blvd.\r\n                        Huntsville, AL 35806\r\n\r\n                   Tel: +1 800 726-8663\r\n                   Fax: +1 256 963 6217\r\n                E-mail: support@adtran.com\"\r\n        DESCRIPTION\r\n               \"The MIB module that describes the base organization\r\n               for all enterprises MIBs developed by ADTRAN, Inc.\"\r\n       ::= { enterprises 664 }\r\n\r\n\r\n\r\n    --\r\n    -- OBJECT-IDENTIFIERS\r\n    --\r\n\r\n    adProducts         OBJECT IDENTIFIER ::= { adtran 1 }\r\n    adMgmt             OBJECT IDENTIFIER ::= { adtran 2 }\r\n    adAdmin            OBJECT IDENTIFIER ::= { adtran 3 }\r\n    adPerform          OBJECT IDENTIFIER ::= { adtran 4 }\r\n    adShared           OBJECT IDENTIFIER ::= { adtran 5 }\r\n    adIdentity         OBJECT IDENTIFIER ::= { adtran 6 }\r\n        adIdentityShared   OBJECT IDENTIFIER ::= { adIdentity 10000 }\r\n    adAgentCapModule   OBJECT IDENTIFIER ::= { adtran 7 }\r\n        adAgentCapProduct  OBJECT IDENTIFIER ::= { adAgentCapModule 1 }\r\n        adAgentCapShared   OBJECT IDENTIFIER ::= { adAgentCapModule 2 }\r\n    adConformance      OBJECT IDENTIFIER ::= { adtran 99 }\r\n        adComplianceShared OBJECT IDENTIFIER ::= { adConformance 10000 }\r\n\r\n    --\r\n    -- PRODUCT-IDENTITY SECTION - adProducts\r\n    --\r\n    -- The name identifiers for Adtran products that support SNMP\r\n    -- management appear in a list under the \"adProducts\" node.\r\n    -- The location of the name within this list defines the MIB-II\r\n    -- system group \"sysObjectID\" value for the product.  For example,\r\n    -- the T1 channel bank line interface unit, ACTDAXL3, will respond\r\n    -- to a request for system object ID with the identifier sequence\r\n    -- iso.org.dos.internet.private.enterprises.adtran.adProducts.\r\n    -- adACTDAXL3 - 1.3.6.1.4.1.664.1.9\r\n    --\r\n\r\n    --\r\n    -- PRODUCT MANAGEMENT SECTION - adMgmt\r\n    --\r\n    -- The \"adMgmt\" node contains product specific management information.\r\n    -- Each manageable product will have its own sub-node under this node\r\n    -- containing the product\'s management information.  For example, the\r\n    -- ACTDAXL3 management node is \"adACTDAXL3mg\" with the numeric\r\n    -- identifier sequence - 1.3.6.1.4.1.664.2.9.\r\n    --\r\n\r\n    --\r\n    -- ADMINISTRATION SECTION - adAdmin\r\n    --\r\n    -- The \"adAdmin\" node contains administrative information\r\n    -- for Adtran products.  The \"adProductInfo\" group under this\r\n    -- node contains information about the product, such as\r\n    -- product name, part number, and revision.\r\n    --\r\n\r\n    --\r\n    -- Perfomance SECTION - adPerform\r\n    --\r\n    -- The \"adPerform\" node contains frame relay performance statistics\r\n    -- for all Adtran \"IQ\" devices (i.e., TSUIQ & DSUIQ). Currently, the\r\n    -- only mib groups under this branch are defined in the fperform mib.\r\n    --\r\n\r\n    --\r\n    -- SHARED SECTION - adShared\r\n    --\r\n    -- The \"adShared\" node contains management information for a specific\r\n    -- function which may be supported by several manageable products.\r\n    -- Each functional group will have its own sub-node under this node\r\n    -- and be located within an individual MIB.  For example, the node\r\n    -- adExLan is the first node under the adShared node with the numeric\r\n    -- identifier sequence - 1.3.6.1.4.1.664.5.1.\r\n    --\r\n\r\n    --\r\n    -- MODULE IDENTITY SECTION - adIdentity\r\n    --\r\n    -- The \"adIdentity\" node contains a list of product identifiers that\r\n    -- are used in the Module Identify OID for SMIv2 MIBs only.  The Module\r\n    -- Identity name should be the same as the product name under\r\n    -- the adProducts node, with a suffix of \"ID\". For example, if the product name\r\n    -- is adVCP, then the SMIv2 Module Identity clause should be named adVCPID.\r\n    -- The OID is adIdentity followed by the numeric ProductID.\r\n    --\r\n\r\n    --\r\n    -- AGENT CAPABILITIES SECTION - adAgentCapModule\r\n    --\r\n    -- The \"adAgentCapModule\" node is the branch that SMIv2 AGENT-CAPABILITIES\r\n    -- statements use. THere are two subnodes defined to support both product\r\n    -- specific and generic MIBs. Use these as appropriate.\r\n\r\n    --\r\n    -- CONFORMANCE SECTION - adConformance\r\n    --\r\n    -- Conformance statements in SMIv2 consist of OBJECT-GROUP, NOTIFICATION-GROUP\r\n    -- and MODULE-COMPLIANCE statements. THese are to be placed under this node\r\n    -- for all product MIBs and under the sub-node for adShared MIBs.\r\n    -- OID.\r\n\r\n\r\n    --\r\n    -- Product Information group\r\n    --\r\n    -- This group contains information common for most all Adtran\r\n    -- products.\r\n    --\r\n\r\n    adProductInfo   OBJECT IDENTIFIER ::= { adAdmin 1 }\r\n\r\n    adProdName  OBJECT-TYPE\r\n        SYNTAX      DisplayString\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"The Adtran Product Name\"\r\n        ::= { adProductInfo 1 }\r\n\r\n    adProdPartNumber  OBJECT-TYPE\r\n        SYNTAX      DisplayString\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"The Adtran Product Part Number\"\r\n        ::= { adProductInfo 2 }\r\n\r\n    adProdCLEIcode  OBJECT-TYPE\r\n        SYNTAX      DisplayString\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"The Adtran Product CLEI Code\"\r\n        ::= { adProductInfo 3 }\r\n\r\n    adProdSerialNumber  OBJECT-TYPE\r\n        SYNTAX      DisplayString\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"The Adtran Product Serial Number\"\r\n        ::= { adProductInfo 4 }\r\n\r\n    adProdRevision  OBJECT-TYPE\r\n        SYNTAX      DisplayString\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"The Adtran Product Revision Number\"\r\n        ::= { adProductInfo 5 }\r\n\r\n    adProdSwVersion  OBJECT-TYPE\r\n        SYNTAX      DisplayString\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"The Adtran Product Software Version Number\"\r\n        ::= { adProductInfo 6 }\r\n\r\n    adProdPhysAddress   OBJECT-TYPE\r\n        SYNTAX      PhysAddress\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"This octet string variable contains the Adtran\r\n             Physical Address assigned to this product.  For\r\n             example, the octet sequence 16 02 03 01 specifies\r\n             bank/shelf number 22 (hex 16), group number 2,\r\n             slot number 3, unit/port 1. This object value is\r\n             commonly reported in SNMP Traps to identify the\r\n             product\'s location.\"\r\n        ::= { adProductInfo 7 }\r\n\r\n    adProdProductID  OBJECT-TYPE\r\n        SYNTAX      OBJECT IDENTIFIER\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"The Adtran Product ID as reported via sysObjectID.\r\n             Note: In the proprietary ASP protocol, the product reports\r\n             only its product type number as an octet string.\"\r\n        ::= { adProductInfo 8 }\r\n\r\n    adProdTransType OBJECT-TYPE\r\n        SYNTAX      DisplayString\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"The data transmission circuit/facility/payload level of the\r\n             device (see Appendix A of GR-833-CORE).  Common examples are:\r\n             T0, T1, T2, T3, STS1, and OC3. For the SCU and other common\r\n             equipment cards, the code should be EQPT.\"\r\n        ::= { adProductInfo 9 }\r\n\r\n-- compliance statements\r\n-- These two subidentifiers are for local use in this MIB only\r\nadCompliances    OBJECT IDENTIFIER ::= { adConformance  1 }\r\nadMIBGroups      OBJECT IDENTIFIER ::= { adConformance  2 }\r\n\r\nadCompliance MODULE-COMPLIANCE\r\n   STATUS  current\r\n   DESCRIPTION\r\n       \"The compliance statement for SNMPv2 entities which implement the\r\n       adtran MIB, which is supported by all ADTRAN SNMP agents.\"\r\n\r\n   MODULE  -- this module\r\n   MANDATORY-GROUPS {\r\n       adBaseGroup\r\n       }\r\n\r\n   GROUP  adCNDGroup\r\n       DESCRIPTION\r\n           \"Group which are supported by all CND products and some END which\r\n           are supported by the EMS management system.\"\r\n   ::= { adCompliances 1 }\r\n\r\n\r\nadBaseGroup OBJECT-GROUP\r\n    OBJECTS {\r\n        adProdName,\r\n        adProdPartNumber,\r\n        adProdCLEIcode,\r\n        adProdSerialNumber,\r\n        adProdRevision,\r\n        adProdSwVersion,\r\n        adProdPhysAddress,\r\n        adProdProductID\r\n        }\r\n    STATUS  current\r\n    DESCRIPTION\r\n       \"The ADTRAN Base Group.\"\r\n    ::= { adMIBGroups 1 }\r\n\r\nadCNDGroup OBJECT-GROUP\r\n    OBJECTS {\r\n        adProdTransType\r\n        }\r\n    STATUS  current\r\n    DESCRIPTION\r\n       \"Variables supported by CND products only.\"\r\n    ::= { adMIBGroups 2 }\r\n\r\n    END\r\n'),(4,'ADTRAN-TA6XX-MIB',1756979642,1756979642,1,'','   ADTRAN-TA6XX-MIB   DEFINITIONS ::= BEGIN\r\n\r\n   -- TITLE:       Generic TA6xx MIB\r\n   -- PRODUCT:     All Total Access 6xx type products\r\n   -- DATE:        02/09/06\r\n   -- AUTHOR:      Scott Jackson\r\n   -- SNMP:        SNMPv2c\r\n   -- MIB ARC:     adtran.adIdentityShared.42\r\n   -- FILE:        adTa6xx.mib\r\n\r\n\r\n   -- HISTORY:\r\n      -- 09/06/02 jsj Created.\r\n\r\n   IMPORTS\r\n         IpAddress, OBJECT-TYPE, MODULE-IDENTITY,\r\n         Integer32\r\n             FROM SNMPv2-SMI\r\n         MODULE-COMPLIANCE, OBJECT-GROUP\r\n             FROM SNMPv2-CONF\r\n         DisplayString\r\n             FROM SNMPv2-TC\r\n    adShared, adIdentityShared\r\n             FROM ADTRAN-MIB\r\n         AdProductIdentifier\r\n             FROM ADTRAN-TC;\r\n\r\n\r\n   adTa6xxMID MODULE-IDENTITY\r\n        LAST-UPDATED \"0209060000Z\"\r\n        ORGANIZATION \"ADTRAN, Inc.\"\r\n        CONTACT-INFO\r\n               \"        Technical Support Dept.\r\n                Postal: ADTRAN, Inc.\r\n                        901 Explorer Blvd.\r\n                        Huntsville, AL 35806\r\n\r\n                   Tel: +1 800 726-8663\r\n                   Fax: +1 256 963 6217\r\n                E-mail: support@adtran.com\"\r\n        DESCRIPTION\r\n            \"The MIB module for general IAD system\r\n             configuration.\"\r\n       ::= { adIdentityShared 42 }\r\n\r\n\r\n   adTa6xx             OBJECT IDENTIFIER ::= { adShared 42 }\r\n\r\n   adTa6xxScalars      OBJECT IDENTIFIER ::= { adTa6xx 1 }\r\n   adTa6xxCompliances  OBJECT IDENTIFIER ::= { adTa6xx 2 }\r\n   adTa6xxMIBGroups    OBJECT IDENTIFIER ::= { adTa6xx 3 }\r\n\r\n   -- Configuration Group\r\n\r\n   adTa6xxProduct OBJECT-TYPE\r\n       SYNTAX  AdProductIdentifier\r\n       MAX-ACCESS  read-only\r\n       STATUS  current\r\n       DESCRIPTION\r\n               \"The ADTRAN Product code for this Ta6xx.\"\r\n       ::= { adTa6xxScalars 1 }\r\n\r\n\r\n   -- Provisioning group\r\n\r\n   adTa6xxDate OBJECT-TYPE\r\n        SYNTAX     OCTET STRING (SIZE (10))\r\n        MAX-ACCESS      read-write\r\n        STATUS          current\r\n        DESCRIPTION\r\n            \"Current date string in format mm/dd/yyyy\"\r\n        ::= { adTa6xxScalars 2 }\r\n\r\n   adTa6xxTime OBJECT-TYPE\r\n        SYNTAX     OCTET STRING (SIZE (8))\r\n        MAX-ACCESS      read-write\r\n        STATUS          current\r\n        DESCRIPTION\r\n            \"Current 24 hour time string in format hh:mm:ss\"\r\n        ::= { adTa6xxScalars 3 }\r\n\r\n    adTa6xxTftpAddr OBJECT-TYPE\r\n        SYNTAX          IpAddress\r\n        MAX-ACCESS      read-write\r\n        STATUS          current\r\n        DESCRIPTION\r\n            \"Tftp server IP Address for software uploads.\r\n             Upgrade is initiated and filename specified via\r\n             objects in genslot.mib.\"\r\n        ::= { adTa6xxScalars 4 }\r\n\r\n    adTa6xxTFileName OBJECT-TYPE\r\n        SYNTAX      DisplayString (SIZE(0..127))\r\n        MAX-ACCESS  read-write\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"Filename for tftp software update.\"\r\n        ::= { adTa6xxScalars 5 }\r\n\r\n    adTa6xxUpdateSoftware OBJECT-TYPE\r\n        SYNTAX      INTEGER {\r\n                    initiate(1)\r\n                    }\r\n        MAX-ACCESS      read-write\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"A set command will initiate tftp download.\r\n             Get has no meaning and will always return 1.\"\r\n        ::= { adTa6xxScalars 6 }\r\n\r\n    adTa6xxUpdateStatus OBJECT-TYPE\r\n        SYNTAX      DisplayString\r\n        MAX-ACCESS      read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"A progress indication during download which can\r\n             be polled.\"\r\n        ::= { adTa6xxScalars 7 }\r\n\r\n\r\n   -- Status group\r\n\r\n    adTa6xxAlarmStatus OBJECT-TYPE\r\n        SYNTAX      OCTET STRING\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"A byte encoded string representing the alarm state\r\n             of the unit. Unit Alarm Indicator is a byte that\r\n             indicates whether an alarm is present in the unit\r\n             or not.\r\n\r\n             Unit Alarm Ind:\r\n             0 - No Alarm present on Unit\r\n             1 - An alarm(s) is present on the unit.\r\n\r\n             L1 Alarm:\r\n             0 - No Alarm\r\n             1 - Alarm Active\r\n\r\n             L2 Alarm:\r\n             0 - No Alarm\r\n             1 - Alarm Active\r\n\r\n             Format of the byte string from left to right:\r\n             +-----+-----+-----+-----+-----+-----+-----+\r\n             |       Byte 1    |  Byte 2   |  Byte 3   |\r\n             +-----+-----+-----+-----+-----+-----+-----+\r\n             |  Unit Alarm Ind | L1 Alarm  | L2 Alarm  |\r\n             +-----+-----+-----+-----+-----+-----+-----+\r\n             .\"\r\n        ::= { adTa6xxScalars 8 }\r\n\r\n    adTa6xxProvVersion OBJECT-TYPE\r\n        SYNTAX      Integer32\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"The sum of all the card Provisioning Counters in\r\n             the generic slot MIB that can be used by an EMS to\r\n             detect local changes to card provisioning that\r\n             need to be investigated for synchronization.\"\r\n        ::= { adTa6xxScalars 9 }\r\n\r\n\r\n   -- Front panel high speed MAX-ACCESS cache\r\n   --  This object permits retrieval of the entire front panel\r\n   --   indicators in one SNMP object. See product MIBs for\r\n   --    support level.\r\n\r\n   adTa6xxFrontPanel OBJECT-TYPE\r\n        SYNTAX      OCTET STRING\r\n        MAX-ACCESS  read-only\r\n        STATUS      current\r\n        DESCRIPTION\r\n            \"A byte encoded string representing the status of\r\n             faceplate indicators, LEDs, & switches for GUI\r\n             visualization. The format of this string for the\r\n             TA6xx IADs are as follows:\r\n\r\n            1. The first (left-most) byte of the string\r\n               corresponds to the right-most LED or switch of\r\n               the TA6xx frontpanel. The adjacent LED is\r\n               represented by the next byte of the string.\r\n               Therefore, the string is read from left to right\r\n               and represents the LEDs from right to left.\r\n\r\n            2. The byte value represents the following:\r\n               0x1 -    LED OFF\r\n               0x2 -    SOLID GREEN\r\n               0x3 -    SOLID YELLOW\r\n               0x4 -    SOLID RED\r\n               0x5 -    SLOWBLINK GREEN\r\n               0x6 -    FASTBLINK GREEN\r\n               0x7 -    SLOWBLINK YELLOW\r\n               0x8 -    FASTBLINK YELLOW\r\n               0x9 -    SLOWBLINK RED\r\n               0xa -    FASTBLINK RED\r\n               0xb -    AUDIBLE ALARM\r\n\r\n               Present Format of LEDs\r\n              +-----+-----+-----+-----+-----+-----+-----+-----+\r\n              | Pwr |Batt |Voice|Data |v35tx|v35rx|link |tx/rx|\r\n              +-----+-----+-----+-----+-----+-----+-----+-----+\r\n\r\n              NOTE: v35tx, v35rx, tx/rx cannot be reported by SNMP\r\n                    at this time.\r\n            \"\r\n        ::= { adTa6xxScalars 10 }\r\n\r\n--\r\n-- Compliance Statement\r\n--\r\n\r\nadTa6xxCompliance MODULE-COMPLIANCE\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The compliance statements for SNMPv2 entities which\r\n        implement the adIadIwf MIB.\"\r\n\r\n    MODULE\r\n    MANDATORY-GROUPS {\r\n        adTa6xxBaseGroup\r\n    }\r\n\r\n    ::= { adTa6xxCompliances 1 }\r\n\r\n-- units of conformance\r\n\r\nadTa6xxBaseGroup OBJECT-GROUP\r\n    OBJECTS {\r\n        adTa6xxProduct,\r\n        adTa6xxDate,\r\n        adTa6xxTime,\r\n        adTa6xxTftpAddr,\r\n        adTa6xxTFileName,\r\n        adTa6xxUpdateSoftware,\r\n        adTa6xxUpdateStatus,\r\n        adTa6xxAlarmStatus,\r\n        adTa6xxProvVersion,\r\n        adTa6xxFrontPanel\r\n    }\r\n    STATUS     current\r\n    DESCRIPTION\r\n        \"The TA 6xx Base Group.\"\r\n\r\n    ::= { adTa6xxMIBGroups 1 }\r\n\r\n      END\r\n'),(5,'ADTRAN-TC',1756979642,1756979642,1,'','ADTRAN-TC    DEFINITIONS ::= BEGIN\r\n\r\n\r\nIMPORTS\r\n    MODULE-IDENTITY     FROM SNMPv2-SMI\r\n    TEXTUAL-CONVENTION  FROM SNMPv2-TC\r\n    adtran              FROM ADTRAN-MIB;\r\n\r\nadtrantcMib MODULE-IDENTITY\r\n        LAST-UPDATED \"200112300000Z\"\r\n        ORGANIZATION \"ADTRAN, Inc.\"\r\n        CONTACT-INFO\r\n               \"        Technical Support Dept.\r\n                Postal: ADTRAN, Inc.\r\n                        901 Explorer Blvd.\r\n                        Huntsville, AL 35806\r\n\r\n                   Tel: +1 800 726-8663\r\n                   Fax: +1 256 963 6217\r\n                E-mail: support@adtran.com\"\r\n        DESCRIPTION\r\n               \"The MIB module for general unit configuration.\"\r\n       ::= { adtran 6 }\r\n\r\n    -- TITLE:       ADTRAN Textual Convention Definitions\r\n    -- FILENAME:    adtrantc.mib\r\n    -- AUTHOR:      Phil Bergstresser\r\n    -- DATE:        00/03/29\r\n    --\r\n    -- PROCESS: END email requests to Steve Shown w/ product # & name\r\n    --          CND email requests to Phil Bergstresser w/ product # & name\r\n    --          Each backup for the other\r\n    --\r\n    -- MODIFICATIONS:\r\n    --   00/03/30 pnb Generate adProductID enumeration\r\n    --   00/04/12 pnb add alarm severity enumeration\r\n    --   00/04/24 pnb update productIds and adShared types from Source Safe doc\r\n    --   00/04/26 pnb same\r\n    --   00/05/03 pnb same, plus reorder some types\r\n    --   00/05/19 pnb same, reorder some comments\r\n    --   00/05/24 pnb correct 270 double comment flaw\r\n    --   00/06/19 pnb update adShared\r\n    --   00/07/31 pnb update from adtmib doc for options cards and additions.\r\n    --                correct case typo in alarm severity.\r\n    --   00/08/04 pnb align comments for ease of reading, and\r\n    --                update from latest adtmib.doc changes.\r\n    --   00/08/09 sls added TA1500 Dual FXO/DPT product ID\r\n    --   00/08/22 sls added TA3000 cards & MX2800STS1 (#s 286-288)\r\n    --   00/08/25 sls added TA1500 cards (#s 289-291)\r\n    --   00/09/15 sls added nodes to adShared\r\n    --   00/09/21 sls aded Lucent, TA1500, & Stratum card entries\r\n    --   00/10/02 sls added adTA1500LucentSCU\r\n    --   00/10/11 sls added adTA3000qADSL\r\n    --   00/10/23 sls added adATLAS890\r\n    --   00/10/26 sls added adTA1500FT1dp, adLucentLIU 2.4.1, adGenLIU &\r\n    --                adDSX1Common\r\n    --   00/11/07 sls added adTA3000OctIMA\r\n    --   01/01/08 sls added adMgmt.303 - adMgmt.309 & adTSU1500SCUCommon\r\n    --   01/01/10 sls added adTA3000qHDSL2 & adTAGSHDSL\r\n    --   01/01/17 sls added adMX2810\r\n    --   01/02/16 sls corrected entries for enum 218,220, & 295\r\n    --   01/02/19 sls ATLAS 550 Packet Voice Rsrc Module\r\n    --   02/27/01 sls added TA1500 Multi 4-Wire\r\n    --   03/01/01 sls added adTSULTX\r\n    --   03/22/01 sls added 316-321\r\n    --   03/27/01 sls consolidated 316-321 to 316-317 & added TA3000 G.SHDSL multi-ports\r\n    --   04/05/01 sls added 320-331 (TA 1500 access cards)\r\n    --   04/10/01 sls added adPSUcommon\r\n    --   04/18/01 sls added adTA1500DDSdp\r\n    --   04/23/01 sls added TA 3000 DS3 TSI E1 MUX (trap extension) place holders\r\n    --   04/26/01 sls added adGenSHDSL\r\n    --   05/01/01 sls added adTA3000CES\r\n    --   05/03/01 sls added adTARouterTraps\r\n    --   05/09/01 sls added adIQ710, its interface modules & adTA1500LcntUBR1TE\r\n    --   05/18/01 sls added adTA3000VCP\r\n    --   05/23/01 pnb added adExp6530SHDSL\r\n    --   05/24/01 pnb added adTA3000quadE1NTU\r\n    --   05/29/01 sls added ATLAS 810\r\n    --   05/30/01 sls added adTracerCommon\r\n    --   05/31/01 sls added adExp653x\r\n    --   06/15/01	sls added adTA608, adTA3000LTU8 & adTANTU8\r\n    --   06/19/01	sls added adTA3000DS1FR\r\n    --   06/26/01 sls added adTASHDSLbnc & adTASHDSLv35\r\n    --   06/28/01 sls added adTA3000ALEc\r\n    --   06/29/01 sls added Total Access 2nd Gen H2TUC  cards\r\n    --   07/09/01 sls added adTASHDSLSP\r\n    --   07/31/01 sls added adTA3000HTUCg6 & adTA3000HTUCg6HLSS\r\n    --   08/13/01 sls added adTADS3TSIE3\r\n    --   08/22/01 sls added several Total Access 1000 cards\r\n    --   09/10/01 sls added adXprs6503\r\n    --   09/13/01 sls added 3 HTUC cards\r\n    --   09/21/01 sls added adTA300DS3LM(371) & adTA300H2TURsprint(372)\r\n    --   10/04/01 sls added adTA1500MCU(373), adTA3000BATS(374) & adTA1500DDSdpQwest(375)\r\n    --   10/19/01 sls added adTA3000qSHDSL\r\n    --   10/23/01 sls added adTA3000T1OR\r\n    --   10/25/01 sls added adTA3000OC3CSM\r\n    --   10/29/01 sls added reserved14\r\n    --   11/07/01 sls added adTA1500DualCoinCot & adTA1500DualCoinRt\r\n    --   11/12/01 pnb added adDSX1CommonTraps (trap extender)\r\n    --   11/16/01 sls added adATLAS550NxT1hssi\r\n    --   11/26/01 sls added adNV1800\r\n    --   11/28/01 sls added adTASHDSLprot\r\n    --   12/05/01 pnb added adTA1500qFXOMLT(385)\r\n    --   12/07/01 pnb added adTAOC3L3(386) plus two trap extension IDs\r\n    --   12/17/01 pnb added EBS C & R phone cards\r\n    --   01/07/02 sls added 2nd Gen IQ710\r\n    --   01/08/02 pnb added quad E1\r\n    --   01/11/02 pnb added TA 1500 4 wire single DX cards\r\n    --   01/23/02 pnb added TA4303 PS\r\n    --   01/24/02 sls added Atlas 550 cards & corrected PNs on others\r\n    --   01/24/02 pnb added TA4303 STS1\r\n    --   01/25/02 sls added adunit\r\n    --   01/25/02 pnb added TA 3000 DS0 TSI Mux\r\n    --   01/28/02 pnb added TA4303 oBRI & adH4TUCcommon\r\n    --   01/29/02 pnb changed comment on product ID 3 (reserved00) to reflect usage\r\n    --   01/30/02 pnb added TA 3000 IVD\r\n    --   02/01/02 sls added TA550 modules\r\n    --   02/05/02 pnb added MX2810 STS1 card\r\n    --   02/05/02 pnb added TA3000 H4TUC\r\n    --   02/07/02 sls added added adTA850RCU\r\n    --   02/14/02 pnb added TA 3000 SHDSL 1.5 Gen LTUs\r\n    --   02/20/02 sls added ATLAS 800 modules & edited several existing ATLAS\r\n    --                      entries to make more consistent\r\n    --   02/24/02 sls added ATLAS 830\r\n    --   03/08/02 pnb added TA 3000 H2TUC-HKT\r\n    --   04/01/02 pnb added TA 3000 octal ADSL\r\n    --   04/02/02 pnb added TA 3K HTUC cards\r\n    --   04/03/02 pnb added LTU4/NTU4\r\n    --   04/05/02 pnb added TA4303SNMP\r\n    --   04/08/02 pnb add TA3000 octal ADSL w/ POTS splitters\r\n    --   04/19/02 pnb add trap extension for MX28xx\r\n    --   05/13/02 sls add IAD entries in adShared\r\n    --   05/16/02 pnb add 28 slot DS3 TSI & mod description of 22 slot (264) for 3010\r\n    --   05/17/02 sls revise adTADSX1 comment\r\n    --   05/22/02 pnb change 445 to 455 and mark gap\r\n    --   06/10/02 pnb add H2TUC HLSS\r\n    --   06/11/02 pnb add H4TUC G2 (3)\r\n    --   06/21/02 pnb add 128 port CSM\r\n    --   06/27/02 pnb add comment to 319 for 2nd gen equivalence\r\n    --   06/28/02 sls add ATLAS 550 Dual Video\r\n    --   07/02/02 sls add ATLAS 800 Octal FXS\r\n    --   07/10/02 pnb add T200 SHDSL NTU\r\n    --   07/11/02 pnb add TA T1/E1 SHDSL LTU\r\n    --   07/22/02 pnb add shared GenOPTI3\r\n    --   07/23/02 pnb add OPTI3L2, and \"Unknown\" non-responsive generic\r\n    --   07/30/02 pnb add shared adGenAtm, & TA1500 4w cards\r\n    --   08/02/02 pnb add ta100 E1/T1 LIU\r\n    --   08/05/02 pnb add 3 1500 common nodes\r\n    --   08/08/02 pnb add TA3k DS3CSM cr\r\n    --   08/08/02 sls add adATLAS550EtherSwitch\r\n    --   08/09/02 sls add NetVanta 3xxx update/additions\r\n    --   08/12/02 sls add TA 6xx entries\r\n    --   08/13/02 pnb add E1FR and 1500 TO & FXS/GT cards\r\n    --   08/27/02 pnb add trap extension for generic OPTI3\r\n    --   09/12/02 pnb add shared DSx1FR\r\n    --   09/18/02 pnb add quad IMA cards\r\n    --   09/27/02 pnb add MX2820 19\" shelf & cards\r\n    --   10/16/02 pnb add SHDSL4 LTU\r\n    --   10/24/02 pnb add TA1500 Single 4-Wire ETO\r\n    --   10/29/02 sls add adTa6xx & adIadIwf\r\n    --   11/01/02 sls add TA604, TA612, TA616\r\n    --   11/13/02 pnb add adGen654x to adShared\r\n    --   12/12/02 pnb add MX2820 23\" shelf\r\n    --   12/17/02 pnb add OPTI-MX shelf & cards\r\n    --   12/23/02 sls add NV2xxx VPN products\r\n    --   01/06/03 pnb add OPTI-MX SCM controller\r\n    --   02/03/03 pnb add TA12xx shelves & cards\r\n    --   02/04/03 pnb add 512-520 TA3k variety\r\n    --   02/06/03 pnb adjust name/descr of SCU(517)\r\n    --   02/06/03 pnb add eSCU L3\r\n    --   02/11/03 pnb add & correct TA1500 ETO cards\r\n    --   02/17/03 pnb add new shared node for SHDSL4 products\r\n    --   02/18/03 pnb add 1500 Ubrite\r\n    --   02/28/03 pnb add adMCUcommon\r\n    --   03/07/03 sls add TA604, TA612, TA616: redundant\r\n    --   03/11/03 pnb add oADSL-c w/ ETA, remove redundant 6xx\r\n    --   03/20/03 sls add NetVanta 1224 & 1224ST\r\n    --   04/02/03 pnb add 1500FT1 shared\r\n    --   04/08/03 sls add ATLAS 550 NX\r\n    --   04/09/03 sls add ATLAS 550 Dual FXO\r\n    --   04/18/03 pnb add 1500 FXO GT\r\n    --   04/22/03 pnb add OMM12 shared and product, and 1500 4W TDM\r\n    --   04/23/03 pnb add OptiSMXshelf\r\n    --   05/02/03 pnb add 1200 ADSL IDs (same Product# as shelf)\r\n    --   05/02/03 pnb add adOptical shared node for Phoenix (JV)\r\n    --   05/07/03 pnb add DS3Mux L3, L4\r\n    --   05/14/03 pnb add SAM/DSLAM equivalents for TA3xxx shelf types\r\n    --   05/28/03 sls add adTAH4TUCmg\r\n    --   05/29/03 sls add OptiMX VT1.5 & TA300 Quad DS1/Mux to/from Fiber\r\n    --   06/11/03 pnb change symbol for adShared(51) HDSL group (BS, BT, JT)\r\n    --   06/16/03 pnb Added adShared node for adRFC2955, & ProdID for TA3k QFrAtm line card\r\n    --   06/18/03 pnb make Module Identity y2k compliant\r\n    --   07/11/03 sls add adGenAOS node to adShared\r\n\r\n\r\n    -- *** ENSURE ANY UPDATES TO THIS FILE ARE ALSO REFLECTED IN ADTRANTC.MIB ***\r\n\r\n    -- This mmodule of Textual Conventions contains definitions that can be\r\n    --   imported into MIB modules so that independent additions can be made\r\n    --   for new products without affecting existing MIBs.\r\n\r\n\r\n\r\n    -- TYPES\r\n\r\n    -- The first tier (adtran) and second tier (adProducts, adMgmt, adAdmin,\r\n    --   adPerform, adShared) object identifiers are defined in the ADTRAN-MIB module.\r\n\r\n    -- The third tier of adProducts and adMgmt object identifiers are defined\r\n    --   in each product specific MIB in accordance with the enumeration above\r\n    --   of the AdProductIdentifier textual convention type.\r\n\r\n    -- The third tier of adAdmin objects are defined in the ADTRAN-MIB module.\r\n\r\n    -- The third tier of adPerform objects are named here for use in generic\r\n    --   performance statistics MIBs.\r\n\r\n    -- The third tier of adShared objects are named here for use in generic\r\n    --   shared MIBs.\r\n\r\n\r\n    -- The following type defines the third tier of the ADTRAN OID sub-tree,\r\n    --   or specifies where they are defined.\r\n    -- They may be redefined in legacy modules, but the OIDs must mean the same.\r\n\r\n\r\n    -- This type is used to define the product leaves\r\n    --   in the subtree adtran(664).adProduct\r\n\r\n    AdProductIdentifier ::=  TEXTUAL-CONVENTION\r\n      STATUS      current\r\n      DESCRIPTION \" \"\r\n      REFERENCE   \" \"\r\n      SYNTAX   INTEGER { -- use to define all ADTRAN product OIDs\r\n        adADVISOR(1),                  -- ADVISOR SNMP Proxy Agent\r\n        adACTDAX(2),                   -- ACTDAX List 2\r\n        reserved00(3),                 -- Used by the adDS1 DS1 extension MIB for mg only\r\n        adTSU(4),                      -- TSU T1 Mux\r\n        adLIU3(5),                     -- LIU3-PM T1 Line Interface Unit\r\n        adOCUDP(6),                    -- OCUDP-PM / SD4 Channel Unit\r\n        adDDST(7),                     -- DDST-PM DDS Termination Unit\r\n        adDSUDP(8),                    -- DSUDP Channel Unit\r\n        adACTDAXL3(9),                 -- ACTDAX List 3 - ACT1241 Line Interface Unit\r\n        adTSU100(10),                  -- TSU 100 - T1 Multiplexer\r\n        adTSU600(11),                  -- TSU 600\r\n        adLPRPTR(12),                  -- LOOP REPEATER-PM\r\n        adDSU3ARs(13),                 -- DSU III AR (standalone same as shelf MIB)\r\n        adDSU3AR(14),                  -- DSU III AR (shelf)\r\n        adDSU3S4Ws(15),                -- DSU III AR Switch 4 Wire\r\n        adDSU3S4W(16),                 -- DSU III AR Switch 4 Wire (shelf)\r\n        adDSU3DBS4Ws(17),              -- DSU III AR Dial Backup Switch 4 Wire\r\n        adDSU3DBS4W(18),               -- DSU III AR Dial Backup S4W (shelf)\r\n        adDSU3DBS2Ws(19),              -- DSU III AR Dial Backup Switch 2 Wire\r\n        adDSU3DBS2W(20),               -- DSU III AR Dial Backup S2W (shelf)\r\n        adDSU3DBV32s(21),              -- DSU III AR Dial Backup V.32\r\n        adDSU3DBV32(22),               -- DSU III AR Dial Backup V.32 (shelf)\r\n        adDSU3DBISDNs(23),             -- DSU III AR Dial Backup ISDN\r\n        adDSU3DBISDN(24),              -- DSU III AR Dial Backup ISDN (shelf)\r\n        adDSUS2Ws(25),                 -- DSU III Switch 2 Wire\r\n        adOCUDPP(26),                  -- OCUDP-PLUS+ Channel Unit\r\n        adDSUS2W(27),                  -- DSU III Switch 2 Wire (shelf)\r\n        adACT2300BCU(28),              -- ACT2300 Bank Control Unit List 1\r\n        adACT2300LIU(29),              -- ACT2300 Line Interface Unit List 1\r\n        adACT2300OSU(30),              -- ACT2300 Office Support Unit List 1\r\n        adACT2300PWR(31),              -- ACT2300 Power Unit List 1\r\n        adHSU100(32),                  -- HDSL TSU100\r\n        adHSU600(33),                  -- HDSL TSU600\r\n        adSMART16SC(34),               -- Smart 16 Shelf Controller\r\n        adSITEMGR(35),                 -- ACT2300 Site Manager\r\n        adDSU3DBV34(36),               -- DSU III AR Dial Backup V.34 (shelf)\r\n        adDSUCARs(37),                 -- DSU III AR Compression\r\n        adDSUCAR(38),                  --\r\n        adDSUCS4Ws(39),                -- DSU III AR C Switch 4 Wire\r\n        adDSUCS4W(40),                 --\r\n        adDSUCDBS4Ws(41),              -- DSU III AR C Dial Backup Switch 4 Wire\r\n        adDSUCDBS4W(42),               --\r\n        adDSUCDBS2Ws(43),              -- DSU III AR C Dial Backup Switch 2 Wire\r\n        adDSUCDBS2W(44),               --\r\n        adDSUCDBV32s(45),              -- DSU III AR C Dial Backup V.32\r\n        adDSUCDBV32(46),               --\r\n        adDSUCDBISDNs(47),             -- DSU III AR C Dial Backup ISDN\r\n        adDSUCDBISDN(48),              --\r\n        adTDMs(49),                    -- DSU III Time Division Mux (TDM) stand alone\r\n        adTDM(50),                     -- DSU III TDM (shelf)\r\n        adTDMDBS4Ws(51),               -- DSU III TDM Dial Backup Switch 4 Wire\r\n        adTDMDBS4W(52),                -- DSU III TDM Dial Backup S4W (shelf)\r\n        adTDMDBS2Ws(53),               -- DSU III TDM Dial Backup Switch 2 Wire\r\n        adTDMDBS2W(54),                -- DSU III TDM Dial Backup S2W (shelf)\r\n        adTDMDBV32s(55),               -- DSU III TDM Dial Backup V.32\r\n        adTDMDBV32(56),                -- DSU III TDM Dial Backup V.32 (shelf)\r\n        adTDMDBISDNs(57),              -- DSU III TDM Dial Backup ISDN\r\n        adTDMDBISDN(58),               -- DSU III TDM Dial Backup ISDN (shelf)\r\n        adISU128(59),                  -- ISU 128 (shelf)\r\n        adISU2X64(60),                 -- ISU 2 X 64 (shelf)\r\n        adT1CSUACE(61),                -- T1 ESF CSU ACE\r\n        adSMX(62),                     -- SMX RS485 DSU PM channel unit\r\n        adEMTO(63),                    -- EMTO - 4WE&M PM channel unit\r\n        adLIU3PML2(64),                -- LIU3 PM List 2\r\n        adTSURM(65),                   -- TSU RM - SMART16 Shelf card\r\n        adCSURM(66),                   -- CSU RM - SMART16 Shelf card\r\n        adFXS2DPO(67),                 -- D4 analog channel unit\r\n        adFXO2DPT(68),                 -- D4 analog channel unit\r\n        adExpressSL(69),               -- Express SL\r\n        adTSUNXBase(70),               -- Nx56/64 V.35/530\r\n        adTSUNxV35(71),                -- Nx56/64 V.35\r\n        adTSUNx530(72),                -- Nx56/64 530\r\n        adTSUDSX1(73),                 -- DSX-1 Plug In\r\n        adTSUOCU(74),                  -- OCU DP\r\n        adTSUDI(75),                   -- Drop  and Insert\r\n        adTSUFXS(76),                  -- FXS\r\n        adTSUunassign(77),             -- ???????\r\n        adTSUDSX1PO(78),               -- DSX-1 Plug On\r\n        adTSUFXO(79),                  -- FX0\r\n        adTSUDBU(80),                  -- Multi Port DBU\r\n        adTSUNX2(81),                  -- 2nd Gen Nx56/64 V.35/530\r\n        adTSUNX2V35(82),               -- 2nd Gen Nx56/64 V.35\r\n        adTSUNX2530(83),               -- 2nd Gen Nx56/64 530\r\n        adTSUEM(84),                   -- E and M\r\n        adTSUCmprss(85),               -- Compression Card\r\n        adTSUNxBase120(86),            -- Base 120 Nx\r\n        adTSUDsxBase120(87),           -- Base 120 Dsx\r\n        adTSUFXS2(88),                 -- FXS Voice 2\r\n        adTSUNxDBU(89),                -- Nx DBU\r\n        adTSUDsxBase140(90),           -- Base 140 Dsx\r\n        adTSUPassThru(91),             -- Pass Thru\r\n        adTSUMUXAgent(92),             -- Agent\r\n        adTSUNX2DUAL(93),              -- Dual Nx56/64\r\n        adTSUDSUDP(94),                -- Dual DSU III\r\n        adNxDBUTest(95),               -- Nx DBU Test Card\r\n        adTSUDModem(96),               -- Dual V.34 Modem\r\n        adTSUQmodem(97),               -- Quad V.34 Modem\r\n        adTSUDXC(98),                  -- DXC\r\n        adTSUUBrite(99),               -- U Brite\r\n        adTSUNxeBase(100),             -- TSU 1x0e Base Nx56/64\r\n        adTSUDsxBase120e(101),         -- TSU120e Base DSX-1\r\n        adTSUDUALOCU(102),             -- Dual OCU DP\r\n        adTSUNXDBUeBase(103),          -- TSU 1x0e Base NXDBU\r\n        adFXSG2(104),                  -- FXS_Gen2\r\n        adTSU4FXS(105),                -- Quad FXS\r\n        adTSU8FXS(106),                -- Octal FXS\r\n        adTSUNxIQ(107),                -- Nx IQ\r\n        adTSURtr(108),                 -- Router\r\n        adTSUDrop(109),                -- DropPort\r\n        adESUNxBase(110),              -- ESUBaseNx\r\n        adTSU4FXSG2(111),              -- Quad FXS Gen2\r\n        optionCards70to120(120),       -- TSU Mux option cards\r\n        adDS0PM(121),                  -- DS0DP /PM\r\n        adUBRITE(122),                 -- UBRITE /PM\r\n        adISU512(123),                 -- ISU512 standalone unit\r\n        adTSUMUXAGENT(124),            -- TSU Embedded Agent Option card\r\n        adDSUIVESP(125),               -- DSU IV ESP\r\n        adFSU(126),                    -- FSU\r\n        adTSUESP(127),                 -- TSU ESP\r\n        adTSU120(128),                 -- TSU 120\r\n        adTSU600e(129),                -- TSU 600 e\r\n        adTSU120e(130),                -- TSU 120 e\r\n        ad4WEM(131),                   -- 4 Wire E&M\r\n        ad2WEM(132),                   -- 2 Wire E&M\r\n        adESPEtherCard(133),           -- ESP Ethernet Card\r\n        adESPS4WCard(134),             -- ESP S4W DBU Card\r\n        adESPV34Card(135),             -- ESP V34 DBU Card\r\n        adESPISDNCard(136),            -- ESP ISDN DBU Card\r\n        adESPDTECard(137),             -- ESP DTE DBU Card\r\n        adESPDualISDNCard(138),        -- ESP Dual ISDN DBU Card\r\n        adFramePort144(139),           -- D4 FramePort 144\r\n        adFSU5622(140),                -- FSU 5622 ESP\r\n        adDSUIQ(141),                  -- DSU IQ\r\n        adTSU100e(142),                -- TSU 100 with Embedded SNMP\r\n        adATLAS800(143),               -- ATLAS 800 (1200.180L1)\r\n        adCOFRAD(144),                 -- CO FRAD\r\n        adFramePort768(145),           -- D4 FramePort 768\r\n        adBR110Chassis(146),           -- BR 1/10 Chassis used by CO FRAD\r\n        adTSUIQ(147),                  -- TSU IQ\r\n        adExpressL128FR(148),          -- Express L128 Frame Relay    1202.070L1\r\n        adExpressL768(149),            --  Express L768 1202.192L1\r\n        adExpressL15(150),             -- Express L1.5   1202.192L2\r\n        adTotalAccessSCU(151),         -- Total Access SCU (1181.010L1)\r\n        adTotalAccessHTUC(152),        -- Total Access HTU-C (1181.101L1)\r\n        adTDU120E(153),                -- TDU 120 E\r\n        adATLASGen(154),               -- ATLAS Generic\r\n        adATLAS800Plus(155),           -- ATLAS 800Plus (1200.226L1)\r\n        adATLAS1200(156),              -- ATLAS 1200\r\n        adATLASOC(157),                -- ATLAS Generic Option Card\r\n        adATLAST1PRI4OC(158),          -- ATLAS T1PRI4 Option Card (1200.185L1-L3)\r\n        adATLASV35Nx4OC(159),          -- ATLAS V35Nx4 Option Card 1200184L1\r\n        adATLASUBRI8OC(160),           -- ATLAS UBRI8 Option Card 1200186L2\r\n        adATLAST3OC(161),              -- ATLAS T3 Option Card 1200223L1\r\n        adATLASSerialOC(162),          -- ATLAS Serial Option Card 1200182L1\r\n        adATLASModemOC(163),           -- ATLAS Modem Option Card 1200181L1\r\n        adATLASE1OC(164),              -- ATLAS E1 Option Card 1200264L1\r\n        adATLASHDLCOC(165),            -- ATLAS HDLC Option Card 1200222L1\r\n        adATLASCompVoiceOC(166),       -- ATLAS Comp Voice Option Card (1200.221L1 - L4)\r\n        adATLASSyncSerialOC(167),      -- ATLAS Synchronous Serial OC (NO LONGER ACTIVE)\r\n        adESU120e(168),                -- ESU 120e 1200.420L1\r\n        adESU120eHDSL(169),            -- ESU 120e HDSL 1200.421L1\r\n        adT3SU300(170),                -- T3SU-300 1200.217L1\r\n        adBRFP144(171),                -- BR 1/10 FramePort 144\r\n        adBRFP768(172),                -- BR 1/10 FramePort 768\r\n        adBRFP768SP(173),              -- BR 1/10 FramePort 768 SpanPowering\r\n        adT3SUHSSIOC(174),             -- T3SU HSSI Option Card\r\n        adT3SUV35OC(175),              -- T3SU V35 Option Card\r\n        adIQPROBE(176),                -- IQPROBE\r\n        adESPEM(177),                  -- Dual ESP E&M Option Card\r\n        adESPFXO(178),                 -- Dual ESP FXO Option Card\r\n        adESPFXS(179),                 -- Dual ESP FXS Option Card\r\n        adTotalAccessNMI(180),         -- Total Access NMI\r\n        adTADS3MUX(181),               -- Total Access DS3 MUX\r\n        adTotalAccessE1HDSL(182),      -- Total Access E1 HDSL LTU (1181.102L1)\r\n        adT3SUQDSX1OC(183),            -- T3SU Quad DSX1 Option Card\r\n        adTAGenCard(184),              -- Total Access Generic Card\r\n        adTotalAccessHD10(185),        -- Total Access HD10 (1181.200L1)\r\n        adTSUIQPlus(186),              -- TSU IQ+\r\n        adTAQFOC(187),                 -- Total Access Westell Quad Fiber Optic Card\r\n        adTA3000DSX1(188),             -- Total Access 3000 DSX1 Module (1181.050L1)\r\n        adTASTS1Mux(189),              -- Total Access STS1 Mux\r\n        reserved01(190),               -- Total Access STS1 Mux (trap extension)\r\n        adTAT1OR(191),                 -- Total Access Westell T1 Office Repeater\r\n        adTAECU(192),                  -- Total Access E1 External Clock Module\r\n        reserved02(193),               -- Total Access DS3 MUX (trap extension)\r\n        adTAOC3MUX(194),               -- Total Access OC-3 MUX\r\n        adTSU610(195),                 -- TSU 610\r\n        adISU512e(196),                -- ISU 512e\r\n        reserved03(197),               -- Total Access DSX1 module (trap extension)\r\n        adMX2800(198),                 -- MX2800 (T3 Mux)\r\n        adESULT(199),                  -- ESU LT\r\n        adD4DIGROUP(200),              -- Virtual FramePort Controller\r\n        adTAH2TUC(201),                -- Total Access H2TUC for Bell Atl. (1181.111L1)\r\n        adTAHD10E1(202),               -- Total Access HD10 E1 version\r\n        adTADS3MUXL2(203),             -- Total Access DS3 MUX List 2\r\n        adTA850BCU(204),               -- Total Access 850 BCU\r\n        reserved04(205),               -- Total Access OC-3 MUX (trap extension)\r\n        adTRSDSL(206),                 -- D4 TR-SDSL\r\n        adBRTRSDSL(207),               -- BR1/10 TR-SDSL\r\n        adEx6100(208),                 -- Express 6100\r\n        adTAE1LTU(209),                -- Total Access HDSL LTU (1182007L1)\r\n        adTA750BCU(210),               -- Total Access 750 BCU (1175012L1)\r\n        adTAQuadFXS(211),              -- Total Access Quad FXS (1175408L1)\r\n        adTAQuadFXO(212),              -- Total Access Quad FXO (1175407L1)\r\n        adTANx64(213),                 -- Total Access Nx56/64 (1175025L1)\r\n        adTAOCUDP(214),                -- Total Access OCU-DP (1180005L1)\r\n        adTADSODP(215),                -- Total Access DSO-DP (1180003L1)\r\n        adTAUBRITE(216),               -- Total Access U-BRITE (1180020L1)\r\n        adTSUIQRM(217),                -- TSU IQ Smart 16 Rackmount\r\n        adF3SU300(218),                -- NTU-45 (1200.660L1) former name: F3SU-300\r\n        adATLAS550(219),               -- ATLAS 550\r\n        adTALTU45(220),                -- Total Access LTU-45 (1182.033L1)\r\n        adTA1500qLIU(221),             -- TA1500 Quad LIU (1180109L1)\r\n        adTA1500dLIU(222),             -- TA1500 Dual LIU (1180009L1)\r\n        adTA1500SCUrt(223),            -- TA1500 SCU RT w/MLT (1180008L2)\r\n        adTA1500SCUcot(224),           -- TA1500 SCU COT w/MLT (1180008L3)\r\n        adTAEM(225),                   -- TotalAccess E&M (1180402L1)\r\n        adTAFXO(226),                  -- TotalAccess FXO/DPT (1180404L1)\r\n        adTAFXS (227),                 -- TotalAccess FXS (1180403L1)\r\n        adTAqPOTS(228),                -- TotalAccess Quad POTS RT (1180408L1)\r\n        adTA1500SCU(229),              -- TA1500 SCU w/o MLT  (1180008L1)\r\n        adTA1500DualFXS(230),          -- Total Access 1500 Dual FXS (1180208L1)\r\n        adTA1500DualFXO(231),          -- Total Access 1500 Dual FXO (1180207L1)\r\n        adLucentDualOCUDP(232),        -- Lucent Dual OCUDP (1133205L1)\r\n        adLucentDualDS0DP(233),        -- Lucent Dual DS0DP (1133203L1)\r\n        adTASTS1MuxL2(234),            -- Total Access STS1 Mux L2 (1181030L2)\r\n        adTA4303(235),                 -- Total Access 4303 (1200.330L1) chassis\r\n        reserved05(236),               -- Total Access STS1 Mux L2 (trap extension)\r\n        adLucentEM(237),               -- Lucent Dual E&M (1133402L1)\r\n        adTAH2TUCgte(238),             -- Total Access H2TUC for GTE  (1181.111L2)\r\n        adTAH2TUCsbc(239),             -- Total Access H2TUC for SBC (1181.111L4)\r\n        adTAH2TUCclec(240),            -- Total Access H2TUC for CLEC (1181.111L1#C)\r\n        adTA3000eSCU(241),             -- Total Access SCU (1181.018L1)\r\n        adESPPRIdbu(242),              -- ESP PRI DBU Card\r\n        adTA1500DualDSU(243),          -- Total Access 750/1500 Dual DSU DP (1175225L1)\r\n        adTA4303Ctrl(244),             -- TA4303 EN GR303 Controller 1200.334L1\r\n        adTA3000(245),                 -- TA3000  1181.001L1 TA3000 23 inch domestic shelf\r\n        adTA3010(246),                 -- TA3010  1182.003L1 TA3010 19 inch domestic shelf\r\n        adTA3011(247),                 -- TA3011  1182.001L1 Total Access OMP-FC\r\n        adTA3011Mex(248),              -- TA3011   1181.001L1#M Total Access for Mexico\r\n        adTA3012(249),                 -- TA3012  1182.004L1 Total Access 3000 DA\r\n        adTA1500(250),                 -- TA1500  1180.001L1 TA1500 23 inch chassis\r\n        adTA1000(251),                 -- TA1000  1179.001L1 Total Access 1000 OSP housing\r\n        adTA1000COT(252),              -- TA1000   1179.501L1 Total Access 1000 COT chassis\r\n        adTA850(253),                  -- TA850  1200.375L1 Total Access 850 chassis\r\n        adTA750(254),                  -- TA750  1175.001L1 Total Access 750 chassis\r\n        adATLASt3DI(255),              -- ATLAS T3 Drop & Insert module 1200225L1\r\n        adATLASussi(256),              -- ATLAS USSI module (1200.261L1-L4)\r\n        adATLASimux(257),              -- ATLAS IMUX (Nx56/64 Bonding Rsrc) module (1200.262L1)\r\n        adATLAS8DSX(258),              -- ATLAS Octal DSX module 1200317L1\r\n        adATLAS4DSX(259),              -- ATLAS Quad DSX module 1200320L1\r\n        adTA4303QuadDSX(260),          -- TA4303 Quad DSX module 1200331L1\r\n        adTA4303OctalDSX(261),         -- TA4303 Octal DSX module 1200332L1\r\n        adTA4303DS3(262),              -- TA4303 DS3 module 1200333L1\r\n        adTA4303DualDS3(263),          -- TA4303 Dual DS3 module 1200336L1\r\n        adTADS3TSIE1(264),             -- TA 3010 DS3 TSI E1 MUX (1182.020L1) 22 slot\r\n        adTAOC3L2(265),                -- TA 3000 OC-3 MUX L2 1181031L2\r\n        reserved06(266),               -- TA 3000 OC-3 MUX L2 (trap extension)\r\n        reserved07(267),               -- TA 3000 OC-3 MUX L2 (trap extension)\r\n        reserved08(268),               -- TA 3000 OC-3 MUX L2 (trap extension)\r\n        adATLAS550VCom(269),           -- ATLAS 550 VCOM Module - 1200312Lx (x = 1,2,3,5)\r\n        adATLAS550IMux(270),           -- ATLAS 550 IMUX Module - 1200326L1\r\n        adATLAS550T1(271),             -- ATLAS 550 T1 Network Module - 1200307L1\r\n        adATLAS550DualT1(272),         -- ATLAS 550 Dual T1/Pri Module - 1200314L1\r\n        adATLAS550DualNx(273),         -- ATLAS 550  Dual NX Module - 1200311L1\r\n        adATLAS550QuadBRI(274),        -- ATLAS 550 Quad Bri Module - 1200315L1\r\n        adATLAS550OctFXS(275),         -- ATLAS 550 Octal FXS Module - 1200309L1\r\n        adATLAS550OctFXO(276),         -- ATLAS 550 Octal FX0 Module - 1200310L1\r\n        adATLAS550QuadFXS(277),        -- ATLAS 550 Quad FXS Module - 1200328L1\r\n        adATLAS550QuadFXO(278),        -- ATLAS 550 Quad FX0 Module - 1200329L1\r\n        adATLAS550RsrcHost(279),       -- ATLAS 550 Resource Host Module - 1200324L1\r\n        adATLAS550E1(280),             -- ATLAS 550 E1 Network Module - 1200308L1\r\n        adATLAS550EM(281),             -- ATLAS 550 E&M Module - 1200313L1\r\n        adOSU300(282),                 -- OSU 300 - 1200663-L1\r\n        adTAATMMUX(283),               -- Total Access ATM MUX - 1181041L1\r\n        adTA1500DualFXSL2(284),        -- Total Access 1500 Dual FXS/DPT w/o SMAS (1180208L2)\r\n        adTA1500DualFXOL2(285),        -- Total Access 1500 Dual FXO/DPT w/o SMAS (1180207L2)\r\n        adTA3000HTUCICOT(286),         -- Total Access 3000 HTU-C ICOT (1179511L1)\r\n        adTA3000quadDSX1E1(287),       -- Total Access 3000 quad DSX-1/E1 (1181402L1)\r\n        adMX2800STS1(288),             -- MX2800 STS-1 multiplexer (1200659)\r\n        adTA1500dNx64(289),            -- TA1500 Daul Nx56/64 (1180025L1)\r\n        adTA1500DDS4x4(290),           -- TA1500 4x4 DDS (1180106L1)\r\n        adTA1500DDS4x4PO(291),         -- TA1500 4x4 DDS Preferred Option (1180106L2)\r\n        adLucentFXS(292),              -- Lucent FXS (1133406L1)\r\n        adLucentFXO(293),              -- LucentFXO (1133405L1)\r\n        adTA1500EML2(294),             -- TA1500 E&M w/SMAS (1180402L2\r\n        adStratum3Eclock(295),         -- Stratum 3E clock (1181930-L1)\r\n        adTA1500LucentSCU(296),        -- TA1500 Lucent SCU (1133008L4)\r\n        adTA3000qADSL(297),            -- TA3000 Quad ADSL (1181408L1)\r\n        adTA3000OctIDSL(298),          -- TA3000 Octal IDSL (1181.407L1)\r\n        adATLAS890(299),               -- ATLAS 890 (1200.321L1)\r\n        adTA1500FT1dp(300),            -- Total Access 15000 FT1 DP (1180405L1)\r\n        adLucentLIU(301),              -- TA1500 Lucent LIU (1133209L1)\r\n        adTA3000OctIMA(302),           -- TA3000 Octal DS1 IMA (1181.409L1)\r\n        reserved09(303),               -- Total Access ATM MUX  (1181041L1) (trap extension)\r\n        adTADualOCUDP(304),            -- Total Access Dual OCU DP (1180205L1)\r\n        adTADualDSODP(305),            -- Total Access Dual DSO DP (1180203L1)\r\n        adTADualOCUDPL2(306),          -- Total Access Dual OCU DP w/o SMAS (1180205L2)\r\n        adTADualDSODPL2(307),          -- Total Access Dual DSO DP w/o SMAS (1180203L2)\r\n        adTA1500OCUDPoem(308),         -- Total Access 1500 OCU-DP OEM (1133105L1)\r\n        adTA1500OCUDP(309),            -- Total Access 1500 OCU-DP Preferred Option (1180105L2)\r\n        adTA3000qHDSL2(310),           -- TA3000 Quad HDSL2 (1181.404L1)\r\n        adTAGSHDSL(311),               -- Total Access G.SHDSL Single Port (1182008L1)\r\n        adMX2810(312),                 -- MX2810 (1185.002L1)\r\n        adATLAS550PVRM(313),           -- ATLAS 550 Packet Voice Rsrc Module (1200752L1)\r\n        adTA1500M4W(314),              -- TA1500 Multi 4 Wire (1180413L1)\r\n        adTSULTX(315),                 -- TSU LTX (2200250)\r\n        adTA1500DualOCUDPTJ(316),      -- TA 1500 Dual OCU DP w/ Tst Jacks (1180205L3, -L4 & 1133205L3)\r\n        adTA1500DualDSODPTJ(317),      -- TA 1500 Dual DSO DP w/ Tst Jacks (1180203L3, -L4 & 1133203L3)\r\n        adTA3000qGSHDSL(318),          -- TA 3000 G.SHDSL Quad Port (1181403L1#T)\r\n        adTA3000oGSHDSL(319),          -- TA 3000 G.SHDSL Octal Port (1181403L1)  (1181403L2)\r\n        adTA1500d2wTO(320),            -- TA1500 Dual 2-Wire TO w/o SMAS (1180212L2)\r\n        adTA1500d2wTOsmas(321),        -- TA1500 Dual 2-Wire TO w/ SMAS (1180212L1 / 1133212L1)\r\n        adTA1500d2wFXS(322),           -- TA1500 Dual 2-Wire FXS GT w/o SMAS (1180214L2)\r\n        adTA1500d2wFXSsmas(323),       -- TA1500 Dual 2-Wire FXS GT w/ SMAS (1180214L1 / 1133214L1)\r\n        adTA15002wFXO(324),            -- TA1500 2-Wire FXO GT w/o SMAS (1180115L2)\r\n        adTA15002wFXOsmas(325),        -- TA1500 2-Wire FXO GT w/ SMAS (1180115L1 / 1133115L1)\r\n        adTA1500d4wDX(326),            -- TA1500 Dual 4-Wire DX w/o SMAS (1180216L2)\r\n        adTA1500d4wDXsmas(327),        -- TA1500 Dual 4-Wire DX w/ SMAS (1180216L1 / 1133216L1)\r\n        adTA1500d4wFXO(328),           -- TA1500 Dual 4-Wire FXO w/o SMAS (1180217L2)\r\n        adTA1500d4wFXOsmas(329),       -- TA1500 Dual 4-Wire FXO w/ SMAS (1180217L1 / 1133217L1)\r\n        adTA1500d4wFXS(330),           -- TA1500 Dual 4-Wire FXS w/o SMAS (1180218L2)\r\n        adTA1500d4wFXSsmas(331),       -- TA1500 Dual 4-Wire FXS w/ SMAS (1180218L1 / 1133218L1)\r\n        adTA1500DDSdp(332),            -- TA1500 DDS-DP (1180105L1)\r\n        reserved10(333),               -- TA 3000 DS3 TSI E1 MUX (trap extension)\r\n        reserved11(334),               -- TA 3000 DS3 TSI E1 MUX (trap extension)\r\n        adTA3000CES(335),              -- TA 3000 CES module (1181.420L1)\r\n        adIQ710(336),                  -- IQ 710 (1200.800L1)\r\n        adIQ7xxDDS(337),               -- IQ 710 DDS Interface Module (1200.801L1)\r\n        adIQ7xxT1(338),                -- IQ 710 T1 Interface Module (1200.802L1)\r\n        adIQ7xxT1DSX(339),             -- IQ 710 T1-DSX Interface Module (1200.803L1)\r\n        adTA1500LcntUBR1TE(340),       -- TA1500 Lucent UBR1TE (1133120L1)\r\n        adTA3000VCP(341),              -- TA 3000 Voice Cell Processor  (1181410L1)\r\n        adExp6530SHDSL(342),           -- Express 6530 SHDSL NxNTU (1225001L1)\r\n        adTA3000quadE1NTU(343),        -- Total Access 3000 quad E1 w/ NTU mgmt (1181402L1#T)\r\n        adATLAS810(344),               -- ATLAS 810+ AC (1200265L1)\r\n        adTA608(345),                  -- Total Access 608 (T1model)  (1200.680L1)\r\n        adTA3000LTU8(346),             -- Total Access 3000 LTU-8  (1182.300L1)\r\n        reserved12(347),               -- Total Access 3000 LTU-8  (trap extension)\r\n        reserved13(348),               -- Total Access 3000 LTU-8  (trap extension)\r\n        adTANTU8(349),                 -- Total Access NTU-8  (1182.301L1)\r\n        adTA3000DS1FR(350),            -- TA 3000 DS1 Frame Relay (1181.414L1)\r\n        adTASHDSLbnc(351),             -- Total Access SHDSL LTU w/ BNC (1182008L3)\r\n        adTASHDSLv35(352),             -- Total Access SHDSL V.35 LTU (1182008L5)\r\n        adTA3000ALEc(353),             -- TA3000 ADSL Loop Extender, CO Unit (181600L1)\r\n        adTAH2TUCvrzneG2(354),         -- Total Access H2TUC for Versizon East, 2nd Gen (1181112L1)\r\n        adTAH2TUCvrznwG2(355),         -- Total Access H2TUC for Versizon West, 2nd Gen (1181112L2)\r\n        adTAH2TUCmciG2(356),           -- Total Access H2TUC for MCI, 2nd Gen (1181112L3)\r\n        adTAH2TUCsbcG2(357),           -- Total Access H2TUC for SBC, 2nd Gen (1181112L4)\r\n        adTAH2TUCqwestG2(358),         -- Total Access H2TUC for QWEST, 2nd Gen (1181112L5)\r\n        adTAH2TUCbellsG2(359),         -- Total Access H2TUC for BellSouth, 2nd Gen (1181112L6)\r\n        adTA3000HTUCg6(360),           -- Total Access 3000 HTU-C 6th Gen for SBC (1181.106L4)\r\n        adTA3000HTUCg6HLSS(361),       -- Total Access 3000 HTU-C 6th Gen for Qwest (1181.106L5)\r\n        adTADS3TSIE3(362),             -- TA 3000 DS3 TSI E3 MUX 1182021L1\r\n        adTA1000qADSL(363),            -- Total Access 1000 QUAD ADSL            (1179413L1)\r\n        adTA1000qH2LIU(364),           -- Total Access 1000 DSLAM QUAD HDSL2 LIU (1179109L1)\r\n        adTA1000atmBCU(365),           -- Total Access 1000 ATM BCU              (1179112L1)\r\n        adTA1000dslamPSU(366),         -- Total Access 1000 DSLAM PSU            (1179008L1)\r\n        adXprs6503(367),               -- Express 6503  (1200296L1)\r\n        adTA3000HTUCg6BSouth(368),     -- Total Access 3000 HTU-C 6th Gen for BellSouth (1181106L6)\r\n        adTA3000H4TUCL4G1(369),        -- Total Access 3000 H4TUC, 1st Gen (1181411L4)\r\n        adTA3000H4TUCL5G1(370),        -- Total Access 3000 H4TUC, 1st Gen (1181411L5)\r\n        adTA300DS3LM(371),             -- TA 3000 DS3 Line Module (1181450L1)\r\n        adTA300H2TURsprint(372),       -- Total Access 3000 H2TU-R L6 for Sprint (1181126L6)\r\n        adTA1500MCU(373),              -- TA1500 MCU (1180434L1)\r\n        adTA3000BATS(374),             -- TA3000 Broadband ATM Test System (1358007L1)\r\n        adTA1500DDSdpQwest(375),       -- TA1500 TR DDS-DP Qwest Red-Opt (1180105L2#Q)\r\n        adTA3000qSHDSL(376),           -- TA 3000 SHDSL Quad Port (1181423L1)\r\n        adTA3000T1OR(377),             -- TA 3000 T1-OR 1st Gen (1181310L2)\r\n        adTA3000OC3CSM(378),           -- TA 3000 OC3 CSM ATM MUX (1181044L1)\r\n        reserved14(379),               -- TA 3000 OC3 CSM ATM MUX (1181044L1) (trap extension)\r\n        adTA1500DualCoinCot(380),      -- TA 1500 Dual Coin COT (1180432L1)\r\n        adTA1500DualCoinRt(381),       -- TA 1500 Dual Coin RT (1180433L1)\r\n        adATLAS550NxT1hssi(382),       -- ATLAS 550 NxT1 HSSI Module (1200346L1)\r\n        adNV3200(383),                 -- NetVanta 3200 (1200860L1)\r\n        adTASHDSLprot(384),            -- Total Access SHDSL LTU w/ Prot (1182008L6)\r\n        adTA1500qFXOMLT(385),          -- Total Access 1500 quad FXO w/ MLT (1180407L1)\r\n        adTAOC3L3(386),                -- TA OC-3 MUX L3 w/ 2 DS3 drops & 1 DS3 to 28 DS1s (1181031L3)\r\n        reserved15(387),               -- TA OC-3 MUX L3  (1181031L3) trap extension 1\r\n        reserved16(388),               -- TA OC-3 MUX L3  (1181031L3) trap extension 2\r\n        adTA1500EBSCot(389),           -- TA 1500 CO p-phone card (1180430L1)\r\n        adTA1500EBSRt(390),            -- TA 1500 RT p-phone card (1180431L1)\r\n        adIQ710Gen2(391),              -- IQ 710 2nd Gen (1202.800L1)\r\n        adTA3000quadE1(392),           -- Total Access 3000 quad E1 (1181402L1#E)\r\n        adTA1500s4wDX(393),            -- TA1500 Single 4-Wire DX w/o SMAS (1180116L1)\r\n        adTA1500s4wDXsmas(394),        -- TA1500 Single 4-Wire DX w/ SMAS (1180116L2)\r\n        adTA4303PSU(395),              -- TA4303 Power Supply module (1200335L1)\r\n        adATLAS550MdmMgmt(396),        -- ATLAS 550 Modem Management Network Module (1200341L1)\r\n        adATLAS550BriDbu(397),         -- ATLAS 550 BRI DBU Network Interface Module (1200327L1)\r\n        adATLAS550DualUssi(398),       -- ATLAS 550 Dual USSI Module (1200754L1)\r\n        adATLAS550QuadT1(399),         -- ATLAS 550 Quad T1/PRI Module (1200755L1)\r\n        adATLAS550LgcyData(400),       -- ATLAS 550 Legacy Data Module (1200342L1)\r\n        adTA4303STS1(401),             -- TA4303 STS1 module (1200352L1)\r\n        adTADS0TSIMux(402),            -- TA 3000 DS0 TSI MUX (1182022L1)\r\n        adTA4303OctalBRI(403),         -- TA4303 Octal BRI module 1202332L1\r\n        adTA3000IVD(404),              -- TA 3000 Integrated Voice & Data triple wide (1181424L1)\r\n        adATLAS550PbxRsrc(405),        -- ATLAS 550 PBX Resource Module (1200756L1)\r\n        adATLAS550Pots(406),           -- ATLAS 550 Lifeline/POTS Network Module (1200757L1)\r\n        adATLAS550OctDss(407),         -- ATLAS 550 Octal DSS User Module (1200758L1)\r\n        adATLAS550qStBri(408),         -- ATLAS 550 Quad S/T BRI Module (1200764L1)\r\n        adATLAS550NxT1Imux(409),       -- ATLAS 550 NxT1 IMUX Module (1200347L1)\r\n        adATLAS550NxT1hssiL2(410),     -- ATLAS 550 NxT1 HSSI/V.35 Module (1200346L2)\r\n        adMX2810STS1(411),             -- MX2810 STS-1 card (1185004L1)\r\n        adTA3000H4TUCL1G1(412),        -- Total Access 3000 H4TUC, 1st Gen (1181411L1)\r\n        adTA850RCU(413),               -- TA850 RCU (1200376L1)\r\n        adTA3000SHDSLltu15gSp(414),    -- TA 3000 SHDSL LTU Single port, 1.5 Gen (1182108L1)\r\n        adTA3000SHDSLltu15gSpBnc(415), -- TA 3000 SHDSL LTU Single port w/ BNC, 1.5 Gen (1182108L3)\r\n        adTA3000SHDSLltu15gV35Bnc(416),-- TA 3000 SHDSL LTU V.35 w/ BNC 1.5 Gen (1182108L5)\r\n        adTA3000SHDSLltu15gSp11(417),  -- TA 3000 SHDSL LTU Single port w/ 1:1, 1.5 Gen (1182108L6)\r\n        adTA3000SHDSLltu15gSpT(418),   -- TA 3000 SHDSL LTU Single port, 1.5 Gen Telstra (1182108L7)\r\n        adTADSX1(419),                 -- TA 750/850/1500 DSX1 Module (1200.385L1, 2200.385-3)\r\n        adATLASRdntAcPs(420),          -- ATLAS Redundant AC Pwr Supply (1200.220L1)\r\n        adATLASRdntDcPs(421),          -- ATLAS Redundant DC Pwr Supply (1200.316L1)\r\n        adATLAS890Cntrlr(422),         -- ATLAS 890 System Controller (1200.322L1)\r\n        adATLASOctBRI(423),            -- ATLAS Octal S/T BRI Option (1200.343L1)\r\n        adATLAS890AcPs(424),           -- ATLAS 890 AC Power Supply (1200.344L1)\r\n        adATLAS890DcPs(425),           -- ATLAS 890 DC Power Supply (1200.345L1)\r\n        adATLASadpcmRsrc(426),         -- ATLAS ADPCM Resource Module (1200.770L1)\r\n        adATLASNxT1hssi(427),          -- ATLAS NxT1 HSSI/V.35 Option (1200.771L1)\r\n        adATLASNxT1IMUX(428),          -- ATLAS NxT1 IMUX Resource (1200.772L1)\r\n        adATLASvideo(429),             -- ATLAS Video Option (1200.773L1)\r\n        adATLAS830(430),               -- ATLAS 830 (1200.780L1)\r\n        adTA3000H2TucHKT(431),         -- TA 3000 H2TUC for HKT (1181.112L9)\r\n        adTA3000OctADSL(432),          -- TA 3000 octal ADSL (1181.405L1)\r\n        adTAH2TUCvrzneG3(433),         -- TA 3000 H2TUC for Verizon East, 3rd Gen (1181.113L1)\r\n        adTAH2TUCvrznwG3(434),         -- TA 3000 H2TUC for Verizon West, 3rd Gen (1181.113L2)\r\n        adTAH2TUCmciG3(435),           -- TA 3000 H2TUC for MCI, 3rd Gen (1181.113L3)\r\n        adTAH2TUCsbcG3(436),           -- TA 3000 H2TUC for SBC, 3rd Gen (1181.113L4)\r\n        adTAH2TUCqwestG3(437),         -- TA 3000 H2TUC for QWEST, 3rd Gen (1181.113L5)\r\n        adTAH2TUCbellsG3(438),         -- TA 3000 H2TUC for BellSouth, 3rd Gen (1181.113L6)\r\n        adTA3000H2TucHKTG3(439),       -- TA 3000 H2TUC for HKT, 3rd Gen (1181.113L9)\r\n        adTA3000LTU4(440),             -- Total Access 3000 LTU-4  (1181.308L1)\r\n        reserved17(441),               -- Total Access 3000 LTU-4  (trap extension)\r\n        reserved18(442),               -- Total Access 3000 LTU-4  (trap extension)\r\n        adTANTU4(443),                 -- Total Access NTU-4  (1181.307L1)\r\n        adTA4303snmp(444),             -- Total Access 4303 (1200.330L1) chassis w/ full SNMP\r\n        reserved18a(445),              -- was (1181.405L2), moved to 455\r\n        reserved19(446),               -- MX2800 Trap extensions (1204.288L1/L2)\r\n        adTADS3TSIE1L2(447),           -- TA 3000 DS3 TSI E1 MUX (1182.020L2) 28 slot\r\n        adTAH2TUCHlss(448),            -- Total Access H2TUC single port dual circuit (1181.213L1)\r\n        adTA3000H4TUCL1G2(449),        -- Total Access 3000 H4TUC, 2nd Gen (1181.412L1)\r\n        adTA3000H4TUCL4G2(450),        -- Total Access 3000 H4TUC, 2nd Gen (1181.412L4)\r\n        adTA3000H4TUCL5G2(451),        -- Total Access 3000 H4TUC, 2nd Gen (1181.412L5)\r\n        adTA3000CSM128(452),           -- Total Access 3000 128 port Cell Switch Module (1181.041L4)\r\n        adATLAS550DualVideo(453),      -- ATLAS 550 Dual Video Option 1200.765L1)\r\n        adATLAS800octalFxs(454),       -- ATLAS 800 Octal FXS (1200.338L1)\r\n        adTA3000OctADSL2(455),         -- TA 3000 octal ADSL + POTS splitters (1181.405L2)\r\n        adT200SHDSLNTU(456),           -- T200 SHDSL NTU  (1225.035L1)\r\n        adTAT1E1SHDSLLtu(457),         -- Total Access T1/E1 SHDSL LTU  (1182.210L1)\r\n        adTAOPTI3L2(458),              -- Total Access OPTI3L2 (1184.002L2)\r\n        adTA1500s4wFxoSmas(459),       -- TA1500 Single 4-Wire FXO w/  SMAS (1180117L1)\r\n        adTA1500s4wFxoNoSmas(460),     -- TA1500 Single 4-Wire FXO w/o SMAS (1180117L2)\r\n        adTA1500s4wFxsSmas(461),       -- TA1500 Single 4-Wire FXS w/  SMAS (1180118L1)\r\n        adTA1500s4wFxsNoSmas(462),     -- TA1500 Single 4-Wire FXS w/o SMAS (1180118L2)\r\n        adTA1000DualT1E1Liu(463),      -- Total Access 1000 DSLAM DUAL T1/E1 LIU (1179010L1)\r\n        adTA3000CSMcr(464),            -- Total Access 3000 DS3 Cell Switch Module cost reduced (1181.041L2)\r\n        adATLAS550EtherSwitch(465),    -- ATLAS 550 Ethernet Switch Module (1200.766L1)\r\n        adNV3205(466),                 -- NetVanta 3205 (1200870L1)\r\n        adNV3305(467),                 -- NetVanta 3305 (1200880L1)\r\n        adNV3xxxDDS(468),              -- NetVanta 3xxx DDS (1200861L1)\r\n        adNV3xxxT1(469),               -- NetVanta 3xxx T1 (1200862L1)\r\n        adNV3xxxT1Dsx1(470),           -- NetVanta 3xxx T1/Dsx-1 (1200863L1)\r\n        adNV3xxxV90dbu(471),           -- NetVanta 3xxx V.90 DBU (1200864L1)\r\n        adNV3xxxISDNdbu(472),          -- NetVanta 3xxx ISDN DBU (1200865L1)\r\n        adNV3xxxSerial(473),           -- NetVanta 3xxx Serial (1200866L1)\r\n        adNV3xxxSHDSL(474),            -- NetVanta 3xxx SHDSL (1200867L1)\r\n        adTA624(475),                  -- Total Access 624 (4200624L1#ATM & 4200624L1#TDM)\r\n        adTA600R(476),                 -- Total Access 600R Router-Only (4200600L1#TDM)\r\n        adTA1500s4wToSmas(477),        -- TA1500 Single 4-Wire TO w/ SMAS (1180.112L1)\r\n        adTA1500s4wToNoSmas(478),      -- TA1500 Single 4-Wire TO w/o SMAS (1180.112L2)\r\n        adTA3000E1FR(479),             -- TA 3000 E1 Frame Relay (1182.414L1)\r\n        adTA1500s2wFxsGtSmas(480),     -- TA1500 Single 2-Wire FXS/GT w/  SMAS (1180.114L1)\r\n        adTA1500s2wFxsGtNoSmas(481),   -- TA1500 Single 2-Wire FXS/GT w/o SMAS (1180.114L2)\r\n        adTA3000OctDs1E1IMA(482),      -- TA3000 Octal DS1/E1 IMA (1181.409L2)\r\n        adTA3000QuadDs1IMA(483),       -- TA3000 Quad DS1 IMA (1181.409L10)\r\n        adMX2820(484),                 -- MX2820 shelf  19\"        (1186001L1)\r\n        adMX2820M13(485),              -- MX2820 M13 access module (1186002L1)\r\n        adMX2820Scu(486),              -- MX2820 SCU card          (1186003L1)\r\n        adMX2820Clock(487),            -- MX2820 Clock card        (1186004L1)\r\n        adTASHDSL4(488),               -- Total Access SHDSL4 LTU  (1182118L1)\r\n        adTA1500s4wEtoSmas(489),       -- TA1500 Single 4-Wire ETO w/ SMAS (1180.113L1)\r\n        adTA1500s4wEtoNoSmas(490),     -- TA1500 Single 4-Wire ETO w/o SMAS (1180.113L2)\r\n        adTA604(491),                  -- Total Access 604 (T1model)  (1200.641L1)\r\n        adTA612(492),                  -- Total Access 612 (T1model)  (1200.612L1)\r\n        adTA616(493),                  -- Total Access 616 (T1model)  (1200.616L1)\r\n        adMX2820wide(494),             -- MX2820 shelf  23\"        (1186001L2)\r\n        adOptiMXshelf(495),            -- OPTI-MX shelf                            (1184501L1)\r\n        adOptiMXOc3OMM(496),           -- OPTI-MX OC3 Mux                          (1184502L1)\r\n        adOptiMXOc3OMMx1(497),         -- OPTI-MX OC3 Mux Trap Exten               (1184502L1)\r\n        adOptiMXT1E1(498),             -- OPTI-MX DS1 line card (T1/E1)            (1184513L1)\r\n        adOptiMXT1E1x1(499),           -- OPTI-MX DS1 line card (T1/E1) Trap Exten (1184513L1)\r\n        adOptiMXDs3(500),              -- OPTI-MX DS3 line card                    (1184503L1)\r\n        adNV2050(501),                 -- NetVanta 2050 (1202362L1)\r\n        adNV2054(502),                 -- NetVanta 2054 (1202362L2)\r\n        adNV2100(503),                 -- NetVanta 2100 (1202361L1)\r\n        adNV2104(504),                 -- NetVanta 2104 (1202361L2)\r\n        adNV2300(505),                 -- NetVanta 2300 (1202366L1)\r\n        adNV2400(506),                 -- NetVanta 2400 (1202367L1)\r\n        adOptiMXScm(507),              -- OPTI-MX SCM Controller                   (1184500L1)\r\n        adTA1200Shelf(508),            -- TA1200 RDS shelf                                (1179601L1)\r\n        adTA1280Shelfalc(509),         -- TA1280 RDS shelf                      (Alcatel) (1179601L1#A)\r\n        adTA1200QuadIMA(510),          -- TA1200 Quad IMA module \"network card\"           (1179611L1)\r\n        adTA1280QuadIMAalc(511),       -- TA1280 Quad IMA module \"network card\" (Alcatel) (1179611L1#A)\r\n        adTA3000HC(512),               -- TA3000 23 inch domestic High Cap shelf    (1181.001L2)\r\n        adTA3kPCU(513),                -- TA3000 Primary Controller Unit            (1181918L1)\r\n        adTA3kPSM(514),                -- TA3000 Primary Switch Module              (1181041L3)\r\n        adTA3kECU(515),                -- TA3000 Expansion Controller Unit          (1181919L1)\r\n        adTA3kSAM(516),                -- TA3000 Subtending Access Module           (1181046L1)\r\n        adTA3kSCUL2(517),              -- TA3000 System Controller Unit - No FLD    (1181018L2)\r\n        adTA3kH4TUCL1G3(518),          -- TA3000 H4TUC, 3rd Gen (1181.413L1)\r\n        adTA3kH4TUCL4G3(519),          -- TA3000 H4TUC, 3rd Gen (1181.413L4)\r\n        adTA3kH4TUCL5G3(520),          -- TA3000 H4TUC, 3rd Gen (1181.413L5)\r\n        adTA3kSCUL3(521),              -- TA3000 System Controller Unit - No FCD, w/Inband (1181018L3)\r\n        adTA1500d4wEtoSmas(522),       -- TA1500 Dual 4-Wire ETO w/ SMAS (1180.213L1)\r\n        adTA1500d4wEtoNoSmas(523),     -- TA1500 Dual 4-Wire ETO w/o SMAS (1180.213L2)\r\n        adTA1500UBRITE(524),           -- TA1500 U-BRITE w/PWR (1180020L2)\r\n        adNV1224(525),                 -- NetVanta 1224 (1200500L1)\r\n        adNV1224ST(526),               -- NetVanta 1224ST (1200500L2)\r\n        adATLAS550Nx(527),             -- ATLAS 550 NX Module - 1200349L1\r\n        adTA3KoADSLCwEta(528),         -- TA 3000 octal ADSL-C w/ ETA               (1181.425L2)\r\n        adATLAS550DualFXO(529),        -- ATLAS 550 Dual FX0 Module - 1200349L1\r\n        adTA1500dFXOGT(530),           -- TA1500 Dual FXO GT w/o SMAS (1180215L2)\r\n        adTA1500dFXOGTsmas(531),       -- TA1500 Dual FXO GT w/ SMAS  (1180215L1)\r\n        adTA1500dFXOGTLuc(532),        -- Dual FXO GT                 (1133215L1)\r\n        adOptiMXOc12OMM(533),          -- OPTI-MX OC12 Mux            (1184504L1)\r\n        adTA1500s4wTdmSmas(534),       -- TA1500 4-Wire TDM w/  SMAS  (1180119L1)\r\n        adTA1500s4wTdm(535),           -- TA1500 4-Wire TDM w/o SMAS  (1180119L2)\r\n        adOptiSMXshelf(536),           -- OPTI-SMX shelf              (1184514L1)\r\n        adTA1200ADSL(537),             -- TA1200 24 port ADSL module            (1179601L1)  Same ID as shelf\r\n        adTA1280ADSLalc(538),          -- TA1280 24 port ADSL module  (Alcatel) (1179601L1#A)Same ID as shelf\r\n        adTADS3MUXL3(539),             -- Total Access DS3 MUX List 3 (1181020L3)\r\n        adTADS3MUXL4(540),             -- Total Access DS3 MUX List 4 (1181020L4)\r\n        adTA3000SAM(541),              -- TA3000  1181.001L1    TA3000 23 inch domestic shelf          SAM/DSLAM\r\n        adTA3010SAM(542),              -- TA3010  1182.003L1    TA3010 19 inch domestic shelf          SAM/DSLAM\r\n        adTA3011SAM(543),              -- TA3011  1182.001L1    Total Access OMP-FC                    SAM/DSLAM\r\n        adTA3011MexSAM(544),           -- TA3011  1181.001L1#M  Total Access for Mexico                SAM/DSLAM\r\n        adTA3012SAM(545),              -- TA3012  1182.004L1    Total Access 3000 DA                   SAM/DSLAM\r\n        adTA3000HCSAM(546),            -- TA3000  1181.001L2    TA3000 23 inch domestic High Cap shelf SAM/DSLAM\r\n        adOptiMXVT15(547),             -- OPTI-MX VT1.5 line card               (1184515L1)\r\n        adOptiMXVT15x1(548),           -- OPTI-MX VT1.5 line card Trap Exten    (1184515L1)\r\n        adTA3kQDFC(549),               -- TA3000 QDFC, Quad DS1/Mux to Fiber           (1181308L4)\r\n        adTA3kQDFCx1(550),             -- TA3000 QDFC, Quad DS1/Mux to Fiber Trap Ext. (1181308L4)\r\n        adTA3kQDFR(551),               -- TA3000 QDFR, Fiber to Quad DS1/Mux           (1181307L4)\r\n        adTA3kQuadFrAtm(552),          -- TA3000 Quad E1/DSX1 Frame Relay/ATM          (1181415L1)\r\n        adNV1524ST(760),               -- NetVanta 1524ST (1200560L1)\r\n\r\n                      -- GAP HERE TO BE MANUALLY FILLED IN UNTIL FILLED\r\n        adUnknown(999)                 -- Any unresponsive or unrecognizable card actually detectable\r\n}\r\n\r\n   -- These identifiers are used to define the product leaves\r\n   --   in the subtree adtran(664).adPerform(4)\r\n\r\n    AdPerformance ::= TEXTUAL-CONVENTION\r\n      STATUS      current\r\n      DESCRIPTION \" \"\r\n      REFERENCE   \" \"\r\n      SYNTAX INTEGER { -- use to define all ADTRAN performance OIDs\r\n        adFRPerformmg (1),\r\n        adL3Performmg (2)\r\n        }\r\n\r\n    -- These identifiers are used to define the product leaves\r\n    --   in the subtree adtran(664).adShared(5)\r\n\r\n    AdSharedCommon ::= TEXTUAL-CONVENTION\r\n      STATUS      current\r\n      DESCRIPTION \" \"\r\n      REFERENCE   \" \"\r\n      SYNTAX INTEGER { -- use to define all ADTRAN shared OIDs\r\n        adExLan(1),\r\n        adFRHistory(2),\r\n        adEOCxxx(3),\r\n        adTARouterGroup(4),\r\n        adFXOcommon(5),\r\n        adNx64common(6),\r\n        adOCUDPcommon(7),\r\n        adDSODPcommon(8),\r\n        adUBRITEcommon(9),\r\n        adFXScommon(10),\r\n        adPRI(11),\r\n        adXSUIQEXTmg(12),\r\n        adGenericShelves(13),\r\n        adH2TUCcommon(14),\r\n        adENDgenChassis(15),\r\n        adTrapInform(16),\r\n        adSCUCommon(17),\r\n        adEandMcommon(18),\r\n        adGenVoice(19),\r\n        adGenLIU(20),\r\n        adDSX1Common(21),\r\n        adTA1500SCUCommon(22),\r\n        adPSUcommon(23),\r\n        adGenSHDSL(24),\r\n        adTARouterTraps(25),\r\n        adTracerCommon(26),\r\n        adExp653x(27),\r\n        adTASHDSLSP(28),\r\n        adDSX1CommonTraps(29),  -- extends adDSX1Common for traps\r\n        adunit(30),\r\n        adH4TUCcommon(31),\r\n        adIadSysMib(32),\r\n        adIadRouter(33),\r\n        adIadVoice(34),\r\n        adGenOPTI3(35),\r\n        adGenAtm(36),\r\n        ad4WCommon(37),\r\n        adDXCommon(38),\r\n        adGTCommon(39),\r\n        adGenOPTI3Traps(40),\r\n        adgenDSX1FR(41),\r\n        adTa6xx(42),\r\n        adIadIwf(43),\r\n        adGen654x(44),\r\n        adGenSHDSL4(45),\r\n        adMCUcommon(46),\r\n        adTA1500FT1common(47),\r\n        adGenOMMX(48),\r\n        adGenOMMXTraps(49),\r\n        adGenOptical(50),      -- Phoenix (JV)\r\n        adGenHDSL(51),         -- HDSL (BS, BT, JT)\r\n        adRfc2955FrAtm(52),    -- CND (DC)\r\n        adGenAOS(53)\r\n        }\r\n\r\n    -- A type to define occupancy of a slot (real or virtual)\r\n\r\n    AdPresence ::= TEXTUAL-CONVENTION\r\n      STATUS      current\r\n      DESCRIPTION \" \"\r\n      REFERENCE   \" \"\r\n      SYNTAX  INTEGER {   -- used to reflect occupancy status\r\n        empty(1),         -- not occupied and not reserved\r\n        virtual(2),       -- empty, but was, or is\r\n                          --   preprovisioned (optional)\r\n        occupied(3)       -- occupied with designated type\r\n        }\r\n\r\n\r\n    -- A type to define alarm severities\r\n\r\n    AdAlarmSeverity ::= TEXTUAL-CONVENTION\r\n      STATUS      current\r\n      DESCRIPTION \" \"\r\n      REFERENCE   \" \"\r\n      SYNTAX INTEGER {    -- A type to define alarm severities\r\n        informational(1),\r\n        warning(2),\r\n        minor(3),\r\n        major(4),\r\n        critical(5)\r\n        }\r\n\r\n    -- A type for dynamic row creation, maintenance, and deletion\r\n\r\n    EntryStatus ::= TEXTUAL-CONVENTION\r\n      STATUS      current\r\n      DESCRIPTION \" \"\r\n      REFERENCE   \" \"\r\n      SYNTAX INTEGER {    -- used to dynamically manage rows\r\n        valid(1),         -- row exists, or command\r\n                          --   to signal row complete\r\n        createRequest(2), -- command to insert row\r\n        underCreation(3), -- status upon creation if interim\r\n        invalid(4)        -- command to delete row\r\n        }\r\n\r\n    -- Table algorithm from rfc1757 RMON-MIB:\r\n\r\n              --   EntryStatus ::= INTEGER\r\n              --           { valid(1),\r\n              --             createRequest(2),\r\n              --             underCreation(3),\r\n              --             invalid(4)\r\n              --           }\r\n              -- The status of a table entry.\r\n              --\r\n              -- Setting this object to the value invalid(4) has the\r\n              -- effect of invalidating the corresponding entry.\r\n              -- That is, it effectively disassociates the mapping\r\n              -- identified with said entry.\r\n              -- It is an implementation-specific matter as to whether\r\n              -- the agent removes an invalidated entry from the table.\r\n              -- Accordingly, management stations must be prepared to\r\n              -- receive tabular information from agents that\r\n              -- corresponds to entries currently not in use.  Proper\r\n              -- interpretation of such entries requires examination\r\n              -- of the relevant EntryStatus object.\r\n              --\r\n              -- An existing instance of this object cannot be set to\r\n              -- createRequest(2).  This object may only be set to\r\n              -- createRequest(2) when this instance is created.  When\r\n              -- this object is created, the agent may wish to create\r\n              -- supplemental object instances with default values\r\n              -- to complete a conceptual row in this table.  Because\r\n              -- the creation of these default objects is entirely at\r\n              -- the option of the agent, the manager must not assume\r\n              -- that any will be created, but may make use of any that\r\n              -- are created. Immediately after completing the create\r\n              -- operation, the agent must set this object to\r\n              -- underCreation(3).\r\n              --\r\n              -- When in the underCreation(3) state, an entry is\r\n              -- allowed to exist in a possibly incomplete, possibly\r\n              -- inconsistent state, usually to allow it to be\r\n              -- modified in mutiple PDUs.  When in this state, an\r\n              -- entry is not fully active.  Entries shall exist in\r\n              -- the underCreation(3) state until the management\r\n              -- station is finished configuring the entry and sets\r\n              -- this object to valid(1) or aborts, setting this\r\n              -- object to invalid(4).  If the agent determines that\r\n              -- an entry has been in the underCreation(3) state for\r\n              -- an abnormally long time, it may decide that the\r\n              -- management station has crashed.  If the agent makes\r\n              -- this decision, it may set this object to invalid(4)\r\n              -- to reclaim the entry.  A prudent agent will\r\n              -- understand that the management station may need to\r\n              -- wait for human input and will allow for that\r\n              -- possibility in its determination of this abnormally\r\n              -- long period.\r\n              --\r\n              -- An entry in the valid(1) state is fully configured and\r\n              -- consistent and fully represents the configuration or\r\n              -- operation such a row is intended to represent.  For\r\n              -- example, it could be a statistical function that is\r\n              -- configured and active, or a filter that is available\r\n              -- in the list of filters processed by the packet capture\r\n              -- process.\r\n              --\r\n              -- A manager is restricted to changing the state of an\r\n              -- entry in the following ways:\r\n              --\r\n              --                       create   under\r\n              --      To:       valid  Request  Creation  invalid\r\n              -- From:\r\n              -- valid             OK       NO        OK       OK\r\n              -- createRequest    N/A      N/A       N/A      N/A\r\n              -- underCreation     OK       NO        OK       OK\r\n              -- invalid           NO       NO        NO       OK\r\n              -- nonExistent       NO       OK        NO       OK\r\n              --\r\n              -- In the table above, it is not applicable to move the\r\n              -- state from the createRequest state to any other\r\n              -- state because the manager will never find the\r\n              -- variable in that state.  The nonExistent state is\r\n              -- not a value of the enumeration, rather it means that\r\n              -- the entryStatus variable does not exist at all.\r\n              --\r\n              -- An agent may allow an entryStatus variable to change\r\n              -- state in additional ways, so long as the semantics\r\n              -- of the states are followed.  This allowance is made\r\n              -- to ease the implementation of the agent and is made\r\n              -- despite the fact that managers should never\r\n              -- excercise these additional state transitions.\r\n\r\n    END\r\n'),(6,'AGENTX-MIB',1756979642,1756979642,1,'','AGENTX-MIB DEFINITIONS ::= BEGIN\nIMPORTS\n MODULE-IDENTITY, OBJECT-TYPE, Unsigned32, mib-2\n    FROM SNMPv2-SMI\n SnmpAdminString\n    FROM SNMP-FRAMEWORK-MIB\n MODULE-COMPLIANCE, OBJECT-GROUP\n    FROM SNMPv2-CONF\n TEXTUAL-CONVENTION, TimeStamp, TruthValue, TDomain\n    FROM SNMPv2-TC;\nagentxMIB MODULE-IDENTITY\n LAST-UPDATED \"200001100000Z\" -- Midnight 10 January 2000\n ORGANIZATION \"AgentX Working Group\"\n CONTACT-INFO \"WG-email:   agentx@dorothy.bmc.com\n               Subscribe:  agentx-request@dorothy.bmc.com\n               WG-email Archive:  ftp://ftp.peer.com/pub/agentx/archives\n               FTP repository:  ftp://ftp.peer.com/pub/agentx\n               http://www.ietf.org/html.charters/agentx-charter.html\n               Chair:      Bob Natale\n                           ACE*COMM Corporation\n               Email:      bnatale@acecomm.com\n               WG editor:  Mark Ellison\n                           Ellison Software Consulting, Inc.\n               Email:      ellison@world.std.com\n               Co-author:  Lauren Heintz\n                           Cisco Systems,\n               EMail:      lheintz@cisco.com\n               Co-author:  Smitha Gudur\n                           Independent Consultant\n               Email:      sgudur@hotmail.com\n              \"\n DESCRIPTION    \"This is the MIB module for the SNMP Agent Extensibility\n     Protocol (AgentX).  This MIB module will be implemented by\n     the master agent.\n    \"\n  REVISION     \"200001100000Z\" -- Midnight 10 January 2000\n DESCRIPTION\n    \"Initial version published as RFC 2742.\"\n  ::= { mib-2  74 }\n -- Textual Conventions\n AgentxTAddress ::= TEXTUAL-CONVENTION\n   STATUS       current\n   DESCRIPTION\n     \"Denotes a transport service address.  This is identical to\n      the TAddress textual convention (SNMPv2-SMI) except that\n      zero-length values are permitted.\n     \"\n   SYNTAX       OCTET STRING (SIZE (0..255))\n -- Administrative assignments\n agentxObjects OBJECT IDENTIFIER      ::= { agentxMIB 1 }\n agentxGeneral OBJECT IDENTIFIER      ::= { agentxObjects 1 }\n agentxConnection OBJECT IDENTIFIER   ::= { agentxObjects 2 }\n agentxSession OBJECT IDENTIFIER      ::= { agentxObjects 3 }\n agentxRegistration OBJECT IDENTIFIER ::= { agentxObjects 4 }\n agentxDefaultTimeout OBJECT-TYPE\n  SYNTAX      INTEGER (0..255)\n  UNITS       \"seconds\"\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The default length of time, in seconds, that the master\n      agent should allow to elapse after dispatching a message\n      to a session before it regards the subagent as not\n      responding.  This is a system-wide value that may\n      override the timeout value associated with a particular\n      session (agentxSessionTimeout) or a particular registered\n      MIB region (agentxRegTimeout).  If the associated value of\n      agentxSessionTimeout and agentxRegTimeout are zero, or\n      impractical in accordance with implementation-specific\n      procedure of the master agent, the value represented by\n      this object will be the effective timeout value for the\n      master agent to await a response to a dispatch from a\n      given subagent.\n     \"\n  DEFVAL      { 5 }\n  ::= { agentxGeneral 1 }\n agentxMasterAgentXVer OBJECT-TYPE\n  SYNTAX      INTEGER (1..255)\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The AgentX protocol version supported by this master agent.\n      The current protocol version is 1.  Note that the master agent\n      must also allow interaction with earlier version subagents.\n     \"\n  ::= { agentxGeneral 2 }\n --      The AgentX Subagent Connection Group\n agentxConnTableLastChange OBJECT-TYPE\n  SYNTAX      TimeStamp\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The value of sysUpTime when the last row creation or deletion\n      occurred in the agentxConnectionTable.\n     \"\n  ::= { agentxConnection 1 }\n agentxConnectionTable OBJECT-TYPE\n   SYNTAX      SEQUENCE OF AgentxConnectionEntry\n   MAX-ACCESS  not-accessible\n   STATUS      current\n   DESCRIPTION\n     \"The agentxConnectionTable tracks all current AgentX transport\n      connections.  There may be zero, one, or more AgentX sessions\n      carried on a given AgentX connection.\n     \"\n   ::= { agentxConnection 2 }\n agentxConnectionEntry OBJECT-TYPE\n   SYNTAX      AgentxConnectionEntry\n   MAX-ACCESS  not-accessible\n   STATUS      current\n   DESCRIPTION\n     \"An agentxConnectionEntry contains information describing a\n      single AgentX transport connection.  A connection may be\n      used to support zero or more AgentX sessions.  An entry is\n      created when a new transport connection is established,\n      and is destroyed when the transport connection is terminated.\n     \"\n   INDEX { agentxConnIndex }\n   ::= { agentxConnectionTable 1 }\n AgentxConnectionEntry ::= SEQUENCE {\n          agentxConnIndex            Unsigned32,\n          agentxConnOpenTime         TimeStamp,\n          agentxConnTransportDomain  TDomain,\n          agentxConnTransportAddress AgentxTAddress }\n agentxConnIndex OBJECT-TYPE\n   SYNTAX       Unsigned32 (1..4294967295)\n   MAX-ACCESS   not-accessible\n   STATUS       current\n   DESCRIPTION\n     \"agentxConnIndex contains the value that uniquely identifies\n      an open transport connection used by this master agent\n      to provide AgentX service.  Values of this index should\n      not be re-used.  The value assigned to a given transport\n      connection is constant for the lifetime of that connection.\n     \"\n   ::= { agentxConnectionEntry 1 }\n agentxConnOpenTime OBJECT-TYPE\n   SYNTAX       TimeStamp\n   MAX-ACCESS   read-only\n   STATUS       current\n   DESCRIPTION\n     \"The value of sysUpTime when this connection was established\n      and, therefore, its value when this entry was added to the table.\n     \"\n   ::= { agentxConnectionEntry 2 }\n agentxConnTransportDomain OBJECT-TYPE\n   SYNTAX       TDomain\n   MAX-ACCESS   read-only\n   STATUS       current\n   DESCRIPTION\n     \"The transport protocol in use for this connection to the\n      subagent.\n     \"\n   ::= { agentxConnectionEntry 3 }\n agentxConnTransportAddress OBJECT-TYPE\n   SYNTAX       AgentxTAddress\n   MAX-ACCESS   read-only\n   STATUS       current\n   DESCRIPTION\n     \"The transport address of the remote (subagent) end of this\n      connection to the master agent.  This object may be zero-length\n      for unix-domain sockets (and possibly other types of transport\n      addresses) since the subagent need not bind a filename to its\n      local socket.\n     \"\n   ::= { agentxConnectionEntry 4 }\n -- The AgentX Subagent Session Group\n agentxSessionTableLastChange OBJECT-TYPE\n  SYNTAX      TimeStamp\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The value of sysUpTime when the last row creation or deletion\n      occurred in the agentxSessionTable.\n     \"\n  ::= { agentxSession 1 }\n agentxSessionTable OBJECT-TYPE\n  SYNTAX      SEQUENCE OF AgentxSessionEntry\n  MAX-ACCESS  not-accessible\n  STATUS      current\n  DESCRIPTION\n     \"A table of AgentX subagent sessions currently in effect.\n     \"\n  ::= { agentxSession 2 }\n agentxSessionEntry OBJECT-TYPE\n  SYNTAX      AgentxSessionEntry\n  MAX-ACCESS  not-accessible\n  STATUS      current\n  DESCRIPTION\n     \"Information about a single open session between the AgentX\n      master agent and a subagent is contained in this entry.  An\n      entry is created when a new session is successfully established\n      and is destroyed either when the subagent transport connection\n      has terminated or when the subagent session is closed.\n     \"\n  INDEX       { agentxConnIndex, agentxSessionIndex }\n  ::= { agentxSessionTable 1 }\n AgentxSessionEntry ::= SEQUENCE {\n  agentxSessionIndex         Unsigned32,\n  agentxSessionObjectID      OBJECT IDENTIFIER,\n  agentxSessionDescr         SnmpAdminString,\n  agentxSessionAdminStatus   INTEGER,\n  agentxSessionOpenTime      TimeStamp,\n  agentxSessionAgentXVer     INTEGER,\n  agentxSessionTimeout       INTEGER\n }\n agentxSessionIndex OBJECT-TYPE\n  SYNTAX      Unsigned32 (0..4294967295)\n  MAX-ACCESS  not-accessible\n  STATUS      current\n  DESCRIPTION\n     \"A unique index for the subagent session.  It is the same as\n      h.sessionID defined in the agentx header.  Note that if\n      a subagent\'s session with the master agent is closed for\n      any reason its index should not be re-used.\n      A value of zero(0) is specifically allowed in order\n      to be compatible with the definition of h.sessionId.\n     \"\n  ::= { agentxSessionEntry 1 }\n agentxSessionObjectID OBJECT-TYPE\n  SYNTAX      OBJECT IDENTIFIER\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"This is taken from the o.id field of the agentx-Open-PDU.\n      This attribute will report a value of \'0.0\' for subagents\n      not supporting the notion of an AgentX session object\n      identifier.\n     \"\n  ::= { agentxSessionEntry 2 }\n agentxSessionDescr OBJECT-TYPE\n  SYNTAX      SnmpAdminString\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"A textual description of the session.  This is analogous to\n      sysDescr defined in the SNMPv2-MIB in RFC 1907 [19] and is\n      taken from the o.descr field of the agentx-Open-PDU.\n      This attribute will report a zero-length string value for\n      subagents not supporting the notion of a session description.\n     \"\n  ::= { agentxSessionEntry 3 }\n agentxSessionAdminStatus OBJECT-TYPE\n  SYNTAX      INTEGER {\n                 up(1),\n                 down(2)\n              }\n  MAX-ACCESS  read-write\n  STATUS      current\n  DESCRIPTION\n     \"The administrative (desired) status of the session.  Setting\n      the value to \'down(2)\' closes the subagent session (with c.reason\n      set to \'reasonByManager\').\n     \"\n  ::= { agentxSessionEntry 4 }\n agentxSessionOpenTime OBJECT-TYPE\n  SYNTAX      TimeStamp\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The value of sysUpTime when this session was opened and,\n      therefore, its value when this entry was added to the table.\n     \"\n  ::= { agentxSessionEntry 5 }\n agentxSessionAgentXVer OBJECT-TYPE\n  SYNTAX      INTEGER (1..255)\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The version of the AgentX protocol supported by the\n      session.  This must be less than or equal to the value of\n      agentxMasterAgentXVer.\n     \"\n  ::= { agentxSessionEntry 6 }\n agentxSessionTimeout OBJECT-TYPE\n  SYNTAX     INTEGER (0..255)\n  UNITS      \"seconds\"\n  MAX-ACCESS read-only\n  STATUS     current\n  DESCRIPTION\n     \"The length of time, in seconds, that a master agent should\n      allow to elapse after dispatching a message to this session\n      before it regards the subagent as not responding.  This value\n      is taken from the o.timeout field of the agentx-Open-PDU.\n      This is a session-specific value that may be overridden by\n      values associated with the specific registered MIB regions\n      (see agentxRegTimeout). A value of zero(0) indicates that\n      the master agent\'s default timeout value should be used\n      (see agentxDefaultTimeout).\n     \"\n  ::= { agentxSessionEntry 7 }\n -- The AgentX Registration Group\n agentxRegistrationTableLastChange OBJECT-TYPE\n  SYNTAX      TimeStamp\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The value of sysUpTime when the last row creation or deletion\n      occurred in the agentxRegistrationTable.\n     \"\n  ::= { agentxRegistration 1 }\n agentxRegistrationTable OBJECT-TYPE\n  SYNTAX      SEQUENCE OF AgentxRegistrationEntry\n  MAX-ACCESS  not-accessible\n  STATUS      current\n  DESCRIPTION\n     \"A table of registered regions.\n     \"\n  ::= { agentxRegistration 2 }\n agentxRegistrationEntry OBJECT-TYPE\n  SYNTAX      AgentxRegistrationEntry\n  MAX-ACCESS  not-accessible\n  STATUS      current\n  DESCRIPTION\n     \"Contains information for a single registered region.  An\n      entry is created when a session  successfully registers a\n      region and is destroyed for any of three reasons: this region\n      is unregistered by the session, the session is closed,\n      or the subagent connection is closed.\n     \"\n  INDEX       { agentxConnIndex, agentxSessionIndex, agentxRegIndex }\n  ::= { agentxRegistrationTable 1 }\n AgentxRegistrationEntry ::= SEQUENCE {\n  agentxRegIndex           Unsigned32,\n  agentxRegContext         OCTET STRING,\n  agentxRegStart           OBJECT IDENTIFIER,\n  agentxRegRangeSubId      Unsigned32,\n  agentxRegUpperBound      Unsigned32,\n  agentxRegPriority        Unsigned32,\n  agentxRegTimeout         INTEGER,\n  agentxRegInstance        TruthValue }\n agentxRegIndex OBJECT-TYPE\n  SYNTAX      Unsigned32 (1..4294967295)\n  MAX-ACCESS  not-accessible\n  STATUS      current\n  DESCRIPTION\n     \"agentxRegIndex uniquely identifies a registration entry.\n      This value is constant for the lifetime of an entry.\n     \"\n  ::= { agentxRegistrationEntry 1 }\n agentxRegContext OBJECT-TYPE\n  SYNTAX      OCTET STRING\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The context in which the session supports the objects in this\n      region.  A zero-length context indicates the default context.\n     \"\n  ::= { agentxRegistrationEntry 2 }\n agentxRegStart OBJECT-TYPE\n  SYNTAX      OBJECT IDENTIFIER\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The starting OBJECT IDENTIFIER of this registration entry.  The\n      session identified by agentxSessionIndex implements objects\n      starting at this value (inclusive).  Note that this value could\n      identify an object type, an object instance, or a partial object\n      instance.\n     \"\n  ::= { agentxRegistrationEntry 3 }\n agentxRegRangeSubId OBJECT-TYPE\n  SYNTAX      Unsigned32\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"agentxRegRangeSubId is used to specify the range.  This is\n      taken from r.region_subid in the registration PDU.  If the value\n      of this object is zero, no range is specified.  If it is non-zero,\n      it identifies the `nth\' sub-identifier in r.region for which\n      this entry\'s agentxRegUpperBound value is substituted in the\n      OID for purposes of defining the region\'s upper bound.\n     \"\n  ::= { agentxRegistrationEntry 4 }\n agentxRegUpperBound OBJECT-TYPE\n  SYNTAX      Unsigned32\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n    \"agentxRegUpperBound represents the upper-bound sub-identifier in\n     a registration.  This is taken from the r.upper_bound in the\n     registration PDU.  If agentxRegRangeSubid (r.region_subid) is\n     zero, this value is also zero and is not used to define an upper\n     bound for this registration.\n    \"\n  ::= { agentxRegistrationEntry 5 }\n agentxRegPriority OBJECT-TYPE\n  SYNTAX      Unsigned32\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The registration priority.  Lower values have higher priority.\n      This value is taken from r.priority in the register PDU.\n      Sessions should use the value of 127 for r.priority if a\n      default value is desired.\n     \"\n  ::= { agentxRegistrationEntry 6 }\n agentxRegTimeout OBJECT-TYPE\n  SYNTAX      INTEGER (0..255)\n  UNITS       \"seconds\"\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The timeout value, in seconds, for responses to\n      requests associated with this registered MIB region.\n      A value of zero(0) indicates the default value (indicated\n      by by agentxSessionTimeout or agentxDefaultTimeout) is to\n      be used.  This value is taken from the r.timeout field of\n      the agentx-Register-PDU.\n     \"\n  ::= { agentxRegistrationEntry 7 }\n agentxRegInstance OBJECT-TYPE\n  SYNTAX      TruthValue\n  MAX-ACCESS  read-only\n  STATUS      current\n  DESCRIPTION\n     \"The value of agentxRegInstance is `true\' for\n      registrations for which the INSTANCE_REGISTRATION\n      was set, and is `false\' for all other registrations.\n     \"\n  ::= { agentxRegistrationEntry 8 }\n -- Conformance Statements for AgentX\n agentxConformance     OBJECT IDENTIFIER ::= { agentxMIB 2 }\n agentxMIBGroups       OBJECT IDENTIFIER ::= { agentxConformance 1 }\n agentxMIBCompliances  OBJECT IDENTIFIER ::= { agentxConformance 2 }\n -- Compliance Statements for AgentX\n agentxMIBCompliance MODULE-COMPLIANCE\n  STATUS      current\n  DESCRIPTION\n     \"The compliance statement for SNMP entities that implement the\n      AgentX protocol.  Note that a compliant agent can implement all\n      objects in this MIB module as read-only.\n     \"\n  MODULE -- this module\n     MANDATORY-GROUPS  { agentxMIBGroup }\n     OBJECT agentxSessionAdminStatus\n        MIN-ACCESS read-only\n        DESCRIPTION\n           \"Write access is not required.\n           \"\n  ::= { agentxMIBCompliances 1 }\n agentxMIBGroup OBJECT-GROUP\n  OBJECTS {\n     agentxDefaultTimeout,\n     agentxMasterAgentXVer,\n     agentxConnTableLastChange,\n     agentxConnOpenTime,\n     agentxConnTransportDomain,\n     agentxConnTransportAddress,\n     agentxSessionTableLastChange,\n     agentxSessionTimeout,\n     agentxSessionObjectID,\n     agentxSessionDescr,\n     agentxSessionAdminStatus,\n     agentxSessionOpenTime,\n     agentxSessionAgentXVer,\n     agentxRegistrationTableLastChange,\n     agentxRegContext,\n     agentxRegStart,\n     agentxRegRangeSubId,\n     agentxRegUpperBound,\n     agentxRegPriority,\n     agentxRegTimeout,\n     agentxRegInstance\n    }\n  STATUS      current\n  DESCRIPTION\n     \"All accessible objects in the AgentX MIB.\n     \"\n  ::= { agentxMIBGroups 1 }\n END\n'),(7,'ALCATEL-IND1-BASE',1756979642,1756979642,1,'','ALCATEL-IND1-BASE DEFINITIONS ::= BEGIN\nIMPORTS\n	MODULE-IDENTITY, OBJECT-IDENTITY, enterprises\nFROM\n	SNMPv2-SMI;\nalcatelIND1BaseMIB MODULE-IDENTITY\n    LAST-UPDATED  \"200103020008Z\"\n    ORGANIZATION  \"Alcatel - Architects Of An Internet World\"\n    CONTACT-INFO\n        \"Please consult with Customer Service to insure the most appropriate\n         version of this document is used with the products in question:\n         \n                    Alcatel Internetworking, Incorporated\n                   (Division 1, Formerly XYLAN Corporation)\n                           26801 West Agoura Road\n                        Agoura Hills, CA  91301-5122\n                          United States Of America\n        \n        Telephone:               North America  +1 800 995 2696\n                                 Latin America  +1 877 919 9526\n                                 Europe         +31 23 556 0100\n                                 Asia           +65 394 7933\n                                 All Other      +1 818 878 4507\n        \n        Electronic Mail:         support@ind.alcatel.com\n        World Wide Web:          http://www.ind.alcatel.com\n        File Transfer Protocol:  ftp://ftp.ind.alcatel.com/pub/products/mibs\"\n    \n    DESCRIPTION\n        \"This module describes an authoritative enterprise-specific Simple\n         Network Management Protocol (SNMP) Management Information Base (MIB):\n         \n             This module provides base definitions for modules\n             developed to manage Alcatel Internetworking networking\n			 infrastructure products.\n         \n         The right to make changes in specification and other information\n         contained in this document without prior notice is reserved.\n         \n         No liability shall be assumed for any incidental, indirect, special, or\n         consequential damages whatsoever arising from or related to this\n         document or the information contained herein.\n         \n         Vendors, end-users, and other interested parties are granted\n         non-exclusive license to use this specification in connection with\n         management of the products for which it is intended to be used.\n         \n           Copyright (C) 1995-2002 Alcatel Internetworking, Incorporated\n                         ALL RIGHTS RESERVED WORLDWIDE\"\n    REVISION      \"200103020008Z\"\n    DESCRIPTION\n        \"The latest version of this MIB Module.\"\n    ::= { alcatel 800 }\nalcatel OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Alcatel Corporate Private Enterprise Number.\"\n    ::= { enterprises 6486 }\nalcatelIND1Management OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n	    \"Internetworking Division 1 Management Branch.\"\n    ::= { alcatelIND1BaseMIB 1 }\nmanagementIND1Hardware OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Hardware Feature Management Branch.\"\n    ::= { alcatelIND1Management 1 }\nmanagementIND1Software OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Software Feature Management Branch.\"\n    ::= { alcatelIND1Management 2 }\nmanagementIND1Notifications OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Notifications Related Management Branch.\"\n    ::= { alcatelIND1Management 3 }\nmanagementIND1AgentCapabilities OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Notifications Related Management Branch.\"\n    ::= { alcatelIND1Management 4 }\nhardwareIND1Entities OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Hardware Feature Related ENTITY-MIB Extensions.\"\n    ::= { managementIND1Hardware 1 }\nhardwareIND1Devices OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch Where Object Indentifiers For Chassis And Modules Are Defined.\"\n    ::= { managementIND1Hardware 2 }\nsoftwareIND1Entities OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Software Feature Related ENTITY-MIB Extensions.\"\n    ::= { managementIND1Software 1 }\nnotificationIND1Entities OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Notification Related ENTITY-MIB Extensions.\"\n    ::= { managementIND1Notifications 1 }\nnotificationIND1Traps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Notification/Trap Definitions.\"\n    ::= { managementIND1Notifications 2 }\naipAMAPTraps  OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Alcatel/Xylan Mapping Adjaceny Protocol Notification/Trap Definitions.\"\n    ::= { notificationIND1Traps 1 }\naipGMAPTraps  OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Group Mobility Advertising Protocol Notification/Trap Definitions.\"\n    ::= { notificationIND1Traps 2 }\npolicyManagerTraps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Policy Manager Notification/Trap Definitions.\"\n    ::= { notificationIND1Traps 3 }\nchassisTraps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Chassis Notification/Trap Definitions.\"\n    ::= { notificationIND1Traps 4 }\nhealthMonTraps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Chassis Notification/Trap Definitions.\"\n    ::= { notificationIND1Traps 5 }\ncmmEsmDrvTraps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For CMM Ethernet Driver Notification/Trap Definitions.\"\n    ::= { notificationIND1Traps 6 }\nspanningTreeTraps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For CMM Spanning Tree Notification/Trap Definitions.\"\n    ::= { notificationIND1Traps 7 }\nportMirroringMonitoringTraps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n	\"Branch for Port mirroring and monitoring Notification/Trap Definitions.\"\n    ::= { notificationIND1Traps 8 }\nsourceLearningTraps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n	\"Branch for Source Learning Notification/Trap Definitioins.\"\n    ::= { notificationIND1Traps 9 }\n			\nslbTraps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n	\"Branch for Server Load Balancing Notification/Trap Definitions.\"\n    ::= { notificationIND1Traps 10 }\nswitchMgtTraps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n	\"Branch for Switch Management Notification/Trap Definitions.\"\n    ::= { notificationIND1Traps 11 }\ntrapMgrTraps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n	\"Branch for Trap Manager Notification Definitions.\"\n    ::= { notificationIND1Traps 12 }\ngroupmobilityTraps OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch for Group Mobility Notification/Trap Definitions.\"\n    ::= { notificationIND1Traps 13 }\nhardentIND1Physical OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Physical Hardware Feature Related ENTITY-MIB Extensions.\"\n    ::= { hardwareIND1Entities 1 }\nhardentIND1System OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For System Wide Hardware Feature Related ENTITY-MIB Extensions.\"\n    ::= { hardwareIND1Entities 2 }\nhardentIND1Chassis OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Chassis Hardware Feature Related ENTITY-MIB Extensions.\"\n    ::= { hardwareIND1Entities 3 }\nhardentIND1Pcam OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Pseudo-CAM Hardware Feature Related ENTITY-MIB Extensions.\"\n    ::= { hardwareIND1Entities 4 }\nsoftentIND1SnmpAgt OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For SNMP Agent Information.\"\n    ::= { softwareIND1Entities 1 }\nsoftentIND1TrapMgr OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Trap Manager Information.\"\n    ::= { softwareIND1Entities 2 }\nsoftentIND1VlanMgt OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For VLAN Manager Information.\"\n    ::= { softwareIND1Entities 3 }\nsoftentIND1GroupMobility OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Group Mobility Information.\"\n    ::= { softwareIND1Entities 4 }\nsoftentIND1Port OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Port Manager Information.\"\n    ::= { softwareIND1Entities 5 }\nsoftentIND1Sesmgr OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Session Manager Information.\"\n    ::= { softwareIND1Entities 7 }\nsoftentIND1MacAddress OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Source Learning MAC Address Information.\"\n    ::= { softwareIND1Entities 8 }\nsoftentIND1Aip OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Interswitch Protocol Information.\"\n    ::= { softwareIND1Entities 9 }\nsoftentIND1Routing OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Routing Information.\"\n    ::= { softwareIND1Entities 10 }\nsoftentIND1Confmgr OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Configuration Manager Information.\"\n    ::= { softwareIND1Entities 11 }\nsoftentIND1VlanStp OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For VLAN Spanning Tree Protocol Information.\"\n    ::= { softwareIND1Entities 12 }\nsoftentIND1LnkAgg OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Link Aggregation Information.\"\n    ::= { softwareIND1Entities 13 }\nsoftentIND1Policy OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Policy Information.\"\n    ::= { softwareIND1Entities 14 }\nsoftentIND1AAA OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Authentication, Authorization, and Accounting (AAA) Information.\"\n    ::= { softwareIND1Entities 15 }\nsoftentIND1Health OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Health Information.\"\n    ::= { softwareIND1Entities 16 }\nsoftentIND1WebMgt OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For WebView Information.\"\n    ::= { softwareIND1Entities 17 }\nsoftentIND1Ipms OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For IPMS Information.\"\n    ::= { softwareIND1Entities 18 }\nsoftentIND1PortMirroringMonitoring OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n	\" Branch for Port Mirroring and Monitoring information.\" \n    ::= { softwareIND1Entities 19 }\nsoftentIND1Slb OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n	\" Branch for Server Load Balancing information.\" \n    ::= { softwareIND1Entities 20 }\nsoftentIND1Dot1Q OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For 802.1Q Information.\"\n    ::= { softwareIND1Entities 21 }\nsoftentIND1QoS OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For QoS and Filtering Information.\"\n    ::= { softwareIND1Entities 22 }\nsoftentIND1Ip OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch for IP private information.\"\n    ::= { softwareIND1Entities 23 }\nsoftentIND1StackMgr OBJECT-IDENTITY\n    STATUS current \n    DESCRIPTION\n        \"Branch for Stack Manager private information.\"\n    ::= { softwareIND1Entities 24 }\n    \nsoftentIND1Partmgr OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Partitioned Manager Information.\"\n    ::= { softwareIND1Entities 25 }\nsoftentIND1Ntp OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch for Network Time Protocol Information.\"\n    ::= { softwareIND1Entities 26 }\nsoftentIND1InLinePower OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch for In Line Power management Information.\"\n    ::= { softwareIND1Entities 27 }\nroutingIND1Tm OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For ????????????????????? Information.\"\n    ::= { softentIND1Routing 1 }\nroutingIND1Iprm OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For IP Route Manager Information.\"\n    ::= { softentIND1Routing 2 }\nroutingIND1Rip OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Routing Information Protocol (RIP) Information.\"\n    ::= { softentIND1Routing 3 }\nroutingIND1Ospf OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Open Shortest Path First (OSPF) Information.\"\n    ::= { softentIND1Routing 4 }\nroutingIND1Bgp OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Border Gateway Protocol (BGP) Information.\"\n    ::= { softentIND1Routing 5 }\nroutingIND1Pimsm OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Protocol Independent Multicast Sparse Mode (PIM-SM) Information.\"\n    ::= { softentIND1Routing 6 }\nroutingIND1Dvmrp OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Distance-Vector Multicast Routing Protocol (DVMRP) Information.\"\n    ::= { softentIND1Routing 7 }\nroutingIND1Ipx OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For Novell Internetwork Packet Exchange (IPX) Protocol Information.\"\n    ::= { softentIND1Routing 8 }\nroutingIND1UdpRelay OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For UDP Relay Agent.\"\n    ::= { softentIND1Routing 9 }\nroutingIND1Ipmrm OBJECT-IDENTITY\n    STATUS current\n    DESCRIPTION\n        \"Branch For IP Multicast Route Manager Information.\"\n    ::= { softentIND1Routing 10 }\nEND\n'),(8,'ALCATEL-IND1-CHASSIS-MIB',1756979642,1756979642,1,'','ALCATEL-IND1-CHASSIS-MIB DEFINITIONS ::= BEGIN\n	\nIMPORTS\n         OBJECT-TYPE,\n         OBJECT-IDENTITY,\n	 MODULE-IDENTITY,	\n         NOTIFICATION-TYPE,\n	 Unsigned32,		\n         Counter32              FROM SNMPv2-SMI\n         PhysicalIndex,\n         entPhysicalIndex       FROM ENTITY-MIB\n         hardentIND1Physical,\n         chassisTraps,\n         hardentIND1Chassis     FROM ALCATEL-IND1-BASE\n         SnmpAdminString	       FROM SNMP-FRAMEWORK-MIB\n         DisplayString,\n         TEXTUAL-CONVENTION     FROM SNMPv2-TC\n	 MODULE-COMPLIANCE, \n	 OBJECT-GROUP,\n         NOTIFICATION-GROUP     FROM SNMPv2-CONF;\nalcatelIND1ChassisMIB MODULE-IDENTITY\n    LAST-UPDATED \"200101301100Z\"\n    ORGANIZATION \"Alcatel Internetworking, Incorporated\"\n    CONTACT-INFO\n     \"Please consult with Customer Service to insure the most appropriate\n      version of this document is used with the products in question:\n    \n                 Alcatel Internetworking, Incorporated\n                (Division 1, Formerly XYLAN Corporation)\n                        26801 West Agoura Road\n                     Agoura Hills, CA  91301-5122\n                       United States Of America\n    \n     Telephone:               North America  +1 800 995 2696\n                              Latin America  +1 877 919 9526\n                              Europe         +31 23 556 0100\n                              Asia           +65 394 7933\n                              All Other      +1 818 878 4507\n    \n     Electronic Mail:         support@ind.alcatel.com\n     World Wide Web:          http://www.ind.alcatel.com\n     File Transfer Protocol:  ftp://ftp.ind.alcatel.com/pub/products/mibs\"\n    DESCRIPTION\n	\"This module describes an authoritative enterprise-specific Simple\n        etwork Management Protocol (SNMP) Management Information Base (MIB):\n        \n        For the Birds Of Prey Product Line, this is the Chassis Supervision\n	Chassis MIB\n        for managing physical chassis objects not covered in the IETF \n	Entity MIB (rfc 2737).\n        The right to make changes in specification and other information\n        contained in this document without prior notice is reserved.\n        No liability shall be assumed for any incidental, indirect, special, or\n        consequential damages whatsoever arising from or related to this\n        document or the information contained herein.\n        \n        Vendors, end-users, and other interested parties are granted\n        non-exclusive license to use this specification in connection with\n        management of the products for which it is intended to be used.\n        \n         Copyright (C) 1995-2002 Alcatel Internetworking, Incorporated\n                       ALL RIGHTS RESERVED WORLDWIDE\"\n    REVISION      \"200101301100Z\"\n  DESCRIPTION\n     \"Addressing discrepancies with Alcatel Standard.\"\n     ::= { hardentIND1Chassis 1 }\n    \n    alcatelIND1ChassisMIBObjects OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Chassis Supervision Chassis MIB\n            Subsystem Managed Objects.\"\n        ::= { alcatelIND1ChassisMIB 1 }\n    alcatelIND1ChassisMIBConformance OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Chassis Supervision Chassis MIB\n            Subsystem Conformance Information.\"\n        ::= { alcatelIND1ChassisMIB 2 }\n    alcatelIND1ChassisMIBGroups OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Chassis Supervision Chassis MIB\n            Subsystem Units Of Conformance.\"\n        ::= { alcatelIND1ChassisMIBConformance 1 }\n    alcatelIND1ChassisMIBCompliances OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Chassis Supervision Chassis MIB\n            Subsystem Compliance Statements.\"\n        ::= { alcatelIND1ChassisMIBConformance 2 }	\n    \n    alcatelIND1ChassisPhysMIBObjects OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Chassis Supervision Chassis Physical MIB\n            Subsystem Managed Objects.\"\n        ::= { hardentIND1Physical 1 }\n    alcatelIND1ChassisPhysMIBConformance OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Chassis Supervision Chassis Physical MIB\n            Subsystem Conformance Information.\"\n        ::= { hardentIND1Physical 2 }\n    alcatelIND1ChassisPhysMIBGroups OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Chassis Supervision Chassis Physical MIB\n            Subsystem Units Of Conformance.\"\n        ::= { alcatelIND1ChassisPhysMIBConformance 1 }\n    alcatelIND1ChassisPhysMIBCompliances OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Chassis Supervision Chassis Physical MIB\n            Subsystem Compliance Statements.\"\n        ::= { alcatelIND1ChassisPhysMIBConformance 2 }	\n-- CONTROL MODULE TABLE\nchasControlModuleTable OBJECT-TYPE\n	SYNTAX SEQUENCE OF ChasControlModuleEntry\n	MAX-ACCESS not-accessible\n	STATUS current\n	DESCRIPTION\n	\"This table contains one row for the primary control module.\"\n::= { alcatelIND1ChassisMIBObjects 1 }\nchasControlModuleEntry OBJECT-TYPE\n	SYNTAX ChasControlModuleEntry\n	MAX-ACCESS not-accessible\n	STATUS current\n	DESCRIPTION\n	\"Information about the primary control module. This table is an extension\n	of the entity physical table but this class is instanciated only for a\n	the primary control module that has a particular Index.\"\n	INDEX { entPhysicalIndex }\n::= { chasControlModuleTable 1 }\nChasControlModuleEntry ::= SEQUENCE\n	{\n		chasControlRunningVersion             INTEGER,\n		chasControlActivateTimeout            INTEGER,\n		chasControlVersionMngt                INTEGER,\n                chasControlDelayedActivateTimer       Unsigned32,\n		chasControlCertifyStatus              INTEGER,\n		chasControlSynchronizationStatus      INTEGER\n			\n	}					  \nchasControlRunningVersion OBJECT-TYPE\n	SYNTAX INTEGER\n	{\n		unknown(1),\n		working(2),\n		certified(3)\n	}\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"Identification of the Running Version (or Running Configuration) for \n        the control module. Note that the Running Version value of (1) unknown,\n        (2) working, or (3) certified is returned.\"\n::= { chasControlModuleEntry 1 }\nchasControlActivateTimeout OBJECT-TYPE\n	SYNTAX INTEGER (0..900)\n        MAX-ACCESS read-write\n	STATUS current\n	DESCRIPTION\n        \"This value is in seconds. It represents how much time before the\n	switch automatically falls back to the certified version. This value\n  	is set via the Activate(reload working) cli command.\n        An Activate reboot must be initiated via the primary CMM and that\n        the timeout value can be accessed via user interface to the primary CMM \n        only. After the Activate reboot has been initiated, a timeout will occur\n        (i.e., an Activate Timeout) at the timeout value specified by the user.\n        If a reboot cancel has not been received prior to the timeout expiration,\n        the primary CMM will automatically reboot (i.e., re-reboot) using the \n        certified configuration. This ensures that an automatic backup reboot is \n        available using the certified configuration in the event that the user \n        is unable to interface with primary CMM as a result of the attempted\n        Activate reboot. If the Activate reboot is successful, the user cancels\n        the backup reboot via the normal reboot cancellation process (i.e., a \n        zero value is written for the object chasControlDelayedRebootTimer).\"\n::= { chasControlModuleEntry 2 }\nchasControlVersionMngt OBJECT-TYPE\n	SYNTAX INTEGER\n	{\n		notSignificant(1),\n		certifySynchro(2),\n		certifyNoSynchro(3),\n		flashSynchro(4),\n		restore(5),\n                activate(6)\n	}\n	MAX-ACCESS read-write\n	STATUS current\n	DESCRIPTION\n	\"For the primary this means:\n		notSignificant -	No command applied.\n		certifySynchro -	Copy the file from the working to the certified\n					directory and from the primary to the secondary\n					(reboot of the secondary).\n		certifyNoSynchro -	Copy the file from the working to the certified\n		 			directory.\n		flashSynchro -		Copy the file from the primary to the secondary\n					(reboot of the secondary).\n		restore -		Copy the file from the certified directory to the\n					working directory.\n		activate -		reload from the working directory. Activate can be\n					scheduled. \"\n::= { chasControlModuleEntry 3 }\nchasControlDelayedActivateTimer OBJECT-TYPE\n	SYNTAX Unsigned32 (0..4294967295)\n        MAX-ACCESS read-write\n	STATUS current\n	DESCRIPTION\n        \"Timer value in seconds used to initiate a delayed activate of the primary\n	CMM. Writing this object to a non-zero value results in CMM reboot of the \n        working  directory following expiration of the specified activate timer delay.\n        Writing this object to zero results in an immediately activate process.\"\n::= { chasControlModuleEntry 4 }\nchasControlCertifyStatus OBJECT-TYPE\n	SYNTAX INTEGER\n	{\n		unknown(1),\n		needCertify(2),\n		certified(3)\n	}\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"Returned value indicates if the control module has been certified\n     (that is the working directory matches the certified directory)\"\n::= { chasControlModuleEntry 5 }\nchasControlSynchronizationStatus OBJECT-TYPE\n	SYNTAX INTEGER\n	{\n		unknown(1),\n		monoControlModule(2),\n		notSynchronized(3),\n		synchronized(4)\n	}\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"Returned value indicates if the control module has been synchronized\n     (that is the working directory matches the working directory\n      on the other control module(s) if present).\n     Returned value is monoControlModule when no other control module\n     is present.\"\n::= { chasControlModuleEntry 6 }\n-- CONTROL REDUNDANT TABLE\nchasControlRedundantTable OBJECT-TYPE\n	SYNTAX SEQUENCE OF ChasControlRedundantEntry\n	MAX-ACCESS not-accessible\n	STATUS current\n	DESCRIPTION\n	\"This table contains one row per control module. There is always at least\n	one control module in the system.\"\n::= { alcatelIND1ChassisMIBObjects 2 }\nchasControlRedundantEntry OBJECT-TYPE\n	SYNTAX ChasControlRedundantEntry\n	MAX-ACCESS not-accessible\n	STATUS current\n	DESCRIPTION\n	\"Information about a particular control module this table is an extension\n	of the entity physical table but this class is instanciated only for a\n	particular type of physical entity: the control module that has a\n	particular Index.\"\n	INDEX { entPhysicalIndex }\n::= { chasControlRedundantTable 1 }\nChasControlRedundantEntry ::= SEQUENCE\n	{\n		chasControlNumberOfTakeover           Counter32,\n		chasControlDelayedRebootTimer         Unsigned32\n	}\nchasControlNumberOfTakeover OBJECT-TYPE\n	SYNTAX Counter32\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"This object is a count of the number of times the control module has\n	changed from primary to secondary mode as a result of a Takeover. Note\n        that this object can be accessed via user interface to either the \n        primary or secondary CMM. The value returned is the number of times\n        that the interfacing control module (either primary or secondary CMM)\n        has changed from primary to secondary mode. This value does not reflect\n        the total number of CMM Takeovers for the switch. To get the total \n        number of Takeovers for the switch, it is necessary to read this value\n        via user interface to each control module independently.\"\n::= { chasControlRedundantEntry 1 }\nchasControlDelayedRebootTimer OBJECT-TYPE\n	SYNTAX Unsigned32 (0.. 4294967295)\n	MAX-ACCESS read-write\n	STATUS current\n	DESCRIPTION\n	\"Timer value (in seconds) used to initiate a delayed reboot of the primary\n	or secondary CMM using the certified configuration.  Writing this object to\n	a non-zero value results in a CMM reboot following expiration of the \n	specified reset timer delay.  Writing this object to zero results in \n	cancellation of a pending CMM delayed reboot.\"\n::= { chasControlRedundantEntry 2 }\n -- CHASSIS TABLE\nchasChassisTable OBJECT-TYPE\n	SYNTAX SEQUENCE OF ChasChassisEntry\n	MAX-ACCESS not-accessible\n	STATUS current\n	DESCRIPTION\n	\"This table contains one row per chassis. There is always at least one\n	chassis or many like for stackable product.\"\n::= { alcatelIND1ChassisMIBObjects 3 }\nchasChassisEntry OBJECT-TYPE\n	SYNTAX ChasChassisEntry\n	MAX-ACCESS not-accessible\n	STATUS current\n	DESCRIPTION\n	\"Information about a particular control module this table is an extension\n	 of the entity physical table but this class is instanciated only for a\n	 particular type of physical entity: the control module that has a\n	 particular Index.\"\n	INDEX { entPhysicalIndex }\n::= { chasChassisTable 1 }\nChasChassisEntry ::= SEQUENCE\n	{\n		chasFreeSlots             		Unsigned32,\n		chasPowerLeft             		INTEGER,\n		chasNumberOfResets        		Counter32,\n		chasHardwareBoardTemp			INTEGER,\n		chasHardwareCpuTemp			INTEGER,\n		chasTempRange				INTEGER,\n   		chasTempThreshold			INTEGER,\n		chasDangerTempThreshold			INTEGER,\n	        chasPrimaryPhysicalIndex		INTEGER\n	}\nchasFreeSlots OBJECT-TYPE\n	SYNTAX Unsigned32	(0..18)\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"The number of free NI front panel slots.\"\n::= { chasChassisEntry 1 }\nchasPowerLeft OBJECT-TYPE\n	SYNTAX INTEGER (-100000..100000)\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"The power still available on the chassis in Watts.\"\n::= { chasChassisEntry 2 }\nchasNumberOfResets OBJECT-TYPE\n	SYNTAX Counter32\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"This object is a count of the number of times this station has been reset\n	since a cold-start.\"\n::= { chasChassisEntry 3 }\nchasHardwareBoardTemp	OBJECT-TYPE\n        SYNTAX		INTEGER	 (0..200)\n        MAX-ACCESS	read-only\n        STATUS		current\n        DESCRIPTION\n         \"This object indicates the current output of the Board Temperature\n          Sensor provided by the LM75 part (degrees Centigrade) for this chassis.\n	  This temperature is what is used for comparing to the threshold and\n	  determining whether the value is in range.\"\n::= { chasChassisEntry 4 }\nchasHardwareCpuTemp	OBJECT-TYPE\n        SYNTAX	        INTEGER	 (0..200)\n        MAX-ACCESS	read-only\n        STATUS		current\n        DESCRIPTION\n         \"This object indicates the current output of the SPARC Temperature\n          Sensor (degrees Centigrade) for this chassis.\n	  This object is not applicable for Hawk and 0 is returned\"\n::= { chasChassisEntry 5 }\nchasTempRange OBJECT-TYPE\n	SYNTAX INTEGER\n	{\n		unknown(1),\n		notPresent(2),\n		underThreshold(3),\n		overFirstThreshold(4),\n		overDangerThreshold(5)\n	}\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"Temp Range is the value of the temperature sensor for the chassis. The\n         Temp Range value reflects the temperature of the chassis relative to the \n         Temp Threshold value (i.e., over vs. under the threshold).\"\n::= { chasChassisEntry 6 }\nchasTempThreshold OBJECT-TYPE\n	SYNTAX INTEGER (30..80)\n	MAX-ACCESS read-write\n	STATUS current\n	DESCRIPTION\n	\"This object is the threshold temperature in degrees Celsius for the\n        chassis. Temp Threshold is the chassis temperature point at which,\n        when reached due to an ascending or descending temperature transition, \n        a temperature notification is provided to the user. When this threshold\n        is exceeded, we start sending traps and other operator notification.\"\n::= { chasChassisEntry 7 }\nchasDangerTempThreshold OBJECT-TYPE\n	SYNTAX INTEGER (30..150)\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"This Threshold is a second one which is hardcoded. When the\n	Chassis Exceeds this value it starts shutting down NIs.\n	This value will be set by the factory and not changeable.\"\n::= { chasChassisEntry 8 }\nchasPrimaryPhysicalIndex OBJECT-TYPE\n	SYNTAX INTEGER (1..255)\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"This value holds the Entity Table Physical Index for the Control\n	 Module that is currently primary. This is to allow snmp managers \n	 to determine which Control Module is currently primary so it knows \n	 what entry in the chasControlModuleTable to access for setting the\n	 chasControlVersionMngt values for controling the switch.\"\n::= { chasChassisEntry 9 }\n-- Extension of the Entity physical table\nchasEntPhysicalTable OBJECT-TYPE\n	SYNTAX SEQUENCE OF ChasEntPhysicalEntry\n	MAX-ACCESS not-accessible\n	STATUS current\n	DESCRIPTION\n	\"This table contains one row per physical entity. It is an extension for\n	the entity physical table (rfc 2737) that is instantiated for every physical entity\n	object. The fields are not always significant for every object.\"\n::= { alcatelIND1ChassisPhysMIBObjects 1 }\nchasEntPhysicalEntry OBJECT-TYPE\n	SYNTAX ChasEntPhysicalEntry\n	MAX-ACCESS not-accessible\n	STATUS current\n	DESCRIPTION\n	\"Information about a particular physical entity.\"\n	INDEX { entPhysicalIndex }\n::= { chasEntPhysicalTable 1 }\nChasEntPhysicalEntry ::= SEQUENCE\n	{\n		chasEntPhysAdminStatus                INTEGER,\n		chasEntPhysOperStatus                 INTEGER,\n		chasEntPhysLedStatus                  BITS,\n		chasEntPhysPower                      INTEGER,\n		chasEntPhysModuleType                 SnmpAdminString,\n		chasEntPhysMfgDate                    SnmpAdminString,\n		chasEntPhysPartNumber                 SnmpAdminString\n	}\nchasEntPhysAdminStatus OBJECT-TYPE\n	SYNTAX INTEGER\n	{\n		unknown(1),\n		powerOff(2),\n		powerOn(3),\n		reset(4),\n		takeover(5),\n		resetAll(6),\n		standby(7)\n	}\n	MAX-ACCESS read-write\n	STATUS current\n	DESCRIPTION\n	\"All modules (even empty slots) are in unknown state when the chassis\n	first powers up.\n	Chassis status possible value:\n		powerOn <=> powered up\n	Control Module possible value:\n		powerOn <=> CM up and running\n		reset <=> CM reset\n		takeover <=> Secondary CM takes over\n		resetAll <=> resets the whole switch\n	NI status possible value:\n		powerOn <=> NI is either powered (up or down) or waiting to be powered\n			    whenever more power is available. This admin status has not full meaning\n			    without chasEntPhysOperStatus\n		powerOff <=> NI down and unpowered and NI will not be powered until user requests it,\n			     a failover happens or a reboot happens\n		reset <=> NI reset\n	FABRIC status possible value:\n		powerOn     <=> FABRIC is powered\n		powerOff    <=> FABRIC is unpowered\n		standby     <=> FABRIC is powered and requested to be redundant (inactive)\n	Daughter board status possible value:\n		powerOn <=> DB up and running\n		reset <=> DB reset (TO BE CONFIRMED)\n	Power supply status possible value:\n		powerOn <=> PS up\"\n::= { chasEntPhysicalEntry 1 }\nchasEntPhysOperStatus OBJECT-TYPE\n	SYNTAX INTEGER\n	{\n		up(1),\n		down(2),\n		testing(3),\n		unknown(4),\n		secondary(5),\n		notPresent(6),\n		unpowered(7),\n		master(8)\n	}\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"All modules (even empty slots) are in unknown state when the chassis\n	first powers up.\n	Chassis status possible value :\n		up <=> powered up\n	Control Module possible value :\n		notPresent <=> CM not present\n		up <=> CM up and running\n		down <=> CM down and powered\n		secondary <=> CM in secondary mode and running\n	NI status possible value :\n		notPresent <=> NI not present\n		up <=> NI up and running\n		down <=> NI down and powered\n		unpowered <=> NI unpowered because there is not enough power in the system\n			      (chasEntPhysAdminStatus = powerOn) or because the NI has to be OFF\n			      (chasEntPhysAdminStatus = powerOff). This operational status has not full meaning\n			      without chasEntPhysAdminStatus\n	Fabric status possible value :\n		master <=> up and acting as master\n		up <=> up and acting as slave\n		secondary <=> secondary mode for redundancy\n	Daughter board status possible value :\n		notPresent <=> DB not present\n		up <=> DB up and running\n		down <=> DB down and powered\n	Power supply status possible value :\n		notPresent <=> PS not present\n		up <=> PS up\"\n::= { chasEntPhysicalEntry 2 }\nchasEntPhysLedStatus OBJECT-TYPE\n	SYNTAX BITS {\n	ok1GreenLSBit(0),\n	ok1GreenMSBit(1),\n	ok1AmberLSBit(2),\n	ok1AmberMSBit(3),\n	ok2GreenLSBit(4),\n	ok2GreenMSBit(5),\n	ok2AmberLSBit(6),\n	ok2AmberMSBit(7),\n	primary(8),\n	seconadry(9),\n	temperature(10),\n	statusFan(11),\n	fan1LSBit(12),\n	fan1MSBit(13),\n	fan2LSBit(14),\n	fan2MSBit(15),\n	fan3LSBit(16),\n	fan3MSBit(17),\n	internalPS(18),\n	fanGroup(19)\n	}\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"The status of each of the LEDs of this module.\n	\n	Falcon CMM: \n	[11]    Fan 		1=Green (ok)	0=amber (fail) \n	[10]    Temperature	1=Green (ok)	0=amber (fail) \n	[9]     Secondary CMM	1=amber		0=OFF \n	[8]     Primary CMM	1=amber		0=OFF \n	[7:6]   OK2 amber	00=off		01=on		10=blink	11=reserved \n	[5:4]   OK2 green 	00=off		01=on		10=blink	11=reserved \n	[3:2]   OK1 amber	00=off		01=on		10=blink	11=reserved \n	[1:0]   OK1 green	00=off		01=on		10=blink	11=reserved \n	Eagle CMM:\n  \n	[17:16] Fan 3 (rear)		00=amber	01=green	10=blink	11=reserved \n	[15:14] Fan 2 (top right)	00=amber	01=green	10=blink	11=reserved \n	[13:12] Fan 1 (top left)	00=amber	01=green	10=blink	11=reserved \n	[11]    Status			1=Green (ok)	0=amber (fail) \n	[10]    Temperature		1=Green (ok)	0=amber (fail) \n	[9]     Secondary CMM		1=amber		0=OFF \n	[8]     Primary CMM		1=amber		0=OFF \n	[7:6]   OK2 amber		00=off		01=on		10=blink	11=reserved \n	[5:4]   OK2 green		00=off		01=on		10=blink	11=reserved \n	[3:2]   OK1 amber		00=off		01=on		10=blink	11=reserved \n	[1:0]   OK1 green		00=off		01=on		10=blink	11=reserved \n  \n	Hawk Stack: \n	[19]    fanGroup	1=Green (ok)	0=amber (fail) \n	[18]    internalPS	1=Green (ok)	0=amber (fail) \n	[11]    backupPS	1=Green (ok)	0=amber (fail) \n	[10]    Temperature	1=Green (ok)	0=amber (fail) \n	[9]     Secondary CMM	1=amber		0=OFF \n	[8]     Primary CMM	1=amber		0=OFF \n	[7:6]   OK2 amber	00=off		01=on		10=blink	11=reserved \n	[5:4]   OK2 green 	00=off		01=on		10=blink	11=reserved \n	[3:2]   OK1 amber	00=off		01=on		10=blink	11=reserved \n	[1:0]   OK1 green	00=off		01=on		10=blink	11=reserved \n	NI: \n	[7:6]   OK2 amber	00=off	01=on	10=blink	11=reserved \n	[5:4]   OK2 green	00=off	01=on	10=blink	11=reserved \n	[3:2]   OK1 amber	00=off	01=on	10=blink	11=reserved \n	[1:0]   OK1 green	00=off	01=on	10=blink	11=reserved \n  \n	FABRIC (Eagle Only): \n	[7:6]	OK2 Yellow LED	01=on	00=off	10=blink	11=reserved\n	[5:4]	OK2 Green LED	01=on	00=off  10=blink	11=reserved\n	[3:2]	OK1 Yellow LED	01=on	00=off  10=blink	11=reserved\n	[1:0]	OK1 Green LED	01=on	00=off	10=blink	11=reserved\nNOTE: 	Due to European regulation, the LEDs will NEVER be illuminated RED!\n	They in fact will be either green OR amber.\"\n::= { chasEntPhysicalEntry 3 }\nchasEntPhysPower OBJECT-TYPE\n	SYNTAX INTEGER (0..65535)\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"This value is only applicable to the NI, PS and Control Modules.  It\n	corresponds to a a static value for the power consumption of an NI\n	module or Control Module. This value is in Watts.\"\n::= { chasEntPhysicalEntry 4 }\nchasEntPhysModuleType OBJECT-TYPE			     \n    SYNTAX      SnmpAdminString\n    MAX-ACCESS  read-only\n    STATUS      current\n    DESCRIPTION\n            \"This object is the unique Module Type or ID from the entities eeprom.\n	     This value is guarrantteed to be unique to each type of Module. \n	     This value is only intended for Alcatel internal use.\"\n    ::= { chasEntPhysicalEntry 5 }\n \nchasEntPhysMfgDate OBJECT-TYPE			     \n    SYNTAX      SnmpAdminString (SIZE(0..11))\n    MAX-ACCESS  read-only\n    STATUS      current\n    DESCRIPTION\n            \"This object contains the manufacturing date of the entity. \n            Its format is mmm dd yyyy : NOV 27 2001.\"\n        ::= { chasEntPhysicalEntry 6 }\n \nchasEntPhysPartNumber OBJECT-TYPE		     \n    SYNTAX      SnmpAdminString (SIZE(0..14))\n    MAX-ACCESS  read-only\n    STATUS      current\n    DESCRIPTION\n            \"This object contains the Alcatel Part Number for the entity.\n	     This value is used to identify what is \n	     needed when placing orders with Alcatel.\" \n        ::= { chasEntPhysicalEntry 7 }\n-- CHASSIS SUPERVISION RFS LS TABLE\nchasSupervisionRfsLsTable OBJECT-TYPE\n	SYNTAX SEQUENCE OF ChasSupervisionRfsLsEntry\n	MAX-ACCESS      not-accessible\n	STATUS          current\n	DESCRIPTION\n                \"This table contains a list of file on the remote chassis per directory.\"\n        ::= { alcatelIND1ChassisMIBObjects 4 }\nchasSupervisionRfsLsEntry OBJECT-TYPE\n	SYNTAX          ChasSupervisionRfsLsEntry\n	MAX-ACCESS      not-accessible\n	STATUS          current\n	DESCRIPTION\n               	\"Information about a remote file.\n                 A row in this table contains a file per directory per chassis\"\n    INDEX { chasSupervisionRfsLsFileIndex }\n        ::= { chasSupervisionRfsLsTable 1 }\nChasSupervisionRfsLsEntry ::= SEQUENCE\n	{\n		chasSupervisionRfsLsFileIndex	INTEGER,\n		chasSupervisionRfsLsSlot        Unsigned32,\n		chasSupervisionRfsLsDirName	DisplayString (SIZE (0..255)),\n		chasSupervisionRfsLsFileName	DisplayString (SIZE (0..33)),\n		chasSupervisionRfsLsFileType	INTEGER,\n		chasSupervisionRfsLsFileSize	Unsigned32,\n		chasSupervisionRfsLsFileAttr	INTEGER,\n   		chasSupervisionRfsLsFileDateTime DisplayString (SIZE (0..16))\n	}\nchasSupervisionRfsLsFileIndex OBJECT-TYPE\n	SYNTAX          INTEGER (1..100)\n	MAX-ACCESS      read-only\n	STATUS          current\n	DESCRIPTION\n	\"This value holds file Index for the RFS LS table.\"\n	::= { chasSupervisionRfsLsEntry 1}\nchasSupervisionRfsLsSlot OBJECT-TYPE\n	SYNTAX          Unsigned32\n	MAX-ACCESS	read-only\n	STATUS          current\n	DESCRIPTION \n                \"Slot where remote file is located.\"\n	::= { chasSupervisionRfsLsEntry 2}\nchasSupervisionRfsLsDirName OBJECT-TYPE\n	SYNTAX          DisplayString (SIZE (0..255))\n	MAX-ACCESS	read-only\n	STATUS          current\n	DESCRIPTION\n		\"The remote directory name where remote file is located in\"\n	DEFVAL { \"/flash\" }\n	::= { chasSupervisionRfsLsEntry 3 }\nchasSupervisionRfsLsFileName OBJECT-TYPE\n	SYNTAX	DisplayString (SIZE (0..33))\n	MAX-ACCESS	read-only\n	STATUS          current\n	DESCRIPTION	\"The file name of remote file\"\n	DEFVAL { \"\" }\n        ::= { chasSupervisionRfsLsEntry 4 }\nchasSupervisionRfsLsFileType OBJECT-TYPE\n	SYNTAX          INTEGER	{\n                                file(1),\n       				directory(2),\n               			undefined(3)\n                        	}\n	MAX-ACCESS	read-only\n	STATUS          current\n	DESCRIPTION	\"The Type of a remote file\"\n	DEFVAL          { undefined }\n        ::= { chasSupervisionRfsLsEntry 5 }\nchasSupervisionRfsLsFileSize OBJECT-TYPE\n	SYNTAX          Unsigned32\n	MAX-ACCESS	read-only\n	STATUS          current\n	DESCRIPTION	\"size of this remote file\"\n	DEFVAL          { 0 }\n        ::= { chasSupervisionRfsLsEntry 6 }\nchasSupervisionRfsLsFileAttr OBJECT-TYPE\n	SYNTAX          INTEGER {\n				undefined(1),\n				readOnly(2),\n				readWrite(3),\n				writeOnly(4)\n                                }\n	MAX-ACCESS	read-only\n	STATUS          current\n	DESCRIPTION	\"attributes of this remote file\"\n	DEFVAL          { undefined }\n        ::= { chasSupervisionRfsLsEntry 7 }\nchasSupervisionRfsLsFileDateTime OBJECT-TYPE\n	SYNTAX          DisplayString (SIZE (0..16))\n	MAX-ACCESS	read-only\n	STATUS          current\n	DESCRIPTION	\"the modification date and time of a remote file\"\n	DEFVAL          { \"\" }\n        ::= { chasSupervisionRfsLsEntry 8 }\n-- CHASSIS SUPERVISION RFS COMMANDS\nalcatelIND1ChassisSupervisionRfsCommands OBJECT-IDENTITY	\n	STATUS current\n        DESCRIPTION	\n        	\"Branch For Chassis Supervision RFS commands. \n             For the rrm command the Slot, Command and SrcFileName are mandatory. \n             For the rcp the Slot, Command, SrcFileName and DestFileName are mandatory.\"\n        ::= { alcatelIND1ChassisMIBObjects 5 }\nchasSupervisionRfsCommandsSlot OBJECT-TYPE\n	SYNTAX          Unsigned32\n	MAX-ACCESS		read-create\n	STATUS          current\n	DESCRIPTION	\"Slot where RFS command should be executed.\"\n        ::= { alcatelIND1ChassisSupervisionRfsCommands 1}\nchasSupervisionRfsCommandsCommand OBJECT-TYPE\n	SYNTAX          INTEGER {\n                   		notSignificant(0),\n                                rrm(1),\n	  			rcp(2),\n                                rls(3)\n        			}\n	MAX-ACCESS	read-create\n	STATUS          current\n	DESCRIPTION\n        	\"This object identifies which of the above Actions is to be\n                 performed.\"\n        ::= { alcatelIND1ChassisSupervisionRfsCommands 2 }\nchasSupervisionRfsCommandsSrcFileName OBJECT-TYPE\n	SYNTAX          DisplayString (SIZE (0..255))\n	MAX-ACCESS		read-create\n	STATUS          current\n	DESCRIPTION\n        	\"The remote file for where the RFS action is executed. \n                 This includes also the path so directory name and file name.\n                 This object is used when command set to rrm or rcp.\"\n        ::= { alcatelIND1ChassisSupervisionRfsCommands 3 }\nchasSupervisionRfsCommandsDestFileName OBJECT-TYPE\n	SYNTAX          DisplayString (SIZE (0..255))\n	MAX-ACCESS		read-create\n	STATUS          current\n	DESCRIPTION\n                \"The destination file for where the RFS action is executed. \n                 This includes also the path so directory name and file name.\n                 This object is used when command set to rcp.\"\n        ::= { alcatelIND1ChassisSupervisionRfsCommands 4 }\nchasSupervisionRfsCommandsRlsDirName OBJECT-TYPE\n	SYNTAX          DisplayString (SIZE (1..255))\n	MAX-ACCESS		read-create\n	STATUS          current\n	DESCRIPTION\n               \"The remote directory name where remote file is located in.\n                This is used when command set to rls.\"\n	DEFVAL { \"/flash\" }\n        ::= { alcatelIND1ChassisSupervisionRfsCommands 5 }\nchasSupervisionRfsCommandsRlsFileName OBJECT-TYPE\n	SYNTAX          DisplayString (SIZE (0..33))\n	MAX-ACCESS		read-create\n	STATUS          current\n	DESCRIPTION\n               \"The remote file name where remote file is located in.\n                This is used when command set to rls.\"\n        ::= { alcatelIND1ChassisSupervisionRfsCommands 6 }\nchasSupervisionRfsCommandsProcessingState OBJECT-TYPE\n	SYNTAX          INTEGER {\n        			inProgress(1),\n        			ready(2)\n                                }\n	MAX-ACCESS	read-only\n	STATUS          current\n	DESCRIPTION	\"command executing state for the previous set operation.\"\n        ::= { alcatelIND1ChassisSupervisionRfsCommands 7 }\nchasSupervisionRfsCommandsStatusCode OBJECT-TYPE\n	SYNTAX          INTEGER {\n				 success(1),\n                                 slotIsPrimary(2),\n                                 slotNotExist(3),\n				 directoryNotExist(4),\n				 fileNotExist(5),\n                                 maximumFilesExceed(6),\n                                 noDiskSpace(7),\n                                 systemBusy(8),\n				 systemError(9),\n				 directoryNotAllowToRemove(10)\n                                }\n	MAX-ACCESS	read-only\n	STATUS          current\n	DESCRIPTION	\"command completetion status error code.\"\n        ::= { alcatelIND1ChassisSupervisionRfsCommands 8 }\n-- CHASSIS CONTROL RELOAD STATUS\nchasControlReloadStatusTable OBJECT-TYPE\n	SYNTAX		SEQUENCE OF ChasControlReloadEntry\n	MAX-ACCESS	not-accessible\n	STATUS		current\n	DESCRIPTION	\"Table containing reload status of each network interface\n				slot or stack module\"\n::= { alcatelIND1ChassisMIBObjects 6 }\nchasControlReloadEntry OBJECT-TYPE\n	SYNTAX		ChasControlReloadEntry\n	MAX-ACCESS	not-accessible\n	STATUS		current\n	DESCRIPTION	\"Entry of a network interface reload status\"\n	INDEX { chasControlReloadIndex }\n::={ chasControlReloadStatusTable 1 }\nChasControlReloadEntry ::= SEQUENCE {\n	chasControlReloadIndex		INTEGER,\n	chasControlReloadStatus		INTEGER\n}\nchasControlReloadIndex OBJECT-TYPE\n	SYNTAX 		INTEGER (1..16)\n	MAX-ACCESS	not-accessible\n	STATUS		current\n	DESCRIPTION	\"Entry of a network interface reload status\"\n	::= { chasControlReloadEntry 1 }\nchasControlReloadStatus OBJECT-TYPE\n	SYNTAX INTEGER\n	{\n		reloadEnabled(1),\n		reloadDisabled(2),\n		noInterface(3),\n		unknown(4)\n	}\n	MAX-ACCESS read-only\n	STATUS current\n	DESCRIPTION\n	\"Returned value indicates if the network interface module is \n     enabled or disabled for reload.\"\n	DEFVAL { reloadDisabled }\n::= { chasControlReloadEntry 2 }\n-- CHASSIS GLOBAL CONTROL OBJECTS\n    chasGlobalControl   OBJECT IDENTIFIER ::= { alcatelIND1ChassisMIBObjects 7 }\nchasGlobalControlDelayedResetAll OBJECT-TYPE\n	SYNTAX INTEGER (-1..65535)\n	MAX-ACCESS read-write\n	STATUS current\n	DESCRIPTION\n	\"This object is used to schedule a delayed reset all action. \n	If set to -1 - cancel the timer, 0 - reset all immediately, \n	any other value will start counting down the time until reset.\"\n    DEFVAL { -1 }\n::= { chasGlobalControl 1 }\n--\n--Chassis traps mib : chassisTraps \n--\n--chassisTraps  OBJECT IDENTIFIER ::= { notificationIND1Traps 4 }\n--Chassis traps definition\nchassisTrapsDesc  OBJECT IDENTIFIER ::= { chassisTraps 1 }\nchassisTrapsObj  OBJECT IDENTIFIER ::= { chassisTraps 2 }\n--\n--textual conventions\n--\nChassisTrapsStrLevel ::= TEXTUAL-CONVENTION	\n    STATUS        current\n    DESCRIPTION   \n	\"enumerated value which provide the\n	urgency level of the STR.\"\n    SYNTAX        INTEGER {\n		 	  strNotFatal		(1), --recorverable    	\n			  strApplicationFatal	(2), --not recorverable for the application   	\n			  strFatal		(3)  --not recorverable for the board\n		  }\n    	\n \nChassisTrapsStrAppID  ::= TEXTUAL-CONVENTION\n    STATUS        current\n    DESCRIPTION   \n	\"Application Identification number\"\n    SYNTAX        INTEGER (0..255) \n \nChassisTrapsStrSnapID  ::= TEXTUAL-CONVENTION\n    STATUS        current\n    DESCRIPTION   \n	\"Subapplication Identification number.\n	we can have multiple snapIDs per \n	Subapplication (task) but only one is \n	to be used to send STRs.\"\n    SYNTAX        INTEGER (0..255) \n \nChassisTrapsStrfileLineNb ::= TEXTUAL-CONVENTION \n    STATUS        current\n    DESCRIPTION   \n	\"Line number in the source file where the \n	fault was detected. This is given by the C \n	ANSI macro __LINE__.\"\n    SYNTAX        INTEGER (1..65535)\nChassisTrapsStrErrorNb ::= TEXTUAL-CONVENTION \n    STATUS        current\n    DESCRIPTION   \n	\"Fault identifier. The error number\n	identifies the kind the detected fault and \n	allows a mapping of the data contained in \n	chassisTrapsdataInfo.\"\n    SYNTAX        INTEGER (0..65535)\n \nChassisTrapsStrdataInfo ::= TEXTUAL-CONVENTION\n    STATUS        current\n    DESCRIPTION   \n	\"Additional data provided to help to find out\n	the origine of the fault. The contain and the \n	significant portion are varying in accordance \n	with chassisTrapsStrErrorNb. The lenght of this \n	field is expressed in bytes.\"\n    SYNTAX  OCTET STRING (SIZE (0..63))\n \nChassisTrapsObjectType ::= TEXTUAL-CONVENTION \n    STATUS        current\n    DESCRIPTION   \n	\"An enumerated value which provides the object type \n	involved in the alert trap.\"\n    SYNTAX        INTEGER {\n		 	  chassis		(1),     	\n			  ni			(2),  	\n			  powerSuply		(3),  \n			  fan			(4),  \n			  cmm			(5),\n                          fabric		(6),\n                          gbic			(7)  \n		  }\n \nChassisTrapsObjectNumber ::= TEXTUAL-CONVENTION \n    STATUS        current\n    DESCRIPTION   \n	\"A number defining the order of the object in the \n	set. EX: The number of the considered fan or power\n	supply. This intend to clarify as much as possible\n	the location of the failure or alert. An instance\n	of the appearance of the trap could be: \n	failure on a module. Power supply 3.  \"\n    SYNTAX        INTEGER  (0..255)\n \nChassisTrapsAlertNumber ::= TEXTUAL-CONVENTION\n    STATUS        current\n    DESCRIPTION   \n	\"this number identify the alert among all the \n	possible chassis alert causes.\"\n    SYNTAX	INTEGER {\n		runningWorking			(1),	-- The working version is used		     	\n		runningCertified		(2),	-- The certified version is used\n		certifyStarted			(3),	-- CERTIFY process started\n		certifyFlashSyncStarted		(4),	-- CERTIFY w/FLASH SYNCHRO process started\n		certifyCompleted		(5),	-- CERTIFY process completed successfully\n		certifyFailed			(6),	-- CERTIFY process failed\n		synchroStarted			(7),	-- Flash Synchronization process started\n		synchroCompleted		(8),	-- Flash Synchronization completed successfully\n		synchroFailed			(9),	-- Flash Synchronization failed\n		restoreStarted			(10),	-- RESTORE process started\n		restoreCompleted		(11),	-- RESTORE process completed successfully\n		restoreFailed			(12),	-- RESTORE process failed\n		takeoverStarted			(13),	-- CMM take-over being processed\n		takeoverDeferred		(14),	-- CMM take-over deferred\n		takeoverCompleted		(15),	-- CMM take-over completed\n		macAllocFailed			(16),	-- CMS MAC allocation failed\n		macRangeFailed			(17),	-- CMS MAC range addition failed\n		fanFailed			(18),	-- One or more of the fans is inoperable\n		fanOk				(19),	-- Fan is operable\n		fansOk				(20),	-- All fans are operable\n		tempOverThreshold		(21),	-- CMM temperature over the threshold\n		tempUnderThreshold		(22),	-- CMM temperature under the threshold\n		tempOverDangerThreshold		(23),	-- CMM temperature over danger threshold\n		powerMissing			(24),	-- Not enough power available\n		psNotOperational		(25),	-- Power Supply is not operational\n		psOperational			(26),	-- Power supply is operational\n		psAllOperational		(27),	-- All power supplies are operational\n		redundancyNotSupported		(28),	-- Hello protocol disabled, Redundancy not supported\n		redundancyDisabledCertifyNeeded	(29),	-- Hello protocol disabled, Certify needed\n		cmmStartingAsPrimary		(30),	-- CMM started as primary\n		cmmStartingAsSecondary		(31),	-- CMM started as secondary\n		cmmStartupCompleted		(32),	-- end of CMM start up\n		cmmAPlugged			(33),	-- cmm a plugged\n		cmmBPlugged			(34),	-- cmm b plugged\n		cmmAUnPlugged			(35),	-- cmm a unplugged\n		cmmBUnPlugged			(36),	-- cmm b unplugged\n		lowNvramBattery			(37),	-- NV RAM battery is low\n		notEnoughFabricsOperational	(38),	-- Not enough Fabric boards operational\n		simplexNoSynchro		(39),	-- Only simplex CMM no flash synchro done\n		secAutoActivate			(40),	-- secondary CMM autoactivating\n		secAutoCertifyStarted		(41),	-- secondary CMM autocertifying\n		secAutoCertifyCompleted		(42),	-- secondary CMM autocertify end\n		secInactiveReset		(43),	-- cmm b unplugged\n		activateScheduled		(44),	-- ACTIVATE process scheduled\n		activateStarted			(45),	-- secondary CMM reset because of inactivity\n                getAfileCompleted               (46),   -- Get A file process completed\n                getAfileFailed                  (47),   -- Failed to get a file from other CMM/Stack\n                sysUpdateStart                  (48),   -- sysUpdate starts\n                sysUpdateInProgress             (49),   -- sysUpdate in progress\n                sysUpdateError                  (50),   -- sysUpdate error\n                sysUpdateEnd                    (51)    -- sysUpdate ends\n		  }\n \n--\n--object i.e. trap description\n--\nchassisTrapsStr NOTIFICATION-TYPE\n    OBJECTS {\n        chassisTrapsStrLevel         	,  \n	chassisTrapsStrAppID 		, \n	chassisTrapsStrSnapID		, \n	chassisTrapsStrfileName		, \n	chassisTrapsStrfileLineNb	, \n	chassisTrapsStrErrorNb		, \n	chassisTrapsStrcomments		, \n	chassisTrapsStrdataInfo		\n    }\n    STATUS        current\n    DESCRIPTION\n       \"A Software Trouble report is sent by whatever application \n	encountering a problem during its execution and would \n	want to aware the user of for maintenance purpose.	\"\n::= { chassisTrapsDesc 0 1 }\nchassisTrapsAlert NOTIFICATION-TYPE\n    OBJECTS {\n	physicalIndex, \n        chassisTrapsObjectType		, \n	chassisTrapsObjectNumber	, \n	chassisTrapsAlertNumber		,\n	chassisTrapsAlertDescr		\n    }\n    STATUS        current\n    DESCRIPTION\n       \"generic trap notifying something changed in the chassis\n	whatever it\'s a failure or not				\"\n::= { chassisTrapsDesc 0 2 }\nchassisTrapsStateChange NOTIFICATION-TYPE\n    OBJECTS {\n	physicalIndex, \n        chassisTrapsObjectType		, \n	chassisTrapsObjectNumber	, \n	chasEntPhysOperStatus			\n    }\n    STATUS        current\n    DESCRIPTION\n       \"A status change was detected\"\n::= { chassisTrapsDesc 0 3 }\n--\n-- objects used in the traps.\n--\nchassisTrapsStrLevel    OBJECT-TYPE\n	SYNTAX     		ChassisTrapsStrLevel\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"An enumerated value which provides the\n	urgency level of the STR.\" \n	::= {chassisTrapsObj 1}\nchassisTrapsStrAppID    OBJECT-TYPE\n	SYNTAX     		ChassisTrapsStrAppID\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"Application Identification number\"  \n	::= {chassisTrapsObj 2}\nchassisTrapsStrSnapID   OBJECT-TYPE\n	SYNTAX     		ChassisTrapsStrSnapID\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"Subapplication Identification number.\n	we can have multiple snapIDs per \n	Subapplication (task) but only one is \n	to be used to send STRs.\"  \n	::= {chassisTrapsObj 3}\nchassisTrapsStrfileName    OBJECT-TYPE\n	SYNTAX     		SnmpAdminString(SIZE(0..19))\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"Name of the source file where the fault\n	was detected. This is given by the C ANSI\n	macro __FILE__. The path shouldn\'t appear.\"  \n	::= {chassisTrapsObj 4}\nchassisTrapsStrfileLineNb    OBJECT-TYPE\n	SYNTAX     		ChassisTrapsStrfileLineNb\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"Line number in the source file where the \n	fault was detected. This is given by the C \n	ANSI macro __LINE__.\"  \n	::= {chassisTrapsObj 5}\nchassisTrapsStrErrorNb    OBJECT-TYPE\n	SYNTAX     		ChassisTrapsStrErrorNb\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"Fault identificator. The error number\n	identify the kind the detected fault and \n	allow a mapping of the data contained in \n	chassisTrapsdataInfo.\"  \n	::= {chassisTrapsObj 6}\nchassisTrapsStrcomments    OBJECT-TYPE\n	SYNTAX     		SnmpAdminString(SIZE(0..63))\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"comment text explaning the fault.\"  \n	::= {chassisTrapsObj 7}\nchassisTrapsStrdataInfo    OBJECT-TYPE\n	SYNTAX     		ChassisTrapsStrdataInfo\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"Additional data provided to help to find out\n	the origine of the fault. The contain and the \n	significant portion are varying in accordance \n	with chassisTrapsStrErrorNb. The lenght of this \n	field is expressed in bytes.\"  \n	::= {chassisTrapsObj 8}\nchassisTrapsObjectType    OBJECT-TYPE\n	SYNTAX     		ChassisTrapsObjectType\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"enumerated value which provide the object type \n	involved in the alert trap.\"  \n	::= {chassisTrapsObj 9}\nchassisTrapsObjectNumber    OBJECT-TYPE\n	SYNTAX     		ChassisTrapsObjectNumber\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"number defining the order of the object in the \n	set. EX: number of the considered fan or power\n	supply. This intend to clarify as much as possible\n	the location of the failure or alert. A instance\n	of the appearance of the trap could be: \n	failure on a module. Power supply 3.  \"  \n	::= {chassisTrapsObj 10}\nchassisTrapsAlertNumber    OBJECT-TYPE\n	SYNTAX     		ChassisTrapsAlertNumber\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"this number identify the alert among all the \n	possible chassis alert causes.\"  \n	::= {chassisTrapsObj 11}\nchassisTrapsAlertDescr    OBJECT-TYPE\n	SYNTAX     		SnmpAdminString(SIZE(0..127))\n	MAX-ACCESS 		read-only\n	STATUS 			current\n	DESCRIPTION\n	\"description of the alert maching \n	chassisTrapsAlertNumber\"  \n	::= {chassisTrapsObj 12}\nphysicalIndex    	  OBJECT-TYPE\n    	SYNTAX      		PhysicalIndex\n    	MAX-ACCESS  		read-only\n    	STATUS      		current\n    	DESCRIPTION\n            \"The Physical index of the involved object.\"\n    	::= { chassisTrapsObj 13 }\n-- END Trap Objects\n       \n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n-- COMPLIANCE\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n    alcatelIND1ChassisMIBCompliance MODULE-COMPLIANCE\n        STATUS  current\n        DESCRIPTION\n            \"Compliance statement for Chassis Supervision.\"\n        MODULE\n            MANDATORY-GROUPS\n            {\n                chasControlModuleGroup               ,\n                chasControlRedundantGroup            ,\n                chasChassisGroup                     ,\n                chasControlReloadStatusGroup         ,\n                chasGlobalControlGroup               ,\n                chassisNotificationGroup \n            }\n        ::= { alcatelIND1ChassisMIBCompliances 1 }\n    alcatelIND1ChassisPhysMIBCompliance MODULE-COMPLIANCE\n        STATUS  current\n        DESCRIPTION\n            \"Compliance statement for Chassis Supervision Physical.\"\n        MODULE\n            MANDATORY-GROUPS\n            {\n                chasEntPhysicalGroup                 ,\n                chassisPhysNotificationGroup \n            }\n        ::= { alcatelIND1ChassisPhysMIBCompliances 1 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n-- UNITS OF CONFORMANCE\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n    chasControlModuleGroup OBJECT-GROUP\n        OBJECTS\n        {\n            chasControlRunningVersion            ,\n            chasControlActivateTimeout           ,\n            chasControlVersionMngt               ,\n            chasControlDelayedActivateTimer                    	          \n        }\n        STATUS  current\n        DESCRIPTION\n            \"Chassis Supervision Control Modules Group.\"\n        ::= { alcatelIND1ChassisMIBGroups 1 }\n    chasControlRedundantGroup OBJECT-GROUP\n        OBJECTS\n        {\n            chasControlNumberOfTakeover	     ,\n            chasControlDelayedRebootTimer          \n        }\n        STATUS  current\n        DESCRIPTION\n            \"Chassis Supervision Redundant Control Modules Group.\"\n        ::= { alcatelIND1ChassisMIBGroups 2 }\n    chasChassisGroup OBJECT-GROUP\n        OBJECTS\n        {\n            chasFreeSlots           ,\n            chasPowerLeft           ,\n            chasNumberOfResets      ,\n            chasHardwareBoardTemp   ,\n            chasHardwareCpuTemp     ,\n            chasTempRange           ,\n            chasTempThreshold       ,\n            chasDangerTempThreshold ,\n            chasPrimaryPhysicalIndex	   \n        }\n        STATUS  current\n        DESCRIPTION\n            \"Chassis Supervision Chassis Group.\"\n        ::= { alcatelIND1ChassisMIBGroups 3 }\n    chasControlReloadStatusGroup OBJECT-GROUP\n        OBJECTS\n        {\n            chasControlReloadStatus          \n        }\n        STATUS  current\n        DESCRIPTION\n            \"Chassis Supervision NI Reload Status Control Modules Group.\"\n        ::= { alcatelIND1ChassisMIBGroups 4 }\n    chasGlobalControlGroup OBJECT-GROUP\n        OBJECTS\n        {\n            chasGlobalControlDelayedResetAll          \n        }\n        STATUS  current\n        DESCRIPTION\n            \"Chassis Supervision Global Control Modules Group.\"\n        ::= { alcatelIND1ChassisMIBGroups 5 }\n    chassisNotificationGroup NOTIFICATION-GROUP\n        NOTIFICATIONS	\n        {\n            chassisTrapsStr                  ,\n            chassisTrapsAlert                                 \n        }\n        STATUS  current\n        DESCRIPTION\n            \"Chassis Supervision Notification Group.\"\n        ::= { alcatelIND1ChassisMIBGroups 6 }\n    chasEntPhysicalGroup OBJECT-GROUP\n        OBJECTS	\n        {\n            chasEntPhysAdminStatus                ,\n            chasEntPhysOperStatus                 ,\n            chasEntPhysLedStatus                  ,\n            chasEntPhysPower                      ,\n            chasEntPhysModuleType                 ,\n            chasEntPhysMfgDate                    ,\n            chasEntPhysPartNumber                 \n        }\n        STATUS  current\n        DESCRIPTION\n            \"Chassis (inclosure) Entity Physical Group.\"\n        ::= { alcatelIND1ChassisPhysMIBGroups 1 }\n    chassisPhysNotificationGroup NOTIFICATION-GROUP\n        NOTIFICATIONS	\n        {\n            chassisTrapsStr                  ,\n            chassisTrapsAlert                ,\n            chassisTrapsStateChange                 \n        }\n        STATUS  current\n        DESCRIPTION\n            \"Chassis Supervision Physical Notification Group.\"\n        ::= { alcatelIND1ChassisPhysMIBGroups 2 }\nEND\n'),(9,'ALCATEL-IND1-HEALTH-MIB',1756979642,1756979642,1,'','ALCATEL-IND1-HEALTH-MIB DEFINITIONS ::= BEGIN\nIMPORTS\n	OBJECT-TYPE,\n	MODULE-IDENTITY,\n	OBJECT-IDENTITY,\n	NOTIFICATION-TYPE              FROM SNMPv2-SMI\n	MODULE-COMPLIANCE,\n	OBJECT-GROUP,\n	NOTIFICATION-GROUP             FROM SNMPv2-CONF\n	healthMonTraps,\n        softentIND1Health              FROM ALCATEL-IND1-BASE;\n \n	alcatelIND1HealthMonitorMIB MODULE-IDENTITY\n		LAST-UPDATED \"200108270000Z\"\n		ORGANIZATION \"Alcatel - Architects Of An Internet World\"\n		CONTACT-INFO\n            \"Please consult with Customer Service to insure the most appropriate\n             version of this document is used with the products in question:\n         \n                        Alcatel Internetworking, Incorporated\n                       (Division 1, Formerly XYLAN Corporation)\n                               26801 West Agoura Road\n                            Agoura Hills, CA  91301-5122\n                              United States Of America\n        \n            Telephone:               North America  +1 800 995 2696\n                                     Latin America  +1 877 919 9526\n                                     Europe         +31 23 556 0100\n                                     Asia           +65 394 7933\n                                     All Other      +1 818 878 4507\n        \n            Electronic Mail:         support@ind.alcatel.com\n            World Wide Web:          http://www.ind.alcatel.com\n            File Transfer Protocol:  ftp://ftp.ind.alcatel.com/pub/products/mibs\"\n		DESCRIPTION\n			\"This module describes an authoritative enterprise-specific Simple\n             Network Management Protocol (SNMP) Management Information Base (MIB):\n         \n                 For the Birds Of Prey Product Line\n		 Health Monitoring for dissemination of resource consumption information.\n         \n             The right to make changes in specification and other information\n             contained in this document without prior notice is reserved.\n         \n             No liability shall be assumed for any incidental, indirect, special, or\n             consequential damages whatsoever arising from or related to this\n             document or the information contained herein.\n         \n             Vendors, end-users, and other interested parties are granted\n             non-exclusive license to use this specification in connection with\n             management of the products for which it is intended to be used.\n         \n               Copyright (C) 1995-2002 Alcatel Internetworking, Incorporated\n                             ALL RIGHTS RESERVED WORLDWIDE\"\n		REVISION      \"200108270000Z\"\n        DESCRIPTION\n            \"Addressing discrepancies with Alcatel Standard.\"\n     	        ::= { softentIND1Health 1}\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	alcatelIND1HealthMonitorMIBObjects OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Health Montor Subsystem Managed Objects.\"\n            ::= { alcatelIND1HealthMonitorMIB 1 }\n    alcatelIND1HealthMonitorMIBConformance OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Health Montor Subsystem Managed Objects.\"\n            ::= { alcatelIND1HealthMonitorMIB 2 }\n    alcatelIND1HealthMonitorMIBGroups OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Health Montor Subsystem Managed Objects.\"\n            ::= { alcatelIND1HealthMonitorMIBConformance 1}\n    alcatelIND1HealthMonitorMIBCompliances OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Health Montor Subsystem Managed Objects.\"\n            ::= { alcatelIND1HealthMonitorMIBConformance 2}\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	healthDeviceInfo  OBJECT IDENTIFIER ::= { alcatelIND1HealthMonitorMIBObjects 1 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	--  healthDeviceInfo contains device-level\n	--  health monitoring information.  \n	healthDeviceRxLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level input utilization over the\n		 latest sample period (percent).\"\n	    ::= { healthDeviceInfo 1 }\n	healthDeviceRx1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level input utilization over the\n		 last minute (percent).\"\n	    ::= { healthDeviceInfo 2 }\n	healthDeviceRx1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level input utilization over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 3 }\n	healthDeviceRx1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute device-level input utilization over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 4 }\n	healthDeviceRxTxLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level i/o utilization over the\n		 latest sample period (percent).\"\n	    ::= { healthDeviceInfo 5 }\n	healthDeviceRxTx1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level i/o utilization over the\n		 last minute (percent).\"\n	    ::= { healthDeviceInfo 6 }\n	healthDeviceRxTx1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level i/o utilization over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 7 }\n	healthDeviceRxTx1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute device-level i/o utilization over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 8 }\n	healthDeviceMemoryLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level memory utilization over the\n		 latest sample period (percent).\"\n	    ::= { healthDeviceInfo 9 }\n	healthDeviceMemory1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level memory utilization over the\n		 last minute (percent).\"\n	    ::= { healthDeviceInfo 10 }\n	healthDeviceMemory1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level memory utilization over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 11 }\n	healthDeviceMemory1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute device-level memory utilization over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 12 }\n	healthDeviceCpuLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level CPU utilization over the\n		 latest sample period (percent).\"\n	    ::= { healthDeviceInfo 13 }\n	healthDeviceCpu1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level CPU utilization over the\n		 last minute (percent).\"\n	    ::= { healthDeviceInfo 14 }\n	healthDeviceCpu1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average device-level CPU utilization over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 15 }\n	healthDeviceCpu1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute device-level CPU utilization over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 16 }\n	healthDeviceTemperatureChasLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average chassis temperature over the\n		 latest sample period (percent).\"\n	    ::= { healthDeviceInfo 17 }\n	healthDeviceTemperatureChas1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average chassis temperature over the\n		 last minute (percent).\"\n	    ::= { healthDeviceInfo 18 }\n	healthDeviceTemperatureChas1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average chassis temperature over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 19 }\n	healthDeviceTemperatureChas1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute chassis temperature over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 20 }\n	healthDeviceTemperatureCmmCpuLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average CMM CPU temperature over the\n		 latest sample period (percent).\"\n	    ::= { healthDeviceInfo 21 }\n	healthDeviceTemperatureCmmCpu1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average CMM CPU temperature over the\n		 last minute (percent).\"\n	    ::= { healthDeviceInfo 22 }\n	healthDeviceTemperatureCmmCpu1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average CMM CPU temperature over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 23 }\n	healthDeviceTemperatureCmmCpu1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute CMM CPU temperature over the\n		 last hour (percent).\"\n	    ::= { healthDeviceInfo 24 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	healthModuleInfo  OBJECT IDENTIFIER ::= { alcatelIND1HealthMonitorMIBObjects 2 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	--  healthModuleInfo contains slot-level health monitoring information.\n	healthModuleTable  OBJECT-TYPE\n	    SYNTAX  SEQUENCE OF HealthModuleEntry\n	    MAX-ACCESS  not-accessible\n	    STATUS  current\n	    DESCRIPTION\n		\"A list of installed modules in this chassis.\"\n	    ::= { healthModuleInfo 1 }\n	healthModuleEntry  OBJECT-TYPE\n	    SYNTAX  HealthModuleEntry\n	    MAX-ACCESS  not-accessible\n	    STATUS  current\n	    DESCRIPTION\n		\"A module entry containing objects for a module in a specific \'slot\'.\"\n	    INDEX { healthModuleSlot }\n	    ::= { healthModuleTable 1 }\n	HealthModuleEntry ::= SEQUENCE {\n	    healthModuleSlot\n			INTEGER,\n	    healthModuleRxLatest\n			INTEGER,\n	    healthModuleRx1MinAvg\n			INTEGER,\n	    healthModuleRx1HrAvg\n			INTEGER,\n	    healthModuleRx1HrMax\n			INTEGER,\n	    healthModuleRxTxLatest\n			INTEGER,\n	    healthModuleRxTx1MinAvg\n			INTEGER,\n	    healthModuleRxTx1HrAvg\n			INTEGER,\n	    healthModuleRxTx1HrMax\n			INTEGER,\n	    healthModuleMemoryLatest\n			INTEGER,\n	    healthModuleMemory1MinAvg\n			INTEGER,\n	    healthModuleMemory1HrAvg\n			INTEGER,\n	    healthModuleMemory1HrMax\n			INTEGER,\n	    healthModuleCpuLatest\n			INTEGER,\n	    healthModuleCpu1MinAvg\n			INTEGER,\n	    healthModuleCpu1HrAvg\n			INTEGER,\n	    healthModuleCpu1HrMax\n			INTEGER\n	    }\n	healthModuleSlot  OBJECT-TYPE\n	    SYNTAX  INTEGER  (1..64)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"The (one-based) front slot number within the chassis.\"\n	    ::= { healthModuleEntry 1 }\n	healthModuleRxLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level input utilization over the \n		 latest sample period (percent).\"\n	    ::= { healthModuleEntry 2 }\n	healthModuleRx1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level input utilization over the \n		 last minute (percent).\"\n	    ::= { healthModuleEntry 3 }\n	healthModuleRx1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level input utilization over the \n		 last hour (percent).\"\n	    ::= { healthModuleEntry 4 }\n	healthModuleRx1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute module-level input utilization over the \n		 last hour (percent).\"\n	    ::= { healthModuleEntry 5 }\n	healthModuleRxTxLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level i/o utilization over the \n		 latest sample period (percent).\"\n	    ::= { healthModuleEntry 6 }\n	healthModuleRxTx1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level i/o utilization over the \n		 last minute (percent).\"\n	    ::= { healthModuleEntry 7 }\n	healthModuleRxTx1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level i/o utilization over the \n		 last hour (percent).\"\n	    ::= { healthModuleEntry 8 }\n	healthModuleRxTx1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute module-level i/o utilization over the \n		 last hour (percent).\"\n	    ::= { healthModuleEntry 9 }\n	healthModuleMemoryLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level memory utilization over the\n		 latest sample period (percent).\"\n	    ::= { healthModuleEntry 10 }\n	healthModuleMemory1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level memory utilization over the\n		 last minute (percent).\"\n	    ::= { healthModuleEntry 11 }\n	healthModuleMemory1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level memory utilization over the\n		 last hour (percent).\"\n	    ::= { healthModuleEntry 12 }\n	healthModuleMemory1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute module-level memory utilization over the\n		 last hour (percent).\"\n	    ::= { healthModuleEntry 13 }\n	healthModuleCpuLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level CPU utilization over the\n		 latest sample period (percent).\"\n	    ::= { healthModuleEntry 14 }\n	healthModuleCpu1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level CPU utilization over the\n		 last minute (percent).\"\n	    ::= { healthModuleEntry 15 }\n	healthModuleCpu1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average module-level CPU utilization over the\n		 last hour (percent).\"\n	    ::= { healthModuleEntry 16 }\n	healthModuleCpu1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute module-level CPU utilization over the\n		 last hour (percent).\"\n	    ::= { healthModuleEntry 17 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	healthPortInfo  OBJECT IDENTIFIER ::= { alcatelIND1HealthMonitorMIBObjects 3 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	--  healthPortInfo contains port-level health monitoring information.\n	HealthPortUpDownStatus ::= INTEGER {\n	    healthPortDn(1),\n	    healthPortUp(2)\n	}\n	healthPortTable  OBJECT-TYPE\n	    SYNTAX  SEQUENCE OF HealthPortEntry\n	    MAX-ACCESS  not-accessible\n	    STATUS  current\n	    DESCRIPTION\n		\"A list of Physical Port health instances.\"\n	    ::= { healthPortInfo 1 }\n	healthPortEntry  OBJECT-TYPE\n	    SYNTAX  HealthPortEntry\n	    MAX-ACCESS  not-accessible\n	    STATUS  current\n	    DESCRIPTION\n		\"A Physical Port health entry.\"\n	    INDEX { healthPortSlot, healthPortIF }\n	    ::= { healthPortTable 1 }\n	HealthPortEntry ::= SEQUENCE {\n	    healthPortSlot\n			INTEGER,\n	    healthPortIF\n			INTEGER,\n	    healthPortUpDn\n			HealthPortUpDownStatus,\n	    healthPortRxLatest\n			INTEGER,\n	    healthPortRx1MinAvg\n			INTEGER,\n	    healthPortRx1HrAvg\n			INTEGER,\n	    healthPortRx1HrMax\n			INTEGER,\n	    healthPortRxTxLatest\n			INTEGER,\n	    healthPortRxTx1MinAvg\n			INTEGER,\n	    healthPortRxTx1HrAvg\n			INTEGER,\n	    healthPortRxTx1HrMax\n			INTEGER\n	    }\n	healthPortSlot  OBJECT-TYPE\n	    SYNTAX  INTEGER (1..64)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"The physical slot number for this port.\"\n	    ::= { healthPortEntry 1 }\n	healthPortIF  OBJECT-TYPE\n	    SYNTAX  INTEGER  (1..64)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"The on-board interface number.\"\n	    ::= { healthPortEntry 2 }\n	healthPortUpDn  OBJECT-TYPE\n	    SYNTAX  HealthPortUpDownStatus \n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"The status of this port.\"\n	    ::= { healthPortEntry 3 }\n	healthPortRxLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average port-level input utilization over the \n		 latest sample period (percent).\"\n	    ::= { healthPortEntry 4 }\n	healthPortRx1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average port-level input utilization over the \n		 last minute (percent).\"\n	    ::= { healthPortEntry 5 }\n	healthPortRx1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average port-level input utilization over the \n		 last hour (percent).\"\n	    ::= { healthPortEntry 6 }\n	healthPortRx1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute port-level input utilization over the \n		 last hour (percent).\"\n	    ::= { healthPortEntry 7 }\n	healthPortRxTxLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average port-level i/o utilization over the \n		 latest sample period (percent).\"\n	    ::= { healthPortEntry 8 }\n	healthPortRxTx1MinAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average port-level i/o utilization over the \n		 last minute (percent).\"\n	    ::= { healthPortEntry 9 }\n	healthPortRxTx1HrAvg  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Average port-level i/o utilization over the \n		 last hour (percent).\"\n	    ::= { healthPortEntry 10 }\n	healthPortRxTx1HrMax  OBJECT-TYPE\n	    SYNTAX  INTEGER (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Maximum one-minute port-level i/o utilization over the \n		 last hour (percent).\"\n	    ::= { healthPortEntry 11 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	healthControlInfo  OBJECT IDENTIFIER ::= { alcatelIND1HealthMonitorMIBObjects 4 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	--  healthControl contains the variables\n	--  which control operation of resource utilization sampling. \n	--\n        healthSamplingInterval OBJECT-TYPE\n	      SYNTAX  INTEGER  (1..30)\n              MAX-ACCESS  read-write\n              STATUS  current\n              DESCRIPTION\n                 \"Time interval between consecutive samples of resources.\n		  Units are seconds.  Legal values are:               1,2,3,4,5,6,10,12,15,20,30.\"\n              DEFVAL  { 5 }\n              ::= { healthControlInfo 1 }\n        healthSamplingReset OBJECT-TYPE\n              SYNTAX  INTEGER   (1..2147483647)\n              MAX-ACCESS  read-write\n              STATUS  current\n              DESCRIPTION\n                 \"Any set of this variable causes all health counters to reset\n		  to zero and a restart of sampling.\"\n              DEFVAL  { 1 }\n              ::= { healthControlInfo 2 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	healthThreshInfo  OBJECT IDENTIFIER ::= { alcatelIND1HealthMonitorMIBObjects 5 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	--  healthThreshInfo contains the threshold data.\n	--\n	healthThreshDeviceRxLimit  OBJECT-TYPE\n 	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-write\n	    STATUS  current\n	    DESCRIPTION\n  		\"Device input threshold value.  Units are percent.\"\n            DEFVAL  { 80 }\n	    ::= { healthThreshInfo 1 }\n	healthThreshDeviceRxTxLimit  OBJECT-TYPE\n 	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-write\n	    STATUS  current\n	    DESCRIPTION\n  		\"Device input/output threshold value.  Units are percent.\"\n            DEFVAL  { 80 }\n	    ::= { healthThreshInfo 2 }\n	healthThreshDeviceMemoryLimit  OBJECT-TYPE\n 	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-write\n	    STATUS  current\n	    DESCRIPTION\n  		\"Device memory threshold value.  Units are percent.\"\n            DEFVAL  { 80 }\n	    ::= { healthThreshInfo 3 }\n	    \n	healthThreshDeviceCpuLimit  OBJECT-TYPE\n 	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-write\n	    STATUS  current\n	    DESCRIPTION\n  		\"Device Cpu threshold value.  Units are percent.\"\n            DEFVAL  { 80 }\n	    ::= { healthThreshInfo 4 }\n	healthThreshDeviceRxSecondaryLimit  OBJECT-TYPE\n 	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-write\n	    STATUS  current\n	    DESCRIPTION\n  		\"Device input secondary threshold value.  Units are percent.\"\n            DEFVAL  { 60 }\n	    ::= { healthThreshInfo 5 }\n	healthThreshDeviceRxTxSecondaryLimit  OBJECT-TYPE\n 	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-write\n	    STATUS  current\n	    DESCRIPTION\n  		\"Device input/output secondary threshold value.  Units are percent.\"\n            DEFVAL  { 60 }\n	    ::= { healthThreshInfo 6 }\n	healthThreshDeviceMemorySecondaryLimit  OBJECT-TYPE\n 	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-write\n	    STATUS  current\n	    DESCRIPTION\n  		\"Device memory secondary threshold value.  Units are percent.\"\n            DEFVAL  { 60 }\n	    ::= { healthThreshInfo 7 }\n	    \n	healthThreshDeviceCpuSecondaryLimit  OBJECT-TYPE\n 	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-write\n	    STATUS  current\n	    DESCRIPTION\n  		\"Device CPU secondary threshold value.  Units are percent.\"\n            DEFVAL  { 60 }\n	    ::= { healthThreshInfo 8 }\n	healthThreshDeviceTempLimit  OBJECT-TYPE\n 	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-write\n	    STATUS  current\n	    DESCRIPTION\n  		\"Device Temperature threshold value.  Units are degrees Celsius.\"\n            DEFVAL  { 50 }\n	    ::= { healthThreshInfo 9 }\n	healthThreshDeviceTempSecondaryLimit  OBJECT-TYPE\n 	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-write\n	    STATUS  current\n	    DESCRIPTION\n  		\"Device Temperature secondary threshold value.  Units are degrees Celsius.\"\n            DEFVAL  { 40 }\n	    ::= { healthThreshInfo 10 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	healthSliceInfo  OBJECT IDENTIFIER ::= { alcatelIND1HealthMonitorMIBObjects 7 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	--  healthSliceInfo contains the slice data.\n	--\n	healthSliceTable  OBJECT-TYPE\n	    SYNTAX  SEQUENCE OF HealthSliceEntry\n	    MAX-ACCESS  not-accessible\n	    STATUS  current\n	    DESCRIPTION\n		\"A list of Physical Slice health instances.\"\n	    ::= { healthSliceInfo 1 }\n	healthSliceEntry  OBJECT-TYPE\n	    SYNTAX  HealthSliceEntry\n	    MAX-ACCESS  not-accessible\n	    STATUS  current\n	    DESCRIPTION\n		\"A Physical Slice health entry.\"\n	    INDEX { healthSliceSlot, healthSliceSlice }\n	    ::= { healthSliceTable 1 }\n	HealthSliceEntry ::= SEQUENCE {\n	    healthSliceSlot\n			INTEGER,\n	    healthSliceSlice\n			INTEGER,\n	    healthSliceMemoryLatest\n			INTEGER,\n	    healthSliceCpuLatest\n			INTEGER\n	    }\n	healthSliceSlot  OBJECT-TYPE\n	    SYNTAX  INTEGER (1..64)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"The physical slot number for this slice.\"\n	    ::= { healthSliceEntry 1 }\n	healthSliceSlice  OBJECT-TYPE\n	    SYNTAX  INTEGER  (1..64)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"The on-board slice number.\"\n	    ::= { healthSliceEntry 2 }\n	healthSliceMemoryLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Slice-level memory utilization over the\n		 latest sample period (percent).\"\n	    ::= { healthSliceEntry 3 }\n	healthSliceCpuLatest  OBJECT-TYPE\n	    SYNTAX  INTEGER  (0..100)\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n		\"Slice-level Cpu utilization over the\n		 latest sample period (percent).\"\n	    ::= { healthSliceEntry 4 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	healthTrapInfo  OBJECT IDENTIFIER ::= { alcatelIND1HealthMonitorMIBObjects 6 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	--  healthTrapInfo contains objects exclusively used in traps.\n	--\n	healthMonRxStatus  OBJECT-TYPE\n 	    SYNTAX  INTEGER  {\n		     crossedBelowThreshold (1),\n		     noChange              (2),\n		     crossedAboveThreshold (3)\n                             }\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n  		\"Rx threshold status.\"\n	    ::= { healthTrapInfo 1 }\n	healthMonRxTxStatus  OBJECT-TYPE\n 	    SYNTAX  INTEGER  {\n		     crossedBelowThreshold (1),\n		     noChange              (2),\n		     crossedAboveThreshold (3)\n                             }\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n  		\"RxTx threshold status.\"\n	    ::= { healthTrapInfo 2 }\n	healthMonMemoryStatus  OBJECT-TYPE\n 	    SYNTAX  INTEGER  {\n		     crossedBelowThreshold (1),\n		     noChange              (2),\n		     crossedAboveThreshold (3)\n                             }\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n  		\"Memory threshold status.\"\n	    ::= { healthTrapInfo 3 }\n	healthMonCpuStatus  OBJECT-TYPE\n 	    SYNTAX  INTEGER  {\n		     crossedBelowThreshold (1),\n		     noChange              (2),\n		     crossedAboveThreshold (3)\n                             }\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n  		\"CPU threshold status.\"\n	    ::= { healthTrapInfo 4 }\n	healthMonCmmTempStatus  OBJECT-TYPE\n 	    SYNTAX  INTEGER  {\n		     crossedBelowThreshold (1),\n		     noChange              (2),\n		     crossedAboveThreshold (3)\n                             }\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n  		\"CMM temperature threshold status.\"\n	    ::= { healthTrapInfo 5 }\n	healthMonCmmCpuTempStatus  OBJECT-TYPE\n 	    SYNTAX  INTEGER  {\n		     crossedBelowThreshold (1),\n		     noChange              (2),\n		     crossedAboveThreshold (3)\n                             }\n	    MAX-ACCESS  read-only\n	    STATUS  current\n	    DESCRIPTION\n  		\"CMM CPU temperature threshold status.\"\n	    ::= { healthTrapInfo 6 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n--  NOTIFICATIONS\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n	healthMonDeviceTrap  NOTIFICATION-TYPE\n	   OBJECTS { \n	       healthMonRxStatus, \n	       healthMonRxTxStatus, \n	       healthMonMemoryStatus, \n	       healthMonCpuStatus, \n	       healthMonCmmTempStatus, \n	       healthMonCmmCpuTempStatus\n		   }\n	   STATUS   current\n	   DESCRIPTION \n	       \"Device-level rising/falling threshold crossing trap.\"\n	    ::= { healthMonTraps 0 1 }\n	healthMonModuleTrap  NOTIFICATION-TYPE\n	   OBJECTS { \n	       healthModuleSlot,\n	       healthMonRxStatus, \n	       healthMonRxTxStatus,\n	       healthMonMemoryStatus, \n	       healthMonCpuStatus \n		   }\n	   STATUS   current\n	   DESCRIPTION \n	       \"Module-level rising/falling threshold crossing trap.\"\n	    ::= { healthMonTraps 0 2 }\n	healthMonPortTrap  NOTIFICATION-TYPE\n	   OBJECTS { \n	       healthPortSlot,\n	       healthPortIF,\n	       healthMonRxStatus, \n	       healthMonRxTxStatus \n		   }\n	   STATUS   current\n	   DESCRIPTION \n	       \"Port-level rising/falling threshold crossing trap.\"\n	    ::= { healthMonTraps 0 3 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n-- COMPLIANCE\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n    alcatelIND1HealthMonitorMIBCompliance MODULE-COMPLIANCE\n        STATUS  current\n        DESCRIPTION\n            \"Compliance statement for Health Monitoring.\"\n        MODULE\n            MANDATORY-GROUPS\n            {\n                healthDeviceGroup,\n                healthModuleGroup,\n                healthPortGroup,\n                healthControlGroup,\n                healthThreshGroup,\n                healthSliceGroup\n            }\n        ::= { alcatelIND1HealthMonitorMIBCompliances 1 }\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n-- UNITS OF CONFORMANCE\n-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n    healthDeviceGroup OBJECT-GROUP\n        OBJECTS\n        {\n	                healthDeviceRxLatest,\n	                healthDeviceRx1MinAvg,\n	                healthDeviceRx1HrAvg,\n	                healthDeviceRx1HrMax,\n	                healthDeviceRxTxLatest,\n	                healthDeviceRxTx1MinAvg,\n	                healthDeviceRxTx1MinAvg,\n	                healthDeviceRxTx1HrAvg,\n	                healthDeviceRxTx1HrMax,\n	                healthDeviceMemoryLatest,\n	                healthDeviceMemory1MinAvg,\n	                healthDeviceMemory1HrAvg,\n	                healthDeviceMemory1HrMax,\n	                healthDeviceCpuLatest,\n	                healthDeviceCpu1MinAvg,\n	                healthDeviceCpu1HrAvg,\n	                healthDeviceCpu1HrMax,\n	                healthDeviceTemperatureChas1HrMax,\n	                healthDeviceTemperatureChasLatest,\n	                healthDeviceTemperatureChas1MinAvg,\n	                healthDeviceTemperatureChas1HrAvg,\n	                healthDeviceTemperatureChas1HrMax,\n	                healthDeviceTemperatureCmmCpuLatest,\n	                healthDeviceTemperatureCmmCpu1MinAvg,\n	                healthDeviceTemperatureCmmCpu1HrAvg,\n	                healthDeviceTemperatureCmmCpu1HrMax\n        }\n        STATUS  current\n        DESCRIPTION\n            \"Collection of device-level health monitoring objects.\"\n        ::= { alcatelIND1HealthMonitorMIBGroups 1 }\n    healthModuleGroup OBJECT-GROUP\n        OBJECTS\n        {\n	                healthModuleSlot,      \n	                healthModuleRxLatest,\n	                healthModuleRx1MinAvg,\n	                healthModuleRx1HrAvg,\n	                healthModuleRx1HrMax,\n	                healthModuleRxTxLatest,\n	                healthModuleRxTx1MinAvg,\n	                healthModuleRxTx1MinAvg,\n	                healthModuleRxTx1HrAvg,\n	                healthModuleRxTx1HrMax,\n	                healthModuleMemoryLatest,\n	                healthModuleMemory1MinAvg,\n	                healthModuleMemory1HrAvg,\n	                healthModuleMemory1HrMax,\n	                healthModuleCpuLatest,\n	                healthModuleCpu1MinAvg,\n	                healthModuleCpu1HrAvg,\n	                healthModuleCpu1HrMax  \n        }\n        STATUS  current\n        DESCRIPTION\n            \"Collection of slot-level health monitoring objects.\"\n        ::= { alcatelIND1HealthMonitorMIBGroups 2 }\n    healthPortGroup OBJECT-GROUP\n        OBJECTS\n        {\n	                healthPortSlot,      \n	                healthPortIF,      \n	                healthPortRxLatest,\n	                healthPortRx1MinAvg,\n	                healthPortRx1HrAvg,\n	                healthPortRx1HrMax,\n	                healthPortRxTxLatest,\n	                healthPortRxTx1MinAvg,\n	                healthPortRxTx1MinAvg,\n	                healthPortRxTx1HrAvg,\n	                healthPortRxTx1HrMax\n        }\n        STATUS  current\n        DESCRIPTION\n            \"Collection of port-level health monitoring objects.\"\n        ::= { alcatelIND1HealthMonitorMIBGroups 3 }\n    healthControlGroup OBJECT-GROUP\n        OBJECTS\n        {\n                        healthSamplingInterval,\n                        healthSamplingReset\n        }\n        STATUS  current\n        DESCRIPTION\n            \"Collection of objects which control operation of resource utilization sampling.\"\n        ::= { alcatelIND1HealthMonitorMIBGroups 4 }\n    healthThreshGroup OBJECT-GROUP\n        OBJECTS\n        {\n	                healthThreshDeviceRxLimit,\n	                healthThreshDeviceRxTxLimit,\n	                healthThreshDeviceMemoryLimit,\n	                healthThreshDeviceCpuLimit,\n	                healthThreshDeviceRxSecondaryLimit,\n	                healthThreshDeviceRxTxSecondaryLimit,\n	                healthThreshDeviceMemorySecondaryLimit,\n	                healthThreshDeviceCpuSecondaryLimit,\n	                healthThreshDeviceTempLimit,\n	                healthThreshDeviceTempSecondaryLimit\n        }\n        STATUS  current\n        DESCRIPTION\n            \"Collection of threshold objects.\"\n        ::= { alcatelIND1HealthMonitorMIBGroups 5 }\n    healthTrapObjectsGroup OBJECT-GROUP\n        OBJECTS\n        {\n	                healthMonRxStatus,\n	                healthMonRxTxStatus,\n	                healthMonMemoryStatus,\n	                healthMonCpuStatus,\n	                healthMonCmmTempStatus,\n	                healthMonCmmCpuTempStatus\n        }\n        STATUS  current\n        DESCRIPTION\n            \"Collection of objects which appear only in traps.\"\n        ::= { alcatelIND1HealthMonitorMIBGroups 6 }\n    healthTrapsGroup NOTIFICATION-GROUP\n	NOTIFICATIONS {\n	                healthMonDeviceTrap,\n	                healthMonModuleTrap,\n	                healthMonPortTrap\n	}\n        STATUS  current\n        DESCRIPTION\n            \"Collection of Traps for health monitoring.\"\n        ::= { alcatelIND1HealthMonitorMIBGroups 7 }\n    healthSliceGroup OBJECT-GROUP\n        OBJECTS\n        {\n	                healthSliceSlot,      \n	                healthSliceSlice,      \n	                healthSliceMemoryLatest,      \n	                healthSliceCpuLatest\n        }\n        STATUS  current\n        DESCRIPTION\n            \"Collection of slice-level health monitoring objects.\"\n        ::= { alcatelIND1HealthMonitorMIBGroups 8 }\n	END\n'),(10,'ALCATEL-IND1-SYSTEM-MIB',1756979642,1756979642,1,'','ALCATEL-IND1-SYSTEM-MIB DEFINITIONS ::= BEGIN\n		IMPORTS\n		MODULE-IDENTITY, OBJECT-IDENTITY, OBJECT-TYPE, IpAddress,\n		Unsigned32\n			FROM SNMPv2-SMI\n		MODULE-COMPLIANCE, OBJECT-GROUP\n			FROM SNMPv2-CONF\n		DisplayString, TEXTUAL-CONVENTION, TruthValue\n			FROM SNMPv2-TC\n		hardentIND1System\n			FROM ALCATEL-IND1-BASE;\n	alcatelIND1SystemMIB MODULE-IDENTITY\n		LAST-UPDATED \"200109190000Z\"\n		ORGANIZATION \"Alcatel - Architects Of An Internet World\"\n		CONTACT-INFO\n		     \"Please consult with Customer Service to insure the most appropriate\n             version of this document is used with the products in question:\n                        Alcatel Internetworking, Incorporated\n                       (Division 1, Formerly XYLAN Corporation)\n                               26801 West Agoura Road\n            Telephone:               North America  +1 800 995 2696\n                                     Latin America  +1 877 919 9526\n                                     Europe         +31 23 556 0100\n                                     Asia           +65 394 7933\n                                     All Other      +1 818 878 4507\n            Electronic Mail:         support@ind.alcatel.com\n            World Wide Web:          http://www.ind.alcatel.com\n            File Transfer Protocol:  ftp://ftp.ind.alcatel.com/pub/products/mibs\"\n		DESCRIPTION\n            \"This module describes an authoritative enterprise-specific Simple\n             Network Management Protocol (SNMP) Management Information Base (MIB):\n                 For the Birds Of Prey Product Line\n                 Proprietary System Subsystem.\n             No liability shall be assumed for any incidental, indirect, special, or\n             consequential damages whatsoever arising from or related to this\n             document or the information contained herein.\n             Vendors, end-users, and other interested parties are granted\n             non-exclusive license to use this specification in connection with\n             management of the products for which it is intended to be used.\n               Copyright (C) 1995-2002 Alcatel Internetworking, Incorporated\n                             ALL RIGHTS RESERVED WORLDWIDE\"\n        REVISION      \"200111130000Z\"\n        DESCRIPTION\n            \"The latest version of this MIB Module.\"\n            ::= {hardentIND1System 1 }\n    alcatelIND1SystemMIBObjects OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For BOP Proprietary System\n            Subsystem Managed Objects.\"\n        ::= { alcatelIND1SystemMIB 1 }\n    alcatelIND1SystemMIBConformance OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Alcatel IND BOP Proprietary System\n            Subsystem Conformance Information.\"\n        ::= { alcatelIND1SystemMIB 2 }\n    alcatelIND1SystemMIBGroups OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Alcatel IND BOP Proprietary System\n            Subsystem Units Of Conformance.\"\n        ::= { alcatelIND1SystemMIBConformance 1 }\n    alcatelIND1SystemMIBCompliances OBJECT-IDENTITY\n        STATUS current\n        DESCRIPTION\n            \"Branch For Alcatel IND BOP Proprietary System\n            Subsystem Compliance Statements.\"\n        ::= { alcatelIND1SystemMIBConformance 2 }\n	-- textual conventions\n	SystemFileType ::= TEXTUAL-CONVENTION\n		STATUS		current\n		DESCRIPTION\n			\"a small positive integer used to identify file types\"\n		SYNTAX	INTEGER	{\n							file(1),\n							directory(2),\n							undefined(3)\n						}\n	SwitchLoggingIndex ::= TEXTUAL-CONVENTION\n		STATUS		current\n		DESCRIPTION\n		\"a small positive integer used to identify switch logging outputs\"\n		SYNTAX INTEGER	{	console(1),\n							flash(2),\n							socket(3),\n							ipaddr(4)\n						}\n	MicrocodeDirectoryIndex ::= TEXTUAL-CONVENTION\n		STATUS		current\n		DESCRIPTION\n			\"a small positive integer used to index into the Microcode table\"\n		SYNTAX	INTEGER	{\n							loaded(1),		-- the loaded directory\n							certified(2),	-- the certified directory\n							working(3)		-- the working directory\n						}\n	AppIdIndex ::= TEXTUAL-CONVENTION\n		STATUS		current\n		DESCRIPTION\n			\"a small positive integer used to index into tables arranged\n			by Application ID\'s.\"\n		SYNTAX	INTEGER (0..254)	-- 255 possible application id\'s\n	Enable ::= TEXTUAL-CONVENTION\n		STATUS		current\n		DESCRIPTION\n			\"an enumerated value used to indicate whether an entity is\n			enabled(1), or disabled(2)\"\n		SYNTAX	INTEGER	{\n							enabled(1),\n							disabled(2)\n						}\n	NumFpgaOnBoard ::= TEXTUAL-CONVENTION\n   		STATUS       current\n		DESCRIPTION\n			\"an enumerated value which provides an indication of how\n			FPGA\'s exist on this CMM.  The value is a small positive integer.\"\n		SYNTAX	INTEGER {\n							falcon(1),	-- range (1..2) 2 FPGAs\n							eagle (2),	-- range (1..3) 3 FPGAs\n							hawk (3)    -- range (0..0) 0 FPGAs\n						}\n	FileSystemIndex ::= TEXTUAL-CONVENTION\n   		STATUS       current\n		DESCRIPTION\n			\"an enumerated value which provides an indication of the\n			file system.  The value is a small positive integer indicating\n			the type of the file system\"\n		SYNTAX	INTEGER {\n							flash(1)	-- only flash for now, simm later?\n						}\n	SeverityLevel ::= TEXTUAL-CONVENTION\n   		STATUS       current\n		DESCRIPTION\n			\"an enumerated value which provides an indication of the\n			severity level used for logging and debug purposes.  The value is\n			a small integer.\"\n		SYNTAX	INTEGER\n				{\n					severityLevelOff (1), -- logging turned off\n					severityLevelAlarm(2), -- about to crash and reboot\n					severityLevelError(3), -- functionality is reduced\n					severityLevelAlert(4), -- a violation has occurred\n					severityLevelWarn (5), -- unexpected, non critical event\n					severityLevelInfo (6), -- any other msg that is not a dbg msg\n					severityLevelDbg1 (7), -- normal event debug message\n					severityLevelDbg2 (8), -- debug specific message\n					severityLevelDbg3 (9)  -- maximum verbosity dbg specific msg\n				}\n    --  groups within the system mib\n	systemMicrocode		OBJECT IDENTIFIER	::= {alcatelIND1SystemMIBObjects 1 }\n    systemBootParams	OBJECT IDENTIFIER	::= {alcatelIND1SystemMIBObjects 2 }\n	systemHardware		OBJECT IDENTIFIER	::= {alcatelIND1SystemMIBObjects 3 }\n	systemFileSystem	OBJECT IDENTIFIER	::= {alcatelIND1SystemMIBObjects 4 }\n	systemServices		OBJECT IDENTIFIER	::= {alcatelIND1SystemMIBObjects 5 }\n	systemSwitchLogging	OBJECT IDENTIFIER	::= {alcatelIND1SystemMIBObjects 6 }\n	systemDNS			OBJECT IDENTIFIER	::= {alcatelIND1SystemMIBObjects 7 }\n	-- systemMicrocode group.  This group contains the CMM specific\n	-- microcode information.\n	systemMicrocodeTable	OBJECT-TYPE\n		SYNTAX		SEQUENCE OF SystemMicrocodeEntry\n		MAX-ACCESS  not-accessible\n		STATUS      current\n		DESCRIPTION\n			\"This table contains one row per set of microcode objects.\n			There is always at least one set of microcode objects for each\n			CMM System Module\"\n		::= {systemMicrocode 1}\n    systemMicrocodeEntry	OBJECT-TYPE\n        SYNTAX		SystemMicrocodeEntry\n        MAX-ACCESS	not-accessible\n        STATUS	    current\n        DESCRIPTION\n        	\"The Microcode information for this CMM\"\n        INDEX	{systemMicrocodeIndex}\n        ::= {systemMicrocodeTable 1}\n	SystemMicrocodeEntry ::= SEQUENCE 	{\n			systemMicrocodeIndex	MicrocodeDirectoryIndex -- top level\n		}\n    systemMicrocodeIndex	OBJECT-TYPE\n        SYNTAX		MicrocodeDirectoryIndex\n        MAX-ACCESS	read-only\n        STATUS		current\n        DESCRIPTION\n		\"The index to the highest level of the microcode table.  This\n		level is organized by the directory being referenced.\"\n		::={ systemMicrocodeEntry 1 }\n	systemMicrocodePackageTable	OBJECT-TYPE\n		SYNTAX	SEQUENCE OF	SystemMicrocodePackageEntry\n		MAX-ACCESS	not-accessible\n		STATUS	current\n		DESCRIPTION\n			\"the microcode package table\"\n		::= {systemMicrocode 2}\n	systemMicrocodePackageEntry	OBJECT-TYPE\n		SYNTAX	SystemMicrocodePackageEntry\n		MAX-ACCESS	not-accessible\n		STATUS	current\n		DESCRIPTION\n			\"a row in the microcode package table\"\n		INDEX	{systemMicrocodeIndex, systemMicrocodePackageIndex}\n		::= {systemMicrocodePackageTable 1}\n	SystemMicrocodePackageEntry	::= SEQUENCE {\n			systemMicrocodePackageIndex			Unsigned32,\n			systemMicrocodePackageVersion		DisplayString,\n			systemMicrocodePackageName			DisplayString,\n			systemMicrocodePackageDescription	DisplayString,\n			systemMicrocodePackageStatus		INTEGER,\n			systemMicrocodePackageSize			Unsigned32\n		}\n	systemMicrocodePackageIndex	OBJECT-TYPE\n		SYNTAX	Unsigned32\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"The index to the package sub table in the microcode table\"\n		::= {systemMicrocodePackageEntry 1}\n	systemMicrocodePackageVersion OBJECT-TYPE\n		SYNTAX	DisplayString	(SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The version of the microcode package (Fos.img, Fbase.img, etc.)\"\n		::=	{systemMicrocodePackageEntry 2}\n	systemMicrocodePackageName OBJECT-TYPE\n		SYNTAX	DisplayString	(SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The name of the microcode package\"\n		DEFVAL	{ \"\" }\n		::=	{systemMicrocodePackageEntry 3}\n	systemMicrocodePackageDescription OBJECT-TYPE\n		SYNTAX	DisplayString	(SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The description of the microcode package\"\n		DEFVAL	{ \"\" }\n		::=	{systemMicrocodePackageEntry 4}\n	systemMicrocodePackageStatus OBJECT-TYPE\n		SYNTAX	INTEGER {\n							undefined(1),\n							ok(2),\n							inuse(3)\n						}\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The status of the microcode package\"\n		DEFVAL	{ undefined }\n		::=	{systemMicrocodePackageEntry 5}\n	systemMicrocodePackageSize OBJECT-TYPE\n		SYNTAX	Unsigned32\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The size of the microcode package\"\n		DEFVAL	{ 0 }\n		::=	{systemMicrocodePackageEntry 6}\n	systemMicrocodeComponentTable	OBJECT-TYPE\n		SYNTAX	SEQUENCE OF	SystemMicrocodeComponentEntry\n		MAX-ACCESS	not-accessible\n		STATUS	current\n		DESCRIPTION\n			\"the microcode Component table\"\n		::= {systemMicrocode 3}\n	systemMicrocodeComponentEntry	OBJECT-TYPE\n		SYNTAX	SystemMicrocodeComponentEntry\n		MAX-ACCESS	not-accessible\n		STATUS	current\n		DESCRIPTION\n			\"a row in the microcode Component table\"\n		INDEX {	systemMicrocodeIndex,\n				systemMicrocodePackageIndex,\n				systemMicrocodeComponentIndex}\n		::= {systemMicrocodeComponentTable 1}\n	SystemMicrocodeComponentEntry	::= SEQUENCE {\n			systemMicrocodeComponentIndex		Unsigned32,\n			systemMicrocodeComponentVersion		DisplayString,\n			systemMicrocodeComponentName		DisplayString,\n			systemMicrocodeComponentDescription	DisplayString,\n			systemMicrocodeComponentStatus		INTEGER,\n			systemMicrocodeComponentSize		Unsigned32\n		}\n	systemMicrocodeComponentIndex	OBJECT-TYPE\n		SYNTAX	Unsigned32\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"The index to the Component sub table in the microcode table\"\n		::= {systemMicrocodeComponentEntry 1}\n	systemMicrocodeComponentVersion OBJECT-TYPE\n		SYNTAX	DisplayString	(SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The version of the microcode Component\"\n		::=	{systemMicrocodeComponentEntry 2}\n	systemMicrocodeComponentName OBJECT-TYPE\n		SYNTAX	DisplayString	(SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The name of the microcode Component\"\n		DEFVAL	{ \"\" }\n		::=	{systemMicrocodeComponentEntry 3}\n	systemMicrocodeComponentDescription OBJECT-TYPE\n		SYNTAX	DisplayString	(SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The description of the microcode Component\"\n		DEFVAL	{ \"\" }\n		::=	{systemMicrocodeComponentEntry 4}\n	systemMicrocodeComponentStatus OBJECT-TYPE\n		SYNTAX	INTEGER {\n							undefined(1),\n							ok(2),\n							inuse(3)\n						}\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The status of the microcode Component\"\n		DEFVAL	{ undefined }\n		::=	{systemMicrocodeComponentEntry 5}\n	systemMicrocodeComponentSize OBJECT-TYPE\n		SYNTAX	Unsigned32\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The size of the microcode Component\"\n		DEFVAL	{ 0 }\n		::=	{systemMicrocodeComponentEntry 6}\n	systemMicrocodeDependencyTable	OBJECT-TYPE\n		SYNTAX	SEQUENCE OF	SystemMicrocodeDependencyEntry\n		MAX-ACCESS	not-accessible\n		STATUS	current\n		DESCRIPTION\n			\"the microcode Dependency table\"\n		::= {systemMicrocode 4}\n	systemMicrocodeDependencyEntry	OBJECT-TYPE\n		SYNTAX	SystemMicrocodeDependencyEntry\n		MAX-ACCESS	not-accessible\n		STATUS	current\n		DESCRIPTION\n			\"a row in the microcode Dependency table\"\n		INDEX {	systemMicrocodeIndex,\n				systemMicrocodePackageIndex,\n				systemMicrocodeComponentIndex,\n				systemMicrocodeDependencyIndex}\n		::= {systemMicrocodeDependencyTable 1}\n	SystemMicrocodeDependencyEntry	::= SEQUENCE {\n			systemMicrocodeDependencyIndex			Unsigned32,\n			systemMicrocodeDependencyPackageName	DisplayString,\n			systemMicrocodeDependencyVersion		DisplayString\n		}\n	systemMicrocodeDependencyIndex	OBJECT-TYPE\n		SYNTAX	Unsigned32\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"The index to the Dependency sub table in the microcode table\"\n		::= {systemMicrocodeDependencyEntry 1}\n	systemMicrocodeDependencyPackageName OBJECT-TYPE\n		SYNTAX	DisplayString	(SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The name of the microcode Package Dependency\"\n		DEFVAL	{ \"\" }\n		::=	{systemMicrocodeDependencyEntry 2}\n	systemMicrocodeDependencyVersion OBJECT-TYPE\n		SYNTAX	DisplayString	(SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"The version of the microcode Dependency\"\n		::=	{systemMicrocodeDependencyEntry 3}\n	-- systemBootParams group.  This group contains the CMM specific\n	-- boot parameter information.\n	systemBootNetwork	OBJECT-TYPE\n		SYNTAX		IpAddress\n	    MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"this object is the base IP address of the EMP for this CMM\"\n		::= { systemBootParams 1 }\n	systemBootNetworkGateway	OBJECT-TYPE\n		SYNTAX		IpAddress\n	    MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"this object is the gateway of the EMP for this CMM\"\n		::= { systemBootParams 2 }\n    systemBootNetworkNetmask	OBJECT-TYPE\n        SYNTAX		IpAddress\n        MAX-ACCESS	read-only\n        STATUS		current\n        DESCRIPTION\n            \"This is the Netmask of the EMP that is used when this\n			CMM boots.\"\n        ::={ systemBootParams 3 }\n	-- systemHardware group.  This group contains hardware information\n	-- regarding this CMM.\n    systemHardwareFlashMfg	OBJECT-TYPE\n		SYNTAX		INTEGER {other(1), amd(2), intel(3), atmel(4), toshiba(7), sandisk(8), sst(9)}\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"This object identifies the manufacturer of the Flash memory\n			used on this CMM.  toshiba(7) is for hawk only. The reason 7 is used\n			is because 5 is already used for micron and 6 is for kingston.\n			toshiba, sandisk, and sst are compact flashes for the hawk only.\"\n		::= { systemHardware 1}\n	systemHardwareFlashSize	OBJECT-TYPE\n		SYNTAX		Unsigned32\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"This object identifies the size of the flash memory available\n			on this CMM.  It is the total flash hardware memory and does\n			not indicate how much of the memory is free, used, etc.\"\n		::= { systemHardware 2}\n   systemHardwareMemoryMfg	OBJECT-TYPE\n		SYNTAX		INTEGER {other(1), amd(2), intel(3), atmel(4), micron(5), kingston(6), dataram(10), interward(11)}\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"This object identifies the manufacturer of the RAM memory\n			used on this CMM.\"\n		::= { systemHardware 3}\n	systemHardwareMemorySize	OBJECT-TYPE\n		SYNTAX		Unsigned32\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"This object identifies the size of the RAM memory available on\n			this CMM.  It is the total RAM hardware memory and does not\n			indicate how much of the memory is free, used, etc.\"\n		::= { systemHardware 4}\n	systemHardwareNVRAMBatteryLow	OBJECT-TYPE\n		SYNTAX		TruthValue\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"This object identifies the whether the NVRAM battery is low.\n			 true(1), false(2)\"\n		::= { systemHardware 5}\n	systemHardwareBootCpuType	OBJECT-TYPE\n		SYNTAX		INTEGER	{other(1), sparc380(2), sparcV9(3), ppc(4)}\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n		\"Indicates the manufacturer and model number of the CPU.  Currently,\n		only two types of processors are enumerated.\"\n		::={ systemHardware 6 }\n	systemHardwareJumperInterruptBoot	OBJECT-TYPE\n		SYNTAX	TruthValue\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"This object identifies whether the Interrupt Boot Jumper on this\n			CMM is set: True(1), False(2)\"\n		DEFVAL {false}\n		::= {systemHardware 7}\n	systemHardwareJumperForceUartDefaults	OBJECT-TYPE\n		SYNTAX	TruthValue\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"This object identifies whether the Force Uart Defaults Jumper on this\n			CMM is set: True(1), False(2)\"\n		DEFVAL {false}\n		::= {systemHardware 8}\n	systemHardwareJumperRunExtendedMemoryDiagnostics	OBJECT-TYPE\n		SYNTAX	TruthValue\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"This object identifies whether the Run Extended Memory\n			Diagnostics Jumper on this CMM is set: True(1), False(2)\"\n		DEFVAL {false}\n		::= {systemHardware 9}\n	systemHardwareJumperSpare	OBJECT-TYPE\n		SYNTAX	TruthValue\n		MAX-ACCESS	read-only\n		STATUS	current\n		DESCRIPTION\n			\"This object identifies whether the Spare Jumper on this\n			CMM is set: True(1), False(2)\"\n		DEFVAL {false}\n		::= {systemHardware 10}\n	systemHardwareFpgaVersionTable	OBJECT-TYPE\n		SYNTAX	SEQUENCE OF	SystemHardwareFpgaVersionEntry\n		MAX-ACCESS	not-accessible\n		STATUS	current\n		DESCRIPTION\n			\"This table contains the FPGA version for each FPGA on this CMM\"\n		::= {systemHardware 11}\n	systemHardwareFpgaVersionEntry	OBJECT-TYPE\n		SYNTAX	SystemHardwareFpgaVersionEntry\n		MAX-ACCESS	not-accessible\n		STATUS	current\n		DESCRIPTION\n			\"a row in the systemHardwareFpgaVersionTable\"\n		INDEX	{systemHardwareFpgaVersionIndex}\n		::= {systemHardwareFpgaVersionTable 1}\n	SystemHardwareFpgaVersionEntry ::= SEQUENCE	{\n			systemHardwareFpgaVersionIndex	NumFpgaOnBoard,\n			systemHardwareFpgaVersion		Unsigned32\n		}\n	systemHardwareFpgaVersionIndex	OBJECT-TYPE\n		SYNTAX	NumFpgaOnBoard\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"This is the index to one of the FPGA versions on this CMM\"\n		::={systemHardwareFpgaVersionEntry 1}\n	systemHardwareFpgaVersion		OBJECT-TYPE\n		SYNTAX	Unsigned32\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"This is the version of one of the FPGA devices on this CMM\"\n		::={systemHardwareFpgaVersionEntry 2}\n	systemHardwareBootRomVersion	OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n		\"A string that identifies the boot rom version\"\n		DEFVAL		{ \"\" }\n		::={ systemHardware 12 }\n	systemHardwareBackupMiniBootVersion	OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n		\"A string that identifies the backup miniboot version.\"\n		DEFVAL		{ \"\" }\n		::={ systemHardware 13 }\n	systemHardwareDefaultMiniBootVersion	OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n		\"A string that identifies the default miniboot version.\"\n		DEFVAL		{ \"\" }\n		::={ systemHardware 14 }\n	-- systemServices group.  This group contains the objects used by the\n	-- System Services applications.\n	systemServicesDate OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"This object contains the current System Date in the\n			following format: MM/DD/YYYY\"\n		::= { systemServices 1 }\n	systemServicesTime OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"This object contains the current System Time in the\n			following format: HH:MM:SS\"\n		::= { systemServices 2 }\n	systemServicesTimezone OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"This object contains the current Hour Offset from UTC\n			in the following format:  -13:00 to +12:00\n				OR\n			a well known timezone (PST,CST,etc.)\"\n		::= { systemServices 3 }\n	systemServicesTimezoneStartWeek OBJECT-TYPE\n		SYNTAX		Unsigned32\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"first, second, third, fourth, fifth, last = 1,2,3,4,5,6\"\n		DEFVAL		{ 0 }\n		::= { systemServices 4 }\n	systemServicesTimezoneStartDay OBJECT-TYPE\n		SYNTAX		Unsigned32\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"Sunday, Monday, Tues... = 1,2,3,4,5,6,7\"\n		DEFVAL		{ 0 }\n		::= { systemServices 5 }\n	systemServicesTimezoneStartMonth OBJECT-TYPE\n		SYNTAX		Unsigned32\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"January, February, march... = 1,2,3,4,5,67,8,9,10,11,12\"\n		DEFVAL		{ 0 }\n		::= { systemServices 6 }\n	systemServicesTimezoneStartTime OBJECT-TYPE\n		SYNTAX		Unsigned32\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"2:00, 3:00, 4:00... = 200, 300, 400, etc.\"\n		DEFVAL		{ 0 }\n		::= { systemServices 7 }\n	systemServicesTimezoneOffset OBJECT-TYPE\n		SYNTAX		Unsigned32\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"60 minutes = 60\"\n		DEFVAL		{ 0 }\n		::= { systemServices 8 }\n	systemServicesTimezoneEndWeek OBJECT-TYPE\n		SYNTAX		Unsigned32\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"first, second, third, fourth, fifth, last = 1,2,3,4,5,6\"\n		DEFVAL		{ 0 }\n		::= { systemServices 9 }\n	systemServicesTimezoneEndDay OBJECT-TYPE\n		SYNTAX		Unsigned32\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"Sunday, Monday, Tues... = 1,2,3,4,5,6,7\"\n		DEFVAL		{ 0 }\n		::= { systemServices 10 }\n	systemServicesTimezoneEndMonth OBJECT-TYPE\n		SYNTAX		Unsigned32\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"January, February, march... = 1,2,3,4,5,6,7,8,9,10,11,12\"\n		DEFVAL		{ 0 }\n		::= { systemServices 11 }\n	systemServicesTimezoneEndTime OBJECT-TYPE\n		SYNTAX		Unsigned32\n	    	MAX-ACCESS		read-write\n		STATUS		current\n		DESCRIPTION\n			\"2:00, 3:00, 4:00... = 200, 300, 400, etc.\"\n		DEFVAL		{ 0 }\n		::= { systemServices 12 }\n	systemServicesEnableDST OBJECT-TYPE\n		SYNTAX		Enable\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"This object enables and disables the DST.\"\n		DEFVAL		{ disabled }\n		::= { systemServices 13 }\n	systemServicesWorkingDirectory OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"This object contains the current file system working directory\n			for this CMM.  For example, /flash/certified\"\n		DEFVAL	{\"/flash\"}\n		::= { systemServices 14 }\n	systemServicesArg1 OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"the 1st argument for system services action routines\"\n		DEFVAL	{\"\"}\n		::= { systemServices 15 }\n	systemServicesArg2 OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"the 2nd argument for system services action routines\"\n		DEFVAL	{\"\"}\n		::= { systemServices 16 }\n	systemServicesArg3 OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"the 3rd argument for system services action routines\"\n		DEFVAL	{\"\"}\n		::= { systemServices 17 }\n	systemServicesArg4 OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"the 4th argument for system services action routines\"\n		DEFVAL	{\"\"}\n		::= { systemServices 18 }\n	systemServicesArg5 OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"the 5th argument for system services action routines\"\n		DEFVAL	{\"\"}\n		::= { systemServices 19 }\n	systemServicesArg6 OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"the 6th argument for system services action routines\"\n		DEFVAL	{\"\"}\n		::= { systemServices 20 }\n	systemServicesArg7 OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"the 7th argument for system services action routines\"\n		DEFVAL	{\"\"}\n		::= { systemServices 21 }\n	systemServicesArg8 OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"the 8th argument for system services action routines\"\n		DEFVAL	{\"\"}\n		::= { systemServices 22 }\n	systemServicesArg9 OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"the 9th argument for system services action routines\"\n		DEFVAL	{\"\"}\n		::= { systemServices 23 }\n	systemServicesAction OBJECT-TYPE\n		SYNTAX	INTEGER{\n					mkdir(1),\n					rmdir(2),\n					mv(3),\n					rm(4),\n					rmr(5),\n					cp(6),\n					cpr(7),\n					chmodpw(8),\n					chmodmw(9),\n					fsck(10),\n					ftp(11),\n					rz(12),\n					vi(13),\n					telnet(14),\n					install(15),\n					ed(16),\n					more(17),\n					newfs(18),\n					dshell(19),\n					view(20),\n					modbootparams(21),\n					filedir(22),\n					ssh(23),\n					sftp(24),\n					debugPmdNi(25),\n					bootrom(26),\n					defaultminiboot(27),\n					backupminiboot(28),\n					fpgacmm(29)\n				}\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"This object identifies which of the above Actions is to be\n			performed by the System Services Application.  Most Actions\n			require one or more parameters be set before the Action is\n			executed.  Please refer to the Alcatel BOP Proprietary\n			System MIB SFS for details regarding the use of Actions.\n			systemServicesAction - 26 for bootrom, 27 for default miniboot,\n			and 28 for backup miniboot use systemServicesArg1 for name of the file\"\n		::= { systemServices 24 }\n	systemServicesResultCode OBJECT-TYPE\n		SYNTAX		Unsigned32\n	    MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"the result of a system services application\"\n		::= { systemServices 25 }\n	systemServicesResultString OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n	    MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"the string result of a system services application\"\n		::= { systemServices 26 }\n	systemServicesKtraceEnable OBJECT-TYPE\n		SYNTAX		Enable\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"enables/disables the Ktrace facility\"\n		DEFVAL { enabled }\n		::= { systemServices 27 }\n	systemServicesSystraceEnable OBJECT-TYPE\n		SYNTAX		Enable\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"enables/disables the Systrace facility\"\n		DEFVAL { enabled }\n		::= { systemServices 28 }\n 	systemServicesTtyLines OBJECT-TYPE\n		SYNTAX		Unsigned32 (0..255)\n	    MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"the number of tty lines for a console screen\"\n		DEFVAL { 24 }\n		::= { systemServices 29 }\n	systemServicesTtyColumns OBJECT-TYPE\n		SYNTAX		Unsigned32 (0..255)\n	    MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"the number of tty columns for a console screen\"\n		DEFVAL { 80 }\n		::= { systemServices 30 }\n	systemServicesMemMonitorEnable OBJECT-TYPE\n		SYNTAX		Enable\n	    MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"disables/enables the kernel Memory Monitor feature\"\n		DEFVAL { enabled }\n		::= { systemServices 31 }\n	systemServicesKtraceLevelTable OBJECT-TYPE\n		SYNTAX		SEQUENCE OF SystemServicesKtraceLevelEntry\n		MAX-ACCESS	not-accessible\n		STATUS		current\n		DESCRIPTION\n			\"the table of Ktrace severity level settings\"\n		::= { systemServices 32}\n    systemServicesKtraceLevelEntry	OBJECT-TYPE\n        SYNTAX		SystemServicesKtraceLevelEntry\n        MAX-ACCESS	not-accessible\n        STATUS	    current\n        DESCRIPTION\n        	\"A row in the system services ktrace level table.  There\n			is one entry for each possible Application ID\"\n        INDEX	{systemServicesKtraceLevelAppId}\n        ::= {systemServicesKtraceLevelTable 1}\n    SystemServicesKtraceLevelEntry ::= SEQUENCE	{\n        	systemServicesKtraceLevelAppId	AppIdIndex,\n        	systemServicesKtraceLevel		SeverityLevel\n        }\n    systemServicesKtraceLevelAppId OBJECT-TYPE\n        SYNTAX		AppIdIndex\n        MAX-ACCESS	read-only\n        STATUS		current\n        DESCRIPTION\n            \"the index into the ktrace level table\"\n        ::= {systemServicesKtraceLevelEntry  1 }\n    systemServicesKtraceLevel OBJECT-TYPE\n        SYNTAX		SeverityLevel\n        MAX-ACCESS	read-write\n        STATUS		current\n        DESCRIPTION\n            \"the ktrace level for a specific Application ID\"\n		DEFVAL { severityLevelDbg3 }\n        ::= {systemServicesKtraceLevelEntry  2 }\n	systemServicesSystraceLevelTable OBJECT-TYPE\n		SYNTAX		SEQUENCE OF SystemServicesSystraceLevelEntry\n		MAX-ACCESS	not-accessible\n		STATUS		current\n		DESCRIPTION\n			\"the table of Systrace severity level settings\"\n		::= { systemServices 33}\n    systemServicesSystraceLevelEntry	OBJECT-TYPE\n        SYNTAX		SystemServicesSystraceLevelEntry\n        MAX-ACCESS	not-accessible\n        STATUS		current\n        DESCRIPTION\n        	\"A row in the system services systrace level table.  There\n			is one entry for each possible Application ID\"\n        INDEX	{systemServicesSystraceLevelAppId}\n       ::= {systemServicesSystraceLevelTable 1}\n    SystemServicesSystraceLevelEntry ::= SEQUENCE 	{\n        	systemServicesSystraceLevelAppId	AppIdIndex,\n        	systemServicesSystraceLevel	   		SeverityLevel\n        }\n    systemServicesSystraceLevelAppId OBJECT-TYPE\n        SYNTAX		AppIdIndex\n        MAX-ACCESS	read-only\n        STATUS		current\n        DESCRIPTION\n        \"the Systrace level for a specific Application ID.\"\n        ::= {systemServicesSystraceLevelEntry  1 }\n    systemServicesSystraceLevel OBJECT-TYPE\n        SYNTAX		SeverityLevel\n        MAX-ACCESS	read-write\n        STATUS		current\n        DESCRIPTION\n        \"the Systrace level for a specific Application ID.\"\n		DEFVAL { severityLevelDbg3 }\n        ::= {systemServicesSystraceLevelEntry  2 }\n	systemUpdateStatusTable OBJECT-TYPE \n                SYNTAX  SEQUENCE OF     SystemUpdateStatusEntry\n                MAX-ACCESS      not-accessible\n                STATUS  current\n                DESCRIPTION\n                        \"Provides update status for firmware updates\"\n                ::= {systemServices 34}\n        systemUpdateStatusEntry OBJECT-TYPE\n                SYNTAX  SystemUpdateStatusEntry\n                MAX-ACCESS      not-accessible\n                STATUS  current\n                DESCRIPTION\n                        \"A row in the update status table.\"\n                INDEX { systemUpdateIndex}\n                ::= {systemUpdateStatusTable 1}\n        SystemUpdateStatusEntry ::= SEQUENCE {\n                        systemUpdateIndex               INTEGER,\n                        systemUpdateStatus              INTEGER,\n                        systemUpdateErrorCode           INTEGER\n                }\n        systemUpdateIndex       OBJECT-TYPE\n                SYNTAX  INTEGER(65..72)\n                MAX-ACCESS      read-only\n                STATUS          current\n                DESCRIPTION\n                        \"The index to the CMM for which status is required.\"\n                ::= {systemUpdateStatusEntry 1}\n        systemUpdateStatus OBJECT-TYPE\n                SYNTAX  INTEGER {\n                        inProgress(1),\n                        doneOk(2),\n                        doneNok(3),\n                        noOp(4)\n                }\n                MAX-ACCESS      read-only\n                STATUS  current\n                DESCRIPTION\n                        \"Status of a firmware update.  In the case of doneNok,\n                        further information can be obtained from    systemUpdateErrorCode.\"\n                ::=     {systemUpdateStatusEntry 2}\n        systemUpdateErrorCode OBJECT-TYPE  \n                SYNTAX  INTEGER {         \n                        msgSendIpcErr(1),\n                        fXferOPenErr(2),\n                        fXferFtpErr(3),\n                        fXferReadErr(4),\n                        fXferWriteErr(5),\n                        fXferReplyErr(6),\n                        fXferQuitErr(7),\n                        fXferFcloseErr(8),\n			fileNameErr(9),\n			rmFileErr(10),\n                        noInstallComp(11),\n                        notSysResource(12),\n                        notSupported(13),\n                        invalidValue(14),\n			waitMsgMaxTry(15),\n			installDrvErr(16),\n			fileNotFound(17),\n			notPrimary(18),\n			commandBlocked(19)\n                }\n                MAX-ACCESS      read-only\n                STATUS  current\n                DESCRIPTION\n                        \"Error codes for done_nok.\"\n                ::=     {systemUpdateStatusEntry 3}\n--systemFileSystem group.  This group contains the parameters for\n--the multiple File Systems on the CMM.  At this time, there is only\n--one file system available, however more can be added when they are\n--needed in the future.\n    systemFileSystemTable	OBJECT-TYPE\n		SYNTAX	SEQUENCE OF SystemFileSystemEntry\n		MAX-ACCESS	not-accessible\n		STATUS	current\n		DESCRIPTION\n			\"system file system table for this CMM.\"\n		::= { systemFileSystem 1}\n	systemFileSystemEntry	OBJECT-TYPE\n		SYNTAX	SystemFileSystemEntry\n		MAX-ACCESS	not-accessible\n		STATUS		current\n		DESCRIPTION\n			\"A row in the system file system table\"\n		INDEX	{systemFileSystemIndex}\n		::= {systemFileSystemTable 1}\n	SystemFileSystemEntry ::= SEQUENCE 	{\n			systemFileSystemIndex		FileSystemIndex,\n			systemFileSystemName		DisplayString (SIZE (0..255)),\n			systemFileSystemFreeSpace	Unsigned32\n		}\n	systemFileSystemIndex OBJECT-TYPE\n		SYNTAX	FileSystemIndex\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"Index to a specific file system.  Currently, there is\n			only one filesystem /flash.  Note that an index cannot have\n			a default value according to the snmp compiler\"\n		::= {systemFileSystemEntry 1}\n	systemFileSystemName OBJECT-TYPE\n		SYNTAX	DisplayString (SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"The name of the file system.  At this time,\n			there is only one type of file system, flash\"\n		DEFVAL { \"\" }\n		::= { systemFileSystemEntry 2 }\n	systemFileSystemFreeSpace	OBJECT-TYPE\n		SYNTAX			Unsigned32\n		MAX-ACCESS		read-only\n		STATUS			current\n		DESCRIPTION\n			\"the free space in octets of this file system\"\n		DEFVAL { 0 }\n		::= { systemFileSystemEntry 3 }\n	systemFileSystemDirectoryName OBJECT-TYPE\n		SYNTAX	DisplayString (SIZE (0..255))\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"The name of a file system directory.  This object is used in conjunction\n			with an Action command.  The Action command will set this directory\n			name to the name of a specific directory.  Information for all of the\n			files in that directory will then be read from the file system and\n			the appropriate values written in the entries in the systemFileSystemFile\n			table.  All this is being done to give snmp access to the file system\n			files.\"\n		DEFVAL { \"\" }\n		::= { systemFileSystem 2 }\n	systemFileSystemDirectoryDateTime OBJECT-TYPE\n		SYNTAX			DisplayString (SIZE (0..255))\n		MAX-ACCESS		read-only\n		STATUS			current\n		DESCRIPTION\n			\"the date and time (in system format) of the last access to this directory\"\n		DEFVAL { \"\" }\n		::= { systemFileSystem 3 }\n    systemFileSystemFileTable	OBJECT-TYPE\n		SYNTAX	SEQUENCE OF SystemFileSystemFileEntry\n		MAX-ACCESS	not-accessible\n		STATUS	current\n		DESCRIPTION\n			\"system file system File table for this CMM.  This table is used by\n			an Action command which will populate it with file information read\n			from the files in the specified directory.\"\n		::= { systemFileSystem 4}\n	systemFileSystemFileEntry	OBJECT-TYPE\n		SYNTAX	SystemFileSystemFileEntry\n		MAX-ACCESS	not-accessible\n		STATUS		current\n		DESCRIPTION\n			\"A row in the system file system File table\"\n		INDEX {	systemFileSystemFileIndex}		-- base table index\n		::= {systemFileSystemFileTable 1}\n	SystemFileSystemFileEntry ::= SEQUENCE 	{\n			systemFileSystemFileIndex		Unsigned32,\n			systemFileSystemFileName		DisplayString (SIZE (0..255)),\n			systemFileSystemFileType		SystemFileType,\n			systemFileSystemFileSize		Unsigned32,\n			systemFileSystemFileAttr		INTEGER,\n			systemFileSystemFileDateTime	DisplayString (SIZE (0..255))\n		}\n	systemFileSystemFileIndex OBJECT-TYPE\n		SYNTAX	Unsigned32\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"Index to a specific file system File.\"\n		::= {systemFileSystemFileEntry 1}\n	systemFileSystemFileName OBJECT-TYPE\n		SYNTAX	DisplayString (SIZE (0..255))\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"The name of a file system File\"\n		DEFVAL { \"\" }\n		::= { systemFileSystemFileEntry 2 }\n	systemFileSystemFileType OBJECT-TYPE\n		SYNTAX	SystemFileType\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"The Type of a file system File\"\n		DEFVAL { undefined }\n		::= { systemFileSystemFileEntry 3 }\n	systemFileSystemFileSize OBJECT-TYPE\n		SYNTAX			Unsigned32\n		MAX-ACCESS		read-only\n		STATUS			current\n		DESCRIPTION\n			\"size of this file\"\n		DEFVAL { 0 }\n		::= { systemFileSystemFileEntry 4 }\n	systemFileSystemFileAttr OBJECT-TYPE\n		SYNTAX			INTEGER {\n									undefined(1),\n									readOnly(2),\n									readWrite(3),\n									writeOnly(4)\n						}\n		MAX-ACCESS		read-only\n		STATUS			current\n		DESCRIPTION\n			\"attributes of this file\"\n		DEFVAL { undefined }\n		::= { systemFileSystemFileEntry 5 }\n	systemFileSystemFileDateTime OBJECT-TYPE\n		SYNTAX			DisplayString (SIZE (0..255))\n		MAX-ACCESS		read-only\n		STATUS			current\n		DESCRIPTION\n			\"the modification date and time of a file\"\n		DEFVAL { \"\" }\n		::= { systemFileSystemFileEntry 6 }\n	--systemSwitchLogging group.  This group contains the Switch Logging\n	--configuration data.\n	systemSwitchLoggingIndex	OBJECT-TYPE\n		SYNTAX		SwitchLoggingIndex\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n			\"A small positive integer used to identify a switch logging\n			output\"\n		DEFVAL { flash }\n		::={ systemSwitchLogging 1 }\n	systemSwitchLoggingEnable	OBJECT-TYPE\n		SYNTAX		Enable\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"Global switch logging enable/disable\"\n		DEFVAL { enabled }\n		::={ systemSwitchLogging 2 }\n	systemSwitchLoggingFlash	OBJECT-TYPE\n		SYNTAX		Enable\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"Enable/disable switch logging to flash\"\n		DEFVAL { enabled }\n		::={ systemSwitchLogging 3 }\n	systemSwitchLoggingSocket	OBJECT-TYPE\n		SYNTAX		Enable\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"Enable/disable switch logging to a socket\"\n		DEFVAL { disabled }\n		::={ systemSwitchLogging 4 }\n	systemSwitchLoggingSocketIpAddr	OBJECT-TYPE\n		SYNTAX		IpAddress\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"The IP Address of a remote host that can\n			be used to send switch logging records to as an option\"\n		::={ systemSwitchLogging 5 }\n	systemSwitchLoggingConsole	OBJECT-TYPE\n		SYNTAX		Enable\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"Enable/disable switch logging to the console\"\n		DEFVAL { disabled }\n		::={ systemSwitchLogging 6 }\n	systemSwitchLoggingLevelTable	OBJECT-TYPE\n		SYNTAX		SEQUENCE OF SystemSwitchLoggingLevelEntry\n		MAX-ACCESS	not-accessible\n		STATUS		current\n		DESCRIPTION\n		\"The table of switch logging level settings, one for each\n		Application ID\"\n		::={ systemSwitchLogging 7}\n	systemSwitchLoggingClear	OBJECT-TYPE\n		SYNTAX	Unsigned32\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"Enable clearing of switch logging entries\"\n		::={ systemSwitchLogging 8 }\n	systemSwitchLoggingFileSize	OBJECT-TYPE\n		SYNTAX		Unsigned32\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"Set size of swlog logging file\"\n		::={ systemSwitchLogging 9 }\n	systemSwitchLoggingLevelEntry	OBJECT-TYPE\n		SYNTAX		SystemSwitchLoggingLevelEntry\n		MAX-ACCESS	not-accessible\n		STATUS		current\n		DESCRIPTION\n		\"A row in the system switch logging level table\"\n		INDEX {systemSwitchLoggingLevelAppId}\n		::={ systemSwitchLoggingLevelTable 1 }\n	SystemSwitchLoggingLevelEntry  ::= SEQUENCE {\n			systemSwitchLoggingLevelAppId	AppIdIndex,\n			systemSwitchLoggingLevel		SeverityLevel\n		}\n	systemSwitchLoggingLevelAppId	OBJECT-TYPE\n		SYNTAX		AppIdIndex\n		MAX-ACCESS	read-only\n		STATUS		current\n		DESCRIPTION\n		\"A specific application ID which has a severity level associated\n		with it.  This application ID is used as an index into the level\n		table.\"\n		::={ systemSwitchLoggingLevelEntry 1 }\n	systemSwitchLoggingLevel	OBJECT-TYPE\n		SYNTAX		SeverityLevel\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n		\"The logging level for a specific application id.\"\n		::={ systemSwitchLoggingLevelEntry 2 }\n	--systemDNS group.  This group contains the Domain Name Service\n	--configuration information.\n	systemDNSEnableDnsResolver	OBJECT-TYPE\n		SYNTAX		Enable\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"Global Domain Name Service enable/disable\"\n		DEFVAL { disabled }\n		::={ systemDNS 1 }\n	systemDNSDomainName	OBJECT-TYPE\n		SYNTAX		DisplayString (SIZE (0..255))\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"current domain name used by the Domain Name Service\"\n		DEFVAL { \"\" }\n		::={ systemDNS 2 }\n	systemDNSNsAddr1	OBJECT-TYPE\n		SYNTAX		IpAddress\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"1st part of address used by the Domain Name Service\"\n		DEFVAL { 0 }\n		::={ systemDNS 3 }\n	systemDNSNsAddr2	OBJECT-TYPE\n		SYNTAX		IpAddress\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"2nd part of address used by the Domain Name Service\"\n		DEFVAL { 0 }\n		::={ systemDNS 4 }\n	systemDNSNsAddr3	OBJECT-TYPE\n		SYNTAX		IpAddress\n		MAX-ACCESS	read-write\n		STATUS		current\n		DESCRIPTION\n			\"3rd part of address used by the Domain Name Service\"\n		DEFVAL { 0 }\n		::={ systemDNS 5 }\n--\n-- Compliance Statements\n--\n    alcatelIND1SystemMIBCompliance MODULE-COMPLIANCE\n        STATUS  current\n        DESCRIPTION\n            \"Compliance statement for\n             Alcatel BOP Proprietary System Subsystem.\"\n        MODULE  -- this module\n            MANDATORY-GROUPS\n            {\n                systemMicrocodeGroup,\n				systemBootParamsGroup,\n				systemHardwareGroup,\n				systemServicesGroup,\n				systemFileSystemGroup,\n				systemSwitchLoggingGroup,\n				systemDNSGroup\n            }\n        ::= { alcatelIND1SystemMIBCompliances 1 }\n--\n-- Units Of Conformance\n--\n    systemMicrocodeGroup OBJECT-GROUP\n        OBJECTS     {\n				systemMicrocodeIndex,\n				systemMicrocodePackageIndex,\n				systemMicrocodePackageVersion,\n				systemMicrocodePackageName,\n				systemMicrocodePackageDescription,\n				systemMicrocodePackageStatus,\n				systemMicrocodePackageSize,\n				systemMicrocodeComponentIndex,\n				systemMicrocodeComponentVersion,\n				systemMicrocodeComponentName,\n				systemMicrocodeComponentDescription,\n				systemMicrocodeComponentStatus,\n				systemMicrocodeComponentSize,\n				systemMicrocodeDependencyIndex,\n				systemMicrocodeDependencyPackageName,\n				systemMicrocodeDependencyVersion\n			}\n        STATUS      current\n        DESCRIPTION\n            \"Group all the system microcode objects together\"\n        ::= { alcatelIND1SystemMIBGroups 1 }\n    systemBootParamsGroup OBJECT-GROUP\n        OBJECTS	{\n			systemBootNetwork,\n			systemBootNetworkGateway,\n			systemBootNetworkNetmask\n		}\n        STATUS      current\n        DESCRIPTION\n            \"Group all the system boot parameters together\"\n        ::= { alcatelIND1SystemMIBGroups 2 }\n    systemHardwareGroup OBJECT-GROUP\n        OBJECTS     {\n			systemHardwareFlashMfg,\n			systemHardwareFlashSize,\n			systemHardwareMemoryMfg,\n	      	systemHardwareMemorySize,\n			systemHardwareNVRAMBatteryLow,\n			systemHardwareBootCpuType,\n			systemHardwareJumperInterruptBoot,\n			systemHardwareJumperForceUartDefaults,\n			systemHardwareJumperRunExtendedMemoryDiagnostics,\n			systemHardwareJumperSpare,\n			systemHardwareFpgaVersionIndex,\n			systemHardwareFpgaVersion,\n			systemHardwareBootRomVersion,\n			systemHardwareDefaultMiniBootVersion,\n			systemHardwareBackupMiniBootVersion\n        }\n        STATUS      current\n        DESCRIPTION\n            \"Group all the system Hardware Data together\"\n        ::= { alcatelIND1SystemMIBGroups 3 }\n	systemServicesGroup OBJECT-GROUP\n        OBJECTS {\n				systemServicesDate,\n				systemServicesTime,\n				systemServicesTimezone,\n				systemServicesTimezoneStartWeek,\n				systemServicesTimezoneStartDay,\n				systemServicesTimezoneStartMonth,\n				systemServicesTimezoneStartTime,\n				systemServicesTimezoneOffset,\n				systemServicesTimezoneEndWeek,\n				systemServicesTimezoneEndDay,\n				systemServicesTimezoneEndMonth,\n				systemServicesTimezoneEndTime,\n				systemServicesEnableDST,\n				systemServicesWorkingDirectory,\n				systemServicesArg1,\n				systemServicesArg2,\n				systemServicesArg3,\n				systemServicesArg4,\n				systemServicesArg5,\n				systemServicesArg6,\n				systemServicesArg7,\n				systemServicesArg8,\n				systemServicesArg9,\n				systemServicesAction,\n				systemServicesResultCode,\n				systemServicesResultString,\n				systemServicesKtraceEnable,\n				systemServicesSystraceEnable,\n				systemServicesTtyLines,\n				systemServicesTtyColumns,\n				systemServicesMemMonitorEnable,\n				systemServicesKtraceLevelAppId,\n				systemServicesKtraceLevel,\n				systemServicesSystraceLevelAppId,\n                                systemServicesSystraceLevel,\n                                systemUpdateIndex,\n                                systemUpdateStatus,\n                                systemUpdateErrorCode\n			}\n        STATUS  current\n        DESCRIPTION\n            \"Group all the system services parameters together\"\n        ::= { alcatelIND1SystemMIBGroups 4 }\n	systemFileSystemGroup OBJECT-GROUP\n		OBJECTS	{\n			systemFileSystemIndex,\n			systemFileSystemFreeSpace,\n			systemFileSystemName,\n			systemFileSystemDirectoryName,\n			systemFileSystemDirectoryDateTime,\n			systemFileSystemFileIndex,\n			systemFileSystemFileName,\n			systemFileSystemFileType,\n			systemFileSystemFileSize,\n			systemFileSystemFileAttr,\n			systemFileSystemFileDateTime\n		}\n        STATUS      current\n        DESCRIPTION\n         \"Group all the system flash file parameters together\"\n        ::= { alcatelIND1SystemMIBGroups 5 }\n	systemSwitchLoggingGroup OBJECT-GROUP\n		OBJECTS{\n				systemSwitchLoggingIndex,\n				systemSwitchLoggingEnable,\n				systemSwitchLoggingFlash,\n				systemSwitchLoggingSocket,\n				systemSwitchLoggingSocketIpAddr,\n				systemSwitchLoggingConsole,\n				systemSwitchLoggingClear,\n				systemSwitchLoggingFileSize,\n				systemSwitchLoggingLevel,\n				systemSwitchLoggingLevelAppId\n			}\n        	STATUS      current\n        	DESCRIPTION\n         	\"Group all the switch logging parameters together\"\n        	::= { alcatelIND1SystemMIBGroups 6 }\n	systemDNSGroup OBJECT-GROUP\n		OBJECTS{\n				systemDNSEnableDnsResolver,\n				systemDNSDomainName,\n				systemDNSNsAddr1,\n				systemDNSNsAddr2,\n				systemDNSNsAddr3\n			}\n        	STATUS      current\n        	DESCRIPTION\n         	\"Group all the systemDNS parameters together\"\n        	::= { alcatelIND1SystemMIBGroups 7 }\nEND\n');
/*!40000 ALTER TABLE `snmp_mibs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snmpcandidates`
--

DROP TABLE IF EXISTS `snmpcandidates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `snmpcandidates` (
  `string` varchar(64) DEFAULT NULL COMMENT 'The community string to try.',
  `type` int(11) DEFAULT NULL COMMENT '1 for public; 2 for private.',
  `num` int(11) DEFAULT NULL COMMENT 'The order in which to try the string; lowest goes first.'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the SNMP community strings to try during Device Discovery.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snmpcandidates`
--
-- WHERE:  1 limit 10

LOCK TABLES `snmpcandidates` WRITE;
/*!40000 ALTER TABLE `snmpcandidates` DISABLE KEYS */;
INSERT INTO `snmpcandidates` VALUES ('public',1,1),('private',2,1);
/*!40000 ALTER TABLE `snmpcandidates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snmpversioncandidates`
--

DROP TABLE IF EXISTS `snmpversioncandidates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `snmpversioncandidates` (
  `version` int(11) DEFAULT NULL COMMENT '1 for SNMPv1; 2 for SNMPv2.',
  `num` int(11) DEFAULT NULL COMMENT 'The order in which to try the version; lowest goes first.'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the order in which SNMP versions are tried during Device Discovery.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snmpversioncandidates`
--
-- WHERE:  1 limit 10

LOCK TABLES `snmpversioncandidates` WRITE;
/*!40000 ALTER TABLE `snmpversioncandidates` DISABLE KEYS */;
INSERT INTO `snmpversioncandidates` VALUES (1,2),(2,1),(3,3);
/*!40000 ALTER TABLE `snmpversioncandidates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spk_data`
--

DROP TABLE IF EXISTS `spk_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `spk_data` (
  `vendor` varchar(50) NOT NULL COMMENT 'Vendor name',
  `spk_file_name` varchar(50) NOT NULL COMMENT 'SPK file name',
  `description` varchar(100) NOT NULL COMMENT 'Description of the SPK file',
  `location` varchar(150) NOT NULL COMMENT 'File location',
  `version` varchar(50) NOT NULL COMMENT 'Version of the SPK file',
  `order_number` int(11) NOT NULL COMMENT 'Order of SPK Import',
  `import_stage` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Indicates import stage (0 = Before Discovery, 1 = After Discovery)',
  `processed_status` bit(1) NOT NULL DEFAULT b'0' COMMENT 'SPK File Processing Status (0 = Not Processed, 1 = Processed)',
  `processed_at` datetime DEFAULT NULL COMMENT 'Timestamp when the SPK file was processed',
  `active` bit(1) DEFAULT NULL COMMENT 'SPK File status (0 = InActive, 1 = Active)',
  PRIMARY KEY (`vendor`,`spk_file_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains SPK file information and processing tracking';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spk_data`
--
-- WHERE:  1 limit 10

LOCK TABLES `spk_data` WRITE;
/*!40000 ALTER TABLE `spk_data` DISABLE KEYS */;
INSERT INTO `spk_data` VALUES ('Aruba','ArubaEdgeConnect_Certification_v1.0.0.spk','Defines SilverPeak as a device type with 58 object types.','/config/sdwan/Aruba/ArubaEdgeConnect_Certification_v1.0.0.spk','v1.0.0',1,'\0','\0',NULL,''),('Aruba','ArubaEdgeConnect_ObjectGroups_v1.0.0.spk','Defines 2 object group classes LAN and WAN','/config/sdwan/Aruba/ArubaEdgeConnect_ObjectGroups_v1.0.0.spk','v1.0.0',2,'\0','\0',NULL,''),('Aruba','ArubaEdgeConnect_TopNViews_v1.0.0.spk','Provides 5 TopN report views.','/config/sdwan/Aruba/ArubaEdgeConnect_TopNViews_v1.0.0.spk','v1.0.0',3,'','\0',NULL,''),('Cisco-SDWAN','CiscoSDWAN_Certification_v1.0.0.spk','Adds device certification for deviceType.','/config/sdwan/Cisco-SDWAN/CiscoSDWAN_Certification_v1.0.0.spk','v1.0.0',2,'\0','\0',NULL,''),('Cisco-SDWAN','CiscoSDWAN_MIBS_v1.0.0.spk','Includes Edge and Controller device MIBs.','/config/sdwan/Cisco-SDWAN/CiscoSDWAN_MIBS_v1.0.0.spk','v1.0.0',1,'\0','\0',NULL,''),('Cisco-SDWAN','CiscoSDWAN_TopN_v1.0.0.spk','Provides 27 TopN report views.','/config/sdwan/Cisco-SDWAN/CiscoSDWAN_TopN_v1.0.0.spk','v1.0.0',3,'','\0',NULL,''),('Fortinet','Fortigate_Alerts_v1-1_v1.0.0.spk','Includes 3 alert policies, imported as disabled.','/config/sdwan/Fortinet/Fortigate_Alerts_v1-1_v1.0.0.spk','v1.0.0',5,'\0','\0',NULL,''),('Fortinet','Fortigate_Certification_v1.0.0.spk','Defines Fortinet Fortigate as a device type and 58 object types.','/config/sdwan/Fortinet/Fortigate_Certification_v1.0.0.spk','v1.0.0',2,'\0','\0',NULL,''),('Fortinet','Fortigate_Interface_SubType_Rules_v1.0.0.spk','Adds interface subtype mapping rules.','/config/sdwan/Fortinet/Fortigate_Interface_SubType_Rules_v1.0.0.spk','v1.0.0',3,'\0','\0',NULL,''),('Fortinet','Fortigate_MIBs_v1.0.0.spk','Includes Fortigate MIB files (FORTINET-CORE-MIB.mib, FORTINET-FORTIGATE-MIB.mib).','/config/sdwan/Fortinet/Fortigate_MIBs_v1.0.0.spk','v1.0.0',1,'\0','\0',NULL,'');
/*!40000 ALTER TABLE `spk_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf`
--

DROP TABLE IF EXISTS `surf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `is_temporary` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag describing whether this report is a temporary report.  All reports begin as temporary reports until they are given a formal name.',
  `name` varchar(255) NOT NULL COMMENT 'Name of report',
  `description` varchar(255) NOT NULL COMMENT 'Human readable description of report',
  `message` text NOT NULL COMMENT 'Any relevant messages about items in report that may have been deleted by discovery.',
  `user_id` int(11) NOT NULL COMMENT 'Owner of report foreignKey: access_control.user.uid',
  `is_private` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Flag describing whether this table is only visible to the set of specified users/groups or whether anybody can view it.',
  `is_read_only` tinyint(4) DEFAULT 0 COMMENT 'Flag describing whether the users to whom a report is shared have save/delete permissions for that report.',
  `num_columns` int(11) NOT NULL DEFAULT 3 COMMENT 'Number of columns this report will be displayed as.  This is a field that currently only supports the value 3, it is a candidate for deletion.',
  `is_emailed` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Flag describing whether this email will be run and emailed at a particular interval.',
  `email_to` text DEFAULT NULL COMMENT 'Comma-separated list of email addresses for mailer to send report to.',
  `next_run` int(11) NOT NULL DEFAULT 0 COMMENT 'Unix-timestamp of when report is next scheduled to be run.',
  `run_value` int(11) NOT NULL DEFAULT 1 COMMENT 'Number that, when paired with run_unit, describes the interval at which this report is run.',
  `run_unit` varchar(32) NOT NULL DEFAULT 'days' COMMENT 'Unit of time describing the interval at which the report is run.',
  `timezone` varchar(255) NOT NULL DEFAULT 'UTC' COMMENT 'Timezone of this report, for purposes of running report for mailing.',
  `migrated` int(11) DEFAULT 0 COMMENT 'Field describing whether this report was generated by migration or by another means (SURF, detatching, API).  A non-zero value signifies the original pre-SURF report ID that this was generated from.  This is valuable information for finding whether report problems stem from bad migration code or bad frontend code.  It also gives us the IDs necessary to rebuild information that was lost in migration.',
  `is_ftped` tinyint(1) DEFAULT 0 COMMENT 'Whether this report is scheduled to be transfered to an FTP server after the scheduled run time.',
  `template_type` varchar(32) DEFAULT NULL COMMENT 'NULL if this table is non-template, otherwise it is ''device'' or ''object'' cooresponding to what type of template report this is.  This should be switched to an ENUM',
  `userrole_id` int(11) DEFAULT NULL COMMENT 'The user role id associated with this surf report',
  `folder_id` int(11) unsigned DEFAULT NULL COMMENT 'The folder id where this surf report resides',
  `last_modified` int(11) NOT NULL DEFAULT 0 COMMENT 'Unix-timestamp when report was lastly modified.',
  `last_accessed` int(11) NOT NULL DEFAULT 0 COMMENT 'Unix-timestamp when report was lastly accessed.',
  `run_time` int(11) NOT NULL DEFAULT 0 COMMENT 'Last run time in seconds.',
  `is_sftped` tinyint(4) DEFAULT 0 COMMENT 'Whether this report is scheduled to be transfered to an SFTP server after the scheduled run time.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the table that stores a list of saved reports.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf` WRITE;
/*!40000 ALTER TABLE `surf` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_allowed_roles`
--

DROP TABLE IF EXISTS `surf_allowed_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_allowed_roles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `surf_id` bigint(20) NOT NULL COMMENT 'Foreign Key to the surf table foreignKey: net.surf.id',
  `group_id` int(11) NOT NULL COMMENT 'The user role. foreignKey: access_control.userrole.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `surf_and_group` (`surf_id`,`group_id`),
  KEY `group_id` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Allowed Roles table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_allowed_roles`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_allowed_roles` WRITE;
/*!40000 ALTER TABLE `surf_allowed_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_allowed_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_allowed_users`
--

DROP TABLE IF EXISTS `surf_allowed_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_allowed_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `surf_id` bigint(20) unsigned NOT NULL COMMENT 'Foreign Key to the surf table foreignKey: net.surf.id',
  `user_id` int(10) unsigned NOT NULL COMMENT 'Foreign Key to the user table foreignKey: access_control.user.uid',
  PRIMARY KEY (`id`),
  UNIQUE KEY `surf_and_user` (`surf_id`,`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='SURF Report allowed Users table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_allowed_users`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_allowed_users` WRITE;
/*!40000 ALTER TABLE `surf_allowed_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_allowed_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_folders`
--

DROP TABLE IF EXISTS `surf_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_folders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(256) DEFAULT NULL COMMENT 'The name of the folder',
  `parent_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the parent folder. foreignKey: net.surf_folders.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_id` (`parent_id`,`name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the table that stores the report folders information.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_folders`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_folders` WRITE;
/*!40000 ALTER TABLE `surf_folders` DISABLE KEYS */;
INSERT INTO `surf_folders` VALUES (2,'Default',1),(1,'All Reports',0);
/*!40000 ALTER TABLE `surf_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_swell_filter_elements`
--

DROP TABLE IF EXISTS `surf_swell_filter_elements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_swell_filter_elements` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `surf_id` bigint(20) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.surf.id',
  `swell_id` bigint(20) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.surf_swells.id',
  `order_number` int(11) NOT NULL DEFAULT 0 COMMENT 'Zero-indexed order number of filters under the parent filter node.',
  `parent_id` bigint(20) NOT NULL DEFAULT -1 COMMENT 'Parent filter node ID, or -1 if this is a root node. foreignKey: net.surf_swell_filter_elements.id',
  `sub_filter` varchar(127) DEFAULT NULL COMMENT 'Short text describing what sub-category of filters this particular filter belongs under.',
  `type` enum('predicate','operator') DEFAULT NULL COMMENT 'ENUM which specifies what type of filter element node this is.  Predicates are leaf nodes, operators are usually non-leaf nodes.  This should be a candidate for being switched to NOT NULL',
  PRIMARY KEY (`id`),
  UNIQUE KEY `surf_and_swell_and_order` (`surf_id`,`swell_id`,`order_number`),
  KEY `swell_id` (`swell_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='The rows in this table represent a node in tree-structure of filters, describing how the data of a report ought to be filtered.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_swell_filter_elements`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_swell_filter_elements` WRITE;
/*!40000 ALTER TABLE `surf_swell_filter_elements` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_swell_filter_elements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_swell_filter_operators`
--

DROP TABLE IF EXISTS `surf_swell_filter_operators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_swell_filter_operators` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `element_id` bigint(20) NOT NULL COMMENT ' foreignKey: net.surf_swell_filter_elements.id',
  `surf_id` bigint(20) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.surf.id',
  `swell_id` bigint(20) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.surf_swells.id',
  `tag` varchar(255) DEFAULT NULL COMMENT 'TODO: Ask Burke, may be currently unused',
  `operation` varchar(127) DEFAULT NULL COMMENT 'Whether this is an ''and'' or ''or'' operation.  Candidate for ENUM',
  PRIMARY KEY (`id`),
  UNIQUE KEY `element_id` (`element_id`),
  KEY `surf_and_swell_id` (`surf_id`,`swell_id`),
  KEY `swell_id` (`swell_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='The rows in this table are a 1-to-1 mapping to rows in the table surf_swell_filter_elements with the type ''operator''.  They represent operator-groups in a tree structure of filter elements.  Predicates should be the leaf nodes under the operators.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_swell_filter_operators`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_swell_filter_operators` WRITE;
/*!40000 ALTER TABLE `surf_swell_filter_operators` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_swell_filter_operators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_swell_filter_predicate_data`
--

DROP TABLE IF EXISTS `surf_swell_filter_predicate_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_swell_filter_predicate_data` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `surf_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'The surf report id this predicate data is associated with foreignKey: net.surf.id',
  `swell_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'The swell id this predicate data is associated with foreignKey: net.surf_swells.id',
  `predicate_id` bigint(20) NOT NULL COMMENT 'The predicate this predicate data is associated with. foreignKey: net.surf_swell_filter_predicates.id',
  `data_key` varchar(255) DEFAULT NULL COMMENT 'The key, or type, of this data',
  `data_value` text DEFAULT NULL COMMENT 'The value of this data',
  PRIMARY KEY (`id`),
  UNIQUE KEY `surf_and_swell_and_predicate_and_key` (`surf_id`,`swell_id`,`predicate_id`,`data_key`),
  KEY `swell_id` (`swell_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains predicate data for those predicates that don''t have explicit fields in the surf_swell_filter_predicates table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_swell_filter_predicate_data`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_swell_filter_predicate_data` WRITE;
/*!40000 ALTER TABLE `surf_swell_filter_predicate_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_swell_filter_predicate_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_swell_filter_predicates`
--

DROP TABLE IF EXISTS `surf_swell_filter_predicates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_swell_filter_predicates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `element_id` bigint(20) NOT NULL COMMENT 'Foreign Key to the element table',
  `surf_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Foreign Key to the surf table foreignKey: net.surf.id',
  `swell_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Foreign Key to the swell table foreignKey: net.surf_swells.id',
  `predicate_type` varchar(255) NOT NULL COMMENT 'The predicate type',
  `action` varchar(127) DEFAULT NULL COMMENT 'Action',
  `has_extra_data` tinyint(1) DEFAULT 0 COMMENT 'If this has extra data',
  `device_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to net.deviceinfo foreignKey: net.deviceinfo.id',
  `plugin_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to net.plugins. foreignKey: net.plugins.id',
  `object_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to local.device_objects. foreignKey: local.device_object.id',
  `indicator_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to local.device_indicator. foreignKey: local.device_indicator.id',
  `object_type_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to net.plugin_object_type foreignKey: net.plugin_object_type.id',
  `indicator_type_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to net.plugin_indicator_type foreignKey: net.plugin_indicator_type.id',
  `device_class_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to Device Class table',
  `device_group_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to Device Group table foreignKey: net.devicetags.id',
  `object_group_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to Object Group foreignKey: net.objectgroupinfo.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `element_id` (`element_id`),
  KEY `device_object_id` (`device_id`,`object_id`),
  KEY `indicator_id` (`indicator_id`),
  KEY `object_group_id` (`object_group_id`),
  KEY `plugin_id` (`plugin_id`),
  KEY `surf_id` (`surf_id`),
  KEY `swell_id` (`swell_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Swell Filter Table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_swell_filter_predicates`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_swell_filter_predicates` WRITE;
/*!40000 ALTER TABLE `surf_swell_filter_predicates` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_swell_filter_predicates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_swell_filters`
--

DROP TABLE IF EXISTS `surf_swell_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_swell_filters` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `surf_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Foreign Key To The surf table foreignKey: net.surf.id',
  `swell_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Foreign Key to the swell table foreignKey: net.surf_swells.id',
  `type` varchar(255) NOT NULL COMMENT 'Type',
  `order_number` int(11) NOT NULL DEFAULT 0 COMMENT 'Order Number',
  `device_class_id` int(11) DEFAULT NULL COMMENT 'Device Class table',
  `device_group_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to the Device Group table foreignKey: net.devicetags.id',
  `object_group_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to the Object Group table foreignKey: net.objectgroupinfo.id',
  `device_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to the deviceinfo table foreignKey: net.deviceinfo.id',
  `plugin_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to the plugins table foreignKey: net.plugins.id',
  `object_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to local.device_object',
  `indicator_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to local.device_indicator foreignKey: local.device_indicator.id',
  `object_type_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to net.plugin_object_type foreignKey: net.plugin_object_type.id',
  `indicator_type_id` int(11) DEFAULT NULL COMMENT 'Foreign Key to net.plugin_indicator_type foreignKey: net.plugin_indicator_type.id',
  `is_enabled` tinyint(4) DEFAULT NULL COMMENT 'Is Enabled',
  `is_visible` tinyint(4) DEFAULT NULL COMMENT 'Is Visible',
  `name` varchar(255) DEFAULT NULL COMMENT 'Name',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description',
  PRIMARY KEY (`id`),
  UNIQUE KEY `surf_and_swell_and_type_and_order` (`surf_id`,`swell_id`,`type`,`order_number`),
  KEY `device_class_id` (`device_class_id`),
  KEY `device_group_id` (`device_group_id`),
  KEY `device_id` (`device_id`),
  KEY `object_group_id` (`object_group_id`),
  KEY `swell_id` (`swell_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Filters Table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_swell_filters`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_swell_filters` WRITE;
/*!40000 ALTER TABLE `surf_swell_filters` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_swell_filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_swell_ranges`
--

DROP TABLE IF EXISTS `surf_swell_ranges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_swell_ranges` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `surf_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'The surf report id that this range is associated with foreignKey: net.surf.id',
  `swell_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'The swell id that this range is associated with foreignKey: net.surf_swells.id',
  `order_number` int(11) NOT NULL DEFAULT 0 COMMENT 'The index of the range in the ranges array in the swell',
  `rangeType` varchar(255) DEFAULT NULL COMMENT 'The type of the time range',
  `timespan` varchar(255) DEFAULT NULL COMMENT 'The timespan string of the range',
  `startTime` bigint(20) DEFAULT NULL COMMENT 'The start time of the range',
  `endTime` bigint(20) DEFAULT NULL COMMENT 'The end time of the range',
  PRIMARY KEY (`id`),
  UNIQUE KEY `surf_and_swell_and_order` (`surf_id`,`swell_id`,`order_number`),
  KEY `swell_id` (`swell_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all the time ranges that this swell is to run on';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_swell_ranges`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_swell_ranges` WRITE;
/*!40000 ALTER TABLE `surf_swell_ranges` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_swell_ranges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_swell_settings`
--

DROP TABLE IF EXISTS `surf_swell_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_swell_settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `surf_id` bigint(20) NOT NULL COMMENT 'Foreign Key to surf table foreignKey: net.surf.id',
  `swell_id` bigint(20) NOT NULL COMMENT 'Foreign Key to swell table foreignKey: net.surf_swells.id',
  `setting` varchar(100) NOT NULL COMMENT 'Setting',
  `name` varchar(100) NOT NULL COMMENT 'Name',
  `value` text NOT NULL COMMENT 'Text',
  PRIMARY KEY (`id`),
  UNIQUE KEY `surf_and_swell_and_setting_and_name` (`surf_id`,`swell_id`,`setting`,`name`),
  KEY `swell_id` (`swell_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Swell Settings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_swell_settings`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_swell_settings` WRITE;
/*!40000 ALTER TABLE `surf_swell_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_swell_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_swell_visualization_settings`
--

DROP TABLE IF EXISTS `surf_swell_visualization_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_swell_visualization_settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `surf_id` bigint(20) NOT NULL COMMENT 'Foreign Key to the surf table foreignKey: net.surf.id',
  `swell_id` bigint(20) NOT NULL COMMENT 'Foreign Key to the swell table foreignKey: net.surf_swells.id',
  `visualization_id` bigint(20) NOT NULL COMMENT 'Foreign Key to the visulation table',
  `setting` varchar(100) NOT NULL COMMENT 'Setting',
  `name` varchar(100) NOT NULL COMMENT 'Name',
  `value` text NOT NULL COMMENT 'Value',
  PRIMARY KEY (`id`),
  UNIQUE KEY `surf_and_swell_and_visualization_and_setting_and_name` (`surf_id`,`swell_id`,`visualization_id`,`setting`,`name`),
  KEY `swell_id` (`swell_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='The Visualization Settings Table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_swell_visualization_settings`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_swell_visualization_settings` WRITE;
/*!40000 ALTER TABLE `surf_swell_visualization_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_swell_visualization_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_swell_visualizations`
--

DROP TABLE IF EXISTS `surf_swell_visualizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_swell_visualizations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `surf_id` bigint(20) NOT NULL COMMENT 'Foreign Key to Surf Table foreignKey: net.surf.id',
  `swell_id` bigint(20) NOT NULL COMMENT 'Foreign Key to the Swell Table foreignKey: net.surf_swells.id',
  `type` varchar(255) DEFAULT NULL COMMENT 'Type',
  `order_number` int(11) NOT NULL DEFAULT 0 COMMENT 'Order Number',
  PRIMARY KEY (`id`),
  UNIQUE KEY `surf_and_swell_and_order` (`surf_id`,`swell_id`,`order_number`),
  KEY `swell_id` (`swell_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Swell Visualizations Table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_swell_visualizations`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_swell_visualizations` WRITE;
/*!40000 ALTER TABLE `surf_swell_visualizations` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_swell_visualizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_swells`
--

DROP TABLE IF EXISTS `surf_swells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_swells` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `surf_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'The surf report id that this swell is associated with foreignKey: net.surf.id',
  `order_number` int(11) NOT NULL DEFAULT 0 COMMENT 'The structure order of this swell. This maintains the position of the swell in the tree structure so that the same tree is built coming out of the database after saving.',
  `parent_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'The parent swell id that this swell is under. foreignKey: net.surf_swells.id',
  `type` varchar(255) NOT NULL COMMENT 'The swell type as defined by SURF',
  `display_order` int(11) NOT NULL DEFAULT 0 COMMENT 'The render order of this swell in the report from top to bottom',
  `name` varchar(255) NOT NULL COMMENT 'The name of the swell',
  `col` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'The column in the report in which this swell should be rendered',
  `size` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'The size of the swell in columns',
  `height` int(11) NOT NULL DEFAULT 0 COMMENT 'The height of the swell ( I''m pretty sure this isn''t used )',
  `timezone` varchar(255) DEFAULT NULL COMMENT 'The timezone of the swell',
  `parent_limit` int(11) NOT NULL DEFAULT 0 COMMENT 'The parent limit of this swell ( how many things to propogate down )',
  `aggregation` varchar(255) DEFAULT NULL COMMENT 'The aggregation of this swell',
  `migrated` int(11) DEFAULT 0 COMMENT 'Whether or not this swell was created through migration',
  PRIMARY KEY (`id`),
  UNIQUE KEY `surf_and_order` (`surf_id`,`order_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains information about all the swells that are defined in SURFs in the product.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_swells`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_swells` WRITE;
/*!40000 ALTER TABLE `surf_swells` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_swells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surf_template_ids`
--

DROP TABLE IF EXISTS `surf_template_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `surf_template_ids` (
  `surf_id` bigint(20) DEFAULT NULL COMMENT 'The surf report id associated with this template report information foreignKey: net.surf.id',
  `id_type` varchar(32) DEFAULT NULL COMMENT 'The type of the template',
  `item_id` int(11) DEFAULT NULL COMMENT 'The id of the item that is being saved as the item for this template'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table stores some template specific information for surf reports including the type of template it is and the default item for that template';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surf_template_ids`
--
-- WHERE:  1 limit 10

LOCK TABLES `surf_template_ids` WRITE;
/*!40000 ALTER TABLE `surf_template_ids` DISABLE KEYS */;
/*!40000 ALTER TABLE `surf_template_ids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `syslog_destinations`
--

DROP TABLE IF EXISTS `syslog_destinations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `syslog_destinations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) NOT NULL COMMENT 'The name of the syslog destination.',
  `host` varchar(255) NOT NULL COMMENT 'This is the management IP address of the destination.',
  `protocol` enum('TCP','UDP','TLS') NOT NULL COMMENT 'The protocol types supported.',
  `port` smallint(5) unsigned NOT NULL COMMENT 'Destination port on which to communicate.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all global syslog destinations.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `syslog_destinations`
--
-- WHERE:  1 limit 10

LOCK TABLES `syslog_destinations` WRITE;
/*!40000 ALTER TABLE `syslog_destinations` DISABLE KEYS */;
/*!40000 ALTER TABLE `syslog_destinations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topology_object_type_relationships`
--

DROP TABLE IF EXISTS `topology_object_type_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `topology_object_type_relationships` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'This is the ID of the Object Types Topology relationships.',
  `local_object_type_id` int(11) NOT NULL COMMENT 'This is the ID of the first object type in the relationship. foreignKey: net.plugin_object_type.id',
  `remote_object_type_id` int(11) NOT NULL COMMENT 'This is the ID of the second Object Type in the relationship. foreignKey: net.plugin_object_type.id',
  `forward_relationship_type` int(11) NOT NULL COMMENT 'This is the ID of the Relationship Type that describes how the first object type relates to the second. foreignKey: net.topology_relationship_types.id',
  `reverse_relationship_type` int(11) NOT NULL COMMENT 'This is the ID of the Relationship Type that describes how the second object type relates to the first. foreignKey: net.topology_relationship_types.id',
  `forward_cardinality` enum('ONE','MANY') NOT NULL COMMENT 'The cardinality of the first to the second Object Type relationship.',
  `reverse_cardinality` enum('ONE','MANY') NOT NULL COMMENT 'The cardinality of the second to the first Object Type relationship.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_objecttype_relationship` (`local_object_type_id`,`forward_relationship_type`),
  KEY `fk_forward_relationship_type` (`forward_relationship_type`),
  KEY `fk_local_object_type` (`local_object_type_id`),
  KEY `fk_remote_object_type` (`remote_object_type_id`),
  KEY `fk_reverse_relationship_type` (`reverse_relationship_type`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines Object Type relationships for for intra- and inter-device connections.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_object_type_relationships`
--
-- WHERE:  1 limit 10

LOCK TABLES `topology_object_type_relationships` WRITE;
/*!40000 ALTER TABLE `topology_object_type_relationships` DISABLE KEYS */;
INSERT INTO `topology_object_type_relationships` VALUES (1,274,274,1,2,'MANY','MANY'),(2,274,274,3,4,'MANY','MANY'),(3,274,274,5,5,'ONE','ONE'),(4,274,274,6,6,'ONE','ONE'),(10,274,274,7,7,'ONE','MANY');
/*!40000 ALTER TABLE `topology_object_type_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topology_relationship_types`
--

DROP TABLE IF EXISTS `topology_relationship_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `topology_relationship_types` (
  `id` int(11) NOT NULL COMMENT 'This is the ID of the Topology Relationship Types.',
  `name` varchar(64) NOT NULL COMMENT 'This is the name of the Topology Source.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines Topology relationship types.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_relationship_types`
--
-- WHERE:  1 limit 10

LOCK TABLES `topology_relationship_types` WRITE;
/*!40000 ALTER TABLE `topology_relationship_types` DISABLE KEYS */;
INSERT INTO `topology_relationship_types` VALUES (1,'COMPOSED_OF'),(2,'MEMBER_OF'),(3,'UNDERLYING'),(4,'LAYERED_OVER'),(5,'PEER'),(6,'CONNECTED_VIA'),(7,'PEER_MANY');
/*!40000 ALTER TABLE `topology_relationship_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topology_sources`
--

DROP TABLE IF EXISTS `topology_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `topology_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'This is the ID of the Topology Source.',
  `object_string` varchar(64) NOT NULL COMMENT 'This is system-used string to identify the Topology Source.',
  `name` varchar(64) NOT NULL COMMENT 'This is the name of the Topology Source.',
  `topology_layer_type` enum('Physical','Logical','Session') DEFAULT NULL COMMENT 'This is the type of topology layer the source addresses: Layer 2 or Layer 3.',
  `priority` int(11) NOT NULL DEFAULT 0 COMMENT 'Priority of Topology sources in discovery.',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Whether the source is enabled for the purpose of discovery.',
  `config_visible` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Whether the source is visible to the user.',
  `report_visible` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Whether the source is visible in the reporting interface.',
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Whether the source is user created or created by default in the NMS',
  PRIMARY KEY (`id`),
  UNIQUE KEY `object_string` (`object_string`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines Topology sources.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_sources`
--
-- WHERE:  1 limit 10

LOCK TABLES `topology_sources` WRITE;
/*!40000 ALTER TABLE `topology_sources` DISABLE KEYS */;
INSERT INTO `topology_sources` VALUES (1,'ARPCache','ARP Cache','Logical',0,1,1,1,0),(2,'LLDP','LLDP','Logical',0,1,1,1,0),(3,'OSPF','OSPF','Logical',0,1,1,1,0),(4,'BGP','BGP','Session',0,1,1,1,0),(5,'CDP','CDP','Logical',0,1,1,1,0),(6,'MPLSLDP','MPLS LDP','Logical',0,1,1,1,0),(7,'IntraDevice','Intra Device','Logical',0,1,1,1,0),(8,'STP','STP','Physical',0,1,1,1,0),(9,'STP_TRUNK','STP Trunk','Physical',0,1,1,1,0),(11,'UserDefined','User Defined','Logical',0,1,0,1,0);
/*!40000 ALTER TABLE `topology_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trap_event_key`
--

DROP TABLE IF EXISTS `trap_event_key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `trap_event_key` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `trap_event_id` int(11) NOT NULL COMMENT ' foreignKey: net.trapevents.id',
  `oid` varchar(255) DEFAULT NULL COMMENT 'This is the OID of the trap',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_tuple` (`trap_event_id`,`oid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the trap event table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trap_event_key`
--
-- WHERE:  1 limit 10

LOCK TABLES `trap_event_key` WRITE;
/*!40000 ALTER TABLE `trap_event_key` DISABLE KEYS */;
/*!40000 ALTER TABLE `trap_event_key` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trap_v3users`
--

DROP TABLE IF EXISTS `trap_v3users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `trap_v3users` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT 'The v3 username.',
  `authprotocol` enum('MD5','NONE','SHA') NOT NULL DEFAULT 'NONE' COMMENT 'The v3 authorization protocol.',
  `authkey` varchar(256) NOT NULL DEFAULT '' COMMENT 'The v3 authorization key.',
  `privprotocol` enum('AES128','AES192','AES256','NONE') NOT NULL DEFAULT 'NONE' COMMENT 'The v3 privacy protocol.',
  `privkey` varchar(512) NOT NULL DEFAULT '' COMMENT 'The v3 privacy key.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Trap v3 Users';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trap_v3users`
--
-- WHERE:  1 limit 10

LOCK TABLES `trap_v3users` WRITE;
/*!40000 ALTER TABLE `trap_v3users` DISABLE KEYS */;
/*!40000 ALTER TABLE `trap_v3users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trap_webhooks`
--

DROP TABLE IF EXISTS `trap_webhooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `trap_webhooks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `trap_event_id` int(11) NOT NULL COMMENT ' foreignKey: net.trapevents.id',
  `type` enum('TRIGGER','CLEAR') NOT NULL DEFAULT 'TRIGGER' COMMENT 'Type of a webhook TRIGGER/CLEAR',
  `override_single_webhook_per_alert` tinyint(4) DEFAULT NULL COMMENT 'OverrideSingleWebhookPerAlert',
  `start_time` datetime DEFAULT NULL COMMENT 'StartTime',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`trap_event_id`,`type`),
  KEY `trap_event_id` (`trap_event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the basic information about trap webhooks.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trap_webhooks`
--
-- WHERE:  1 limit 10

LOCK TABLES `trap_webhooks` WRITE;
/*!40000 ALTER TABLE `trap_webhooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `trap_webhooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trapdestination`
--

DROP TABLE IF EXISTS `trapdestination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `trapdestination` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(64) DEFAULT NULL COMMENT 'For user-created ones, the name specified.  For auto-discovered ones, a unique string based on some of the fields below.',
  `ip_address` varbinary(40) DEFAULT NULL COMMENT 'The IPv4 address of the trap receiver.',
  `port` int(10) DEFAULT 0 COMMENT 'The UDP port to which to send the traps.',
  `ro_community` varchar(64) DEFAULT NULL COMMENT 'The SNMP community string to send when sending traps.',
  `snmp_version` smallint(6) DEFAULT 1 COMMENT 'The SNMP version to send; this may be 1, 2 or 3.',
  `user` varchar(64) NOT NULL DEFAULT '' COMMENT 'The SNMPv3 security name.',
  `engine_id` varchar(64) NOT NULL DEFAULT '' COMMENT 'The SNMPv3 authoritative engine id.',
  `auth_proto` set('NONE','MD5','SHA','SHA-224','SHA-256','SHA-384','SHA-512') NOT NULL DEFAULT '' COMMENT 'The SNMPv3 authorization protocol.',
  `auth_key` varchar(64) NOT NULL DEFAULT '' COMMENT 'The SNMPv3 authorization key.',
  `priv_proto` set('NONE','AES','AES192','AES256','AES192C','AES256C') NOT NULL DEFAULT '' COMMENT 'The SNMPv3 privacy protocol.',
  `priv_key` varchar(64) NOT NULL DEFAULT '' COMMENT 'The SNMPv3 privacy key.',
  `is_default` smallint(6) DEFAULT 0 COMMENT '1 if this is a system-default trap destination; 0 otherwise.',
  `is_enabled` smallint(6) DEFAULT 0 COMMENT '1 if this trap destination may be used at all; 0 otherwise.',
  `is_discovered` smallint(6) DEFAULT 0 COMMENT '1 if this trap destination were discovered; 0 if it were user-created.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `destination_key` (`ip_address`,`port`,`ro_community`,`snmp_version`,`user`,`engine_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the SNMP trap receivers that will be used to send trap-versions of our alerts to.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trapdestination`
--
-- WHERE:  1 limit 10

LOCK TABLES `trapdestination` WRITE;
/*!40000 ALTER TABLE `trapdestination` DISABLE KEYS */;
/*!40000 ALTER TABLE `trapdestination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trapeventconditions`
--

DROP TABLE IF EXISTS `trapeventconditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `trapeventconditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `event_id` int(11) NOT NULL COMMENT 'event_id foreignKey: net.trapevents.id',
  `trap_type` enum('TRIGGER','CLEAR') NOT NULL DEFAULT 'TRIGGER' COMMENT 'The trap type; TRIGGER or CLEAR.',
  `oid` varchar(80) NOT NULL COMMENT 'The trap variable must match this OID.',
  `comparison` enum('=','!=','>','>=','<','<=','regexp') NOT NULL COMMENT 'The comparison operation; may be one of ==,<,<=,>,>=,!=.',
  `value` varchar(80) NOT NULL COMMENT 'The value of the variable must match this one (according to ''comparison'').',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_tuple` (`event_id`,`trap_type`,`oid`,`comparison`,`value`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This adds additional constraints to a trap rule: the trap''s variables must match these.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trapeventconditions`
--
-- WHERE:  1 limit 10

LOCK TABLES `trapeventconditions` WRITE;
/*!40000 ALTER TABLE `trapeventconditions` DISABLE KEYS */;
INSERT INTO `trapeventconditions` VALUES (1,136,'TRIGGER','.1.3.6.1.4.1.27207.2.1.2.1.1.2','=','SevOne-consistency-check');
/*!40000 ALTER TABLE `trapeventconditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trapeventgroups`
--

DROP TABLE IF EXISTS `trapeventgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `trapeventgroups` (
  `event_id` int(11) NOT NULL COMMENT ' foreignKey: net.trapevents.id',
  `type` enum('DEVICEGROUP','DEVICE') NOT NULL DEFAULT 'DEVICEGROUP' COMMENT 'This defines what ''item_id'' refers to.',
  `item_id` int(11) NOT NULL COMMENT 'The ID of either the Device Group or the Device. Refers to one of the following two tables: net.devicetags.id, net.deviceinfo.id',
  UNIQUE KEY `unique_tuple` (`event_id`,`type`,`item_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines some additional filters for a trap rule.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trapeventgroups`
--
-- WHERE:  1 limit 10

LOCK TABLES `trapeventgroups` WRITE;
/*!40000 ALTER TABLE `trapeventgroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `trapeventgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trapevents`
--

DROP TABLE IF EXISTS `trapevents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `trapevents` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `description` text DEFAULT NULL COMMENT 'description',
  `trigger_oid` varchar(80) DEFAULT NULL COMMENT 'The trap should match (or at least start with) this Trigger OID.',
  `clear_oid` varchar(80) DEFAULT NULL COMMENT 'The trap should match (or at least start with) this Clear OID.',
  `log` smallint(6) DEFAULT -1 COMMENT '1 if the trap should be logged; 0 to not write it down anywhere.',
  `alert` smallint(6) DEFAULT -1 COMMENT '1 if an alert should be generated for the trap; 0 to not alert.',
  `severity` smallint(6) DEFAULT -1 COMMENT 'The severity to use for the alert.',
  `trigger_msg` varchar(1024) DEFAULT NULL COMMENT 'A human-readable trigger message about the trap.  This may contain any of several $-variables.',
  `clear_msg` varchar(1024) DEFAULT NULL COMMENT 'A human-readable clear message about the trap.  This may contain any of several $-variables.',
  `mail_once` int(11) DEFAULT 1 COMMENT '1 if the alert for this trap should be mailed only once; 0 if it should be mailed each time it happens.',
  `mailto` varchar(255) DEFAULT NULL COMMENT 'A comma-delimited list of e-mail addresses to send the alert information to.',
  `disabled` int(11) DEFAULT 0 COMMENT '1 if this rule should be ignored; 0 to allow it.',
  PRIMARY KEY (`id`),
  KEY `alert` (`alert`),
  KEY `disabled` (`disabled`),
  KEY `log` (`log`),
  KEY `oid` (`trigger_oid`),
  KEY `severity` (`severity`)
) ENGINE=MyISAM AUTO_INCREMENT=137 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines ''rules'' to handle SNMP traps received through SevOne-trapd.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trapevents`
--
-- WHERE:  1 limit 10

LOCK TABLES `trapevents` WRITE;
/*!40000 ALTER TABLE `trapevents` DISABLE KEYS */;
INSERT INTO `trapevents` VALUES (3,NULL,'.1.3.6.1.6.3.1.1.5.4',NULL,1,1,5,'Trap received from $dev: $oid -- Bindings: $var -- An interface has come back up.',NULL,1,'',0),(4,NULL,'.1.3.6.1.6.3.1.1.5.3',NULL,1,1,5,'Trap received from $dev: $oid -- Bindings: $var -- An interface has gone down.',NULL,1,'',0),(5,NULL,'.1.3.6.1.6.3.1.1.5.1',NULL,1,1,5,'Trap received from $dev: $oid -- Bindings: $var -- The device was powered up.',NULL,1,'',0),(6,NULL,'.1.3.6.1.6.3.1.1.5.2',NULL,1,1,5,'Trap received from $dev: $oid -- Bindings: $var -- The agent was re-configured.',NULL,1,'',0),(7,NULL,'.1.3.6.1.6.3.1.1.5.5',NULL,1,1,4,'Trap received from $dev: $oid -- Bindings: $var -- An authentication failure has occurred.',NULL,1,'',0),(8,NULL,'.1.3.6.1.6.3.1.1.5.6',NULL,1,1,5,'Trap received from $dev: $oid -- Bindings: $var',NULL,1,'',0),(12,NULL,'.1.3.6.1.4.1.9.2.9.3.1.1.130.1',NULL,1,1,4,'TCP connection failed for $dev: $oid -- Bindings: $var',NULL,1,'',0),(15,NULL,'.1.3.6.1.2.1.10.21.2.0.1',NULL,1,1,5,'Trap received from $dev: $oid -- Bindings: $var -- A successful call has cleared, or a failed call attempt has ultimately failed.',NULL,1,'',0),(16,NULL,'.1.3.6.1.2.1.10.5.0.2',NULL,1,1,4,'Trap received from $dev: $oid -- Bindings: $var -- The PLE sent or received a reset.',NULL,1,'',0),(18,NULL,'.1.3.6.1.4.1.494.4.0.2',NULL,1,1,2,'Trap received from $dev: $oid -- Bindings: $var -- The external fan has failed.',NULL,1,'',0);
/*!40000 ALTER TABLE `trapevents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trapwebhook_webhookdef_map`
--

DROP TABLE IF EXISTS `trapwebhook_webhookdef_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `trapwebhook_webhookdef_map` (
  `trap_webhook_id` bigint(20) NOT NULL COMMENT 'Trap webhook id. foreignKey: net.trap_webhooks.id',
  `webhook_definition_id` bigint(20) NOT NULL COMMENT 'Webhook definition id. foreignKey: net.webhook_definitions.id',
  PRIMARY KEY (`trap_webhook_id`,`webhook_definition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the trap webhook - webhook definition map in the system.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trapwebhook_webhookdef_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `trapwebhook_webhookdef_map` WRITE;
/*!40000 ALTER TABLE `trapwebhook_webhookdef_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `trapwebhook_webhookdef_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unitinfo`
--

DROP TABLE IF EXISTS `unitinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `unitinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(64) NOT NULL COMMENT 'This is the name of the unit in question; for example, ''Bytes''.  This is always plural.',
  `abbreviation` varchar(32) DEFAULT NULL COMMENT 'This is the accepted abbreviation for the unit, or blank if there is none.  For example, ''Bytes'' is abbreviated ''b''.',
  `conversion` int(11) DEFAULT 0 COMMENT '1 if this row describes a converstion from ''conversion_base''; 0 if this row defines a new unit.',
  `conversion_base` varchar(64) DEFAULT NULL COMMENT 'The unit that will be used for the starting point of the conversion.',
  `conversion_operation` varchar(128) DEFAULT NULL COMMENT 'This is a LIST (comma-delimited) of operations (*,/,+,-) that corresponds 1:1 with ''conversion_value''.  For example, if this is ''*,-'', then the base value will first be multiplied by the first value in ''conversion_value'', and then that result will then have the second value in ''conversion_value subtracted from it.',
  `conversion_value` varchar(128) DEFAULT NULL COMMENT 'This is a LIST (comma-delimited) of operands (numbers) that corresponds 1:1 with ''conversion_operations''.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`conversion`,`conversion_base`)
) ENGINE=MyISAM AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the units that are available for use, and also the conversions between them.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unitinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `unitinfo` WRITE;
/*!40000 ALTER TABLE `unitinfo` DISABLE KEYS */;
INSERT INTO `unitinfo` VALUES (1,'Bits','b',0,'','','0'),(2,'Kilobits','Kb',1,'Bits','/','1000'),(3,'Megabits','Mb',1,'Bits','/','1000000'),(4,'Gigabits','Gb',1,'Bits','/','1000000000'),(5,'Bytes','B',0,'','','0'),(6,'Kilobytes','KB',1,'Bytes','/','1000'),(7,'Megabytes','MB',1,'Bytes','/','1000000'),(8,'Gigabytes','GB',1,'Bytes','/','1000000000'),(9,'Seconds','s',0,'','','0'),(10,'Milliseconds','ms',1,'Seconds','*','1000');
/*!40000 ALTER TABLE `unitinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userreports`
--

DROP TABLE IF EXISTS `userreports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `userreports` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) NOT NULL COMMENT ' foreignKey: access_control.user.uid',
  `report_id` int(11) NOT NULL COMMENT ' foreignKey: net.surf.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pair` (`user_id`,`report_id`),
  KEY `reportId` (`report_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table maps a user''s ''favorite'' reports to that user.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userreports`
--
-- WHERE:  1 limit 10

LOCK TABLES `userreports` WRITE;
/*!40000 ALTER TABLE `userreports` DISABLE KEYS */;
/*!40000 ALTER TABLE `userreports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vmwaredeviceinfo`
--

DROP TABLE IF EXISTS `vmwaredeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `vmwaredeviceinfo` (
  `dev_id` int(11) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `vmware_external_key` varchar(25) DEFAULT NULL COMMENT 'ZOMG INVESTIGATE.',
  `type` varchar(255) DEFAULT NULL COMMENT 'ZOMG INVESTIGATE.',
  `is_host` tinyint(4) DEFAULT 0 COMMENT '1 if this is a VMware host; 0 otherwise.',
  `is_vm` tinyint(4) DEFAULT 0 COMMENT '1 if this is a virtual machine; 0 otherwise.',
  `is_vcenter` tinyint(4) DEFAULT 0 COMMENT '1 if this is a vCenter; 0 otherwise.',
  `is_cluster` tinyint(4) DEFAULT 0 COMMENT '1 if this is a VMware cluster; 0 otherwise.',
  `version` varchar(32) DEFAULT NULL COMMENT 'The VMware-reported version.',
  `api_dev_id` int(10) unsigned DEFAULT NULL COMMENT 'The ID of the Device to use to ask for VMware information about this Device.  This is typically either the vCenter or the host for the VM. foreignKey: net.deviceinfo.id',
  `vcenter_id` int(11) DEFAULT NULL COMMENT 'The ID of the Device that represents the vCenter in SevOne NMS. foreignKey: net.deviceinfo.id',
  `host_id` int(10) unsigned DEFAULT NULL COMMENT 'ZOMG INVESTIGATE.',
  `use_http` tinyint(4) DEFAULT 0 COMMENT 'ZOMG INVESTIGATE.',
  `name` varchar(255) DEFAULT NULL COMMENT 'The name of this entity as it appears in VMware.',
  `username` varchar(497) DEFAULT NULL COMMENT 'The username to use if there is no API Device.',
  `password` varchar(497) DEFAULT NULL COMMENT 'The password to use if there is no API Device.',
  `vmware_session_id` varchar(255) DEFAULT NULL COMMENT 'The VMware-specific ''session'' identifier to use when talking to this Device.  This will be updated from time to time.',
  `auto_discovery` tinyint(4) DEFAULT 0 COMMENT 'ZOMG INVESTIGATE',
  `poll_host` tinyint(4) DEFAULT 0 COMMENT 'ZOMG INVESTIGATE',
  `host_username` varchar(497) DEFAULT NULL COMMENT 'ZONG INVESTIGATE',
  `host_password` varchar(497) DEFAULT NULL COMMENT 'ZOMG INVESTIGATE',
  `last_event_datetime` int(11) DEFAULT 0 COMMENT 'ZOMG INVESTIGATE',
  PRIMARY KEY (`dev_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines VMware-specific information about a Device.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vmwaredeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `vmwaredeviceinfo` WRITE;
/*!40000 ALTER TABLE `vmwaredeviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `vmwaredeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webhook_definitions`
--

DROP TABLE IF EXISTS `webhook_definitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `webhook_definitions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id of the webhook definition',
  `type` enum('POLICY','TRAP') NOT NULL DEFAULT 'POLICY' COMMENT 'Webhook definition type based on the usage of the webhook definition for policies/traps',
  `name` varchar(255) NOT NULL COMMENT 'The name of the webhook definition',
  `description` text DEFAULT NULL COMMENT 'The description for the webhook definition',
  `url` varchar(512) NOT NULL COMMENT 'The url for the webhook definition',
  `proxy_url` varchar(512) DEFAULT NULL COMMENT 'The proxy url for the webhook definition',
  `proxy_username` varchar(255) DEFAULT NULL COMMENT 'The encrypted proxy username for the webhook definition',
  `proxy_password` varchar(255) DEFAULT NULL COMMENT 'The encrypted proxy password for the webhook definition',
  `headers` text DEFAULT NULL COMMENT 'Headers for the webhook definition',
  `time_format` enum('CLUSTER_DATE_FORMAT','UNIX_TIMESTAMP','GMT_TIMESTAMP','DATE_TIME','YMDHMS','HUMAN_FRIENDLY') NOT NULL DEFAULT 'CLUSTER_DATE_FORMAT' COMMENT 'Time format for timestamps used in webhook body for the webhook definition',
  `time_zone` enum('DEVICE_LOCAL_TIMEZONE','CLUSTER_TIMEZONE','GMT') DEFAULT 'DEVICE_LOCAL_TIMEZONE' COMMENT 'Time zone for timestamps used in webhook body for the webhook definition',
  `request_method` varchar(10) NOT NULL COMMENT 'Request Method for the webhook definition',
  `content_type` varchar(100) DEFAULT NULL COMMENT 'Content Type for the body of webhook definition',
  `body` text DEFAULT NULL COMMENT 'Body for the webhook definition',
  `allow_insecure_connection` tinyint(1) DEFAULT 0 COMMENT 'Allow the Insecure Connection flag to skip SSL verification for the webhook URL',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the various Webhook Definitions.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhook_definitions`
--
-- WHERE:  1 limit 10

LOCK TABLES `webhook_definitions` WRITE;
/*!40000 ALTER TABLE `webhook_definitions` DISABLE KEYS */;
/*!40000 ALTER TABLE `webhook_definitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webhook_templates`
--

DROP TABLE IF EXISTS `webhook_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `webhook_templates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The id of the webhook template',
  `name` varchar(255) NOT NULL COMMENT 'The name of the webhook template',
  `description` text DEFAULT NULL COMMENT 'The description for the webhook template',
  `url` varchar(512) NOT NULL COMMENT 'The url for the webhook template',
  `request_method` varchar(10) NOT NULL COMMENT 'Request Method for the webhook template',
  `content_type` varchar(100) DEFAULT NULL COMMENT 'Content Type for the body of webhook template',
  `body` text DEFAULT NULL COMMENT 'Body for the webhook template',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the various Webhook Definition Templates.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhook_templates`
--
-- WHERE:  1 limit 10

LOCK TABLES `webhook_templates` WRITE;
/*!40000 ALTER TABLE `webhook_templates` DISABLE KEYS */;
INSERT INTO `webhook_templates` VALUES (1,'Post to Slack','Posts an alert message to the configured Slack app channel. You\'ll need to create a Slack App for incoming webhooks in Slack, then replace the URL below with the Slack App URL it generates.\nNote: This template is defined for trigger-metric policy-generated alerts. It can be modified based on the supported variable to use in the body for clear-metric, flow, and trap alert webhooks.','https://example.com/your-slack-webhook-url-here','POST','application/json','{\n    \"blocks\": [\n        {\n            \"type\": \"header\",\n            \"text\": {\n                \"type\": \"plain_text\",\n                \"text\": \"New SevOne Alert\"\n            }\n        },\n        {\n            \"type\": \"divider\"\n        },\n        {\n            \"type\": \"section\",\n            \"text\": {\n                \"type\": \"mrkdwn\",\n                \"text\": \":warning: $alertState\"\n            }\n        },\n        {\n            \"type\": \"section\",\n            \"text\": {\n                \"type\": \"mrkdwn\",\n                \"text\": \"$policyName - $plainTextTriggeringConditions\"\n            }\n        },\n        {\n            \"type\": \"divider\"\n        },\n        {\n            \"type\": \"section\",\n            \"fields\": [\n                {\n                    \"type\": \"mrkdwn\",\n                    \"text\": \"Device Name: *$deviceName*\"\n                },\n                {\n                    \"type\": \"mrkdwn\",\n                    \"text\": \"Device IP: *$deviceIp*\"\n                },\n                {\n                    \"type\": \"mrkdwn\",\n                    \"text\": \"Object Name: *$objectName*\"\n                },\n                {\n                    \"type\": \"mrkdwn\",\n                    \"text\": \"Object Description: *$objectDescription*\"\n                }\n            ]\n        },\n        {\n            \"type\": \"divider\"\n        }\n    ]\n}'),(2,'Post to Slack w/ DI URL','Posts an alert message to the configured Slack app channel. You\'ll need to create a Slack App for incoming webhooks in Slack, then replace the URL below with the Slack App URL it generates.\nAdditionally, this template includes a Data Insight deep link field. Replace that field in the body with your desired Data Insight URL and variables.\nNote: This template is defined for trigger-metric policy-generated alerts. It can be modified based on the supported variable to use in the body for clear-metric, flow, and trap alert webhooks.','https://example.com/your-slack-webhook-url-here','POST','application/json','{\n    \"blocks\": [\n        {\n            \"type\": \"header\",\n            \"text\": {\n                \"type\": \"plain_text\",\n                \"text\": \"New SevOne Alert\"\n            }\n        },\n        {\n            \"type\": \"divider\"\n        },\n        {\n            \"type\": \"section\",\n            \"text\": {\n                \"type\": \"mrkdwn\",\n                \"text\": \":warning: $alertState\"\n            }\n        },\n        {\n            \"type\": \"section\",\n            \"text\": {\n                \"type\": \"mrkdwn\",\n                \"text\": \"$policyName - $plainTextTriggeringConditions\"\n            }\n        },\n        {\n            \"type\": \"section\",\n            \"text\": {\n                \"type\": \"mrkdwn\",\n                \"text\": \"<DI_URL.com/redirect/v1/reports?reportName=Indicator%20Summary&$DIDataResources|View in Data Insight>\"\n            }\n        },\n        {\n            \"type\": \"divider\"\n        },\n        {\n            \"type\": \"section\",\n            \"fields\": [\n                {\n                    \"type\": \"mrkdwn\",\n                    \"text\": \"Device Name: <DI_URL.com/redirect/v1/reports?reportName=Device%20Summary&datasourceName=$clusterName&devices=$deviceName|$deviceName>\"\n                },\n                {\n                    \"type\": \"mrkdwn\",\n                    \"text\": \"Device IP: *$deviceIp*\"\n                },\n                {\n                    \"type\": \"mrkdwn\",\n                    \"text\": \"Object Name: <DI_URL.com/redirect/v1/reports?reportName=Object%20Summary&datasourceName=$clusterName&objects=$pluginName%26%26$deviceName%26%26$objectName|$objectName>\"\n                },\n                {\n                    \"type\": \"mrkdwn\",\n                    \"text\": \"Object Description: *$objectDescription*\"\n                }\n            ]\n        },\n        {\n            \"type\": \"divider\"\n        }\n    ]\n}'),(3,'Post to CloudPak for AIOps','Posts an alert to the configured CloudPak for AIOps. Replace the URL below with the CloudPak for AIOps URL.\nNote: This template is defined for trigger-metric policy-generated alerts. It can be modified based on the supported variable to use in the body for clear-metric, flow, and trap alert webhooks.','https://<CloudPak_For_AIOps_SevOne_Probe_URL>','POST','application/json','{\n    \"routes\": [\"Netcool\"],\n    \"host\": \"$deviceName\",\n    \"description\": \"$alertMessage\",\n    \"alertMessage\": \"$alertMessage\",\n    \"check\": \"$policyName - $objectName\",\n    \"cluster\": \"$clusterName\",\n    \"alertId\": \"$alertId\",\n    \"alertType\": \"$alertType\",\n    \"alertState\": \"$alertState\",\n    \"occurrences\": \"$occurrences\",\n    \"assignedTo\": \"$assignedTo\",\n    \"deviceId\": \"$deviceId\",\n    \"deviceIp\": \"$deviceIp\",\n    \"deviceName\": \"$deviceName\",\n    \"deviceAltName\": \"$deviceAltName\",\n    \"groupName\": \"$groupName\",\n    \"objectId\": \"$objectId\",\n    \"objectName\": \"$objectName\",\n    \"objectAltName\": \"$objectAltName\",\n    \"objectDescription\": \"$objectDescription\",\n    \"pluginName\": \"$pluginName\",\n    \"pluginDescription\": \"$pluginDescription\",\n    \"policyId\": \"$policyId\",\n    \"policyName\": \"$policyName\",\n    \"thresholdId\": \"$thresholdId\",\n    \"thresholdName\": \"$thresholdName\",\n    \"linkURL\" : \"<DI_URL.com/redirect/v1/reports?reportName=Indicator%20Summary&$DIDataResources|View in Data Insight>\",\n    \"triggeringConditions\": $triggeringConditions,\n    \"closureMessage\": \"$closureMessage\" \n}');
/*!40000 ALTER TABLE `webhook_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webhook_webhookdef_map`
--

DROP TABLE IF EXISTS `webhook_webhookdef_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `webhook_webhookdef_map` (
  `webhook_id` int(11) NOT NULL COMMENT 'Policy webhook id. foreignKey: net.policy_webhooks.id',
  `webhook_definition_id` bigint(20) NOT NULL COMMENT 'Webhook definition id. foreignKey: net.webhook_definitions.id',
  PRIMARY KEY (`webhook_id`,`webhook_definition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the policy webhook - webhook definition map in the system.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhook_webhookdef_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `webhook_webhookdef_map` WRITE;
/*!40000 ALTER TABLE `webhook_webhookdef_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `webhook_webhookdef_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webhooks`
--

DROP TABLE IF EXISTS `webhooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `webhooks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'Name of the webhook',
  `eventName` varchar(255) NOT NULL COMMENT 'The event that will trigger the webhook',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description of the webhook',
  `global_entity_id` int(11) DEFAULT NULL COMMENT 'The id of global entity',
  `local_entity_id` int(11) DEFAULT NULL COMMENT 'The id of the local entity',
  `options` varchar(255) DEFAULT NULL COMMENT 'Additional options that will be used by the event triggering the webhook',
  `auth_type` varchar(255) NOT NULL COMMENT 'The authentication type to be used when calling the remote url',
  `remote_url` varchar(255) NOT NULL COMMENT 'The url that will be posted to, when the webhook is triggered',
  `secret` varchar(255) DEFAULT NULL COMMENT 'The secret to be used when when calling the remote url',
  `user_id` int(11) DEFAULT NULL COMMENT 'The id of the user',
  `password` varchar(255) DEFAULT NULL COMMENT 'The password to be used when when calling the remote url',
  `is_active` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Boolean flag used to mark a webhook active.',
  `date_created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Date of creation of the webhook',
  `date_updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Last update date of the webhook',
  PRIMARY KEY (`id`),
  KEY `idx_webhooks_eventName_global_local_entity_id` (`eventName`,`global_entity_id`,`local_entity_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the webhooks for the new RESTful API. This is deprecated and does not relate to the new webhook features';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhooks`
--
-- WHERE:  1 limit 10

LOCK TABLES `webhooks` WRITE;
/*!40000 ALTER TABLE `webhooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `webhooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webstatusdeviceinfo`
--

DROP TABLE IF EXISTS `webstatusdeviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `webstatusdeviceinfo` (
  `dev_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the Device in question. foreignKey: net.deviceinfo.id',
  `webstatus_https` tinyint(1) unsigned DEFAULT 0 COMMENT 'It indicate whether or not we should use https.',
  `webstatus_port` smallint(11) unsigned DEFAULT NULL COMMENT 'It indicate which port we should use over https.',
  PRIMARY KEY (`dev_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines WebStatus information about a Device.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webstatusdeviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `webstatusdeviceinfo` WRITE;
/*!40000 ALTER TABLE `webstatusdeviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `webstatusdeviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wifideviceinfo`
--

DROP TABLE IF EXISTS `wifideviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wifideviceinfo` (
  `dev_id` bigint(20) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `vendor` longtext DEFAULT NULL COMMENT 'WiFi vendor name',
  `settings` longtext NOT NULL COMMENT 'WiFi Device extra settings',
  PRIMARY KEY (`dev_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines WiFi-specific information about a Device.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wifideviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `wifideviceinfo` WRITE;
/*!40000 ALTER TABLE `wifideviceinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `wifideviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wifisettings`
--

DROP TABLE IF EXISTS `wifisettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wifisettings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The ID for the settings ',
  `settingkey` longtext NOT NULL COMMENT 'setting key for common settings of all wifi controller',
  `settingvalue` longtext NOT NULL COMMENT 'value corresponding to the key',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines WiFi-specific information for all wifi controllers.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wifisettings`
--
-- WHERE:  1 limit 10

LOCK TABLES `wifisettings` WRITE;
/*!40000 ALTER TABLE `wifisettings` DISABLE KEYS */;
INSERT INTO `wifisettings` VALUES (1000,'cluster_settings','{\"AP_ESS_AGG_BL\": \"\", \"AP_ESS_AGG_BL_ALL\": false, \"COLLECT_STATION_USERNAME\": true, \"NO_PREFIX\": true, \"WLC_ESS_BL\": \"\", \"WLC_ESS_WL\": \"\", \"WLC_VERBOSE\": 2, \"COLLECT_AUDIT_LOGS\": true, \"ENABLE_WIFI_M2M_AUTH\": true}');
/*!40000 ALTER TABLE `wifisettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wmideviceinfo`
--

DROP TABLE IF EXISTS `wmideviceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wmideviceinfo` (
  `dev_id` int(10) unsigned NOT NULL COMMENT 'This is the Device in question. foreignKey: net.deviceinfo.id',
  `wmi_capable` tinyint(1) unsigned DEFAULT 1 COMMENT 'ZOMG: THIS COLUMN MAKES NO SENSE AND SHOULD BE REMOVED.',
  `wmi_proxy_id` int(11) DEFAULT NULL COMMENT 'This is the ID of the WMI Proxy that will be used to communicate with the Device. foreignKey: net.wmiproxy.id',
  `username` varchar(497) DEFAULT NULL COMMENT 'The Windows username.',
  `password` varchar(497) DEFAULT NULL COMMENT 'The user''s password.',
  `workgroup_or_domain` varchar(256) DEFAULT NULL COMMENT 'This is either the Windows workgroup name or the Windows domain name; whichever applies.',
  `authentication_level` enum('Default','None','Connect','Call','Packet','PacketIntegrity','PacketPrivacy','Unchanged') DEFAULT 'Default' COMMENT 'These are defined by WMI; the value must match that of the Device.',
  `impersonation_level` enum('Default','Anonymous','Identify','Impersonate','Delegate') DEFAULT 'Default' COMMENT 'These are defined by WMI; the value must match that of the Device.',
  `use_ntlm` tinyint(1) unsigned DEFAULT 0 COMMENT '1 if NTLM should be used; 0 otherwise.',
  PRIMARY KEY (`dev_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the Windows login credentials for a Device.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wmideviceinfo`
--
-- WHERE:  1 limit 10

LOCK TABLES `wmideviceinfo` WRITE;
/*!40000 ALTER TABLE `wmideviceinfo` DISABLE KEYS */;
INSERT INTO `wmideviceinfo` VALUES (52,0,NULL,NULL,NULL,NULL,'Default','Default',0);
/*!40000 ALTER TABLE `wmideviceinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wmiproxy`
--

DROP TABLE IF EXISTS `wmiproxy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wmiproxy` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) NOT NULL COMMENT 'This is the unique name of the proxy.',
  `ip` varbinary(40) NOT NULL COMMENT 'This is the IP address of the proxy.',
  `port` int(11) NOT NULL COMMENT 'This is the port number that the proxy is listening on (default: 3000).',
  `encryption_support` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'This is whether or not encryption will be used when connecting through the proxy.',
  `encryption_password` varchar(64) NOT NULL DEFAULT '' COMMENT 'This is the encryption password used to en/de/crypt the payload send from/to the proxy.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ip_port` (`ip`,`port`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the WMI ''proxy'' servers that allow our WMI Plugin to work; a WMI Device must have a proxy to be polled.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wmiproxy`
--
-- WHERE:  1 limit 10

LOCK TABLES `wmiproxy` WRITE;
/*!40000 ALTER TABLE `wmiproxy` DISABLE KEYS */;
/*!40000 ALTER TABLE `wmiproxy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workhours_groups`
--

DROP TABLE IF EXISTS `workhours_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `workhours_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(256) NOT NULL COMMENT 'The name of the ''work hours'' group.  For example, this could be something like ''Second Shift''.',
  `is_default` tinyint(1) NOT NULL COMMENT '1 if this is the SINGLE default ''work hours'' group that should be applied to all NEW Devices; 0 otherwise.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This describes the ''groups'' that define what ''work hours'' are for Devices.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workhours_groups`
--
-- WHERE:  1 limit 10

LOCK TABLES `workhours_groups` WRITE;
/*!40000 ALTER TABLE `workhours_groups` DISABLE KEYS */;
INSERT INTO `workhours_groups` VALUES (1,'System Default',1);
/*!40000 ALTER TABLE `workhours_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workhours_relativetime`
--

DROP TABLE IF EXISTS `workhours_relativetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `workhours_relativetime` (
  `workhours_group_id` int(11) NOT NULL COMMENT ' foreignKey: net.workhours_groups.id',
  `sunday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Sunday; 0 otherwise',
  `monday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Monday; 0 otherwise',
  `tuesday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Tuesday; 0 otherwise',
  `wednesday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Wednesday; 0 otherwise',
  `thursday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Thursday; 0 otherwise',
  `friday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Friday; 0 otherwise',
  `saturday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Saturday; 0 otherwise',
  `start_hr` int(11) NOT NULL DEFAULT 0 COMMENT 'The hour at which ''work hours'' begin for this day.',
  `start_min` int(11) NOT NULL DEFAULT 0 COMMENT 'The minute of ''start_hr'' at which ''work hours'' begin for this day.',
  `end_hr` int(11) NOT NULL DEFAULT 0 COMMENT 'The hour at which ''work hours'' end for this day.',
  `end_min` int(11) NOT NULL DEFAULT 0 COMMENT 'The minute of ''end_hr'' at which ''work hours'' end for this day.',
  KEY `workhours_group_id` (`workhours_group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='For a ''work hours'' group, this defines the days and times at which the ''work hours'' apply.  A ''work hours'' group may have many entries in this table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workhours_relativetime`
--
-- WHERE:  1 limit 10

LOCK TABLES `workhours_relativetime` WRITE;
/*!40000 ALTER TABLE `workhours_relativetime` DISABLE KEYS */;
INSERT INTO `workhours_relativetime` VALUES (1,0,1,1,1,1,1,0,9,0,17,0);
/*!40000 ALTER TABLE `workhours_relativetime` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-30 10:11:37
