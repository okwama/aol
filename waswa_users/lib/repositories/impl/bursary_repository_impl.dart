import 'package:sqflite/sqflite.dart';
import '../../models/bursary_payment.dart';
import '../bursary_repository.dart';
import '../../services/database_service.dart';

class BursaryRepositoryImpl implements BursaryRepository {
  final DatabaseService _databaseService;

  BursaryRepositoryImpl(this._databaseService);

  @override
  Future<List<BursaryPayment>> getAll() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('BursaryPayment');
    return List.generate(maps.length, (i) => BursaryPayment.fromJson(maps[i]));
  }

  @override
  Future<BursaryPayment?> getById(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'BursaryPayment',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return BursaryPayment.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<BursaryPayment> create(BursaryPayment item) async {
    final db = await _databaseService.database;
    final id = await db.insert('BursaryPayment', item.toJson());
    return item.copyWith(id: id);
  }

  @override
  Future<BursaryPayment> insertOrReplace(BursaryPayment item) async {
    final db = await _databaseService.database;
    await db.insert('BursaryPayment', item.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  @override
  Future<BursaryPayment> update(BursaryPayment item) async {
    final db = await _databaseService.database;
    await db.update(
      'BursaryPayment',
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
      'BursaryPayment',
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  @override
  Future<List<BursaryPayment>> getByStudentId(int studentId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'BursaryPayment',
      where: 'studentId = ?',
      whereArgs: [studentId],
      orderBy: 'datePaid DESC',
    );
    return List.generate(maps.length, (i) => BursaryPayment.fromJson(maps[i]));
  }

  @override
  Future<List<BursaryPayment>> getBySchoolId(int schoolId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'BursaryPayment',
      where: 'schoolId = ?',
      whereArgs: [schoolId],
      orderBy: 'datePaid DESC',
    );
    return List.generate(maps.length, (i) => BursaryPayment.fromJson(maps[i]));
  }

  @override
  Future<List<BursaryPayment>> getByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'BursaryPayment',
      where: 'datePaid BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'datePaid DESC',
    );
    return List.generate(maps.length, (i) => BursaryPayment.fromJson(maps[i]));
  }

  @override
  Future<double> getTotalAmountByStudent(int studentId) async {
    final db = await _databaseService.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM BursaryPayment WHERE studentId = ?',
      [studentId],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<double> getTotalAmountBySchool(int schoolId) async {
    final db = await _databaseService.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM BursaryPayment WHERE schoolId = ?',
      [schoolId],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<List<BursaryPayment>> getPendingPayments() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'BursaryPayment',
      where: 'referenceNumber IS NULL OR referenceNumber = ""',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => BursaryPayment.fromJson(maps[i]));
  }

  @override
  Future<List<BursaryPayment>> getCompletedPayments() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'BursaryPayment',
      where: 'referenceNumber IS NOT NULL AND referenceNumber != ""',
      orderBy: 'datePaid DESC',
    );
    return List.generate(maps.length, (i) => BursaryPayment.fromJson(maps[i]));
  }
}
