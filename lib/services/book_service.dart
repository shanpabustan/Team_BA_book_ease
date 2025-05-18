import 'package:dio/dio.dart';
import '../models/book_borrow_count.dart';
import '../base_url.dart';

class BookService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  static Future<List<BookBorrowCount>> getMostBorrowedBooks({int? month, int? year}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (month != null) queryParams['month'] = month.toString();
      if (year != null) queryParams['year'] = year.toString();

      final response = await _dio.get(
        '/admin/most-borrowed-books',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['retCode'] == '200' && responseData['data'] != null) {
          final booksData = responseData['data']['books'] as List;
          return booksData.map((bookJson) => BookBorrowCount.fromJson(bookJson)).toList();
        }
      }
      throw DioException(
        requestOptions: RequestOptions(path: '/admin/most-borrowed-books'),
        error: 'Failed to fetch most borrowed books: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to fetch most borrowed books: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch most borrowed books: $e');
    }
  }
} 