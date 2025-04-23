import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:book_ease/data/notification_data.dart'; // Make sure it's imported

class NotificationOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final List<AppNotification> notifications;

  const NotificationOverlay({
    super.key,
    required this.onClose,
    required this.notifications,
  });

  @override
  _NotificationOverlayState createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<NotificationOverlay> {
  // Group notifications by a custom logic — you can later use categories if you add them in AppNotification
  Map<String, List<AppNotification>> _groupedNotifications() {
    // For now, all go under "General"
    return {
      "General": widget.notifications,
    };
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupedNotifications();

    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Drag indicator
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text(
                    "Notifications",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: groupedNotifications.entries.map((entry) {
                        return _buildCategorySection(entry.key, entry.value);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, List<AppNotification> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.notifications, color: Colors.teal, size: 20),
              const SizedBox(width: 8),
              Text(
                category,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: notifications.map((notification) {
            return _buildNotificationTile(notification);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotificationTile(AppNotification notification) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder image or future dynamic image
         
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notification",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  notification.message,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey[700]),
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.teal),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(notification.createdAt),
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.teal),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            _formatTime(notification.createdAt),
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateTime) {
    try {
      DateTime parsed = DateTime.parse(dateTime);
      return DateFormat("MMM d, yyyy").format(parsed);
    } catch (_) {
      return dateTime;
    }
  }

  String _formatTime(String dateTime) {
    try {
      DateTime parsed = DateTime.parse(dateTime);
      return DateFormat("h:mm a").format(parsed);
    } catch (_) {
      return "Just now";
    }
  }
}

