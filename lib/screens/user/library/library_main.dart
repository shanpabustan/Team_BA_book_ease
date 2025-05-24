import 'package:book_ease/screens/user/library/book_grid.dart';
import 'package:book_ease/widgets/topusernav_widget.dart';
import 'package:book_ease/widgets/notification_widget.dart';
import 'package:book_ease/provider/book_provider.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:book_ease/provider/notification_service.dart';
import 'package:book_ease/data/notification_data.dart';
import 'package:book_ease/screens/user/user_components/home_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool _showNotifications = false;
  bool _isFetchingNotifs = true;
  List<AppNotification> _notifications = [];
  final ValueNotifier<String> _selectedCategory = ValueNotifier<String>('All');

  void _toggleNotificationOverlay() {
    setState(() {
      _showNotifications = !_showNotifications;
    });
  }

  void _fetchNotifications() async {
    try {
      final userId = Provider.of<UserData>(context, listen: false).userID;
      final service = NotificationService();
      final notifs = await service.fetchNotifications(userId);

      setState(() {
        _notifications = notifs;
        _isFetchingNotifs = false;
      });
    } catch (e) {
      print('Notification fetch error: $e');
      setState(() {
        _isFetchingNotifs = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotifications();
      Provider.of<BookProvider>(context, listen: false).fetchBooks();
    });

    // Add listener to debug category changes
    _selectedCategory.addListener(() {
      print('Selected category changed to: ${_selectedCategory.value}');
    });
  }

  @override
  void dispose() {
    _selectedCategory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserData>(context).userID;
    final bookProvider = Provider.of<BookProvider>(context);

    // Debug print for books
    print('Total books in provider: ${bookProvider.books.length}');
    print(
        'Books categories: ${bookProvider.books.map((b) => b.category).toSet()}');

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWidget(
            onNotificationPressed: _toggleNotificationOverlay,
            unreadCount: _notifications.where((n) => !n.isRead).length,
            userId: userId,
          ),
          body: Container(
            color: Colors.white,
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _FixedHeaderDelegate(
                    height: 60,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10,
                      ),
                      child: ValueListenableBuilder<String>(
                        valueListenable: _selectedCategory,
                        builder: (context, category, child) {
                          return UIComponents.selectCategory(_selectedCategory);
                        },
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10,
                    ),
                    child: UIComponents.sectionTitle('Explore Library Books'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ValueListenableBuilder<String>(
                      valueListenable: _selectedCategory,
                      builder: (context, category, child) {
                        final filteredBooks =
                            bookProvider.getBooksByCategory(category);
                        print(
                            'Filtered books for $category: ${filteredBooks.length}');
                        return BookGrid(
                          userId: userId,
                          selectedCategory: category,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_showNotifications)
          NotificationOverlay(
            onClose: _toggleNotificationOverlay,
            notifications: _isFetchingNotifs ? [] : _notifications,
          ),
      ],
    );
  }
}

class _FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _FixedHeaderDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: height, child: child);
  }

  @override
  bool shouldRebuild(_FixedHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
