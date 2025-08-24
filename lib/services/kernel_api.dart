import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

/// Simple kernel API client (scaffold)
/// Configure `baseUrl` via dependency injection or environment.
class KernelApi {
  final String baseUrl;
  KernelApi({required this.baseUrl});

  Uri _uri(String path) => Uri.parse('${baseUrl.trim().replaceAll(RegExp(r'\/$'), '')}/api$path');

  Future<bool> health() async {
    final uri = _uri('/health');
    final resp = await http.get(uri).timeout(const Duration(seconds: 5));
    return resp.statusCode == 200;
  }

  Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body) async {
    final uri = _uri(path);
    final resp = await http.post(uri, body: jsonEncode(body), headers: {'Content-Type': 'application/json'}).timeout(const Duration(seconds: 8));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
  }

  // Example: post a Tangle block payload
  Future<String> postBlock(Map<String, dynamic> blockPayload) async {
    final resp = await postJson('/blocks', blockPayload);
    return resp['id']?.toString() ?? '';
  }

  // WebSocket: simple stream wrapper
  WebSocketChannel connectWs({String path = '/ws'}) {
    final wsUrl = baseUrl.replaceFirst(RegExp(r'^http'), 'ws');
    final uri = Uri.parse('${wsUrl.trim().replaceAll(RegExp(r'\/$'), '')}/api$path');
    return WebSocketChannel.connect(uri);
  }
}
