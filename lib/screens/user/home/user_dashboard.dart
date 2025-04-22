import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:book_ease/widgets/bottomusernav_widget.dart';
import 'package:book_ease/screens/user/library/library_main.dart';
import 'package:book_ease/screens/user/my_books/mybooks_main.dart';
import 'package:book_ease/screens/user/account/account_main.dart';
import 'package:book_ease/widgets/topusernav_widget.dart';
import 'package:book_ease/widgets/notification_widget.dart';
import 'package:book_ease/data/userdashbook_data.dart';
import 'package:book_ease/data/notification_data.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/book_provider.dart'; 
import 'package:book_ease/provider/user_data.dart';
import 'package:book_ease/screens/user/home/book_details_modal.dart';


void main() {
  runApp(const UserDashApp());
}

class UserDashApp extends StatefulWidget {
  const UserDashApp({super.key});

  @override
  _UserDashAppState createState() => _UserDashAppState();
}

// ===================== Bottom Navigation =====================
class _UserDashAppState extends State<UserDashApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const LibraryScreen(),
    const MyBooksScreen(),
    const AccountScreen(),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBarWidget(
          selectedIndex: _selectedIndex,
          onTabChange: _onTabChange,
        ),
      ),
    );
  }
}

// ===================== Home Screen =====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showNotifications = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleNotificationOverlay() {
    setState(() {
      _showNotifications = !_showNotifications;
    });
  }

@override
void initState() {
  super.initState();
  Future.microtask(() {
    final userId = Provider.of<UserData>(context, listen: false).userID;
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    if (userId != null) {
      bookProvider.fetchBorrowedBooks(userId);
    }
  });
}

  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarWidget(
            onNotificationPressed: _toggleNotificationOverlay,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Explore Library Books'),
                _buildBanner(),
                const SizedBox(height: 25),
                _buildCategoryIcons(),
                const SizedBox(height: 10),
                _buildBookSection(context, 'Recommendations'),
                _buildBookSection(context, 'Trending Books'),
                _buildBookSection(context, 'Borrowed Books'),
              ],
            ),
          ),
        ),

        // Notification Overlay
        if (_showNotifications)
          NotificationOverlay(
            onClose: _toggleNotificationOverlay,
            notifications: dummyNotifications,
          ),
      ],
    );
  }

  // ===================== UI Components =====================
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/banner.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCategoryIcons() {
    final List<Map<String, dynamic>> categories = [
      {"icon": Icons.computer_rounded, "label": "Technology"},
      {"icon": Icons.calculate, "label": "Mathematics"},
      {"icon": Icons.psychology, "label": "Psychology"},
      {"icon": Icons.balance, "label": "Physics"},
      {"icon": Icons.science, "label": "Chemistry"},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map((cat) => _buildCategoryIcon(
                cat["icon"] as IconData, cat["label"] as String))
            .toList(),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.teal),
          FittedBox(
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookSection(BuildContext context, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, category),
        _buildBookList(category),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeeAllScreen(category: title),
                ),
              );
            },
            child: Text(
              'See All',
              style: GoogleFonts.poppins(color: Colors.teal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList(String category) {
  final bookProvider = Provider.of<BookProvider>(context);

  if (category == 'Borrowed Books') {
    final borrowedBooks = bookProvider.borrowedBooks;

    if (borrowedBooks.isEmpty) {
      return const Text("No borrowed books.");
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: borrowedBooks.length,
        itemBuilder: (context, index) {
          final book = borrowedBooks[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 113,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                    image: MemoryImage(base64Decode(book.image)), // No split needed
                    fit: BoxFit.cover,
                  ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Due: ${book.dueDate.split('T').first}",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Handle other categories normally
  final books = getBooks(category);
  return SizedBox(
    height: 150,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return _buildBookTile(book["title"]!, book["copies"]!, book["image"]!);
      },
    ),
  );
}


  Widget _buildBookTile(String title, String copies, String imagePath) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 113,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            copies,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ===================== See All Screen =====================

class SeeAllScreen extends StatelessWidget {
  final String category;
  const SeeAllScreen({super.key, required this.category});

  Uint8List decodeBase64Image(String base64String) {
    if (base64String.contains(',')) {
      return base64Decode(base64String.split(',')[1]);
    }
    return base64Decode(base64String);
  }

  @override
  Widget build(BuildContext context) {
    final isBorrowed = category == 'Borrowed Books';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          category,
          style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isBorrowed
          ? _buildBorrowedBooks(context)
          : _buildComingSoonMessage(),
    );
  }

  // ========== Real borrowed books ==========
  Widget _buildBorrowedBooks(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final books = bookProvider.borrowedBooks;

    if (books.isEmpty) {
      return const Center(child: Text('No borrowed books.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            onTap: () {
              showBookDetailModal(context, book);
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                decodeBase64Image(book.image),
                width: 50,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              book.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              style: const TextStyle(color: Colors.redAccent),
              "Due: ${book.dueDate.split('T').first}"
            ),
            
          ),
        );
      },
    );
  }



    // ========== Placeholder for static categories ==========
  Widget _buildComingSoonMessage() {
    return const Center(
      child: Text(
        'Books for this category will be shown soon.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

