class AppNotification {
  final int notificationId;
  final String userId;
  final String message;
  final String createdAt;
  final bool isRead;

  AppNotification({
    required this.notificationId,
    required this.userId,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    print('Creating AppNotification from JSON: $json');
    print('Available keys: ${json.keys.toList()}');
    
    // Print each field value
    print('notification_id: ${json['notification_id']}');
    print('UserID: ${json['UserID']}');
    print('Message: ${json['Message']}');
    print('CreatedAt: ${json['CreatedAt']}');
    print('IsRead: ${json['IsRead']}');
    
    final notification = AppNotification(
      notificationId: json['notification_id'] ?? 0,
      userId: json['UserID']?.toString() ?? '',
      message: json['Message'] ?? 'No message',
      createdAt: json['CreatedAt'] ?? DateTime.now().toIso8601String(),
      isRead: json['IsRead'] ?? false,
    );
    
    print('Created notification: ID=${notification.notificationId}, Message=${notification.message}');
    return notification;
  }
}

