import 'package:book_ease/screens/user/user_components/banner_widget.dart';
import 'package:book_ease/screens/user/user_components/home_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:book_ease/widgets/topusernav_widget.dart';
import 'package:book_ease/widgets/notification_widget.dart';
import 'package:book_ease/provider/book_provider.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:book_ease/provider/notification_service.dart';
import 'package:book_ease/data/userdashbook_data.dart';
import 'package:book_ease/data/notification_data.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onReserveTap;

  const HomeScreen({
    super.key,
    required this.onReserveTap,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      final userId = Provider.of<UserData>(context, listen: false).userID;
      final bookProvider = Provider.of<BookProvider>(context, listen: false);

      if (userId != null) {
        bookProvider.fetchBorrowedBooks(userId);
        bookProvider.fetchRecommendedBooks(userId);
        bookProvider.fetchPopularBooks();
      } else {
        print('⚠️ userID is null in didChangeDependencies!');
      }

      _fetchNotifications(); // Safe here too

      _hasInitialized = true;
    }
  }

  @override
  void dispose() {
    _selectedCategory.dispose(); // Dispose the ValueNotifier here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserData>(context).userID;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWidget(
            onNotificationPressed: _toggleNotificationOverlay,
            unreadCount: _notifications.where((n) => !n.isRead).length,
            userId: userId,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIComponents.sectionTitle('Explore New Books'),
                BannerWidget(onReserveTap: widget.onReserveTap),
                const SizedBox(height: 25),
                const SizedBox(height: 10),
                Consumer<BookProvider>(
                  builder: (context, bookProvider, child) {
                    return Column(
                      children: [
                        UIComponents.bookSection(
                          context,
                          'Recommendations',
                          (category) => bookProvider.recommendedBooks
                              .map((book) => {
                                    'title': book.title,
                                    'copies': '${book.copies} copies available',
                                    'image': book.image,
                                    'reserveCount': book.reserveCount.toString(),
                                  })
                              .toList(),
                          userId: userId,
                        ),
                        UIComponents.bookSection(
                          context,
                          'Most Popular',
                          (category) => bookProvider.popularBooks
                              .map((book) => {
                                    'title': book.title,
                                    'copies': '${book.copies} copies available',
                                    'image': book.image,
                                    'reserveCount': book.reserveCount.toString(),
                                  })
                              .toList(),
                          userId: userId,
                        ),
                        UIComponents.bookSection(
                          context, 
                          'Borrowed Books', 
                          getBooks,
                          userId: userId,
                        ),
                      ],
                    );
                  },
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
