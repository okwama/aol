import '../models/user.dart';
import 'base_repository.dart';

abstract class UserRepository extends BaseRepository<User> {
  Future<User?> authenticate(String email, String password);
  Future<User?> getByEmail(String email);
  Future<User?> getByPhone(String phone);
  Future<List<User>> getByRole(String role);
  Future<bool> updatePassword(int userId, String newPassword);
  Future<bool> updateStatus(int userId, int status);
}
