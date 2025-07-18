-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: dbms_project
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `train_id` int NOT NULL,
  `schedule_id` int NOT NULL,
  `seat_no` varchar(10) NOT NULL,
  `status` enum('confirmed','waiting') DEFAULT 'confirmed',
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `unique_seat_booking` (`schedule_id`,`seat_no`),
  KEY `user_id` (`user_id`),
  KEY `train_id` (`train_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`train_id`) REFERENCES `trains` (`train_id`),
  CONSTRAINT `bookings_ibfk_3` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`schedule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,2,1,1,'A1','confirmed'),(2,3,3,3,'A4','confirmed'),(3,4,5,5,'A3','confirmed'),(4,5,6,10,'A1','confirmed'),(5,6,6,10,'A2','confirmed'),(6,7,1,1,'A4','confirmed'),(7,8,1,1,'A2','confirmed'),(8,9,1,1,'A3','confirmed');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedules` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `train_id` int NOT NULL,
  `departure_station` int NOT NULL,
  `arrival_station` int NOT NULL,
  `dep_time` time NOT NULL,
  `arr_time` time NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`schedule_id`),
  KEY `train_id` (`train_id`),
  KEY `departure_station` (`departure_station`),
  KEY `arrival_station` (`arrival_station`),
  CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `trains` (`train_id`),
  CONSTRAINT `schedules_ibfk_2` FOREIGN KEY (`departure_station`) REFERENCES `stations` (`station_id`),
  CONSTRAINT `schedules_ibfk_3` FOREIGN KEY (`arrival_station`) REFERENCES `stations` (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` VALUES (1,1,1,2,'06:00:00','12:00:00','2025-05-15'),(2,2,2,1,'14:00:00','20:00:00','2025-05-15'),(3,3,3,4,'17:00:00','10:00:00','2025-05-16'),(4,4,4,3,'09:00:00','22:00:00','2025-05-16'),(5,5,1,2,'18:00:00','23:00:00','2025-05-17'),(10,6,5,6,'08:00:00','10:00:00','2024-05-20'),(11,7,6,7,'11:00:00','13:00:00','2024-05-20'),(12,8,7,1,'14:00:00','18:00:00','2024-05-21'),(13,9,1,5,'09:00:00','13:00:00','2024-05-21');
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stations`
--

DROP TABLE IF EXISTS `stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stations` (
  `station_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `city` varchar(50) NOT NULL,
  PRIMARY KEY (`station_id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stations`
--

LOCK TABLES `stations` WRITE;
/*!40000 ALTER TABLE `stations` DISABLE KEYS */;
INSERT INTO `stations` VALUES (1,'Bangalore','BLR','Bangalore'),(2,'Chennai','MAA','Chennai'),(3,'Mumbai','BOM','Mumbai'),(4,'Delhi','DEL','Delhi'),(5,'Mangalore','MAQ','Mangalore'),(6,'Puttur','PUT','Puttur'),(7,'Kannur','CAN','Kannur');
/*!40000 ALTER TABLE `stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trains`
--

DROP TABLE IF EXISTS `trains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trains` (
  `train_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` varchar(50) NOT NULL,
  `capacity` int NOT NULL,
  PRIMARY KEY (`train_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trains`
--

LOCK TABLES `trains` WRITE;
/*!40000 ALTER TABLE `trains` DISABLE KEYS */;
INSERT INTO `trains` VALUES (1,'Karnataka Express','Express',1000),(2,'Chennai Mail','Mail',1200),(3,'Mumbai Rajdhani','Rajdhani',800),(4,'Delhi Express','Express',1100),(5,'Bangalore Shatabdi','Shatabdi',900),(6,'Puttur Express','Express',200),(7,'Kannur Mail','Mail',180),(8,'Bangalore City Express','Express',250),(9,'Mangalore Central Express','Express',220);
/*!40000 ALTER TABLE `trains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'Snehil','Snehil@gmail.com','Snehil@123','user'),(3,'Shreyas','Shreyas@gmail.com','shreyas18','user'),(4,'Gayan','Gayan@gmail.com','Gangu@123','user'),(5,'Yatheen','Yatheen@gmail.com','Yatheen@1528','user'),(6,'Swasthik','swasthik@gmail.com','Swasthik@123','user'),(7,'Shashank','Shashank@gmail.com','Shashank@123','user'),(8,'konaki','Konaki@gmail.com','Konaki@os','user'),(9,'Devikrishna','Devikrishna@gmail.com','Devikrishna@123','user');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-17 12:13:25
