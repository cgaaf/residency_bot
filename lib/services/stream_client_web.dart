import 'package:http/http.dart' as http;
import 'package:fetch_client/fetch_client.dart';
import 'package:web_browser_detect/web_browser_detect.dart';

class StreamClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final browser = Browser().browser;
    final isSafariBrowser =
        browser.indexOf("Safari") > -1 && browser.indexOf("Chrome") <= -1;
    if (isSafariBrowser) {
      return http.Client().send(request);
    } else {
      final client = FetchClient(mode: RequestMode.cors, streamRequests: true);
      return client.send(request);
    }
  }
}

StreamClient getClient() => StreamClient();
