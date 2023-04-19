import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({super.key, required this.messages});

  final List<String> messages;

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

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.message});

  final String message;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Assistant"),
        Text(message),
      ],
    );
  }
}
