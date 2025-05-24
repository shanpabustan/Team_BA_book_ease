import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_ease/provider/book_data.dart';

class FavoriteBooksService {
  static const String _favoritesKey = 'favorite_books';

  // Get all favorite books
  static Future<List<Map<String, dynamic>>> getFavoriteBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    
    if (favoritesJson == null) {
      return [];
    }

    final List<dynamic> decodedList = jsonDecode(favoritesJson);
    return decodedList.cast<Map<String, dynamic>>();
  }

  // Add a book to favorites
  static Future<bool> addToFavorites(Map<String, dynamic> book) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> currentFavorites = await getFavoriteBooks();
      
      // Check if book already exists
      if (currentFavorites.any((fav) => fav['isbn'] == book['isbn'])) {
        return false;
      }

      // Ensure image data is properly formatted
      String imageData = book['image'] ?? '';
      if (imageData.isNotEmpty && !imageData.startsWith('data:image')) {
        imageData = 'data:image/jpeg;base64,$imageData';
      }

      // Create a properly formatted book map
      final Map<String, dynamic> formattedBook = {
        'title': book['title'] ?? '',
        'author': book['author'] ?? '',
        'year': book['year'] ?? '',
        'isbn': book['isbn'] ?? '',
        'shelfLocation': book['shelfLocation'] ?? '',
        'librarySection': book['librarySection'] ?? '',
        'copies': book['copies'] ?? 0,
        'description': book['description'] ?? '',
        'image': imageData,
        'reserveCount': book['reserveCount'] ?? 0,
        'category': book['category'] ?? '',
        'dateAdded': DateTime.now().toIso8601String(),
      };
      
      currentFavorites.add(formattedBook);
      await prefs.setString(_favoritesKey, jsonEncode(currentFavorites));
      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  // Remove a book from favorites
  static Future<bool> removeFromFavorites(String isbn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> currentFavorites = await getFavoriteBooks();
      
      currentFavorites.removeWhere((book) => book['isbn'] == isbn);
      await prefs.setString(_favoritesKey, jsonEncode(currentFavorites));
      return true;
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  // Check if a book is favorited
  static Future<bool> isBookFavorited(String isbn) async {
    final List<Map<String, dynamic>> favorites = await getFavoriteBooks();
    return favorites.any((book) => book['isbn'] == isbn);
  }
} 