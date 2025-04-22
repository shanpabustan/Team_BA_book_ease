import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationOverlay extends StatefulWidget {
  final VoidCallback onClose; // Callback to close overlay
  final List<Map<String, String>> notifications;

  const NotificationOverlay({
    super.key,
    required this.onClose,
    required this.notifications,
  });

  @override
  _NotificationOverlayState createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<NotificationOverlay> {
  // Group notifications by category
  Map<String, List<Map<String, String>>> _groupedNotifications() {
    Map<String, List<Map<String, String>>> grouped = {};

    for (var notification in widget.notifications) {
      String category = notification["category"] ?? "Other";
      grouped.putIfAbsent(category, () => []).add(notification);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupedNotifications();

    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black.withOpacity(0.4), // Dim background effect
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
                  // Drag Indicator
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

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Center(
                      child: Text(
                        "Notifications",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Notification List with Categories
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

  Widget _buildCategorySection(
      String category, List<Map<String, String>> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header with Icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                _getCategoryIcon(category),
                color: Colors.teal,
                size: 20,
              ),
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

        // Notification List
        Column(
          children: notifications.map((notification) {
            return _buildNotificationTile(notification);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotificationTile(Map<String, String> notification) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              notification["image"] ?? "assets/images/default.png",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),

          // Notification Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  notification["title"] ?? "No Title",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),

                // Message
                if (notification.containsKey("message"))
                  Text(
                    notification["message"]!,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey[700]),
                  ),

                // Event Date (not sent time)
                if (notification.containsKey("date"))
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.teal),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(notification["date"]!),
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.teal),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Sent Time (right-aligned)
          Text(
            _formatTime(notification["sentAt"] ?? ""), // Uses sentAt field
            style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Returns a Material Icon for the category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Reminders":
        return Icons.notifications_active;
      case "Borrowed Books":
        return Icons.menu_book;
      case "Approvals":
        return Icons.check_circle;
      case "Return Date Notifications":
        return Icons.event_note;
      case "Urgent Returns":
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  // Formats event date
  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateFormat("MMMM d, yyyy").parse(date);
      return DateFormat("MMM d, yyyy").format(parsedDate);
    } catch (e) {
      return date; // Fallback if parsing fails
    }
  }

  // Formats sent time
  String _formatTime(String sentAt) {
    if (sentAt.isEmpty) return "Just now"; // Default if missing

    try {
      DateTime parsedSentAt = DateFormat("MMMM d, yyyy hh:mm a").parse(sentAt);
      DateTime now = DateTime.now();
      Duration difference = now.difference(parsedSentAt);

      if (difference.inDays >= 1) {
        return DateFormat("E").format(parsedSentAt); // Example: Mon, Tue, Wed
      } else {
        return DateFormat("h:mm a").format(parsedSentAt); // Example: 10:45 AM
      }
    } catch (e) {
      return "Just now"; // Fallback if parsing fails
    }
  }
}
