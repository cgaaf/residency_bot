import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:residency_bot/secret.dart';

import 'stream_client_web.dart';
import 'package:http/http.dart' as http;

class ChatGPTClient {
  // final uri = Uri.https("api.openai.com", "/v1/chat/completions");
  final uri = Uri.http('localhost:3000', '');
  // final uri = Uri.https('cgaaf-proxy-erver.deno.dev', '');
  // final uri = Uri.http('localhost:8000', '');

  final _headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $API_KEY"
  };

  String _getBody({required bool stream}) {
    final systemMessage = {
      "role": "system",
      "content": "you are a helpful assistant",
    };

    final userMessage = {
      "role": "user",
      "content": "hello world",
    };

    final body = {
      "model": "gpt-3.5-turbo",
      "messages": [systemMessage, userMessage],
      "stream": stream,
    };

    print(body);

    return jsonEncode(body);
  }

  Future<void> testHello() async {
    final uri = Uri.http('localhost:3000', '');
    final client = http.Client();
    final response = await client.get(uri);
    print(response.body);
    print(response.toString());
  }

  Future<String> sendMessage() async {
    final client = http.Client();
    print("CLIENT");
    print(client);
    final response = await client.post(uri,
        headers: _headers, body: _getBody(stream: false));

    print("RESPONSE");
    print(response);

    dynamic decodedResponse;
    if (response.contentLength != null) {
      decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    }

    print("DECODED RESPONSE");
    print(decodedResponse);

    final statusCode = response.statusCode;
    if (!(statusCode >= 200 && statusCode < 300)) {
      if (decodedResponse != null) {
        final errorMessage = decodedResponse["error"]["message"] as String;
        throw Exception("($statusCode) $errorMessage");
      }
      throw Exception(
          "($statusCode) Bad response ${response.reasonPhrase ?? ""}");
    }

    final choices = decodedResponse["choices"] as List;
    final choice = choices[0] as Map;
    final content = choice["message"]["content"] as String;

    return content;
  }

  Stream<String> sendMessageStream() async* {
    final request = http.Request("POST", uri);
    request.headers.addAll(_headers);
    request.body = _getBody(stream: true);

    print("SENDING REQUEST");
    print(request);
    print(request.body);
    print(request.headers);
    print(request.method);
    final response = await StreamClient().send(request);
    print("RECEIVED RESPONSE");
    print(response);
    final statusCode = response.statusCode;
    final byteStream = response.stream;
    print(statusCode);

    if (!(statusCode >= 200 && statusCode < 300)) {
      var error = "";
      await for (final byte in byteStream) {
        final decoded = utf8.decode(byte).trim();
        final map = jsonDecode(decoded) as Map;
        final errorMessage = map["error"]["message"] as String;
        error += errorMessage;
      }
      throw Exception(
          "($statusCode) ${error.isEmpty ? "Bad Response" : error}");
    }

    await for (final byte in byteStream) {
      var decoded = utf8.decode(byte);
      final strings = decoded.split("data: ");
      for (final string in strings) {
        final trimmedString = string.trim();
        if (trimmedString.isNotEmpty && !trimmedString.endsWith("[DONE]")) {
          final map = jsonDecode(trimmedString) as Map;
          final choices = map["choices"] as List;
          final delta = choices[0]["delta"] as Map;
          if (delta["content"] != null) {
            final content = delta["content"] as String;
            // responseText += content;
            yield content;
          }
        }
      }
    }
  }
}
