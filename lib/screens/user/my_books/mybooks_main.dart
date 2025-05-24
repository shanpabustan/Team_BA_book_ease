import 'dart:async';
import 'package:book_ease/main.dart';
import 'package:book_ease/screens/user/app_text_styles.dart';
//import 'package:book_ease/modals/cancel_borrow_modal.dart';
import 'package:book_ease/utils/navigator_helper.dart';
import 'package:book_ease/utils/search_borrow_screen.dart';
import 'package:book_ease/widgets/svg_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/models/borrowed_book.dart';
import 'package:book_ease/services/borrowed_books_service.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/user_data.dart' hide BorrowedBook;
import 'package:connectivity_plus/connectivity_plus.dart';

class MyBooksScreen extends StatefulWidget {
  const MyBooksScreen({super.key});

  @override
  State<MyBooksScreen> createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  final BorrowedBooksService _borrowedBooksService = BorrowedBooksService();
  List<BorrowedBook> borrowedBooks = [];
  bool isLoading = false;
  String? error;

  final List<String> categories = [
    "All",
    "To Return",
    "To Pick Up",
    "Returned",
    "Picked Up",
    "Overdue"
  ];

  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchBorrowedBooks();
  }

  Future<void> _fetchBorrowedBooks() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final userData = Provider.of<UserData>(context, listen: false);
      final String userId = userData.userID;

      if (userId.isEmpty) {
        throw Exception('User not logged in');
      }

      final String status = categories[selectedCategoryIndex] == "All"
          ? "All"
          : categories[selectedCategoryIndex];

      print('Fetching books for user: $userId with status: $status');
      final books = await _borrowedBooksService.fetchBorrowedBooksByStatus(
          userId, status);

      setState(() {
        borrowedBooks = books;
        isLoading = false;
      });
    } catch (e) {
      print('Error in _fetchBorrowedBooks: $e');
      setState(() {
        error = 'Failed to load books. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(
            child: isLoading
                ? const SvgLoadingScreen()
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      )
                    : borrowedBooks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.book_outlined,
                                    size: 48, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  "No books found for ${categories[selectedCategoryIndex]} status",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _buildBookList(),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(55),
      child: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "My Books",
          style: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 20),
                onPressed: () => fadePush(context, const SearchBorrowScreen()),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = selectedCategoryIndex == index;
          return TextButton(
            style: TextButton.styleFrom(
              backgroundColor: isSelected ? secondaryColor : Colors.grey[200],
              foregroundColor: isSelected ? Colors.white : Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedCategoryIndex = index;
              });
              _fetchBorrowedBooks();
            },
            child: Text(categories[index],
                style: GoogleFonts.poppins(fontSize: 12)),
          );
        },
      ),
    );
  }

  Widget _buildBookList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: borrowedBooks.length,
      separatorBuilder: (_, __) => const Divider(height: 30, thickness: 1),
      itemBuilder: (context, index) {
        final book = borrowedBooks[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookImage(book),
            const SizedBox(width: 12),
            _buildBookDetails(book),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  book.status,
                  style: TextStyle(
                    color: _getStatusColor(book.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBookImage(BorrowedBook book) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        _cleanImageUrl(book.picture).isNotEmpty
            ? _cleanImageUrl(book.picture)
            : 'https://via.placeholder.com/60x90?text=No+Image',
        width: 60,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 60,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book_outlined, color: Colors.grey[400], size: 24),
                const SizedBox(height: 4),
                Text('No Image',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookDetails(BorrowedBook book) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(book.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text.rich(TextSpan(children: [
            const TextSpan(text: "Borrow Date: "),
            TextSpan(
              text: book.borrowDate.toString().split(' ')[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ])),
          Text.rich(TextSpan(children: [
            const TextSpan(text: "Due Date: "),
            TextSpan(
              text: book.dueDate.toString().split(' ')[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ])),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Returned":
        return Colors.teal;
      case "To Return":
        return Colors.blue;
      case "Overdue":
        return Colors.red;
      case "To Pick Up":
        return Colors.orange;
      case "Cancelled":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  String _cleanImageUrl(String url) {
    if (url.startsWith('data:image')) {
      const prefixPattern = 'data:image/jpeg;base64,';
      final lastIndex = url.lastIndexOf(prefixPattern);
      if (lastIndex != -1) {
        return url.substring(lastIndex);
      }
    }
    return url;
  }
}
