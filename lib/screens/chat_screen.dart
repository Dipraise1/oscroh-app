import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _showImageOption = false;

  @override
  void initState() {
    super.initState();
    // Load dummy messages
    _loadDummyMessages();
  }

  void _loadDummyMessages() {
    setState(() {
      _messages.addAll([
        ChatMessage(
          text: 'Hi there! Nice to meet you.',
          isMe: false,
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        ),
        ChatMessage(
          text: 'Hey! Thanks for connecting. How are you doing?',
          isMe: true,
          timestamp: DateTime.now()
              .subtract(const Duration(days: 1, hours: 1, minutes: 45)),
        ),
        ChatMessage(
          text:
              'I\'m doing great, thanks for asking! Just got back from work. What about you?',
          isMe: false,
          timestamp: DateTime.now()
              .subtract(const Duration(days: 1, hours: 1, minutes: 30)),
        ),
        ChatMessage(
          text:
              'I\'m good too! Just finishing up some work but looking forward to the weekend.',
          isMe: true,
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        ),
        ChatMessage(
          text: 'Any plans for the weekend?',
          isMe: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
      ]);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _messageController.text.trim(),
        isMe: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
      _showImageOption = false;
    });

    // Scroll to bottom after message is sent
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate received message
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: 'Thanks for your message! I\'ll get back to you soon.',
            isMe: false,
            timestamp: DateTime.now(),
          ));
        });

        // Scroll to bottom after receiving message
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: const Icon(
                Icons.person,
                color: Colors.white70,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[400],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show chat options
              _showChatOptions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final showDate = index == 0 ||
                    !_isSameDay(
                        _messages[index - 1].timestamp, message.timestamp);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showDate)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _formatMessageDate(message.timestamp),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ),
                      ),
                    MessageBubble(
                      message: message,
                      profileColor: Theme.of(context).primaryColor,
                    ),
                  ],
                );
              },
            ),
          ),

          // Image options
          if (_showImageOption)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[100],
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_camera),
                    onPressed: () {
                      // Open camera
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: () {
                      // Open gallery
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showImageOption = false;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),

          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_photo_alternate),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      _showImageOption = !_showImageOption;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text('View Profile'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to profile screen
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.notifications_off,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text('Mute Notifications'),
                onTap: () {
                  Navigator.pop(context);
                  // Toggle notifications
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.block,
                  color: Colors.red,
                ),
                title: const Text('Block User'),
                onTap: () {
                  Navigator.pop(context);
                  // Show block confirmation
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.report,
                  color: Colors.orange,
                ),
                title: const Text('Report User'),
                onTap: () {
                  Navigator.pop(context);
                  // Show report dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) {
      return 'Today';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String? imageUrl;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.imageUrl,
  });
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final Color profileColor;

  const MessageBubble({
    super.key,
    required this.message,
    required this.profileColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: profileColor.withOpacity(0.2),
              child: const Icon(
                Icons.person,
                size: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe ? profileColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        message.imageUrl!,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isMe ? Colors.white70 : Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
