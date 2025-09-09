import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../services/bursary_service.dart';
import '../services/bursary_application_service.dart';
import '../services/activity_service.dart';
import '../services/ambulance_service.dart';
import '../services/remote_ambulance_service.dart';
import '../services/remote_activity_service.dart';
import '../services/remote_auth_service.dart';
import '../services/notice_service.dart';
import '../services/notification_service.dart';
import '../services/sync_service.dart';
import '../repositories/user_repository.dart';
import '../repositories/bursary_repository.dart';
import '../repositories/bursary_application_repository.dart';
import '../repositories/activity_repository.dart';
import '../repositories/ambulance_repository.dart';
import '../repositories/notice_repository.dart';
import '../repositories/impl/user_repository_impl.dart';
import '../repositories/impl/bursary_repository_impl.dart';
import '../repositories/impl/bursary_application_repository_impl.dart';
import '../repositories/impl/activity_repository_impl.dart';
import '../repositories/impl/ambulance_repository_impl.dart';
import '../repositories/impl/notice_repository_impl.dart';
import 'package:flutter/foundation.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  DatabaseService? _databaseService;
  UserRepository? _userRepository;
  BursaryRepository? _bursaryRepository;
  BursaryApplicationRepository? _bursaryApplicationRepository;
  ActivityRepository? _activityRepository;
  AmbulanceRepository? _ambulanceRepository;
  NoticeRepository? _noticeRepository;
  AuthService? _authService;
  BursaryService? _bursaryService;
  BursaryApplicationService? _bursaryApplicationService;
  ActivityService? _activityService;
  AmbulanceService? _ambulanceService;
  NoticeService? _noticeService;
  NotificationService? _notificationService;
  SyncService? _syncService;
  
  bool _isInitialized = false;

  Future<void> initialize() async {
    try {
      print('ServiceLocator: Starting initialization...');
      
      if (kIsWeb) {
        print('ServiceLocator: Web platform detected - skipping database initialization');
        // For web platform, we'll initialize services without database
        await _initializeWebServices();
        print('ServiceLocator: Web services initialized successfully');
        return;
      }
      
      // Initialize database service for mobile/desktop platforms
      _databaseService = DatabaseService();
      print('ServiceLocator: Database service created');
      
      // Ensure database is initialized by calling the database getter
      await _databaseService!.database;
      print('ServiceLocator: Database initialized successfully');
      
      // Skip database recreation in production to avoid potential issues
      // The database initialization above will handle table creation automatically
      print('ServiceLocator: Database tables will be created automatically during initialization');

      // Initialize repositories
      _userRepository = UserRepositoryImpl(_databaseService!);
      _bursaryRepository = BursaryRepositoryImpl(_databaseService!);
      _bursaryApplicationRepository = BursaryApplicationRepositoryImpl(_databaseService!);
      _activityRepository = ActivityRepositoryImpl(_databaseService!);
      _ambulanceRepository = AmbulanceRepositoryImpl(_databaseService!);
      _noticeRepository = NoticeRepositoryImpl(_databaseService!);
      print('ServiceLocator: All repositories initialized');

      // Initialize services with error handling
      _syncService = SyncService();
      _authService = AuthService(_userRepository!, RemoteAuthService(), _syncService!);
      _bursaryService = BursaryService(_bursaryRepository!);
      _bursaryApplicationService = BursaryApplicationService(_bursaryApplicationRepository!);
      _activityService = ActivityService(
        _activityRepository!,
        RemoteActivityService(),
      );
      _ambulanceService = AmbulanceService(
        _ambulanceRepository!,
        RemoteAmbulanceService(),
        _syncService!,
        _databaseService!,
      );
      _noticeService = NoticeService(_noticeRepository!);
      _notificationService = NotificationService(_databaseService!);
      
      // Initialize notification service with timeout
      try {
        await _notificationService!.initialize().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            print('ServiceLocator: Notification service initialization timed out');
          },
        );
        print('ServiceLocator: Notification service initialized');
      } catch (e) {
        print('ServiceLocator: Notification service initialization failed: $e');
        // Continue without notification service
      }
      
      print('ServiceLocator: All services initialized');
      _isInitialized = true;
      print('ServiceLocator: Initialization completed successfully');
    } catch (e) {
      print('ServiceLocator: Initialization failed: $e');
      // Don't rethrow - let the app continue with partial initialization
      print('ServiceLocator: Continuing with partial initialization');
      _isInitialized = true; // Mark as initialized even with errors
    }
  }

  Future<void> _initializeWebServices() async {
    // For web platform, create mock database service and initialize services
    _databaseService = DatabaseService();
    
    // Initialize repositories with mock database
    _userRepository = UserRepositoryImpl(_databaseService!);
    _bursaryRepository = BursaryRepositoryImpl(_databaseService!);
    _bursaryApplicationRepository = BursaryApplicationRepositoryImpl(_databaseService!);
    _activityRepository = ActivityRepositoryImpl(_databaseService!);
    _ambulanceRepository = AmbulanceRepositoryImpl(_databaseService!);
    _noticeRepository = NoticeRepositoryImpl(_databaseService!);
    
    // Initialize services
    _syncService = SyncService();
    _authService = AuthService(_userRepository!, RemoteAuthService(), _syncService!);
    _bursaryService = BursaryService(_bursaryRepository!);
    _bursaryApplicationService = BursaryApplicationService(_bursaryApplicationRepository!);
    _activityService = ActivityService(
      _activityRepository!,
      RemoteActivityService(),
    );
    _ambulanceService = AmbulanceService(
      _ambulanceRepository!,
      RemoteAmbulanceService(),
      _syncService!,
      _databaseService!,
    );
    _noticeService = NoticeService(_noticeRepository!);
    _notificationService = NotificationService(_databaseService!);
    
    // Initialize notification service (handles web platform internally)
    await _notificationService!.initialize();
  }

  // Database service
  DatabaseService get databaseService {
    if (!_isInitialized || _databaseService == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _databaseService!;
  }

  // Repositories
  UserRepository get userRepository {
    if (!_isInitialized || _userRepository == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _userRepository!;
  }
  
  BursaryRepository get bursaryRepository {
    if (!_isInitialized || _bursaryRepository == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _bursaryRepository!;
  }
  
  BursaryApplicationRepository get bursaryApplicationRepository {
    if (!_isInitialized || _bursaryApplicationRepository == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _bursaryApplicationRepository!;
  }
  
  ActivityRepository get activityRepository {
    if (!_isInitialized || _activityRepository == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _activityRepository!;
  }
  
  AmbulanceRepository get ambulanceRepository {
    if (!_isInitialized || _ambulanceRepository == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _ambulanceRepository!;
  }
  
  NoticeRepository get noticeRepository {
    if (!_isInitialized || _noticeRepository == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _noticeRepository!;
  }

  // Services
  AuthService get authService {
    if (!_isInitialized || _authService == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _authService!;
  }
  
  BursaryService get bursaryService {
    if (!_isInitialized || _bursaryService == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _bursaryService!;
  }
  
  BursaryApplicationService get bursaryApplicationService {
    if (!_isInitialized || _bursaryApplicationService == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _bursaryApplicationService!;
  }
  
  ActivityService get activityService {
    if (!_isInitialized || _activityService == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _activityService!;
  }
  
  AmbulanceService get ambulanceService {
    if (!_isInitialized || _ambulanceService == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _ambulanceService!;
  }
  
  NoticeService get noticeService {
    if (!_isInitialized || _noticeService == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _noticeService!;
  }
  
  NotificationService get notificationService {
    if (!_isInitialized || _notificationService == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _notificationService!;
  }
  
  SyncService get syncService {
    if (!_isInitialized || _syncService == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _syncService!;
  }

  // Safe access methods with error handling
  AuthService? get authServiceSafe {
    try {
      return authService;
    } catch (e) {
      print('ServiceLocator: Failed to access authService: $e');
      return null;
    }
  }
  
  NotificationService? get notificationServiceSafe {
    try {
      return notificationService;
    } catch (e) {
      print('ServiceLocator: Failed to access notificationService: $e');
      return null;
    }
  }
  
  ActivityService? get activityServiceSafe {
    try {
      return activityService;
    } catch (e) {
      print('ServiceLocator: Failed to access activityService: $e');
      return null;
    }
  }
  
  BursaryApplicationService? get bursaryApplicationServiceSafe {
    try {
      return bursaryApplicationService;
    } catch (e) {
      print('ServiceLocator: Failed to access bursaryApplicationService: $e');
      return null;
    }
  }
  
  AmbulanceService? get ambulanceServiceSafe {
    try {
      return ambulanceService;
    } catch (e) {
      print('ServiceLocator: Failed to access ambulanceService: $e');
      return null;
    }
  }
  
  NoticeService? get noticeServiceSafe {
    try {
      return noticeService;
    } catch (e) {
      print('ServiceLocator: Failed to access noticeService: $e');
      return null;
    }
  }
  
  SyncService? get syncServiceSafe {
    try {
      return syncService;
    } catch (e) {
      print('ServiceLocator: Failed to access syncService: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    if (_databaseService != null) {
      await _databaseService!.close();
    }
  }
}
