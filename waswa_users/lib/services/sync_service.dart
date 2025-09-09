import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/bursary_application.dart';
import '../models/ambulance_request.dart';
import '../constants/app_constants.dart';
import '../services/database_service.dart';

class SyncService {
  static const String _baseUrl = AppConstants.baseUrl;
  final DatabaseService _databaseService = DatabaseService();

  /// Check if device is online
  Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Sync all pending bursary applications to server
  Future<void> syncBursaryApplications() async {
    try {
      if (!await isOnline()) {
        print('SyncService: Device is offline, skipping sync');
        return;
      }

      print('SyncService: Starting bursary applications sync...');
      
      final db = await _databaseService.database;
      
      // Get all applications that haven't been synced to server
      final pendingApplications = await db.query(
        'BursaryApplication',
        where: 'syncedToServer = ? OR syncedToServer IS NULL',
        whereArgs: [0],
      );

      print('SyncService: Found ${pendingApplications.length} pending applications');

      for (final appData in pendingApplications) {
        try {
          // Convert to BursaryApplication model
          final application = BursaryApplication(
            id: appData['id'] as int,
            childName: appData['childName'] as String,
            school: appData['school'] as String,
            parentIncome: (appData['parentIncome'] as num).toDouble(),
            status: appData['status'] as String,
            applicationDate: DateTime.parse(appData['applicationDate'] as String),
            createdAt: DateTime.parse(appData['createdAt'] as String),
            updatedAt: DateTime.parse(appData['updatedAt'] as String),
            notes: appData['notes'] as String?,
            userId: appData['userId'] as int?,
          );

          // Send to server
          final success = await _uploadBursaryApplication(application);
          
          if (success) {
            // Mark as synced in local database
            await db.update(
              'BursaryApplication',
              {'syncedToServer': 1, 'serverId': application.id},
              where: 'id = ?',
              whereArgs: [appData['id']],
            );
            print('SyncService: Successfully synced application ${appData['id']}');
          } else {
            print('SyncService: Failed to sync application ${appData['id']}');
          }
        } catch (e) {
          print('SyncService: Error syncing application ${appData['id']}: $e');
        }
      }

      print('SyncService: Bursary applications sync completed');
    } catch (e) {
      print('SyncService: Error during sync: $e');
    }
  }

  /// Upload a single bursary application to server
  Future<bool> _uploadBursaryApplication(BursaryApplication application) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/bursary'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(application.toJson()),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('SyncService: Server response: $responseData');
        return true;
      } else {
        print('SyncService: Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('SyncService: Upload error: $e');
      return false;
    }
  }

  /// Download latest applications from server and update local database
  Future<void> downloadBursaryApplications() async {
    try {
      if (!await isOnline()) {
        print('SyncService: Device is offline, skipping download');
        return;
      }

      print('SyncService: Downloading applications from server...');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/bursary'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> serverApplications = json.decode(response.body);
        final db = await _databaseService.database;

        for (final appData in serverApplications) {
          try {
            // Check if application already exists locally
            final existingApps = await db.query(
              'BursaryApplication',
              where: 'serverId = ?',
              whereArgs: [appData['id']],
            );

            if (existingApps.isEmpty) {
              // Insert new application from server
              await db.insert('BursaryApplication', {
                'childName': appData['childName'],
                'school': appData['school'],
                'parentIncome': appData['parentIncome'],
                'status': appData['status'],
                'applicationDate': appData['applicationDate'],
                'notes': appData['notes'],
                'userId': appData['userId'],
                'serverId': appData['id'],
                'syncedToServer': 1,
                'createdAt': appData['createdAt'] ?? DateTime.now().toIso8601String(),
                'updatedAt': appData['updatedAt'] ?? DateTime.now().toIso8601String(),
              });
              print('SyncService: Downloaded new application: ${appData['id']}');
            } else {
              // Update existing application if server version is newer
              final localApp = existingApps.first;
              final localUpdatedAt = DateTime.parse(localApp['updatedAt'] as String);
              final serverUpdatedAt = DateTime.parse(appData['updatedAt']);

              if (serverUpdatedAt.isAfter(localUpdatedAt)) {
                await db.update(
                  'BursaryApplication',
                  {
                    'childName': appData['childName'],
                    'school': appData['school'],
                    'parentIncome': appData['parentIncome'],
                    'status': appData['status'],
                    'applicationDate': appData['applicationDate'],
                    'notes': appData['notes'],
                    'userId': appData['userId'],
                    'updatedAt': appData['updatedAt'],
                  },
                  where: 'serverId = ?',
                  whereArgs: [appData['id']],
                );
                print('SyncService: Updated application: ${appData['id']}');
              }
            }
          } catch (e) {
            print('SyncService: Error processing application ${appData['id']}: $e');
          }
        }

        print('SyncService: Download completed');
      } else {
        print('SyncService: Download error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('SyncService: Download error: $e');
    }
  }

  /// Full sync: upload pending changes and download latest from server
  Future<void> fullSync() async {
    print('SyncService: Starting full sync...');
    
    // First upload any pending changes
    await syncBursaryApplications();
    await syncAmbulanceRequests();
    
    // Then download latest from server
    await downloadBursaryApplications();
    
    print('SyncService: Full sync completed');
  }

  /// Sync ambulance requests
  Future<void> syncAmbulanceRequests() async {
    try {
      print('SyncService: Starting ambulance requests sync...');
      
      final db = await _databaseService.database;
      
      // Get pending ambulance requests
      final pendingRequests = await db.query(
        'AmbulanceRequest',
        where: 'syncedToServer = ?',
        whereArgs: [0],
      );

      print('SyncService: Found ${pendingRequests.length} pending ambulance requests');

      for (final requestData in pendingRequests) {
        try {
          // Convert to AmbulanceRequest model
          final request = AmbulanceRequest(
            id: requestData['id'] as int,
            userId: requestData['userId'] as int,
            ambulanceId: requestData['ambulanceId'] as int?,
            purpose: requestData['purpose'] as String,
            destination: requestData['destination'] as String,
            startDate: DateTime.parse(requestData['startDate'] as String),
            endDate: DateTime.parse(requestData['endDate'] as String),
            notes: requestData['notes'] as String?,
            latitude: requestData['latitude'] as double?,
            longitude: requestData['longitude'] as double?,
            address: requestData['address'] as String?,
            status: AmbulanceRequestStatus.values.firstWhere(
              (e) => e.toString().split('.').last == requestData['status'],
              orElse: () => AmbulanceRequestStatus.pending,
            ),
            assignedBy: requestData['assignedBy'] as int?,
            assignedAt: requestData['assignedAt'] != null 
                ? DateTime.parse(requestData['assignedAt'] as String) 
                : null,
            completedAt: requestData['completedAt'] != null 
                ? DateTime.parse(requestData['completedAt'] as String) 
                : null,
            createdAt: DateTime.parse(requestData['createdAt'] as String),
            updatedAt: DateTime.parse(requestData['updatedAt'] as String),
          );

          // Send to server
          final success = await _uploadAmbulanceRequest(request);
          
          if (success) {
            // Mark as synced
            await db.update(
              'AmbulanceRequest',
              {
                'syncedToServer': 1,
                'serverId': request.id,
              },
              where: 'id = ?',
              whereArgs: [requestData['id']],
            );
            print('SyncService: Ambulance request ${requestData['id']} synced successfully');
          } else {
            print('SyncService: Failed to sync ambulance request ${requestData['id']}');
          }
        } catch (e) {
          print('SyncService: Error syncing ambulance request ${requestData['id']}: $e');
        }
      }
    } catch (e) {
      print('SyncService: Error in ambulance requests sync: $e');
    }
  }

  /// Upload ambulance request to server
  Future<bool> _uploadAmbulanceRequest(AmbulanceRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/ambulance'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final serverData = json.decode(response.body);
        // Update local record with server ID
        final db = await _databaseService.database;
        await db.update(
          'AmbulanceRequest',
          {'serverId': serverData['id']},
          where: 'id = ?',
          whereArgs: [request.id],
        );
        return true;
      }
      return false;
    } catch (e) {
      print('SyncService: Error uploading ambulance request: $e');
      return false;
    }
  }

  /// Auto-sync when connectivity changes
  Future<void> handleConnectivityChange(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      print('SyncService: Device came online, starting sync...');
      await Future.delayed(const Duration(seconds: 2)); // Wait for stable connection
      await fullSync();
    }
  }
}
