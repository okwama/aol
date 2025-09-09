import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'citlogis_foundation';
  static const int _databaseVersion = 6;

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('Database not supported on web platform');
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      if (kIsWeb) {
        // For web platform, we'll use a mock database or skip database initialization
        print('Web platform detected - using mock database');
        throw UnsupportedError('Database not supported on web platform');
      }
      
      String path;
      
      if (Platform.isAndroid || Platform.isIOS) {
        // Mobile platforms
        path = join(await getDatabasesPath(), '$_databaseName.db');
      } else {
        // Desktop platforms
        path = join(await getDatabasesPath(), _databaseName);
      }
      
      print('Database path: $path');
      print('Platform: ${Platform.operatingSystem}');
      
      final db = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
      
      // Check for missing tables and create them if needed
      await _createMissingTables(db);
      
      return db;
    } catch (e) {
      print('Database initialization error: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create User table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phoneNumber TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'USER',
        created_at TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        photoUrl TEXT,
        status INTEGER NOT NULL DEFAULT 0,
        nationalId TEXT,
        city TEXT,
        state TEXT,
        country TEXT
      )
    ''');

    // Create BursaryPayment table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS BursaryPayment (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId INTEGER NOT NULL,
        schoolId INTEGER NOT NULL,
        amount REAL NOT NULL,
        datePaid TEXT NOT NULL,
        referenceNumber TEXT,
        paidBy TEXT,
        notes TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Create BursaryApplication table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS BursaryApplication (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        childName TEXT NOT NULL,
        school TEXT NOT NULL,
        parentIncome REAL NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        applicationDate TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        notes TEXT,
        userId INTEGER,
        serverId INTEGER,
        syncedToServer INTEGER DEFAULT 0
      )
    ''');

    // Create activity table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS activity (
        id INTEGER PRIMARY KEY,
        myActivityId INTEGER,
        name TEXT,
        status INTEGER,
        title TEXT,
        description TEXT,
        location TEXT,
        startDate TEXT,
        endDate TEXT,
        imageUrl TEXT,
        userId INTEGER,
        clientId INTEGER,
        activityType TEXT,
        budgetTotal REAL
      )
    ''');

    // Create AmbulanceRequest table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS AmbulanceRequest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        ambulanceId INTEGER,
        purpose TEXT NOT NULL,
        destination TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        notes TEXT,
        latitude REAL,
        longitude REAL,
        address TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        assignedBy INTEGER,
        assignedAt TEXT,
        completedAt TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        serverId INTEGER,
        syncedToServer INTEGER DEFAULT 0
      )
    ''');

    // Create NoticeBoard table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS NoticeBoard (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Create notifications table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notifications (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        type TEXT NOT NULL,
        is_read INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        action_data TEXT
      )
    ''');

    // Insert sample data
    await _insertSampleData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Add notifications table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS notifications (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          message TEXT NOT NULL,
          type TEXT NOT NULL,
          is_read INTEGER DEFAULT 0,
          created_at TEXT NOT NULL,
          action_data TEXT
        )
      ''');
      print('DatabaseService: Added notifications table in upgrade');
    }
    
    if (oldVersion < 3) {
      // Recreate User table with proper auto-increment
      await db.execute('DROP TABLE IF EXISTS User');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS User (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT UNIQUE NOT NULL,
          phoneNumber TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL,
          role TEXT NOT NULL DEFAULT 'USER',
          created_at TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          photoUrl TEXT,
          status INTEGER NOT NULL DEFAULT 0,
          nationalId TEXT,
          region TEXT
        )
      ''');
      print('DatabaseService: Recreated User table with proper auto-increment');
    }
    
    if (oldVersion < 6) {
      // Update User table to match server schema (replace region with city, state, country)
      try {
        await db.execute('ALTER TABLE User ADD COLUMN city TEXT');
        await db.execute('ALTER TABLE User ADD COLUMN state TEXT');
        await db.execute('ALTER TABLE User ADD COLUMN country TEXT');
        print('DatabaseService: Added city, state, country columns to User table');
      } catch (e) {
        print('DatabaseService: Columns may already exist: $e');
      }
    }
    
    if (oldVersion < 4) {
      // Add missing columns to BursaryApplication table
      try {
        await db.execute('ALTER TABLE BursaryApplication ADD COLUMN serverId INTEGER');
        print('DatabaseService: Added serverId column to BursaryApplication');
      } catch (e) {
        print('DatabaseService: serverId column may already exist: $e');
      }
      
      try {
        await db.execute('ALTER TABLE BursaryApplication ADD COLUMN syncedToServer INTEGER DEFAULT 0');
        print('DatabaseService: Added syncedToServer column to BursaryApplication');
      } catch (e) {
        print('DatabaseService: syncedToServer column may already exist: $e');
      }
    }
    
    if (oldVersion < 5) {
      // Recreate activity table with camelCase column names to match API
      try {
        await db.execute('DROP TABLE IF EXISTS activity');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS activity (
            id INTEGER PRIMARY KEY,
            myActivityId INTEGER,
            name TEXT,
            status INTEGER,
            title TEXT,
            description TEXT,
            location TEXT,
            startDate TEXT,
            endDate TEXT,
            imageUrl TEXT,
            userId INTEGER,
            clientId INTEGER,
            activityType TEXT,
            budgetTotal REAL
          )
        ''');
        print('DatabaseService: Recreated activity table with camelCase columns');
      } catch (e) {
        print('DatabaseService: Error recreating activity table: $e');
      }
    }
  }

  Future<void> _createMissingTables(Database db) async {
    // Check if BursaryApplication table exists, if not create it
    try {
      await db.execute('SELECT 1 FROM BursaryApplication LIMIT 1');
    } catch (e) {
      // Table doesn't exist, create it
      await db.execute('''
        CREATE TABLE IF NOT EXISTS BursaryApplication (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          childName TEXT NOT NULL,
          school TEXT NOT NULL,
          parentIncome REAL NOT NULL,
          status TEXT NOT NULL DEFAULT 'pending',
          applicationDate TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          notes TEXT,
          userId INTEGER,
          serverId INTEGER,
          syncedToServer INTEGER DEFAULT 0
        )
      ''');
      print('DatabaseService: Created missing BursaryApplication table');
    }

    // Check if notifications table exists, if not create it
    try {
      await db.execute('SELECT 1 FROM notifications LIMIT 1');
    } catch (e) {
      // Table doesn't exist, create it
      await db.execute('''
        CREATE TABLE IF NOT EXISTS notifications (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          message TEXT NOT NULL,
          type TEXT NOT NULL,
          is_read INTEGER DEFAULT 0,
          created_at TEXT NOT NULL,
          action_data TEXT
        )
      ''');
      print('DatabaseService: Created missing notifications table');
    }
  }

  Future<void> _insertSampleData(Database db) async {
    // Insert sample users
    await db.insert('User', {
      'name': 'Test User',
      'email': 'test@example.com',
      'phoneNumber': '0706166875',
      'password': '\$2a\$10\$2VosdgBHLtanytp0.g7ZU.HnoxhZNnTruvfDtwh5hQ4tR8JqOxYDG',
      'role': 'USER',
      'created_at': '2025-01-01',
      'updatedAt': DateTime.now().toIso8601String(),
      'status': 0,
      'nationalId': '12345678',
      'region': 'Kitale Region',
    });

    // Insert sample notices
    await db.insert('NoticeBoard', {
      'title': 'Foundation Meeting Tomorrow',
      'content': 'All field staff are required to attend the monthly foundation meeting tomorrow at 9:00 AM.',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    await db.insert('NoticeBoard', {
      'title': 'New Distribution Routes',
      'content': 'We have updated our distribution routes for better efficiency.',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // Insert sample bursary applications
    await db.insert('BursaryApplication', {
      'childName': 'Mary Kim',
      'school': 'Region Primary School',
      'parentIncome': 25000.0,
      'status': 'pending',
      'applicationDate': DateTime.now().toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'userId': 1,
    });

    await db.insert('BursaryApplication', {
      'childName': 'Peter Ochieng',
      'school': 'Region Secondary School',
      'parentIncome': 30000.0,
      'status': 'approved',
      'applicationDate': DateTime.now().toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'userId': 1,
    });
  }

  Future<void> close() async {
    if (kIsWeb) {
      print('DatabaseService: Web platform - no database to close');
      return;
    }
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> deleteDatabase() async {
    if (kIsWeb) {
      print('DatabaseService: Web platform - no database to delete');
      return;
    }
    final String path = join(await getDatabasesPath(), _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  Future<void> recreateDatabase() async {
    if (kIsWeb) {
      print('DatabaseService: Web platform - no database to recreate');
      return;
    }
    await deleteDatabase();
    _database = await _initDatabase();
  }

  /// Force database migration by recreating with new version
  Future<void> forceMigration() async {
    if (kIsWeb) {
      print('DatabaseService: Web platform - no database migration needed');
      return;
    }
    try {
      print('DatabaseService: Forcing database migration...');
      await deleteDatabase();
      _database = null;
      _database = await _initDatabase();
      print('DatabaseService: Migration completed successfully');
    } catch (e) {
      print('DatabaseService: Migration failed: $e');
      rethrow;
    }
  }
}
