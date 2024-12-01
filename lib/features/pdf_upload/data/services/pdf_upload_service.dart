import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';
import 'dart:convert';
import '../../../../core/constants/api_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class PDFUploadService extends StatefulWidget {
  const PDFUploadService({Key? key}) : super(key: key);

  @override
  State<PDFUploadService> createState() => _PDFUploadServiceState();
}

class _PDFUploadServiceState extends State<PDFUploadService> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  String? _selectedFileName;
  Uint8List? _selectedFileBytes;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickPDF() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _selectedFileBytes = result.files.first.bytes;
          _selectedFileName = result.files.first.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dosya seçilirken hata oluştu: $e')),
      );
    }
  }

  Future<void> _uploadPDF() async {
    if (_selectedFileBytes == null || _selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen önce bir PDF dosyası seçin')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await uploadPDFWeb(_selectedFileBytes!, _selectedFileName!);
      
      print('API Yanıtı: $result');
      
      if (!mounted) return;
      
      final arguments = {
        'filename': _selectedFileName,
        'content_preview': result['content_preview'],
      };
      
      print('Route Argümanları: $arguments');
      
      Navigator.pushNamed(
        context,
        '/chat',
        arguments: arguments,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yükleme hatası: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>> uploadPDFWeb(Uint8List fileBytes, String fileName) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.uploadEndpoint}');
      print('Uploading to: $uri');

      final request = http.MultipartRequest('POST', uri);
      
      request.headers.addAll({
        'Accept': 'application/json; charset=UTF-8',
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
        ApiConstants.timeoutDuration,
      );
      
      print('Getting response...');
      final response = await http.Response.fromStream(streamedResponse);
      
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Upload error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPainter(),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'PDF Yükle',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'PDF dosyanızı yükleyin ve sohbete başlayın',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF7F8C8D),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 320,
                          height: 400,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_selectedFileName != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3F2FD),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.picture_as_pdf,
                                        size: 48,
                                        color: Color(0xFF1976D2),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _selectedFileName!,
                                        style: const TextStyle(
                                          color: Color(0xFF1976D2),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else
                                MouseRegion(
                                  onEnter: (_) => _animationController.forward(),
                                  onExit: (_) => _animationController.reverse(),
                                  child: GestureDetector(
                                    onTap: _pickPDF,
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F7FB),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(0xFFBDC3C7),
                                          width: 2,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            CupertinoIcons.cloud_upload,
                                            size: 48,
                                            color: Color(0xFF3498DB),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'PDF Dosyası Seç',
                                            style: TextStyle(
                                              color: Color(0xFF2C3E50),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: 240,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading || _selectedFileBytes == null
                                      ? null
                                      : _uploadPDF,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3498DB),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                  ),
                                  child: _isLoading
                                      ? const CupertinoActivityIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          'Sohbete Başla',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3498DB).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.7,
        size.width * 0.5,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.9,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 