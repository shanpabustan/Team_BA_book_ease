import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:book_ease/base_url.dart';

class CategoryStats {
  final String category;
  final int borrowCount;
  final List<BookDetail> books;

  CategoryStats({
    required this.category,
    required this.borrowCount,
    required this.books,
  });

  factory CategoryStats.fromJson(Map<String, dynamic> json) {
    return CategoryStats(
      category: json['category'],
      borrowCount: json['borrow_count'],
      books: (json['books'] as List)
          .map((book) => BookDetail.fromJson(book))
          .toList(),
    );
  }
}

class BookDetail {
  final int bookId;
  final String title;
  final String picture;
  final int borrowCount;

  BookDetail({
    required this.bookId,
    required this.title,
    required this.picture,
    required this.borrowCount,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    return BookDetail(
      bookId: json['book_id'],
      title: json['title'],
      picture: json['picture'],
      borrowCount: json['borrow_count'],
    );
  }
}

class AnalyticsService {
  Future<List<CategoryStats>> getMostBorrowedCategories(String month, String year) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/admin/most-borrowed-categories?month=$month&year=$year'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> categoriesData = responseData['data']['categories'];
        
        return categoriesData
            .map((category) => CategoryStats.fromJson(category))
            .toList();
      } else {
        throw Exception('Failed to load category statistics');
      }
    } catch (e) {
      throw Exception('Error fetching category statistics: $e');
    }
  }
} 