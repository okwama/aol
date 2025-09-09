import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/user.dart';

class RemoteAuthService {
  static const String _baseUrl = AppConstants.baseUrl;

  Future<Map<String, dynamic>> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'phoneNumber': user.phoneNumber,
          'password': user.password,
          'nationalId': user.nationalId,
          'city': 'Webuye',
          'state': 'Western',
          'country': 'Kenya',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'success': true,
            'user': User.fromJson(data['user']),
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Registration failed',
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> login(String emailOrPhone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'emailOrPhone': emailOrPhone,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'success': true,
            'user': User.fromJson(data['user']),
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Login failed',
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/profile/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'success': true,
            'user': User.fromJson(data['user']),
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Failed to get profile',
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile(User user) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/auth/profile/${user.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'phoneNumber': user.phoneNumber,
          'nationalId': user.nationalId,
          'city': user.city,
          'state': user.state,
          'country': user.country,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'success': true,
            'user': User.fromJson(data['user']),
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Profile update failed',
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> changePassword(int userId, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/auth/change-password/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'success': true,
            'message': data['message'] ?? 'Password changed successfully',
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Password change failed',
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<bool> checkUserExists(String email, String phone) async {
    try {
      // Try to get profile by email
      final emailResponse = await http.get(
        Uri.parse('$_baseUrl/auth/profile/0'), // This will fail but we can check the error
        headers: {'Content-Type': 'application/json'},
      );
      
      // For now, we'll use a simple approach - try login with dummy password
      // If it returns "Invalid password", user exists. If "User not found", user doesn't exist
      final loginResponse = await login(email, 'dummy_password');
      
      if (loginResponse['success'] == false) {
        final message = loginResponse['message'] as String;
        if (message.contains('Invalid password')) {
          return true; // User exists but wrong password
        } else if (message.contains('User not found')) {
          return false; // User doesn't exist
        }
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }
}
