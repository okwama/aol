import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import 'remote_auth_service.dart';
import 'sync_service.dart';

class AuthService {
  final UserRepository _userRepository;
  final RemoteAuthService _remoteAuthService;
  final SyncService _syncService;
  final FlutterSecureStorage _secureStorage;
  User? _currentUser;

  AuthService(this._userRepository, this._remoteAuthService, this._syncService) 
      : _secureStorage = const FlutterSecureStorage();

  User? get currentUser => _currentUser;

  Future<bool> isAuthenticated() async {
    if (_currentUser != null) return true;
    
    try {
      // Check secure storage for login status
      final isLoggedIn = await _secureStorage.read(key: 'is_logged_in');
      if (isLoggedIn == 'true') {
        // Try to restore user session
        final userId = await _secureStorage.read(key: 'user_id');
        if (userId != null) {
          // On web platform, skip database lookup and create a basic user from stored data
          if (kIsWeb) {
            final userName = await _secureStorage.read(key: 'user_name') ?? 'User';
            final userEmail = await _secureStorage.read(key: 'user_email') ?? '';
            _currentUser = User(
              id: int.parse(userId),
              name: userName,
              email: userEmail,
              phoneNumber: '',
              password: '',
              role: 'USER',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              status: 1,
            );
            return true;
          } else {
            final user = await _userRepository.getById(int.parse(userId));
            if (user != null) {
              _currentUser = user;
              return true;
            }
          }
        }
      }
      return false;
    } catch (e) {
      print('Authentication check error: $e');
      return false;
    }
  }

  Future<User?> login(String emailOrPhone, String password) async {
    try {
      // Try server login first
      final serverResult = await _remoteAuthService.login(emailOrPhone, password);
      
      if (serverResult['success'] == true) {
        // Server login successful
        final user = serverResult['user'] as User;
        _currentUser = user;
        
        // Store user data locally for offline access
        await _storeUserLocally(user);
        
        // Store session data securely
        await _secureStorage.write(key: 'user_id', value: user.id.toString());
        await _secureStorage.write(key: 'user_email', value: user.email);
        await _secureStorage.write(key: 'user_name', value: user.name);
        await _secureStorage.write(key: 'is_logged_in', value: 'true');
        await _secureStorage.write(key: 'server_user_id', value: user.id.toString());
        
        return user;
      } else {
        // Server login failed, try local fallback
        print('Server login failed: ${serverResult['message']}');
        return await _loginLocally(emailOrPhone, password);
      }
    } catch (e) {
      print('Login error: $e');
      // Try local fallback on network error
      return await _loginLocally(emailOrPhone, password);
    }
  }

  Future<User?> _loginLocally(String emailOrPhone, String password) async {
    try {
      // On web platform, skip local database lookup
      if (kIsWeb) {
        print('Local login not supported on web platform');
        return null;
      }
      
      // Determine if input is email or phone
      final isEmail = emailOrPhone.contains('@');
      User? user;
      
      if (isEmail) {
        // Try to find user by email
        user = await _userRepository.getByEmail(emailOrPhone);
      } else {
        // Try to find user by phone
        user = await _userRepository.getByPhone(emailOrPhone);
      }
      
      // Verify password
      if (user != null && user.password == password) {
        _currentUser = user;
        
        // Store user data securely
        await _secureStorage.write(key: 'user_id', value: user.id.toString());
        await _secureStorage.write(key: 'user_email', value: user.email);
        await _secureStorage.write(key: 'user_name', value: user.name);
        await _secureStorage.write(key: 'is_logged_in', value: 'true');
        
        return user;
      }
      return null;
    } catch (e) {
      print('Local login error: $e');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      _currentUser = null;
      
      // Clear secure storage
      await _secureStorage.delete(key: 'user_id');
      await _secureStorage.delete(key: 'user_email');
      await _secureStorage.delete(key: 'user_name');
      await _secureStorage.delete(key: 'is_logged_in');
      
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  Future<User?> register(User user) async {
    try {
      // Try server registration first
      final serverResult = await _remoteAuthService.register(user);
      
      if (serverResult['success'] == true) {
        // Server registration successful
        final serverUser = serverResult['user'] as User;
        
        // Store user data locally for offline access
        await _storeUserLocally(serverUser);
        
        // Store session data securely
        await _secureStorage.write(key: 'user_id', value: serverUser.id.toString());
        await _secureStorage.write(key: 'user_email', value: serverUser.email);
        await _secureStorage.write(key: 'user_name', value: serverUser.name);
        await _secureStorage.write(key: 'is_logged_in', value: 'true');
        await _secureStorage.write(key: 'server_user_id', value: serverUser.id.toString());
        
        _currentUser = serverUser;
        return serverUser;
      } else {
        // Server registration failed, try local fallback
        print('Server registration failed: ${serverResult['message']}');
        return await _registerLocally(user);
      }
    } catch (e) {
      print('Registration error: $e');
      // Try local fallback on network error
      return await _registerLocally(user);
    }
  }

  Future<User?> _registerLocally(User user) async {
    try {
      // Skip local registration on web platform
      if (kIsWeb) {
        print('Local registration not supported on web platform');
        return null;
      }
      
      final createdUser = await _userRepository.create(user);
      
      // Store session data securely
      await _secureStorage.write(key: 'user_id', value: createdUser.id.toString());
      await _secureStorage.write(key: 'user_email', value: createdUser.email);
      await _secureStorage.write(key: 'user_name', value: createdUser.name);
      await _secureStorage.write(key: 'is_logged_in', value: 'true');
      
      _currentUser = createdUser;
      return createdUser;
    } catch (e) {
      print('Local registration error: $e');
      return null;
    }
  }

  Future<void> _storeUserLocally(User user) async {
    try {
      // Skip local storage on web platform
      if (kIsWeb) {
        print('Local user storage not supported on web platform');
        return;
      }
      
      // Check if user already exists locally
      final existingUser = await _userRepository.getByEmail(user.email);
      if (existingUser != null) {
        // Update existing user
        await _userRepository.update(user);
      } else {
        // Create new user locally
        await _userRepository.create(user);
      }
    } catch (e) {
      print('Error storing user locally: $e');
    }
  }

  Future<bool> updateProfile(User user) async {
    try {
      await _userRepository.update(user);
      if (_currentUser?.id == user.id) {
        _currentUser = user;
      }
      return true;
    } catch (e) {
      print('Profile update error: $e');
      return false;
    }
  }

  Future<bool> changePassword(int userId, String newPassword) async {
    try {
      return await _userRepository.updatePassword(userId, newPassword);
    } catch (e) {
      print('Password change error: $e');
      return false;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      return await _userRepository.getByEmail(email);
    } catch (e) {
      print('Get user by email error: $e');
      return null;
    }
  }

  Future<User?> getUserByPhone(String phone) async {
    try {
      return await _userRepository.getByPhone(phone);
    } catch (e) {
      print('Get user by phone error: $e');
      return null;
    }
  }
}
