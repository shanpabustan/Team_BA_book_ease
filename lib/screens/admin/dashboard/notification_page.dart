// lib/widgets/notification_popup.dart
import 'package:flutter/material.dart';
import 'package:book_ease/provider/notification_service.dart'; // Adjust path
import 'package:book_ease/data/notification_data.dart';
import 'package:intl/intl.dart';

class NotificationPopup extends StatefulWidget {
  final String userId;
  final Function(List<AppNotification>)? onNotificationsUpdated;

  const NotificationPopup({
    super.key,
    required this.userId,
    this.onNotificationsUpdated,
  });

  @override
  State<NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<NotificationPopup> {
  final NotificationService _notificationService = NotificationService();
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final notifications = await _notificationService.fetchNotifications(widget.userId);
      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
        widget.onNotificationsUpdated?.call(_notifications);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        print("Failed to load notifications: $e");
      }
    }
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((n) => AppNotification(
        notificationId: n.notificationId,
        userId: n.userId,
        message: n.message,
        createdAt: n.createdAt,
        isRead: true,
      )).toList();
    });
    widget.onNotificationsUpdated?.call(_notifications);
  }

  String _formatTime(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('MMM d, h:mm a').format(dateTime);
    } catch (_) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Container(
        width: 320,
        constraints: const BoxConstraints(maxHeight: 400),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Notifications",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: _markAllAsRead,
                  child: const Text(
                    "Mark All as Read",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const Divider(),
            // List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _notifications.isEmpty
                      ? const Center(child: Text("No notifications"))
                      : ListView.separated(
                          itemCount: _notifications.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final notif = _notifications[index];
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.notifications,
                                color: notif.isRead ? Colors.grey : Colors.blue,
                              ),
                              title: Text(
                                notif.message,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                _formatTime(notif.createdAt),
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              onTap: () {
                                setState(() {
                                  _notifications[index] = AppNotification(
                                    notificationId: notif.notificationId,
                                    userId: notif.userId,
                                    message: notif.message,
                                    createdAt: notif.createdAt,
                                    isRead: true,
                                  );
                                });
                                widget.onNotificationsUpdated?.call(_notifications);
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
