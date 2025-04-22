// lib/widgets/notification_popup.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/notification_provider.dart';

class NotificationPopup extends StatelessWidget {
  const NotificationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final notifProvider = context.watch<NotificationProvider>();

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
                  onPressed: () => notifProvider.markAllAsRead(),
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
              child: notifProvider.notifications.isEmpty
                  ? const Center(child: Text("No notifications"))
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: notifProvider.notifications.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final notif = notifProvider.notifications[index];
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.notifications,
                              color: Colors.blue),
                          title: Text(notif.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(notif.message),
                          trailing: Text(
                            notif.time,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
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