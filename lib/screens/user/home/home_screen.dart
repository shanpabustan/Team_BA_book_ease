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

  // Static list of categories for home screen
  final List<String> _staticCategories = [
    
    'Fiction',
    'Non-Fiction',
    'Textbooks',
    'Reference Materials',
    'Children\'s Books',
    'Young Adult',
    'Science & Technology',
    'History & Social Studies',
    'Biographies',
    'Comics & Graphic Novels'
  ];

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
    _fetchNotifications();
    Future.microtask(() {
      final userId = Provider.of<UserData>(context, listen: false).userID;
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      if (userId != null) {
        bookProvider.fetchBorrowedBooks(userId);
        bookProvider.fetchRecommendedBooks(userId);
        bookProvider.fetchPopularBooks();
      }
    });
  }

  @override
  void dispose() {
    _selectedCategory.dispose(); // Dispose the ValueNotifier here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWidget(
            onNotificationPressed: _toggleNotificationOverlay,
            unreadCount: _notifications.where((n) => !n.isRead).length,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIComponents.sectionTitle('Explore New Books'),
                BannerWidget(onReserveTap: widget.onReserveTap),
                const SizedBox(height: 25),
                ValueListenableBuilder<String>(
                  valueListenable: _selectedCategory,
                  builder: (context, value, _) {
                    return SizedBox(
                      height: 35,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _staticCategories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = _staticCategories[index];
                          final isSelected = value == category;

                          return TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: isSelected
                                  ? Colors.teal
                                  : Colors.grey[200],
                              foregroundColor:
                                  isSelected ? Colors.white : Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => _selectedCategory.value = category,
                            child: Text(
                              category,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Consumer<BookProvider>(
                  builder: (context, bookProvider, child) {
                    return Column(
                      children: [
                        UIComponents.bookSection(
                          context,
                          'Recommendations',
                          (category) => bookProvider.recommendedBooks.map((book) => {
                                'title': book.title,
                                'copies': '${book.copies} copies available',
                                'image': book.image,
                              }).toList(),
                        ),
                        UIComponents.bookSection(
                          context,
                          'Most Popular',
                          (category) => bookProvider.popularBooks.map((book) => {
                                'title': book.title,
                                'copies': '${book.copies} copies available',
                                'image': book.image,
                              }).toList(),
                        ),
                        
                        UIComponents.bookSection(context, 'Borrowed Books', getBooks),
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
