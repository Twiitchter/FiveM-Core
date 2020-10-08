-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.12-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for core
CREATE DATABASE IF NOT EXISTS `core` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `core`;

-- Dumping structure for table core.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Default ID - Auto Inc on new insert.',
  `FiveM_ID` varchar(50) DEFAULT NULL COMMENT 'The Character Owner\\',
  `Character_ID` varchar(50) DEFAULT NULL COMMENT 'The Character ID to be called as reference, C00:Unique_ID/C01:Unique_ID/C02:Unique_ID etc...',
  `Created` timestamp NOT NULL DEFAULT current_timestamp(),
  `City_ID` varchar(10) DEFAULT NULL COMMENT 'City ID / Licence to be used for Government Actions',
  `First_Name` varchar(25) DEFAULT NULL,
  `Last_Name` varchar(25) DEFAULT NULL,
  `Birth_Date` varchar(10) DEFAULT NULL COMMENT 'The Characters DOB in DD/MM/YYYY format.',
  `Height` int(3) DEFAULT NULL COMMENT 'The Characters height in CM.',
  `Appearance` longtext DEFAULT '{"sex":0}',
  `Inventory` longtext DEFAULT '{"cash":0}',
  `Coords` varchar(255) DEFAULT '{"x":-1050.30, "y":-2740.95, "z":14.6}' COMMENT 'Last Position Saved...',
  `Active` tinyint(1) DEFAULT NULL,
  `Wanted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Character_ID` (`Character_ID`),
  KEY `First_Name` (`First_Name`),
  KEY `Last_Name` (`Last_Name`),
  KEY `City_ID` (`City_ID`),
  KEY `Coords` (`Coords`),
  KEY `Wanted` (`Wanted`),
  KEY `Active` (`Active`),
  KEY `FiveM_ID` (`FiveM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Character Table';

-- Data exporting was unselected.

-- Dumping structure for table core.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `City_Role` tinyint(1) NOT NULL DEFAULT 0,
  `Name` varchar(50) DEFAULT NULL,
  `Rates` longtext DEFAULT '{}',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table core.users
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Default ID - Auto Inc on new insert.',
  `FiveM_ID` varchar(50) DEFAULT NULL COMMENT 'Unique ID assigned by FiveM (The Licence)',
  `Steam_ID` varchar(50) DEFAULT NULL COMMENT 'Unique ID assigned by Steam',
  `Discord_ID` varchar(50) DEFAULT NULL COMMENT 'Unique ID assigned by Discord',
  `Group` varchar(10) DEFAULT 'public' COMMENT 'All users are Public, Moderators are Mods and Admins are Admins. No Higher Roler than Admin.',
  `Join_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `Last_Login` timestamp NOT NULL DEFAULT current_timestamp(),
  `IP_Address` varchar(18) DEFAULT NULL COMMENT 'Last Connected IP Address',
  `Language_Key` varchar(4) DEFAULT NULL COMMENT 'Language Preferance as Key',
  `Ban_Status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 is Not Banned. 1 is Banned.',
  `Supporter_Status` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `FiveM_ID` (`FiveM_ID`),
  KEY `Discord_ID` (`Discord_ID`),
  KEY `Steam_ID` (`Steam_ID`),
  KEY `Language_Key` (`Language_Key`),
  KEY `IP_Address` (`IP_Address`),
  KEY `Ban_Status` (`Ban_Status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Users Table';

-- Data exporting was unselected.

-- Dumping structure for table core.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Plate` varchar(8) DEFAULT NULL,
  `City_Owned` tinyint(1) NOT NULL DEFAULT 0,
  `Department` varchar(25) DEFAULT NULL,
  `Character_ID` varchar(50) DEFAULT NULL,
  `City_ID` varchar(8) DEFAULT NULL,
  `Inventory` longtext DEFAULT '{}',
  `Health` longtext DEFAULT '{}',
  `Mods` longtext DEFAULT '{}',
  `Repairing` tinyint(1) DEFAULT 0,
  `Repair_InTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `Repair_OutTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `Wanted` tinyint(1) DEFAULT 0,
  `Impounded` tinyint(1) DEFAULT 0,
  `Impound_InTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `Impound_OutTime` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Plate` (`Plate`),
  KEY `Character_ID` (`Character_ID`),
  KEY `City_Owned` (`City_Owned`),
  KEY `Department` (`Department`),
  KEY `Wanted` (`Wanted`),
  KEY `Repairing` (`Repairing`),
  KEY `Impounded` (`Impounded`),
  KEY `City_ID` (`City_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
