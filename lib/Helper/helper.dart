import 'package:http/http.dart' as http;

class ApiHandler {
  static Future<Map<String, dynamic>> fetchData(String apiPath) async {
    try {
      final response = await http.get(Uri.parse('apiPath'));

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.body};
      } else {
        return {'success': false, 'error': 'Failed to fetch data'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Exception: $e'};
    }
  }
}
