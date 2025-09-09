import 'package:sqflite/sqflite.dart';
import '../../models/user.dart';
import '../user_repository.dart';
import '../../services/database_service.dart';

class UserRepositoryImpl implements UserRepository {
  final DatabaseService _databaseService;

  UserRepositoryImpl(this._databaseService);

  @override
  Future<List<User>> getAll() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('User');
    return List.generate(maps.length, (i) => User.fromJson(maps[i]));
  }

  @override
  Future<User?> getById(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<User> create(User item) async {
    final db = await _databaseService.database;
    // Create a copy of the JSON without the id field for auto-increment
    final jsonData = item.toJson();
    jsonData.remove('id');
    final id = await db.insert('User', jsonData);
    return item.copyWith(id: id);
  }

  @override
  Future<User> insertOrReplace(User item) async {
    final db = await _databaseService.database;
    await db.insert('User', item.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  @override
  Future<User> update(User item) async {
    final db = await _databaseService.database;
    await db.update(
      'User',
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
      'User',
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  @override
  Future<User?> authenticate(String email, String password) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<User?> getByEmail(String email) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<User?> getByPhone(String phone) async {
    final db = await _databaseService.database;
    
    // Normalize phone number by removing all non-digit characters
    final normalizedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    print('Phone search - Original: "$phone", Normalized: "$normalizedPhone"');
    
    // Try exact match first
    List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'phoneNumber = ?',
      whereArgs: [phone],
    );
    
    print('Exact match result: ${maps.length}');
    
    // If no exact match, try normalized phone number
    if (maps.isEmpty) {
      maps = await db.query(
        'User',
        where: 'phoneNumber = ?',
        whereArgs: [normalizedPhone],
      );
      print('Normalized match result: ${maps.length}');
    }
    
    // If still no match, try searching for phone numbers that contain the normalized digits
    if (maps.isEmpty) {
      maps = await db.query(
        'User',
        where: 'phoneNumber LIKE ?',
        whereArgs: ['%$normalizedPhone%'],
      );
      print('Partial match result: ${maps.length}');
    }
    
    if (maps.isNotEmpty) {
      print('Phone search successful: ${maps.first['phoneNumber']}');
      return User.fromJson(maps.first);
    }
    
    print('Phone search failed: No matches found');
    return null;
  }

  @override
  Future<List<User>> getByRole(String role) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'role = ?',
      whereArgs: [role],
    );
    return List.generate(maps.length, (i) => User.fromJson(maps[i]));
  }

  @override
  Future<bool> updatePassword(int userId, String newPassword) async {
    final db = await _databaseService.database;
    final count = await db.update(
      'User',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  @override
  Future<bool> updateStatus(int userId, int status) async {
    final db = await _databaseService.database;
    final count = await db.update(
      'User',
      {'status': status},
      where: 'id = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }
}
