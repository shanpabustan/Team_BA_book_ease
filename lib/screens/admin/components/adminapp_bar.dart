import 'package:book_ease/provider/notification_provider.dart';
import 'package:book_ease/screens/admin/dashboard/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;

  const AppBarWidget({
    required this.scaffoldKey,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 20); // includes top padding

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  final GlobalKey _notifIconKey = GlobalKey();
  OverlayEntry? _popupEntry;

  void _toggleNotificationPopup(BuildContext context) {
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
        child: const NotificationPopup(),
      ),
    );

    Overlay.of(context).insert(_popupEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = context.watch<NotificationProvider>().unreadCount;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Section
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

                // Right Section
                Row(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          key: _notifIconKey,
                          icon: const Icon(Icons.notifications,
                              color: Colors.black87),
                          onPressed: () => _toggleNotificationPopup(context),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 6,
                              child: Text(
                                unreadCount.toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
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
        ),
      ),
    );
  }
}
