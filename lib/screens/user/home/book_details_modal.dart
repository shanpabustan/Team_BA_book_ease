import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final dynamic book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      base64Decode(book.image.split(',').last),
                      height: screenHeight * 0.3,
                      width: screenWidth * 0.35,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            book.title,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 16),
                        _infoRow("Author", book.author, fontSize: 15),
                        _infoRow("Year Published", book.year, fontSize: 15),
                        _infoRow("ISBN", book.isbn, fontSize: 15),
                        _infoRow("Shelf Location", book.shelfLocation,
                            fontSize: 15),
                        _infoRow("Library Section", book.librarySection,
                            fontSize: 15),
                        _infoRow("Available Copies", "${book.copies}",
                            fontSize: 15),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(book.description ?? "No description available."),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _infoRow(String label, String? value, {double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
          Expanded(
            child: Text(
              value ?? "N/A",
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to show the bottom sheet
void showBookDetailModal(BuildContext context, dynamic book) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => BookDetailScreen(book: book),
  );
}
