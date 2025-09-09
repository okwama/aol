import '../models/bursary_application.dart';
import '../repositories/bursary_application_repository.dart';
import 'remote_bursary_service.dart';
import 'sync_service.dart';
import '../models/app_notification.dart';
import '../di/service_locator.dart';

class BursaryApplicationService {
  final BursaryApplicationRepository _bursaryApplicationRepository;
  final RemoteBursaryService _remoteBursaryService;
  final SyncService _syncService;

  BursaryApplicationService(this._bursaryApplicationRepository)
      : _remoteBursaryService = RemoteBursaryService(),
        _syncService = SyncService();

  Future<List<BursaryApplication>> getAllApplications() async {
    try {
      // Try server first
      final serverApplications = await _remoteBursaryService.getAllApplications();
      // Sync any pending local changes
      await _syncService.syncBursaryApplications();
      return serverApplications;
    } catch (e) {
      print('Server unavailable, falling back to local database: $e');
      try {
        return await _bursaryApplicationRepository.getAll();
      } catch (localError) {
        print('Error fetching bursary applications from local database: $localError');
        return [];
      }
    }
  }

  Future<BursaryApplication?> getApplicationById(int id) async {
    try {
      // Try server first
      return await _remoteBursaryService.getApplicationById(id);
    } catch (e) {
      print('Server unavailable, falling back to local database: $e');
      try {
        return await _bursaryApplicationRepository.getById(id);
      } catch (localError) {
        print('Error fetching bursary application from local database: $localError');
        return null;
      }
    }
  }

  Future<BursaryApplication?> createApplication(BursaryApplication application) async {
    try {
      // Try server first
      final result = await _remoteBursaryService.createApplication(application);
      // If successful, sync any pending local changes
      await _syncService.syncBursaryApplications();
      
      // Add notification for successful submission
      await ServiceLocator().notificationService.addNotification(
        title: 'Bursary Application Submitted',
        message: 'Your application for ${application.childName} has been submitted successfully.',
        type: NotificationType.bursary,
        actionData: 'bursary_${result?.id}',
      );
      
      return result;
    } catch (e) {
      print('Server unavailable, saving to local database for later sync: $e');
      try {
        final result = await _bursaryApplicationRepository.create(application);
        // Mark for sync when online
        await _markForSync(result);
        
        // Add notification for offline submission
        await ServiceLocator().notificationService.addNotification(
          title: 'Bursary Application Saved',
          message: 'Your application for ${application.childName} has been saved offline and will be submitted when online.',
          type: NotificationType.bursary,
          actionData: 'bursary_${result.id}',
        );
        
        return result;
      } catch (localError) {
        print('Error creating bursary application in local database: $localError');
        return null;
      }
    }
  }

  Future<bool> updateApplication(BursaryApplication application) async {
    try {
      // Try server first
      return await _remoteBursaryService.updateApplication(application);
    } catch (e) {
      print('Server unavailable, falling back to local database: $e');
      try {
        await _bursaryApplicationRepository.update(application);
        return true;
      } catch (localError) {
        print('Error updating bursary application in local database: $localError');
        return false;
      }
    }
  }

  Future<bool> deleteApplication(int id) async {
    try {
      // Try server first
      return await _remoteBursaryService.deleteApplication(id);
    } catch (e) {
      print('Server unavailable, falling back to local database: $e');
      try {
        return await _bursaryApplicationRepository.delete(id);
      } catch (localError) {
        print('Error deleting bursary application from local database: $localError');
        return false;
      }
    }
  }

  Future<List<BursaryApplication>> getApplicationsByUserId(int userId) async {
    try {
      // Try server first
      return await _remoteBursaryService.getApplicationsByUserId(userId);
    } catch (e) {
      print('Server unavailable, falling back to local database: $e');
      try {
        return await _bursaryApplicationRepository.getByUserId(userId);
      } catch (localError) {
        print('Error fetching user bursary applications from local database: $localError');
        return [];
      }
    }
  }

  Future<List<BursaryApplication>> getApplicationsByStatus(String status) async {
    try {
      // Try server first
      return await _remoteBursaryService.getApplicationsByStatus(status);
    } catch (e) {
      print('Server unavailable, falling back to local database: $e');
      try {
        return await _bursaryApplicationRepository.getByStatus(status);
      } catch (localError) {
        print('Error fetching bursary applications by status from local database: $localError');
        return [];
      }
    }
  }

  Future<List<BursaryApplication>> getPendingApplications() async {
    return await getApplicationsByStatus('pending');
  }

  Future<List<BursaryApplication>> getApprovedApplications() async {
    return await getApplicationsByStatus('approved');
  }

  Future<List<BursaryApplication>> getRejectedApplications() async {
    return await getApplicationsByStatus('rejected');
  }

  /// Mark application for sync when device comes online
  Future<void> _markForSync(BursaryApplication? application) async {
    if (application != null) {
      // The sync tracking is handled by the database schema
      // Applications with syncedToServer = 0 will be synced automatically
      print('Application ${application.id} marked for sync when online');
    }
  }

  /// Manual sync trigger
  Future<void> syncWithServer() async {
    await _syncService.fullSync();
  }

  /// Check sync status
  Future<bool> hasPendingSync() async {
    return await _syncService.isOnline();
  }
}
