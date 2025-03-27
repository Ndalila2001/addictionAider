import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

import '../consts/colors.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _messageController = TextEditingController();
  late WebSocketChannel _channel;
  final List<Map<String, dynamic>> _messages = [];
  final String _userId = '67e3278fdd140e3f8d06025a';
  final String _receiverId = '67e4350fea4ec7661bca200d';
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    try {
      // Use your actual server IP instead of localhost
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8000/api/v1/chat/ws'),
      );

      // Send user_id immediately
      _channel.sink.add(json.encode({'user_id': _userId}));

      setState(() => _isConnected = true);

      _channel.stream.listen(
        (message) => _handleIncomingMessage(message),
        onError: (error) => _handleConnectionError(error),
        onDone: () => _handleConnectionClosed(),
      );
    } catch (e) {
      _handleConnectionError(e);
    }
  }

  void _handleIncomingMessage(dynamic message) {
    try {
      final data = json.decode(message);
      setState(() {
        _messages.add({
          'text': data['message'],
          'isSent': data['sender'] == _userId,
          'timestamp': DateTime.now(),
        });
      });
    } catch (e) {
      print('Message parsing error: $e');
    }
  }

  void _handleConnectionError(dynamic error) {
    print('WebSocket error: $error');
    setState(() => _isConnected = false);
    Future.delayed(const Duration(seconds: 2), _connectToWebSocket);
  }

  void _handleConnectionClosed() {
    print('WebSocket connection closed');
    setState(() => _isConnected = false);
    Future.delayed(const Duration(seconds: 2), _connectToWebSocket);
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty || !_isConnected) return;

    final messageData = {
      'sender': _userId,
      'recipient': _receiverId,
      'message': message,
    };

    try {
      _channel.sink.add(json.encode(messageData));
      setState(() {
        _messages.add({
          'text': message,
          'isSent': true,
          'timestamp': DateTime.now(),
        });
      });
      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  @override
  void dispose() {
    _channel.sink.close(status.goingAway);
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCD9EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDCD9EC),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Group Chat',
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Fatone",
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.circle,
              color: _isConnected ? Colors.green : Colors.red,
              size: 12,
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return MessageBubble(
                  text: message['text'],
                  isSent: message['isSent'],
                  timestamp: message['timestamp'],
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: "Baloo",
              ),
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: const TextStyle(
                  color: blackColor,
                  fontFamily: "Baloo",
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: secColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: secColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: secColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                filled: true,
                fillColor: mainColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isConnected ? secColor : Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                LucideIcons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isSent;
  final DateTime timestamp;

  const MessageBubble({
    required this.text,
    required this.isSent,
    required this.timestamp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSent ? secColor.withOpacity(0.3) : mainColor.withOpacity(0.3),
          border: Border.all(color: const Color(0xFF28E07E)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}