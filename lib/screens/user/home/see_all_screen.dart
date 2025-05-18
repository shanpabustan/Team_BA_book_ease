import 'package:book_ease/screens/user/app_text_styles.dart';
import 'package:book_ease/screens/user/home/book_details_modal.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/provider/book_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:book_ease/screens/admin/admin_theme.dart';

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
      backgroundColor: const Color(0xFFF2FAF9),
      appBar: AppBar(
        backgroundColor: AdminColor.secondaryBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          category,
          style: AppTextStyles.appBarTitle.copyWith(
            color: Colors.white, // Add color override if needed
          ),
        ),
      ),
      body:
          isBorrowed ? _buildBorrowedBooks(context) : _buildComingSoonMessage(),
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
              // Book Image
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

              // Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Arrow Icon Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            book.title,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

                    // Due Date + View Button
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
                          onPressed: () => showBookDetailModal(context, book),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF9AD3BC)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
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
        'Books for this category will be shown soon.',
        style: TextStyle(fontSize: 15, color: Colors.grey),
      ),
    );
  }
}
