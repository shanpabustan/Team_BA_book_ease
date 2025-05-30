import 'package:book_ease/provider/book_data.dart';
import 'package:book_ease/screens/user/app_text_styles.dart';
import 'package:book_ease/screens/user/user_components/book_detail_modal.dart';
import 'package:book_ease/screens/user/user_components/home_components.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/provider/book_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';
import 'package:book_ease/screens/admin/admin_theme.dart';

class SeeAllScreen extends StatelessWidget {
  final String category;
  final String? userId; // Added nullable userId to be passed optionally

  const SeeAllScreen({
    super.key,
    required this.category,
    this.userId, // Optional, only needed for Recommendations
  });

  Uint8List decodeBase64Image(String base64String) {
    try {
      if (base64String.isEmpty) {
        throw Exception('Empty image string');
      }

      if (base64String.contains('base64,')) {
        return base64Decode(base64String.split('base64,').last);
      }

      return base64Decode(base64String);
    } catch (e) {
      // Return empty Uint8List on error to avoid crash
      return Uint8List.fromList([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBorrowed = category == 'Borrowed Books';
    final isRecommended = category == 'Recommendations';
    final isPopular = category == 'Most Popular';

    return Scaffold(
      backgroundColor: const Color(0xFFF2FAF9),
      appBar: AppBar(
        backgroundColor: AdminColor.secondaryBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          category,
          style: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
        ),
      ),
      body: isBorrowed
          ? _buildBorrowedBooks(context)
          : isRecommended
              ? _buildRecommendedBooks(context)
              : isPopular
                  ? _buildPopularBooks(context)
                  : _buildComingSoonMessage(),
    );
  }

  Widget _buildBorrowedBooks(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final books = bookProvider.borrowedBooks;

    if (books.isEmpty) {
      return const Center(
        child: Text(
          'No borrowed books.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  decodeBase64Image(book.image),
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Author: ${book.author}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Due: ${book.dueDate.split('T').first}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            showBookDetailsModal(
                              context: context,
                              book: book,
                              userId: userId ?? '',
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "View Details",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF2B4B50),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecommendedBooks(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final books = bookProvider.recommendedBooks;

    if (books.isEmpty) {
      return const Center(
        child: Text(
          'No recommended books available.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  decodeBase64Image(book.image),
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 90,
                      color: Colors.grey[200],
                      child: const Icon(Icons.book, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Author: ${book.author}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "${book.copies} copies available",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            final bookMap = {
                              'book_id': book.bookId,
                              'title': book.title,
                              'author': book.author,
                              'total_copies': book.copies,
                              'year_published': book.year,
                              'description': book.description,
                              'picture': book.image,
                              'isbn': book.isbn,
                              'shelf_location': book.shelfLocation,
                              'library_section': book.librarySection,
                              'category': book.category,
                              //'reserveCount': book.reserveCount,
                            };

                            final bookObj = Book.fromJson(bookMap);

                            showBookDetailsModal(
                              context: context,
                               book: book,
                              userId: userId ?? '',
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "View Details",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF2B4B50),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularBooks(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final books = bookProvider.popularBooks;

    if (books.isEmpty) {
      return const Center(
        child: Text(
          'No popular books available.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  decodeBase64Image(book.image),
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 90,
                      color: Colors.grey[200],
                      child: const Icon(Icons.book, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Author: ${book.author}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "${book.copies} copies available",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            final bookMap = {
                              'book_id': book.bookId,
                              'title': book.title,
                              'author': book.author,
                              'total_copies': book.copies,
                              'year_published': book.year,
                              'description': book.description,
                              'picture': book.image,
                              'isbn': book.isbn,
                              'shelf_location': book.shelfLocation,
                              'library_section': book.librarySection,
                              'category': book.category,
                              //'reserveCount': book.reserveCount ?? 0,
                            };

                            final bookObj = Book.fromJson(bookMap);

                            showBookDetailsModal(
                              context: context,
                               book: book,
                              userId: userId ?? '',
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "View Details",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF2B4B50),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComingSoonMessage() {
    return const Center(
      child: Text(
        "Coming soon...",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }
}
