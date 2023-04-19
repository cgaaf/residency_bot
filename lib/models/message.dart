import '../widgets/chat_message.dart';

class Message {
  Message(this.role, this.content);
  final ChatRole role;
  final String content;

  static List<Message> sampleMessages = [
    Message(ChatRole.user, "Hello what do you do?"),
    Message(ChatRole.assistant, "I am a useful assistant"),
    Message(ChatRole.user, "What can you assist with?"),
    Message(ChatRole.assistant, "I can tell you things about")
  ];
}

enum ChatRole { assistant, user }
