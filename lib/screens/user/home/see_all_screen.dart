import 'package:book_ease/screens/user/home/book_details_modal.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/provider/book_provider.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'dart:convert';

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
      body:
          isBorrowed ? _buildBorrowedBooks(context) : _buildComingSoonMessage(),
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
                "Due: ${book.dueDate.split('T').first}"),
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
