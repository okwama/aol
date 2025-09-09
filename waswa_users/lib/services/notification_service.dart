import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../models/app_notification.dart';
import 'database_service.dart';

class NotificationService {
  final DatabaseService _databaseService;
  final StreamController<List<AppNotification>> _notificationsController = 
      StreamController<List<AppNotification>>.broadcast();
  
  List<AppNotification> _notifications = [];
  
  NotificationService(this._databaseService);

  Stream<List<AppNotification>> get notificationsStream => _notificationsController.stream;
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  List<AppNotification> get unreadNotifications => 
      _notifications.where((n) => !n.isRead).toList();
  int get unreadCount => unreadNotifications.length;

  /// Initialize the notification service and load existing notifications
  Future<void> initialize() async {
    if (kIsWeb) {
      print('NotificationService: Web platform detected - skipping database initialization');
      return;
    }
    await _loadNotifications();
  }

  /// Add a new notification
  Future<void> addNotification({
    required String title,
    required String message,
    required NotificationType type,
    String? actionData,
  }) async {
    try {
      final notification = AppNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        message: message,
        type: type,
        isRead: false,
        createdAt: DateTime.now(),
        actionData: actionData,
      );

      // Save to database (skip on web)
      if (!kIsWeb) {
        await _saveNotification(notification);
      }
      
      // Add to local list
      _notifications.insert(0, notification);
      
      // Notify listeners
      _notificationsController.add(_notifications);
      
      print('NotificationService: Added notification - ${notification.title}');
    } catch (e) {
      print('NotificationService: Error adding notification - $e');
    }
  }

  /// Mark a notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final updatedNotification = _notifications[index].copyWith(isRead: true);
        _notifications[index] = updatedNotification;
        
        // Update in database (skip on web)
        if (!kIsWeb) {
          await _updateNotification(updatedNotification);
        }
        
        // Notify listeners
        _notificationsController.add(_notifications);
      }
    } catch (e) {
      print('NotificationService: Error marking notification as read - $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      for (int i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead) {
          _notifications[i] = _notifications[i].copyWith(isRead: true);
        }
      }
      
      // Update all in database (skip on web)
      if (!kIsWeb) {
        await _markAllAsReadInDatabase();
      }
      
      // Notify listeners
      _notificationsController.add(_notifications);
    } catch (e) {
      print('NotificationService: Error marking all notifications as read - $e');
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(int notificationId) async {
    try {
      _notifications.removeWhere((n) => n.id == notificationId);
      
      // Delete from database (skip on web)
      if (!kIsWeb) {
        await _deleteNotification(notificationId);
      }
      
      // Notify listeners
      _notificationsController.add(_notifications);
    } catch (e) {
      print('NotificationService: Error deleting notification - $e');
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      _notifications.clear();
      
      // Clear from database (skip on web)
      if (!kIsWeb) {
        await _clearAllNotificationsFromDatabase();
      }
      
      // Notify listeners
      _notificationsController.add(_notifications);
    } catch (e) {
      print('NotificationService: Error clearing all notifications - $e');
    }
  }

  /// Get notifications by type
  List<AppNotification> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  /// Load notifications from database
  Future<void> _loadNotifications() async {
    try {
      if (kIsWeb) {
        print('NotificationService: Web platform - skipping database load');
        _notifications = [];
        _notificationsController.add(_notifications);
        return;
      }
      
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'notifications',
        orderBy: 'created_at DESC',
      );

      _notifications = maps.map((map) => AppNotification.fromMap(map)).toList();
      _notificationsController.add(_notifications);
      
      print('NotificationService: Loaded ${_notifications.length} notifications');
    } catch (e) {
      print('NotificationService: Error loading notifications - $e');
      _notifications = [];
    }
  }

  /// Save notification to database
  Future<void> _saveNotification(AppNotification notification) async {
    try {
      final db = await _databaseService.database;
      await db.insert('notifications', notification.toMap());
    } catch (e) {
      print('NotificationService: Error saving notification - $e');
    }
  }

  /// Update notification in database
  Future<void> _updateNotification(AppNotification notification) async {
    try {
      final db = await _databaseService.database;
      await db.update(
        'notifications',
        notification.toMap(),
        where: 'id = ?',
        whereArgs: [notification.id],
      );
    } catch (e) {
      print('NotificationService: Error updating notification - $e');
    }
  }

  /// Mark all notifications as read in database
  Future<void> _markAllAsReadInDatabase() async {
    try {
      final db = await _databaseService.database;
      await db.update(
        'notifications',
        {'is_read': 1},
        where: 'is_read = ?',
        whereArgs: [0],
      );
    } catch (e) {
      print('NotificationService: Error marking all as read in database - $e');
    }
  }

  /// Delete notification from database
  Future<void> _deleteNotification(int notificationId) async {
    try {
      final db = await _databaseService.database;
      await db.delete(
        'notifications',
        where: 'id = ?',
        whereArgs: [notificationId],
      );
    } catch (e) {
      print('NotificationService: Error deleting notification from database - $e');
    }
  }

  /// Clear all notifications from database
  Future<void> _clearAllNotificationsFromDatabase() async {
    try {
      final db = await _databaseService.database;
      await db.delete('notifications');
    } catch (e) {
      print('NotificationService: Error clearing all notifications from database - $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _notificationsController.close();
  }
}
