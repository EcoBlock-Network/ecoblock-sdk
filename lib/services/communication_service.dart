import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class CommItem {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  CommItem({required this.id, required this.title, required this.excerpt, required this.content, this.imageUrl, required this.createdAt});

  factory CommItem.fromJson(Map<String, dynamic> j) {
    return CommItem(
      id: j['id'] as String,
      title: (j['title'] ?? '') as String,
      excerpt: ((j['body'] ?? '') as String).substring(0, ((j['body'] ?? '') as String).length.clamp(0, 140)),
      content: (j['body'] ?? '') as String,
      imageUrl: j['image_url'] != null ? j['image_url'] as String : null,
      createdAt: DateTime.parse((j['created_at'] ?? DateTime.now().toUtc().toIso8601String()) as String),
    );
  }
}

class CommunicationService {
  final String baseUrl;
  final String apiKey;

  CommunicationService({this.baseUrl = 'https://ecoblock.fr', this.apiKey = ''});

  Future<List<CommItem>> fetchStories() async {
    return _fetchList('/api/communication/stories');
  }

  Future<List<CommItem>> fetchBlogs() async {
    return _fetchList('/api/communication/blog');
  }

  Future<List<CommItem>> _fetchList(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = {
      if (apiKey.isNotEmpty) 'x-api-key': apiKey,
      'accept': 'application/json',
    };

    final resp = await http.get(uri, headers: headers);
    if (resp.statusCode != 200) {
      throw Exception('Failed to load ($path) status=${resp.statusCode}');
    }
    try {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      final items = body['items'] as List<dynamic>;
      return items.map((e) => CommItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to parse response: $e');
    }
  }
}
