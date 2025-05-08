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
  return AppNotification(
    notificationId: json['NotificationID'] ?? 0,
    userId: json['UserID'] ?? '',
    message: json['Message'] ?? 'No message',
    createdAt: json['CreatedAt'] ?? DateTime.now().toIso8601String(),
    isRead: json['IsRead'] ?? false,
  );
}

}

