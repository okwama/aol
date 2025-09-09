import 'package:sqflite/sqflite.dart';
import '../../models/bursary_application.dart';
import '../bursary_application_repository.dart';
import '../../services/database_service.dart';

class BursaryApplicationRepositoryImpl implements BursaryApplicationRepository {
  final DatabaseService _databaseService;

  BursaryApplicationRepositoryImpl(this._databaseService);

  @override
  Future<List<BursaryApplication>> getAll() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('BursaryApplication');
    return List.generate(maps.length, (i) => BursaryApplication.fromJson(maps[i]));
  }

  @override
  Future<BursaryApplication?> getById(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'BursaryApplication',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return BursaryApplication.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<BursaryApplication> create(BursaryApplication item) async {
    final db = await _databaseService.database;
    final id = await db.insert('BursaryApplication', item.toJson());
    return item.copyWith(id: id);
  }

  @override
  Future<BursaryApplication> insertOrReplace(BursaryApplication item) async {
    final db = await _databaseService.database;
    await db.insert('BursaryApplication', item.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  @override
  Future<BursaryApplication> update(BursaryApplication item) async {
    final db = await _databaseService.database;
    await db.update(
      'BursaryApplication',
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
      'BursaryApplication',
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  @override
  Future<List<BursaryApplication>> getByUserId(int userId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'BursaryApplication',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => BursaryApplication.fromJson(maps[i]));
  }

  @override
  Future<List<BursaryApplication>> getByStatus(String status) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'BursaryApplication',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => BursaryApplication.fromJson(maps[i]));
  }
}
