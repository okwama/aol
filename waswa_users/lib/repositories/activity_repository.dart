import '../models/activity.dart';
import 'base_repository.dart';

abstract class ActivityRepository extends BaseRepository<Activity> {
  Future<List<Activity>> getByUserId(int userId);
  Future<List<Activity>> getByStatus(int status);
  Future<List<Activity>> getByActivityType(String activityType);
  Future<List<Activity>> getByDateRange(String startDate, String endDate);
  Future<List<Activity>> getByLocation(String location);
  Future<List<Activity>> getUpcomingActivities();
  Future<List<Activity>> getCompletedActivities();
  Future<double> getTotalBudgetByUser(int userId);
}
