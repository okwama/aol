import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/activity.dart';

class RemoteActivityService {
  static const String _baseUrl = '${AppConstants.baseUrl}/activity';

  Future<List<Activity>> getAllActivities() async {
    try {
      print('RemoteActivityService: Fetching activities from $_baseUrl');
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      print('RemoteActivityService: Response status: ${response.statusCode}');
      print('RemoteActivityService: Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('RemoteActivityService: Parsed ${data.length} activities');
        final activities = data.map((json) => Activity.fromJson(json)).toList();
        print('RemoteActivityService: Successfully created ${activities.length} Activity objects');
        return activities;
      } else {
        print('RemoteActivityService: Error response: ${response.body}');
        throw Exception('Failed to load activities: ${response.statusCode}');
      }
    } catch (e) {
      print('RemoteActivityService: Error fetching activities: $e');
      rethrow;
    }
  }

  Future<Activity?> getActivityById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Activity.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load activity: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activity: $e');
      rethrow;
    }
  }

  Future<List<Activity>> getActivitiesByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user activities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user activities: $e');
      rethrow;
    }
  }

  Future<List<Activity>> getActivitiesByStatus(int status) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/status/$status'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load activities by status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities by status: $e');
      rethrow;
    }
  }

  Future<List<Activity>> getActivitiesByType(String activityType) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/type/$activityType'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load activities by type: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities by type: $e');
      rethrow;
    }
  }

  Future<List<Activity>> getActivitiesByLocation(String location) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/location?location=$location'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load activities by location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities by location: $e');
      rethrow;
    }
  }

  Future<List<Activity>> getActivitiesByDateRange(String startDate, String endDate) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/date-range?startDate=$startDate&endDate=$endDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load activities by date range: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities by date range: $e');
      rethrow;
    }
  }

  Future<List<Activity>> getUpcomingActivities() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/upcoming'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load upcoming activities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching upcoming activities: $e');
      rethrow;
    }
  }

  Future<List<Activity>> getCompletedActivities() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/completed'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load completed activities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching completed activities: $e');
      rethrow;
    }
  }

  Future<List<Activity>> getActivitiesByMonth(int year, int month) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/month/$year/$month'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load activities by month: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities by month: $e');
      rethrow;
    }
  }

  Future<double> getTotalBudgetByUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/budget/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data as num).toDouble();
      } else {
        throw Exception('Failed to load total budget: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching total budget: $e');
      rethrow;
    }
  }
}
