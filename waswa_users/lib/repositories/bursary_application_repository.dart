import '../../models/bursary_application.dart';

abstract class BursaryApplicationRepository {
  Future<List<BursaryApplication>> getAll();
  Future<BursaryApplication?> getById(int id);
  Future<BursaryApplication> create(BursaryApplication item);
  Future<BursaryApplication> update(BursaryApplication item);
  Future<bool> delete(int id);
  Future<List<BursaryApplication>> getByUserId(int userId);
  Future<List<BursaryApplication>> getByStatus(String status);
}
