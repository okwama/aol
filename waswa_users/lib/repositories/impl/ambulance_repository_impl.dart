import 'package:sqflite/sqflite.dart';
import '../../models/ambulance_request.dart';
import '../ambulance_repository.dart';
import '../../services/database_service.dart';

class AmbulanceRepositoryImpl implements AmbulanceRepository {
  final DatabaseService _databaseService;

  AmbulanceRepositoryImpl(this._databaseService);

  @override
  Future<List<AmbulanceRequest>> getAll() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('AmbulanceRequest');
    return List.generate(maps.length, (i) => AmbulanceRequest.fromJson(maps[i]));
  }

  @override
  Future<AmbulanceRequest?> getById(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'AmbulanceRequest',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return AmbulanceRequest.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<AmbulanceRequest> create(AmbulanceRequest item) async {
    final db = await _databaseService.database;
    final id = await db.insert('AmbulanceRequest', item.toJson());
    return item.copyWith(id: id);
  }

  @override
  Future<AmbulanceRequest> insertOrReplace(AmbulanceRequest item) async {
    final db = await _databaseService.database;
    await db.insert('AmbulanceRequest', item.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  @override
  Future<AmbulanceRequest> update(AmbulanceRequest item) async {
    final db = await _databaseService.database;
    await db.update(
      'AmbulanceRequest',
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
      'AmbulanceRequest',
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  @override
  Future<List<AmbulanceRequest>> getByUserId(int userId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'AmbulanceRequest',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => AmbulanceRequest.fromJson(maps[i]));
  }

  @override
  Future<List<AmbulanceRequest>> getByStatus(AmbulanceRequestStatus status) async {
    final db = await _databaseService.database;
    final statusString = status.toString().split('.').last;
    final List<Map<String, dynamic>> maps = await db.query(
      'AmbulanceRequest',
      where: 'status = ?',
      whereArgs: [statusString],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => AmbulanceRequest.fromJson(maps[i]));
  }

  @override
  Future<List<AmbulanceRequest>> getByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'AmbulanceRequest',
      where: 'startDate BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'startDate ASC',
    );
    return List.generate(maps.length, (i) => AmbulanceRequest.fromJson(maps[i]));
  }

  @override
  Future<List<AmbulanceRequest>> getByLocation(double latitude, double longitude, double radius) async {
    final db = await _databaseService.database;
    // Simple distance calculation using bounding box
    final latMin = latitude - radius;
    final latMax = latitude + radius;
    final lonMin = longitude - radius;
    final lonMax = longitude + radius;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'AmbulanceRequest',
      where: 'latitude BETWEEN ? AND ? AND longitude BETWEEN ? AND ?',
      whereArgs: [latMin, latMax, lonMin, lonMax],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => AmbulanceRequest.fromJson(maps[i]));
  }

  @override
  Future<List<AmbulanceRequest>> getPendingRequests() async {
    return getByStatus(AmbulanceRequestStatus.pending);
  }

  @override
  Future<List<AmbulanceRequest>> getAssignedRequests() async {
    return getByStatus(AmbulanceRequestStatus.assigned);
  }

  @override
  Future<bool> assignAmbulance(int requestId, int ambulanceId, int assignedBy) async {
    final db = await _databaseService.database;
    final count = await db.update(
      'AmbulanceRequest',
      {
        'ambulanceId': ambulanceId,
        'assignedBy': assignedBy,
        'assignedAt': DateTime.now().toIso8601String(),
        'status': AmbulanceRequestStatus.assigned.toString().split('.').last,
      },
      where: 'id = ?',
      whereArgs: [requestId],
    );
    return count > 0;
  }

  @override
  Future<bool> updateStatus(int requestId, AmbulanceRequestStatus status) async {
    final db = await _databaseService.database;
    final statusString = status.toString().split('.').last;
    final count = await db.update(
      'AmbulanceRequest',
      {
        'status': statusString,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [requestId],
    );
    return count > 0;
  }

  @override
  Future<bool> completeRequest(int requestId, DateTime completedAt) async {
    final db = await _databaseService.database;
    final count = await db.update(
      'AmbulanceRequest',
      {
        'status': AmbulanceRequestStatus.completed.toString().split('.').last,
        'completedAt': completedAt.toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [requestId],
    );
    return count > 0;
  }
}
