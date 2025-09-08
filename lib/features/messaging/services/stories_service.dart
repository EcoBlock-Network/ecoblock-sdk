import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Story {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  Story({required this.id, required this.title, required this.excerpt, required this.content, this.imageUrl, required this.createdAt});

  factory Story.fromJson(Map<String, dynamic> j) {
    return Story(
      id: j['id'] as String,
      title: (j['title'] ?? '') as String,
      excerpt: ((j['body'] ?? '') as String).substring(0, ((j['body'] ?? '') as String).length.clamp(0, 140)),
      content: (j['body'] ?? '') as String,
      imageUrl: j['image_url'] != null ? j['image_url'] as String : null,
      createdAt: DateTime.parse((j['created_at'] ?? DateTime.now().toUtc().toIso8601String()) as String),
    );
  }
}

class StoryService {
  final String baseUrl;
  final String apiKey;

  StoryService({this.baseUrl = 'https://ecoblock.fr', this.apiKey = ''});

  Future<List<Story>> fetchStories() async {
    final uri = Uri.parse('$baseUrl/api/communication/stories');
    final headers = {
      if (apiKey.isNotEmpty) 'x-api-key': apiKey,
      'accept': 'application/json',
    };

    log('fetchStories: GET $uri');
    log('fetchStories: request headers: $headers');

    final resp = await http.get(uri, headers: headers);

    log('fetchStories: status=${resp.statusCode}');
    log('fetchStories: response headers: ${resp.headers}');
    log('fetchStories: response body: ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('Failed to load stories (${resp.statusCode})');
    }

    try {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      final items = body['items'] as List<dynamic>;
      log('fetchStories: parsed items count=${items.length}');
      return items.map((e) => Story.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      log('fetchStories: JSON parse error: $e');
      log('fetchStories: stack: ${st.toString()}');
      throw Exception('Failed to parse stories response: $e');
    }
  }
}
