import 'package:sqflite/sqflite.dart';
import '../../models/activity.dart';
import '../activity_repository.dart';
import '../../services/database_service.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final DatabaseService _databaseService;

  ActivityRepositoryImpl(this._databaseService);

  @override
  Future<List<Activity>> getAll() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('activity');
    return List.generate(maps.length, (i) => Activity.fromJson(maps[i]));
  }

  @override
  Future<Activity?> getById(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'activity',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Activity.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<Activity> create(Activity item) async {
    final db = await _databaseService.database;
    final id = await db.insert('activity', item.toJson());
    return item.copyWith(id: id);
  }

  @override
  Future<Activity> insertOrReplace(Activity item) async {
    final db = await _databaseService.database;
    await db.insert('activity', item.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  @override
  Future<Activity> update(Activity item) async {
    final db = await _databaseService.database;
    await db.update(
      'activity',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    return item;
  }

  @override
  Future<bool> delete(int id) async {
    final db = await _databaseService.database;
    final count = await db.delete(
      'activity',
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  @override
  Future<List<Activity>> getByUserId(int userId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'activity',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'start_date DESC',
    );
    return List.generate(maps.length, (i) => Activity.fromJson(maps[i]));
  }

  @override
  Future<List<Activity>> getByStatus(int status) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'activity',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'start_date DESC',
    );
    return List.generate(maps.length, (i) => Activity.fromJson(maps[i]));
  }

  @override
  Future<List<Activity>> getByActivityType(String activityType) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'activity',
      where: 'activity_type = ?',
      whereArgs: [activityType],
      orderBy: 'start_date DESC',
    );
    return List.generate(maps.length, (i) => Activity.fromJson(maps[i]));
  }

  @override
  Future<List<Activity>> getByDateRange(String startDate, String endDate) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'activity',
      where: 'start_date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: 'start_date ASC',
    );
    return List.generate(maps.length, (i) => Activity.fromJson(maps[i]));
  }

  @override
  Future<List<Activity>> getByLocation(String location) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'activity',
      where: 'location LIKE ?',
      whereArgs: ['%$location%'],
      orderBy: 'start_date DESC',
    );
    return List.generate(maps.length, (i) => Activity.fromJson(maps[i]));
  }

  @override
  Future<List<Activity>> getUpcomingActivities() async {
    final db = await _databaseService.database;
    final now = DateTime.now().toIso8601String();
    final List<Map<String, dynamic>> maps = await db.query(
      'activity',
      where: 'start_date > ?',
      whereArgs: [now],
      orderBy: 'start_date ASC',
    );
    return List.generate(maps.length, (i) => Activity.fromJson(maps[i]));
  }

  @override
  Future<List<Activity>> getCompletedActivities() async {
    final db = await _databaseService.database;
    final now = DateTime.now().toIso8601String();
    final List<Map<String, dynamic>> maps = await db.query(
      'activity',
      where: 'end_date < ?',
      whereArgs: [now],
      orderBy: 'end_date DESC',
    );
    return List.generate(maps.length, (i) => Activity.fromJson(maps[i]));
  }

  @override
  Future<double> getTotalBudgetByUser(int userId) async {
    final db = await _databaseService.database;
    final result = await db.rawQuery(
      'SELECT SUM(budget_total) as total FROM activity WHERE user_id = ?',
      [userId],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}
