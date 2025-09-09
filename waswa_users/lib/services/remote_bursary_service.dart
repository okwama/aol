import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bursary_application.dart';
import '../constants/app_constants.dart';

class RemoteBursaryService {
  static const String _baseUrl = AppConstants.baseUrl;

  Future<List<BursaryApplication>> getAllApplications() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bursary'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => BursaryApplication.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load applications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bursary applications: $e');
      rethrow;
    }
  }

  Future<BursaryApplication?> getApplicationById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bursary/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return BursaryApplication.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load application: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bursary application: $e');
      rethrow;
    }
  }

  Future<List<BursaryApplication>> getApplicationsByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bursary/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => BursaryApplication.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user applications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user bursary applications: $e');
      rethrow;
    }
  }

  Future<List<BursaryApplication>> getApplicationsByStatus(String status) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bursary/status/$status'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => BursaryApplication.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load applications by status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bursary applications by status: $e');
      rethrow;
    }
  }

  Future<BursaryApplication?> createApplication(BursaryApplication application) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/bursary'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(application.toJson()),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return BursaryApplication.fromJson(data);
      } else {
        throw Exception('Failed to create application: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating bursary application: $e');
      rethrow;
    }
  }

  Future<bool> updateApplication(BursaryApplication application) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/bursary/${application.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(application.toJson()),
      ).timeout(const Duration(seconds: 30));

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating bursary application: $e');
      rethrow;
    }
  }

  Future<bool> deleteApplication(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/bursary/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting bursary application: $e');
      rethrow;
    }
  }
}
