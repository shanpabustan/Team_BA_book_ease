import 'package:dio/dio.dart';
import 'package:book_ease/base_url.dart';

class PasswordResetService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    contentType: 'application/json',
  ));

  static Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post(
        '/request-password-reset',
        data: {'email': email},
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!.data;
      }
      return {
        'retCode': '500',
        'message': 'Failed to connect to server',
        'data': e.message
      };
    } catch (e) {
      return {
        'retCode': '500',
        'message': 'An unexpected error occurred',
        'data': e.toString()
      };
    }
  }

  static Future<Map<String, dynamic>> verifyCodeAndResetPassword(
      String email, String code, String newPassword) async {
    try {
      final response = await _dio.post(
        '/verify-reset-code',
        data: {
          'email': email,
          'code': code,
          'new_password': newPassword,
        },
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!.data;
      }
      return {
        'retCode': '500',
        'message': 'Failed to connect to server',
        'data': e.message
      };
    } catch (e) {
      return {
        'retCode': '500',
        'message': 'An unexpected error occurred',
        'data': e.toString()
      };
    }
  }
} 