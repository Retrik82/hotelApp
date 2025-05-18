import 'package:flutter/material.dart';
import 'TranslaterScreen.dart'; // Убедись, что этот файл существует

class BotChatScreen extends StatefulWidget {
  const BotChatScreen({super.key});

  @override
  State<BotChatScreen> createState() => _BotChatScreenState();
}

class _BotChatScreenState extends State<BotChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _messages.add(_ChatMessage(text: 'Ответ бота на "$text"', isUser: false));
        });
      });
    });

    _controller.clear();
  }

  void _startListening() {
    // Пока просто вывод сообщения. Здесь можно подключить распознавание речи.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Голосовой ввод')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/bot_icon.png'),
        ),
        title: Text('Чат с ботом'),
        actions: [
          IconButton(
            icon: Icon(Icons.translate, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TranslaterScreen()),
              );
            },
          ),
        ],
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.blue.shade200 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message.text, style: TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.mic, color: Colors.indigo),
                  onPressed: _startListening,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12),
                  ),
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({required this.text, required this.isUser});
}
