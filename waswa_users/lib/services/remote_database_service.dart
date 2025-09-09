import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class RemoteDatabaseService {
  // Update this URL after deploying to Vercel
  static const String _baseUrl = 'https://your-api.vercel.app/api/v1';
  
  // For development, you can use localhost
  // static const String _baseUrl = 'http://localhost:3000/api/v1';
  
  static Future<Map<String, dynamic>> _makeRequest(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body != null ? jsonEncode(body) : null,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Remote database error: $e');
      rethrow;
    }
  }

  // Get dashboard statistics
  static Future<Map<String, int>> getDashboardStats() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/dashboard/stats'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return Map<String, int>.from(data['data']);
        }
      }
      return {
        'totalUsers': 0,
        'totalNotices': 0,
        'recentNotices': 0,
        'unreadNotifications': 0,
      };
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      return {
        'totalUsers': 0,
        'totalNotices': 0,
        'recentNotices': 0,
        'unreadNotifications': 0,
      };
    }
  }

  // Get today's events
  static Future<List<Map<String, dynamic>>> getTodayEvents() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/dashboard/today-events'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching today events: $e');
      return [];
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile(int userId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/dashboard/user-profile/$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Get recent notices
  static Future<List<Map<String, dynamic>>> getRecentNotices(int limit) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/dashboard/recent-notices?limit=$limit'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching recent notices: $e');
      return [];
    }
  }

  // Get all home screen data in one request
  static Future<Map<String, dynamic>?> getHomeData() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/dashboard/home-data'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      print('Error fetching home data: $e');
      return null;
    }
  }

  // Get unread notifications count
  static Future<int> getUnreadNotificationsCount(int userId) async {
    try {
      final stats = await getDashboardStats();
      return stats['unreadNotifications'] ?? 0;
    } catch (e) {
      print('Error fetching unread count: $e');
      return 0;
    }
  }
}
