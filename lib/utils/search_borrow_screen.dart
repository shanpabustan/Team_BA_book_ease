// lib/screens/search/search_borrow_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:book_ease/services/borrowed_books_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

class SearchBorrowScreen extends StatefulWidget {
  const SearchBorrowScreen({super.key});

  @override
  State<SearchBorrowScreen> createState() => _SearchBorrowScreenState();
}

class _SearchBorrowScreenState extends State<SearchBorrowScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BorrowedBooksService _borrowedBooksService = BorrowedBooksService();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  String? _error;

  void _onSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
    });

    try {
      final userData = Provider.of<UserData>(context, listen: false);
      final String userId = userData.userID;

      if (userId.isEmpty) {
        throw Exception('User not logged in');
      }

      // Fetch all borrowed books
      final books =
          await _borrowedBooksService.fetchBorrowedBooksByStatus(userId, "All");

      // Filter books based on search query
      final results = books.where((book) {
        final title = book.title.toLowerCase();
        final searchQuery = query.toLowerCase();

        return title.contains(searchQuery);
      }).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to search books. Please try again.';
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AdminColor.secondaryBackgroundColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              constraints: const BoxConstraints(),
            ),
            Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                )
              : _searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isEmpty
                                ? 'Start typing to search your borrowed books...'
                                : 'No books found for "${_searchController.text}"',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: _searchResults.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 30, thickness: 1),
                      itemBuilder: (context, index) {
                        final book = _searchResults[index];
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
                    ),
    );
  }

  Widget _buildBookImage(dynamic book) {
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

  Widget _buildBookDetails(dynamic book) {
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
