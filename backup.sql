-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: centerbeam.proxy.rlwy.net    Database: railway
-- ------------------------------------------------------
-- Server version	9.4.0

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
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcements` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('GENERAL','ASSIGNMENT','EXAM','LECTURE','URGENT','MAINTENANCE') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GENERAL',
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `expires_at` datetime(3) DEFAULT NULL,
  `course_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `announcements_created_at_idx` (`created_at`),
  KEY `announcements_course_id_fkey` (`course_id`),
  KEY `announcements_created_by_id_fkey` (`created_by_id`),
  CONSTRAINT `announcements_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `announcements_created_by_id_fkey` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
INSERT INTO `announcements` VALUES ('cmn7hvwt8006j69k2bd3ib88y','مرحباً بكم في الفصل الدراسي الجديد','نتمنى لكم فصلاً دراسياً موفقاً. يرجى مراجعة الجداول الدراسية.','GENERAL',1,'2026-03-26 13:15:09.405',NULL,NULL,'cmn7hshfj000v69k2ofkiw9xp'),('cmnhf0in50006t6p2iaafbqt6','New Assignment: assign1','Due: 4/22/2026. ','ASSIGNMENT',0,'2026-04-02 11:52:27.233',NULL,'cmn7hsplw001p69k2g8ysko1g','cmn7hsijq000x69k2vrhzc1v9'),('cmnoafw400001fs48euxosnwn','mid advanced ai','on 18 april','GENERAL',0,'2026-04-07 07:18:49.675',NULL,'cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9'),('cmnoaj1er0005fs48u4ppop83','New Assignment: assign 1','Due: 4/15/2026. april 7','ASSIGNMENT',0,'2026-04-07 07:21:16.515',NULL,'cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9'),('cmnoaltin0009fs48d3mi67ip','New lecture: lec1','april 7','LECTURE',0,'2026-04-07 07:23:26.255',NULL,'cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9'),('cmnt8g7wu0008v49n5c59izuj','Exam Scheduled: exam1','Date: 4/11/2026. ','EXAM',0,'2026-04-10 18:21:56.622',NULL,'cmn7htxyn005969k2jmcpyf1l','cmn7hsijr000z69k2tb66jyyd'),('cmntm6snw00067amns26syofc','New Assignment: assign 1','Due: 4/12/2026. april11','ASSIGNMENT',0,'2026-04-11 00:46:31.580',NULL,'cmn7hsplw001p69k2g8ysko1g','cmn7hsijq000x69k2vrhzc1v9'),('cmntm7x4f00087amnyl57u6lo','announcement 1','april 11','GENERAL',0,'2026-04-11 00:47:24.015',NULL,'cmn7hsplw001p69k2g8ysko1g','cmn7hsijq000x69k2vrhzc1v9'),('cmntm8h43000d7amn5cxz35gt','announcement 1','aprill 11','GENERAL',0,'2026-04-11 00:47:49.923',NULL,'cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9'),('cmntm9hec000h7amn4xkhgs3k','New Assignment: assign 1','Due: 4/17/2026. aprill 11','ASSIGNMENT',0,'2026-04-11 00:48:36.948',NULL,'cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9'),('cmntma843000l7amnf9hfzt0r','New lecture: Lecture 3','april 11','LECTURE',0,'2026-04-11 00:49:11.571',NULL,'cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9'),('cmntmde6j000p7amnn7ws2al1','Exam Scheduled: exam 1','Date: 4/12/2026. april 11','EXAM',0,'2026-04-11 00:51:39.403',NULL,'cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9');
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_content`
--

DROP TABLE IF EXISTS `course_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_content` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `contentType` enum('LECTURE','MATERIAL','VIDEO','DOCUMENT','LINK') COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attachments` json DEFAULT NULL,
  `week_number` int DEFAULT NULL,
  `order_index` int NOT NULL DEFAULT '0',
  `is_published` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  `course_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `course_content_course_id_week_number_idx` (`course_id`,`week_number`),
  KEY `course_content_created_by_id_fkey` (`created_by_id`),
  CONSTRAINT `course_content_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `course_content_created_by_id_fkey` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_content`
--

LOCK TABLES `course_content` WRITE;
/*!40000 ALTER TABLE `course_content` DISABLE KEYS */;
INSERT INTO `course_content` VALUES ('cmnoalrw90007fs48ku67y14y','lec1','april 7','LECTURE',NULL,'[\"https://pub-365eed07c3dc495abbd9f6b237bf5875.r2.dev/uploads/1775546598144-511042989-Lect__2.pdf\"]',NULL,1,1,'2026-04-07 07:23:24.154','2026-04-07 07:23:24.154','cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9'),('cmntma6fb000j7amne9uxd30l','Lecture 3','april 11','LECTURE',NULL,'[\"https://pub-365eed07c3dc495abbd9f6b237bf5875.r2.dev/uploads/1775868544346-543644349-Lect__3_Which_Animal_Gave_Us_SARS.pdf\"]',NULL,2,1,'2026-04-11 00:49:09.383','2026-04-11 00:49:09.383','cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9');
/*!40000 ALTER TABLE `course_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_instructors`
--

DROP TABLE IF EXISTS `course_instructors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_instructors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `assigned_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `course_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_instructors_user_id_course_id_key` (`user_id`,`course_id`),
  KEY `course_instructors_course_id_fkey` (`course_id`),
  CONSTRAINT `course_instructors_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `course_instructors_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_instructors`
--

LOCK TABLES `course_instructors` WRITE;
/*!40000 ALTER TABLE `course_instructors` DISABLE KEYS */;
INSERT INTO `course_instructors` VALUES (73,1,'2026-03-26 13:13:55.791','cmn7hsijq000x69k2vrhzc1v9','cmn7hsplw001p69k2g8ysko1g'),(74,1,'2026-03-26 13:13:57.024','cmn7hsijr000z69k2tb66jyyd','cmn7hsq8s001r69k2sgkhpn05'),(75,1,'2026-03-26 13:13:57.845','cmn7hsijq000x69k2vrhzc1v9','cmn7hsqvt001t69k2spl6ex8b'),(76,1,'2026-03-26 13:13:58.670','cmn7hsijr000z69k2tb66jyyd','cmn7hsruq001v69k2s6ismt9o'),(77,1,'2026-03-26 13:13:59.499','cmn7hsijq000x69k2vrhzc1v9','cmn7hsshp001x69k2r2ez8eus'),(78,1,'2026-03-26 13:14:00.319','cmn7hsijr000z69k2tb66jyyd','cmn7hstaa001z69k2ge3qbndu'),(79,1,'2026-03-26 13:14:01.138','cmn7hsijq000x69k2vrhzc1v9','cmn7hsv7q002569k2iwxodylq'),(80,1,'2026-03-26 13:14:01.958','cmn7hsijr000z69k2tb66jyyd','cmn7hsvuo002769k2jzejdodb'),(81,1,'2026-03-26 13:14:02.780','cmn7hsijq000x69k2vrhzc1v9','cmn7hswhl002969k22dwbaizn'),(82,1,'2026-03-26 13:14:03.807','cmn7hsijr000z69k2tb66jyyd','cmn7hsx4q002b69k2yovviswe'),(83,1,'2026-03-26 13:14:04.629','cmn7hsijr000z69k2tb66jyyd','cmn7hstxo002169k2m4sowbn8'),(84,1,'2026-03-26 13:14:05.450','cmn7hsijr000z69k2tb66jyyd','cmn7hsuku002369k2705fxkq5'),(85,1,'2026-03-26 13:14:06.270','cmn7hsijr000z69k2tb66jyyd','cmn7ht2w1002t69k2flcq7p22'),(86,1,'2026-03-26 13:14:07.093','cmn7hsijr000z69k2tb66jyyd','cmn7ht3iv002v69k2zm9ji6ei'),(87,1,'2026-03-26 13:14:07.915','cmn7hsijr000z69k2tb66jyyd','cmn7htjja004569k2syup0hem'),(88,1,'2026-03-26 13:14:08.739','cmn7hsijr000z69k2tb66jyyd','cmn7htk62004769k2x2gvhggu'),(89,1,'2026-03-26 13:14:09.564','cmn7hsijr000z69k2tb66jyyd','cmn7htksw004969k2g4koc4v2'),(90,1,'2026-03-26 13:14:10.390','cmn7hsijr000z69k2tb66jyyd','cmn7htvj5005369k26miqgj4f'),(91,1,'2026-03-26 13:14:11.213','cmn7hsijr000z69k2tb66jyyd','cmn7htw69005569k2yq6zdzj6'),(92,1,'2026-03-26 13:14:12.036','cmn7hsijr001169k2tci45yl7','cmn7hu0km005h69k2w6qrtr34'),(93,1,'2026-03-26 13:14:12.859','cmn7hsijr001169k2tci45yl7','cmn7hu1o7005j69k273lygc67'),(94,1,'2026-03-26 13:14:13.694','cmn7hsijr001169k2tci45yl7','cmn7hu2df005l69k27z1yrvso'),(95,1,'2026-03-26 13:14:14.519','cmn7hsijr001169k2tci45yl7','cmn7hu30c005n69k2wjhjoa67'),(96,1,'2026-03-26 13:14:15.352','cmn7hsijr001169k2tci45yl7','cmn7hu3r6005p69k2mwh260ax'),(97,1,'2026-03-26 13:14:16.173','cmn7hsijr001369k2hg4izncp','cmn7hu4gy005r69k2cmlm26y0'),(98,1,'2026-03-26 13:14:16.995','cmn7hsijr001369k2hg4izncp','cmn7hu5hr005t69k2icnwnjbw'),(99,1,'2026-03-26 13:14:17.819','cmn7hsijr001369k2hg4izncp','cmn7hu6l8005v69k2ex09vhlu'),(100,1,'2026-03-26 13:14:18.639','cmn7hsijr001369k2hg4izncp','cmn7hu78m005x69k2ljbcfagq'),(101,1,'2026-03-26 13:14:19.666','cmn7hsijr001569k24ksspyax','cmn7hu92b005z69k2r4d4l0t2'),(102,1,'2026-03-26 13:14:20.495','cmn7hsijr001569k24ksspyax','cmn7hu9tz006169k2a1f8zpyi'),(103,1,'2026-03-26 13:14:21.317','cmn7hsijr001569k24ksspyax','cmn7huaq2006369k2884f9ddx'),(104,1,'2026-03-26 13:14:22.138','cmn7hsijs001769k2x5rqdhqp','cmn7hubdl006569k2o5yfvja5'),(106,1,'2026-03-26 13:14:25.796','cmn7hsijq000x69k2vrhzc1v9','cmn7hsq8s001r69k2sgkhpn05'),(107,1,'2026-03-26 13:14:27.440','cmn7hsijq000x69k2vrhzc1v9','cmn7hsruq001v69k2s6ismt9o'),(109,1,'2026-03-26 13:14:30.580','cmn7hsijq000x69k2vrhzc1v9','cmn7hstaa001z69k2ge3qbndu'),(110,1,'2026-03-26 13:14:32.229','cmn7hsijq000x69k2vrhzc1v9','cmn7hstxo002169k2m4sowbn8'),(111,1,'2026-04-02 11:40:29.656','cmn7hsijq000x69k2vrhzc1v9','cmnhel3ag0000114hi8l8syha'),(112,1,'2026-04-02 11:40:32.742','cmn7hsijq000x69k2vrhzc1v9','cmnhel6fz0001114hhqzdn415'),(113,1,'2026-04-02 11:40:35.391','cmn7hsijq000x69k2vrhzc1v9','cmnhel8hr0002114hd7drs5ql'),(114,1,'2026-04-02 11:40:38.377','cmn7hsijq000x69k2vrhzc1v9','cmnhelant0003114h152ezc1y'),(115,1,'2026-04-02 11:40:40.821','cmn7hsijq000x69k2vrhzc1v9','cmnhelcm90004114h64p9j5ps'),(116,1,'2026-04-10 18:11:34.623','cmn7hsijr000z69k2tb66jyyd','cmn7htxyn005969k2jmcpyf1l');
/*!40000 ALTER TABLE `course_instructors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_schedules`
--

DROP TABLE IF EXISTS `course_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_schedules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dayOfWeek` enum('SUNDAY','MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY') COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_time` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `end_time` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `room` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `course_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `course_schedules_course_id_fkey` (`course_id`),
  CONSTRAINT `course_schedules_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_schedules`
--

LOCK TABLES `course_schedules` WRITE;
/*!40000 ALTER TABLE `course_schedules` DISABLE KEYS */;
INSERT INTO `course_schedules` VALUES (27,'SUNDAY','08:00','09:30','Building A','Room 100','cmn7hsplw001p69k2g8ysko1g'),(28,'TUESDAY','09:45','11:15','Building A','Room 100','cmn7hsplw001p69k2g8ysko1g'),(29,'MONDAY','09:45','11:15','Building B','Room 101','cmn7hsq8s001r69k2sgkhpn05'),(30,'WEDNESDAY','11:30','13:00','Building B','Room 101','cmn7hsq8s001r69k2sgkhpn05'),(31,'TUESDAY','11:30','13:00','Labs Building','Room 102','cmn7hsruq001v69k2s6ismt9o'),(32,'THURSDAY','14:00','15:30','Labs Building','Room 102','cmn7hsruq001v69k2s6ismt9o'),(33,'WEDNESDAY','14:00','15:30','Main Hall','Room 103','cmn7hsshp001x69k2r2ez8eus'),(34,'SUNDAY','15:45','17:15','Main Hall','Room 103','cmn7hsshp001x69k2r2ez8eus'),(35,'THURSDAY','15:45','17:15','Building A','Room 104','cmn7hstaa001z69k2ge3qbndu'),(36,'MONDAY','08:00','09:30','Building A','Room 104','cmn7hstaa001z69k2ge3qbndu'),(37,'SUNDAY','08:00','09:30','Building B','Room 105','cmn7hstxo002169k2m4sowbn8'),(38,'TUESDAY','09:45','11:15','Building B','Room 105','cmn7hstxo002169k2m4sowbn8'),(39,'MONDAY','09:45','11:15','Labs Building','Room 106','cmn7hsuku002369k2705fxkq5'),(40,'WEDNESDAY','11:30','13:00','Labs Building','Room 106','cmn7hsuku002369k2705fxkq5'),(41,'TUESDAY','11:30','13:00','Main Hall','Room 107','cmn7hswhl002969k22dwbaizn'),(42,'THURSDAY','14:00','15:30','Main Hall','Room 107','cmn7hswhl002969k22dwbaizn'),(43,'WEDNESDAY','14:00','15:30','Building A','Room 108','cmn7ht2w1002t69k2flcq7p22'),(44,'SUNDAY','15:45','17:15','Building A','Room 108','cmn7ht2w1002t69k2flcq7p22'),(45,'THURSDAY','15:45','17:15','Building B','Room 109','cmn7hu0km005h69k2w6qrtr34'),(46,'MONDAY','08:00','09:30','Building B','Room 109','cmn7hu0km005h69k2w6qrtr34'),(47,'SUNDAY','08:00','09:30','Labs Building','Room 110','cmn7hu1o7005j69k273lygc67'),(48,'TUESDAY','09:45','11:15','Labs Building','Room 110','cmn7hu1o7005j69k273lygc67'),(49,'MONDAY','09:45','11:15','Main Hall','Room 111','cmn7hu2df005l69k27z1yrvso'),(50,'WEDNESDAY','11:30','13:00','Main Hall','Room 111','cmn7hu2df005l69k27z1yrvso'),(51,'TUESDAY','11:30','13:00','Building A','Room 112','cmn7hu30c005n69k2wjhjoa67'),(52,'THURSDAY','14:00','15:30','Building A','Room 112','cmn7hu30c005n69k2wjhjoa67');
/*!40000 ALTER TABLE `course_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_ar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `category` enum('COMP','MATH','CHEM','PHYS','BIO','GENERAL','ELECTIVE') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GENERAL',
  `credit_hours` int NOT NULL DEFAULT '3',
  `semester` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `academic_year` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `department_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `program_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `courses_code_key` (`code`),
  KEY `courses_department_id_idx` (`department_id`),
  KEY `courses_program_id_idx` (`program_id`),
  CONSTRAINT `courses_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `courses_program_id_fkey` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES ('cmn7hsmqk001h69k2iamo0y8t','SAFS101','Safety','الأمن والسلامة','الأمن والسلامة (Safety) - 1 credit hours','GENERAL',1,'FALL','2024-2025',1,'cmn7hsbc7000c69k24tboa2r6',NULL,'2026-03-26 13:12:36.380','2026-03-26 13:12:36.380'),('cmn7hsnp2001j69k2c2bp8afu','HURI101','Human Rights','حقوق الإنسان','حقوق الإنسان (Human Rights) - 1 credit hours','GENERAL',1,'FALL','2024-2025',1,'cmn7hsbc7000c69k24tboa2r6',NULL,'2026-03-26 13:12:37.622','2026-03-26 13:12:37.622'),('cmn7hsoby001l69k2rkkpxnc2','ENGL102','English Language 1','لغة إنجليزية 1','لغة إنجليزية 1 (English Language 1) - 2 credit hours','GENERAL',2,'FALL','2024-2025',1,'cmn7hsbc7000c69k24tboa2r6',NULL,'2026-03-26 13:12:38.446','2026-03-26 13:12:38.446'),('cmn7hsoyy001n69k222irre97','INCO102','Introduction to Computer','مدخل في الحاسب الآلي','مدخل في الحاسب الآلي (Introduction to Computer) - 1 credit hours','GENERAL',1,'FALL','2024-2025',1,'cmn7hsbc7000c69k24tboa2r6',NULL,'2026-03-26 13:12:39.273','2026-03-26 13:12:39.273'),('cmn7hsplw001p69k2g8ysko1g','MATH101','Calculus 1','تفاضل وتكامل 1','تفاضل وتكامل 1 (Calculus 1) - 4 credit hours','MATH',4,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:40.100','2026-03-26 13:12:40.100'),('cmn7hsq8s001r69k2sgkhpn05','MATH102','Calculus 2','تفاضل وتكامل 2','تفاضل وتكامل 2 (Calculus 2) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:40.924','2026-03-26 13:12:40.924'),('cmn7hsqvt001t69k2spl6ex8b','MATH104','Basic Concepts in Mathematics','مفاهيم أساسية في الرياضيات','مفاهيم أساسية في الرياضيات (Basic Concepts in Mathematics) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:41.753','2026-03-26 13:12:41.753'),('cmn7hsruq001v69k2s6ismt9o','COMP102','Introduction to Computer Science','مقدمة في الحاسب الآلي','مقدمة في الحاسب الآلي (Introduction to Computer Science) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:43.010','2026-03-26 13:12:43.010'),('cmn7hsshp001x69k2r2ez8eus','COMP104','Computer Programming 1','برمجة حاسب 1','برمجة حاسب 1 (Computer Programming 1) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:43.837','2026-03-26 13:12:43.837'),('cmn7hstaa001z69k2ge3qbndu','COMP106','Logic Design','تصميم منطق','تصميم منطق (Logic Design) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:44.662','2026-03-26 13:12:44.662'),('cmn7hstxo002169k2m4sowbn8','STAT101','Introduction to Statistics','مقدمة في الإحصاء','مقدمة في الإحصاء (Introduction to Statistics) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:45.709','2026-03-26 13:12:45.709'),('cmn7hsuku002369k2705fxkq5','STAT102','Probability Theory 1','نظرية الاحتمالات 1','نظرية الاحتمالات 1 (Probability Theory 1) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:46.542','2026-03-26 13:12:46.542'),('cmn7hsv7q002569k2iwxodylq','MATH201','Mathematical Analysis','التحليل الرياضي','التحليل الرياضي (Mathematical Analysis) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:47.366','2026-03-26 13:12:47.366'),('cmn7hsvuo002769k2jzejdodb','MATH202','Ordinary Differential Equations','معادلات تفاضلية عادية','معادلات تفاضلية عادية (Ordinary Differential Equations) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:48.192','2026-03-26 13:12:48.192'),('cmn7hswhl002969k22dwbaizn','MATH203','Linear Algebra','جبر خطي','جبر خطي (Linear Algebra) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:49.017','2026-03-26 13:12:49.017'),('cmn7hsx4q002b69k2yovviswe','MATH204','Real Analysis','تحليل حقيقي','تحليل حقيقي (Real Analysis) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:49.850','2026-03-26 13:12:49.850'),('cmn7hsxsb002d69k2k5sijztd','MATH205','Number Theory','نظرية الأعداد','نظرية الأعداد (Number Theory) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:50.700','2026-03-26 13:12:50.700'),('cmn7hsyfa002f69k2nlal9709','MATH206','Game Theory','نظرية الألعاب','نظرية الألعاب (Game Theory) - 2 credit hours','MATH',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:51.526','2026-03-26 13:12:51.526'),('cmn7hsz27002h69k2dr52bl82','MATH208','Linear Programming','البرمجة الخطية','البرمجة الخطية (Linear Programming) - 2 credit hours','MATH',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:52.352','2026-03-26 13:12:52.352'),('cmn7hszp4002j69k29lgv4g5z','MATH211','Vector Analysis','التحليل الإتجاهي وحساب الممتدات','التحليل الإتجاهي وحساب الممتدات (Vector Analysis) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:53.175','2026-03-26 13:12:53.175'),('cmn7ht0bz002l69k2nf7d1fbk','MATH212','Electromagnetic Theory','النظرية الكهرومغناطيسية','النظرية الكهرومغناطيسية (Electromagnetic Theory) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:53.999','2026-03-26 13:12:53.999'),('cmn7ht0yu002n69k2pc0wgshv','MATH213','Mechanics 2','ميكانيكا 2','ميكانيكا 2 (Mechanics 2) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:54.823','2026-03-26 13:12:54.823'),('cmn7ht1mb002p69k2fdomisa1','MATH214','Mechanics 3','ميكانيكا 3','ميكانيكا 3 (Mechanics 3) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:55.667','2026-03-26 13:12:55.667'),('cmn7ht298002r69k2ed02mw9r','MATH222','Mathematical Logic','المنطق الرياضي','المنطق الرياضي (Mathematical Logic) - 2 credit hours','MATH',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:56.492','2026-03-26 13:12:56.492'),('cmn7ht2w1002t69k2flcq7p22','STAT201','Statistical Theory 1','نظرية الإحصاء 1','نظرية الإحصاء 1 (Statistical Theory 1) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:57.314','2026-03-26 13:12:57.314'),('cmn7ht3iv002v69k2zm9ji6ei','STAT202','Statistical Theory 2','نظرية الإحصاء 2','نظرية الإحصاء 2 (Statistical Theory 2) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:58.135','2026-03-26 13:12:58.135'),('cmn7ht499002x69k2r6qy2kos','COMP201','Algorithms','تصميم وتحليل الخوارزميات','تصميم وتحليل الخوارزميات (Algorithms) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:59.086','2026-03-26 13:12:59.086'),('cmn7ht52q002z69k28pwzb4bd','COMP202','Data Structures','تراكيب البيانات','تراكيب البيانات (Data Structures) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:12:59.910','2026-03-26 13:12:59.910'),('cmn7ht5pm003169k2kkscl9gf','COMP203','Theory of Computation','نظرية الحسابات','نظرية الحسابات (Theory of Computation) - 2 credit hours','COMP',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:00.970','2026-03-26 13:13:00.970'),('cmn7ht6d4003369k207uz2v8g','COMP204','Computer Networks','شبكات الحاسب','شبكات الحاسب (Computer Networks) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:01.817','2026-03-26 13:13:01.817'),('cmn7ht7g7003569k2zvapea4m','COMP205','Computer Programming 2','برمجة حاسب 2','برمجة حاسب 2 (Computer Programming 2) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:03.223','2026-03-26 13:13:03.223'),('cmn7ht83s003769k20gfa4ds6','COMP206','Web Programming','برمجة الويب','برمجة الويب (Web Programming) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:04.072','2026-03-26 13:13:04.072'),('cmn7ht8r3003969k2u86lts4q','COMP207','Database Systems','نظم قواعد بيانات','نظم قواعد بيانات (Database Systems) - 4 credit hours','COMP',4,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:04.911','2026-03-26 13:13:04.911'),('cmn7ht9e1003b69k2sy6uitrt','COMP208','Automata Theory','نظرية الآليات الذاتية','نظرية الآليات الذاتية (Automata Theory) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:05.738','2026-03-26 13:13:05.738'),('cmn7hta0x003d69k2zj21gxrz','COMP210','Graphics Algorithms','خوارزميات الرسوم','خوارزميات الرسوم (Graphics Algorithms) - 2 credit hours','COMP',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:06.561','2026-03-26 13:13:06.561'),('cmn7htant003f69k2mc46eq40','COMP212','Advanced Computer Programming','برمجة حاسب متقدم','برمجة حاسب متقدم (Advanced Computer Programming) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:07.385','2026-03-26 13:13:07.385'),('cmn7htbji003h69k2bpywjcnm','MATH301','Abstract Algebra 1','الجبر المجرد 1','الجبر المجرد 1 (Abstract Algebra 1) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:08.526','2026-03-26 13:13:08.526'),('cmn7htc6c003j69k283if2wai','MATH302','General Topology','التوبولوجي العام','التوبولوجي العام (General Topology) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:09.348','2026-03-26 13:13:09.348'),('cmn7htcts003l69k24ne1p5hj','MATH303','Numerical Analysis','التحليل العددي','التحليل العددي (Numerical Analysis) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:10.192','2026-03-26 13:13:10.192'),('cmn7htdgn003n69k2zdmfm7gg','MATH304','Measure Theory','نظرية القياس','نظرية القياس (Measure Theory) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:11.016','2026-03-26 13:13:11.016'),('cmn7hte3k003p69k27ta8gjsw','MATH305','Differential Geometry','الهندسة التفاضلية','الهندسة التفاضلية (Differential Geometry) - 2 credit hours','MATH',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:11.840','2026-03-26 13:13:11.840'),('cmn7hteqj003r69k2u5oiljqj','MATH306','Operations Research','بحوث العمليات','بحوث العمليات (Operations Research) - 2 credit hours','MATH',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:12.667','2026-03-26 13:13:12.667'),('cmn7htfdg003t69k28o5c3vhd','MATH307','Theory of Algorithms','نظرية الخوارزميات','نظرية الخوارزميات (Theory of Algorithms) - 2 credit hours','MATH',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:13.492','2026-03-26 13:13:13.492'),('cmn7htg0c003v69k2g7axxqoc','MATH311','Continuum Mechanics','ميكانيكا الأوساط المتصلة','ميكانيكا الأوساط المتصلة (Continuum Mechanics) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:14.316','2026-03-26 13:13:14.316'),('cmn7htgnd003x69k2xk5p9zr1','MATH313','Quantum Mechanics 1','ميكانيكا الكم 1','ميكانيكا الكم 1 (Quantum Mechanics 1) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:15.145','2026-03-26 13:13:15.145'),('cmn7hthfx003z69k2gzt0u8fs','MATH314','Quantum Mechanics 2','ميكانيكا الكم 2','ميكانيكا الكم 2 (Quantum Mechanics 2) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:15.969','2026-03-26 13:13:15.969'),('cmn7hti2t004169k24dkpx9np','MATH319','Principles of Mathematical Modeling','مبادئ النمذجة الرياضية','مبادئ النمذجة الرياضية (Principles of Mathematical Modeling) - 2 credit hours','MATH',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:16.997','2026-03-26 13:13:16.997'),('cmn7htipr004369k2c6tjl1vi','MATH331','Calculus of Variations','مبادئ حساب التغيرات','مبادئ حساب التغيرات (Calculus of Variations) - 2 credit hours','MATH',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:17.823','2026-03-26 13:13:17.823'),('cmn7htjja004569k2syup0hem','STAT301','Statistical Inference 1','استدلال إحصائي 1','استدلال إحصائي 1 (Statistical Inference 1) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:18.886','2026-03-26 13:13:18.886'),('cmn7htk62004769k2x2gvhggu','STAT302','Statistical Inference 2','استدلال إحصائي 2','استدلال إحصائي 2 (Statistical Inference 2) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:19.707','2026-03-26 13:13:19.707'),('cmn7htksw004969k2g4koc4v2','STAT303','Stochastic Processes 1','عمليات عشوائية 1','عمليات عشوائية 1 (Stochastic Processes 1) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:20.529','2026-03-26 13:13:20.529'),('cmn7htlfq004b69k2ryrfzuiy','COMP301','Advanced Programming','برمجة متقدمة','برمجة متقدمة (Advanced Programming) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:21.350','2026-03-26 13:13:21.350'),('cmn7htm2n004d69k2msfe7tow','COMP302','Algorithmic Combinatorics','تألفيات خوارزمية','تألفيات خوارزمية (Algorithmic Combinatorics) - 2 credit hours','COMP',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:22.175','2026-03-26 13:13:22.175'),('cmn7htmpk004f69k2v8mtiw54','COMP303','Programming Language Syntax','قواعد ودلالات لغات البرمجة','قواعد ودلالات لغات البرمجة (Programming Language Syntax) - 2 credit hours','COMP',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:23.000','2026-03-26 13:13:23.000'),('cmn7htnov004h69k28r47cxkv','COMP304','Compiler Design','تصميم مؤلفات','تصميم مؤلفات (Compiler Design) - 2 credit hours','COMP',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:24.271','2026-03-26 13:13:24.271'),('cmn7htobq004j69k2ucizocup','COMP305','Complexity Theory','نظرية التعقد','نظرية التعقد (Complexity Theory) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:25.094','2026-03-26 13:13:25.094'),('cmn7htoyn004l69k20ewoib3g','COMP306','Computer Graphics','رسومات الحاسب','رسومات الحاسب (Computer Graphics) - 2 credit hours','COMP',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:25.919','2026-03-26 13:13:25.919'),('cmn7htplw004n69k2ep8cvvca','COMP307','Operating Systems','نظم تشغيل','نظم تشغيل (Operating Systems) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:26.757','2026-03-26 13:13:26.757'),('cmn7htq8s004p69k23jztctm2','COMP308','Cryptography','تشفير','تشفير (Cryptography) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:27.580','2026-03-26 13:13:27.580'),('cmn7htqvm004r69k256adx7az','COMP309','Multimedia Systems','نظم الوسائط المتعددة','نظم الوسائط المتعددة (Multimedia Systems) - 2 credit hours','COMP',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:28.403','2026-03-26 13:13:28.403'),('cmn7htrih004t69k20mb3pn4l','COMP311','Declarative Languages','اللغات التصريحية','اللغات التصريحية (Declarative Languages) - 2 credit hours','COMP',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:29.226','2026-03-26 13:13:29.226'),('cmn7htsmc004v69k2o0bunoh4','MATH401','Functional Analysis','التحليل الدالي','التحليل الدالي (Functional Analysis) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:30.661','2026-03-26 13:13:30.661'),('cmn7htteu004x69k2wv9t9dxm','MATH402','Abstract Algebra 2','الجبر المجرد 2','الجبر المجرد 2 (Abstract Algebra 2) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:31.481','2026-03-26 13:13:31.481'),('cmn7htu1o004z69k2dyuds7lr','MATH403','Complex Analysis','التحليل المركب','التحليل المركب (Complex Analysis) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:32.508','2026-03-26 13:13:32.508'),('cmn7htuoj005169k2461zeil0','MATH404','Partial Differential Equations','المعادلات التفاضلية الجزئية','المعادلات التفاضلية الجزئية (Partial Differential Equations) - 3 credit hours','MATH',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:33.331','2026-03-26 13:13:33.331'),('cmn7htvj5005369k26miqgj4f','STAT405','Design and Analysis of Experiments','تصميم وتحليل التجارب','تصميم وتحليل التجارب (Design and Analysis of Experiments) - 4 credit hours','MATH',4,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:34.433','2026-03-26 13:13:34.433'),('cmn7htw69005569k2yq6zdzj6','STAT415','Multivariate Statistical Analysis','تحليل إحصائي متعدد','تحليل إحصائي متعدد (Multivariate Statistical Analysis) - 2 credit hours','MATH',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:35.265','2026-03-26 13:13:35.265'),('cmn7htxbt005769k2ldw48aln','COMP401','Artificial Intelligence','ذكاء اصطناعي','ذكاء اصطناعي (Artificial Intelligence) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:36.762','2026-03-26 13:13:36.762'),('cmn7htxyn005969k2jmcpyf1l','COMP402','Bioinformatics','المعلوماتية الحيوية','المعلوماتية الحيوية (Bioinformatics) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:37.583','2026-03-26 13:13:37.583'),('cmn7htym1005b69k2apwrsnnk','COMP403','Parallel and Distributed Processing','المعالجة المتوازية والموزعة','المعالجة المتوازية والموزعة (Parallel and Distributed Processing) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:38.426','2026-03-26 13:13:38.426'),('cmn7htza5005d69k2pwn5ukb0','COMP404','Software Engineering','هندسة البرمجيات','هندسة البرمجيات (Software Engineering) - 2 credit hours','COMP',2,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:39.294','2026-03-26 13:13:39.294'),('cmn7htzxt005f69k2tx01g29w','COMP407','Image Processing','معالجة الصور','معالجة الصور (Image Processing) - 3 credit hours','COMP',3,'FALL','2024-2025',1,'cmn7hsbc7000269k28r4wrma7',NULL,'2026-03-26 13:13:40.145','2026-03-26 13:13:40.145'),('cmn7hu0km005h69k2w6qrtr34','PHYS101','General Physics 1','فيزياء عامة 1','فيزياء عامة 1 (General Physics 1) - 4 credit hours','PHYS',4,'FALL','2024-2025',1,'cmn7hsbc7000469k2xnga0qiw',NULL,'2026-03-26 13:13:40.966','2026-03-26 13:13:40.966'),('cmn7hu1o7005j69k273lygc67','PHYS102','General Physics 3','فيزياء عامة 3','فيزياء عامة 3 (General Physics 3) - 3 credit hours','PHYS',3,'FALL','2024-2025',1,'cmn7hsbc7000469k2xnga0qiw',NULL,'2026-03-26 13:13:42.391','2026-03-26 13:13:42.391'),('cmn7hu2df005l69k27z1yrvso','PHYS103','General Physics 2','فيزياء عامة 2','فيزياء عامة 2 (General Physics 2) - 3 credit hours','PHYS',3,'FALL','2024-2025',1,'cmn7hsbc7000469k2xnga0qiw',NULL,'2026-03-26 13:13:43.299','2026-03-26 13:13:43.299'),('cmn7hu30c005n69k2wjhjoa67','PHYS104','General Physics 4','فيزياء عامة 4','فيزياء عامة 4 (General Physics 4) - 3 credit hours','PHYS',3,'FALL','2024-2025',1,'cmn7hsbc7000469k2xnga0qiw',NULL,'2026-03-26 13:13:44.124','2026-03-26 13:13:44.124'),('cmn7hu3r6005p69k2mwh260ax','PHYS201','Modern Physics 1','فيزياء حديثة 1','فيزياء حديثة 1 (Modern Physics 1) - 2 credit hours','PHYS',2,'FALL','2024-2025',1,'cmn7hsbc7000469k2xnga0qiw',NULL,'2026-03-26 13:13:45.091','2026-03-26 13:13:45.091'),('cmn7hu4gy005r69k2cmlm26y0','CHEM101','General Chemistry 1','كيمياء عامة 1','كيمياء عامة 1 (General Chemistry 1) - 3 credit hours','CHEM',3,'FALL','2024-2025',1,'cmn7hsbc7000669k2fz6x4kyb',NULL,'2026-03-26 13:13:46.018','2026-03-26 13:13:46.018'),('cmn7hu5hr005t69k2icnwnjbw','CHEM102','General Chemistry 2','كيمياء عامة 2','كيمياء عامة 2 (General Chemistry 2) - 3 credit hours','CHEM',3,'FALL','2024-2025',1,'cmn7hsbc7000669k2fz6x4kyb',NULL,'2026-03-26 13:13:46.842','2026-03-26 13:13:46.842'),('cmn7hu6l8005v69k2ex09vhlu','CHEM211','Organic Chemistry 1','كيمياء عضوية 1','كيمياء عضوية 1 (Organic Chemistry 1) - 2 credit hours','CHEM',2,'FALL','2024-2025',1,'cmn7hsbc7000669k2fz6x4kyb',NULL,'2026-03-26 13:13:48.764','2026-03-26 13:13:48.764'),('cmn7hu78m005x69k2ljbcfagq','CHEM222','Inorganic Chemistry 1','كيمياء غير عضوية 1','كيمياء غير عضوية 1 (Inorganic Chemistry 1) - 2 credit hours','CHEM',2,'FALL','2024-2025',1,'cmn7hsbc7000669k2fz6x4kyb',NULL,'2026-03-26 13:13:49.606','2026-03-26 13:13:49.606'),('cmn7hu92b005z69k2r4d4l0t2','BOTA101','Fundamentals of Botany 1','أساسيات علم النبات 1','أساسيات علم النبات 1 (Fundamentals of Botany 1) - 3 credit hours','BIO',3,'FALL','2024-2025',1,'cmn7hsbc7000869k2yxgb8jod',NULL,'2026-03-26 13:13:51.971','2026-03-26 13:13:51.971'),('cmn7hu9tz006169k2a1f8zpyi','ZOOL101','Zoology 1','علم الحيوان 1','علم الحيوان 1 (Zoology 1) - 2 credit hours','BIO',2,'FALL','2024-2025',1,'cmn7hsbc7000869k2yxgb8jod',NULL,'2026-03-26 13:13:52.967','2026-03-26 13:13:52.967'),('cmn7huaq2006369k2884f9ddx','MICR102','Microbiology','ميكروبيولوجي','ميكروبيولوجي (Microbiology) - 2 credit hours','BIO',2,'FALL','2024-2025',1,'cmn7hsbc7000869k2yxgb8jod',NULL,'2026-03-26 13:13:54.122','2026-03-26 13:13:54.122'),('cmn7hubdl006569k2o5yfvja5','GEOL101','Physical Geology','جيولوجيا طبيعية','جيولوجيا طبيعية (Physical Geology) - 3 credit hours','GENERAL',3,'FALL','2024-2025',1,'cmn7hsbc7000a69k2p0t7rthm',NULL,'2026-03-26 13:13:54.969','2026-03-26 13:13:54.969'),('cmnhbowzt0001gju07tok1siv','COMP406','Computer Project (B)','Computer Project (B)',NULL,'COMP',3,'current','2026',1,NULL,NULL,'2026-04-02 10:19:27.113','2026-04-02 10:19:27.113'),('cmnhbp1lm0002gju0b1fbsnhv','COMP408','Advanced AI Topics','Advanced AI Topics',NULL,'COMP',3,'current','2026',1,NULL,NULL,'2026-04-02 10:19:33.083','2026-04-02 10:19:33.083'),('cmnhbp6mn0003gju0z1o19wme','COMP416','Data & Web Mining','Data & Web Mining',NULL,'COMP',3,'current','2026',1,NULL,NULL,'2026-04-02 10:19:39.374','2026-04-02 10:19:39.374'),('cmnhel3ag0000114hi8l8syha','COMP 402','Bioinformatics',NULL,'Introduction to Bioinformatics - sequence analysis, alignment algorithms, and biological databases.','COMP',3,NULL,NULL,1,NULL,NULL,'2026-04-02 11:40:27.496','2026-04-02 11:40:27.496'),('cmnhel6fz0001114hhqzdn415','COMP 404','Software Engineering',NULL,'Software development lifecycle, design patterns, testing, and project management.','COMP',3,NULL,NULL,1,NULL,NULL,'2026-04-02 11:40:31.583','2026-04-02 11:40:31.583'),('cmnhel8hr0002114hd7drs5ql','COMP 406','Computer Project (B)',NULL,'Individual graduation project in computer science.','COMP',3,NULL,NULL,1,NULL,NULL,'2026-04-02 11:40:34.239','2026-04-02 11:40:34.239'),('cmnhelant0003114h152ezc1y','COMP 408','Advanced AI Topics',NULL,'Deep learning, NLP, computer vision, and reinforcement learning.','COMP',3,NULL,NULL,1,NULL,NULL,'2026-04-02 11:40:37.050','2026-04-02 11:40:37.050'),('cmnhelcm90004114h64p9j5ps','COMP 416','Data & Web Mining',NULL,'Data mining techniques, web scraping, clustering, and classification.','COMP',3,NULL,NULL,1,NULL,NULL,'2026-04-02 11:40:39.585','2026-04-02 11:40:39.585'),('cmnp6gpmh0002trz2tyr3f87c','COMP418','Computer Project (Double Major)','Computer Project (Double Major)',NULL,'COMP',3,'current','2026',1,NULL,NULL,'2026-04-07 22:15:15.640','2026-04-07 22:15:15.640'),('cmnp6gsqv0003trz22r6uz1c2','STAT408','Time Series','Time Series',NULL,'GENERAL',3,'current','2026',1,NULL,NULL,'2026-04-07 22:15:19.687','2026-04-07 22:15:19.687'),('cmnp6gvj30004trz287czkcf3','STAT412','Queueing Theory','Queueing Theory',NULL,'GENERAL',3,'current','2026',1,NULL,NULL,'2026-04-07 22:15:23.295','2026-04-07 22:15:23.295'),('cmnp6gy880005trz2k06e932a','STAT418','Stochastic Processes (2)','Stochastic Processes (2)',NULL,'GENERAL',3,'current','2026',1,NULL,NULL,'2026-04-07 22:15:26.793','2026-04-07 22:15:26.793'),('cmnp6h12a0006trz2j9sd5zkg','STAT424','Statistics Research Project','Statistics Research Project',NULL,'GENERAL',3,'current','2026',1,NULL,NULL,'2026-04-07 22:15:30.254','2026-04-07 22:15:30.254');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_ar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `faculty_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `departments_code_key` (`code`),
  UNIQUE KEY `departments_faculty_id_name_key` (`faculty_id`,`name`),
  CONSTRAINT `departments_faculty_id_fkey` FOREIGN KEY (`faculty_id`) REFERENCES `faculties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES ('cmn7hsbc7000269k28r4wrma7','Mathematics Department','قسم الرياضيات','MATH',NULL,'cmn7hsa87000069k2j7wa4zsz','2026-03-26 13:12:21.401','2026-03-26 13:12:21.401'),('cmn7hsbc7000469k2xnga0qiw','Physics Department','قسم الفيزياء','PHYS',NULL,'cmn7hsa87000069k2j7wa4zsz','2026-03-26 13:12:21.401','2026-03-26 13:12:21.401'),('cmn7hsbc7000669k2fz6x4kyb','Chemistry Department','قسم الكيمياء','CHEM',NULL,'cmn7hsa87000069k2j7wa4zsz','2026-03-26 13:12:21.401','2026-03-26 13:12:21.401'),('cmn7hsbc7000869k2yxgb8jod','Biology Department','قسم الأحياء','BIO',NULL,'cmn7hsa87000069k2j7wa4zsz','2026-03-26 13:12:21.401','2026-03-26 13:12:21.401'),('cmn7hsbc7000a69k2p0t7rthm','Geology Department','قسم الجيولوجيا','GEOL',NULL,'cmn7hsa87000069k2j7wa4zsz','2026-03-26 13:12:21.401','2026-03-26 13:12:21.401'),('cmn7hsbc7000c69k24tboa2r6','University Requirements','متطلبات الجامعة','UNIV',NULL,'cmn7hsa87000069k2j7wa4zsz','2026-03-26 13:12:21.401','2026-03-26 13:12:21.401');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('ENROLLED','COMPLETED','DROPPED','WITHDRAWN','FAILED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ENROLLED',
  `enrolled_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `completed_at` datetime(3) DEFAULT NULL,
  `grade` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `grade_points` double DEFAULT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `course_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `enrollments_user_id_course_id_key` (`user_id`,`course_id`),
  KEY `enrollments_user_id_idx` (`user_id`),
  KEY `enrollments_course_id_idx` (`course_id`),
  KEY `enrollments_status_idx` (`status`),
  CONSTRAINT `enrollments_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `enrollments_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments`
--

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
INSERT INTO `enrollments` VALUES (43,'ENROLLED','2026-03-26 13:14:22.957',NULL,NULL,NULL,'cmn7hsl8x001b69k2mkgmtzu4','cmn7hsplw001p69k2g8ysko1g'),(44,'ENROLLED','2026-03-26 13:14:24.947',NULL,NULL,NULL,'cmn7hsl8x001b69k2mkgmtzu4','cmn7hsq8s001r69k2sgkhpn05'),(45,'ENROLLED','2026-03-26 13:14:26.617',NULL,NULL,NULL,'cmn7hsl8x001b69k2mkgmtzu4','cmn7hsruq001v69k2s6ismt9o'),(46,'ENROLLED','2026-03-26 13:14:28.277',NULL,NULL,NULL,'cmn7hsl8x001b69k2mkgmtzu4','cmn7hsshp001x69k2r2ez8eus'),(47,'ENROLLED','2026-03-26 13:14:29.713',NULL,NULL,NULL,'cmn7hsl8x001b69k2mkgmtzu4','cmn7hstaa001z69k2ge3qbndu'),(48,'ENROLLED','2026-03-26 13:14:31.405',NULL,NULL,NULL,'cmn7hsl8x001b69k2mkgmtzu4','cmn7hstxo002169k2m4sowbn8'),(49,'ENROLLED','2026-03-26 13:14:33.050',NULL,NULL,NULL,'cmn7hsl8y001d69k2pv332tsh','cmn7hsplw001p69k2g8ysko1g'),(50,'ENROLLED','2026-03-26 13:14:33.872',NULL,NULL,NULL,'cmn7hsl8y001d69k2pv332tsh','cmn7hstxo002169k2m4sowbn8'),(51,'ENROLLED','2026-03-26 13:14:34.895',NULL,NULL,NULL,'cmn7hsl8y001d69k2pv332tsh','cmn7hsuku002369k2705fxkq5'),(52,'ENROLLED','2026-03-26 13:14:35.713',NULL,NULL,NULL,'cmn7hsl8y001d69k2pv332tsh','cmn7hswhl002969k22dwbaizn'),(53,'ENROLLED','2026-03-26 13:14:36.532',NULL,NULL,NULL,'cmn7hsl8y001d69k2pv332tsh','cmn7ht2w1002t69k2flcq7p22'),(54,'ENROLLED','2026-03-26 13:14:37.352',NULL,NULL,NULL,'cmn7hsl8y001f69k2ir111q8c','cmn7hsplw001p69k2g8ysko1g'),(55,'ENROLLED','2026-03-26 13:14:38.179',NULL,NULL,NULL,'cmn7hsl8y001f69k2ir111q8c','cmn7hu0km005h69k2w6qrtr34'),(56,'ENROLLED','2026-03-26 13:14:39.001',NULL,NULL,NULL,'cmn7hsl8y001f69k2ir111q8c','cmn7hu1o7005j69k273lygc67'),(57,'ENROLLED','2026-03-26 13:14:39.821',NULL,NULL,NULL,'cmn7hsl8y001f69k2ir111q8c','cmn7hu2df005l69k27z1yrvso'),(58,'ENROLLED','2026-03-26 13:14:40.661',NULL,NULL,NULL,'cmn7hsl8y001f69k2ir111q8c','cmn7hu30c005n69k2wjhjoa67'),(59,'ENROLLED','2026-04-02 10:19:16.987',NULL,NULL,NULL,'cmnhboj1z0000gju0zh9yfsnc','cmn7htxyn005969k2jmcpyf1l'),(60,'ENROLLED','2026-04-02 10:19:22.171',NULL,NULL,NULL,'cmnhboj1z0000gju0zh9yfsnc','cmn7htza5005d69k2pwn5ukb0'),(61,'ENROLLED','2026-04-02 10:19:29.107',NULL,NULL,NULL,'cmnhboj1z0000gju0zh9yfsnc','cmnhbowzt0001gju07tok1siv'),(62,'ENROLLED','2026-04-02 10:19:34.563',NULL,NULL,NULL,'cmnhboj1z0000gju0zh9yfsnc','cmnhbp1lm0002gju0b1fbsnhv'),(63,'ENROLLED','2026-04-02 10:19:40.545',NULL,NULL,NULL,'cmnhboj1z0000gju0zh9yfsnc','cmnhbp6mn0003gju0z1o19wme'),(64,'ENROLLED','2026-04-03 14:56:54.854',NULL,NULL,NULL,'cmnj11d3x0000lvpkuh3pprhm','cmn7htxyn005969k2jmcpyf1l'),(65,'ENROLLED','2026-04-03 14:57:01.144',NULL,NULL,NULL,'cmnj11d3x0000lvpkuh3pprhm','cmn7htza5005d69k2pwn5ukb0'),(66,'ENROLLED','2026-04-03 14:57:04.351',NULL,NULL,NULL,'cmnj11d3x0000lvpkuh3pprhm','cmnhbowzt0001gju07tok1siv'),(67,'ENROLLED','2026-04-03 14:57:07.013',NULL,NULL,NULL,'cmnj11d3x0000lvpkuh3pprhm','cmnhbp1lm0002gju0b1fbsnhv'),(68,'ENROLLED','2026-04-03 14:57:09.564',NULL,NULL,NULL,'cmnj11d3x0000lvpkuh3pprhm','cmnhbp6mn0003gju0z1o19wme'),(69,'ENROLLED','2026-04-07 22:06:19.798',NULL,NULL,NULL,'cmnp651zw0000trz2xdlzmj2g','cmn7htxyn005969k2jmcpyf1l'),(70,'ENROLLED','2026-04-07 22:06:24.011',NULL,NULL,NULL,'cmnp651zw0000trz2xdlzmj2g','cmn7htza5005d69k2pwn5ukb0'),(71,'ENROLLED','2026-04-07 22:06:27.309',NULL,NULL,NULL,'cmnp651zw0000trz2xdlzmj2g','cmnhbowzt0001gju07tok1siv'),(72,'ENROLLED','2026-04-07 22:06:30.065',NULL,NULL,NULL,'cmnp651zw0000trz2xdlzmj2g','cmnhbp1lm0002gju0b1fbsnhv'),(73,'ENROLLED','2026-04-07 22:06:33.152',NULL,NULL,NULL,'cmnp651zw0000trz2xdlzmj2g','cmnhbp6mn0003gju0z1o19wme'),(74,'ENROLLED','2026-04-07 22:15:06.909',NULL,NULL,NULL,'cmnp6ge1y0001trz23lr3fh73','cmn7htxyn005969k2jmcpyf1l'),(75,'ENROLLED','2026-04-07 22:15:10.034',NULL,NULL,NULL,'cmnp6ge1y0001trz23lr3fh73','cmn7htym1005b69k2apwrsnnk'),(76,'ENROLLED','2026-04-07 22:15:12.507',NULL,NULL,NULL,'cmnp6ge1y0001trz23lr3fh73','cmnhbp6mn0003gju0z1o19wme'),(77,'ENROLLED','2026-04-07 22:15:17.002',NULL,NULL,NULL,'cmnp6ge1y0001trz23lr3fh73','cmnp6gpmh0002trz2tyr3f87c'),(78,'ENROLLED','2026-04-07 22:15:20.575',NULL,NULL,NULL,'cmnp6ge1y0001trz23lr3fh73','cmnp6gsqv0003trz22r6uz1c2'),(79,'ENROLLED','2026-04-07 22:15:24.181',NULL,NULL,NULL,'cmnp6ge1y0001trz23lr3fh73','cmnp6gvj30004trz287czkcf3'),(80,'ENROLLED','2026-04-07 22:15:27.659',NULL,NULL,NULL,'cmnp6ge1y0001trz23lr3fh73','cmnp6gy880005trz2k06e932a'),(81,'ENROLLED','2026-04-07 22:15:31.326',NULL,NULL,NULL,'cmnp6ge1y0001trz23lr3fh73','cmnp6h12a0006trz2j9sd5zkg'),(82,'ENROLLED','2026-04-09 07:17:10.776',NULL,NULL,NULL,'cmnhox6gs0000hjjm4x9q1t8m','cmn7htnov004h69k28r47cxkv'),(83,'ENROLLED','2026-04-09 07:17:15.502',NULL,NULL,NULL,'cmnhox6gs0000hjjm4x9q1t8m','cmn7htxyn005969k2jmcpyf1l'),(84,'ENROLLED','2026-04-09 07:17:17.979',NULL,NULL,NULL,'cmnhox6gs0000hjjm4x9q1t8m','cmn7htza5005d69k2pwn5ukb0'),(85,'ENROLLED','2026-04-09 07:17:20.935',NULL,NULL,NULL,'cmnhox6gs0000hjjm4x9q1t8m','cmnhbowzt0001gju07tok1siv'),(86,'ENROLLED','2026-04-09 07:17:23.194',NULL,NULL,NULL,'cmnhox6gs0000hjjm4x9q1t8m','cmnhbp1lm0002gju0b1fbsnhv'),(87,'ENROLLED','2026-04-09 07:17:25.453',NULL,NULL,NULL,'cmnhox6gs0000hjjm4x9q1t8m','cmnhbp6mn0003gju0z1o19wme'),(88,'ENROLLED','2026-04-10 23:42:59.182',NULL,NULL,NULL,'cmntjwy810000xr52coryl23v','cmn7htxyn005969k2jmcpyf1l'),(89,'ENROLLED','2026-04-10 23:43:02.421',NULL,NULL,NULL,'cmntjwy810000xr52coryl23v','cmn7htza5005d69k2pwn5ukb0'),(90,'ENROLLED','2026-04-10 23:43:05.101',NULL,NULL,NULL,'cmntjwy810000xr52coryl23v','cmnhbowzt0001gju07tok1siv'),(91,'ENROLLED','2026-04-10 23:43:07.867',NULL,NULL,NULL,'cmntjwy810000xr52coryl23v','cmnhbp1lm0002gju0b1fbsnhv'),(92,'ENROLLED','2026-04-10 23:43:10.326',NULL,NULL,NULL,'cmntjwy810000xr52coryl23v','cmnhbp6mn0003gju0z1o19wme');
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculties`
--

DROP TABLE IF EXISTS `faculties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faculties` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_ar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `faculties_name_key` (`name`),
  UNIQUE KEY `faculties_code_key` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculties`
--

LOCK TABLES `faculties` WRITE;
/*!40000 ALTER TABLE `faculties` DISABLE KEYS */;
INSERT INTO `faculties` VALUES ('cmn7hsa87000069k2j7wa4zsz','Faculty of Science','كلية العلوم','SCI','Faculty of Science at Egyptian University','2026-03-26 13:12:20.167','2026-03-26 13:12:20.167');
/*!40000 ALTER TABLE `faculties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('GENERAL','ANNOUNCEMENT','ASSIGNMENT','EXAM','GRADE','REMINDER','SYSTEM') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GENERAL',
  `reference_type` enum('ANNOUNCEMENT','TASK','COURSE','CONTENT') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `is_pushed` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `read_at` datetime(3) DEFAULT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_user_id_is_read_idx` (`user_id`,`is_read`),
  KEY `notifications_created_at_idx` (`created_at`),
  CONSTRAINT `notifications_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES ('cmnhf0guc0002t6p2t2qqpdef','New Assignment: assign1','MATH101 - Due: 4/22/2026','ASSIGNMENT','TASK','cmnhf0ezi0001t6p2njhms22c',0,0,'2026-04-02 11:52:24.900',NULL,'cmn7hsl8x001b69k2mkgmtzu4'),('cmnhf0guc0003t6p2jbq2ns6j','New Assignment: assign1','MATH101 - Due: 4/22/2026','ASSIGNMENT','TASK','cmnhf0ezi0001t6p2njhms22c',0,0,'2026-04-02 11:52:24.900',NULL,'cmn7hsl8y001d69k2pv332tsh'),('cmnhf0guc0004t6p2dr4ifr8e','New Assignment: assign1','MATH101 - Due: 4/22/2026','ASSIGNMENT','TASK','cmnhf0ezi0001t6p2njhms22c',0,0,'2026-04-02 11:52:24.900',NULL,'cmn7hsl8y001f69k2ir111q8c'),('cmnt8g6ki0002v49nj8lfnftu','Exam Scheduled: exam1','COMP402 - Date: 4/11/2026','EXAM','TASK','cmnt8g55t0001v49nclp2ib46',0,0,'2026-04-10 18:21:54.882',NULL,'cmnhboj1z0000gju0zh9yfsnc'),('cmnt8g6ki0003v49nym18u8aj','Exam Scheduled: exam1','COMP402 - Date: 4/11/2026','EXAM','TASK','cmnt8g55t0001v49nclp2ib46',0,0,'2026-04-10 18:21:54.882',NULL,'cmnj11d3x0000lvpkuh3pprhm'),('cmnt8g6ki0004v49nvpz5aj6d','Exam Scheduled: exam1','COMP402 - Date: 4/11/2026','EXAM','TASK','cmnt8g55t0001v49nclp2ib46',0,0,'2026-04-10 18:21:54.882',NULL,'cmnp651zw0000trz2xdlzmj2g'),('cmnt8g6ki0005v49ns43a2wme','Exam Scheduled: exam1','COMP402 - Date: 4/11/2026','EXAM','TASK','cmnt8g55t0001v49nclp2ib46',0,0,'2026-04-10 18:21:54.882',NULL,'cmnp6ge1y0001trz23lr3fh73'),('cmnt8g6ki0006v49nmtvspjnf','Exam Scheduled: exam1','COMP402 - Date: 4/11/2026','EXAM','TASK','cmnt8g55t0001v49nclp2ib46',0,0,'2026-04-10 18:21:54.882',NULL,'cmnhox6gs0000hjjm4x9q1t8m'),('cmntm6r9w00027amnrd6oacdz','New Assignment: assign 1','MATH101 - Due: 4/12/2026','ASSIGNMENT','TASK','cmntm6ptf00017amnflcvuai8',0,0,'2026-04-11 00:46:29.781',NULL,'cmn7hsl8x001b69k2mkgmtzu4'),('cmntm6r9w00037amnbok8z1fn','New Assignment: assign 1','MATH101 - Due: 4/12/2026','ASSIGNMENT','TASK','cmntm6ptf00017amnflcvuai8',0,0,'2026-04-11 00:46:29.781',NULL,'cmn7hsl8y001d69k2pv332tsh'),('cmntm6r9w00047amntm2mogwq','New Assignment: assign 1','MATH101 - Due: 4/12/2026','ASSIGNMENT','TASK','cmntm6ptf00017amnflcvuai8',0,0,'2026-04-11 00:46:29.781',NULL,'cmn7hsl8y001f69k2ir111q8c'),('cmntm7yaw00097amnu881jvu9','📢 announcement 1','april 11','ANNOUNCEMENT','ANNOUNCEMENT','cmntm7x4f00087amnyl57u6lo',0,0,'2026-04-11 00:47:25.545',NULL,'cmn7hsl8x001b69k2mkgmtzu4'),('cmntm7yaw000a7amnmlschlhl','📢 announcement 1','april 11','ANNOUNCEMENT','ANNOUNCEMENT','cmntm7x4f00087amnyl57u6lo',0,0,'2026-04-11 00:47:25.545',NULL,'cmn7hsl8y001d69k2pv332tsh'),('cmntm7yaw000b7amn0fmmtj1p','📢 announcement 1','april 11','ANNOUNCEMENT','ANNOUNCEMENT','cmntm7x4f00087amnyl57u6lo',0,0,'2026-04-11 00:47:25.545',NULL,'cmn7hsl8y001f69k2ir111q8c');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_instructors`
--

DROP TABLE IF EXISTS `program_instructors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_instructors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assigned_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `professor_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `program_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `program_instructors_professor_id_program_id_key` (`professor_id`,`program_id`),
  KEY `program_instructors_program_id_fkey` (`program_id`),
  CONSTRAINT `program_instructors_professor_id_fkey` FOREIGN KEY (`professor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `program_instructors_program_id_fkey` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_instructors`
--

LOCK TABLES `program_instructors` WRITE;
/*!40000 ALTER TABLE `program_instructors` DISABLE KEYS */;
/*!40000 ALTER TABLE `program_instructors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programs` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_ar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `credit_hours` int NOT NULL DEFAULT '132',
  `department_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `programs_code_key` (`code`),
  UNIQUE KEY `programs_department_id_name_key` (`department_id`,`name`),
  CONSTRAINT `programs_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
INSERT INTO `programs` VALUES ('cmn7hsdvn000e69k2i7x4v7n5','Computer Science','علوم الحاسب','CS',NULL,136,'cmn7hsbc7000269k28r4wrma7','2026-03-26 13:12:24.694','2026-03-26 13:12:24.694'),('cmn7hsdvn000g69k27kp0egvk','Statistics','الإحصاء','STAT',NULL,132,'cmn7hsbc7000269k28r4wrma7','2026-03-26 13:12:24.694','2026-03-26 13:12:24.694'),('cmn7hsdvn000i69k203iwttze','Pure Mathematics','الرياضيات البحتة','PMATH',NULL,132,'cmn7hsbc7000269k28r4wrma7','2026-03-26 13:12:24.694','2026-03-26 13:12:24.694'),('cmn7hsdvn000k69k2oea3ldyu','Physics','الفيزياء','PHYS',NULL,136,'cmn7hsbc7000469k2xnga0qiw','2026-03-26 13:12:24.694','2026-03-26 13:12:24.694'),('cmn7hsdvn000m69k2co1skqm1','Chemistry','الكيمياء','CHEM',NULL,132,'cmn7hsbc7000669k2fz6x4kyb','2026-03-26 13:12:24.694','2026-03-26 13:12:24.694'),('cmn7hsdvn000o69k2nj47w2to','Botany','النبات','BOTA',NULL,128,'cmn7hsbc7000869k2yxgb8jod','2026-03-26 13:12:24.694','2026-03-26 13:12:24.694'),('cmn7hsdvo000q69k2m5osp8do','Zoology','الحيوان','ZOOL',NULL,128,'cmn7hsbc7000869k2yxgb8jod','2026-03-26 13:12:24.694','2026-03-26 13:12:24.694'),('cmn7hsdvo000s69k2ys8ejh3a','Microbiology','الميكروبيولوجي','MICR',NULL,128,'cmn7hsbc7000869k2yxgb8jod','2026-03-26 13:12:24.694','2026-03-26 13:12:24.694'),('cmn7hsdvo000u69k2wi9p0u0p','Geology','الجيولوجيا','GEOL',NULL,132,'cmn7hsbc7000a69k2p0t7rthm','2026-03-26 13:12:24.694','2026-03-26 13:12:24.694');
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule_events`
--

DROP TABLE IF EXISTS `schedule_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_events` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `eventType` enum('LECTURE','EXAM','ASSIGNMENT_DUE','MEETING','OFFICE_HOURS','PERSONAL') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PERSONAL',
  `start_time` datetime(3) NOT NULL,
  `end_time` datetime(3) NOT NULL,
  `is_all_day` tinyint(1) NOT NULL DEFAULT '0',
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_recurring` tinyint(1) NOT NULL DEFAULT '0',
  `recurrence_rule` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `schedule_events_start_time_idx` (`start_time`),
  KEY `schedule_events_user_id_idx` (`user_id`),
  CONSTRAINT `schedule_events_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_events`
--

LOCK TABLES `schedule_events` WRITE;
/*!40000 ALTER TABLE `schedule_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedule_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_submissions`
--

DROP TABLE IF EXISTS `task_submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_submissions` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('PENDING','SUBMITTED','LATE','GRADED','RETURNED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `submitted_at` datetime(3) DEFAULT NULL,
  `file_url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` longtext COLLATE utf8mb4_unicode_ci,
  `answers` json DEFAULT NULL,
  `started_at` datetime(3) DEFAULT NULL,
  `snapshots` json DEFAULT NULL,
  `points` double DEFAULT NULL,
  `grade` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `feedback` longtext COLLATE utf8mb4_unicode_ci,
  `graded_at` datetime(3) DEFAULT NULL,
  `task_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `student_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_submissions_task_id_student_id_key` (`task_id`,`student_id`),
  KEY `task_submissions_student_id_fkey` (`student_id`),
  CONSTRAINT `task_submissions_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `task_submissions_task_id_fkey` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_submissions`
--

LOCK TABLES `task_submissions` WRITE;
/*!40000 ALTER TABLE `task_submissions` DISABLE KEYS */;
INSERT INTO `task_submissions` VALUES ('cmnt8qj7p000av49nmi6ijp6v','GRADED','2026-04-10 18:29:57.828',NULL,NULL,'{\"1775845277575\": \"false\", \"1775845287800\": \"true\", \"1775845298313\": \"false\"}','2026-04-10 18:29:31.920',NULL,5,NULL,NULL,'2026-04-10 18:29:57.828','cmnt8g55t0001v49nclp2ib46','cmnhox6gs0000hjjm4x9q1t8m');
/*!40000 ALTER TABLE `task_submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `task_type` enum('ASSIGNMENT','EXAM','QUIZ','PROJECT','LAB','PERSONAL') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ASSIGNMENT',
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MEDIUM',
  `due_date` datetime(3) DEFAULT NULL,
  `start_date` datetime(3) DEFAULT NULL,
  `max_points` int NOT NULL DEFAULT '100',
  `attachments` json DEFAULT NULL,
  `questions` json DEFAULT NULL,
  `settings` json DEFAULT NULL,
  `published` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `completed_at` datetime(3) DEFAULT NULL,
  `course_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tasks_due_date_idx` (`due_date`),
  KEY `tasks_course_id_idx` (`course_id`),
  KEY `tasks_created_by_id_idx` (`created_by_id`),
  KEY `tasks_status_idx` (`status`),
  KEY `tasks_created_by_id_status_idx` (`created_by_id`,`status`),
  CONSTRAINT `tasks_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tasks_created_by_id_fkey` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES ('cmn7hvsb1006769k2zbiv1om6','Python Programming Lab','Complete exercises 1-5 from Chapter 3','LAB','MEDIUM','2026-04-02 13:15:03.563',NULL,20,NULL,NULL,NULL,1,'2026-03-26 13:15:03.565','2026-03-26 13:15:03.565','PENDING',NULL,'cmn7hsruq001v69k2s6ismt9o','cmn7hsijq000x69k2vrhzc1v9'),('cmn7hvtfc006969k2ifclp2ty','Midterm Exam - Programming 1','Covers: Variables, Loops, Functions, Arrays','EXAM','HIGH','2026-04-09 13:15:03.564','2026-04-09 13:15:03.564',100,NULL,NULL,NULL,1,'2026-03-26 13:15:04.800','2026-03-26 13:15:04.800','PENDING',NULL,'cmn7hsshp001x69k2r2ez8eus','cmn7hsijq000x69k2vrhzc1v9'),('cmn7hvu9n006b69k2jk8j4rd9','Assignment 1: Calculator Program','Build a simple calculator using Python','ASSIGNMENT','MEDIUM','2026-04-02 13:15:03.563',NULL,30,NULL,NULL,NULL,1,'2026-03-26 13:15:06.107','2026-03-26 13:15:06.107','PENDING',NULL,'cmn7hsshp001x69k2r2ez8eus','cmn7hsijq000x69k2vrhzc1v9'),('cmn7hvuwk006d69k23wmfw210','Calculus Problem Set 1','Problems from Chapter 2: Derivatives','ASSIGNMENT','MEDIUM','2026-04-02 13:15:03.563',NULL,25,NULL,NULL,NULL,1,'2026-03-26 13:15:06.932','2026-03-26 13:15:06.932','PENDING',NULL,'cmn7hsplw001p69k2g8ysko1g','cmn7hsijr000z69k2tb66jyyd'),('cmn7hvvjj006f69k21hmat8ah','Quiz 1: Limits','Short quiz on limits and continuity','QUIZ','MEDIUM','2026-04-16 13:15:03.564',NULL,15,NULL,NULL,NULL,1,'2026-03-26 13:15:07.759','2026-03-26 13:15:07.759','PENDING',NULL,'cmn7hsplw001p69k2g8ysko1g','cmn7hsijr000z69k2tb66jyyd'),('cmn7hvw6d006h69k27bbgirdi','Statistics Lab Report','Data analysis using SPSS or R','LAB','MEDIUM','2026-04-09 13:15:03.564',NULL,40,NULL,NULL,NULL,1,'2026-03-26 13:15:08.581','2026-03-26 13:15:08.581','PENDING',NULL,'cmn7hstxo002169k2m4sowbn8','cmn7hsijr000z69k2tb66jyyd'),('cmnhf0ezi0001t6p2njhms22c','assign1','','ASSIGNMENT','MEDIUM','2026-04-22 21:59:00.000',NULL,100,'[\"https://pub-365eed07c3dc495abbd9f6b237bf5875.r2.dev/uploads/1775130736361-183305829-anime_women_short_hair.jpg\"]',NULL,NULL,1,'2026-04-02 11:52:22.494','2026-04-02 11:52:22.494','PENDING',NULL,'cmn7hsplw001p69k2g8ysko1g','cmn7hsijq000x69k2vrhzc1v9'),('cmnoaizzw0003fs48d3xz4l0k','assign 1','april 7','ASSIGNMENT','MEDIUM','2026-04-15 07:20:00.000',NULL,100,'[\"https://pub-365eed07c3dc495abbd9f6b237bf5875.r2.dev/uploads/1775546468968-656820199-Introdution_to_data_mining.pdf\"]',NULL,NULL,1,'2026-04-07 07:21:14.685','2026-04-07 07:21:14.685','PENDING',NULL,'cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9'),('cmnp6lv560008trz2b585mnnf','Ana 3ndi assingment','\nData Mining ','PERSONAL','HIGH','2026-04-09 13:19:00.000',NULL,100,NULL,NULL,NULL,1,'2026-04-07 22:19:16.074','2026-04-07 22:19:16.074','PENDING',NULL,NULL,'cmnp6ge1y0001trz23lr3fh73'),('cmnt8g55t0001v49nclp2ib46','exam1','','EXAM','HIGH','2026-04-11 08:00:00.000',NULL,15,NULL,'[{\"id\": \"1775845277575\", \"text\": \"Q1\", \"type\": \"TRUE_FALSE\", \"points\": 5, \"imageUrl\": null, \"correctAnswer\": \"true\"}, {\"id\": \"1775845287800\", \"text\": \"Q2\", \"type\": \"TRUE_FALSE\", \"points\": 5, \"imageUrl\": null, \"correctAnswer\": \"true\"}, {\"id\": \"1775845298313\", \"text\": \"Q3\", \"type\": \"TRUE_FALSE\", \"points\": 5, \"imageUrl\": null, \"correctAnswer\": \"true\"}]','{\"durationMinutes\": 60, \"shuffleQuestions\": false, \"showResultsImmediately\": false}',0,'2026-04-10 18:21:53.046','2026-04-10 18:21:53.046','PENDING',NULL,'cmn7htxyn005969k2jmcpyf1l','cmn7hsijr000z69k2tb66jyyd'),('cmntm6ptf00017amnflcvuai8','assign 1','april11','ASSIGNMENT','MEDIUM','2026-04-12 12:45:00.000',NULL,70,'[\"https://pub-365eed07c3dc495abbd9f6b237bf5875.r2.dev/uploads/1775868383119-979711362-Lect__4_Which_Animal_Gave_Us_SARS___Part2.pdf\"]',NULL,NULL,1,'2026-04-11 00:46:27.891','2026-04-11 00:46:27.891','PENDING',NULL,'cmn7hsplw001p69k2g8ysko1g','cmn7hsijq000x69k2vrhzc1v9'),('cmntm9gl0000f7amn6hyb6kes','assign 1','aprill 11','ASSIGNMENT','MEDIUM','2026-04-17 00:48:00.000',NULL,100,'[\"https://pub-365eed07c3dc495abbd9f6b237bf5875.r2.dev/uploads/1775868492137-143517307-Lect__4_Which_Animal_Gave_Us_SARS___Part2.pdf\"]',NULL,NULL,1,'2026-04-11 00:48:35.892','2026-04-11 00:48:35.892','PENDING',NULL,'cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9'),('cmntmdd0b000n7amnwj2tyn9k','exam 1','april 11','EXAM','HIGH','2026-04-12 08:00:00.000',NULL,135,NULL,'[{\"id\": \"1775868618438\", \"text\": \"why ?\", \"type\": \"MCQ\", \"points\": 50, \"options\": [\"it\'ll be fine\", \"nothing gotta change\"], \"imageUrl\": null, \"correctAnswer\": \"it\'ll be fine\", \"correctAnswerIndex\": 0}, {\"id\": \"1775868641874\", \"text\": \"is life ok after 2019?\", \"type\": \"TRUE_FALSE\", \"points\": 15, \"imageUrl\": null, \"correctAnswer\": \"false\"}, {\"id\": \"1775868672562\", \"text\": \"is it ok ?\", \"type\": \"TEXT\", \"points\": 70, \"imageUrl\": null}]','{\"durationMinutes\": 60, \"shuffleQuestions\": true, \"showResultsImmediately\": false}',1,'2026-04-11 00:51:37.883','2026-04-11 00:51:37.883','PENDING',NULL,'cmnhel3ag0000114hi8l8syha','cmn7hsijq000x69k2vrhzc1v9');
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ums_courses`
--

DROP TABLE IF EXISTS `ums_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ums_courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `course_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `course_name_ar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credit_hours` int DEFAULT NULL,
  `section` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `semester` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `academic_year` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `instructor_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `raw_data` json DEFAULT NULL,
  `synced_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ums_courses_user_id_course_code_semester_academic_year_key` (`user_id`,`course_code`,`semester`,`academic_year`),
  KEY `ums_courses_user_id_idx` (`user_id`),
  CONSTRAINT `ums_courses_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ums_courses`
--

LOCK TABLES `ums_courses` WRITE;
/*!40000 ALTER TABLE `ums_courses` DISABLE KEYS */;
INSERT INTO `ums_courses` VALUES (6,'COMP 402','المعلوماتيه الحيويه',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 402\", \"courseName\": \"المعلوماتيه الحيويه\", \"creditHours\": null}','2026-04-03 13:47:04.904','cmnhboj1z0000gju0zh9yfsnc'),(7,'COMP 404','هندسه البرمجيات',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 404\", \"courseName\": \"هندسه البرمجيات\", \"creditHours\": null}','2026-04-03 13:47:08.698','cmnhboj1z0000gju0zh9yfsnc'),(8,'COMP 406','مشروع حاسب (ب)',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 406\", \"courseName\": \"مشروع حاسب (ب)\", \"creditHours\": null}','2026-04-03 13:47:10.984','cmnhboj1z0000gju0zh9yfsnc'),(9,'COMP 408','موضوعات متقدمه فى الذكاء الإصطناعى',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 408\", \"courseName\": \"موضوعات متقدمه فى الذكاء الإصطناعى\", \"creditHours\": null}','2026-04-03 13:47:13.347','cmnhboj1z0000gju0zh9yfsnc'),(10,'COMP 416','استخلاص البيانات والويب',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 416\", \"courseName\": \"استخلاص البيانات والويب\", \"creditHours\": null}','2026-04-03 13:47:15.701','cmnhboj1z0000gju0zh9yfsnc'),(11,'COMP 402','المعلوماتيه الحيويه',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 402\", \"courseName\": \"المعلوماتيه الحيويه\", \"creditHours\": null}','2026-04-11 00:37:09.837','cmnj11d3x0000lvpkuh3pprhm'),(12,'COMP 404','هندسه البرمجيات',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 404\", \"courseName\": \"هندسه البرمجيات\", \"creditHours\": null}','2026-04-11 00:37:15.530','cmnj11d3x0000lvpkuh3pprhm'),(13,'COMP 406','مشروع حاسب (ب)',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 406\", \"courseName\": \"مشروع حاسب (ب)\", \"creditHours\": null}','2026-04-11 00:37:19.744','cmnj11d3x0000lvpkuh3pprhm'),(14,'COMP 408','موضوعات متقدمه فى الذكاء الإصطناعى',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 408\", \"courseName\": \"موضوعات متقدمه فى الذكاء الإصطناعى\", \"creditHours\": null}','2026-04-11 00:37:23.538','cmnj11d3x0000lvpkuh3pprhm'),(15,'COMP 416','استخلاص البيانات والويب',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 416\", \"courseName\": \"استخلاص البيانات والويب\", \"creditHours\": null}','2026-04-11 00:37:27.410','cmnj11d3x0000lvpkuh3pprhm'),(16,'COMP 402','المعلوماتيه الحيويه',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 402\", \"courseName\": \"المعلوماتيه الحيويه\", \"creditHours\": null}','2026-04-08 12:40:00.075','cmnp651zw0000trz2xdlzmj2g'),(17,'COMP 404','هندسه البرمجيات',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 404\", \"courseName\": \"هندسه البرمجيات\", \"creditHours\": null}','2026-04-08 12:40:04.022','cmnp651zw0000trz2xdlzmj2g'),(18,'COMP 406','مشروع حاسب (ب)',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 406\", \"courseName\": \"مشروع حاسب (ب)\", \"creditHours\": null}','2026-04-08 12:40:06.454','cmnp651zw0000trz2xdlzmj2g'),(19,'COMP 408','موضوعات متقدمه فى الذكاء الإصطناعى',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 408\", \"courseName\": \"موضوعات متقدمه فى الذكاء الإصطناعى\", \"creditHours\": null}','2026-04-08 12:40:08.870','cmnp651zw0000trz2xdlzmj2g'),(20,'COMP 416','استخلاص البيانات والويب',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 416\", \"courseName\": \"استخلاص البيانات والويب\", \"creditHours\": null}','2026-04-08 12:40:11.503','cmnp651zw0000trz2xdlzmj2g'),(21,'COMP 402','المعلوماتيه الحيويه',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 402\", \"courseName\": \"المعلوماتيه الحيويه\", \"creditHours\": null}','2026-04-07 22:15:04.694','cmnp6ge1y0001trz23lr3fh73'),(22,'COMP 403','المعالجه المتوازنه والموزعه',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 403\", \"courseName\": \"المعالجه المتوازنه والموزعه\", \"creditHours\": null}','2026-04-07 22:15:08.711','cmnp6ge1y0001trz23lr3fh73'),(23,'COMP 416','استخلاص البيانات والويب',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 416\", \"courseName\": \"استخلاص البيانات والويب\", \"creditHours\": null}','2026-04-07 22:15:11.173','cmnp6ge1y0001trz23lr3fh73'),(24,'COMP 418','مشروع حاسب (لمزدوج التخصص)',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 418\", \"courseName\": \"مشروع حاسب (لمزدوج التخصص)\", \"creditHours\": null}','2026-04-07 22:15:13.628','cmnp6ge1y0001trz23lr3fh73'),(25,'STAT 408','سلاسل زمنيه',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"STAT 408\", \"courseName\": \"سلاسل زمنيه\", \"creditHours\": null}','2026-04-07 22:15:18.120','cmnp6ge1y0001trz23lr3fh73'),(26,'STAT 412','نظريه الطوابير',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"STAT 412\", \"courseName\": \"نظريه الطوابير\", \"creditHours\": null}','2026-04-07 22:15:21.684','cmnp6ge1y0001trz23lr3fh73'),(27,'STAT 418','عمليات عشوائيه (2)',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"STAT 418\", \"courseName\": \"عمليات عشوائيه (2)\", \"creditHours\": null}','2026-04-07 22:15:25.259','cmnp6ge1y0001trz23lr3fh73'),(28,'STAT 424','مشروع بحثى فى الاحصاء',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"STAT 424\", \"courseName\": \"مشروع بحثى فى الاحصاء\", \"creditHours\": null}','2026-04-07 22:15:28.745','cmnp6ge1y0001trz23lr3fh73'),(29,'COMP 304','تصميم مولفات',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 304\", \"courseName\": \"تصميم مولفات\", \"creditHours\": null}','2026-04-11 10:44:11.413','cmnhox6gs0000hjjm4x9q1t8m'),(30,'COMP 402','المعلوماتيه الحيويه',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 402\", \"courseName\": \"المعلوماتيه الحيويه\", \"creditHours\": null}','2026-04-11 10:44:15.552','cmnhox6gs0000hjjm4x9q1t8m'),(31,'COMP 404','هندسه البرمجيات',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 404\", \"courseName\": \"هندسه البرمجيات\", \"creditHours\": null}','2026-04-11 10:44:18.074','cmnhox6gs0000hjjm4x9q1t8m'),(32,'COMP 406','مشروع حاسب (ب)',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 406\", \"courseName\": \"مشروع حاسب (ب)\", \"creditHours\": null}','2026-04-11 10:44:20.564','cmnhox6gs0000hjjm4x9q1t8m'),(33,'COMP 408','موضوعات متقدمه فى الذكاء الإصطناعى',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 408\", \"courseName\": \"موضوعات متقدمه فى الذكاء الإصطناعى\", \"creditHours\": null}','2026-04-11 10:44:23.293','cmnhox6gs0000hjjm4x9q1t8m'),(34,'COMP 416','استخلاص البيانات والويب',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 416\", \"courseName\": \"استخلاص البيانات والويب\", \"creditHours\": null}','2026-04-11 10:44:25.816','cmnhox6gs0000hjjm4x9q1t8m'),(35,'COMP 402','المعلوماتيه الحيويه',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 402\", \"courseName\": \"المعلوماتيه الحيويه\", \"creditHours\": null}','2026-04-11 00:54:00.635','cmntjwy810000xr52coryl23v'),(36,'COMP 404','هندسه البرمجيات',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 404\", \"courseName\": \"هندسه البرمجيات\", \"creditHours\": null}','2026-04-11 00:54:04.629','cmntjwy810000xr52coryl23v'),(37,'COMP 406','مشروع حاسب (ب)',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 406\", \"courseName\": \"مشروع حاسب (ب)\", \"creditHours\": null}','2026-04-11 00:54:09.859','cmntjwy810000xr52coryl23v'),(38,'COMP 408','موضوعات متقدمه فى الذكاء الإصطناعى',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 408\", \"courseName\": \"موضوعات متقدمه فى الذكاء الإصطناعى\", \"creditHours\": null}','2026-04-11 00:54:12.328','cmntjwy810000xr52coryl23v'),(39,'COMP 416','استخلاص البيانات والويب',NULL,NULL,NULL,'current','2026',NULL,'{\"courseCode\": \"COMP 416\", \"courseName\": \"استخلاص البيانات والويب\", \"creditHours\": null}','2026-04-11 00:54:14.836','cmntjwy810000xr52coryl23v');
/*!40000 ALTER TABLE `ums_courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ums_grades`
--

DROP TABLE IF EXISTS `ums_grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ums_grades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `course_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `grade` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `grade_points` double DEFAULT NULL,
  `credit_hours` int DEFAULT NULL,
  `semester` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `academic_year` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `raw_data` json DEFAULT NULL,
  `synced_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ums_grades_user_id_course_code_semester_academic_year_key` (`user_id`,`course_code`,`semester`,`academic_year`),
  KEY `ums_grades_user_id_idx` (`user_id`),
  CONSTRAINT `ums_grades_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ums_grades`
--

LOCK TABLES `ums_grades` WRITE;
/*!40000 ALTER TABLE `ums_grades` DISABLE KEYS */;
/*!40000 ALTER TABLE `ums_grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ums_sessions`
--

DROP TABLE IF EXISTS `ums_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ums_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cookies` json NOT NULL,
  `last_sync_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `expires_at` datetime(3) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ums_sessions_user_id_key` (`user_id`),
  CONSTRAINT `ums_sessions_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ums_sessions`
--

LOCK TABLES `ums_sessions` WRITE;
/*!40000 ALTER TABLE `ums_sessions` DISABLE KEYS */;
INSERT INTO `ums_sessions` VALUES (4,'[\"ASP.NET_SessionId=atqe4kr4qyezgvcnqqjejzip\", \"__RequestVerificationToken=8dqzkBqTQv3TqGZUDZCpsFmd_KotaAtBej-T48gw8aYJIShQ25GUGcQ8AlPxhZ9B5EftRlB4csM0AMRVxxb3NJ6KQjo1\", \"BIGipServerUMS_New_Pool_443=687871404.47873.0000\", \"TS01b306c6=01b5d2c3bd447269e3433977391eec125ebf31f3398f7f30771f020de5885ecfe60ac29fd46014644aae6653bd22189cb8f096d9c63a2ccc368e3501067ea4e86a8cbb36895a13304e25396bb7110dad6bd07b5340091a89b36f2fbbb477475a3b1e3ef2bc3a43705427d817b6bd8c72f24906dbc2\"]','2026-04-03 13:47:03.186',NULL,1,'cmnhboj1z0000gju0zh9yfsnc'),(5,'[\"TS01b306c6=01b5d2c3bd660864ab3f64309b863c261eeaaefad17caf443f812c53845f08b7dabae84fcd08f67973b8c9682806dc826df878f3647077a5f12be5046b49539f7be38596b6ecadd6cf3db0bf48cf8a3c54c148aaacbe35e48ff6e43b6ea060aa3a095ae9051be8abc23565791d2173c624e76845d6\", \"BIGipServerUMS_New_Pool_443=671094188.47873.0000\", \"__RequestVerificationToken=P4k1hxacaxTXEnDmbQGM_h0HyJw2ufofnXK2CJjOO916ePLrSyG4pdrr8h0a4y34n42e2jf7mRVynX_JvvKmw7upWmE1\", \"ASP.NET_SessionId=nbnqlugu30ngbk505thcgizh\"]','2026-04-11 10:44:09.593',NULL,1,'cmnhox6gs0000hjjm4x9q1t8m'),(6,'[\"ASP.NET_SessionId=bacdd4f0kiurs5cyteck0tm3\", \"__RequestVerificationToken=vaXjQN4B_DbDmTrS1tO0DpGiBu1wRZluBiHFmHaC_0qXO6acGAT5GYSRDCQhRZs88gqmUFQXOLfDl4dTV3H3OyXwMds1\", \"BIGipServerUMS_New_Pool_443=687871404.47873.0000\", \"TS01b306c6=01b5d2c3bd8d5a3162760eec7abb4078e0b33aef0f53622368f3848951321874849ee805a2cdf7de0c3578fad071c964f69874b22b58f0203adc92d793f5ab9e31da0e0dc7b5309265aa9bd5b577df9b2517cd11502cf00270dd7981376060157ee87410dcb3ab51c10592d0c4ec6cbc23764bdf4d\"]','2026-04-11 00:37:06.930',NULL,1,'cmnj11d3x0000lvpkuh3pprhm'),(7,'[\"BIGipServerUMS_New_Pool_443=671094188.47873.0000\", \"__RequestVerificationToken=6ldbKUgFTdHbpw8DQ-R_UZzlQrTaOEFnxXa-LQ6NGhw1RDQc8UJulbh0uyT1hoX1blep5zI112fR35Bc7pArNth3zh01\", \"ASP.NET_SessionId=rmdz2ncq5sy11sxr4w1hnyxs\", \"TS01b306c6=01b5d2c3bd3af83e57c7b731e87db9ce758d321bd42760a257b07014ba82eaf4fae0960d62b3dddff0eb3fb03914052cd9feed51c585db8a78d715f733f7e9af5ff8f3dfd2e6086ba6df918e3763475d7949ff970abbbc7697198bf59c6f47bd233aae603a7f036f62ca3c3f35dbd2990343bcec26\"]','2026-04-08 12:39:58.316',NULL,1,'cmnp651zw0000trz2xdlzmj2g'),(8,'[\"TS01b306c6=01b5d2c3bdfa9183443ff9d2a65bd434c6d306a9e765ab053aa173337c195e10d0612f034ad9e54cbf128ec595e79e2f432066a8d2a3d55493d52dd3b5625873cf476b5a21b41c4b0fa794a43deca59f48285ae24a5dae2e3be36f62a8eb99bf17c1ba2e6482868a2b314e446b76f59ab4a25eac87\", \"BIGipServerUMS_New_Pool_443=671094188.47873.0000\", \"__RequestVerificationToken=55fVc-tl3Lsf4pTG4CW6OBfwyxG8yO9B-9mz1HR1eneRBSh16xlKSmwdvYWsHt4KI5Lm59fJaU80noSR6MR7B8YrApA1\", \"ASP.NET_SessionId=ryd51dli0usettsgn1w2aklc\"]','2026-04-07 22:15:02.913',NULL,1,'cmnp6ge1y0001trz23lr3fh73'),(9,'[\"TS01b306c6=01b5d2c3bddad9445eac9980c8f401c104d78a27dc87cdb1d3fb3b0b554230c18168bc74bfcedd31816ea070e70a6547d7d6182a478edab7e02a358257d2f0725fffa50af90f3dcf371516748f82c08c1714796b5034231922d50cd1fe9417ae3665606d37004fd14002d6fb481ccf23278961b340\", \"BIGipServerUMS_New_Pool_443=671094188.47873.0000\", \"__RequestVerificationToken=-iowwrnlK8apLNh7c_MpM_1rnhVkdu4ooTOs3T_hKsmCGR0D9mC0ir7q_K1SfbILutmMkjiftzRXCeEZD0d-Yl98vqg1\", \"ASP.NET_SessionId=iueoccuxc3o4azvwk5jfnren\"]','2026-04-11 00:53:58.942',NULL,1,'cmntjwy810000xr52coryl23v');
/*!40000 ALTER TABLE `ums_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_ar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('STUDENT','PROFESSOR','ADMIN') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'STUDENT',
  `student_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gpa` double DEFAULT NULL,
  `level` int DEFAULT NULL,
  `program_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `department_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT '0',
  `is_onboarding_complete` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `faculty` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `major` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `semester` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `academic_year` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `advisor_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `advisor_email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fcm_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL,
  `last_login_at` datetime(3) DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_key` (`email`),
  UNIQUE KEY `users_student_id_key` (`student_id`),
  KEY `users_program_id_idx` (`program_id`),
  KEY `users_department_id_idx` (`department_id`),
  CONSTRAINT `users_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `users_program_id_fkey` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('cmn7hshfj000v69k2ofkiw9xp','admin@college.edu','$2a$10$SvT/CmsKQPmWVhQPkynJfexLe/NBikCP2/UCGiqA/FnsTPgz9bPPi','System Admin',NULL,NULL,NULL,'ADMIN',NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-26 13:12:29.298','2026-03-26 13:12:29.298',NULL,NULL),('cmn7hsijq000x69k2vrhzc1v9','doctor@college.edu','$2a$10$1N0u.iZYZ27vYxhwYZL6Nex6SyC02Y2Yw/DPMtWKWpTf9pVTeBkwy','Dr. Smith',NULL,NULL,NULL,'PROFESSOR',NULL,NULL,NULL,NULL,'cmn7hsbc7000269k28r4wrma7',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-26 13:12:30.746','2026-04-11 00:44:27.425','2026-04-11 00:44:27.423',NULL),('cmn7hsijr000z69k2tb66jyyd','dr.ahmed@college.edu','$2a$10$SvT/CmsKQPmWVhQPkynJfexLe/NBikCP2/UCGiqA/FnsTPgz9bPPi','Dr. Ahmed Hassan','د. أحمد حسن',NULL,NULL,'PROFESSOR',NULL,NULL,NULL,NULL,'cmn7hsbc7000269k28r4wrma7',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-26 13:12:30.746','2026-04-10 18:02:48.737','2026-04-10 18:02:48.736',NULL),('cmn7hsijr001169k2tci45yl7','dr.mohamed@college.edu','$2a$10$SvT/CmsKQPmWVhQPkynJfexLe/NBikCP2/UCGiqA/FnsTPgz9bPPi','Dr. Mohamed Ali','د. محمد علي',NULL,NULL,'PROFESSOR',NULL,NULL,NULL,NULL,'cmn7hsbc7000269k28r4wrma7',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-26 13:12:30.746','2026-03-26 13:12:30.746',NULL,NULL),('cmn7hsijr001369k2hg4izncp','dr.fatma@college.edu','$2a$10$SvT/CmsKQPmWVhQPkynJfexLe/NBikCP2/UCGiqA/FnsTPgz9bPPi','Dr. Fatma Salem','د. فاطمة سالم',NULL,NULL,'PROFESSOR',NULL,NULL,NULL,NULL,'cmn7hsbc7000469k2xnga0qiw',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-26 13:12:30.746','2026-03-26 13:12:30.746',NULL,NULL),('cmn7hsijr001569k24ksspyax','dr.khaled@college.edu','$2a$10$SvT/CmsKQPmWVhQPkynJfexLe/NBikCP2/UCGiqA/FnsTPgz9bPPi','Dr. Khaled Mostafa','د. خالد مصطفى',NULL,NULL,'PROFESSOR',NULL,NULL,NULL,NULL,'cmn7hsbc7000669k2fz6x4kyb',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-26 13:12:30.746','2026-03-26 13:12:30.746',NULL,NULL),('cmn7hsijs001769k2x5rqdhqp','dr.rania@college.edu','$2a$10$SvT/CmsKQPmWVhQPkynJfexLe/NBikCP2/UCGiqA/FnsTPgz9bPPi','Dr. Rania Hassan','د. رانيا حسن',NULL,NULL,'PROFESSOR',NULL,NULL,NULL,NULL,'cmn7hsbc7000869k2yxgb8jod',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-26 13:12:30.746','2026-03-26 13:12:30.746',NULL,NULL),('cmn7hsijs001969k24owpujnx','dr.sami@college.edu','$2a$10$SvT/CmsKQPmWVhQPkynJfexLe/NBikCP2/UCGiqA/FnsTPgz9bPPi','Dr. Sami Osman','د. سامي عثمان',NULL,NULL,'PROFESSOR',NULL,NULL,NULL,NULL,'cmn7hsbc7000a69k2p0t7rthm',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-26 13:12:30.746','2026-03-26 13:12:30.746',NULL,NULL),('cmn7hsl8x001b69k2mkgmtzu4','student@college.edu','$2a$10$SvT/CmsKQPmWVhQPkynJfexLe/NBikCP2/UCGiqA/FnsTPgz9bPPi','أحمد محمد',NULL,NULL,NULL,'STUDENT','2024001',NULL,2,'cmn7hsdvn000e69k2i7x4v7n5',NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-26 13:12:34.245','2026-03-26 13:12:34.245',NULL,NULL),('cmn7hsl8y001d69k2pv332tsh','sara@college.edu','$2a$10$SvT/CmsKQPmWVhQPkynJfexLe/NBikCP2/UCGiqA/FnsTPgz9bPPi','سارة أحمد',NULL,NULL,NULL,'STUDENT','2024002',NULL,3,'cmn7hsdvn000g69k27kp0egvk',NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-26 13:12:34.245','2026-03-26 13:12:34.245',NULL,NULL),('cmn7hsl8y001f69k2ir111q8c','omar@college.edu','$2a$10$SvT/CmsKQPmWVhQPkynJfexLe/NBikCP2/UCGiqA/FnsTPgz9bPPi','عمر حسن',NULL,NULL,NULL,'STUDENT','2024003',NULL,1,'cmn7hsdvn000k69k2oea3ldyu',NULL,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-26 13:12:34.245','2026-03-26 13:12:34.245',NULL,NULL),('cmnhboj1z0000gju0zh9yfsnc','30409260104446@sci.asu.edu.eg','$2a$12$XlmwH73jkck60yU8tyu2OeJk02mX6p/vSjHDfg3MnUS8HTfJBXc9a','باللغة العربية : activate to sort column ascending\"> الاسم باللغة العربية','باللغة العربية : activate to sort column ascending\"> الاسم باللغة العربية',NULL,NULL,'STUDENT','الصورة الامامية',3,4,NULL,NULL,1,1,1,'كلية العلوم','برنامج علوم الحاسب',NULL,'2025-2026','محمد هاشم على عبد الرحمن','m_abdelrahman@sci.asu.edu.eg',NULL,'2026-04-02 10:19:09.047','2026-04-03 13:50:48.276','2026-04-03 13:47:01.280',NULL),('cmnhox6gs0000hjjm4x9q1t8m','N014653138@sci.asu.edu.eg','$2a$12$jPl/r7NtDG6AubJ31NtGJeXOx0M/xzgOUEnZgMHFtEZtObp2Q64yC','باللغة العربية : activate to sort column ascending\"> الاسم باللغة العربية','باللغة العربية : activate to sort column ascending\"> الاسم باللغة العربية',NULL,NULL,'STUDENT','N014653138',NULL,4,NULL,NULL,1,1,1,'كلية العلوم','برنامج علوم الحاسب',NULL,'2025-2026','دولت عبد العزيز محمد ذكى','dawlat_zaki@sci.asu.edu.eg',NULL,'2026-04-02 16:29:47.644','2026-04-11 10:44:06.992','2026-04-11 10:44:06.980','activate to sort column ascending\"> العنوان'),('cmnj11d3x0000lvpkuh3pprhm','30410030100903@sci.asu.edu.eg','$2a$12$vBbb.J7a8GnQtUqXGGKA8.8CTGvDchujBialiY33EEUSQ1vZOQ/nO','نورين احمد','نورين احمد',NULL,'01013229538','STUDENT','30410030100903',2.7,4,NULL,NULL,1,1,1,'كلية العلوم','برنامج علوم الحاسب','فصل الربيع','2025-2026','محمد هاشم على عبد الرحمن','m_abdelrahman@sci.asu.edu.eg',NULL,'2026-04-03 14:56:44.444','2026-04-11 00:37:03.627','2026-04-11 00:37:03.625','13ش الحسين ابراهيم ش جمال عبد الناصر'),('cmnp651zw0000trz2xdlzmj2g','30310060102434@sci.asu.edu.eg','$2a$12$XK4AYNJo690j6FqYpEWaGuSnEjeNdMnxCeWRGVm19VdxqV.LpJt.a','باللغة العربية : activate to sort column ascending\"> الاسم باللغة العربية','باللغة العربية : activate to sort column ascending\"> الاسم باللغة العربية',NULL,NULL,'STUDENT','30310060102434',NULL,4,NULL,NULL,1,1,1,'كلية العلوم','برنامج علوم الحاسب',NULL,'2025-2026','محمد هاشم على عبد الرحمن','m_abdelrahman@sci.asu.edu.eg',NULL,'2026-04-07 22:06:11.803','2026-04-08 12:39:55.856','2026-04-08 12:39:55.846','activate to sort column ascending\"> العنوان'),('cmnp6ge1y0001trz23lr3fh73','30406010106819@sci.asu.edu.eg','$2a$12$DWPOkcF.LfhSqVKcQlsaa.hXXpISb6lArPzhEl2WEnwZ7lf1aLtSa','باللغة العربية : activate to sort column ascending\"> الاسم باللغة العربية','باللغة العربية : activate to sort column ascending\"> الاسم باللغة العربية',NULL,NULL,'STUDENT','30406010106819',NULL,4,NULL,NULL,1,1,1,'كلية العلوم','برنامج إحصاء رياضي / علوم الحاسب',NULL,'2025-2026','ناهد عبد الســلام مخلص','Nahed@sci.asu.edu.eg',NULL,'2026-04-07 22:15:00.646','2026-04-07 22:15:00.646','2026-04-07 22:15:00.635','activate to sort column ascending\"> العنوان'),('cmntjwy810000xr52coryl23v','30409260104446@asu.edu.eg','$2a$12$UpnlSQbz4/Nk4g/QJ1cODeJOZvd2nvWBUYWUAm6VGR1ByKxPfhbPi','ندى مجدى','ندى مجدى',NULL,'01030875906','STUDENT','30409260104446',NULL,4,NULL,NULL,1,1,1,'كلية العلوم','برنامج علوم الحاسب','فصل الربيع','2025-2026','محمد هاشم على عبد الرحمن','m_abdelrahman@sci.asu.edu.eg',NULL,'2026-04-10 23:42:52.964','2026-04-11 00:53:56.848','2026-04-11 00:53:56.845',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `verification_codes`
--

DROP TABLE IF EXISTS `verification_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `verification_codes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('REGISTRATION','PASSWORD_RESET','EMAIL_CHANGE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` datetime(3) NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `verification_codes_code_idx` (`code`),
  KEY `verification_codes_user_id_fkey` (`user_id`),
  CONSTRAINT `verification_codes_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verification_codes`
--

LOCK TABLES `verification_codes` WRITE;
/*!40000 ALTER TABLE `verification_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `verification_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-13 11:29:40
