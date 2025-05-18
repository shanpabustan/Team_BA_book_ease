// lib/screens/search/search_book_screen.dart
import 'package:flutter/material.dart';
import 'package:book_ease/data/search_book_data.dart';
import 'search_screen_base.dart';

class SearchBookScreen extends StatelessWidget {
  const SearchBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchScreenBase(
      database: bookDatabase,
      history: searchHistory,
      title: 'Search Books',
    );
  }
}
