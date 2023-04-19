import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({super.key, required this.onSubmitted});

  final void Function(String) onSubmitted;

  void pressButton() {}

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Ask your question",
              suffixIcon: IconButton(
                onPressed: pressButton,
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ),
            onSubmitted: onSubmitted,
          ),
        ),
      ],
    );
  }
}
