CREATE DATABASE  IF NOT EXISTS `flowershop` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `flowershop`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: flowershop
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `avatar` text,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `role` enum('user','admin','staff') DEFAULT 'user',
  `status` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES (1,'admin123','john.doe@example.com','c4ca4238a0b923820dcc509a6f75849b','John','Doe',NULL,'0987654321','123 Main St, City A','staff',0,'2025-02-20 02:05:57','2025-02-21 19:34:22'),(2,'jane_smith','jane.smith@example.com','482c811da5d5b4bc6d497ffa98491e38','Jane','Smith',NULL,'0978456123','456 Oak St, City B','staff',0,'2025-02-20 02:05:57','2025-02-21 19:34:22'),(3,'admin','admin@example.com','c4ca4238a0b923820dcc509a6f75849b','Nguyen Van ','A',NULL,'cxzczxcxz','789 Pine St, City C','staff',0,'2025-02-20 02:05:57','2025-02-21 19:34:22'),(4,'tom_hardy','tom.hardy@example.com','482c811da5d5b4bc6d497ffa98491e38','Tom','Hardy',NULL,'0912233445','111 Maple St, City D',NULL,1,'2025-02-20 02:05:57','2025-03-03 20:44:03'),(5,'emily_clark','emily.clark@example.com','482c811da5d5b4bc6d497ffa98491e38','Emily','Clark',NULL,'0912349988','222 Birch St, City E',NULL,0,'2025-02-20 02:05:57','2025-02-21 19:34:22'),(6,'will_smith','will.smith@example.com','482c811da5d5b4bc6d497ffa98491e38','Will','Smith',NULL,'0909876543','333 Cedar St, City F','user',0,'2025-02-20 02:05:57','2025-02-21 19:34:22'),(7,'susan_lee','susan.lee@example.com','482c811da5d5b4bc6d497ffa98491e38','Susan','Lee',NULL,'0923456789','444 Elm St, City G','user',1,'2025-02-20 02:05:57','2025-02-21 20:58:34'),(8,'mark_jones','mark.jones@example.com','482c811da5d5b4bc6d497ffa98491e38','Mark','Jones',NULL,'0934567890','555 Walnut St, City H','user',0,'2025-02-20 02:05:57','2025-02-21 19:34:22'),(9,'lucy_liu','lucy.liu@example.com','482c811da5d5b4bc6d497ffa98491e38','Lucy','Liu',NULL,'0945678901','666 Chestnut St, City I','user',0,'2025-02-20 02:05:57','2025-02-21 19:34:22'),(10,'michael_jordan','michael.jordan@example.com','482c811da5d5b4bc6d497ffa98491e38','Michael','Jordan',NULL,'0956789012','777 Spruce St, City J','user',0,'2025-02-20 02:05:57','2025-02-21 19:34:22'),(11,'testuser','test@example.com','testpass','Test','User',NULL,'123456789','Test Address','staff',0,'2025-02-20 02:35:17','2025-02-21 19:34:22'),(13,'user01','a@gmail.com','202cb962ac59075b964b07152d234b70','abc','vcxvxc',NULL,'1231231',NULL,'staff',0,'2025-02-20 12:16:28','2025-02-21 19:34:22'),(14,'4userfpt01@gmail.com','4userfpt01@gmail.com','',NULL,NULL,NULL,NULL,NULL,'staff',0,'2025-02-21 03:46:38','2025-02-21 19:34:22'),(15,'alice01','alice.johnson01@example.com','482c811da5d5b4bc6d497ffa98491e38','Alice','Johnson',NULL,'0987654322','123 Main St, City A','user',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(16,'brian02','brian.wilson02@example.com','482c811da5d5b4bc6d497ffa98491e38','Brian','Wilson',NULL,'0987654323','456 Oak St, City B','staff',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(17,'charlotte03','charlotte.lee03@example.com','482c811da5d5b4bc6d497ffa98491e38','Charlotte','Lee',NULL,'0987654324','789 Pine St, City C','admin',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(18,'david04','david.nguyen04@example.com','482c811da5d5b4bc6d497ffa98491e38','David','Nguyen',NULL,'0987654325','222 Birch St, City D','user',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(19,'ella05','ella.wong05@example.com','482c811da5d5b4bc6d497ffa98491e38','Ella','Wong',NULL,'0987654326','333 Cedar St, City E','staff',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(20,'frank06','frank.pham06@example.com','482c811da5d5b4bc6d497ffa98491e38','Frank','Pham',NULL,'0987654327','444 Elm St, City F','admin',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(21,'grace07','grace.lam07@example.com','482c811da5d5b4bc6d497ffa98491e38','Grace','Lam',NULL,'0987654328','555 Walnut St, City G','user',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(22,'hannah08','hannah.chan08@example.com','482c811da5d5b4bc6d497ffa98491e38','Hannah','Chan',NULL,'0987654329','666 Chestnut St, City H','staff',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(23,'ian09','ian.cruz09@example.com','482c811da5d5b4bc6d497ffa98491e38','Ian','Cruz',NULL,'0987654330','777 Spruce St, City I','admin',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(24,'jack10','jack.king10@example.com','482c811da5d5b4bc6d497ffa98491e38','Jack','King',NULL,'0987654331','888 Maple St, City J','user',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(25,'kate11','kate.morris11@example.com','482c811da5d5b4bc6d497ffa98491e38','Kate','Morris',NULL,'0987654332','999 Oak St, City K','staff',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(26,'liam12','liam.wood12@example.com','482c811da5d5b4bc6d497ffa98491e38','Liam','Wood',NULL,'0987654333','123 Main St, City A','admin',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(27,'mia13','mia.martin13@example.com','482c811da5d5b4bc6d497ffa98491e38','Mia','Martin',NULL,'0987654334','456 Oak St, City B','user',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(28,'noah14','noah.mitchell14@example.com','482c811da5d5b4bc6d497ffa98491e38','Noah','Mitchell',NULL,'0987654335','789 Pine St, City C','staff',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(29,'olivia15','olivia.moore15@example.com','482c811da5d5b4bc6d497ffa98491e38','Olivia','Moore',NULL,'0987654336','222 Birch St, City D','admin',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(30,'peter16','peter.baker16@example.com','482c811da5d5b4bc6d497ffa98491e38','Peter','Baker',NULL,'0987654337','333 Cedar St, City E','user',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(31,'quinn17','quinn.bell17@example.com','482c811da5d5b4bc6d497ffa98491e38','Quinn','Bell',NULL,'0987654338','444 Elm St, City F','staff',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(32,'ryan18','ryan.cooper18@example.com','482c811da5d5b4bc6d497ffa98491e38','Ryan','Cooper',NULL,'0987654339','555 Walnut St, City G','admin',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(33,'sarah19','sarah.evans19@example.com','482c811da5d5b4bc6d497ffa98491e38','Sarah','Evans',NULL,'0987654340','666 Chestnut St, City H','user',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(34,'thomas20','thomas.green20@example.com','482c811da5d5b4bc6d497ffa98491e38','Thomas','Green',NULL,'0987654341','777 Spruce St, City I','staff',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(35,'uma21','uma.hall21@example.com','482c811da5d5b4bc6d497ffa98491e38','Uma','Hall',NULL,'0987654342','888 Maple St, City J','admin',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(36,'victor22','victor.adams22@example.com','482c811da5d5b4bc6d497ffa98491e38','Victor','Adams',NULL,'0987654343','999 Oak St, City K','user',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(37,'william23','william.hughes23@example.com','482c811da5d5b4bc6d497ffa98491e38','William','Hughes',NULL,'0987654344','123 Main St, City A','staff',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(38,'xander24','xander.turner24@example.com','482c811da5d5b4bc6d497ffa98491e38','Xander','Turner',NULL,'0987654345','456 Oak St, City B','admin',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(39,'yasmin25','yasmin.collins25@example.com','482c811da5d5b4bc6d497ffa98491e38','Yasmin','Collins',NULL,'0987654346','789 Pine St, City C','user',1,'2025-02-21 15:41:00','2025-02-21 15:41:00'),(40,'zoe26','zoe.edwards26@example.com','482c811da5d5b4bc6d497ffa98491e38','Zoe','Edwards',NULL,'0987654347','222 Birch St, City D','staff',1,'2025-02-21 15:42:57','2025-02-21 21:48:45'),(41,'adam27','adam.harris27@example.com','482c811da5d5b4bc6d497ffa98491e38','Adam','Harris',NULL,'0987654348','333 Cedar St, City E','admin',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(42,'bella28','bella.clark28@example.com','482c811da5d5b4bc6d497ffa98491e38','Bella','Clark',NULL,'0987654349','444 Elm St, City F','user',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(43,'carter29','carter.lewis29@example.com','482c811da5d5b4bc6d497ffa98491e38','Carter','Lewis',NULL,'0987654350','555 Walnut St, City G','staff',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(44,'daisy30','daisy.robinson30@example.com','482c811da5d5b4bc6d497ffa98491e38','Daisy','Robinson',NULL,'0987654351','666 Chestnut St, City H','admin',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(45,'ethan31','ethan.walker31@example.com','482c811da5d5b4bc6d497ffa98491e38','Ethan','Walker',NULL,'0987654352','777 Spruce St, City I','user',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(46,'fiona32','fiona.allen32@example.com','482c811da5d5b4bc6d497ffa98491e38','Fiona','Allen',NULL,'0987654353','888 Maple St, City J','staff',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(47,'gavin33','gavin.young33@example.com','123456','Gavin','Young',NULL,'0987654354','999 Oak St, City K','admin',1,'2025-02-21 15:42:57','2025-02-21 20:56:14'),(48,'harper34','harper.king34@example.com','482c811da5d5b4bc6d497ffa98491e38','Harper','King',NULL,'0987654355','123 Main St, City A','user',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(49,'isaac35','isaac.wright35@example.com','482c811da5d5b4bc6d497ffa98491e38','Isaac','Wright',NULL,'0987654356','456 Oak St, City B','staff',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(50,'julia36','julia.scott36@example.com','482c811da5d5b4bc6d497ffa98491e38','Julia','Scott',NULL,'0987654357','789 Pine St, City C','admin',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(51,'kevin37','kevin.green37@example.com','482c811da5d5b4bc6d497ffa98491e38','Kevin','Green',NULL,'0987654358','222 Birch St, City D','user',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(52,'lily38','lily.adams38@example.com','482c811da5d5b4bc6d497ffa98491e38','Lily','Adams',NULL,'0987654359','333 Cedar St, City E','staff',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(53,'mason39','mason.nelson39@example.com','482c811da5d5b4bc6d497ffa98491e38','Mason','Nelson',NULL,'0987654360','444 Elm St, City F','admin',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(54,'nora40','nora.carter40@example.com','482c811da5d5b4bc6d497ffa98491e38','Nora','Carter',NULL,'0987654361','555 Walnut St, City G','user',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(55,'owen41','owen.mitchell41@example.com','482c811da5d5b4bc6d497ffa98491e38','Owen','Mitchell',NULL,'0987654362','666 Chestnut St, City H','staff',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(56,'piper42','piper.roberts42@example.com','482c811da5d5b4bc6d497ffa98491e38','Piper','Roberts',NULL,'0987654363','777 Spruce St, City I','admin',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(57,'quincy43','quincy.phillips43@example.com','482c811da5d5b4bc6d497ffa98491e38','Quincy','Phillips',NULL,'0987654364','888 Maple St, City J','user',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(58,'riley44','riley.campbell44@example.com','482c811da5d5b4bc6d497ffa98491e38','Riley','Campbell',NULL,'0987654365','999 Oak St, City K','staff',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(59,'sophia45','sophia.parker45@example.com','482c811da5d5b4bc6d497ffa98491e38','Sophia','Parker',NULL,'0987654366','123 Main St, City A','admin',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(60,'theo46','theo.evans46@example.com','482c811da5d5b4bc6d497ffa98491e38','Theo','Evans',NULL,'0987654367','456 Oak St, City B','user',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(61,'ursula47','ursula.edwards47@example.com','482c811da5d5b4bc6d497ffa98491e38','Ursula','Edwards',NULL,'0987654368','789 Pine St, City C','staff',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(62,'violet48','violet.collins48@example.com','482c811da5d5b4bc6d497ffa98491e38','Violet','Collins',NULL,'0987654369','222 Birch St, City D','admin',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(63,'wyatt49','wyatt.stewart49@example.com','482c811da5d5b4bc6d497ffa98491e38','Wyatt','Stewart',NULL,'0987654370','333 Cedar St, City E','user',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(64,'xena50','xena.morris50@example.com','482c811da5d5b4bc6d497ffa98491e38','Xena','Morris',NULL,'0987654371','444 Elm St, City F','staff',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(65,'yara51','yara.rogers51@example.com','482c811da5d5b4bc6d497ffa98491e38','Yara','Rogers',NULL,'0987654372','555 Walnut St, City G','admin',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(66,'zach52','zach.morgan52@example.com','482c811da5d5b4bc6d497ffa98491e38','Zach','Morgan',NULL,'0987654373','666 Chestnut St, City H','user',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(67,'aria53','aria.bell53@example.com','482c811da5d5b4bc6d497ffa98491e38','Aria','Bell',NULL,'0987654374','777 Spruce St, City I','staff',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(68,'blake54','blake.murphy54@example.com','482c811da5d5b4bc6d497ffa98491e38','Blake','Murphy',NULL,'0987654375','888 Maple St, City J','admin',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(69,'cora55','cora.bailey55@example.com','482c811da5d5b4bc6d497ffa98491e38','Cora','Bailey',NULL,'0987654376','999 Oak St, City K','user',1,'2025-02-21 15:42:57','2025-02-21 15:42:57'),(70,'abc@123','abc@gmail.com','123','nguyen van ','a',NULL,'1234567','vcvxcvxcvcx','user',0,'2025-02-21 20:10:48','2025-02-21 20:19:03');
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blogs`
--

DROP TABLE IF EXISTS `blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blogs` (
  `blog_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `content` text,
  `author_id` int DEFAULT NULL,
  `status` enum('published','hidden') DEFAULT 'published',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`blog_id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `blogs_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `account` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogs`
--

LOCK TABLES `blogs` WRITE;
/*!40000 ALTER TABLE `blogs` DISABLE KEYS */;
INSERT INTO `blogs` VALUES (1,'Hướng dẫn chăm sóc hoa hồng','Hoa hồng là loài hoa phổ biến...',1,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(2,'Cách trồng hoa lan nở quanh năm','Hoa lan cần điều kiện đặc biệt...',2,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(3,'Làm sao để cây xương rồng không bị úng','Xương rồng dễ bị úng nước nếu...',3,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(4,'Kinh nghiệm chọn đất trồng rau sạch','Đất là yếu tố quan trọng...',4,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(5,'Công thức pha đất trồng hoa ly','Hoa ly cần loại đất giàu dinh dưỡng...',5,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(6,'Tổng hợp các giống hoa tulip đẹp','Tulip có nhiều màu sắc đa dạng...',1,'hidden','2025-03-02 05:39:15','2025-03-02 05:39:15'),(7,'Hướng dẫn trồng hoa cúc đúng cách','Hoa cúc dễ trồng nhưng...',2,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(8,'Cách tưới nước cho sen đá','Sen đá không cần quá nhiều nước...',3,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(9,'Những loại hoa dễ trồng tại nhà','Một số loài hoa như...',4,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(10,'Bí quyết giữ hoa tươi lâu sau khi cắt','Muốn hoa tươi lâu, cần...',5,'hidden','2025-03-02 05:39:15','2025-03-02 05:39:15'),(11,'Lợi ích của cây xanh trong nhà','Cây xanh giúp lọc không khí...',1,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(12,'Cách chăm sóc cây kim tiền','Cây kim tiền là loại cây phong thủy...',2,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(13,'Top 10 loài cây giúp thanh lọc không khí','Một số cây như lưỡi hổ...',3,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(14,'Hướng dẫn chọn chậu cây phù hợp','Việc chọn chậu cây phù hợp giúp...',4,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(15,'Cách làm phân bón hữu cơ tại nhà','Phân bón hữu cơ giúp cây phát triển...',5,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(16,'Hướng dẫn làm vườn trên sân thượng','Vườn trên sân thượng đang là xu hướng...',1,'hidden','2025-03-02 05:39:15','2025-03-02 05:39:15'),(17,'Những lỗi thường gặp khi trồng cây cảnh','Nhiều người mắc sai lầm khi...',2,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(18,'Cách chọn giống hoa phù hợp theo mùa','Mỗi mùa có loại hoa phù hợp riêng...',3,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(19,'Hướng dẫn bảo dưỡng cây cảnh nội thất','Cây nội thất cần chăm sóc đúng cách...',4,'published','2025-03-02 05:39:15','2025-03-02 05:39:15'),(20,'Mẹo trồng cây không cần quá nhiều đất','Một số loại cây có thể trồng trong môi trường ít đất...',5,'hidden','2025-03-02 05:39:15','2025-03-02 05:39:15');
/*!40000 ALTER TABLE `blogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `cart_item_id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_item_id`),
  KEY `cart_id` (`cart_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`cart_id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carts`
--

DROP TABLE IF EXISTS `carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carts` (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `account` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carts`
--

LOCK TABLES `carts` WRITE;
/*!40000 ALTER TABLE `carts` DISABLE KEYS */;
/*!40000 ALTER TABLE `carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `description` text,
  `status` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Hoa Hồng','Hoa hồng biểu tượng của tình yêu và sự lãng mạn.',0,'2025-03-02 03:20:59','2025-03-02 03:32:00'),(2,'Hoa Cúc','Hoa cúc mang ý nghĩa trường thọ và sự bền vững.',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(3,'Hoa Lan','Hoa lan thể hiện sự sang trọng, quý phái.',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(4,'Hoa Ly','Hoa ly có hương thơm quyến rũ, biểu tượng cho sự tinh khiết.',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(5,'Hoa Sen','Hoa sen đại diện cho sự thanh khiết và cao quý.',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(6,'Hoa Đào','Hoa đào mang ý nghĩa may mắn, thịnh vượng.',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(7,'Hoa Mai','Hoa mai vàng tượng trưng cho sự giàu sang, phú quý.',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(8,'Hoa Tulip','Hoa tulip tượng trưng cho sự hoàn hảo và tình yêu.',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(9,'Hoa Hướng Dương','Hoa hướng dương luôn hướng về mặt trời, thể hiện sự trung thành.',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(10,'Hoa Bỉ Ngạn','Hoa bỉ ngạn mang ý nghĩa của sự chia ly và ký ức.',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(12,'test edit 01','vcxvxc',1,'2025-03-02 05:15:28','2025-03-02 05:17:51');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedbacks`
--

DROP TABLE IF EXISTS `feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedbacks` (
  `feedback_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `order_id` int DEFAULT NULL,
  `content` text NOT NULL,
  `rating` int DEFAULT NULL,
  `is_visible` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`feedback_id`),
  KEY `user_id` (`user_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `feedbacks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `account` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `feedbacks_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedbacks`
--

LOCK TABLES `feedbacks` WRITE;
/*!40000 ALTER TABLE `feedbacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_approvals`
--

DROP TABLE IF EXISTS `order_approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_approvals` (
  `approval_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `approved_by` int NOT NULL,
  `approved_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status_before` enum('pending','accepted','cancelled','completed') DEFAULT NULL,
  `status_after` enum('pending','accepted','cancelled','completed') DEFAULT NULL,
  `note` text,
  PRIMARY KEY (`approval_id`),
  KEY `order_id` (`order_id`),
  KEY `approved_by` (`approved_by`),
  CONSTRAINT `order_approvals_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_approvals_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `account` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_approvals`
--

LOCK TABLES `order_approvals` WRITE;
/*!40000 ALTER TABLE `order_approvals` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_approvals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `status` enum('pending','accepted','cancelled','completed') DEFAULT 'pending',
  `total` decimal(10,2) NOT NULL,
  `shipping_address` varchar(255) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `account` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `reset_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`reset_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `account` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `stock` int DEFAULT '0',
  `image` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (2,1,'Hoa Hồng','Hoa hồng biểu tượng của tình yêu và sự lãng mạn.',100000.00,10,'https://example.com/images/hoahong.jpg',1,'2025-03-02 03:20:59','2025-03-02 03:32:00'),(3,2,'Hoa Cúc','Hoa cúc mang ý nghĩa trường thọ và sự bền vững.',50000.00,20,'https://example.com/images/hoacuc.jpg',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(4,3,'Hoa Lan','Hoa lan thể hiện sự sang trọng, quý phái.',200000.00,15,'https://example.com/images/hoalan.jpg',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(5,4,'Hoa Ly','Hoa ly có hương thơm quyến rũ, biểu tượng cho sự tinh khiết.',150000.00,12,'https://example.com/images/hoaly.jpg',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(6,5,'Hoa Sen','Hoa sen đại diện cho sự thanh khiết và cao quý.',120000.00,8,'https://example.com/images/hoasen.jpg',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(7,6,'Hoa Đào','Hoa đào mang ý nghĩa may mắn, thịnh vượng.',180000.00,6,'https://example.com/images/hoadao.jpg',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(8,7,'Hoa Mai','Hoa mai vàng tượng trưng cho sự giàu sang, phú quý.',250000.00,10,'https://example.com/images/hoamai.jpg',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(9,8,'Hoa Tulip','Hoa tulip tượng trưng cho sự hoàn hảo và tình yêu.',300000.00,5,'https://example.com/images/hoatulip.jpg',1,'2025-03-02 03:20:59','2025-03-02 03:20:59'),(10,9,'Hoa Hướng Dương','Hoa hướng dương luôn hướng về mặt trời, thể hiện sự trung thành.',85000.00,18,'https://example.com/images/hoahuongduong.jpg',0,'2025-03-02 03:20:59','2025-03-04 00:21:14'),(11,10,'Hoa Bỉ Ngạn','Hoa bỉ ngạn mang ý nghĩa của sự chia ly và ký ức.',130000.00,7,'https://example.com/images/hoabingan.jpg',0,'2025-03-02 03:20:59','2025-03-04 08:57:11'),(14,2,'Hoa hồng 9999 heheh','1109414',1123133.00,1231414,'uploads/products/1741058111689_ChatGPT-Logo.png',1,'2025-03-04 09:43:09','2025-03-04 10:15:12'),(55,1,'Hoa Hồng Đỏ','Hoa hồng đỏ tượng trưng cho tình yêu cháy bỏng.',150000.00,20,'https://example.com/images/hoahongdo.jpg',1,'2025-03-04 10:00:00','2025-03-04 10:00:00'),(56,2,'Hoa Cúc Trắng','Hoa cúc trắng biểu tượng của sự thuần khiết.',60000.00,25,'https://example.com/images/hoacuctrang.jpg',1,'2025-03-04 10:05:00','2025-03-04 10:05:00'),(57,3,'Hoa Lan Hồ Điệp','Hoa lan hồ điệp biểu trưng cho sự thanh cao, quý phái.',220000.00,18,'https://example.com/images/hoalanhodiep.jpg',1,'2025-03-04 10:10:00','2025-03-04 10:10:00'),(58,4,'Hoa Ly Vàng','Hoa ly vàng tượng trưng cho sự sung túc và thành công.',160000.00,15,'https://example.com/images/hoalyvang.jpg',1,'2025-03-04 10:15:00','2025-03-04 10:15:00'),(59,5,'Hoa Sen Trắng','Hoa sen trắng mang ý nghĩa thanh cao, thuần khiết.',130000.00,30,'https://example.com/images/hoasentrang.jpg',1,'2025-03-04 10:20:00','2025-03-04 10:20:00'),(60,6,'Hoa Đào Phú Quý','Hoa đào phú quý mang lại may mắn cho gia chủ.',180000.00,10,'https://example.com/images/hoadaophuqui.jpg',1,'2025-03-04 10:25:00','2025-03-04 10:25:00'),(61,7,'Hoa Mai Vàng Tết','Hoa mai vàng biểu tượng cho sự phát đạt trong năm mới.',250000.00,12,'https://example.com/images/hoamaivangtet.jpg',1,'2025-03-04 10:30:00','2025-03-04 10:30:00'),(62,8,'Hoa Tulip Đỏ','Hoa tulip đỏ thể hiện tình yêu nồng cháy.',320000.00,8,'https://example.com/images/hoatulipdo.jpg',1,'2025-03-04 10:35:00','2025-03-04 10:35:00'),(63,9,'Hoa Hướng Dương Mặt Trời','Hoa hướng dương luôn hướng về mặt trời, mang lại ánh sáng cho cuộc sống.',90000.00,25,'uploads/products/1741452375793_479040236_4113763188856443_3172689062218118625_n.jpg',0,'2025-03-04 10:40:00','2025-03-08 23:49:02');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `setting_id` int NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` varchar(255) DEFAULT NULL,
  `description` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sliders`
--

DROP TABLE IF EXISTS `sliders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sliders` (
  `slider_id` int NOT NULL AUTO_INCREMENT,
  `image_url` text NOT NULL,
  `link` text,
  `caption` text,
  `status` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`slider_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sliders`
--

LOCK TABLES `sliders` WRITE;
/*!40000 ALTER TABLE `sliders` DISABLE KEYS */;
INSERT INTO `sliders` VALUES (1,'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','https://example.com/page1','Khuyến mãi mùa hè',1,'2025-03-02 06:21:03','2025-03-02 08:13:49'),(2,'https://example.com/images/slider2.jpg','https://example.com/page2','Giảm giá 50% cho thành viên mới',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(3,'https://example.com/images/slider3.jpg','https://example.com/page3','Sản phẩm mới ra mắt',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(4,'https://example.com/images/slider4.jpg','https://example.com/page4','Mua một tặng một',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(5,'https://example.com/images/slider5.jpg','https://example.com/page5','Săn deal sốc mỗi ngày',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(6,'https://example.com/images/slider6.jpg','https://example.com/page6','Ưu đãi độc quyền',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(7,'https://example.com/images/slider7.jpg','https://example.com/page7','Bộ sưu tập xuân hè 2024',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(8,'https://example.com/images/slider8.jpg','https://example.com/page8','Đăng ký nhận ưu đãi ngay',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(9,'https://example.com/images/slider9.jpg','https://example.com/page9','Chương trình khách hàng thân thiết',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(10,'https://example.com/images/slider10.jpg','https://example.com/page10','Ưu đãi chỉ có hôm nay',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(11,'https://example.com/images/slider11.jpg','https://example.com/page11','Flash sale cuối tuần',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(12,'https://example.com/images/slider12.jpg','https://example.com/page12','Cơ hội trúng thưởng iPhone',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(13,'https://example.com/images/slider13.jpg','https://example.com/page13','Mua sắm hoàn tiền lên tới 10%',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(14,'https://example.com/images/slider14.jpg','https://example.com/page14','Nhận quà ngay khi đăng ký tài khoản',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(15,'https://example.com/images/slider15.jpg','https://example.com/page15','Giảm giá cực sốc cho sản phẩm hot',1,'2025-03-02 06:21:03','2025-03-02 06:21:03'),(16,'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','','cxzczx',1,'2025-03-02 08:08:15','2025-03-02 08:08:15');
/*!40000 ALTER TABLE `sliders` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-09  0:04:41
