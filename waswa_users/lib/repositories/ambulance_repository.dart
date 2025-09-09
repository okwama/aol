import '../models/ambulance_request.dart';
import 'base_repository.dart';

abstract class AmbulanceRepository extends BaseRepository<AmbulanceRequest> {
  Future<List<AmbulanceRequest>> getByUserId(int userId);
  Future<List<AmbulanceRequest>> getByStatus(AmbulanceRequestStatus status);
  Future<List<AmbulanceRequest>> getByDateRange(DateTime startDate, DateTime endDate);
  Future<List<AmbulanceRequest>> getByLocation(double latitude, double longitude, double radius);
  Future<List<AmbulanceRequest>> getPendingRequests();
  Future<List<AmbulanceRequest>> getAssignedRequests();
  Future<bool> assignAmbulance(int requestId, int ambulanceId, int assignedBy);
  Future<bool> updateStatus(int requestId, AmbulanceRequestStatus status);
  Future<bool> completeRequest(int requestId, DateTime completedAt);
}
