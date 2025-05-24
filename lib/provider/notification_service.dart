import 'package:dio/dio.dart';
import 'package:book_ease/data/notification_data.dart'; // Import your Notification model
import 'package:book_ease/base_url.dart';

class NotificationService {
  final Dio _dio = Dio(); // The Dio instance to make HTTP requests

  // Fetch notifications for a user by their userId
  Future<List<AppNotification>> fetchNotifications(String userId) async {
    try {
      final response = await _dio.get('${ApiConfig.baseUrl}/test/fetch-notifs?user_id=$userId');
      
      // Debug prints
      print('API Response Status: ${response.statusCode}');
      print('API Response Data: ${response.data}');
      
      // Check if the response status is OK
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print('Parsed Data Length: ${data.length}');
        
        // Convert JSON response into Notification objects
        final notifications = data.map((json) => AppNotification.fromJson(json)).toList();
        print('Created Notifications: ${notifications.map((n) => n.message).toList()}');
        return notifications;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error in fetchNotifications: $e');
      throw Exception('Error fetching notifications: $e');
    }
  }
}
