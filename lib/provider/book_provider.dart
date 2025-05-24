import 'package:book_ease/base_url.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'book_data.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<BorrowedBook> _borrowedBooks = [];
  List<Book> _recommendedBooks = [];
  List<Book> _popularBooks = [];

  bool _isLoading = false;

  List<Book> get books => _books;
  List<BorrowedBook> get borrowedBooks => _borrowedBooks;
  List<Book> get recommendedBooks => _recommendedBooks;
  List<Book> get popularBooks => _popularBooks;

  bool get isLoading => _isLoading;

  // Get unique categories from available books
  List<String> get categories {
    final Set<String> uniqueCategories = _books
        .map((book) => book.category.trim())
        .where((category) => category != "Unknown" && category.isNotEmpty)
        .toSet();
    
    // Always include 'All' at the beginning
    return ['All', ...uniqueCategories.toList()..sort()];
  }

  List<Book> getBooksByCategory(String category) {
    print('Getting books for category: $category');
    print('Available categories: ${_books.map((b) => b.category).toSet()}');
    
    if (category == 'All') {
      print('Returning all books: ${_books.length}');
      return _books;
    }
    
    final filtered = _books.where((book) => book.category.trim() == category.trim()).toList();
    print('Filtered books count: ${filtered.length}');
    return filtered;
  }

  Future<void> fetchBooks() async {
    print('Fetching books...');
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Dio().get('${ApiConfig.baseUrl}/get-all');
      print('Books API Response: ${response.data}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _books = data.map((json) => Book.fromJson(json)).toList();
        print('Fetched ${_books.length} books');
        print('Categories found: ${categories}');
      }
    } catch (e) {
      print('Error fetching books: $e');
      _books = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBorrowedBooks(String userId) async {
    try {
      final response = await Dio().get(
        '${ApiConfig.baseUrl}/stud/get-borrowed',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _borrowedBooks = [];

        if (data.isNotEmpty) {
          _borrowedBooks =
              data.map((json) => BorrowedBook.fromJson(json)).toList();
        }

        notifyListeners();
      }
    } catch (e) {
      print('Error fetching borrowed books: $e');
      _borrowedBooks = [];
      notifyListeners();
    }
  }

  Future<void> fetchRecommendedBooks(String userId) async {
    try {
      final response = await Dio().get(
        '${ApiConfig.baseUrl}/stud/get-recommended',
        queryParameters: {'user_id': userId},
      );

      print('\n=== Recommended Books API Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Data Type: ${response.data.runtimeType}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        // Check if response has the expected structure
        if (responseData is Map<String, dynamic>) {
          // Handle both 'Data' and 'data' keys
          final data = responseData['Data'] ?? responseData['data'];
          print('Recommended books data: $data');
          
          if (data == null) {
            print('No recommended books data received');
            _recommendedBooks = [];
          } else if (data is List) {
            _recommendedBooks = data.map((json) {
              try {
                print('Processing recommended book: $json');
                // Ensure picture field exists and is not null
                if (json['picture'] == null) {
                  print('Picture is null for book: ${json['title']}');
                  json['picture'] = ''; // Set empty string as default
                }
                return Book.fromJson(json);
              } catch (e) {
                print('Error parsing recommended book: $e');
                print('Problematic book data: $json');
                return null;
              }
            }).whereType<Book>().toList(); // Filter out null values
            print('Successfully parsed ${_recommendedBooks.length} recommended books');
          } else {
            print('Unexpected data format: $data');
            _recommendedBooks = [];
          }
        } else {
          print('Invalid response format: $responseData');
          _recommendedBooks = [];
        }
      } else {
        print('Error status code: ${response.statusCode}');
        _recommendedBooks = [];
      }
    } catch (e) {
      print('Error fetching recommended books: $e');
      _recommendedBooks = [];
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchPopularBooks({int limit = 5}) async {
    try {
      print('Fetching most popular books with limit: $limit');
      final response = await Dio().get(
        '${ApiConfig.baseUrl}/stud/popular-books',
        queryParameters: {
          'limit': limit.toString(),
        },
      );

      print('Popular books API response: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Check if response has the expected structure
        if (responseData is Map<String, dynamic>) {
          final data = responseData['Data'] ?? responseData['data'];
          print('Popular books data: $data');

          if (data is List) {
            _popularBooks = data.map((json) {
              try {
                print('Processing popular book: $json');
                // Ensure picture field exists and is not null
                if (json['picture'] == null) {
                  print('Picture is null for book: ${json['title']}');
                  json['picture'] = ''; // Set empty string as default
                }
                return Book.fromJson(json);
              } catch (e) {
                print('Error parsing popular book: $e');
                print('Problematic book data: $json');
                return null;
              }
            }).whereType<Book>().toList(); // Filter out null values
            print('Successfully parsed ${_popularBooks.length} popular books');
          } else {
            print('Unexpected data format: $data');
            _popularBooks = [];
          }
        } else {
          print('Invalid response format: $responseData');
          _popularBooks = [];
        }
      } else {
        print('Error status code: ${response.statusCode}');
        _popularBooks = [];
      }
    } catch (e) {
      print('Error fetching popular books: $e');
      _popularBooks = [];
    } finally {
      notifyListeners();
    }
  }

  void clearBooks() {
    _books = [];
    _borrowedBooks = [];
    _recommendedBooks = [];
    _popularBooks = [];
    notifyListeners();
  }
}
