import 'package:flutter/material.dart';
import 'package:residency_bot/models/message.dart';
import 'package:residency_bot/services/chatgpt_client.dart';
import 'package:residency_bot/widgets/chat_box.dart';
import 'package:residency_bot/widgets/chat_input.dart';

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
  final List<Message> _sampleData = Message.sampleMessages;

  void submitText(String string) {
    setState(() {
      Message userMessage = Message(ChatRole.user, string);
      _sampleData.add(userMessage);

      Message assistantMessage = Message(ChatRole.assistant, "");
      _sampleData.add(assistantMessage);

      final client = ChatGPTClient();
      client.sendMessageStream().listen((responseChunk) {
        setState(() {
          _sampleData.last.content += responseChunk;
        });
      });
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
              ChatBox(messages: _sampleData),
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
