import 'package:book_ease/base_url.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/dashboard/notification_page.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

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
  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<UserData>().userID;
      if (userId.isNotEmpty) {
        fetchUnreadNotifications(userId);
      }
    });
  }

  Future<void> fetchUnreadNotifications(String userId) async {
    try {
      final response = await Dio().get(
        '${ApiConfig.baseUrl}/notifications/unread',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        final count = response.data['unreadCount'] ?? 0;
        setState(() {
          unreadCount = count;
        });
        print("Unread count updated: $unreadCount");
      } else {
        print('Error loading unread count: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load unread notifications: $e');
    }
  }

  void _toggleNotificationPopup(BuildContext context, String userId) {
    if (_popupEntry != null) {
      _popupEntry!.remove();
      _popupEntry = null;
      print('Popup removed');
      return;
    }

    final RenderBox renderBox =
        _notifIconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    _popupEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + 40,
        left: position.dx - 280,
        child: NotificationPopup(userId: userId),
      ),
    );

    Overlay.of(context).insert(_popupEntry!);
    print('Popup inserted');
  }

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
                  children: [
                    IconButton(
                      key: _notifIconKey,
                      icon: const Icon(Icons.notifications, color: Colors.black87),
                      onPressed: () => _toggleNotificationPopup(context, userId),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
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
                  ],
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/lebron.png'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
