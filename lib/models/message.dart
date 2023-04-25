import '../widgets/chat_message.dart';
import 'package:uuid/uuid.dart';

class Message {
  Message(this.id, this.role, this.content);

  String id;
  final ChatRole role;
  String content;

  static List<Message> sampleMessages = [
    Message(
        const Uuid().v4().toString(), ChatRole.user, "Hello what do you do?"),
    Message(const Uuid().v4().toString(), ChatRole.assistant,
        "I am a useful assistant"),
    Message(const Uuid().v4().toString(), ChatRole.user,
        "What can you assist with?"),
    Message(const Uuid().v4().toString(), ChatRole.assistant,
        "I can tell you things about")
  ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'content': content,
      };
}

enum ChatRole { assistant, user }
