import 'package:dio/dio.dart';
import 'package:book_ease/models/borrowed_book.dart';
import 'package:book_ease/base_url.dart';

class BorrowedBooksService {
  final Dio _dio = Dio();
  final String baseUrl = '${ApiConfig.baseUrl}/stud/get-books-status';

  Future<List<BorrowedBook>> fetchBorrowedBooksByStatus(String userId, String status) async {
    try {
      print('Making request to: $baseUrl');
      print('Query parameters: user_id: $userId, status: $status');
      
      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'user_id': userId,
          'status': status,
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data['retCode'] == '200') {
          if (response.data['data'] == null) {
            print('No books found for the given criteria');
            return [];
          }
          
          final List<dynamic> data = response.data['data'] as List;
          print('Number of books found: ${data.length}');
          print('First book data: ${data.isNotEmpty ? data.first : "No books"}');
          
          final books = data.map((json) {
            try {
              final book = BorrowedBook.fromJson(json);
              print('Successfully parsed book: ${book.title} (Status: ${book.status}, Source: ${book.source})');
              return book;
            } catch (e) {
              print('Error parsing book: $e');
              print('Problematic JSON: $json');
              rethrow;
            }
          }).toList();

          print('Total books parsed successfully: ${books.length}');
          return books;
        } else {
          print('API returned error: ${response.data['message']}');
          throw Exception(response.data['message'] ?? 'Failed to fetch borrowed books');
        }
      } else {
        print('API request failed with status code: ${response.statusCode}');
        throw Exception('Failed to fetch borrowed books: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioError details: ${e.response?.data}');
      print('DioError message: ${e.message}');
      print('DioError type: ${e.type}');
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      print('Error in fetchBorrowedBooksByStatus: $e');
      throw Exception('Error fetching borrowed books: $e');
    }
  }

}