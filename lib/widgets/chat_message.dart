import 'package:flutter/material.dart';

import '../models/message.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.message});
  final Message message;

  bool isAssistant() {
    return (message.role == ChatRole.assistant);
  }

  CrossAxisAlignment calcAlignment() {
    return isAssistant() ? CrossAxisAlignment.start : CrossAxisAlignment.end;
  }

  String buildLabel() {
    return isAssistant() ? "Assistant" : "User";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: calcAlignment(),
      children: [
        Text(
          buildLabel(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        Text(
          message.content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
