class AppConstants {
  // App Information
  static const String appName = 'JLW Foundation';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'foundation.db';
  static const int databaseVersion = 1;
  
  // API Endpoints (if needed in future)
  static const String baseUrl = 'https://jlw-api.vercel.app/api/v1';
  
  // Shared Preferences Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String isLoggedInKey = 'is_logged_in';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred.';
  static const String invalidCredentialsMessage = 'Invalid email or password.';
  static const String requiredFieldMessage = 'This field is required.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String logoutSuccessMessage = 'Logout successful!';
  static const String saveSuccessMessage = 'Saved successfully!';
  static const String deleteSuccessMessage = 'Deleted successfully!';
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'HH:mm';
  
  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
  
  //Remote My Sql Configuration
  static const String dbHost = '102.218.215.35';
  static const String dbPort = '3306';
  static const String dbUsername = 'citlogis_bryan';
  static const String dbPassword = '@bo9511221.qwerty';
  static const String dbDatabase = 'citlogis_foundation';
  static const String dbSync = 'false';
  static const String dbLogging = 'false';

  // Cloudinary Configuration
  static const String cloudinaryCloudName = 'otienobryan';
  static const String cloudinaryApiKey = '825231187287193';
  static const String cloudinaryApiSecret = 'BSFpWhpwt3RrNaxnZjWv7WFNwvY';
  static const String cloudinaryUploadPreset = 'ml_default';
  static const String cloudinaryBaseUrl = 'https://api.cloudinary.com/v1_1/otienobryan';
  
  // Location
  static const double defaultLatitude = -1.2921;
  static const double defaultLongitude = 36.8219;
  static const String defaultLocation = 'Nairobi, Kenya';
  
  // Ambulance
  static const int ambulanceResponseTime = 15; // minutes
  static const double locationRadius = 0.01; // degrees
  
  // Bursary
  static const double minBursaryAmount = 100.0;
  static const double maxBursaryAmount = 100000.0;
  
  // Activity
  static const int maxActivityDuration = 24; // hours
  static const double maxBudgetAmount = 1000000.0;
}
