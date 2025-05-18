import 'dart:convert';
import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final dynamic book;
  static const double bookWidth = 120.0;  // Fixed width for book
  static const double bookAspectRatio = 0.7;  // Standard book aspect ratio (width:height)

  const BookItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: bookWidth,
      child: AspectRatio(
        aspectRatio: bookAspectRatio,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(book.image.split(',').last),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.book, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}




