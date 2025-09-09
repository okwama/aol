import '../models/bursary_payment.dart';
import 'base_repository.dart';

abstract class BursaryRepository extends BaseRepository<BursaryPayment> {
  Future<List<BursaryPayment>> getByStudentId(int studentId);
  Future<List<BursaryPayment>> getBySchoolId(int schoolId);
  Future<List<BursaryPayment>> getByDateRange(DateTime startDate, DateTime endDate);
  Future<double> getTotalAmountByStudent(int studentId);
  Future<double> getTotalAmountBySchool(int schoolId);
  Future<List<BursaryPayment>> getPendingPayments();
  Future<List<BursaryPayment>> getCompletedPayments();
}
