// lib/providers/notification_provider.dart
import 'package:flutter/material.dart';
import 'package:book_ease/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      title: "New User Registered",
      message: "John Doe just registered an account.",
      time: "5 min ago",
    ),
    NotificationModel(
      title: "Book Reserved",
      message: "A user reserved 'Flutter for Pros'.",
      time: "10 min ago",
    ),
    NotificationModel(
      title: "New Message",
      message: "You have a message from admin support.",
      time: "30 min ago",
    ),
    NotificationModel(
      title: "Book Reserved",
      message: "A user reserved 'Flutter for Pros'.",
      time: "10 min ago",
    ),
    NotificationModel(
      title: "New Message",
      message: "You have a message from admin support.",
      time: "30 min ago",
    ),
    NotificationModel(
      title: "Book Reserved",
      message: "A user reserved 'Flutter for Pros'.",
      time: "10 min ago",
    ),
    NotificationModel(
      title: "New Message",
      message: "You have a message from admin support.",
      time: "30 min ago",
    ),
  ];

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((notif) => !notif.isRead).length;

  void markAllAsRead() {
    for (var notif in _notifications) {
      notif.isRead = true;
    }
    notifyListeners();
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
}