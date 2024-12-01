import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' show utf8;
import '../../../../core/constants/api_constants.dart';

class ChatService extends StatefulWidget {
  final String? filename;
  final String? contentPreview;

  const ChatService({
    Key? key,
    this.filename,
    this.contentPreview,
  }) : super(key: key);

  @override
  State<ChatService> createState() => _ChatServiceState();
}

class _ChatServiceState extends State<ChatService> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text;
    setState(() {
      _messages.add({
        'role': 'user',
        'content': userMessage,
      });
      _isLoading = true;
    });
    _messageController.clear();

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/chat/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: utf8.encode(json.encode({
          'message': userMessage,
        })),
      ).timeout(ApiConstants.timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content': data['response'] ?? 'Yanıt alınamadı',
          });
        });
      } else {
        throw Exception('Mesaj gönderilemedi: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF3498DB).withOpacity(0.1),
            child: const Icon(
              Icons.picture_as_pdf,
              color: Color(0xFF3498DB),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.filename ?? 'PDF Sohbet',
              style: const TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.contentPreview != null)
              Text(
                widget.contentPreview!,
                style: const TextStyle(
                  color: Color(0xFF7F8C8D),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF3498DB)),
            onPressed: () {
              setState(() => _messages.clear());
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF2C3E50)),
            onSelected: (value) {
              // Menü işlemleri
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new',
                child: Row(
                  children: [
                    Icon(Icons.upload_file, color: Color(0xFF3498DB)),
                    SizedBox(width: 8),
                    Text('Yeni PDF Yükle'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: Color(0xFF3498DB)),
                    SizedBox(width: 8),
                    Text('Sohbeti Temizle'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (_messages.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: const Color(0xFF3498DB).withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'PDF içeriği hakkında soru sorun',
                      style: TextStyle(
                        color: Color(0xFF7F8C8D),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message['role'] == 'user';
                    
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        margin: EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          left: isUser ? 50 : 0,
                          right: isUser ? 0 : 50,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color(0xFF3498DB)
                              : const Color(0xFFF5F7FB),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(isUser ? 20 : 0),
                            bottomRight: Radius.circular(isUser ? 0 : 20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isUser) ...[
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: const Color(0xFF3498DB).withOpacity(0.1),
                                    child: const Icon(
                                      Icons.assistant,
                                      size: 16,
                                      color: Color(0xFF3498DB),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  isUser ? 'Siz' : 'Asistan',
                                  style: TextStyle(
                                    color: isUser
                                        ? Colors.white.withOpacity(0.7)
                                        : const Color(0xFF7F8C8D),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message['content'] ?? '',
                              style: TextStyle(
                                color: isUser ? Colors.white : const Color(0xFF2C3E50),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FB),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'PDF hakkında bir soru sorun...',
                              hintStyle: TextStyle(color: Color(0xFF95A5A6)),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        if (_messageController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close, color: Color(0xFF95A5A6)),
                            onPressed: () {
                              _messageController.clear();
                              setState(() {});
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3498DB).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: _isLoading ? null : _sendMessage,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
} 