import '../models/ambulance_request.dart';
import '../repositories/ambulance_repository.dart';
import 'remote_ambulance_service.dart';
import 'sync_service.dart';
import 'database_service.dart';
import '../models/app_notification.dart';
import '../di/service_locator.dart';

class AmbulanceService {
  final AmbulanceRepository _ambulanceRepository;
  final RemoteAmbulanceService _remoteAmbulanceService;
  final SyncService _syncService;
  final DatabaseService _databaseService;

  AmbulanceService(
    this._ambulanceRepository,
    this._remoteAmbulanceService,
    this._syncService,
    this._databaseService,
  );

  Future<List<AmbulanceRequest>> getAllRequests() async {
    try {
      // Try server first
      final serverRequests = await _remoteAmbulanceService.getAllRequests();
      
      // Update local database with server data
      for (final request in serverRequests) {
        await _ambulanceRepository.create(request);
      }
      
      return serverRequests;
    } catch (e) {
      print('Server unavailable, using local data: $e');
      // Fallback to local data
      return await _ambulanceRepository.getAll();
    }
  }

  Future<AmbulanceRequest?> getRequestById(int id) async {
    try {
      return await _ambulanceRepository.getById(id);
    } catch (e) {
      print('Error fetching ambulance request: $e');
      return null;
    }
  }

  Future<AmbulanceRequest?> createRequest(AmbulanceRequest request) async {
    try {
      // Try server first
      final serverRequest = await _remoteAmbulanceService.createRequest(request);
      
      // Save to local database with server ID
      final localRequest = AmbulanceRequest(
        id: serverRequest.id,
        userId: serverRequest.userId,
        ambulanceId: serverRequest.ambulanceId,
        purpose: serverRequest.purpose,
        destination: serverRequest.destination,
        startDate: serverRequest.startDate,
        endDate: serverRequest.endDate,
        notes: serverRequest.notes,
        latitude: serverRequest.latitude,
        longitude: serverRequest.longitude,
        address: serverRequest.address,
        status: serverRequest.status,
        assignedBy: serverRequest.assignedBy,
        assignedAt: serverRequest.assignedAt,
        completedAt: serverRequest.completedAt,
        createdAt: serverRequest.createdAt,
        updatedAt: serverRequest.updatedAt,
      );
      
      await _ambulanceRepository.create(localRequest);
      
      // Add notification for successful submission
      await ServiceLocator().notificationService.addNotification(
        title: 'Ambulance Request Submitted',
        message: 'Your ambulance request has been submitted successfully. We will contact you soon.',
        type: NotificationType.ambulance,
        actionData: 'ambulance_${serverRequest.id}',
      );
      
      return serverRequest;
    } catch (e) {
      print('Server unavailable, saving locally: $e');
      // Fallback to local storage
      final localRequest = await _ambulanceRepository.create(request);
      if (localRequest != null) {
        // Mark for sync when online
        await _markForSync(localRequest.id!);
        
        // Add notification for offline submission
        await ServiceLocator().notificationService.addNotification(
          title: 'Ambulance Request Saved',
          message: 'Your ambulance request has been saved offline and will be submitted when online.',
          type: NotificationType.ambulance,
          actionData: 'ambulance_${localRequest.id}',
        );
      }
      return localRequest;
    }
  }

  Future<bool> updateRequest(AmbulanceRequest request) async {
    try {
      await _ambulanceRepository.update(request);
      return true;
    } catch (e) {
      print('Error updating ambulance request: $e');
      return false;
    }
  }

  Future<bool> deleteRequest(int id) async {
    try {
      return await _ambulanceRepository.delete(id);
    } catch (e) {
      print('Error deleting ambulance request: $e');
      return false;
    }
  }

  Future<List<AmbulanceRequest>> getRequestsByUser(int userId) async {
    try {
      return await _ambulanceRepository.getByUserId(userId);
    } catch (e) {
      print('Error fetching user requests: $e');
      return [];
    }
  }

  Future<List<AmbulanceRequest>> getRequestsByStatus(AmbulanceRequestStatus status) async {
    try {
      return await _ambulanceRepository.getByStatus(status);
    } catch (e) {
      print('Error fetching requests by status: $e');
      return [];
    }
  }

  Future<List<AmbulanceRequest>> getPendingRequests() async {
    try {
      return await _ambulanceRepository.getPendingRequests();
    } catch (e) {
      print('Error fetching pending requests: $e');
      return [];
    }
  }

  Future<List<AmbulanceRequest>> getAssignedRequests() async {
    try {
      return await _ambulanceRepository.getAssignedRequests();
    } catch (e) {
      print('Error fetching assigned requests: $e');
      return [];
    }
  }

  Future<bool> assignAmbulance(int requestId, int ambulanceId, int assignedBy) async {
    try {
      return await _ambulanceRepository.assignAmbulance(requestId, ambulanceId, assignedBy);
    } catch (e) {
      print('Error assigning ambulance: $e');
      return false;
    }
  }

  Future<bool> updateRequestStatus(int requestId, AmbulanceRequestStatus status) async {
    try {
      return await _ambulanceRepository.updateStatus(requestId, status);
    } catch (e) {
      print('Error updating request status: $e');
      return false;
    }
  }

  Future<bool> completeRequest(int requestId) async {
    try {
      return await _ambulanceRepository.completeRequest(requestId, DateTime.now());
    } catch (e) {
      print('Error completing request: $e');
      return false;
    }
  }

  Future<List<AmbulanceRequest>> getRequestsByLocation(double latitude, double longitude, double radius) async {
    try {
      return await _ambulanceRepository.getByLocation(latitude, longitude, radius);
    } catch (e) {
      print('Error fetching requests by location: $e');
      return [];
    }
  }

  Future<List<AmbulanceRequest>> getEmergencyRequests() async {
    try {
      final allRequests = await _ambulanceRepository.getAll();
      return allRequests.where((request) =>
        request.status == AmbulanceRequestStatus.pending ||
        request.status == AmbulanceRequestStatus.assigned
      ).toList();
    } catch (e) {
      print('Error fetching emergency requests: $e');
      return [];
    }
  }

  // Helper methods for sync tracking
  Future<void> _markForSync(int localId) async {
    try {
      final db = await _databaseService.database;
      await db.update(
        'AmbulanceRequest',
        {'syncedToServer': 0},
        where: 'id = ?',
        whereArgs: [localId],
      );
    } catch (e) {
      print('Error marking for sync: $e');
    }
  }

  Future<void> syncWithServer() async {
    try {
      await _syncService.syncAmbulanceRequests();
    } catch (e) {
      print('Error syncing ambulance requests: $e');
    }
  }

  Future<bool> hasPendingSync() async {
    try {
      final db = await _databaseService.database;
      final result = await db.query(
        'AmbulanceRequest',
        where: 'syncedToServer = ?',
        whereArgs: [0],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking pending sync: $e');
      return false;
    }
  }
}
