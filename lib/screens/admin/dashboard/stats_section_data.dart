import 'package:book_ease/base_url.dart';
import 'package:dio/dio.dart';


class CountResponse {
  final String retCode;
  final String message;
  final int data;

  CountResponse({required this.retCode, required this.message, required this.data});

  factory CountResponse.fromJson(Map<String, dynamic> json) {
    return CountResponse(
      retCode: json['retCode'],
      message: json['message'],
      data: json['data'],
    );
  }
}

class DashboardService {
  final Dio _dio = Dio(_baseOptions);

  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: ApiConfig.baseUrl, // Replace with actual base URL
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 5),
  );

  Future<int> fetchStudentCount() async {
    final response = await _dio.get('/admin/count');
    return CountResponse.fromJson(response.data).data;
  }

  Future<int> fetchBorrowedBooksCount() async {
    final response = await _dio.get('/admin/count-borrowed-books');
    return CountResponse.fromJson(response.data).data;
  }

  Future<int> fetchReservationsCount() async {
    final response = await _dio.get('/admin/count-reservations');
    return CountResponse.fromJson(response.data).data;
  }

  Future<int> fetchOverdueBooksCount() async {
    final response = await _dio.get('/admin/count-overdue-books');
    return CountResponse.fromJson(response.data).data;
  }
}
