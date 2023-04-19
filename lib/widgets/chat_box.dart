import 'package:flutter/material.dart';
import 'package:residency_bot/models/message.dart';
import 'chat_message.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({super.key, required this.messages});

  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          for (var message in messages) ChatMessage(message: message),
        ],
      ),
    );
  }
}
