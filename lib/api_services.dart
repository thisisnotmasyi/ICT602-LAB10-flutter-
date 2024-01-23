import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<dynamic>> getSubjects() async {
    final response = await http.get(Uri.parse('$baseUrl/subject'));
    return json.decode(response.body)['subject'];
  }

  // Implement other CRUD methods (getSubject, addSubject, updateSubject, deleteSubject) similarly.
}
