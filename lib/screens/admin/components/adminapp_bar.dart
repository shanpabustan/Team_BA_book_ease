import 'package:book_ease/base_url.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/dashboard/notification_page.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/notification_service.dart';
import 'package:book_ease/data/notification_data.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;

  const AppBarWidget({
    required this.scaffoldKey,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  final GlobalKey _notifIconKey = GlobalKey();
  OverlayEntry? _popupEntry;
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final userId = context.read<UserData>().userID;
    if (userId.isEmpty) return;

    try {
      final service = NotificationService();
      final notifications = await service.fetchNotifications(userId);
      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to load notifications: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleNotificationPopup(BuildContext context, String userId) {
    if (_popupEntry != null) {
      _popupEntry!.remove();
      _popupEntry = null;
      return;
    }

    final RenderBox renderBox =
        _notifIconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    _popupEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + 40,
        left: position.dx - 280,
        child: NotificationPopup(
          userId: userId,
          onNotificationsUpdated: (notifications) {
            setState(() {
              _notifications = notifications;
            });
          },
        ),
      ),
    );

    Overlay.of(context).insert(_popupEntry!);
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UserData>().userID;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (MediaQuery.of(context).size.width < 800)
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black87),
                    onPressed: () =>
                        widget.scaffoldKey.currentState?.openDrawer(),
                  ),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      key: _notifIconKey,
                      icon: const Icon(Icons.notifications, color: Colors.black87, size: 28),
                      onPressed: () => _toggleNotificationPopup(context, userId),
                    ),
                    if (!_isLoading && unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Center(
                            child: Text(
                              unreadCount > 9 ? '9+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/bini.jpg'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
