// lib/screens/search/search_borrow_screen.dart
import 'package:book_ease/data/search_barrow_data.dart';
import 'package:flutter/material.dart';
import 'search_screen_base.dart';

class SearchBorrowScreen extends StatelessWidget {
  const SearchBorrowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchScreenBase(
      database: borrowDatabase,
      history: borrowSearchHistory,
      title: 'Search Borrowed Books',
    );
  }
}
