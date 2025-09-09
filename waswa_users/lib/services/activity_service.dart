import '../models/activity.dart';
import '../repositories/activity_repository.dart';
import 'remote_activity_service.dart';

class ActivityService {
  final ActivityRepository _activityRepository;
  final RemoteActivityService _remoteActivityService;

  ActivityService(
    this._activityRepository,
    this._remoteActivityService,
  );

  Future<List<Activity>> getAllActivities() async {
    try {
      // Try server first for real-time data
      final serverActivities = await _remoteActivityService.getAllActivities();
      
      // Update local database with server data for offline access
      for (final activity in serverActivities) {
        await _activityRepository.insertOrReplace(activity);
      }
      
      return serverActivities;
    } catch (e) {
      print('Server unavailable, using local data: $e');
      // Fallback to local data
      return await _activityRepository.getAll();
    }
  }

  Future<Activity?> getActivityById(int id) async {
    try {
      return await _activityRepository.getById(id);
    } catch (e) {
      print('Error fetching activity: $e');
      return null;
    }
  }

  Future<Activity?> createActivity(Activity activity) async {
    try {
      return await _activityRepository.create(activity);
    } catch (e) {
      print('Error creating activity: $e');
      return null;
    }
  }

  Future<bool> updateActivity(Activity activity) async {
    try {
      await _activityRepository.update(activity);
      return true;
    } catch (e) {
      print('Error updating activity: $e');
      return false;
    }
  }

  Future<bool> deleteActivity(int id) async {
    try {
      return await _activityRepository.delete(id);
    } catch (e) {
      print('Error deleting activity: $e');
      return false;
    }
  }

  Future<List<Activity>> getActivitiesByUser(int userId) async {
    try {
      return await _activityRepository.getByUserId(userId);
    } catch (e) {
      print('Error fetching user activities: $e');
      return [];
    }
  }

  Future<List<Activity>> getActivitiesByStatus(int status) async {
    try {
      return await _activityRepository.getByStatus(status);
    } catch (e) {
      print('Error fetching activities by status: $e');
      return [];
    }
  }

  Future<List<Activity>> getActivitiesByType(String activityType) async {
    try {
      return await _activityRepository.getByActivityType(activityType);
    } catch (e) {
      print('Error fetching activities by type: $e');
      return [];
    }
  }

  Future<List<Activity>> getUpcomingActivities() async {
    try {
      // Try server first for real-time data
      return await _remoteActivityService.getUpcomingActivities();
    } catch (e) {
      print('Server unavailable, using local data: $e');
      // Fallback to local data
      return await _activityRepository.getUpcomingActivities();
    }
  }

  Future<List<Activity>> getActivitiesByMonth(int year, int month) async {
    try {
      // Try server first for real-time data
      return await _remoteActivityService.getActivitiesByMonth(year, month);
    } catch (e) {
      print('Server unavailable, using local data: $e');
      // Fallback to local data
      final allActivities = await _activityRepository.getAll();
      return allActivities.where((activity) {
        final startDate = DateTime.tryParse(activity.startDate);
        if (startDate == null) return false;
        return startDate.year == year && startDate.month == month;
      }).toList();
    }
  }

  Future<List<Activity>> getActivitiesByDateRange(String startDate, String endDate) async {
    try {
      // Try server first for real-time data
      return await _remoteActivityService.getActivitiesByDateRange(startDate, endDate);
    } catch (e) {
      print('Server unavailable, using local data: $e');
      // Fallback to local data
      return await _activityRepository.getByDateRange(startDate, endDate);
    }
  }

  Future<List<Activity>> getCompletedActivities() async {
    try {
      return await _activityRepository.getCompletedActivities();
    } catch (e) {
      print('Error fetching completed activities: $e');
      return [];
    }
  }

  Future<double> getTotalBudgetByUser(int userId) async {
    try {
      return await _activityRepository.getTotalBudgetByUser(userId);
    } catch (e) {
      print('Error calculating total budget: $e');
      return 0.0;
    }
  }

  Future<List<Activity>> searchActivities(String query) async {
    try {
      final allActivities = await _activityRepository.getAll();
      return allActivities.where((activity) =>
        activity.title.toLowerCase().contains(query.toLowerCase()) ||
        activity.description.toLowerCase().contains(query.toLowerCase()) ||
        activity.location.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      print('Error searching activities: $e');
      return [];
    }
  }
}
