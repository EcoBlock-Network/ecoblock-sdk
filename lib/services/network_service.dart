import 'dart:convert';
import 'dart:io';

class NetworkService {
  final String baseUrl;
  final String? apiKey;

  NetworkService({required this.baseUrl, this.apiKey});

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<dynamic> getJson(String path, {Duration timeout = const Duration(seconds: 10)}) async {
    final client = HttpClient();
    try {
      final uri = _uri(path);
      final req = await client.getUrl(uri);
      req.headers.set(HttpHeaders.acceptHeader, 'application/json');
      if (apiKey != null && apiKey!.isNotEmpty) {
        req.headers.set('x-api-key', apiKey!);
      }
      final resp = await req.close().timeout(timeout);
      if (resp.statusCode != 200) {
        throw HttpException('Bad status: ${resp.statusCode}', uri: uri);
      }
      final body = await resp.transform(utf8.decoder).join();
      return json.decode(body);
    } finally {
      client.close(force: true);
    }
  }
}
