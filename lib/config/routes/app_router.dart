import 'package:flutter/material.dart';
import '../../features/chat/data/services/chat_service.dart';
import '../../features/pdf_upload/data/services/pdf_upload_service.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String chatRoute = '/chat';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(
          builder: (_) => const PDFUploadService(),
          settings: settings,
        );
        
      case chatRoute:
        final args = settings.arguments;
        if (args == null || args is! Map<String, dynamic>) {
          return _errorRoute('Geçersiz argümanlar');
        }
        
        final Map<String, dynamic> arguments = args;
        return MaterialPageRoute(
          builder: (_) => ChatService(
            filename: arguments['filename'] as String?,
            contentPreview: arguments['content_preview'] as String?,
          ),
          settings: settings,
        );
        
      default:
        return _errorRoute('Route bulunamadı');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Hata'),
        ),
        body: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
} 