import 'package:book_ease/base_url.dart';
import 'package:dio/dio.dart';

final Dio dio = Dio();

Future<List<Map<String, String>>> fetchBookList() async {
  try {
    final response = await dio.get('${ApiConfig.baseUrl}/get-all');

    if (response.statusCode == 200) {
      final responseBody = response.data;

      // Check that Data is a list
      if (responseBody["data"] is List) {
        List<dynamic> data = responseBody["data"];

        return data.map<Map<String, String>>((json) {
          return {
            'bookId': json['book_id'].toString(),
            'title': json['title'] ?? '',
            'author': json['author'] ?? '',
            'year': json['year_published'].toString(),
            'version': json['version'].toString(),
            'isbn': json['isbn'] ?? '',
            'copies': json['available_copies'].toString(),
            'totalCopies': json['total_copies'].toString(),
            'section': json['library_section'] ?? '',
            'shelfLocation': json['shelf_location'] ?? '',
            'category': json['category'] ?? '',
            'condition': json['book_condition'] ?? '',
            'description': json['description'] ?? '',
            'image': json['picture'] ?? '',
          };
        }).toList();
      } else {
        throw Exception("API returned unexpected format: ${responseBody['data']}");
      }
    } else {
      throw Exception('Failed to load books');
    }
  } catch (e) {
    print('Error fetching books: $e');
    return [];
  }
}
