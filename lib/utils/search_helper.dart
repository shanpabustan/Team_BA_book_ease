// lib/helpers/search_helper.dart
import 'package:flutter/material.dart';

class SearchHelper {
  static List<Map<String, String>> filterData(
    String query,
    List<Map<String, String>> database,
  ) {
    return database
        .where((item) =>
            item['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static void updateSearchHistory({
    required String title,
    required String thumbnail,
    required List<Map<String, String>> history,
  }) {
    final existingIndex = history.indexWhere((item) => item['title'] == title);
    if (existingIndex == -1) {
      history.insert(0, {'title': title, 'thumbnail': thumbnail});
      if (history.length > 10) history.removeLast();
    }
  }

  static void clearHistory(List<Map<String, String>> history) {
    history.clear();
  }
}
