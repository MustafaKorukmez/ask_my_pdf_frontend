import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<Map<String, dynamic>> uploadPDFWeb(Uint8List fileBytes, String fileName) async {
    try {
      final uri = Uri.parse('$baseUrl/upload-pdf/');
      print('Uploading to: $uri');

      final request = http.MultipartRequest('POST', uri);
      
      request.headers.addAll({
        'Accept': 'application/json',
        'Connection': 'keep-alive',
      });

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );

      print('Sending request...');
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      
      print('Getting response...');
      final response = await http.Response.fromStream(streamedResponse);
      
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Upload error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
} 