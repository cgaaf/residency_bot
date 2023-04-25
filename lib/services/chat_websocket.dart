import 'package:web_socket_channel/web_socket_channel.dart';

class GPTWebSocket {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://127.0.0.1:8080/openAI'),
  );

  // Stream<dynamic> connectSocket() {
  //   return channel.stream as Stream<dynamic>;
  // }

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void printStream() {
    channel.stream.listen((event) {
      print(event);
    });
  }
}
