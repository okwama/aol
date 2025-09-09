class AppNotification {
  final int id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final String? actionData;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.actionData,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'action_data': actionData,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.system,
      ),
      isRead: map['is_read'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      actionData: map['action_data'],
    );
  }

  AppNotification copyWith({
    int? id,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    String? actionData,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      actionData: actionData ?? this.actionData,
    );
  }
}

enum NotificationType {
  bursary,
  ambulance,
  event,
  system,
  notice,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.bursary:
        return 'Bursary';
      case NotificationType.ambulance:
        return 'Ambulance';
      case NotificationType.event:
        return 'Event';
      case NotificationType.system:
        return 'System';
      case NotificationType.notice:
        return 'Notice';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.bursary:
        return '🎓';
      case NotificationType.ambulance:
        return '🚑';
      case NotificationType.event:
        return '📅';
      case NotificationType.system:
        return '⚙️';
      case NotificationType.notice:
        return '📢';
    }
  }
}
