import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  ChatInput({super.key, required this.onSubmitted});

  final void Function(String) onSubmitted;

  void pressButton() {
    onSubmitHandler(controller.text);
  }

  void onSubmitHandler(String inputText) {
    onSubmitted(inputText);
    controller.clear();
    print("Input cleared");
  }

  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Ask your question",
              suffixIcon: IconButton(
                onPressed: pressButton,
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ),
            onSubmitted: onSubmitHandler,
          ),
        ),
      ],
    );
  }
}
