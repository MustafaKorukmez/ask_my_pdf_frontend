import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/'),
        headers: {
          'Accept': 'application/json',
          'Connection': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'message': message}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['response'] as String;
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }
} 