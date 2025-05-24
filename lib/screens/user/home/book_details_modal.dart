import 'package:flutter/material.dart';
import 'package:book_ease/screens/user/user_components/book_detail_helper.dart';

class BookDetailScreen extends StatelessWidget {
  final dynamic book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: BookDetailContent(
          book: book,
          showReserveButton: false,
          showFavoriteButton: false,
          onReserve: null,
          onFavoriteToggle: null,
        ),
      ),
    );
  }
}
