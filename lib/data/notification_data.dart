class AppNotification {
  final int notificationId;
  final String userId;
  final String message;  // This is all you need for display
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
      notificationId: json['NotificationID'],
      userId: json['UserID'],
      message: json['Message'],  // Directly using the message
      createdAt: json['CreatedAt'],
      isRead: json['IsRead'],
    );
  }
}
