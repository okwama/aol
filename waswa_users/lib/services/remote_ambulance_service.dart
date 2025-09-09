import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/ambulance_request.dart';

class RemoteAmbulanceService {
  static const String _baseUrl = '${AppConstants.baseUrl}/ambulance';

  Future<List<AmbulanceRequest>> getAllRequests() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AmbulanceRequest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load ambulance requests: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching ambulance requests: $e');
      rethrow;
    }
  }

  Future<AmbulanceRequest?> getRequestById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AmbulanceRequest.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load ambulance request: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching ambulance request: $e');
      rethrow;
    }
  }

  Future<AmbulanceRequest> createRequest(AmbulanceRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return AmbulanceRequest.fromJson(data);
      } else {
        throw Exception('Failed to create ambulance request: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating ambulance request: $e');
      rethrow;
    }
  }

  Future<AmbulanceRequest> updateRequest(AmbulanceRequest request) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${request.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AmbulanceRequest.fromJson(data);
      } else {
        throw Exception('Failed to update ambulance request: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating ambulance request: $e');
      rethrow;
    }
  }

  Future<bool> deleteRequest(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting ambulance request: $e');
      rethrow;
    }
  }

  Future<List<AmbulanceRequest>> getRequestsByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AmbulanceRequest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user ambulance requests: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user ambulance requests: $e');
      rethrow;
    }
  }

  Future<List<AmbulanceRequest>> getRequestsByStatus(AmbulanceRequestStatus status) async {
    try {
      final statusString = status.toString().split('.').last;
      final response = await http.get(
        Uri.parse('$_baseUrl/status/$statusString'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AmbulanceRequest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load ambulance requests by status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching ambulance requests by status: $e');
      rethrow;
    }
  }

  Future<List<AmbulanceRequest>> getPendingRequests() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pending'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AmbulanceRequest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load pending requests: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pending requests: $e');
      rethrow;
    }
  }

  Future<List<AmbulanceRequest>> getAssignedRequests() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/assigned'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AmbulanceRequest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load assigned requests: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching assigned requests: $e');
      rethrow;
    }
  }

  Future<List<AmbulanceRequest>> getEmergencyRequests() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/emergency'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AmbulanceRequest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load emergency requests: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching emergency requests: $e');
      rethrow;
    }
  }

  Future<AmbulanceRequest> assignAmbulance(int requestId, int ambulanceId, int assignedBy) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$requestId/assign'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'ambulanceId': ambulanceId,
          'assignedBy': assignedBy,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AmbulanceRequest.fromJson(data);
      } else {
        throw Exception('Failed to assign ambulance: ${response.statusCode}');
      }
    } catch (e) {
      print('Error assigning ambulance: $e');
      rethrow;
    }
  }

  Future<AmbulanceRequest> updateRequestStatus(int requestId, AmbulanceRequestStatus status) async {
    try {
      final statusString = status.toString().split('.').last;
      final response = await http.put(
        Uri.parse('$_baseUrl/$requestId/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': statusString}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AmbulanceRequest.fromJson(data);
      } else {
        throw Exception('Failed to update request status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating request status: $e');
      rethrow;
    }
  }
}
