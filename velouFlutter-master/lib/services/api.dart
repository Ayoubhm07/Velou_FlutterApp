import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  final String baseUrl;

  Api(this.baseUrl);

  Future<Map<String, dynamic>> addPost({
    required String title,
    required String description,
    required String image,
    required String category,
    required String state,
  }) async {
    final url = Uri.parse('$baseUrl/add-post');
    final Map<String, dynamic> postData = {
      'title': title,
      'description': description,
      'image': image,
      'category': category,
      'state': state,
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(postData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {'success': true, 'data': responseData['data']};
      } else {
        return {'success': false, 'error': 'Failed to add post'};
      }
    } catch (error) {
      print(error);
      return {'success': false, 'error': 'Internal server error'};
    }
  }
}
