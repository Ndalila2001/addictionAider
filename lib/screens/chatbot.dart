import 'package:addiction_aider/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

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

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel _channel;
  final List<Map<String, dynamic>> _messages = [];
  bool _isWaitingForResponse = false;
  late AnimationController _loadingController;
  late Animation<double> _dot1Animation;
  late Animation<double> _dot2Animation;
  late Animation<double> _dot3Animation;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
    
    // Initialize animation controller
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    
    // Create animations for each dot
    _dot1Animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.2), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _loadingController,
      curve: const Interval(0.0, 0.33, curve: Curves.easeInOut),
    ));
    
    _dot2Animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.2), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _loadingController,
      curve: const Interval(0.33, 0.66, curve: Curves.easeInOut),
    ));
    
    _dot3Animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.2), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _loadingController,
      curve: const Interval(0.66, 1.0, curve: Curves.easeInOut),
    ));
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8000/api/v1/bot/ws'),
    );

    _channel.stream.listen(
      (message) {
        setState(() {
          _isWaitingForResponse = false;
          _messages.add({
            'text': message,
            'isMe': false,
            'timestamp': DateTime.now(),
          });
        });
      },
      onError: (error) {
        setState(() => _isWaitingForResponse = false);
        print('WebSocket error: $error');
      },
      onDone: () {
        setState(() => _isWaitingForResponse = false);
        print('WebSocket connection closed');
      },
    );
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({
        'text': message,
        'isMe': true,
        'timestamp': DateTime.now(),
      });
      _isWaitingForResponse = true;
    });

    _channel.sink.add(message);
    _controller.clear();
  }

  Widget _buildLoadingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _dot1Animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _dot1Animation.value,
                  child: child,
                );
              },
              child: Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  color: secColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _dot2Animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _dot2Animation.value,
                  child: child,
                );
              },
              child: Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  color: secColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _dot3Animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _dot3Animation.value,
                  child: child,
                );
              },
              //hjghjghjgjg
              child: Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  color: secColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _channel.sink.close(status.goingAway);
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
          const Text(
            'AI ChatBot',
            style: TextStyle(
              fontSize: 32,
              fontFamily: "Fatone",
              color: Colors.black,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: false,
              itemCount: _messages.length + (_isWaitingForResponse ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isWaitingForResponse && index == _messages.length) {
                  return _buildLoadingIndicator();
                }
                
                final message = _messages[index];
                return Align(
                  alignment: message['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: message['isMe'] 
                          ? mainColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: message['isMe'] ? secColor : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['text'],
                          style: TextStyle(
                            fontFamily: "Baloo",
                            color: message['isMe'] ? blackColor : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${message['timestamp'].hour}:${message['timestamp'].minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Baloo',
                            color: blackColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Baloo",
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: "How are you feeling?",
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