import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_ease/provider/book_data.dart';

class FavoriteBooksService {
  static String _getFavoritesKey(String userId) => 'favorite_books_$userId';

  // Get all favorite books for a specific user
  static Future<List<Map<String, dynamic>>> getFavoriteBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('current_user_id');
    
    if (userId == null) {
      return [];
    }

    final String? favoritesJson = prefs.getString(_getFavoritesKey(userId));
    
    if (favoritesJson == null) {
      return [];
    }

    try {
      final List<dynamic> decodedList = jsonDecode(favoritesJson);
      return decodedList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error decoding favorites: $e');
      return [];
    }
  }

  // Add a book to favorites for a specific user
  static Future<bool> addToFavorites(Map<String, dynamic> book) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('current_user_id');
      
      if (userId == null) {
        return false;
      }

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
        'book_id': book['book_id'] ?? 0,
        'title': book['title'] ?? '',
        'author': book['author'] ?? '',
        'year': book['year'] ?? '',
        'isbn': book['isbn'] ?? "Unknown",
        'shelfLocation': book['shelfLocation'] ?? "Unknown",
        'librarySection': book['librarySection'] ?? "Unknown",
        'copies': book['copies'] ?? 0,
        'description': book['description'] ?? '',
        'image': imageData,
        'reserveCount': book['reserveCount'] ?? 0,
        'category': book['category'] ?? '',
        'dateAdded': DateTime.now().toIso8601String(),
      };
      
      currentFavorites.add(formattedBook);
      await prefs.setString(_getFavoritesKey(userId), jsonEncode(currentFavorites));
      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  // Remove a book from favorites for a specific user
  static Future<bool> removeFromFavorites(String isbn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('current_user_id');
      
      if (userId == null) {
        return false;
      }

      final List<Map<String, dynamic>> currentFavorites = await getFavoriteBooks();
      
      currentFavorites.removeWhere((book) => book['isbn'] == isbn);
      await prefs.setString(_getFavoritesKey(userId), jsonEncode(currentFavorites));
      return true;
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  // Check if a book is favorited by a specific user
  static Future<bool> isBookFavorited(String isbn) async {
    final List<Map<String, dynamic>> favorites = await getFavoriteBooks();
    return favorites.any((book) => book['isbn'] == isbn);
  }

  // Clear all favorites for a specific user
  static Future<void> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('current_user_id');
      
      if (userId != null) {
        await prefs.remove(_getFavoritesKey(userId));
      }
    } catch (e) {
      print('Error clearing favorites: $e');
    }
  }

  // Get all favorite books for a specific user ID (used for data migration/backup)
  static Future<List<Map<String, dynamic>>> getFavoriteBooksForUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_getFavoritesKey(userId));
    
    if (favoritesJson == null) {
      return [];
    }

    try {
      final List<dynamic> decodedList = jsonDecode(favoritesJson);
      return decodedList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error decoding favorites for user $userId: $e');
      return [];
    }
  }
} 