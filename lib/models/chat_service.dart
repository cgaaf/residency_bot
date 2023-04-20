import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:http/http.dart' as http;

class ChatService {
  final url = "https://cgaaf-proxy-erver.deno.dev/";
  final _dio = Dio();

  void sendMessage(String content) {
    var uri = Uri.parse(url);

    var body = jsonEncode(
      {
        "model": "gpt-4",
        "stream": true,
        "messages": [
          {"role": "user", "content": content}
        ]
      },
    );

    var response = http.post(uri, body: body);
    var stream = response.asStream();

    stream.listen((event) {
      print(event.body);
    });
  }

  Stream<T> getStream<T>(String url, CancelToken cancelToken,
      {required T Function(Map<String, dynamic>) onSuccess}) {
    final controller = StreamController<T>.broadcast();

    print("starting request");
    _dio
        .get(url,
            cancelToken: cancelToken,
            options: Options(responseType: ResponseType.stream))
        .then((it) {
      (it.data.stream as Stream).listen((it) {
        final rawData = utf8.decode(it);

        final dataList =
            rawData.split("\n").where((element) => element.isNotEmpty).toList();

        for (final line in dataList) {
          if (line.startsWith("data: ")) {
            final data = line.substring(6);
            if (data.startsWith("[DONE]")) {
              print("stream response is done");
              return;
            }

            controller
              ..sink
              ..add(onSuccess(json.decode(data)));
          }
        }
      }, onDone: () {
        controller.close();
      }, onError: (err, t) {
        print(err);
        controller
          ..sink
          ..addError(err, t);
      });
    }, onError: (err, t) {
      print(err);
      controller
        ..sink
        ..addError(err, t);
    });

    return controller.stream;
  }
}
