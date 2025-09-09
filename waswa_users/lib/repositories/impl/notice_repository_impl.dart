import 'package:sqflite/sqflite.dart';
import '../../models/notice_board.dart';
import '../notice_repository.dart';
import '../../services/database_service.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final DatabaseService _databaseService;

  NoticeRepositoryImpl(this._databaseService);

  @override
  Future<List<NoticeBoard>> getAll() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('NoticeBoard');
    return List.generate(maps.length, (i) => NoticeBoard.fromJson(maps[i]));
  }

  @override
  Future<NoticeBoard?> getById(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'NoticeBoard',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return NoticeBoard.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<NoticeBoard> create(NoticeBoard item) async {
    final db = await _databaseService.database;
    final id = await db.insert('NoticeBoard', item.toJson());
    return item.copyWith(id: id);
  }

  @override
  Future<NoticeBoard> insertOrReplace(NoticeBoard item) async {
    final db = await _databaseService.database;
    await db.insert('NoticeBoard', item.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  @override
  Future<NoticeBoard> update(NoticeBoard item) async {
    final db = await _databaseService.database;
    await db.update(
      'NoticeBoard',
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
      'NoticeBoard',
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  @override
  Future<List<NoticeBoard>> getRecentNotices(int limit) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'NoticeBoard',
      orderBy: 'createdAt DESC',
      limit: limit,
    );
    return List.generate(maps.length, (i) => NoticeBoard.fromJson(maps[i]));
  }

  @override
  Future<List<NoticeBoard>> getNoticesByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'NoticeBoard',
      where: 'createdAt BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => NoticeBoard.fromJson(maps[i]));
  }

  @override
  Future<List<NoticeBoard>> searchNotices(String query) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'NoticeBoard',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => NoticeBoard.fromJson(maps[i]));
  }

  @override
  Future<List<NoticeBoard>> getImportantNotices() async {
    final db = await _databaseService.database;
    // Assuming important notices are those with specific keywords or recent ones
    final List<Map<String, dynamic>> maps = await db.query(
      'NoticeBoard',
      where: 'title LIKE ? OR title LIKE ? OR title LIKE ?',
      whereArgs: ['%Important%', '%Urgent%', '%Emergency%'],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => NoticeBoard.fromJson(maps[i]));
  }

  @override
  Future<bool> markAsRead(int noticeId) async {
    // This would require adding a read status field to the NoticeBoard table
    // For now, we'll return true as a placeholder
    return true;
  }

  @override
  Future<int> getUnreadCount() async {
    // This would require adding a read status field to the NoticeBoard table
    // For now, we'll return 0 as a placeholder
    return 0;
  }
}
