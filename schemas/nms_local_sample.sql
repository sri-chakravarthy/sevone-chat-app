/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.6.25-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: local
-- ------------------------------------------------------
-- Server version	10.6.25-MariaDB-log

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
-- Table structure for table `bulkdata_fetched_files`
--

DROP TABLE IF EXISTS `bulkdata_fetched_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulkdata_fetched_files` (
  `source` int(11) NOT NULL COMMENT ' foreignKey: net.bulkdata_sources.id',
  `name` varchar(255) NOT NULL COMMENT 'The name of the file downloaded from the EMS',
  `fetch_timestamp` int(11) NOT NULL COMMENT 'The time the file was downloaded from the EMS',
  `generation_timestamp` int(11) DEFAULT NULL COMMENT 'The last modified timestamp of the file on the remote system',
  `file_size` bigint(20) DEFAULT NULL COMMENT 'The size of the file that was downloaded',
  UNIQUE KEY `file` (`source`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Table listing when files were downloaded from the EMS (Element Management Server)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulkdata_fetched_files`
--
-- WHERE:  1 limit 10

LOCK TABLES `bulkdata_fetched_files` WRITE;
/*!40000 ALTER TABLE `bulkdata_fetched_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulkdata_fetched_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coc_expressions`
--

DROP TABLE IF EXISTS `coc_expressions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `coc_expressions` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `group_id` int(11) DEFAULT NULL COMMENT ' foreignKey: local.coc_groups.id',
  `indicator_type` int(11) DEFAULT NULL COMMENT ' foreignKey: net.plugin_indicator_type.id',
  `expression` text DEFAULT NULL COMMENT 'The mathematic expression to evaluate. Variables are referenced as ${variable_name}. This is eventually parsed inside of Kron by the muParser library.',
  `max_value` text DEFAULT NULL COMMENT 'The mathemetical expression we evaluate to find the net.cocpoll.max_value for the indicator. This is evaluated by Discovery. Variables are references as ${variable_name}.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_type` (`group_id`,`indicator_type`)
) ENGINE=MyISAM AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Defines the expressions that belong to a given expression group. Expressions will define indicators that belong to the created object when we run Discovery.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coc_expressions`
--
-- WHERE:  1 limit 10

LOCK TABLES `coc_expressions` WRITE;
/*!40000 ALTER TABLE `coc_expressions` DISABLE KEYS */;
INSERT INTO `coc_expressions` VALUES (1,1,16231,'(${hcInTotal})','${hcInTotal}+${hcOutTotal}'),(2,15,16231,'${test}',''),(3,14,16231,'${test1}',''),(4,1,16366,'(${hcInTotal})',''),(5,1,16537,'(${hcInTotal})',''),(6,10,16537,'(${averageJitter})',''),(7,16,16554,'( ${averageRtt})',''),(8,16,16555,'( ((${averageRtt} / 1000) < 0) ? 0 : 1  )',''),(9,16,16556,'0',''),(10,16,16557,'( ${packetLossDS})','');
/*!40000 ALTER TABLE `coc_expressions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coc_groups`
--

DROP TABLE IF EXISTS `coc_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `coc_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `object_type` int(11) DEFAULT 0 COMMENT ' foreignKey: net.plugin_object_type.id',
  `dev_id` int(11) DEFAULT 0 COMMENT ' foreignKey: net.deviceinfo.id',
  `name` varchar(255) DEFAULT NULL COMMENT 'This is the name that will be given to the object created from this group',
  `description` varchar(255) DEFAULT NULL COMMENT 'This is the description that will be given to the object created from this group',
  `default_value` double DEFAULT NULL COMMENT 'This is the value given to expressions when the expression''s value cannot be evaluated (For instance, invalid value or divide-by-zero error).',
  PRIMARY KEY (`id`),
  UNIQUE KEY `device_name` (`dev_id`,`name`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Defines the groups that belong to a given device. Groups own any number of variables and expressions. Groups are used to define what objects should be created when we Discover the device.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coc_groups`
--
-- WHERE:  1 limit 10

LOCK TABLES `coc_groups` WRITE;
/*!40000 ALTER TABLE `coc_groups` DISABLE KEYS */;
INSERT INTO `coc_groups` VALUES (1,1891,219,'Armonk-HCTotal','Armonk-HCTotal',0),(2,1891,83,'Perth-hc-octets','Perth-hc-octets',-1),(10,1944,83,'EU-UK-LON99:EU-CH-SCUN:ZEU-CH-SCUN-U320-WR01:DE','jitter-EU-CH-SCUN-zeu-ch-scun-u320-wr01:DE:-Index:645130100-ToS:0',-1),(12,1891,83,'test','test',0),(13,1891,219,'test','test',0),(14,1891,4854,'Edge','Edge Calculation',0),(15,1891,4855,'Edge1','Edge 1 Calculation',0),(16,1944,4856,'EU-UK-LON99:EU-CH-SCUN:ZEU-CH-SCUN-U320-WR01:DE','jitter-EU-CH-SCUN-zeu-ch-scun-u320-wr01:DE:-Index:645130100-ToS:0',NULL),(17,1962,4857,'EU-UK-LON99:EU-CH-SCUN:ZEU-CH-SCUN-U320-WR01:DE:NEW','jitter-EU-CH-SCUN-zeu-ch-scun-u320-wr01:DE:-Index:645130100-ToS:0',NULL);
/*!40000 ALTER TABLE `coc_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coc_variables`
--

DROP TABLE IF EXISTS `coc_variables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `coc_variables` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `dev_id` int(11) DEFAULT 0 COMMENT 'This is the device of the indicator this variable references belongs to. foreignKey: net.deviceinfo.id',
  `plugin_id` int(11) DEFAULT 0 COMMENT 'This is the plugin of the indicator this variable references belongs to. foreignKey: net.plugins.id',
  `indicator_id` int(11) DEFAULT 0 COMMENT 'This it the ID of the indicator this variable references. This ID might not exist in the foreign table on our peer, but on any peer in the cluster. foreignKey: local.device_indicator.id',
  `group_id` int(11) DEFAULT 0 COMMENT ' foreignKey: local.coc_groups.id',
  `variable_name` varchar(32) DEFAULT NULL COMMENT 'This is the string used to reference this variable in a Calculation expression. This is referenced by ${variable_name}, where the ${ and } are not included in this value. This field may only contain alphanumeric values.',
  `default_value` double DEFAULT NULL COMMENT 'The default value for this variable.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_variable_name` (`group_id`,`variable_name`)
) ENGINE=MyISAM AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines a reference to an indicator that may exist on ANY PEER in the cluster. This means that the indicator_id column may point to an ID that does not exist on our peer. The peer the indicator exists on is controlled by the dev_id, since devices may exist on only one peer.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coc_variables`
--
-- WHERE:  1 limit 10

LOCK TABLES `coc_variables` WRITE;
/*!40000 ALTER TABLE `coc_variables` DISABLE KEYS */;
INSERT INTO `coc_variables` VALUES (1,83,1,22531,1,'hcInTotal',NULL),(2,219,1,50148,1,'hcOutTotal',NULL),(37,83,1,22544,16,'averageRtt',0),(38,83,1,227712,16,'packetLossDS',0),(39,83,1,22528,16,'packetLossSD',0),(40,83,1,22529,16,'sentPackets',0),(16,83,1,22531,10,'averageJitter',0),(17,219,1,50148,15,'test',NULL),(18,220,1,50194,14,'test1',NULL),(46,83,1,22529,17,'sentPackets',0);
/*!40000 ALTER TABLE `coc_variables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_database`
--

DROP TABLE IF EXISTS `device_database`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_database` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `device_id` int(11) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.deviceinfo.id',
  `type` enum('MYSQL','ORACLE') NOT NULL DEFAULT 'MYSQL' COMMENT 'This is the kind of database in question.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'This is a user-provided name for the database.  TODO: This SHOULD be unique per Device.',
  `description` varchar(255) DEFAULT NULL COMMENT 'This is a user-provided description for the database.',
  `username` varchar(497) NOT NULL COMMENT 'This is the username with which to log in to the database (plaintext).',
  `password` varchar(497) NOT NULL COMMENT 'This is the password with which to log in to the database (plaintext).',
  `port` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the port number to use to connect to the database.',
  `connection_string` varchar(255) NOT NULL DEFAULT '' COMMENT 'The Oracle-specific connection string (this makes sense for Oracle connections).',
  PRIMARY KEY (`id`),
  UNIQUE KEY `device_id_and_name` (`device_id`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the databases for Devices in the system.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_database`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_database` WRITE;
/*!40000 ALTER TABLE `device_database` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_database` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_indicator`
--

DROP TABLE IF EXISTS `device_indicator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_indicator` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `device_id` int(10) unsigned NOT NULL COMMENT 'device id foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT 'object id foreignKey: local.device_object.id',
  `plugin_id` smallint(5) unsigned NOT NULL COMMENT 'plugin id foreignKey: net.plugins.id',
  `plugin_indicator_type_id` int(10) unsigned NOT NULL COMMENT 'This is the Indicator Type ID of the Indicator. foreignKey: net.plugin_indicator_type.id',
  `is_enabled` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 if the Indicator is enabled (that is, polling); 0 otherwise.',
  `is_baselining` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 if the Indicator will be baselined; 0 otherwise.',
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if the Indicator is scheduled for deletion; 0 otherwise.  This currently has no effect.',
  `column_name` varchar(255) DEFAULT NULL COMMENT 'This is name of the longterm table''s column that represents this Indicator''s data.  The table may be found using ''local.device_object.table_name''.',
  `maximum_value` double DEFAULT NULL COMMENT 'This is the maximum value of the Indicator (in ''data_units'' units).  If there is none, then this may be safely set to zero.',
  `format` enum('GAUGE','COUNTER32','COUNTER64') NOT NULL DEFAULT 'GAUGE' COMMENT 'This is how to interpret the data that will be collected for this Indicator.',
  `has_precalculated_deltas` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if this Indicator Type is COUNTERXX and the polled data represents precalculated deltas.',
  `last_invalidation_time` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the last time that Device Discovery decided to invalidate this Indicator.  When an invalidation occurs, the previous value (if a counter) is not to be trusted.',
  `synthetic_expression` varchar(2048) DEFAULT NULL COMMENT 'If this is NULL, then this is an Atomic Indicator.  Otherwise, this is a Synthetic Indicator, and this is an expression that SevOne-datad will use to evaluate its value.',
  `evaluation_order` int(10) unsigned DEFAULT NULL COMMENT 'This is the order in which to evaluate the Indicator (only if ''synthetic_expression'' is set).',
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_key` (`device_id`,`object_id`,`plugin_indicator_type_id`),
  KEY `object_id` (`object_id`),
  KEY `plugin_id` (`plugin_id`),
  KEY `plugin_indicator_type_id` (`plugin_indicator_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=255321 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the main information about an Indicator.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_indicator`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_indicator` WRITE;
/*!40000 ALTER TABLE `device_indicator` DISABLE KEYS */;
INSERT INTO `device_indicator` VALUES (245,1,8,1,12974,1,1,0,'p1i245',800,'COUNTER32',0,0,NULL,1),(246,1,8,1,12976,1,1,0,'p1i246',800,'COUNTER32',0,0,NULL,1),(247,1,8,1,12975,1,1,0,'p1i247',800,'COUNTER32',0,0,NULL,1),(248,1,8,1,12977,1,1,0,'p1i248',800,'COUNTER32',0,0,NULL,1),(249,1,8,1,12978,1,1,0,'p1i249',800,'COUNTER32',0,0,NULL,1),(250,1,8,1,12980,1,1,0,'p1i250',800,'COUNTER32',0,0,NULL,1),(251,1,8,1,12979,1,1,0,'p1i251',800,'COUNTER32',0,0,NULL,1),(252,1,8,1,12981,1,1,0,'p1i252',800,'COUNTER32',0,0,NULL,1),(253,1,8,1,12982,1,1,0,'p1i253',800,'COUNTER32',0,0,NULL,1),(254,1,8,1,12983,1,1,0,'p1i254',800,'COUNTER32',0,0,NULL,1);
/*!40000 ALTER TABLE `device_indicator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_indicator_ext_jmx`
--

DROP TABLE IF EXISTS `device_indicator_ext_jmx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_indicator_ext_jmx` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `indicator_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_indicator.id',
  `attribute` varchar(255) DEFAULT NULL COMMENT 'The JMX Attribute that this indicator is a part of',
  `expression` longtext DEFAULT NULL COMMENT 'If this is not NULL then evaluate the expression and indicator is the result',
  `max_value_expression` longtext DEFAULT NULL COMMENT 'If this is populated it is the maximum value for this indicator',
  PRIMARY KEY (`indicator_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the JMX extensions for Indicators.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_indicator_ext_jmx`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_indicator_ext_jmx` WRITE;
/*!40000 ALTER TABLE `device_indicator_ext_jmx` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_indicator_ext_jmx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_indicator_ext_nbar`
--

DROP TABLE IF EXISTS `device_indicator_ext_nbar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_indicator_ext_nbar` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `indicator_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_indicator.id',
  `oid` varchar(64) NOT NULL COMMENT 'This is the SNMP OID to query at poll time.',
  PRIMARY KEY (`indicator_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the NBAR Plugin''s extension to the Indicator table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_indicator_ext_nbar`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_indicator_ext_nbar` WRITE;
/*!40000 ALTER TABLE `device_indicator_ext_nbar` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_indicator_ext_nbar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_indicator_ext_snmp`
--

DROP TABLE IF EXISTS `device_indicator_ext_snmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_indicator_ext_snmp` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `indicator_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_indicator.id',
  `oid` text NOT NULL COMMENT 'This is the SNMP OID to query at poll time.',
  `oid_high` text DEFAULT NULL COMMENT 'TODO: Document me',
  PRIMARY KEY (`indicator_id`),
  KEY `device_id` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the SNMP Plugin''s extension to the Indicator table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_indicator_ext_snmp`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_indicator_ext_snmp` WRITE;
/*!40000 ALTER TABLE `device_indicator_ext_snmp` DISABLE KEYS */;
INSERT INTO `device_indicator_ext_snmp` VALUES (1,245,'.1.3.6.1.4.1.2021.11.65.0',NULL),(1,246,'.1.3.6.1.4.1.2021.11.56.0',NULL),(1,247,'.1.3.6.1.4.1.2021.11.53.0',NULL),(1,248,'.1.3.6.1.4.1.2021.11.55.0',NULL),(1,249,'.1.3.6.1.4.1.2021.11.51.0',NULL),(1,250,'.1.3.6.1.4.1.2021.11.64.0',NULL),(1,251,'.1.3.6.1.4.1.2021.11.61.0',NULL),(1,252,'.1.3.6.1.4.1.2021.11.52.0',NULL),(1,253,'.1.3.6.1.4.1.2021.11.50.0',NULL),(1,254,'.1.3.6.1.4.1.2021.11.54.0',NULL);
/*!40000 ALTER TABLE `device_indicator_ext_snmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_indicator_ext_vmware`
--

DROP TABLE IF EXISTS `device_indicator_ext_vmware`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_indicator_ext_vmware` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `indicator_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_indicator.id',
  `counter_id` int(11) NOT NULL COMMENT 'This is the VMware counter ID that is used during polling to obtain the value for this Indicator.',
  PRIMARY KEY (`indicator_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the VMware Plugin''s extension to the Indicator table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_indicator_ext_vmware`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_indicator_ext_vmware` WRITE;
/*!40000 ALTER TABLE `device_indicator_ext_vmware` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_indicator_ext_vmware` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_indicator_metadata`
--

DROP TABLE IF EXISTS `device_indicator_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_indicator_metadata` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `indicator_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_indicator.id',
  `first_seen` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'This is the date at which the Indicator was discovered.',
  `last_seen` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'This is the date at which the Indicator was last verified by discovery.',
  `system_is_enabled` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 for if discovery thinks that this should be enabled; 0 otherwise.',
  `override_is_enabled` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 for if a user has manually specified an ''is_enabled'' value.',
  `system_is_baselining` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 for if discovery thinks that this should be collecting baseline data; 0 otherwise.',
  `override_is_baselining` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 for if a user has manually specified an ''is_baselining'' value; 0 otherwise.',
  `system_maximum_value` double DEFAULT NULL COMMENT 'This is the maximum value that discovery has chosen for the Indicator.',
  `override_maximum_value` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 for if a user has manually specified a ''maximum_value''; 0 otherwise.',
  PRIMARY KEY (`indicator_id`),
  KEY `device_id` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table holds extra information about an Indicator.  Things here are not used commonly enough to burden the giant Indicator table with extra information, which would increase its byte size and consume more RAM during queries.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_indicator_metadata`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_indicator_metadata` WRITE;
/*!40000 ALTER TABLE `device_indicator_metadata` DISABLE KEYS */;
INSERT INTO `device_indicator_metadata` VALUES (1,245,'2025-03-12 04:34:17','2026-05-05 04:00:12',1,0,1,0,800,0),(1,246,'2025-03-12 04:34:17','2026-05-05 04:00:12',1,0,1,0,800,0),(1,247,'2025-03-12 04:34:17','2026-05-05 04:00:12',1,0,1,0,800,0),(1,248,'2025-03-12 04:34:17','2026-05-05 04:00:12',1,0,1,0,800,0),(1,249,'2025-03-12 04:34:17','2026-05-05 04:00:12',1,0,1,0,800,0),(1,250,'2025-03-12 04:34:17','2026-05-05 04:00:12',1,0,1,0,800,0),(1,251,'2025-03-12 04:34:17','2026-05-05 04:00:12',1,0,1,0,800,0),(1,252,'2025-03-12 04:34:17','2026-05-05 04:00:12',1,0,1,0,800,0),(1,253,'2025-03-12 04:34:17','2026-05-05 04:00:12',1,0,1,0,800,0),(1,254,'2025-03-12 04:34:17','2026-05-05 04:00:12',1,0,1,0,800,0);
/*!40000 ALTER TABLE `device_indicator_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_indicator_type_map`
--

DROP TABLE IF EXISTS `device_indicator_type_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_indicator_type_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `device_id` int(11) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.deviceinfo.id',
  `plugin_id` int(11) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.plugins.id',
  `plugin_indicator_type_id` int(11) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.plugin_indicator_type.id',
  `is_enabled` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if the Indicator Type is enabled; 0 otherwise.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_tuple` (`device_id`,`plugin_indicator_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=87666 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This maps Indicator Types to individual Devices.  If a Plugin supports this mapping, then this table defines what may be polled by the Device.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_indicator_type_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_indicator_type_map` WRITE;
/*!40000 ALTER TABLE `device_indicator_type_map` DISABLE KEYS */;
INSERT INTO `device_indicator_type_map` VALUES (1,1,1,13023,1),(2,1,1,380,1),(3,1,1,381,1),(4,1,1,382,1),(5,1,1,383,1),(6,1,1,384,1),(7,1,1,2576,1),(8,1,1,2577,1),(9,1,1,2578,1),(10,1,1,2579,1);
/*!40000 ALTER TABLE `device_indicator_type_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object`
--

DROP TABLE IF EXISTS `device_object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `plugin_id` smallint(5) unsigned NOT NULL COMMENT ' foreignKey: net.plugins.id',
  `plugin_object_type_id` int(10) unsigned NOT NULL COMMENT 'This is the Object Type ID of the Indicator. foreignKey: net.plugin_object_type.id',
  `subtype_id` int(10) unsigned DEFAULT NULL COMMENT ' foreignKey: net.objectsubtypes.id',
  `name` varchar(255) NOT NULL COMMENT 'This is the name of the Object; an Object''s name is unique per Device per Plugin.',
  `description` varchar(255) NOT NULL COMMENT 'An Object''s description add some extra information about the Object, but is not required to be unique in any way.',
  `is_enabled` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 if the Object is enabled (that is, polling); 0 otherwise.  Disabled Objects are not counted toward the element count of the Peer.',
  `is_visible` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 if the Object is visible; 0 otherwise.  System-disabled Objects are automatically marked invisible; however, this field may be overridden by users.',
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if the Object is marked for deletion; 0 otherise.  An Object marked for deletion will be completely removed at the next Device discovery.',
  `poll_frequency` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'This is currently not used; we expect to use it in 5.4 to replace the ''kronreal'' database.',
  `table_name` varchar(255) DEFAULT NULL COMMENT 'This is name of the table in the ''pluginlongterm'' database that contains this Object''s historical data.  Historical attempts to determine this value by convention (instead of configuration) have failed due to the ability to move Devices from one Peer to another; too little is globally unique at this point to accomplish this.',
  `is_external` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if the Object is external; 0 otherise. An external objects are the objects created from Deffered data plugin, Universal collector, etc.',
  `alt_name` varchar(255) DEFAULT '' COMMENT 'This is the alternate name of the Object; an Object''s alternate name is not unique in any way.',
  `is_disabled_by_DDQ` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Object status changed by DDQ: -1 if Auto to Disabled; 1 if Enabled to Disabled; 0 otherwise.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_key` (`device_id`,`plugin_id`,`name`),
  KEY `name_ix` (`name`),
  KEY `plugin_id` (`plugin_id`),
  KEY `table_name_ix` (`table_name`)
) ENGINE=InnoDB AUTO_INCREMENT=28885 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the main information about an Object.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object` WRITE;
/*!40000 ALTER TABLE `device_object` DISABLE KEYS */;
INSERT INTO `device_object` VALUES (8,1,1,1579,0,'CPU Total0','CPU Total',1,1,0,0,'d1_psnmp_t1579_o8',0,'',0),(9,1,1,280,0,'/dev/shm','tmpfs',1,1,0,0,'d1_psnmp_t280_o9',0,'',0),(10,1,1,280,0,'/run','tmpfs',1,1,0,0,'d1_psnmp_t280_o10',0,'',0),(11,1,1,280,0,'/sys/fs/cgroup','tmpfs',1,1,0,0,'d1_psnmp_t280_o11',0,'',0),(12,1,1,280,0,'/','/dev/mapper/rhel-root',1,1,0,0,'d1_psnmp_t280_o12',0,'',0),(13,1,1,280,0,'/boot','/dev/vda1',1,1,0,0,'d1_psnmp_t280_o13',0,'',0),(14,1,1,280,0,'/var/lib/containers/storage/overlay','/dev/mapper/rhel-root',1,1,0,0,'d1_psnmp_t280_o14',0,'',0),(17,1,1,280,0,'/var/lib/pst','tmpfs',1,1,0,0,'d1_psnmp_t280_o17',0,'',0),(24,1,1,321,0,'vda','Disk IO',1,1,0,0,'d1_psnmp_t321_o24',0,'',0),(25,1,1,321,0,'vda1','Disk IO',1,1,0,0,'d1_psnmp_t321_o25',0,'',0);
/*!40000 ALTER TABLE `device_object` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_coc`
--

DROP TABLE IF EXISTS `device_object_ext_coc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_coc` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `group_id` int(11) NOT NULL COMMENT ' foreignKey: local.coc_groups.id',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the Cross-Object Calculation Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_coc`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_coc` WRITE;
/*!40000 ALTER TABLE `device_object_ext_coc` DISABLE KEYS */;
INSERT INTO `device_object_ext_coc` VALUES (219,5335,1),(83,26083,2),(219,26457,13),(83,26458,12),(83,26459,10),(4854,26493,14),(4855,26492,15),(4856,26580,16),(4857,26648,17);
/*!40000 ALTER TABLE `device_object_ext_coc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_dns`
--

DROP TABLE IF EXISTS `device_object_ext_dns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_dns` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `domain_name` varchar(255) NOT NULL COMMENT 'This is the domain name to resolve for polling.  This is configured directly by users.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the DNS Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_dns`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_dns` WRITE;
/*!40000 ALTER TABLE `device_object_ext_dns` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_object_ext_dns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_http`
--

DROP TABLE IF EXISTS `device_object_ext_http`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_http` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `clear_on_200` int(11) NOT NULL COMMENT '1 if any alerts generated by this Plugin (not thresholds) should be cleared upon receiving a 200 code; 0 otherwise.',
  `images` int(11) NOT NULL COMMENT '1 if the poller should download any images found on the page; 0 otherwise.',
  `integrity_severity` int(11) NOT NULL COMMENT 'This is the severity (0-8) of any alerts generated by an integrity failure.',
  `range300` int(11) NOT NULL COMMENT '1 if an alert should be generated for a 300-level status code; 0 otherwise.',
  `range400` int(11) NOT NULL COMMENT '1 if an alert should be generated for a 400-level status code; 0 otherwise.',
  `range500` int(11) NOT NULL COMMENT '1 if an alert should be generated for a 500-level status code; 0 otherwise.',
  `accept_cookies` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if this http object accept cookies; 0 otherwise.',
  `url` mediumtext NOT NULL COMMENT 'This is the URL to fetch at polling time.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the HTTP Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_http`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_http` WRITE;
/*!40000 ALTER TABLE `device_object_ext_http` DISABLE KEYS */;
INSERT INTO `device_object_ext_http` VALUES (50,855,0,1,127,4,3,2,1,'https://9.42.110.15:26516'),(70,1286,0,1,127,4,3,2,1,'https://9.42.110.15:26516'),(62,881,0,1,127,4,3,2,1,'https://10.52.0.96'),(87,2718,0,1,127,4,3,2,1,'https://9.42.110.15:26588'),(90,2721,0,1,127,4,3,2,1,'https://9.42.110.15:26588');
/*!40000 ALTER TABLE `device_object_ext_http` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_icmp`
--

DROP TABLE IF EXISTS `device_object_ext_icmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_icmp` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `custom` int(11) NOT NULL COMMENT '1 if this was created by a user; 0 if this was created by the system to match the management address of the Device.  Non-custom entries cannot be deleted or modified.',
  `ip` varbinary(40) NOT NULL COMMENT 'The IPv4 or IPv6 address to ping.',
  `packet_interval` int(11) NOT NULL COMMENT 'The interval, in milliseconds, between pings.',
  `packet_number` int(11) NOT NULL COMMENT 'The number of pings to send.',
  `packet_size` int(11) NOT NULL COMMENT 'The size, in bytes, of each ping.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the ICMP Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_icmp`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_icmp` WRITE;
/*!40000 ALTER TABLE `device_object_ext_icmp` DISABLE KEYS */;
INSERT INTO `device_object_ext_icmp` VALUES (5,253,0,'00000000',0,5,64),(50,854,0,'00000000',0,5,64),(62,880,0,'',0,5,64),(64,882,0,'0A340060',0,5,56),(65,883,0,'0A340811',0,5,56),(69,884,0,'0A340065',0,5,64),(67,960,0,'0A340063',0,5,56),(68,961,0,'0A340064',0,5,56),(66,1047,0,'0A340061',0,5,56),(70,1285,0,'',0,5,64);
/*!40000 ALTER TABLE `device_object_ext_icmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_ipsla`
--

DROP TABLE IF EXISTS `device_object_ext_ipsla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_ipsla` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `cache` tinyint(4) NOT NULL COMMENT 'For HTTP tests, this is whether or not to allow a cached result.',
  `called_number` varchar(32) NOT NULL COMMENT 'For VoIP tests, this is the number to dial.',
  `codec_type` tinyint(4) NOT NULL COMMENT 'For UDP Jitter tests, this is the codec to use.',
  `cos` tinyint(3) unsigned NOT NULL COMMENT 'For Ethernet tests, this is Class of Service.',
  `detect_point` tinyint(4) NOT NULL COMMENT 'For VoIP tests, this specifies whether the test is a ring-the-phone or connect-the-call test.  Note: this may be moved to an enumeration.',
  `domain_name` varchar(255) NOT NULL COMMENT 'For Ethernet tests, this is the Ethernet domain name (do not confuse this with a DNS domain name).',
  `duration` int(11) NOT NULL COMMENT 'For Video tests, this is how long the video should stream (in seconds).',
  `frequency` int(11) NOT NULL COMMENT 'The interval between test runs, in seconds.',
  `http_version` varchar(32) NOT NULL COMMENT 'For HTTP tests, this is the HTTP version to use; Cisco has hinted at these possible values: 0.9, 1.0, 1.1.  Note: this may be moved to an enumeration.',
  `is_sevone` tinyint(4) NOT NULL COMMENT '1 if this test was created though SevOne NMS; 0 if we found it on the device during dicovery.',
  `mode` tinyint(4) NOT NULL COMMENT 'For FTP tests, this determines whether the test is active or passive.  Note: this may be moved to an enumeration.',
  `mpid` int(10) unsigned NOT NULL COMMENT 'For Ethernet tests, this specifies the MPID.',
  `name_server_ip` varbinary(40) NOT NULL COMMENT 'For HTTP and DNS tests, this is the IP address of the nameserver.',
  `operation` tinyint(4) NOT NULL COMMENT 'For HTTP tests, this determines whether the test is normal or ''raw''; for FTP tests, this is ''ftpGet''.  Note: this may be moved to an enumeration.',
  `override_target_device_id` tinyint(4) NOT NULL COMMENT '1 if the ''target_device_id'' is set by a user; 0 otherwise. foreignKey: net.deviceinfo.id',
  `owner` varchar(255) NOT NULL COMMENT 'This is the ''owner'' of a test.  For SevOne-NMS-created tests, this will be generated by Device discovery.  Otherwise, it comes from the test itself.',
  `packet_interval` int(11) NOT NULL COMMENT 'For UDP Jitter, ICMP Jitter, and Ethernet Jitter tests, this is the interval between packets.',
  `packet_number` int(11) NOT NULL COMMENT 'For UDP Jitter, ICMP Jitter, and Ethernet Jitter tests, this is the number of packets.',
  `probe_precision` tinyint(4) NOT NULL COMMENT 'For UDP Jitter, this determines whether the results are in milliseconds or microseconds.  Note: this may be moved to an enumeration.',
  `proxy` varchar(128) NOT NULL COMMENT 'For HTTP tests, this is the proxy server to use (if any).',
  `snmp_object_id` int(11) NOT NULL COMMENT 'This is the discovered SNMP index of the test.',
  `source_ip` varbinary(40) NOT NULL COMMENT 'This is the IP address from which to source the test.',
  `source_port` int(11) NOT NULL COMMENT 'This is the port from which to source the test.',
  `string1` varchar(255) NOT NULL COMMENT 'Arbitrary string #1.  Used for raw HTTP tests and Option-82 DHCP tests.',
  `string2` varchar(255) NOT NULL COMMENT 'Arbitrary string #2.  Used for HTTP tests.',
  `string3` varchar(255) NOT NULL COMMENT 'Arbitrary string #3.  Used for HTTP tests.',
  `string4` varchar(255) NOT NULL COMMENT 'Arbitrary string #4.  Used for HTTP tests.',
  `string5` varchar(255) NOT NULL COMMENT 'Arbitrary string #5.  Used for HTTP tests.',
  `system_target_device_id` int(11) NOT NULL COMMENT 'This is the ID of the Device that SevOne NMS thinks is the target of the test. foreignKey: net.deviceinfo.id',
  `tag` varchar(255) NOT NULL COMMENT 'This is the ''tag'' of a test.  For SevOne-NMS-created tests, this will be generated by Device discovery.  Otherwise, it comes from the test itself.',
  `target_device_id` int(11) NOT NULL COMMENT 'This is the ID of the Device that represents the target of the test. foreignKey: net.deviceinfo.id',
  `target_evc` varchar(100) NOT NULL COMMENT 'For Ethernet tests, this is the target EVC.',
  `target_ip` varbinary(40) NOT NULL COMMENT 'This is the target IP address for the test.',
  `target_port` int(11) NOT NULL COMMENT 'This is the target port for the test.',
  `target_url` varchar(128) NOT NULL COMMENT 'For HTTP and FTP tests, this is the target URL.  For DNS, this is the domain name to resolve.',
  `target_vlan` int(10) unsigned NOT NULL COMMENT 'For Ethernet tests, this is the target VLAN.',
  `tos` int(11) NOT NULL COMMENT 'For IP tests, this is the Type of Service to use.',
  `video_traffic_profile` varchar(255) NOT NULL COMMENT 'For Video tests, this is the profile to use.',
  `source_voice_port` varchar(255) DEFAULT NULL COMMENT 'For RTP tests, this is the source voice port to use.',
  `icpif_adv_factor` smallint(6) DEFAULT NULL COMMENT 'For RTP tests, this is the ICPIF Factor to use.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the IP SLA Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_ipsla`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_ipsla` WRITE;
/*!40000 ALTER TABLE `device_object_ext_ipsla` DISABLE KEYS */;
INSERT INTO `device_object_ext_ipsla` VALUES (213,4522,0,'',0,0,0,'',0,3,'',0,0,0,'',0,0,'',0,0,0,'',1,'00000000',0,'','','','','',205,'LAB-898-IP-SLA-Tag',205,'','08080808',0,'',0,0,'','',0),(234,5058,0,'',0,0,0,'',0,3,'',0,0,0,'',0,0,'',0,0,0,'',1,'00000000',0,'','','','','',205,'LAB-898-IP-SLA-Tag',205,'','08080808',0,'',0,0,'','',0);
/*!40000 ALTER TABLE `device_object_ext_ipsla` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_jmx`
--

DROP TABLE IF EXISTS `device_object_ext_jmx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_jmx` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `jmx_name` varchar(2048) NOT NULL COMMENT 'This is the JMX identification string for the Object.',
  `index_expression` longtext DEFAULT NULL COMMENT 'This is the expression used to get this object',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the JMX Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_jmx`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_jmx` WRITE;
/*!40000 ALTER TABLE `device_object_ext_jmx` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_object_ext_jmx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_mysqldb`
--

DROP TABLE IF EXISTS `device_object_ext_mysqldb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_mysqldb` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `database_id` int(11) NOT NULL COMMENT ' foreignKey: local.device_database.id',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the MySQL Database Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_mysqldb`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_mysqldb` WRITE;
/*!40000 ALTER TABLE `device_object_ext_mysqldb` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_object_ext_mysqldb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_nbar`
--

DROP TABLE IF EXISTS `device_object_ext_nbar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_nbar` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `snmp_object_id` int(11) NOT NULL COMMENT 'This is the SNMP index for the Object.  This is essentially the ''ifIndex'' value.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the NBAR Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_nbar`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_nbar` WRITE;
/*!40000 ALTER TABLE `device_object_ext_nbar` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_object_ext_nbar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_oracledb`
--

DROP TABLE IF EXISTS `device_object_ext_oracledb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_oracledb` (
  `device_id` int(10) unsigned NOT NULL COMMENT 'Foreign key to net.deviceinfo foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT 'Foreign Key to local.device_object foreignKey: local.device_object.id',
  `database_id` int(11) NOT NULL COMMENT 'Database ID',
  `scope` enum('global','tablespace') DEFAULT 'global' COMMENT 'Scope',
  `identifier` varchar(64) DEFAULT '' COMMENT 'Identifier',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='The extentiaon table for the oracledb poller';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_oracledb`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_oracledb` WRITE;
/*!40000 ALTER TABLE `device_object_ext_oracledb` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_object_ext_oracledb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_portshaker`
--

DROP TABLE IF EXISTS `device_object_ext_portshaker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_portshaker` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `port` varchar(255) NOT NULL COMMENT 'This is the TCP port number to test.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the Port Shaker Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_portshaker`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_portshaker` WRITE;
/*!40000 ALTER TABLE `device_object_ext_portshaker` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_object_ext_portshaker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_proxyping`
--

DROP TABLE IF EXISTS `device_object_ext_proxyping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_proxyping` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `ip` varchar(255) NOT NULL COMMENT 'This is the IP address to which to connect.',
  `override_target_device_id` tinyint(4) NOT NULL COMMENT '1 if the ''target_device_id'' field is set by a user; 0 otherwise. foreignKey: net.deviceinfo.id',
  `packet_number` int(11) NOT NULL COMMENT 'ZOMG: THIS IS NOT USED.',
  `packet_size` int(11) NOT NULL COMMENT 'ZOMG: THIS IS NOT USED.',
  `system_target_device_id` int(11) NOT NULL COMMENT 'This is the ID of the Device that the system thinks this Object refers to. foreignKey: net.deviceinfo.id',
  `target_device_id` int(11) NOT NULL COMMENT 'This is the ID of the Device that this Object refers to. foreignKey: net.deviceinfo.id',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the Proxy Ping Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_proxyping`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_proxyping` WRITE;
/*!40000 ALTER TABLE `device_object_ext_proxyping` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_object_ext_proxyping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_snmp`
--

DROP TABLE IF EXISTS `device_object_ext_snmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_snmp` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `admin_status_expression` varchar(255) NOT NULL COMMENT 'This is the S3 expression to evaluate to determine the administrative status of the Object.  1 is enabled; 2 is disabled.',
  `ip_address` varbinary(40) NOT NULL COMMENT 'This is the IP address of the Object.  This is only populated for IF-MIB interfaces, and it is only IPv4.',
  `is_interface` smallint(6) NOT NULL COMMENT '1 if this is an ''interface'', whatever that means; 0 otherwise.  Interfaces are candidates for NetFlow mapping.',
  `last_change_oid` varchar(255) NOT NULL COMMENT 'This is the OID to check at polling time to determine if the state of the Object has changed.',
  `netmask` varbinary(40) NOT NULL COMMENT 'This is the netmask of the Object.  This is only populated for IF-MIB interfaces, and it is only IPv4.',
  `oper_status_expression` varchar(255) NOT NULL COMMENT 'This is the S3 expression to evaluate to determine the operational status of the Object.  1 is enabled; 2 is disabled.',
  `snmp_object_id` varchar(255) NOT NULL COMMENT 'This is the SNMP index for the Object.  This is determined by walking the Index OID for the Object Type.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the SNMP Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_snmp`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_snmp` WRITE;
/*!40000 ALTER TABLE `device_object_ext_snmp` DISABLE KEYS */;
INSERT INTO `device_object_ext_snmp` VALUES (1,8,'','',0,'','','','0'),(1,9,'','',0,'','','','5'),(1,10,'','',0,'','','','7'),(1,11,'','',0,'','','','8'),(1,12,'','',0,'','','','25'),(1,13,'','',0,'','','','32'),(1,14,'','',0,'','','','34'),(1,17,'','',0,'','','','33'),(1,24,'','',0,'','','','1'),(1,25,'','',0,'','','','2');
/*!40000 ALTER TABLE `device_object_ext_snmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_vmware`
--

DROP TABLE IF EXISTS `device_object_ext_vmware`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_vmware` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `instance` varchar(255) NOT NULL DEFAULT '' COMMENT 'This is the VMware identifier for the Object.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the VMware Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_vmware`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_vmware` WRITE;
/*!40000 ALTER TABLE `device_object_ext_vmware` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_object_ext_vmware` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_webstatus`
--

DROP TABLE IF EXISTS `device_object_ext_webstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_webstatus` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `url` varchar(255) NOT NULL COMMENT 'This is the URL to fetch and parse at polling time.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the Telephony Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_webstatus`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_webstatus` WRITE;
/*!40000 ALTER TABLE `device_object_ext_webstatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_object_ext_webstatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_ext_wmi`
--

DROP TABLE IF EXISTS `device_object_ext_wmi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_ext_wmi` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `instance_name` varchar(255) NOT NULL COMMENT 'This is the name of the instance for the Object; an Object represents a particular instance of a WMI class.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the Telephony Plugin''s Object extension table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_ext_wmi`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_ext_wmi` WRITE;
/*!40000 ALTER TABLE `device_object_ext_wmi` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_object_ext_wmi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_group_map`
--

DROP TABLE IF EXISTS `device_object_group_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_group_map` (
  `id` bigint(64) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `device_id` int(11) NOT NULL COMMENT 'The Device for the Object. foreignKey: net.deviceinfo.id',
  `plugin_id` int(11) DEFAULT NULL COMMENT 'The Plugin for the Object (note that this is no longer necessary). foreignKey: net.plugins.id',
  `object_id` int(11) DEFAULT NULL COMMENT 'The Object to map to the Object Group. foreignKey: local.device_object.id',
  `group_id` int(11) NOT NULL COMMENT 'The Object Group to which this Object now belongs. foreignKey: net.objectgroupinfo.id',
  `automatic` tinyint(4) DEFAULT NULL COMMENT '1 if this mapping was generated by the system; 0 if it was done by a user.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_object` (`device_id`,`plugin_id`,`object_id`,`group_id`),
  KEY `group_id` (`group_id`),
  KEY `id_and_plugin` (`id`,`plugin_id`),
  KEY `object_id` (`object_id`),
  KEY `plugin_id` (`plugin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28172 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This maps an Object to an Object Group.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_group_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_group_map` WRITE;
/*!40000 ALTER TABLE `device_object_group_map` DISABLE KEYS */;
INSERT INTO `device_object_group_map` VALUES (1,1,1,8,83,1),(2,1,1,31,94,1),(3,1,1,52,10,1),(4,1,1,53,7,1),(5,1,1,54,7,1),(45,4,1,197,83,1),(46,4,1,220,94,1),(51,4,1,245,10,1),(52,4,1,246,7,1),(53,4,1,247,7,1);
/*!40000 ALTER TABLE `device_object_group_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_object_metadata`
--

DROP TABLE IF EXISTS `device_object_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_object_metadata` (
  `device_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `first_seen` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'This is the date at which the Object was added to the system.',
  `last_seen` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'This is the date at which the Object was last seen by Device discovery.',
  `system_description` varchar(255) NOT NULL COMMENT 'This is the value for ''description'' that the system wants to use.',
  `override_description` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if a user has provided his own ''description'' value; 0 otherwise.',
  `system_is_enabled` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'This is the value for ''is_enabled'' that the system wants to use.',
  `override_is_enabled` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if a user has provided his own ''is_enabled'' value; 0 otherwise.',
  `system_is_visible` tinyint(4) DEFAULT 1 COMMENT 'This is the value for ''is_visible'' that the system wants to use.',
  `override_is_visible` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if a user has provided his own ''is_visible'' value; 0 otherwise.',
  `rule_id` int(11) NOT NULL DEFAULT -2 COMMENT 'This will store the net.object_rules.id that is applied to the object.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This contains additional, more system-oriented information about an Object.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_object_metadata`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_object_metadata` WRITE;
/*!40000 ALTER TABLE `device_object_metadata` DISABLE KEYS */;
INSERT INTO `device_object_metadata` VALUES (1,8,'2025-03-12 04:34:17','2026-05-05 04:00:12','CPU Total',0,1,0,1,0,-2),(1,9,'2025-03-12 04:34:17','2026-05-05 04:00:12','tmpfs',0,1,0,1,0,-2),(1,10,'2025-03-12 04:34:17','2026-05-05 04:00:12','tmpfs',0,1,0,1,0,-2),(1,11,'2025-03-12 04:34:18','2026-05-05 04:00:12','tmpfs',0,1,0,1,0,-2),(1,12,'2025-03-12 04:34:18','2026-05-05 04:00:12','/dev/mapper/rhel-root',0,1,0,1,0,-2),(1,13,'2025-03-12 04:34:18','2026-05-05 04:00:12','/dev/vda1',0,1,0,1,0,-2),(1,14,'2025-03-12 04:34:18','2026-05-05 04:00:12','/dev/mapper/rhel-root',0,1,0,1,0,-2),(1,17,'2025-03-12 04:34:18','2026-05-05 04:00:12','tmpfs',0,1,0,1,0,-2),(1,24,'2025-03-12 04:34:19','2026-05-05 04:00:12','Disk IO',0,1,0,1,0,-2),(1,25,'2025-03-12 04:34:19','2026-05-05 04:00:12','Disk IO',0,1,0,1,0,-2);
/*!40000 ALTER TABLE `device_object_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_relationships`
--

DROP TABLE IF EXISTS `device_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_relationships` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `a_device_id` int(11) NOT NULL COMMENT 'First device of the relationship foreignKey: net.deviceinfo.id',
  `z_device_id` int(11) DEFAULT NULL COMMENT 'Second device of the relationship foreignKey: net.deviceinfo.id',
  `relationship_type` int(11) NOT NULL DEFAULT 1 COMMENT 'the relationship type foreignKey: net.topology_relationship_types.id',
  `date_started` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Date when the relationship is discovered',
  `date_ended` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Date when the relationship is found as ended',
  `is_automatic` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Is automatically created',
  `is_discovered` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Is discovered by discovery engine',
  `a_object_id` int(11) DEFAULT NULL COMMENT 'Connection point object of the first device foreignKey: local.device_object.id',
  `conn_id` bigint(20) NOT NULL COMMENT 'bitwise combination of peerid and id of owner',
  `source` int(11) NOT NULL COMMENT 'The source of the link (relationship) created foreignKey: net.topology_sources.id',
  PRIMARY KEY (`id`),
  KEY `conn_id` (`conn_id`),
  KEY `date_ended` (`date_ended`),
  KEY `date_started` (`date_started`),
  KEY `fk_a_device_id` (`a_device_id`),
  KEY `fk_a_object_id` (`a_object_id`),
  KEY `fk_relationship_type` (`relationship_type`),
  KEY `source` (`source`),
  KEY `z_device_id` (`z_device_id`)
) ENGINE=MyISAM AUTO_INCREMENT=454 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines Topology relationship between devices.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_relationships`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_relationships` WRITE;
/*!40000 ALTER TABLE `device_relationships` DISABLE KEYS */;
INSERT INTO `device_relationships` VALUES (142,83,86,5,'2026-03-09 06:10:33','0000-00-00 00:00:00',1,1,2256,4294967438,1),(143,82,81,5,'2026-03-09 07:05:43','0000-00-00 00:00:00',1,1,2491,4294967439,1),(144,86,83,5,'2026-03-09 06:10:33','0000-00-00 00:00:00',1,1,1943,4294967438,1),(145,82,86,5,'2025-03-26 04:41:48','2025-05-09 05:15:49',1,1,2489,4294967441,1),(146,81,86,5,'2025-03-26 04:43:04','2025-05-09 04:40:30',1,1,1706,4294967442,1),(147,81,82,5,'2026-03-09 07:05:43','0000-00-00 00:00:00',1,1,1708,4294967439,1),(148,86,82,5,'2025-03-26 05:11:39','2025-05-09 05:15:49',1,1,1945,4294967441,1),(149,82,73,5,'2025-03-29 04:35:59','2025-05-11 04:38:05',1,1,2493,4294967445,1),(150,96,95,5,'2025-04-04 05:07:32','0000-00-00 00:00:00',1,1,2730,4294967446,1),(151,96,95,5,'2025-04-04 05:07:32','0000-00-00 00:00:00',1,1,2731,4294967447,1);
/*!40000 ALTER TABLE `device_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_relationships_history`
--

DROP TABLE IF EXISTS `device_relationships_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `device_relationships_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `date_started` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Date when the relationship is discovered',
  `date_ended` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Date when the relationship is found as ended',
  `conn_id` bigint(20) NOT NULL COMMENT 'bitwise combination of peerid and id of owner',
  PRIMARY KEY (`id`),
  KEY `conn_id_key` (`conn_id`)
) ENGINE=MyISAM AUTO_INCREMENT=626 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines Topology relationship history between devices.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_relationships_history`
--
-- WHERE:  1 limit 10

LOCK TABLES `device_relationships_history` WRITE;
/*!40000 ALTER TABLE `device_relationships_history` DISABLE KEYS */;
INSERT INTO `device_relationships_history` VALUES (1,'2025-04-10 05:12:10','2025-05-11 04:48:57',4294967459),(2,'2025-03-24 15:08:07','2025-05-09 05:15:49',4294967438),(3,'2025-06-02 06:33:41','2025-06-02 06:34:39',4294967557),(4,'2025-06-03 05:55:10','2025-06-03 05:56:47',4294967557),(5,'2025-06-04 05:20:11','2025-06-04 05:21:56',4294967557),(6,'2025-06-05 05:32:11','2025-06-05 05:34:20',4294967557),(7,'2025-06-06 05:11:26','2025-06-06 05:13:13',4294967557),(8,'2025-06-07 05:35:02','2025-06-07 05:37:16',4294967557),(9,'2025-06-08 07:36:20','2025-06-08 07:38:28',4294967557),(10,'2025-06-09 05:35:21','2025-06-09 05:37:29',4294967557);
/*!40000 ALTER TABLE `device_relationships_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devicemove_log`
--

DROP TABLE IF EXISTS `devicemove_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `devicemove_log` (
  `dev_id` int(11) DEFAULT NULL COMMENT 'The ID of the device being moved. foreignKey: net.deviceinfo.id',
  `chunk_tag` varchar(255) DEFAULT NULL COMMENT 'Tag indicating chunk that is being moved.',
  `sequence_num` int(11) DEFAULT 0 COMMENT 'Order of command/query in the chunk being moved.',
  `hash` varchar(255) DEFAULT '' COMMENT 'MD5 hash of command/query that was run.',
  `return_id` varchar(255) DEFAULT '' COMMENT 'Return ID of command/query that was run.',
  `is_complete` tinyint(4) DEFAULT 0 COMMENT 'Completeness of command/query that was run; DEPRACATED (asamuel)',
  UNIQUE KEY `dev_chunk_sequence` (`dev_id`,`chunk_tag`,`sequence_num`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Table used for journaling a device move in the case of error or interruption.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devicemove_log`
--
-- WHERE:  1 limit 10

LOCK TABLES `devicemove_log` WRITE;
/*!40000 ALTER TABLE `devicemove_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `devicemove_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discover_schedule`
--

DROP TABLE IF EXISTS `discover_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `discover_schedule` (
  `monday` int(11) DEFAULT NULL COMMENT '1 if this entry applies to Mondays; 0 otherwise.',
  `tuesday` int(11) DEFAULT NULL COMMENT '1 if this entry applies to Tuesdays; 0 otherwise.',
  `wednesday` int(11) DEFAULT NULL COMMENT '1 if this entry applies to Wednesdays; 0 otherwise.',
  `thursday` int(11) DEFAULT NULL COMMENT '1 if this entry applies to Thursdays; 0 otherwise.',
  `friday` int(11) DEFAULT NULL COMMENT '1 if this entry applies to Fridays; 0 otherwise.',
  `saturday` int(11) DEFAULT NULL COMMENT '1 if this entry applies to Saturdays; 0 otherwise.',
  `sunday` int(11) DEFAULT NULL COMMENT '1 if this entry applies to Sundays; 0 otherwise.',
  `hour` int(11) DEFAULT NULL COMMENT 'The hour of the day for discovery (0-23).',
  `minute` int(11) DEFAULT NULL COMMENT 'The minute of hour for discovery (0-59).',
  `time_zone` varchar(255) DEFAULT 'utc' COMMENT 'The timezone that this entry applies to.'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines when a Peer may issue rediscovery requests.  The may be EXACTLY ONE entry in this table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discover_schedule`
--
-- WHERE:  1 limit 10

LOCK TABLES `discover_schedule` WRITE;
/*!40000 ALTER TABLE `discover_schedule` DISABLE KEYS */;
INSERT INTO `discover_schedule` VALUES (1,1,1,1,1,1,1,0,0,'America/New_York');
/*!40000 ALTER TABLE `discover_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discovery_status`
--

DROP TABLE IF EXISTS `discovery_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `discovery_status` (
  `core_pid` int(11) DEFAULT 0 COMMENT 'This is the SevOne-discover-devices PID that spawned the process that is currently discovering the Device.',
  `thread_pid` int(11) DEFAULT 0 COMMENT 'This is the PID of the actual process that is currently discovering the Device.',
  `device_id` int(11) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.deviceinfo.id',
  `queue` enum('','high','low') NOT NULL DEFAULT '' COMMENT 'This is the queue in which the Device was placed.  If this is not set, then the Device was discovered manually.',
  `action` enum('','delete','discover') NOT NULL DEFAULT '' COMMENT 'This is what the discovery process is currently doing to the Device: either discovering it, or deleting it.',
  `time_started` int(11) DEFAULT 0 COMMENT 'This is the timestamp at which the discovery started (epoch).',
  PRIMARY KEY (`device_id`),
  KEY `queue` (`queue`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the information about the current discovery of Devices.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discovery_status`
--
-- WHERE:  1 limit 10

LOCK TABLES `discovery_status` WRITE;
/*!40000 ALTER TABLE `discovery_status` DISABLE KEYS */;
INSERT INTO `discovery_status` VALUES (2226680,2245185,84,'low','discover',1777955907);
/*!40000 ALTER TABLE `discovery_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flowfalconaggregationtemplate`
--

DROP TABLE IF EXISTS `flowfalconaggregationtemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flowfalconaggregationtemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `view_id` int(11) DEFAULT 0 COMMENT ' foreignKey: net.flowfalconview.id',
  `origin_ip` varbinary(40) DEFAULT '' COMMENT 'Part of the direction tuple',
  `interface` int(10) unsigned DEFAULT NULL COMMENT 'Part of the direction tuple',
  `direction` int(11) DEFAULT 0 COMMENT 'Part of the direction tuple',
  `datatable` varchar(128) DEFAULT '' COMMENT 'This is the name of the datatable in the netflow database.  This is analogous to how object longterm tables are stored',
  PRIMARY KEY (`id`),
  UNIQUE KEY `template_key` (`view_id`,`origin_ip`,`interface`,`direction`),
  KEY `device_key` (`origin_ip`,`interface`,`direction`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This maps netflow direction tuples to aggregated flow falcon templates.  It also stores the base name of the tables in the netflow database.  The table is a function of the ip address, the template id, and aggregation time span.  This is a candidate to clean up with a foreign key to net.netflowdirection.id' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flowfalconaggregationtemplate`
--
-- WHERE:  1 limit 10

LOCK TABLES `flowfalconaggregationtemplate` WRITE;
/*!40000 ALTER TABLE `flowfalconaggregationtemplate` DISABLE KEYS */;
INSERT INTO `flowfalconaggregationtemplate` VALUES (1,32,'092B6423',0,1,''),(2,46,'092B6423',0,1,''),(3,48,'092B6423',0,1,''),(4,53,'092B6423',0,1,''),(5,62,'092B6423',0,1,''),(6,68,'092B6423',0,1,''),(7,69,'092B6423',0,1,''),(8,78,'092B6423',0,1,''),(9,32,'092B6423',0,2,''),(10,46,'092B6423',0,2,'');
/*!40000 ALTER TABLE `flowfalconaggregationtemplate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flowng_observed_paths`
--

DROP TABLE IF EXISTS `flowng_observed_paths`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flowng_observed_paths` (
  `tracking_uuid` binary(16) NOT NULL,
  `element_value0` varchar(64) NOT NULL DEFAULT '',
  `element_value1` varchar(64) NOT NULL DEFAULT '',
  `element_value2` varchar(64) NOT NULL DEFAULT '',
  `element_value3` varchar(64) NOT NULL DEFAULT '',
  `element_value4` varchar(64) NOT NULL DEFAULT '',
  `most_recent_end_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`tracking_uuid`,`element_value0`,`element_value1`,`element_value2`,`element_value3`,`element_value4`),
  KEY `end_time` (`most_recent_end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='The flowng observed tracking paths';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flowng_observed_paths`
--
-- WHERE:  1 limit 10

LOCK TABLES `flowng_observed_paths` WRITE;
/*!40000 ALTER TABLE `flowng_observed_paths` DISABLE KEYS */;
/*!40000 ALTER TABLE `flowng_observed_paths` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `highpoller_absolutetime`
--

DROP TABLE IF EXISTS `highpoller_absolutetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `highpoller_absolutetime` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `device_id` int(11) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `kron_id` int(11) NOT NULL COMMENT ' foreignKey: kronreal.kron.id',
  `start_time` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the start time of this entry.  For what this entry does, see ''on_off''.',
  `end_time` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the end time of this entry.  For what this entry does, see ''on_off''.',
  `on_off` int(11) NOT NULL DEFAULT 0 COMMENT '1 if polling should be enabled during the timespan in this entry; 0 if it should be disabled.',
  `time_zone` varchar(255) DEFAULT 'UTC' COMMENT 'The timezone in which these times apply.  ZOMG IS THIS AT ALL NEEDED?',
  PRIMARY KEY (`id`),
  KEY `device_and_kron` (`device_id`,`kron_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores scheduling information for the High-frequency poller.  This table is concerned with absolutely-scheduled entries.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `highpoller_absolutetime`
--
-- WHERE:  1 limit 10

LOCK TABLES `highpoller_absolutetime` WRITE;
/*!40000 ALTER TABLE `highpoller_absolutetime` DISABLE KEYS */;
/*!40000 ALTER TABLE `highpoller_absolutetime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `highpoller_relativetime`
--

DROP TABLE IF EXISTS `highpoller_relativetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `highpoller_relativetime` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `device_id` int(11) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `kron_id` int(11) NOT NULL COMMENT ' foreignKey: kronreal.kron.id',
  `monday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Mondays; 0 otherwise.',
  `tuesday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Tuesdays; 0 otherwise.',
  `wednesday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Wednesdays; 0 otherwise.',
  `thursday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Thursdays; 0 otherwise.',
  `friday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Fridays; 0 otherwise. Gotta get down on Friday.',
  `saturday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Saturdays; 0 otherwise.',
  `sunday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Sundays; 0 otherwise.',
  `start_hr` int(11) NOT NULL DEFAULT 0 COMMENT 'The hour number (0-24) at which this entry begins.  Yes, both 0 and 24 are possible.',
  `start_min` int(11) NOT NULL DEFAULT 0 COMMENT 'The minute number (0-59) at which this entry begins.',
  `end_hr` int(11) NOT NULL DEFAULT 0 COMMENT 'The hour number (0-24) at which this entry ends.  Yes, both 0 and 24 are possible.',
  `end_min` int(11) NOT NULL DEFAULT 0 COMMENT 'The minute number (0-59) at which this entry ends.',
  `time_zone` varchar(255) DEFAULT 'UTC' COMMENT 'The timezone in which these times apply.  ZOMG IS THIS AT ALL NEEDED?',
  `on_off` int(11) DEFAULT 0 COMMENT '1 if polling should be enabled during the timespan in this entry; 0 if it should be disabled.',
  PRIMARY KEY (`id`),
  KEY `device_and_kron` (`device_id`,`kron_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores scheduling information for the High-frequency poller.  This table is concerned with recurring entries.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `highpoller_relativetime`
--
-- WHERE:  1 limit 10

LOCK TABLES `highpoller_relativetime` WRITE;
/*!40000 ALTER TABLE `highpoller_relativetime` DISABLE KEYS */;
/*!40000 ALTER TABLE `highpoller_relativetime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `http_object_expression`
--

DROP TABLE IF EXISTS `http_object_expression`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `http_object_expression` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `device_id` int(11) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.deviceinfo.id',
  `object_id` int(11) NOT NULL DEFAULT -1 COMMENT ' foreignKey: local.device_object.id',
  `name` varchar(128) DEFAULT NULL COMMENT 'This is the name of the rule (or expression).',
  `expression` varchar(255) DEFAULT NULL COMMENT 'This is the expression to check.  This is a crappy POSIX-style ''regex_t'' kind of regular expression.',
  `must_match` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 if a match is expected; 0 if one is not expected.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_tuple` (`object_id`,`name`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='HTTP ''expressions'' are per-Object assertions that are checked at poll time.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `http_object_expression`
--
-- WHERE:  1 limit 10

LOCK TABLES `http_object_expression` WRITE;
/*!40000 ALTER TABLE `http_object_expression` DISABLE KEYS */;
/*!40000 ALTER TABLE `http_object_expression` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `license_info`
--

DROP TABLE IF EXISTS `license_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `license_info` (
  `customer_id` int(11) DEFAULT NULL COMMENT 'Customer ID',
  `first_name` varchar(256) DEFAULT NULL COMMENT 'customer given name',
  `last_name` varchar(256) DEFAULT NULL COMMENT 'customer surname',
  `email` varchar(256) DEFAULT NULL COMMENT 'customer email',
  `company` varchar(256) DEFAULT NULL COMMENT 'Company name',
  `creation_date` int(11) DEFAULT NULL COMMENT 'creation date in unix timestamp',
  `expiration_date` int(11) DEFAULT NULL COMMENT 'expiration date in unix timestamp',
  `end_license_date` int(11) DEFAULT NULL COMMENT 'end license date in unix timestamp',
  `grace_period` int(11) DEFAULT NULL COMMENT 'grace period in days',
  `unlimited_license` int(11) DEFAULT NULL COMMENT 'shows license is unlimited or not',
  `license_id` int(11) DEFAULT NULL COMMENT 'License ID',
  `license_number` varchar(256) DEFAULT NULL COMMENT 'license number',
  `serial_number` int(11) DEFAULT NULL COMMENT 'Serial Number',
  `appliance_type` varchar(256) DEFAULT NULL COMMENT 'Type of an appliance',
  `customer_type` varchar(256) DEFAULT NULL COMMENT 'Customer type',
  `peering` int(1) DEFAULT NULL COMMENT 'peering enabled or not',
  `hsa` int(1) DEFAULT NULL COMMENT 'hsa enabled or not',
  `sdb` int(1) DEFAULT NULL COMMENT 'sdb enabled or not',
  `netflow_limit` int(11) DEFAULT NULL COMMENT 'netflow limit',
  `objects` int(11) NOT NULL COMMENT 'objects limit',
  `interfaces` int(11) NOT NULL COMMENT 'interfaces limit',
  `is_primary` tinyint(1) NOT NULL COMMENT 'indicate if the appliance is primary or secondary'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains SevOne license info';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `license_info`
--
-- WHERE:  1 limit 10

LOCK TABLES `license_info` WRITE;
/*!40000 ALTER TABLE `license_info` DISABLE KEYS */;
INSERT INTO `license_info` VALUES (0,'','','','',1473275559,1924972200,1924972200,0,1,0,'',1,'PAS','Enterprise',1,1,1,4500,5000,15,1);
/*!40000 ALTER TABLE `license_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metadata_map`
--

DROP TABLE IF EXISTS `metadata_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `metadata_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `attribute_id` int(11) NOT NULL COMMENT 'attribute_id foreignKey: net.metadata_attribute.id',
  `entity_type` enum('device','object') NOT NULL COMMENT 'The entity type to which this value is mapped',
  `entity_id` int(11) NOT NULL COMMENT 'The ID of the entity to which this value is mapped. This is a foreign key but the key does not directly point to a specific table but points to the table that the entity type tells us to point to.',
  `string_value` varchar(1024) DEFAULT NULL COMMENT 'The value of the attribute mapped to the given entity.',
  `blob_value` blob DEFAULT NULL COMMENT 'The blob value of the attribute mapped to the given entity.',
  `updated_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'This is the date at which metadata was updated.',
  PRIMARY KEY (`id`),
  KEY `attribute` (`attribute_id`),
  KEY `entity` (`entity_id`,`entity_type`),
  KEY `string_value` (`string_value`)
) ENGINE=InnoDB AUTO_INCREMENT=463652 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the mappings of what entities are assigned what string attributes.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metadata_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `metadata_map` WRITE;
/*!40000 ALTER TABLE `metadata_map` DISABLE KEYS */;
INSERT INTO `metadata_map` VALUES (1,159,'device',1,'Unknown',NULL,'0000-00-00 00:00:00'),(2,161,'device',1,'SevOne',NULL,'0000-00-00 00:00:00'),(3,158,'device',1,'In Production',NULL,'0000-00-00 00:00:00'),(4,163,'device',1,'SelfMon Device',NULL,'0000-00-00 00:00:00'),(5,143,'device',1,'Unknown',NULL,'0000-00-00 00:00:00'),(6,144,'device',1,'Linux c49988v1.fyre.ibm.com 4.18.0-553.117.1.el8_10.x86_64 #1 SMP Fri Mar 27 18:49:45 EDT 2026 x86_64',NULL,'0000-00-00 00:00:00'),(7,147,'device',1,'.1.3.6.1.4.1.27207.3',NULL,'0000-00-00 00:00:00'),(8,157,'device',1,'Unknown',NULL,'0000-00-00 00:00:00'),(9,149,'device',1,'icon_help',NULL,'0000-00-00 00:00:00'),(10,162,'device',1,'Unknown',NULL,'0000-00-00 00:00:00');
/*!40000 ALTER TABLE `metadata_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nat_config_info`
--

DROP TABLE IF EXISTS `nat_config_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `nat_config_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID of a table entry ',
  `physical_ip` varbinary(40) DEFAULT NULL COMMENT 'physical IP of a machine ',
  `nat_ip` varbinary(40) DEFAULT NULL COMMENT 'NAT IP of a machine ',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'timestamp at which entry is created',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains nat configuration info';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nat_config_info`
--
-- WHERE:  1 limit 10

LOCK TABLES `nat_config_info` WRITE;
/*!40000 ALTER TABLE `nat_config_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `nat_config_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_device_groups`
--

DROP TABLE IF EXISTS `netflow_device_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_device_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Autoincrement id',
  `group_id` int(11) NOT NULL COMMENT 'Device group for the netflow direction foreignKey: net.devicetags.id',
  `direction_id` int(11) NOT NULL COMMENT 'Netflow direction foreignKey: local.netflowdirection.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `indexNetflowDevicegroup` (`group_id`,`direction_id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is a stub table used to create tablecache.netflow_device_groups, a cached table of device group to netflow direction associations';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_device_groups`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_device_groups` WRITE;
/*!40000 ALTER TABLE `netflow_device_groups` DISABLE KEYS */;
INSERT INTO `netflow_device_groups` VALUES (1,1,9),(2,1,10),(3,1,11),(4,1,12),(5,1,13),(6,2,9),(7,2,10),(8,2,11),(9,2,12),(10,2,13);
/*!40000 ALTER TABLE `netflow_device_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_firewall`
--

DROP TABLE IF EXISTS `netflow_firewall`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_firewall` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `source_ip` varbinary(40) DEFAULT NULL COMMENT 'The IPv4 address of the device originating the flows. This is also known as the ''Origin IP''.',
  `source_int` int(10) unsigned DEFAULT NULL COMMENT 'The integer representing the interface generating flows for the given source_ip.',
  `direction` int(11) DEFAULT -1 COMMENT 'An integer representing the direction the the flow in/out of the given interface for a given source_ip.  Undefined = -1, Incoming = 1 Outgoing = 2.',
  `permit` int(11) DEFAULT 0 COMMENT 'Boolean that indicates if the given source_ip/interface/direction is permitted to record flows. 0 = Not Permitted, 1 = Permitted.',
  `rule_creator` int(11) DEFAULT 0 COMMENT 'Enumeration that indicates who originated the rule: 0 = user, 1 = system.',
  `rule_type` int(11) DEFAULT 0 COMMENT 'Indicates when the rule was over capacity: 0 = normal rule, 1 = Over Capacity.',
  `delete_status` tinyint(4) DEFAULT 0 COMMENT 'Boolean that indicates if this rule has been deleted and the associated in memory cache should be cleared: 0 = Not Deleted, 1 = Deleted.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `source` (`source_ip`,`source_int`,`direction`)
) ENGINE=InnoDB AUTO_INCREMENT=443 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains the current set of the SevOne NMS netflow interfaces on which flows are being received.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_firewall`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_firewall` WRITE;
/*!40000 ALTER TABLE `netflow_firewall` DISABLE KEYS */;
INSERT INTO `netflow_firewall` VALUES (435,'64400065',393,2,0,0,0,0),(436,'64400065',0,1,0,0,0,0),(437,'64400065',399,2,0,0,0,0),(438,'64400065',399,1,0,0,0,0),(439,'64400065',0,2,0,0,0,0);
/*!40000 ALTER TABLE `netflow_firewall` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_object_groups`
--

DROP TABLE IF EXISTS `netflow_object_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_object_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `direction_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `indexNetflowObjectgroup` (`group_id`,`direction_id`),
  KEY `group_id` (`group_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_object_groups`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_object_groups` WRITE;
/*!40000 ALTER TABLE `netflow_object_groups` DISABLE KEYS */;
INSERT INTO `netflow_object_groups` VALUES (1,131,12);
/*!40000 ALTER TABLE `netflow_object_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflow_options_template_resolved_values`
--

DROP TABLE IF EXISTS `netflow_options_template_resolved_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflow_options_template_resolved_values` (
  `resolved_element_id` bigint(20) NOT NULL COMMENT 'sevone resolved field id. ',
  `element_id_value` text NOT NULL COMMENT 'value of field id',
  `element_id_value_hash` binary(32) NOT NULL COMMENT 'hash computed from element id value',
  `element_id_resolved_value` text NOT NULL COMMENT 'resolved value of field id. ',
  `hash` binary(16) NOT NULL COMMENT 'hash computed from resolved value',
  `last_seen` int(11) NOT NULL DEFAULT 0 COMMENT 'last seen for this resolved value',
  PRIMARY KEY (`resolved_element_id`,`element_id_value_hash`,`hash`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table stores option template data, resovled by netflow_options_template_resolvers. ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflow_options_template_resolved_values`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflow_options_template_resolved_values` WRITE;
/*!40000 ALTER TABLE `netflow_options_template_resolved_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `netflow_options_template_resolved_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowdirection`
--

DROP TABLE IF EXISTS `netflowdirection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowdirection` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `peer` int(11) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.peers.server_id',
  `origin_ip` varbinary(40) DEFAULT NULL COMMENT 'This is the origin ip of the flow.  It does not support IPv6',
  `interface` int(10) unsigned DEFAULT NULL COMMENT 'This is the interface associated with the flow',
  `direction` int(11) DEFAULT NULL COMMENT 'this is the direction.  It may be either 1 (incoming) or 2 (outgoing).  This is a candidate for enum',
  `visible` tinyint(4) DEFAULT 0 COMMENT 'This controls if the direction is visible',
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`origin_ip`,`interface`,`direction`),
  KEY `interface_key` (`interface`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the netflowdirection table.  It has information about the direction tuples.  The tuples are (origin_ip,interface,direction) ' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowdirection`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowdirection` WRITE;
/*!40000 ALTER TABLE `netflowdirection` DISABLE KEYS */;
INSERT INTO `netflowdirection` VALUES (1,1,'092B0A17',0,1,0),(2,1,'092B0A17',0,2,0),(3,1,'092B6423',0,1,0),(4,1,'092B6423',0,2,0),(5,1,'092B28D2',0,1,0),(6,1,'092B28D2',0,2,0),(7,1,'09C7C3C5',0,1,0),(8,1,'09C7C3C5',0,2,0),(9,1,'64400065',393,2,0),(10,1,'64400065',399,2,0);
/*!40000 ALTER TABLE `netflowdirection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowinterface`
--

DROP TABLE IF EXISTS `netflowinterface`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowinterface` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `peer` int(11) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.peers.server_id',
  `origin_ip` varbinary(40) DEFAULT NULL COMMENT 'This is the ip where the flows came from.  This column does not support IPv6',
  `interface` int(10) unsigned DEFAULT NULL COMMENT 'This the ifIndex from snmp.',
  `name` varchar(255) DEFAULT NULL COMMENT 'This is similar to the name in netflowdeviceinfo',
  `system_name` varchar(255) DEFAULT NULL COMMENT 'This is similar to the system name in netflowdeviceinfo',
  `override_name` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'This controls if the system resets the name to what it discovers.  However, the functionallity was not implemented as of Feb 22, 2013',
  `description` varchar(255) DEFAULT NULL COMMENT 'This can be overriden by the override_description bit',
  `system_description` varchar(255) DEFAULT NULL COMMENT 'This is the ifDescription of the interface',
  `override_description` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'This controls if the system description matches the description',
  `speed` bigint(20) DEFAULT NULL COMMENT 'This can be overriden by the override_speed bit',
  `system_speed` bigint(20) DEFAULT NULL COMMENT 'This is the ifSpeed of the interface',
  `override_speed` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'This controls if the system speed matches the speed',
  `visible` tinyint(4) DEFAULT 0 COMMENT 'Controls if this is visible in the gui',
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`origin_ip`,`interface`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the interfaces on the netflow device' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowinterface`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowinterface` WRITE;
/*!40000 ALTER TABLE `netflowinterface` DISABLE KEYS */;
INSERT INTO `netflowinterface` VALUES (1,1,'092B0A17',0,NULL,NULL,0,NULL,NULL,0,NULL,NULL,0,0),(3,1,'092B6423',0,NULL,NULL,0,NULL,NULL,0,NULL,NULL,0,0),(5,1,'092B28D2',0,NULL,NULL,0,NULL,NULL,0,NULL,NULL,0,0),(6,1,'09C7C3C5',0,NULL,NULL,0,NULL,NULL,0,NULL,NULL,0,0),(7,1,'64400065',393,NULL,NULL,0,NULL,NULL,0,NULL,NULL,0,0),(8,1,'64400065',399,'Test',NULL,1,'Test',NULL,1,NULL,NULL,0,0),(9,1,'64400065',0,NULL,NULL,0,NULL,NULL,0,NULL,NULL,0,0),(10,1,'092B3BDB',0,NULL,NULL,0,NULL,NULL,0,NULL,NULL,0,0);
/*!40000 ALTER TABLE `netflowinterface` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowmplsmap`
--

DROP TABLE IF EXISTS `netflowmplsmap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowmplsmap` (
  `mpls_label2` varchar(32) NOT NULL COMMENT 'MPLS label',
  `provider_edge_egress_ip` varbinary(40) NOT NULL COMMENT 'provider edge egress ip',
  `customer_vrf_name` varchar(32) NOT NULL COMMENT 'customer vrf name',
  PRIMARY KEY (`mpls_label2`,`provider_edge_egress_ip`,`customer_vrf_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the mpls mapping ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowmplsmap`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowmplsmap` WRITE;
/*!40000 ALTER TABLE `netflowmplsmap` DISABLE KEYS */;
/*!40000 ALTER TABLE `netflowmplsmap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowoptionstemplate`
--

DROP TABLE IF EXISTS `netflowoptionstemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowoptionstemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `origin_ip` varbinary(40) DEFAULT NULL COMMENT 'The ip from netflowdeviceinfo',
  `source_port` smallint(5) unsigned DEFAULT NULL COMMENT 'The source port of the netflow exporter',
  `source_id` int(10) unsigned DEFAULT NULL COMMENT 'This is related to RFC 3954.  This is NOT a foriegn in our system',
  `template_id` int(11) DEFAULT NULL COMMENT 'This is related to RFC 3954.  This is NOT a foriegn in our system',
  `version` int(11) DEFAULT 0 COMMENT 'This is related to RFC 3954',
  `last_seen` int(11) DEFAULT 0 COMMENT 'This is the last time we saw this template',
  `hash` binary(16) NOT NULL COMMENT 'this is the md5 hash value of the option template',
  PRIMARY KEY (`id`),
  UNIQUE KEY `source` (`origin_ip`,`source_port`,`source_id`,`template_id`,`version`)
) ENGINE=InnoDB AUTO_INCREMENT=3109 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='These are the option templates that the netflow sources have sent to the appliance. ' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowoptionstemplate`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowoptionstemplate` WRITE;
/*!40000 ALTER TABLE `netflowoptionstemplate` DISABLE KEYS */;
/*!40000 ALTER TABLE `netflowoptionstemplate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowsourcetemplate`
--

DROP TABLE IF EXISTS `netflowsourcetemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowsourcetemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `origin_ip` varbinary(40) DEFAULT NULL COMMENT 'The ip from netflowdeviceinfo',
  `source_port` smallint(5) unsigned DEFAULT NULL COMMENT 'The source port of the netflow exporter',
  `source_id` int(10) unsigned DEFAULT NULL COMMENT 'This is related to RFC 3954.  This is NOT a foriegn in our system',
  `template_id` int(11) DEFAULT NULL COMMENT 'This is related to RFC 3954.  This is NOT a foriegn in our system',
  `version` int(11) DEFAULT 0 COMMENT 'This is related to RFC 3954',
  `last_seen` int(11) DEFAULT 0 COMMENT 'This is the last time wee saw this template',
  `field_hash` binary(16) NOT NULL COMMENT 'This is MD5 hash of fields, to determine if they have changed',
  PRIMARY KEY (`id`),
  UNIQUE KEY `source` (`origin_ip`,`source_port`,`source_id`,`template_id`,`version`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='These are the templates that the netflow sources have sent to the appliance.  In this case, templates is refering to the templates sent in a RFC 3954 sense.' `ENCRYPTED`=YES;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowsourcetemplate`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowsourcetemplate` WRITE;
/*!40000 ALTER TABLE `netflowsourcetemplate` DISABLE KEYS */;
/*!40000 ALTER TABLE `netflowsourcetemplate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowsourcetemplatefield`
--

DROP TABLE IF EXISTS `netflowsourcetemplatefield`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowsourcetemplatefield` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `sourcetemplate_id` int(11) DEFAULT NULL COMMENT ' foreignKey: local.netflowsourcetemplate.id',
  `order_number` int(11) DEFAULT 0 COMMENT 'The ordinal position of the field',
  `field` bigint(20) DEFAULT 0 COMMENT 'This is the field number returned by the netflow template.  See RFC 3954 for more information.  This is related to netflow_fields.element_id',
  `length` int(11) DEFAULT 0 COMMENT 'The size of the field, in bytes',
  `is_variable_length` tinyint(1) DEFAULT 0 COMMENT 'Is the field variable length',
  PRIMARY KEY (`id`),
  KEY `sourcetemplate_id` (`sourcetemplate_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1058 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table containts all of the fields that belong to a certain RFC 3954 template.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowsourcetemplatefield`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowsourcetemplatefield` WRITE;
/*!40000 ALTER TABLE `netflowsourcetemplatefield` DISABLE KEYS */;
/*!40000 ALTER TABLE `netflowsourcetemplatefield` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowstats`
--

DROP TABLE IF EXISTS `netflowstats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowstats` (
  `source_ip` varbinary(40) DEFAULT NULL COMMENT 'This is the same as origin_ip, a greate candidate to rename to origin_ip',
  `source_int` int(10) unsigned DEFAULT NULL COMMENT 'This is the same as the interface, should be renamed',
  `direction` int(11) DEFAULT NULL COMMENT 'Part of the direction tuple',
  `permit` int(11) DEFAULT NULL COMMENT 'This field is unused, and is a candidate for deletion',
  `rejected_bytes_fw` bigint(20) DEFAULT NULL COMMENT 'The number of bytes that have been rejected due to firewall rules',
  `rejected_flows_fw` bigint(20) DEFAULT NULL COMMENT 'The number of flows that have been rejected due to firewall rules',
  `rejected_bytes_perf` bigint(20) DEFAULT NULL COMMENT 'The number of bytes that have been rejected due to performance rules',
  `rejected_flows_perf` bigint(20) DEFAULT NULL COMMENT 'The number of flows that have been rejected due to performance rules',
  `rejected_flows_duration` bigint(20) DEFAULT NULL COMMENT 'The number of flows that have been rejected due to flow size rules.  They were longer than twice the write interval',
  `accepted_bytes` bigint(20) DEFAULT NULL COMMENT 'The number of bytes that have been accepted',
  `accepted_flows` bigint(20) DEFAULT NULL COMMENT 'The number of flows that have been accepted',
  `flows_per_second` decimal(12,2) unsigned DEFAULT 0.00 COMMENT 'This is the rolling average over the last ten minnutes of the number of flows',
  `last_long_flow_seen` int(11) DEFAULT 0 COMMENT 'This is the last time a long flow was seen.  A long flow is one that is more than twice as long as the write interval',
  `last_seen` int(11) DEFAULT 0 COMMENT 'This is the last time this direction tuple has been seen',
  `last_write` int(11) DEFAULT 0 COMMENT 'This is the last we wrote data for the given direction tuple',
  `sample_rate` int(10) unsigned NOT NULL DEFAULT 1 COMMENT 'This is the sample rate of the flow',
  UNIQUE KEY `source_ip` (`source_ip`,`source_int`,`direction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is where we store statistics on a per direction tuple basis.  The source_ip, source_int, and direction can be replace with a foreign key to net.netflowdirection.id.  This table used to be in net, but it is too high traffic';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowstats`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowstats` WRITE;
/*!40000 ALTER TABLE `netflowstats` DISABLE KEYS */;
INSERT INTO `netflowstats` VALUES ('092B0A17',0,1,0,48,1,0,0,0,0,0,0.00,0,1742102130,0,1),('092B0A17',0,2,0,48,1,0,0,0,0,0,0.00,0,1742102130,0,1),('092B6423',0,1,1,0,0,0,0,0,48,1,0.00,0,1742116450,0,16383),('092B6423',0,2,1,0,0,0,0,0,48,1,0.00,0,1742116450,0,16383),('092B28D2',0,1,1,0,0,0,0,0,432,9,0.00,0,1742151577,0,16383),('092B28D2',0,2,1,0,0,0,0,0,432,9,0.00,0,1742151577,0,16383),('09C7C3C5',0,1,1,0,0,0,0,0,1296,27,0.00,0,1742366114,0,16383),('09C7C3C5',0,2,1,0,0,0,0,0,1296,27,0.00,0,1742366114,0,16383),('64400065',0,2,0,318643,1721,0,0,0,0,0,0.00,0,1766407588,1766404833,1),('64400065',393,2,0,79794,858,0,0,0,0,0,0.00,0,1766407567,1766404841,1);
/*!40000 ALTER TABLE `netflowstats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netflowvrfmap`
--

DROP TABLE IF EXISTS `netflowvrfmap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `netflowvrfmap` (
  `customer_vrf_name` varchar(32) NOT NULL COMMENT 'customer vrf name',
  `source_ip` varbinary(40) NOT NULL COMMENT 'source ip',
  `provider_edge_ingress_ip` varbinary(40) NOT NULL COMMENT 'provider edge ingress ip',
  PRIMARY KEY (`customer_vrf_name`,`source_ip`,`provider_edge_ingress_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the vrf mapping ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netflowvrfmap`
--
-- WHERE:  1 limit 10

LOCK TABLES `netflowvrfmap` WRITE;
/*!40000 ALTER TABLE `netflowvrfmap` DISABLE KEYS */;
/*!40000 ALTER TABLE `netflowvrfmap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peer_statistics`
--

DROP TABLE IF EXISTS `peer_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `peer_statistics` (
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Timestamp when data will be dumped in the database.',
  `model` varchar(20) DEFAULT NULL COMMENT 'Model of peer (PAS/DNC).',
  `nms_version` varchar(20) DEFAULT NULL COMMENT 'SevOne NMS version of Peer.',
  `deployment_type` varchar(20) DEFAULT NULL COMMENT 'Deployment type of Peer (HW/vPAS).',
  `hostname` varchar(254) DEFAULT NULL COMMENT 'Hostname of peer',
  `architecture` varchar(10) DEFAULT NULL COMMENT 'Architecture of peer',
  `file_system` text DEFAULT NULL COMMENT 'File system of peer',
  `is_sdb_enabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Is SDB enabled on this peer',
  PRIMARY KEY (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the table that stores the peerwise basic information.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peer_statistics`
--
-- WHERE:  1 limit 10

LOCK TABLES `peer_statistics` WRITE;
/*!40000 ALTER TABLE `peer_statistics` DISABLE KEYS */;
INSERT INTO `peer_statistics` VALUES ('2025-05-05 00:00:12','PAS5K','7.2.0','VIRTUAL','c49988v1.fyre.ibm.com','x86_64','1- Mount point- /, Size- 233GB; 2- Mount point- /data, Size- 233GB',1),('2025-05-06 00:00:12','PAS5K','7.2.0','VIRTUAL','c49988v1.fyre.ibm.com','x86_64','1- Mount point- /, Size- 233GB; 2- Mount point- /data, Size- 233GB',1),('2025-05-07 00:00:13','PAS5K','7.2.0','VIRTUAL','c49988v1.fyre.ibm.com','x86_64','1- Mount point- /, Size- 233GB; 2- Mount point- /data, Size- 233GB',1),('2025-05-08 00:00:15','PAS5K','7.2.0','VIRTUAL','c49988v1.fyre.ibm.com','x86_64','1- Mount point- /, Size- 233GB; 2- Mount point- /data, Size- 233GB',1),('2025-05-09 00:00:14','PAS5K','7.2.0','VIRTUAL','c49988v1.fyre.ibm.com','x86_64','1- Mount point- /, Size- 233GB; 2- Mount point- /data, Size- 233GB',1),('2025-05-10 00:00:13','PAS5K','7.2.0','VIRTUAL','c49988v1.fyre.ibm.com','x86_64','1- Mount point- /, Size- 233GB; 2- Mount point- /data, Size- 233GB',1),('2025-05-11 00:00:14','PAS5K','7.2.0','VIRTUAL','c49988v1.fyre.ibm.com','x86_64','1- Mount point- /, Size- 233GB; 2- Mount point- /data, Size- 233GB',1),('2025-05-12 00:00:13','PAS5K','7.2.0','VIRTUAL','c49988v1.fyre.ibm.com','x86_64','1- Mount point- /, Size- 233GB; 2- Mount point- /data, Size- 233GB',1),('2025-05-13 00:00:14','PAS5K','7.2.0','VIRTUAL','c49988v1.fyre.ibm.com','x86_64','1- Mount point- /, Size- 233GB; 2- Mount point- /data, Size- 233GB',1),('2025-05-14 00:00:11','PAS5K','7.2.0','VIRTUAL','c49988v1.fyre.ibm.com','x86_64','1- Mount point- /, Size- 233GB; 2- Mount point- /data, Size- 233GB',1);
/*!40000 ALTER TABLE `peer_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peeravailability`
--

DROP TABLE IF EXISTS `peeravailability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `peeravailability` (
  `peer_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.peers.server_id',
  `last_check` int(10) unsigned NOT NULL COMMENT 'The timestamp at which this row was last updated (epoch).',
  `mysqldata` int(10) unsigned DEFAULT NULL COMMENT 'The time that it took to connect to MySQL, port 3306 (microseconds); NULL if it could not connect.',
  `mysqlconfig` int(10) unsigned DEFAULT NULL COMMENT 'The time that it took to connect to MySQL, port 3307 (microseconds); NULL if it could not connect.',
  `active_appliance` enum('PRIMARY','SECONDARY') NOT NULL DEFAULT 'PRIMARY' COMMENT 'This is used to add HSA appliances to the peer availability table',
  PRIMARY KEY (`peer_id`,`active_appliance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This contains this Peer''s beliefs about its ability to connect to the other Peers.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peeravailability`
--
-- WHERE:  1 limit 10

LOCK TABLES `peeravailability` WRITE;
/*!40000 ALTER TABLE `peeravailability` DISABLE KEYS */;
INSERT INTO `peeravailability` VALUES (1,1777964881,1636,7346,'PRIMARY');
/*!40000 ALTER TABLE `peeravailability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `php_ui_stats`
--

DROP TABLE IF EXISTS `php_ui_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `php_ui_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) NOT NULL COMMENT 'The user ID',
  `script` varchar(255) NOT NULL COMMENT 'The script being tracked.',
  `access_count` bigint(20) NOT NULL COMMENT 'The number of requests to the script.',
  `get_count` bigint(20) NOT NULL COMMENT 'The number of GET requests to the script.',
  `post_count` bigint(20) NOT NULL COMMENT 'The number of POST requests to the script.',
  `database_connectionCount` bigint(20) NOT NULL COMMENT 'The number of connections attempted.',
  `database_connectionCount_local` bigint(20) NOT NULL COMMENT 'The number of local connections attempted.',
  `database_connectionCount_master` bigint(20) NOT NULL COMMENT 'The number of master connections attempted.',
  `database_connectionCount_remote` bigint(20) NOT NULL COMMENT 'The number of remote connections attempted.',
  `database_queryCount` bigint(20) NOT NULL COMMENT 'The number of queries attempted.',
  `database_queryErrorCount` bigint(20) NOT NULL COMMENT 'The number of query errors.',
  `database_queryTime` double NOT NULL COMMENT 'The total amount of time spent running queries.',
  `memory_peak_usage` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Peak amount of memory used by PHP for this script, in megabytes.',
  `request_time` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Total request time as known by PHP for this script, in seconds.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_and_script` (`user_id`,`script`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='PHP scripts usage statistics by user';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `php_ui_stats`
--
-- WHERE:  1 limit 10

LOCK TABLES `php_ui_stats` WRITE;
/*!40000 ALTER TABLE `php_ui_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `php_ui_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process_object_subtype_map`
--

DROP TABLE IF EXISTS `process_object_subtype_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `process_object_subtype_map` (
  `device_id` int(11) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.deviceinfo.id',
  `subtype_id` int(11) NOT NULL DEFAULT 0 COMMENT 'Processes are now stored as Object Subtypes, so this determins what processes are allowed to be discovered. foreignKey: net.objectsubtypes.id',
  `is_enabled` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if this Object Subtype is enabled; 0 if it is disabled.',
  UNIQUE KEY `unique_tuple` (`device_id`,`subtype_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This maps a Device to a kind of process, determining what can and will be discovered during Process Plugin discovery.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_object_subtype_map`
--
-- WHERE:  1 limit 10

LOCK TABLES `process_object_subtype_map` WRITE;
/*!40000 ALTER TABLE `process_object_subtype_map` DISABLE KEYS */;
INSERT INTO `process_object_subtype_map` VALUES (100,1378,1),(100,1379,1),(100,1386,1),(100,1387,1),(100,1336,1),(100,1337,1),(100,1338,1),(100,1339,1),(100,1340,1),(100,1302,1);
/*!40000 ALTER TABLE `process_object_subtype_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `setting` varchar(128) NOT NULL DEFAULT '' COMMENT 'The setting name.',
  `value` varchar(64) DEFAULT NULL COMMENT 'The setting value.',
  PRIMARY KEY (`setting`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the Peer''s local settings.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--
-- WHERE:  1 limit 10

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES ('checkmate_run_frequency','1'),('cmcdr_last_import','1264312075'),('default_http_proxy',''),('discovery_orphan_table_cleanup_time','1777926362'),('enable_peer_firewall','0'),('ffupdater_last_run','1777964821'),('firewall_settings_override','1'),('flowing_flows_per_second_limit','30000'),('flowlog_flows_per_second_limit','30000'),('highpolling_last_logged_time','1777964803');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snmp_mibs_stats`
--

DROP TABLE IF EXISTS `snmp_mibs_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `snmp_mibs_stats` (
  `mib_id` int(11) NOT NULL DEFAULT 0 COMMENT ' foreignKey: net.snmp_mibs.id',
  `filename` varchar(255) NOT NULL DEFAULT '' COMMENT 'This is the name of the file in which the MIB is stored (in /usr/local/snmp/mibs).',
  `revision` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the last revision of the MIB that was written to disk.  This corresponds to net.snmp_mibs.revision.',
  `mtime` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'This is the last modification time of the file.',
  PRIMARY KEY (`mib_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores filesystem information about the SNMP MIBs that are transcribed from ''net.snmp_mibs'' to ''/usr/local/snmp/mibs''.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snmp_mibs_stats`
--
-- WHERE:  1 limit 10

LOCK TABLES `snmp_mibs_stats` WRITE;
/*!40000 ALTER TABLE `snmp_mibs_stats` DISABLE KEYS */;
INSERT INTO `snmp_mibs_stats` VALUES (1,'/usr/local/snmp/mibs/ADTRAN-IADROUTER-MIB.mib',1,1775544123),(2,'/usr/local/snmp/mibs/ADTRAN-IADVOICE-MIB.mib',1,1775544123),(3,'/usr/local/snmp/mibs/ADTRAN-MIB.mib',1,1775544123),(4,'/usr/local/snmp/mibs/ADTRAN-TA6XX-MIB.mib',1,1775544123),(5,'/usr/local/snmp/mibs/ADTRAN-TC.mib',1,1775544123),(6,'/usr/local/snmp/mibs/AGENTX-MIB.mib',1,1775544123),(7,'/usr/local/snmp/mibs/ALCATEL-IND1-BASE.mib',1,1775544123),(8,'/usr/local/snmp/mibs/ALCATEL-IND1-CHASSIS-MIB.mib',1,1775544123),(9,'/usr/local/snmp/mibs/ALCATEL-IND1-HEALTH-MIB.mib',1,1775544123),(10,'/usr/local/snmp/mibs/ALCATEL-IND1-SYSTEM-MIB.mib',1,1775544123);
/*!40000 ALTER TABLE `snmp_mibs_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snmp_object_status`
--

DROP TABLE IF EXISTS `snmp_object_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `snmp_object_status` (
  `object_id` int(11) NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `device_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `admin_status` tinyint(4) DEFAULT NULL COMMENT 'The current administrative status.  1 = enabled; 2 = disabled; 0 = unknown.  Note: this could be an enumeration.',
  `admin_status_time` bigint(20) DEFAULT NULL COMMENT 'The time at which ''admin_status'' was last changed.',
  `oper_status` tinyint(4) DEFAULT NULL COMMENT 'The current operational status.  1 = enabled; 2 = disabled; 0 = unknown.  Note: this could be an enumeration.',
  `oper_status_time` bigint(20) DEFAULT NULL COMMENT 'The time at which ''oper_status'' was last changed.',
  PRIMARY KEY (`object_id`),
  KEY `device_id` (`device_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This contains extra time-related information about the administrative and operational statuses of SNMP Plugin Objects, for use with enabling and disabling them.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snmp_object_status`
--
-- WHERE:  1 limit 10

LOCK TABLES `snmp_object_status` WRITE;
/*!40000 ALTER TABLE `snmp_object_status` DISABLE KEYS */;
INSERT INTO `snmp_object_status` VALUES (52,1,1,0,1,0),(53,1,1,0,1,0),(54,1,1,0,1,0),(247,4,1,0,1,0),(246,4,1,0,1,0),(245,4,1,0,1,0),(930,64,1,0,1,0),(931,64,1,0,1,0),(934,64,1,0,1,0),(937,64,1,0,1,1772516693);
/*!40000 ALTER TABLE `snmp_object_status` ENABLE KEYS */;
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains all local syslog destinations.';
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
-- Table structure for table `thresholds`
--

DROP TABLE IF EXISTS `thresholds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `thresholds` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `name` varchar(255) DEFAULT NULL COMMENT 'This is the name of the threshold.  For a Policy-driven threshold, this is automatically generated.',
  `description` varchar(1024) DEFAULT NULL COMMENT 'This is the description of the threshold.  For a Policy-driven threshold, this is copied from the Policy''s description.',
  `device_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `policy_id` int(11) DEFAULT 0 COMMENT ' foreignKey: net.policy.id',
  `group_id` int(11) DEFAULT 0 COMMENT 'Policy-driven only.  This is the ID of the group for which the Policy was created.  This is used only for adding text to the alert message. Refers to net.objectgroupinfo.id, if is_device_group is 0, otherwise it refers to net.devicetags.id.',
  `is_device_group` tinyint(4) DEFAULT 0 COMMENT 'Policy-driven only.  1 if ''group_id'' refers to a Device Group; 0 if it refers to an Object Group.',
  `severity` int(11) DEFAULT NULL COMMENT 'This is the severity of the alert to generate (0-8).',
  `trigger_expression` varchar(1024) DEFAULT NULL COMMENT 'This is the DNF of the logic to use to evaluate the threshold.  '','' is OR; ''|'' is AND.  All ORs are evaluated together; then ANDs.  Numbers are condition IDs (see local.thresholds_conditions.id).',
  `clear_expression` varchar(1024) DEFAULT NULL COMMENT 'This is the DNF of the logic to use to clear the threshold.  '','' is OR; ''|'' is AND.  All ORs are evaluated together; then ANDs.  Numbers are condition IDs (see local.thresholds_conditions.id).',
  `user_enabled` int(11) DEFAULT 1 COMMENT '1 if the threshold has been enabled by a user; 0 otherwise.',
  `policy_enabled` int(11) DEFAULT 1 COMMENT '1 if the threshold has been enabled by its creator policy; 0 otherwise.',
  `mail_to` varchar(1024) DEFAULT NULL COMMENT 'This is a comma-separated list of email addresses (both real and SevOne user and SevOne group addresses).',
  `mail_once` smallint(6) DEFAULT 1 COMMENT '1 if only one email should be sent about this threshold (once an alert is generated); 0 if an email should be sent each time it triggers.',
  `mail_period` int(11) NOT NULL DEFAULT 900 COMMENT 'If ''mail_once'' is 0, then this is how often to send the emails (minimum time in seconds).',
  `last_updated` int(11) DEFAULT NULL COMMENT 'This is the timestamp at which the threshold was last updated (epoch).',
  `use_default_traps` smallint(6) DEFAULT 1 COMMENT '1 if the system-default SNMP trap destinations should be used; 0 otherwise.',
  `use_device_traps` smallint(6) DEFAULT 1 COMMENT '1 if the Device-specific SNMP trap destinations should be used; 0 otherwise.',
  `use_custom_traps` smallint(6) DEFAULT 0 COMMENT '1 if this threshold has its own set of SNMP trap destinations configured; 0 otherwise.',
  `trigger_message` text DEFAULT NULL COMMENT 'This is the message to use to create the alert text when the threshold is triggered.',
  `clear_message` text DEFAULT NULL COMMENT 'This is the message to use to create the clear text when the threshold is cleared.',
  `append_condition_messages` smallint(6) DEFAULT 1 COMMENT '1 if, in addition to ''trigger_message'' or ''clear_message'', a series of messages about the conditions that triggered should be appended to the alert text; 0 otherwise.',
  `type` enum('other','flow') DEFAULT 'other' COMMENT 'type of the data the threshold is about',
  `use_device_work_hours` tinyint(4) NOT NULL DEFAULT 0 COMMENT '1 if the Device Work Hours should be used instead of ''Shedule'' options; 0 otherwise.',
  `is_service_alerts` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'true if this policy is a flow app alerts threshold.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_key` (`name`,`policy_id`),
  KEY `policy_id` (`policy_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2434 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table stores thresholds that will be checked periodically by SevOne-checkmate.  A triggered threshold generates an Alert.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thresholds`
--
-- WHERE:  1 limit 10

LOCK TABLES `thresholds` WRITE;
/*!40000 ALTER TABLE `thresholds` DISABLE KEYS */;
INSERT INTO `thresholds` VALUES (1,'Ethernet Interface Traffic Over 95% - 32 Bit Counters - c49988v1.fyre.ibm.com - eth0','Ethernet Interface Traffic - 32 Bit Counters',1,1,41,1,3,'1|2','3|4',1,1,'',1,900,1741754523,1,1,0,'','',1,'other',0,0),(2,'Ethernet Interface Traffic Over 95% - 32 Bit Counters - c49988v1.fyre.ibm.com - eth1','Ethernet Interface Traffic - 32 Bit Counters',1,1,41,1,3,'5|6','7|8',1,1,'',1,900,1741754523,1,1,0,'','',1,'other',0,0),(3,'Interface Errors and Discards Over 100 in 15 Minutes - c49988v1.fyre.ibm.com - lo','Interface Errors',1,9,41,1,3,'9|10|11|12','13,14,15,16',1,1,'',1,900,1741754523,1,1,0,'','',1,'other',0,0),(4,'Interface Errors and Discards Over 100 in 15 Minutes - c49988v1.fyre.ibm.com - eth0','Interface Errors',1,9,41,1,3,'17|18|19|20','21,22,23,24',1,1,'',1,900,1741754523,1,1,0,'','',1,'other',0,0),(5,'Interface Errors and Discards Over 100 in 15 Minutes - c49988v1.fyre.ibm.com - eth1','Interface Errors',1,9,41,1,3,'25|26|27|28','29,30,31,32',1,1,'',1,900,1741754523,1,1,0,'','',1,'other',0,0),(6,'SNMP is no longer available - c49988v1.fyre.ibm.com - SNMP Availability','Alert if SNMP becomes unavailable.',1,20,41,1,1,'33','34',1,1,'',1,900,1741754523,1,1,0,'','',1,'other',0,0),(7,'SevOne Process: requestd peer availability - c49988v1.fyre.ibm.com - SevOne-requestd','This service processes requests for data. When requestd Available Peers is < 100% this may result a peer outage and data availability issue, unless this is a hub & spoke environment.',1,36,2,1,0,'35','36',1,1,'',1,900,1741754523,1,1,0,'','',1,'other',0,0),(15,'Selfmond: master-master conflict - c49988v1.fyre.ibm.com - SevOne-selfmond','Both primary and secondary sevone appliances think that they are master, which could result in replication and data divergence issues.',1,37,2,1,0,'73','',1,1,'',1,900,1741778524,1,1,0,'','',1,'other',0,0),(17,'Selfmond: active appliance change - c49988v1.fyre.ibm.com - SevOne-selfmond','There was a change detected in the active appliance over the configured time duration, indicating a possible fail-over or take-over event.',1,38,2,1,0,'75','',1,1,'',1,900,1741778524,1,1,0,'','',1,'other',0,0),(19,'Selfmond: Data Db replication is lagging - c49988v1.fyre.ibm.com - SevOne-selfmond','Database replication is excessively lagging, which may interfere with cluster operations and the accuracy of data requests.',1,40,2,1,0,'77','',1,1,'',1,900,1741778524,1,1,0,'','',1,'other',0,0);
/*!40000 ALTER TABLE `thresholds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thresholds_absolutetimes`
--

DROP TABLE IF EXISTS `thresholds_absolutetimes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `thresholds_absolutetimes` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `threshold_id` int(11) NOT NULL COMMENT ' foreignKey: local.thresholds.id',
  `dev_id` int(11) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `start_time` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the start time of this entry.  For what this entry does, see ''on_off''.',
  `end_time` int(11) NOT NULL DEFAULT 0 COMMENT 'This is the end time of this entry.  For what this entry does, see ''on_off''.',
  `on_off` int(11) NOT NULL DEFAULT 0 COMMENT '1 if polling should be enabled during the timespan in this entry; 0 if it should be disabled.',
  `time_zone` varchar(255) DEFAULT 'UTC' COMMENT 'The timezone in which these times apply.  ZOMG IS THIS AT ALL NEEDED?',
  PRIMARY KEY (`id`),
  KEY `dev_id` (`dev_id`),
  KEY `threshold_id` (`threshold_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores scheduling information for the thresholds.  This table is concerned with absolutely-scheduled entries.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thresholds_absolutetimes`
--
-- WHERE:  1 limit 10

LOCK TABLES `thresholds_absolutetimes` WRITE;
/*!40000 ALTER TABLE `thresholds_absolutetimes` DISABLE KEYS */;
/*!40000 ALTER TABLE `thresholds_absolutetimes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thresholds_conditions`
--

DROP TABLE IF EXISTS `thresholds_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `thresholds_conditions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `threshold_id` int(11) DEFAULT NULL COMMENT ' foreignKey: local.thresholds.id',
  `policy_id` int(11) DEFAULT -1 COMMENT 'If this is a standalone threshold, then this will be set to ''-1''. foreignKey: net.policy.id',
  `policy_condition_id` int(11) DEFAULT -1 COMMENT 'If this is a standalone threshold, then this will be set to ''-1''. foreignKey: net.policyconditions.id',
  `device_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `plugin_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.plugins.id',
  `object_id` int(11) DEFAULT NULL COMMENT ' foreignKey: local.device_object.id',
  `poll_id` bigint(20) DEFAULT NULL COMMENT ' foreignKey: local.device_indicator.id',
  `type` int(11) DEFAULT NULL COMMENT 'This defines how to interpret the condition.  0 = static; 1 = baseline delta; 2 = baseline percentage; 3 = baseline sigma.  Note: This should be an enumeration.',
  `is_trigger` int(11) DEFAULT NULL COMMENT '1 if this condition is for triggering an alert; 0 if it is for clearing it.',
  `value` double DEFAULT NULL COMMENT 'The value against which to compare the data.  How this is compared is dependent on ''type'', ''comparison'', etc.',
  `unit` varchar(32) DEFAULT NULL COMMENT 'This is the units in which ''value'' is measured.',
  `comparison` smallint(6) DEFAULT NULL COMMENT 'How to compare the data.  0 = >; 1 = <; 2 = ==; 3 = >=; 4 = <=; 5 = !=; 6 = (bad polls); 7 = changed; 8 = changed from; 9 = changed to.  Note: This should be an enumeration.',
  `aggregation` smallint(6) DEFAULT NULL COMMENT 'How to prepare the data.  0 = no aggregation; 1 = minimum; 2 = average; 3 = maximum; 4 = total; 5 = count.',
  `duration` int(11) DEFAULT NULL COMMENT 'How much data to gather (in seconds), counting backward from the last data point found.',
  `message` varchar(1024) DEFAULT NULL COMMENT 'This is the condition-specific message to append to alert message.  This may be blank for SevOne-checkmate to generate one on its own.',
  `sigma_direction` smallint(6) DEFAULT NULL COMMENT 'This is how to interpret standard deviations.  0 = apply to data above the baseline; 1 = apply to data below the baseline; 2 = apply to data above or below the baseline.',
  `value2` double DEFAULT NULL COMMENT 'The second value against which to compare the data e.g. ''count of values'' or ''time interval'' or ''% values/time'' that the condtion is true. The meaning is determined by the aggregation value.',
  PRIMARY KEY (`id`),
  KEY `device_id__plugin_id__object_id` (`device_id`,`plugin_id`,`object_id`),
  KEY `policy_id` (`policy_id`),
  KEY `threshold_id` (`threshold_id`)
) ENGINE=MyISAM AUTO_INCREMENT=11552 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains the conditions for the thresholds.  Conditions are the things that are actually evaluated.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thresholds_conditions`
--
-- WHERE:  1 limit 10

LOCK TABLES `thresholds_conditions` WRITE;
/*!40000 ALTER TABLE `thresholds_conditions` DISABLE KEYS */;
INSERT INTO `thresholds_conditions` VALUES (1,1,1,58,1,1,53,510,0,1,95,'Percent',0,2,900,'',0,NULL),(2,1,1,60,1,1,53,517,0,1,95,'Percent',0,2,900,'',0,NULL),(3,1,1,62,1,1,53,510,0,0,85,'Percent',1,2,900,'',0,NULL),(4,1,1,64,1,1,53,517,0,0,85,'Percent',1,2,900,'',0,NULL),(5,2,1,58,1,1,54,530,0,1,95,'Percent',0,2,900,'',0,NULL),(6,2,1,60,1,1,54,537,0,1,95,'Percent',0,2,900,'',0,NULL),(7,2,1,62,1,1,54,530,0,0,85,'Percent',1,2,900,'',0,NULL),(8,2,1,64,1,1,54,537,0,0,85,'Percent',1,2,900,'',0,NULL),(9,3,9,278,1,1,52,490,0,1,100,'Number',0,4,900,'',0,NULL),(10,3,9,279,1,1,52,496,0,1,100,'Number',0,4,900,'',0,NULL);
/*!40000 ALTER TABLE `thresholds_conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thresholds_conditions_flowfalcon`
--

DROP TABLE IF EXISTS `thresholds_conditions_flowfalcon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `thresholds_conditions_flowfalcon` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `condition_id` int(11) NOT NULL COMMENT ' foreignKey: local.thresholds_conditions.id',
  `element_id` bigint(20) NOT NULL COMMENT ' foreignKey: net.netflow_fields.id',
  `threshold_trigger_id` bigint(20) unsigned NOT NULL COMMENT ' foreignKey: local.thresholds_triggers.id',
  `unit` enum('','k','M','G','T','P','E') NOT NULL COMMENT 'Type of unit',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='extension of thresholds_conditions with fields specific to flows';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thresholds_conditions_flowfalcon`
--
-- WHERE:  1 limit 10

LOCK TABLES `thresholds_conditions_flowfalcon` WRITE;
/*!40000 ALTER TABLE `thresholds_conditions_flowfalcon` DISABLE KEYS */;
/*!40000 ALTER TABLE `thresholds_conditions_flowfalcon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thresholds_flowfalcon`
--

DROP TABLE IF EXISTS `thresholds_flowfalcon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `thresholds_flowfalcon` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `threshold_id` int(11) NOT NULL COMMENT ' foreignKey: local.thresholds.id',
  `device_id` int(11) NOT NULL COMMENT ' foreignKey: net.netflowdeviceinfo.id',
  `interface_id` int(11) NOT NULL COMMENT 'interface that the threshold is associated with foreignKey: local.netflowinterface.id',
  `direction_id` int(11) NOT NULL COMMENT 'direction that the threshold is associated with foreignKey: local.netflowdirection.id',
  `view_id` int(11) NOT NULL COMMENT ' foreignKey: net.flowfalconview.id',
  `filter_id` int(11) DEFAULT NULL COMMENT ' foreignKey: net.flowfalconfilters.id',
  PRIMARY KEY (`id`),
  KEY `threshold` (`threshold_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='extension of thresholds with fields specific to flows';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thresholds_flowfalcon`
--
-- WHERE:  1 limit 10

LOCK TABLES `thresholds_flowfalcon` WRITE;
/*!40000 ALTER TABLE `thresholds_flowfalcon` DISABLE KEYS */;
/*!40000 ALTER TABLE `thresholds_flowfalcon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thresholds_flowfalcon_group_by`
--

DROP TABLE IF EXISTS `thresholds_flowfalcon_group_by`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `thresholds_flowfalcon_group_by` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `threshold_id` int(11) NOT NULL COMMENT ' foreignKey: local.thresholds.id',
  `element_id` bigint(20) NOT NULL COMMENT ' foreignKey: net.netflow_fields.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `threshold_element` (`threshold_id`,`element_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='set of flow key fields for grouping during aggregation for a given threshold';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thresholds_flowfalcon_group_by`
--
-- WHERE:  1 limit 10

LOCK TABLES `thresholds_flowfalcon_group_by` WRITE;
/*!40000 ALTER TABLE `thresholds_flowfalcon_group_by` DISABLE KEYS */;
/*!40000 ALTER TABLE `thresholds_flowfalcon_group_by` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thresholds_relativetimes`
--

DROP TABLE IF EXISTS `thresholds_relativetimes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `thresholds_relativetimes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `threshold_id` int(11) NOT NULL COMMENT ' foreignKey: local.thresholds.id',
  `dev_id` int(11) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `monday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Mondays; 0 otherwise.',
  `tuesday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Tuesdays; 0 otherwise.',
  `wednesday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Wednesdays; 0 otherwise.',
  `thursday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Thursdays; 0 otherwise.',
  `friday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Fridays; 0 otherwise. Gotta get down on Friday.',
  `saturday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Saturdays; 0 otherwise.',
  `sunday` int(11) NOT NULL DEFAULT 0 COMMENT '1 if this entry applies to Sundays; 0 otherwise.',
  `start_hr` int(11) NOT NULL DEFAULT 0 COMMENT 'The hour number (0-24) at which this entry begins.  Yes, both 0 and 24 are possible.',
  `start_min` int(11) NOT NULL DEFAULT 0 COMMENT 'The minute number (0-59) at which this entry begins.',
  `end_hr` int(11) NOT NULL DEFAULT 0 COMMENT 'The hour number (0-24) at which this entry ends.  Yes, both 0 and 24 are possible.',
  `end_min` int(11) NOT NULL DEFAULT 0 COMMENT 'The minute number (0-59) at which this entry ends.',
  `time_zone` varchar(255) DEFAULT 'UTC' COMMENT 'The timezone in which these times apply.  ZOMG IS THIS AT ALL NEEDED?',
  `on_off` int(11) DEFAULT 0 COMMENT '1 if polling should be enabled during the timespan in this entry; 0 if it should be disabled.',
  PRIMARY KEY (`id`),
  KEY `dev_id` (`dev_id`),
  KEY `threshold_id` (`threshold_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores scheduling information for the thresholds.  This table is concerned with recurring entries.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thresholds_relativetimes`
--
-- WHERE:  1 limit 10

LOCK TABLES `thresholds_relativetimes` WRITE;
/*!40000 ALTER TABLE `thresholds_relativetimes` DISABLE KEYS */;
/*!40000 ALTER TABLE `thresholds_relativetimes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thresholds_rules`
--

DROP TABLE IF EXISTS `thresholds_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `thresholds_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `threshold_id` int(11) NOT NULL COMMENT ' foreignKey: local.thresholds.id',
  `rule_number` smallint(6) NOT NULL COMMENT 'number of the rule in the logical disjunction for the current threshold',
  `condition_id` int(11) NOT NULL COMMENT ' foreignKey: local.thresholds_conditions.id',
  `threshold_trigger_id` bigint(20) NOT NULL COMMENT ' foreignKey: local.thresholds_triggers.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `threshold_rule_condition` (`threshold_id`,`rule_number`,`condition_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='rules associated with flowfalcon thresholds';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thresholds_rules`
--
-- WHERE:  1 limit 10

LOCK TABLES `thresholds_rules` WRITE;
/*!40000 ALTER TABLE `thresholds_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `thresholds_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thresholds_service_profiles`
--

DROP TABLE IF EXISTS `thresholds_service_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `thresholds_service_profiles` (
  `threshold_id` int(11) NOT NULL COMMENT 'Threshold id',
  `service_profile_id` int(11) NOT NULL COMMENT 'The app profile id associated with the threshold.',
  PRIMARY KEY (`threshold_id`,`service_profile_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This defines the threshould-app profiles map in the system.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thresholds_service_profiles`
--
-- WHERE:  1 limit 10

LOCK TABLES `thresholds_service_profiles` WRITE;
/*!40000 ALTER TABLE `thresholds_service_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `thresholds_service_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thresholds_trapdestinations`
--

DROP TABLE IF EXISTS `thresholds_trapdestinations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `thresholds_trapdestinations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `threshold_id` int(10) DEFAULT NULL COMMENT ' foreignKey: local.thresholds.id',
  `trap_destination_id` int(10) DEFAULT NULL COMMENT ' foreignKey: net.trapdestination.id',
  `is_enabled` smallint(6) DEFAULT 0 COMMENT '1 if this trap destination should actually be used; 0 otherwise.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `threshold_key` (`threshold_id`,`trap_destination_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This lists the threshold-specific SNMP trap destinations.  This is only used for standalone thresholds.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thresholds_trapdestinations`
--
-- WHERE:  1 limit 10

LOCK TABLES `thresholds_trapdestinations` WRITE;
/*!40000 ALTER TABLE `thresholds_trapdestinations` DISABLE KEYS */;
/*!40000 ALTER TABLE `thresholds_trapdestinations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thresholds_triggers`
--

DROP TABLE IF EXISTS `thresholds_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `thresholds_triggers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `type` enum('trigger','clear') NOT NULL COMMENT 'Type of trigger condition',
  `duration` int(11) NOT NULL COMMENT 'Trigger condition after duration',
  `threshold_id` bigint(20) unsigned NOT NULL COMMENT ' foreignKey: local.thresholds.id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `treshold_condition_type` (`type`,`threshold_id`),
  KEY `threshold_id` (`threshold_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Groping of trigger or clear conditions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thresholds_triggers`
--
-- WHERE:  1 limit 10

LOCK TABLES `thresholds_triggers` WRITE;
/*!40000 ALTER TABLE `thresholds_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `thresholds_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topology_bridge_forwarding`
--

DROP TABLE IF EXISTS `topology_bridge_forwarding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `topology_bridge_forwarding` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `object_id` int(10) unsigned NOT NULL COMMENT ' foreignKey: local.device_object.id',
  `mac_address` varchar(255) NOT NULL COMMENT 'The MAC address of the connected object (may or may not be an Object in SevOne)',
  `vlan_id` varchar(255) NOT NULL COMMENT 'Unique identifier for the VLAN on which this connection was discovered',
  `port_role` enum('ACCESS','TRUNK') NOT NULL COMMENT 'Whether this entry appears to be for an Access Port or a Trunk Port',
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_key` (`object_id`,`mac_address`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This stores the bridge forwarding table used in L2 Topology Discovery.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_bridge_forwarding`
--
-- WHERE:  1 limit 10

LOCK TABLES `topology_bridge_forwarding` WRITE;
/*!40000 ALTER TABLE `topology_bridge_forwarding` DISABLE KEYS */;
/*!40000 ALTER TABLE `topology_bridge_forwarding` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topology_relationship_metadata`
--

DROP TABLE IF EXISTS `topology_relationship_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `topology_relationship_metadata` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `conn_id` bigint(20) NOT NULL COMMENT 'bitwise combination of peerid and id of owner',
  `attribute_type` varchar(256) NOT NULL COMMENT 'The type of the metadata',
  `attribute_value` varchar(256) NOT NULL COMMENT 'The value of the metadata',
  `device_id` int(11) DEFAULT NULL COMMENT 'The device id which discovered the metadata and to which it is relevant',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2783 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table defines Topology relationship''s metadata.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topology_relationship_metadata`
--
-- WHERE:  1 limit 10

LOCK TABLES `topology_relationship_metadata` WRITE;
/*!40000 ALTER TABLE `topology_relationship_metadata` DISABLE KEYS */;
INSERT INTO `topology_relationship_metadata` VALUES (2423,0,'MPLS Router Type','PE',82),(308,4294967465,'BGP Type','iBGP',223),(309,4294967466,'BGP Type','iBGP',224),(310,4294967488,'BGP Type','iBGP',209),(311,4294967489,'BGP Type','eBGP',209),(312,4294967498,'BGP Type','iBGP',210),(313,4294967499,'BGP Type','iBGP',210),(314,4294967500,'BGP Type','eBGP',210),(315,4294967506,'BGP Type','eBGP',207),(316,4294967507,'BGP Type','eBGP',207);
/*!40000 ALTER TABLE `topology_relationship_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trap_event_identifier`
--

DROP TABLE IF EXISTS `trap_event_identifier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `trap_event_identifier` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The id of the identifier',
  `trap_event_id` int(11) NOT NULL COMMENT 'The trap event with which this identifier is associated',
  `source_address` varbinary(40) DEFAULT NULL COMMENT 'The source of the identifier',
  PRIMARY KEY (`id`),
  KEY `trap_event_id` (`trap_event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Trap identifiers!';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trap_event_identifier`
--
-- WHERE:  1 limit 10

LOCK TABLES `trap_event_identifier` WRITE;
/*!40000 ALTER TABLE `trap_event_identifier` DISABLE KEYS */;
/*!40000 ALTER TABLE `trap_event_identifier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trap_event_identifier_value`
--

DROP TABLE IF EXISTS `trap_event_identifier_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `trap_event_identifier_value` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The id of the value for the trap',
  `trap_event_identifier_id` int(11) NOT NULL COMMENT 'The trap identifier id this value is associated to',
  `trap_event_key_id` int(11) NOT NULL COMMENT 'The trap event key id for this value',
  `value` varchar(255) DEFAULT NULL COMMENT 'The actual value',
  PRIMARY KEY (`id`),
  KEY `trap_event_identifier_id` (`trap_event_identifier_id`,`trap_event_key_id`,`value`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This table contains values for trap event identifier values';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trap_event_identifier_value`
--
-- WHERE:  1 limit 10

LOCK TABLES `trap_event_identifier_value` WRITE;
/*!40000 ALTER TABLE `trap_event_identifier_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `trap_event_identifier_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usagestats`
--

DROP TABLE IF EXISTS `usagestats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `usagestats` (
  `day` date DEFAULT '0000-00-00' COMMENT 'This is the day for which the entry applies.  For entries from this table''s predecessor, this value is 0 (after migration).',
  `browser` varchar(128) DEFAULT NULL COMMENT 'This is the name of the browser.  This is provided by the front-end somewhere upon login.',
  `version` varchar(128) DEFAULT NULL COMMENT 'This is the version of the browser.  This is provided by the front-end somewhere upon login.',
  `hits` int(11) DEFAULT 1 COMMENT 'This is a count of the number of times that this browser has been used for this day.',
  UNIQUE KEY `browser_by_day` (`browser`,`version`,`day`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This tracks the number of uses of a particular browser version per day.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usagestats`
--
-- WHERE:  1 limit 10

LOCK TABLES `usagestats` WRITE;
/*!40000 ALTER TABLE `usagestats` DISABLE KEYS */;
INSERT INTO `usagestats` VALUES ('2025-03-11','webkit','537.36',2),('2025-03-12','webkit','537.36',5),('2025-03-13','webkit','537.36',3),('2025-03-16','webkit','537.36',4),('2025-03-17','webkit','537.36',1),('2025-03-18','webkit','537.36',6),('2025-03-19','webkit','537.36',3),('2025-03-20','webkit','537.36',4),('2025-03-21','webkit','537.36',3),('2025-03-24','webkit','537.36',4);
/*!40000 ALTER TABLE `usagestats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilization_statistics`
--

DROP TABLE IF EXISTS `utilization_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilization_statistics` (
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Timestamp when data will be dumped in the database.',
  `device_count` int(10) DEFAULT NULL COMMENT 'Devices per peer.',
  `obj_enabled` int(10) DEFAULT NULL COMMENT 'Count of enabled object.',
  `obj_disabled` int(10) DEFAULT NULL COMMENT 'Count of disabled object.',
  `indicators_enabled` int(10) DEFAULT NULL COMMENT 'Count of enabled indicators.',
  `indicators_disabled` int(10) DEFAULT NULL COMMENT 'Count of disabled indicators.',
  `ind_per_sec` double DEFAULT NULL COMMENT 'Value of indicators per second.',
  `flow_interfaces` int(10) DEFAULT NULL COMMENT 'Count of flow interfaces.',
  `flows_per_sec` double DEFAULT NULL COMMENT 'Value of indicators per second.',
  `selfmon_device_count` int(11) DEFAULT 0,
  `group_poller_device_count` int(11) DEFAULT 0,
  `coc_device_count` int(11) DEFAULT 0,
  `managed_client_device_count` int(11) DEFAULT 0,
  `ips_capacity` int(11) DEFAULT 0,
  `objects_capacity` int(11) DEFAULT 0,
  `total_objects` int(11) DEFAULT 0,
  `flow_device_count` int(11) DEFAULT 0,
  `unknown_flow_device_count` int(11) DEFAULT 0,
  `licensed_device_count` int(11) DEFAULT 0,
  `managed_device_count` int(11) DEFAULT 0,
  `selfmon_object_count` int(11) DEFAULT 0,
  `total_flow_load` int(11) DEFAULT 0,
  `fps_capacity` int(11) DEFAULT 0,
  `flow_interface_capacity` int(11) DEFAULT 0,
  `total_fps` double DEFAULT 0,
  `total_flow_interfaces` int(11) DEFAULT 0,
  `icmp_device_count` int(11) DEFAULT 0,
  `parquet_writer_flows_per_second_net` int(11) NOT NULL DEFAULT 0,
  `logs_ingestor_aws_files_ingested_total_dropped` int(11) NOT NULL DEFAULT 0,
  `parquet_writer_flow_messages_total_dropped` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This is the table that stores the peerwise utilization information.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilization_statistics`
--
-- WHERE:  1 limit 10

LOCK TABLES `utilization_statistics` WRITE;
/*!40000 ALTER TABLE `utilization_statistics` DISABLE KEYS */;
INSERT INTO `utilization_statistics` VALUES ('2025-05-05 00:00:09',37,1999,262,27033,98,88.9,4,0,1,0,0,0,333,5000,1999,2,0,36,36,55,1200,5000,15,0,4,0,0,0,0),('2025-05-05 06:00:09',37,2000,261,27034,97,88.47,4,0,1,0,0,0,333,5000,2000,2,0,36,36,55,1200,5000,15,0,4,0,0,0,0),('2025-05-05 12:00:07',37,1999,262,27034,97,88.86,4,0,1,0,0,0,333,5000,1999,2,0,36,36,55,1200,5000,15,0,4,0,0,0,0),('2025-05-05 18:00:09',37,1999,262,27034,97,88.91,4,0,1,0,0,0,333,5000,1999,2,0,36,36,55,1200,5000,15,0,4,0,0,0,0),('2025-05-06 00:00:09',37,1999,262,27034,97,88.82,4,0,1,0,0,0,333,5000,1999,2,0,36,36,55,1200,5000,15,0,4,0,0,0,0),('2025-05-06 06:00:08',37,1999,258,27027,104,88.29,4,0,1,0,0,0,333,5000,1999,2,0,36,36,55,1200,5000,15,0,4,0,0,0,0),('2025-05-06 12:00:10',37,2000,259,27015,116,88.84,4,0,1,0,0,0,333,5000,2000,2,0,36,36,55,1200,5000,15,0,4,0,0,0,0),('2025-05-06 18:00:05',37,2000,259,27015,116,88.84,4,0,1,0,0,0,333,5000,2000,2,0,36,36,55,1200,5000,15,0,4,0,0,0,0),('2025-05-07 00:00:09',37,2000,259,27015,116,88.83,4,0,1,0,0,0,333,5000,2000,2,0,36,36,55,1200,5000,15,0,4,0,0,0,0),('2025-05-07 06:00:11',37,1999,255,27052,79,88.83,4,0,1,0,0,0,333,5000,1999,2,0,36,36,55,1200,5000,15,0,4,0,0,0,0);
/*!40000 ALTER TABLE `utilization_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vmware_sessions`
--

DROP TABLE IF EXISTS `vmware_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `vmware_sessions` (
  `dev_id` int(12) NOT NULL COMMENT ' foreignKey: net.deviceinfo.id',
  `session_id` varchar(255) DEFAULT '' COMMENT 'This is the API key.',
  PRIMARY KEY (`dev_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='This maps a Device to its VMware API key.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vmware_sessions`
--
-- WHERE:  1 limit 10

LOCK TABLES `vmware_sessions` WRITE;
/*!40000 ALTER TABLE `vmware_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `vmware_sessions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-05  7:08:20