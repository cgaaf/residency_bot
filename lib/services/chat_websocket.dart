import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:residency_bot/models/message.dart';

class GPTWebSocket {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://127.0.0.1:8080/openAI'),
  );

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void sendMessages(List<Message> messages) {
    final encoded = jsonEncode(messages);
    channel.sink.add(encoded);
  }

  Stream<Message> getMessageStream() {
    print("FORMATTING MESSAGES");
    return channel.stream.map((text) {
      print(text);
      var json = jsonDecode(text);
      final String id = json['id'];
      final String content = json['content'];

      return Message(id, ChatRole.assistant, content);
    });
  }

  void printStream() {
    channel.stream.listen((event) {
      print(event);
    });
  }
}
