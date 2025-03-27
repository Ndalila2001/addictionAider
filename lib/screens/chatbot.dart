import 'package:addiction_aider/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class ChatBotApp extends StatelessWidget {
  const ChatBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel _channel;
  bool _isConnected = false;
  String _connectionStatus = 'Connecting...';
  
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! How can I help you today?',
      'isMe': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  Future<void> _connectToWebSocket() async {
    setState(() {
      _connectionStatus = 'Connecting...';
      _isConnected = false;
    });

    try {
      // Try different URLs - pick one that works for your setup
      // const url = 'ws://10.0.2.2/api/v1/chat/ws'; // For Android emulator
      const url = 'ws://192.168.1.100/api/v1/chat/ws'; // For local network
      // const url = 'wss://your-production-server.com/chat'; // For production

      _channel = IOWebSocketChannel.connect(
        Uri.parse(url),
        pingInterval: const Duration(seconds: 30),
      );

      setState(() {
        _connectionStatus = 'Connected';
        _isConnected = true;
      });

      _channel.stream.listen(
        (message) {
          setState(() {
            _messages.add({
              'text': message,
              'isMe': false,
            });
          });
        },
        onError: (error) {
          print('WebSocket error: $error');
          setState(() {
            _connectionStatus = 'Error: ${error.toString()}';
            _isConnected = false;
          });
          _reconnect();
        },
        onDone: () {
          print('WebSocket connection closed');
          setState(() {
            _connectionStatus = 'Disconnected';
            _isConnected = false;
          });
          _reconnect();
        },
      );
    } catch (e) {
      print('Connection failed: $e');
      setState(() {
        _connectionStatus = 'Failed: ${e.toString()}';
        _isConnected = false;
      });
      _reconnect();
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      print('Attempting to reconnect...');
      _connectToWebSocket();
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty && _isConnected) {
      final message = _controller.text;
      setState(() {
        _messages.add({
          'text': message,
          'isMe': true,
        });
      });
      
      _channel.sink.add(message);
      _controller.clear();
    } else if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not connected to server'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCD9EC),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Column(
            children: [
              const Text(
                'AI ChatBot',
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: "Fatone",
                  color: Colors.black,
                ),
              ),
              Text(
                _connectionStatus,
                style: TextStyle(
                  color: _isConnected ? Colors.green : Colors.red,
                  fontFamily: "Baloo",
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: message['isMe']
                          ? Border.all(color: secColor, width: 2)
                          : Border.all(color: mainColor),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        fontFamily: "Baloo",
                        color: message['isMe'] ? blackColor : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 120,
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Baloo",
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: "How are you feeling?",
                        hintStyle: const TextStyle(
                          color: Colors.black,
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
                            horizontal: 16, vertical: 14),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: secColor,
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
          ),
        ],
      ),
    );
  }
}