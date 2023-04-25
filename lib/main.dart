import 'package:flutter/material.dart';
import 'package:residency_bot/models/message.dart';
import 'package:residency_bot/services/chat_websocket.dart';
import 'package:residency_bot/widgets/chat_box.dart';
import 'package:residency_bot/widgets/chat_input.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Chatbot Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Message> _messages = [];
  final chatSocket = GPTWebSocket();

  @override
  void initState() {
    // chatSocket.channel.stream.listen((event) {
    //   print(event);
    //   setState(() {
    //     _messages
    //   });
    // });

    // chatSocket.getMessageStream().listen((event) {
    //   print(event);
    // });
    print("GETTING MESSAGE STREAM");
    final messageStream = chatSocket.getMessageStream();
    print("MESSAGE STREAM RECEIVED");
    messageStream.listen((streamedMessage) {
      final localMessageExists =
          _messages.map((e) => e.id).contains(streamedMessage.id);
      print(streamedMessage);

      setState(() {
        if (localMessageExists) {
          // find local message and add the new content
          var localMessage = _messages
              .firstWhere((element) => element.id == streamedMessage.id);
          localMessage.content += streamedMessage.content;
        } else {
          // add the first streamed message to the list
          _messages.add(streamedMessage);
        }
      });
    });

    super.initState();
  }

  void submitText(String string) {
    setState(() {
      // Message userMessage = Message(UChatRole.user, string);
      final userMessage =
          Message(const Uuid().v4().toString(), ChatRole.user, string);
      _messages.add(userMessage);

      chatSocket.sendMessages(_messages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ChatBox(messages: _messages),
              ChatInput(
                onSubmitted: submitText,
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
