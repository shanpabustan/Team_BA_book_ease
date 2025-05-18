import 'package:dio/dio.dart';
import 'package:book_ease/models/borrowed_book.dart';
import 'package:book_ease/base_url.dart';

class BorrowedBooksService {
  final Dio _dio = Dio();
  final String baseUrl = '${ApiConfig.baseUrl}/stud/get-books-status';

  Future<List<BorrowedBook>> fetchBorrowedBooksByStatus(String userId, String status) async {
    try {
      print('Making request to: $baseUrl with user_id: $userId and status: $status');
      
      // If status is "All", we'll fetch books for each status and combine them
      if (status == "All") {
        final List<String> allStatuses = ["Pending", "Canceled", "Returned", "Unreturned", "Overdue"];
        List<BorrowedBook> allBooks = [];
        
        for (String status in allStatuses) {
          try {
            final response = await _dio.get(
              baseUrl,
              queryParameters: {
                'user_id': userId,
                'status': status,
              },
            );

            if (response.statusCode == 200 && response.data['retCode'] == '200' && response.data['data'] != null) {
              final List<dynamic> data = response.data['data'] as List;
              final books = data.map((json) => BorrowedBook.fromJson(json)).toList();
              allBooks.addAll(books);
            }
          } catch (e) {
            print('Error fetching books for status $status: $e');
            // Continue with other statuses even if one fails
            continue;
          }
        }
        
        return allBooks;
      }
      
      // For specific status
      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'user_id': userId,
          'status': status,
        },
      );

      print('Response received: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data['retCode'] == '200') {
          if (response.data['data'] == null) {
            print('No books found for the given criteria');
            return [];
          }
          
          final List<dynamic> data = response.data['data'] as List;
          print('Parsed data: $data');
          
          return data.map((json) {
            try {
              return BorrowedBook.fromJson(json);
            } catch (e) {
              print('Error parsing book: $e');
              print('Problematic JSON: $json');
              rethrow;
            }
          }).toList();
        } else {
          throw Exception(response.data['message'] ?? 'Failed to fetch borrowed books');
        }
      } else {
        throw Exception('Failed to fetch borrowed books: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioError details: ${e.response?.data}');
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      print('Error in fetchBorrowedBooksByStatus: $e');
      throw Exception('Error fetching borrowed books: $e');
    }
  }
} 