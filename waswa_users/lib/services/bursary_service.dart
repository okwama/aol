import '../models/bursary_payment.dart';
import '../repositories/bursary_repository.dart';

class BursaryService {
  final BursaryRepository _bursaryRepository;

  BursaryService(this._bursaryRepository);

  Future<List<BursaryPayment>> getAllBursaries() async {
    try {
      return await _bursaryRepository.getAll();
    } catch (e) {
      print('Error fetching bursaries: $e');
      return [];
    }
  }

  Future<BursaryPayment?> getBursaryById(int id) async {
    try {
      return await _bursaryRepository.getById(id);
    } catch (e) {
      print('Error fetching bursary: $e');
      return null;
    }
  }

  Future<BursaryPayment?> createBursary(BursaryPayment bursary) async {
    try {
      return await _bursaryRepository.create(bursary);
    } catch (e) {
      print('Error creating bursary: $e');
      return null;
    }
  }

  Future<bool> updateBursary(BursaryPayment bursary) async {
    try {
      await _bursaryRepository.update(bursary);
      return true;
    } catch (e) {
      print('Error updating bursary: $e');
      return false;
    }
  }

  Future<bool> deleteBursary(int id) async {
    try {
      return await _bursaryRepository.delete(id);
    } catch (e) {
      print('Error deleting bursary: $e');
      return false;
    }
  }

  Future<List<BursaryPayment>> getBursariesByStudent(int studentId) async {
    try {
      return await _bursaryRepository.getByStudentId(studentId);
    } catch (e) {
      print('Error fetching student bursaries: $e');
      return [];
    }
  }

  Future<List<BursaryPayment>> getBursariesBySchool(int schoolId) async {
    try {
      return await _bursaryRepository.getBySchoolId(schoolId);
    } catch (e) {
      print('Error fetching school bursaries: $e');
      return [];
    }
  }

  Future<double> getTotalAmountByStudent(int studentId) async {
    try {
      return await _bursaryRepository.getTotalAmountByStudent(studentId);
    } catch (e) {
      print('Error calculating total amount: $e');
      return 0.0;
    }
  }

  Future<double> getTotalAmountBySchool(int schoolId) async {
    try {
      return await _bursaryRepository.getTotalAmountBySchool(schoolId);
    } catch (e) {
      print('Error calculating total amount: $e');
      return 0.0;
    }
  }

  Future<List<BursaryPayment>> getPendingBursaries() async {
    try {
      return await _bursaryRepository.getPendingPayments();
    } catch (e) {
      print('Error fetching pending bursaries: $e');
      return [];
    }
  }

  Future<List<BursaryPayment>> getCompletedBursaries() async {
    try {
      return await _bursaryRepository.getCompletedPayments();
    } catch (e) {
      print('Error fetching completed bursaries: $e');
      return [];
    }
  }
}
