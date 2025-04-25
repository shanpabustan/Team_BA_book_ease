import 'package:book_ease/base_url.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'book_data.dart'; // Book and BorrowedBook models



class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<BorrowedBook> _borrowedBooks = [];

  bool _isLoading = false;

  List<Book> get books => _books;
  List<BorrowedBook> get borrowedBooks => _borrowedBooks;

  bool get isLoading => _isLoading;

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Dio().get('${ApiConfig.baseUrl}/get-all');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _books = data.map((json) => Book.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching books: $e');
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
        _borrowedBooks = data.map((json) => BorrowedBook.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching borrowed books: $e');
    }
  }



}