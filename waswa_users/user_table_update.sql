-- JLW Foundation - User Table Update Script
-- This script updates the existing User table with comprehensive fields

-- First, backup existing data (if any)
CREATE TABLE IF NOT EXISTS User_backup AS SELECT * FROM User;

-- Drop existing User table
DROP TABLE IF EXISTS User;

-- Create comprehensive User table
CREATE TABLE `User` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'Full name of the user',
  `email` varchar(255) NOT NULL COMMENT 'User email address (unique)',
  `phoneNumber` varchar(20) NOT NULL COMMENT 'User phone number (unique)',
  `password` varchar(255) NOT NULL COMMENT 'Hashed password',
  `role` enum('USER','ADMIN','FIELD_USER','MANAGER','SUPERVISOR') NOT NULL DEFAULT 'USER' COMMENT 'User role in the system',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Account creation date',
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update timestamp',
  `photoUrl` varchar(500) DEFAULT NULL COMMENT 'Profile photo URL',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Account status: 1=active, 0=inactive, 2=suspended',
  
  -- Additional personal information
  `firstName` varchar(100) DEFAULT NULL COMMENT 'First name',
  `lastName` varchar(100) DEFAULT NULL COMMENT 'Last name',
  `dateOfBirth` date DEFAULT NULL COMMENT 'Date of birth',
  `gender` enum('MALE','FEMALE','OTHER','PREFER_NOT_TO_SAY') DEFAULT NULL COMMENT 'Gender',
  `nationalId` varchar(20) DEFAULT NULL COMMENT 'National ID number',
  `passportNumber` varchar(20) DEFAULT NULL COMMENT 'Passport number if applicable',
  
  -- Address information
  `address` text DEFAULT NULL COMMENT 'Full address',
  `city` varchar(100) DEFAULT NULL COMMENT 'City',
  `state` varchar(100) DEFAULT NULL COMMENT 'State/Province',
  `country` varchar(100) DEFAULT 'Kenya' COMMENT 'Country',
  `postalCode` varchar(20) DEFAULT NULL COMMENT 'Postal/ZIP code',
  `latitude` decimal(10,8) DEFAULT NULL COMMENT 'GPS latitude',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT 'GPS longitude',
  
  -- Emergency contact
  `emergencyContactName` varchar(255) DEFAULT NULL COMMENT 'Emergency contact person name',
  `emergencyContactPhone` varchar(20) DEFAULT NULL COMMENT 'Emergency contact phone',
  `emergencyContactRelationship` varchar(100) DEFAULT NULL COMMENT 'Relationship to emergency contact',
  
  -- Work/Foundation related
  `department` varchar(100) DEFAULT NULL COMMENT 'Department within the foundation',
  `position` varchar(100) DEFAULT NULL COMMENT 'Job position/title',
  `employeeId` varchar(50) DEFAULT NULL COMMENT 'Employee ID if applicable',
  `hireDate` date DEFAULT NULL COMMENT 'Date hired/joined foundation',
  `supervisorId` int(11) DEFAULT NULL COMMENT 'ID of user''s supervisor',
  
  -- Communication preferences
  `preferredLanguage` enum('ENGLISH','SWAHILI','KIKUYU','LUHYA','KALENJIN','OTHER') DEFAULT 'ENGLISH' COMMENT 'Preferred language',
  `notificationPreferences` json DEFAULT NULL COMMENT 'JSON object for notification settings',
  `emailVerified` tinyint(1) DEFAULT 0 COMMENT 'Email verification status',
  `phoneVerified` tinyint(1) DEFAULT 0 COMMENT 'Phone verification status',
  
  -- Security and access
  `lastLoginAt` datetime DEFAULT NULL COMMENT 'Last login timestamp',
  `lastLoginIp` varchar(45) DEFAULT NULL COMMENT 'Last login IP address',
  `failedLoginAttempts` int(11) DEFAULT 0 COMMENT 'Count of failed login attempts',
  `accountLocked` tinyint(1) DEFAULT 0 COMMENT 'Account lock status',
  `lockExpiresAt` datetime DEFAULT NULL COMMENT 'Account lock expiration',
  `passwordChangedAt` datetime DEFAULT NULL COMMENT 'Last password change timestamp',
  `passwordExpiresAt` datetime DEFAULT NULL COMMENT 'Password expiration date',
  
  -- Additional metadata
  `notes` text DEFAULT NULL COMMENT 'Additional notes about the user',
  `tags` json DEFAULT NULL COMMENT 'JSON array of user tags',
  `metadata` json DEFAULT NULL COMMENT 'Additional metadata in JSON format',
  
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_email_key` (`email`),
  UNIQUE KEY `User_phoneNumber_key` (`phoneNumber`),
  UNIQUE KEY `User_nationalId_key` (`nationalId`),
  UNIQUE KEY `User_employeeId_key` (`employeeId`),
  KEY `idx_user_role` (`role`),
  KEY `idx_user_status` (`status`),
  KEY `idx_user_department` (`department`),
  KEY `idx_user_supervisor` (`supervisorId`),
  KEY `idx_user_location` (`latitude`, `longitude`),
  KEY `idx_user_created_at` (`created_at`),
  KEY `idx_user_last_login` (`lastLoginAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Comprehensive user management table for JLW Foundation';

-- Insert sample users with the new structure
INSERT INTO `User` (
  `name`, `email`, `phoneNumber`, `password`, `role`, `created_at`, `updatedAt`, 
  `status`, `firstName`, `lastName`, `nationalId`, `address`, `city`, `country`,
  `emergencyContactName`, `emergencyContactPhone`, `department`, `position`
) VALUES
(
  'Test User', 
  'test@example.com', 
  '0706166875', 
  '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 
  'USER', 
  NOW(), 
  NOW(), 
  1, 
  'Test', 
  'User', 
  '12345678', 
  'Nairobi, Kenya', 
  'Nairobi', 
  'Kenya',
  'Emergency Contact',
  '0700000000',
  'Field Operations',
  'Field Staff'
),
(
  'Benjamin OKwama', 
  'admin@foundation.com', 
  '+254711987654', 
  '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 
  'ADMIN', 
  NOW(), 
  NOW(), 
  1, 
  'Benjamin', 
  'OKwama', 
  '87654321', 
  'Kitale, Kenya', 
  'Kitale', 
  'Kenya',
  'Admin Emergency',
  '+254700000000',
  'Administration',
  'System Administrator'
),
(
  'John Doe', 
  'john.doe@foundation.com', 
  '+254722333444', 
  '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 
  'FIELD_USER', 
  NOW(), 
  NOW(), 
  1, 
  'John', 
  'Doe', 
  '11223344', 
  'Eldoret, Kenya', 
  'Eldoret', 
  'Kenya',
  'Jane Doe',
  '+254733444555',
  'Field Operations',
  'Field Coordinator'
);

-- Create indexes for better performance
CREATE INDEX `idx_user_email_status` ON `User` (`email`, `status`);
CREATE INDEX `idx_user_phone_status` ON `User` (`phoneNumber`, `status`);
CREATE INDEX `idx_user_role_status` ON `User` (`role`, `status`);
CREATE INDEX `idx_user_department_status` ON `User` (`department`, `status`);

-- Add foreign key constraint for supervisor relationship (self-referencing)
ALTER TABLE `User` 
ADD CONSTRAINT `fk_user_supervisor` 
FOREIGN KEY (`supervisorId`) REFERENCES `User` (`id`) 
ON DELETE SET NULL ON UPDATE CASCADE;

-- Create a view for active users
CREATE VIEW `v_active_users` AS
SELECT 
  id, name, email, phoneNumber, role, department, position,
  firstName, lastName, city, country, created_at, lastLoginAt
FROM `User` 
WHERE status = 1;

-- Create a view for user statistics
CREATE VIEW `v_user_statistics` AS
SELECT 
  role,
  COUNT(*) as total_users,
  COUNT(CASE WHEN status = 1 THEN 1 END) as active_users,
  COUNT(CASE WHEN status = 0 THEN 1 END) as inactive_users,
  COUNT(CASE WHEN emailVerified = 1 THEN 1 END) as verified_users,
  AVG(CASE WHEN lastLoginAt IS NOT NULL THEN DATEDIFF(NOW(), lastLoginAt) END) as avg_days_since_login
FROM `User` 
GROUP BY role;

-- Insert additional sample data for testing
INSERT INTO `User` (
  `name`, `email`, `phoneNumber`, `password`, `role`, `created_at`, `updatedAt`, 
  `status`, `firstName`, `lastName`, `nationalId`, `address`, `city`, `country`,
  `emergencyContactName`, `emergencyContactPhone`, `department`, `position`
) VALUES
(
  'Sarah Muthoni', 
  'sarah.muthoni@foundation.com', 
  '+254733111222', 
  '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 
  'MANAGER', 
  NOW(), 
  NOW(), 
  1, 
  'Sarah', 
  'Muthoni', 
  '55667788', 
  'Nakuru, Kenya', 
  'Nakuru', 
  'Kenya',
  'James Muthoni',
  '+254744222333',
  'Field Operations',
  'Field Manager'
),
(
  'David Ochieng', 
  'david.ochieng@foundation.com', 
  '+254744333444', 
  '$2a$10$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG', 
  'SUPERVISOR', 
  NOW(), 
  NOW(), 
  1, 
  'David', 
  'Ochieng', 
  '99887766', 
  'Kisumu, Kenya', 
  'Kisumu', 
  'Kenya',
  'Mary Ochieng',
  '+254755444555',
  'Field Operations',
  'Field Supervisor'
);

-- Update the sample users to have proper supervisor relationships
UPDATE `User` SET `supervisorId` = 4 WHERE `id` = 3; -- John Doe reports to Sarah Muthoni
UPDATE `User` SET `supervisorId` = 4 WHERE `id` = 5; -- David Ochieng reports to Sarah Muthoni

-- Create a stored procedure for user authentication
DELIMITER //
CREATE PROCEDURE `sp_authenticate_user`(
  IN p_email_or_phone VARCHAR(255),
  IN p_password VARCHAR(255)
)
BEGIN
  DECLARE v_user_id INT;
  DECLARE v_user_status TINYINT;
  DECLARE v_failed_attempts INT;
  
  -- Find user by email or phone
  SELECT id, status, failedLoginAttempts 
  INTO v_user_id, v_user_status, v_failed_attempts
  FROM `User` 
  WHERE (email = p_email_or_phone OR phoneNumber = p_email_or_phone)
    AND password = p_password;
  
  -- Check if user exists and password is correct
  IF v_user_id IS NOT NULL THEN
    -- Check if account is locked
    IF v_user_status = 0 THEN
      SELECT 'ACCOUNT_INACTIVE' as result, NULL as user_id;
    ELSEIF v_user_status = 2 THEN
      SELECT 'ACCOUNT_SUSPENDED' as result, NULL as user_id;
    ELSE
      -- Reset failed attempts and update last login
      UPDATE `User` 
      SET failedLoginAttempts = 0, 
          lastLoginAt = NOW(),
          lastLoginIp = USER()
      WHERE id = v_user_id;
      
      SELECT 'SUCCESS' as result, v_user_id as user_id;
    END IF;
  ELSE
    -- Increment failed attempts for the email/phone
    UPDATE `User` 
    SET failedLoginAttempts = failedLoginAttempts + 1
    WHERE email = p_email_or_phone OR phoneNumber = p_email_or_phone;
    
    SELECT 'INVALID_CREDENTIALS' as result, NULL as user_id;
  END IF;
END //
DELIMITER ;

-- Create a stored procedure for user registration
DELIMITER //
CREATE PROCEDURE `sp_register_user`(
  IN p_name VARCHAR(255),
  IN p_email VARCHAR(255),
  IN p_phone VARCHAR(20),
  IN p_password VARCHAR(255),
  IN p_role ENUM('USER','ADMIN','FIELD_USER','MANAGER','SUPERVISOR'),
  IN p_national_id VARCHAR(20),
  IN p_address TEXT,
  IN p_city VARCHAR(100),
  IN p_country VARCHAR(100)
)
BEGIN
  DECLARE v_user_id INT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  
  START TRANSACTION;
  
  -- Check if email or phone already exists
  IF EXISTS(SELECT 1 FROM `User` WHERE email = p_email OR phoneNumber = p_phone) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User with this email or phone already exists';
  END IF;
  
  -- Insert new user
  INSERT INTO `User` (
    name, email, phoneNumber, password, role, created_at, updatedAt,
    status, nationalId, address, city, country
  ) VALUES (
    p_name, p_email, p_phone, p_password, p_role, NOW(), NOW(),
    1, p_national_id, p_address, p_city, p_country
  );
  
  SET v_user_id = LAST_INSERT_ID();
  
  COMMIT;
  
  SELECT v_user_id as user_id, 'SUCCESS' as result;
END //
DELIMITER ;

-- Grant permissions (adjust as needed for your database user)
-- GRANT SELECT, INSERT, UPDATE, DELETE ON `User` TO 'your_app_user'@'%';
-- GRANT EXECUTE ON PROCEDURE `sp_authenticate_user` TO 'your_app_user'@'%';
-- GRANT EXECUTE ON PROCEDURE `sp_register_user` TO 'your_app_user'@'%';

-- Show the final table structure
DESCRIBE `User`;

-- Show sample data
SELECT id, name, email, phoneNumber, role, status, department, position, created_at 
FROM `User` 
ORDER BY id;
