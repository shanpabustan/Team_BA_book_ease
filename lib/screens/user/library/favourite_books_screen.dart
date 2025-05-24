import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/services/favorite_books_service.dart';
import 'package:book_ease/screens/user/user_components/book_detail_modal.dart';
import 'package:intl/intl.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/provider/book_data.dart';

class FavouriteBooksScreen extends StatefulWidget {
  final String userId;

  const FavouriteBooksScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<FavouriteBooksScreen> createState() => _FavouriteBooksScreenState();
}

class _FavouriteBooksScreenState extends State<FavouriteBooksScreen> {
  List<Map<String, dynamic>> _favoriteBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteBooks();
  }

  Future<void> _loadFavoriteBooks() async {
    setState(() => _isLoading = true);
    try {
      final books = await FavoriteBooksService.getFavoriteBooks();
      setState(() {
        _favoriteBooks = books;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading favorite books: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> removeBook(int index) async {
    final book = _favoriteBooks[index];
    final success = await FavoriteBooksService.removeFromFavorites(book['isbn']);
    if (success) {
      setState(() {
        _favoriteBooks.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book removed from favorites'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to remove book from favorites'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AdminColor.secondaryBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "My Favorites",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteBooks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No favorite books yet',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add books to your favorites to see them here',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _favoriteBooks.length,
                  itemBuilder: (context, index) {
                    final book = _favoriteBooks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Book Cover
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                base64Decode(book['image'].split(',').last),
                                width: 100,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 100,
                                    height: 150,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.book, color: Colors.grey),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Book Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title + Delete Icon Row
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          book['title'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => removeBook(index),
                                        icon: const Icon(Icons.delete_outline),
                                        color: Colors.red.shade700,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    book['author'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Date Added: ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(book['dateAdded']))}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton(
                                    onPressed: () {
                                      // Convert the book map to a Book object
                                      final bookMap = {
                                        'book_id': book['book_id'] ?? 0,
                                        'title': book['title'],
                                        'author': book['author'],
                                        'total_copies': book['copies'],
                                        'year_published': book['year'],
                                        'description': book['description'],
                                        'picture': book['image'],
                                        'isbn': book['isbn'],
                                        'shelf_location': book['shelfLocation'],
                                        'library_section': book['librarySection'],
                                        'category': book['category'],
                                        'reserved_count': book['reserveCount'],
                                      };
                                      
                                      final bookObj = Book.fromJson(bookMap);
                                      
                                      showBookDetailsModal(
                                        context: context,
                                        book: bookObj,
                                        userId: widget.userId,
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Color(0xFF9AD3BC)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: Text(
                                      "View details",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: const Color(0xFF2B4B50),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
