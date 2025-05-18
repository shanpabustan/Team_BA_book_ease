import 'dart:convert';
import 'package:flutter/material.dart';

class BookBorrowCount {
  final int bookId;
  final String title;
  final String picture;
  final int borrowCount;

  BookBorrowCount({
    required this.bookId,
    required this.title,
    required this.picture,
    required this.borrowCount,
  });

  factory BookBorrowCount.fromJson(Map<String, dynamic> json) {
    String rawPicture = json['picture'] ?? '';
    // Clean the base64 string if it contains the data URI prefix
    final cleanedPicture = rawPicture.contains('base64,') 
        ? rawPicture.split('base64,').last 
        : rawPicture;

    return BookBorrowCount(
      bookId: json['book_id'] as int,
      title: json['title'] as String,
      picture: cleanedPicture,
      borrowCount: json['borrow_count'] as int,
    );
  }
}

// Extension to add UI-related functionality
extension BookBorrowCountUI on BookBorrowCount {
  Widget getImageWidget({double? width, double? height}) {
    try {
      return Image.memory(
        base64Decode(picture),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.book,
              color: const Color(0xFF9E9E9E),
              size: (width ?? 24) * 0.5,
            ),
          );
        },
      );
    } catch (e) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.book,
          color: const Color(0xFF9E9E9E),
          size: (width ?? 24) * 0.5,
        ),
      );
    }
  }
} 