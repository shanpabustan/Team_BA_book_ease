import 'package:dio/dio.dart';
import 'package:book_ease/data/notification_data.dart'; // Import your Notification model
import 'package:book_ease/base_url.dart';

class NotificationService {
  final Dio _dio = Dio(); // The Dio instance to make HTTP requests

  // Fetch notifications for a user by their userId
  Future<List<AppNotification>> fetchNotifications(String userId) async {
    try {
      final response = await _dio.get('${ApiConfig.baseUrl}/test/fetch-notifs?user_id=$userId');
      
      // Check if the response status is OK
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        
        // Convert JSON response into Notification objects
        return data.map((json) => AppNotification.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }
}
