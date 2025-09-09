-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 05, 2025 at 02:25 PM
-- Server version: 10.6.23-MariaDB-cll-lve
-- PHP Version: 8.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `citlogis_foundation`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity`
--

CREATE TABLE `activity` (
  `id` int(11) NOT NULL,
  `my_actitvity_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` tinyint(3) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `location` varchar(250) NOT NULL,
  `start_date` varchar(100) NOT NULL,
  `end_date` varchar(100) NOT NULL,
  `image_url` varchar(200) NOT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `activity_type` varchar(200) NOT NULL,
  `budget_total` decimal(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `activity_budget`
--

CREATE TABLE `activity_budget` (
  `id` int(11) NOT NULL,
  `activity_id` int(11) NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(11,2) NOT NULL,
  `total` decimal(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `department` int(11) NOT NULL,
  `department_name` varchar(100) NOT NULL,
  `staff_name` varchar(200) NOT NULL,
  `password` varchar(100) NOT NULL,
  `mobile_number` varchar(20) NOT NULL,
  `account_code` varchar(32) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `missing` int(11) NOT NULL,
  `salary` int(11) NOT NULL,
  `account_balance` int(11) NOT NULL,
  `running` int(11) NOT NULL,
  `pending` int(11) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(32) NOT NULL,
  `gender` varchar(32) NOT NULL,
  `country` varchar(99) NOT NULL,
  `image` varchar(999) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `branch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `AmbulanceRequest`
--

CREATE TABLE `AmbulanceRequest` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL COMMENT 'User requesting the ambulance',
  `ambulanceId` int(11) DEFAULT NULL COMMENT 'Assigned ambulance ID',
  `purpose` varchar(500) NOT NULL COMMENT 'Purpose of ambulance use',
  `destination` varchar(500) NOT NULL COMMENT 'Destination address',
  `startDate` datetime(3) NOT NULL COMMENT 'Start date and time',
  `endDate` datetime(3) NOT NULL COMMENT 'End date and time',
  `notes` text DEFAULT NULL COMMENT 'Additional notes',
  `latitude` double DEFAULT NULL COMMENT 'Request location latitude',
  `longitude` double DEFAULT NULL COMMENT 'Request location longitude',
  `address` varchar(500) DEFAULT NULL COMMENT 'Request location address',
  `status` enum('pending','approved','rejected','assigned','completed','cancelled') NOT NULL DEFAULT 'pending' COMMENT 'Request status',
  `assignedBy` int(11) DEFAULT NULL COMMENT 'Admin who assigned the ambulance',
  `assignedAt` datetime(3) DEFAULT NULL COMMENT 'When ambulance was assigned',
  `completedAt` datetime(3) DEFAULT NULL COMMENT 'When request was completed',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ambulances`
--

CREATE TABLE `ambulances` (
  `id` int(11) NOT NULL,
  `reg_number` varchar(100) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Booking`
--

CREATE TABLE `Booking` (
  `id` int(11) NOT NULL,
  `roomId` int(11) NOT NULL,
  `customerId` int(11) NOT NULL,
  `checkIn` datetime(3) NOT NULL,
  `checkOut` datetime(3) NOT NULL,
  `guests` int(11) NOT NULL,
  `totalPrice` double NOT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'pending',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `BursaryApplication`
--

CREATE TABLE `BursaryApplication` (
  `id` int(11) NOT NULL,
  `childName` varchar(255) NOT NULL,
  `school` varchar(255) NOT NULL,
  `parentIncome` decimal(10,2) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `applicationDate` datetime(3) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3),
  `notes` text DEFAULT NULL,
  `userId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `BursaryPayment`
--

CREATE TABLE `BursaryPayment` (
  `id` int(11) NOT NULL,
  `studentId` int(11) NOT NULL,
  `schoolId` int(11) NOT NULL,
  `amount` double NOT NULL,
  `datePaid` datetime(3) NOT NULL,
  `referenceNumber` varchar(191) DEFAULT NULL,
  `paidBy` varchar(191) DEFAULT NULL,
  `notes` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Category`
--

CREATE TABLE `Category` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Customer`
--

CREATE TABLE `Customer` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Distribution`
--

CREATE TABLE `Distribution` (
  `id` int(11) NOT NULL,
  `journeyPlanId` int(11) NOT NULL,
  `recipientName` varchar(191) DEFAULT NULL COMMENT 'Name of the person who received the distribution',
  `recipientPhone` varchar(191) DEFAULT NULL COMMENT 'Phone number of the recipient',
  `recipientNotes` varchar(500) DEFAULT NULL COMMENT 'Additional notes about the recipient',
  `distributedBy` int(11) DEFAULT NULL COMMENT 'User ID who performed the distribution',
  `distributionDate` datetime(3) DEFAULT NULL COMMENT 'Date and time when distribution was completed',
  `photoCount` int(11) DEFAULT 0 COMMENT 'Number of photos taken during distribution',
  `finalNotes` text DEFAULT NULL COMMENT 'Final notes and observations about the distribution',
  `totalItems` int(11) DEFAULT 0 COMMENT 'Total number of items distributed',
  `distributionStatus` enum('pending','in_progress','completed','cancelled') DEFAULT 'pending' COMMENT 'Current status of the distribution process',
  `status` int(11) NOT NULL DEFAULT 0,
  `notes` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `DistributionItem`
--

CREATE TABLE `DistributionItem` (
  `id` int(11) NOT NULL,
  `distributionId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `notes` varchar(500) DEFAULT NULL,
  `distributedAt` datetime(3) DEFAULT current_timestamp(3),
  `recipientId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `DistributionPhotos`
--

CREATE TABLE `DistributionPhotos` (
  `id` int(11) NOT NULL,
  `distributionId` int(11) NOT NULL,
  `photoUrl` varchar(500) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `fileSize` int(11) DEFAULT NULL,
  `takenAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `DistributionTaskStatus`
--

CREATE TABLE `DistributionTaskStatus` (
  `id` int(11) NOT NULL,
  `distributionId` int(11) NOT NULL,
  `taskType` enum('distribute','gallery','checkout') NOT NULL,
  `isCompleted` tinyint(1) DEFAULT 0,
  `completedAt` datetime(3) DEFAULT NULL,
  `completedBy` int(11) DEFAULT NULL,
  `notes` varchar(500) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `FeedbackReport`
--

CREATE TABLE `FeedbackReport` (
  `id` int(11) NOT NULL,
  `journeyPlanId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `comment` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `reportId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `JourneyPlan`
--

CREATE TABLE `JourneyPlan` (
  `id` int(11) NOT NULL,
  `date` datetime(3) NOT NULL,
  `time` varchar(191) NOT NULL,
  `userId` int(11) NOT NULL,
  `recipientId` int(11) DEFAULT NULL,
  `locationId` int(11) DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'pending',
  `checkInTime` datetime(3) DEFAULT NULL,
  `checkInLatitude` double DEFAULT NULL,
  `checkInLongitude` double DEFAULT NULL,
  `notes` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Leave`
--

CREATE TABLE `Leave` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `leaveType` varchar(191) NOT NULL,
  `startDate` datetime(3) NOT NULL,
  `endDate` datetime(3) NOT NULL,
  `reason` varchar(191) NOT NULL,
  `attachment` varchar(191) DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'PENDING',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Location`
--

CREATE TABLE `Location` (
  `id` int(11) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `placeName` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `my_activity`
--

CREATE TABLE `my_activity` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` tinyint(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `NoticeBoard`
--

CREATE TABLE `NoticeBoard` (
  `id` int(11) NOT NULL,
  `title` varchar(191) NOT NULL,
  `content` varchar(191) NOT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Notices`
--

CREATE TABLE `Notices` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Order`
--

CREATE TABLE `Order` (
  `id` int(11) NOT NULL,
  `totalAmount` double NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `notes` varchar(191) DEFAULT NULL,
  `userId` int(11) NOT NULL,
  `recipientId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `journeyPlanId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `OrderItem`
--

CREATE TABLE `OrderItem` (
  `id` int(11) NOT NULL,
  `orderId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Product`
--

CREATE TABLE `Product` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `category` varchar(191) NOT NULL,
  `description` varchar(191) DEFAULT NULL,
  `currentStock` int(11) DEFAULT NULL,
  `image` varchar(191) DEFAULT NULL,
  `recipientId` int(11) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ProductReport`
--

CREATE TABLE `ProductReport` (
  `reportId` int(11) NOT NULL,
  `productName` varchar(191) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `comment` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Recipient`
--

CREATE TABLE `Recipient` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `contact` varchar(191) NOT NULL,
  `location` varchar(191) NOT NULL,
  `locationId` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `age` varchar(191) DEFAULT NULL,
  `idNumber` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Report`
--

CREATE TABLE `Report` (
  `id` int(11) NOT NULL,
  `type` enum('FEEDBACK','PRODUCT_AVAILABILITY','VISIBILITY') NOT NULL,
  `journeyPlanId` int(11) DEFAULT NULL,
  `orderId` int(11) DEFAULT NULL,
  `userId` int(11) NOT NULL,
  `comment` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Room`
--

CREATE TABLE `Room` (
  `id` int(11) NOT NULL,
  `title` varchar(191) NOT NULL,
  `roomTypeId` int(11) NOT NULL,
  `price` double NOT NULL,
  `description` varchar(191) NOT NULL,
  `images` text NOT NULL,
  `isAvailable` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `RoomType`
--

CREATE TABLE `RoomType` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` varchar(191) NOT NULL,
  `basePrice` double NOT NULL,
  `capacity` int(11) NOT NULL,
  `amenities` text NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `School`
--

CREATE TABLE `School` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `address` varchar(191) DEFAULT NULL,
  `contactEmail` varchar(191) DEFAULT NULL,
  `contactPhone` varchar(191) DEFAULT NULL,
  `type` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `SOS`
--

CREATE TABLE `SOS` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'active',
  `notes` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `premisesId` int(11) DEFAULT NULL,
  `locationId` int(11) DEFAULT NULL,
  `address` varchar(191) DEFAULT NULL,
  `distressType` varchar(191) DEFAULT NULL,
  `resolvedAt` datetime(3) DEFAULT NULL,
  `userName` varchar(191) DEFAULT NULL,
  `userPhone` varchar(191) DEFAULT NULL,
  `amb_id` int(11) NOT NULL,
  `amb_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Student`
--

CREATE TABLE `Student` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `admissionNumber` varchar(191) DEFAULT NULL,
  `gender` varchar(191) DEFAULT NULL,
  `dateOfBirth` datetime(3) DEFAULT NULL,
  `guardianName` varchar(191) DEFAULT NULL,
  `guardianContact` varchar(191) DEFAULT NULL,
  `schoolId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tb2`
--

CREATE TABLE `tb2` (
  `id` int(11) NOT NULL,
  `tb1_id` int(11) NOT NULL,
  `piece_id` varchar(200) NOT NULL,
  `product_name` varchar(200) NOT NULL,
  `piece_name` varchar(200) NOT NULL,
  `quantity` varchar(200) NOT NULL,
  `rate` decimal(11,2) NOT NULL,
  `total` decimal(11,2) NOT NULL,
  `month` varchar(100) NOT NULL,
  `year` varchar(100) NOT NULL,
  `created_date` varchar(100) NOT NULL,
  `my_date` varchar(100) NOT NULL,
  `status` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `staff` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Token`
--

CREATE TABLE `Token` (
  `id` int(11) NOT NULL,
  `token` varchar(191) NOT NULL,
  `userId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `expiresAt` datetime(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phoneNumber` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('USER','ADMIN','FIELD_USER','MANAGER','SUPERVISOR') NOT NULL DEFAULT 'USER',
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `photoUrl` varchar(500) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `gender` enum('MALE','FEMALE','OTHER','PREFER_NOT_TO_SAY') DEFAULT NULL,
  `nationalId` varchar(20) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `country` varchar(100) NOT NULL DEFAULT 'Kenya',
  `postalCode` varchar(20) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `emergencyContactName` varchar(255) DEFAULT NULL,
  `emergencyContactPhone` varchar(20) DEFAULT NULL,
  `emergencyContactRelationship` varchar(100) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `employeeId` varchar(50) DEFAULT NULL,
  `hireDate` date DEFAULT NULL,
  `supervisorId` int(11) DEFAULT NULL,
  `preferredLanguage` enum('ENGLISH','SWAHILI','KIKUYU','LUHYA','KALENJIN','OTHER') NOT NULL DEFAULT 'ENGLISH',
  `emailVerified` tinyint(4) NOT NULL DEFAULT 0,
  `phoneVerified` tinyint(4) NOT NULL DEFAULT 0,
  `lastLoginAt` datetime DEFAULT NULL,
  `lastLoginIp` varchar(45) DEFAULT NULL,
  `failedLoginAttempts` int(11) NOT NULL DEFAULT 0,
  `accountLocked` tinyint(4) NOT NULL DEFAULT 0,
  `lockExpiresAt` datetime DEFAULT NULL,
  `passwordChangedAt` datetime DEFAULT NULL,
  `passwordExpiresAt` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `notificationPreferences` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`notificationPreferences`)),
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('admin','user') NOT NULL DEFAULT 'user',
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `User_backup`
--

CREATE TABLE `User_backup` (
  `id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phoneNumber` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USER',
  `created_at` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updatedAt` datetime(3) NOT NULL,
  `photoUrl` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` int(2) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `VisibilityReport`
--

CREATE TABLE `VisibilityReport` (
  `reportId` int(11) NOT NULL,
  `comment` varchar(191) DEFAULT NULL,
  `imageUrl` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Visitor`
--

CREATE TABLE `Visitor` (
  `id` int(11) NOT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'pending',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `idPhotoUrl` varchar(191) DEFAULT NULL,
  `notes` varchar(191) DEFAULT NULL,
  `reasonForVisit` varchar(191) NOT NULL,
  `scheduledVisitTime` datetime(3) NOT NULL,
  `userId` int(11) NOT NULL,
  `userName` varchar(191) NOT NULL,
  `userPhone` varchar(191) NOT NULL,
  `visitorName` varchar(191) NOT NULL,
  `visitorPhone` varchar(191) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_active_users`
-- (See below for the actual view)
--
CREATE TABLE `v_active_users` (
`id` int(11)
,`name` varchar(255)
,`email` varchar(255)
,`phoneNumber` varchar(20)
,`role` enum('USER','ADMIN','FIELD_USER','MANAGER','SUPERVISOR')
,`department` varchar(100)
,`position` varchar(100)
,`firstName` varchar(100)
,`lastName` varchar(100)
,`city` varchar(100)
,`country` varchar(100)
,`created_at` datetime(6)
,`lastLoginAt` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_user_statistics`
-- (See below for the actual view)
--
CREATE TABLE `v_user_statistics` (
`role` enum('USER','ADMIN','FIELD_USER','MANAGER','SUPERVISOR')
,`total_users` bigint(21)
,`active_users` bigint(21)
,`inactive_users` bigint(21)
,`verified_users` bigint(21)
,`avg_days_since_login` decimal(11,4)
);

-- --------------------------------------------------------

--
-- Table structure for table `_DistributionRecipients`
--

CREATE TABLE `_DistributionRecipients` (
  `A` int(11) NOT NULL,
  `B` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `_prisma_migrations`
--

CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) NOT NULL,
  `checksum` varchar(64) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) NOT NULL,
  `logs` text DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity`
--
ALTER TABLE `activity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `activity_budget`
--
ALTER TABLE `activity_budget`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `AmbulanceRequest`
--
ALTER TABLE `AmbulanceRequest`
  ADD PRIMARY KEY (`id`),
  ADD KEY `AmbulanceRequest_userId_idx` (`userId`),
  ADD KEY `AmbulanceRequest_ambulanceId_idx` (`ambulanceId`),
  ADD KEY `AmbulanceRequest_status_idx` (`status`),
  ADD KEY `AmbulanceRequest_startDate_idx` (`startDate`),
  ADD KEY `AmbulanceRequest_endDate_idx` (`endDate`),
  ADD KEY `AmbulanceRequest_assignedBy_fkey` (`assignedBy`),
  ADD KEY `idx_ambulance_request_user_status` (`userId`,`status`),
  ADD KEY `idx_ambulance_request_date_range` (`startDate`,`endDate`),
  ADD KEY `idx_ambulance_request_location` (`latitude`,`longitude`);

--
-- Indexes for table `ambulances`
--
ALTER TABLE `ambulances`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Booking`
--
ALTER TABLE `Booking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Booking_roomId_idx` (`roomId`),
  ADD KEY `Booking_customerId_idx` (`customerId`);

--
-- Indexes for table `BursaryApplication`
--
ALTER TABLE `BursaryApplication`
  ADD PRIMARY KEY (`id`),
  ADD KEY `BursaryApplication_userId_idx` (`userId`),
  ADD KEY `BursaryApplication_status_idx` (`status`),
  ADD KEY `BursaryApplication_applicationDate_idx` (`applicationDate`);

--
-- Indexes for table `BursaryPayment`
--
ALTER TABLE `BursaryPayment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `BursaryPayment_studentId_fkey` (`studentId`),
  ADD KEY `BursaryPayment_schoolId_fkey` (`schoolId`);

--
-- Indexes for table `Category`
--
ALTER TABLE `Category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Customer`
--
ALTER TABLE `Customer`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Customer_email_key` (`email`);

--
-- Indexes for table `Distribution`
--
ALTER TABLE `Distribution`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Distribution_journeyPlanId_idx` (`journeyPlanId`),
  ADD KEY `idx_distribution_journey_plan` (`journeyPlanId`),
  ADD KEY `idx_distribution_status` (`distributionStatus`),
  ADD KEY `idx_distribution_date` (`distributionDate`),
  ADD KEY `idx_distribution_user` (`distributedBy`);

--
-- Indexes for table `DistributionItem`
--
ALTER TABLE `DistributionItem`
  ADD PRIMARY KEY (`id`),
  ADD KEY `DistributionItem_distributionId_idx` (`distributionId`),
  ADD KEY `DistributionItem_productId_idx` (`productId`),
  ADD KEY `DistributionItem_recipientId_idx` (`recipientId`),
  ADD KEY `idx_distribution_item_distribution` (`distributionId`),
  ADD KEY `idx_distribution_item_product` (`productId`),
  ADD KEY `idx_distribution_item_recipient` (`recipientId`);

--
-- Indexes for table `DistributionPhotos`
--
ALTER TABLE `DistributionPhotos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `DistributionPhotos_distributionId_idx` (`distributionId`);

--
-- Indexes for table `DistributionTaskStatus`
--
ALTER TABLE `DistributionTaskStatus`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `DistributionTaskStatus_distributionId_taskType_unique` (`distributionId`,`taskType`),
  ADD KEY `DistributionTaskStatus_distributionId_idx` (`distributionId`);

--
-- Indexes for table `FeedbackReport`
--
ALTER TABLE `FeedbackReport`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `FeedbackReport_reportId_key` (`reportId`),
  ADD KEY `FeedbackReport_userId_idx` (`userId`),
  ADD KEY `FeedbackReport_journeyPlanId_idx` (`journeyPlanId`);

--
-- Indexes for table `JourneyPlan`
--
ALTER TABLE `JourneyPlan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `JourneyPlan_userId_idx` (`userId`),
  ADD KEY `JourneyPlan_recipientId_idx` (`recipientId`),
  ADD KEY `fk_journeyplan_location` (`locationId`);

--
-- Indexes for table `Leave`
--
ALTER TABLE `Leave`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Leave_userId_idx` (`userId`);

--
-- Indexes for table `Location`
--
ALTER TABLE `Location`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_location_coordinates` (`latitude`,`longitude`);

--
-- Indexes for table `my_activity`
--
ALTER TABLE `my_activity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `NoticeBoard`
--
ALTER TABLE `NoticeBoard`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Notices`
--
ALTER TABLE `Notices`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Order`
--
ALTER TABLE `Order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Order_userId_idx` (`userId`),
  ADD KEY `Order_recipientId_idx` (`recipientId`),
  ADD KEY `Order_journeyPlanId_idx` (`journeyPlanId`);

--
-- Indexes for table `OrderItem`
--
ALTER TABLE `OrderItem`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `OrderItem_orderId_productId_key` (`orderId`,`productId`),
  ADD KEY `OrderItem_orderId_idx` (`orderId`),
  ADD KEY `OrderItem_productId_idx` (`productId`);

--
-- Indexes for table `Product`
--
ALTER TABLE `Product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Product_recipientId_idx` (`recipientId`);

--
-- Indexes for table `ProductReport`
--
ALTER TABLE `ProductReport`
  ADD PRIMARY KEY (`reportId`);

--
-- Indexes for table `Recipient`
--
ALTER TABLE `Recipient`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_recipient_location` (`locationId`);

--
-- Indexes for table `Report`
--
ALTER TABLE `Report`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Report_userId_idx` (`userId`),
  ADD KEY `Report_journeyPlanId_idx` (`journeyPlanId`),
  ADD KEY `Report_orderId_idx` (`orderId`);

--
-- Indexes for table `Room`
--
ALTER TABLE `Room`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Room_roomTypeId_idx` (`roomTypeId`);

--
-- Indexes for table `RoomType`
--
ALTER TABLE `RoomType`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `RoomType_name_key` (`name`);

--
-- Indexes for table `School`
--
ALTER TABLE `School`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `SOS`
--
ALTER TABLE `SOS`
  ADD PRIMARY KEY (`id`),
  ADD KEY `SOS_userId_idx` (`userId`),
  ADD KEY `fk_sos_location` (`locationId`);

--
-- Indexes for table `Student`
--
ALTER TABLE `Student`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Student_schoolId_fkey` (`schoolId`);

--
-- Indexes for table `tb2`
--
ALTER TABLE `tb2`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Token`
--
ALTER TABLE `Token`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Token_token_key` (`token`),
  ADD KEY `Token_userId_idx` (`userId`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `IDX_4a257d2c9837248d70640b3e36` (`email`),
  ADD UNIQUE KEY `IDX_a3a6ca48a99127554da5314f64` (`phoneNumber`),
  ADD UNIQUE KEY `IDX_5f8e78b4104bed6d543de36b39` (`nationalId`),
  ADD UNIQUE KEY `IDX_61451fc955dbcbd690dadc1ac4` (`employeeId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `VisibilityReport`
--
ALTER TABLE `VisibilityReport`
  ADD PRIMARY KEY (`reportId`);

--
-- Indexes for table `Visitor`
--
ALTER TABLE `Visitor`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Visitor_userId_idx` (`userId`);

--
-- Indexes for table `_DistributionRecipients`
--
ALTER TABLE `_DistributionRecipients`
  ADD UNIQUE KEY `_DistributionRecipients_AB_unique` (`A`,`B`),
  ADD KEY `_DistributionRecipients_B_index` (`B`);

--
-- Indexes for table `_prisma_migrations`
--
ALTER TABLE `_prisma_migrations`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity`
--
ALTER TABLE `activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `activity_budget`
--
ALTER TABLE `activity_budget`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `AmbulanceRequest`
--
ALTER TABLE `AmbulanceRequest`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ambulances`
--
ALTER TABLE `ambulances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Booking`
--
ALTER TABLE `Booking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `BursaryApplication`
--
ALTER TABLE `BursaryApplication`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `BursaryPayment`
--
ALTER TABLE `BursaryPayment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Category`
--
ALTER TABLE `Category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Customer`
--
ALTER TABLE `Customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Distribution`
--
ALTER TABLE `Distribution`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `DistributionItem`
--
ALTER TABLE `DistributionItem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `DistributionPhotos`
--
ALTER TABLE `DistributionPhotos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `DistributionTaskStatus`
--
ALTER TABLE `DistributionTaskStatus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `FeedbackReport`
--
ALTER TABLE `FeedbackReport`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `JourneyPlan`
--
ALTER TABLE `JourneyPlan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Leave`
--
ALTER TABLE `Leave`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Location`
--
ALTER TABLE `Location`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `my_activity`
--
ALTER TABLE `my_activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `NoticeBoard`
--
ALTER TABLE `NoticeBoard`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Notices`
--
ALTER TABLE `Notices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Order`
--
ALTER TABLE `Order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `OrderItem`
--
ALTER TABLE `OrderItem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Product`
--
ALTER TABLE `Product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Recipient`
--
ALTER TABLE `Recipient`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Report`
--
ALTER TABLE `Report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Room`
--
ALTER TABLE `Room`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `RoomType`
--
ALTER TABLE `RoomType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `School`
--
ALTER TABLE `School`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `SOS`
--
ALTER TABLE `SOS`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Student`
--
ALTER TABLE `Student`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb2`
--
ALTER TABLE `tb2`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Token`
--
ALTER TABLE `Token`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Visitor`
--
ALTER TABLE `Visitor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- --------------------------------------------------------

--
-- Structure for view `v_active_users`
--
DROP TABLE IF EXISTS `v_active_users`;

CREATE ALGORITHM=UNDEFINED DEFINER=`citlogis`@`localhost` SQL SECURITY DEFINER VIEW `v_active_users`  AS SELECT `User`.`id` AS `id`, `User`.`name` AS `name`, `User`.`email` AS `email`, `User`.`phoneNumber` AS `phoneNumber`, `User`.`role` AS `role`, `User`.`department` AS `department`, `User`.`position` AS `position`, `User`.`firstName` AS `firstName`, `User`.`lastName` AS `lastName`, `User`.`city` AS `city`, `User`.`country` AS `country`, `User`.`created_at` AS `created_at`, `User`.`lastLoginAt` AS `lastLoginAt` FROM `User` WHERE `User`.`status` = 1 ;

-- --------------------------------------------------------

--
-- Structure for view `v_user_statistics`
--
DROP TABLE IF EXISTS `v_user_statistics`;

CREATE ALGORITHM=UNDEFINED DEFINER=`citlogis`@`localhost` SQL SECURITY DEFINER VIEW `v_user_statistics`  AS SELECT `User`.`role` AS `role`, count(0) AS `total_users`, count(case when `User`.`status` = 1 then 1 end) AS `active_users`, count(case when `User`.`status` = 0 then 1 end) AS `inactive_users`, count(case when `User`.`emailVerified` = 1 then 1 end) AS `verified_users`, avg(case when `User`.`lastLoginAt` is not null then to_days(current_timestamp()) - to_days(`User`.`lastLoginAt`) end) AS `avg_days_since_login` FROM `User` GROUP BY `User`.`role` ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `AmbulanceRequest`
--
ALTER TABLE `AmbulanceRequest`
  ADD CONSTRAINT `AmbulanceRequest_ambulanceId_fkey` FOREIGN KEY (`ambulanceId`) REFERENCES `ambulances` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `AmbulanceRequest_assignedBy_fkey` FOREIGN KEY (`assignedBy`) REFERENCES `admin_users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `AmbulanceRequest_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Booking`
--
ALTER TABLE `Booking`
  ADD CONSTRAINT `Booking_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `Customer` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `Booking_roomId_fkey` FOREIGN KEY (`roomId`) REFERENCES `Room` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `BursaryApplication`
--
ALTER TABLE `BursaryApplication`
  ADD CONSTRAINT `BursaryApplication_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `BursaryPayment`
--
ALTER TABLE `BursaryPayment`
  ADD CONSTRAINT `BursaryPayment_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `School` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `BursaryPayment_studentId_fkey` FOREIGN KEY (`studentId`) REFERENCES `Student` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Distribution`
--
ALTER TABLE `Distribution`
  ADD CONSTRAINT `Distribution_distributedBy_fkey` FOREIGN KEY (`distributedBy`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Distribution_journeyPlanId_fkey` FOREIGN KEY (`journeyPlanId`) REFERENCES `JourneyPlan` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `DistributionItem`
--
ALTER TABLE `DistributionItem`
  ADD CONSTRAINT `DistributionItem_distributionId_fkey` FOREIGN KEY (`distributionId`) REFERENCES `Distribution` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `DistributionItem_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `DistributionItem_recipientId_fkey` FOREIGN KEY (`recipientId`) REFERENCES `Recipient` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `DistributionPhotos`
--
ALTER TABLE `DistributionPhotos`
  ADD CONSTRAINT `DistributionPhotos_distributionId_fkey` FOREIGN KEY (`distributionId`) REFERENCES `Distribution` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `DistributionTaskStatus`
--
ALTER TABLE `DistributionTaskStatus`
  ADD CONSTRAINT `DistributionTaskStatus_distributionId_fkey` FOREIGN KEY (`distributionId`) REFERENCES `Distribution` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `FeedbackReport`
--
ALTER TABLE `FeedbackReport`
  ADD CONSTRAINT `FeedbackReport_journeyPlanId_fkey` FOREIGN KEY (`journeyPlanId`) REFERENCES `JourneyPlan` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `FeedbackReport_reportId_fkey` FOREIGN KEY (`reportId`) REFERENCES `Report` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `FeedbackReport_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `JourneyPlan`
--
ALTER TABLE `JourneyPlan`
  ADD CONSTRAINT `JourneyPlan_recipientId_fkey` FOREIGN KEY (`recipientId`) REFERENCES `Recipient` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `JourneyPlan_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_journeyplan_location` FOREIGN KEY (`locationId`) REFERENCES `Location` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `Leave`
--
ALTER TABLE `Leave`
  ADD CONSTRAINT `Leave_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Order`
--
ALTER TABLE `Order`
  ADD CONSTRAINT `Order_journeyPlanId_fkey` FOREIGN KEY (`journeyPlanId`) REFERENCES `JourneyPlan` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Order_recipientId_fkey` FOREIGN KEY (`recipientId`) REFERENCES `Recipient` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `Order_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `OrderItem`
--
ALTER TABLE `OrderItem`
  ADD CONSTRAINT `OrderItem_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `OrderItem_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Product`
--
ALTER TABLE `Product`
  ADD CONSTRAINT `Product_recipientId_fkey` FOREIGN KEY (`recipientId`) REFERENCES `Recipient` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `ProductReport`
--
ALTER TABLE `ProductReport`
  ADD CONSTRAINT `ProductReport_reportId_fkey` FOREIGN KEY (`reportId`) REFERENCES `Report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Recipient`
--
ALTER TABLE `Recipient`
  ADD CONSTRAINT `fk_recipient_location` FOREIGN KEY (`locationId`) REFERENCES `Location` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `Report`
--
ALTER TABLE `Report`
  ADD CONSTRAINT `Report_journeyPlanId_fkey` FOREIGN KEY (`journeyPlanId`) REFERENCES `JourneyPlan` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Report_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Report_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Room`
--
ALTER TABLE `Room`
  ADD CONSTRAINT `Room_roomTypeId_fkey` FOREIGN KEY (`roomTypeId`) REFERENCES `RoomType` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `SOS`
--
ALTER TABLE `SOS`
  ADD CONSTRAINT `SOS_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sos_location` FOREIGN KEY (`locationId`) REFERENCES `Location` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `Student`
--
ALTER TABLE `Student`
  ADD CONSTRAINT `Student_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `School` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Token`
--
ALTER TABLE `Token`
  ADD CONSTRAINT `Token_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `VisibilityReport`
--
ALTER TABLE `VisibilityReport`
  ADD CONSTRAINT `VisibilityReport_reportId_fkey` FOREIGN KEY (`reportId`) REFERENCES `Report` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Visitor`
--
ALTER TABLE `Visitor`
  ADD CONSTRAINT `Visitor_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `_DistributionRecipients`
--
ALTER TABLE `_DistributionRecipients`
  ADD CONSTRAINT `_DistributionRecipients_A_fkey` FOREIGN KEY (`A`) REFERENCES `Distribution` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `_DistributionRecipients_B_fkey` FOREIGN KEY (`B`) REFERENCES `Recipient` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
