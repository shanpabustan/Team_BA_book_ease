// lib/models/notification_model.dart
class NotificationModel {
  final String title;
  final String message;
  final String time;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false, // default: unread
  });
}