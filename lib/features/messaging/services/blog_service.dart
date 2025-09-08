import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Blog {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  Blog({required this.id, required this.title, required this.excerpt, required this.content, this.imageUrl, required this.createdAt});

  factory Blog.fromJson(Map<String, dynamic> j) {
    return Blog(
      id: j['id'] as String,
      title: j['title'] as String,
      excerpt: (j['body'] as String).substring(0, (j['body'] as String).length.clamp(0, 140)),
      content: j['body'] as String,
      imageUrl: j['image_url'] != null ? j['image_url'] as String : null,
      createdAt: DateTime.parse(j['created_at'] as String),
    );
  }
}

class BlogService {
  final String baseUrl;
  final String apiKey;

  BlogService({this.baseUrl = 'https://ecoblock.fr', this.apiKey = 'fbsM55F9tSZP6mlK5Fp+2WVZYuJKnunvaTXQrf/bN/o='});

  Future<List<Blog>> fetchBlogs() async {
    final uri = Uri.parse('$baseUrl/api/communication/blog');
    final headers = {
      if (apiKey.isNotEmpty) 'x-api-key': apiKey,
      'accept': 'application/json',
    };

    log('fetchBlogs: GET $uri');
    log('fetchBlogs: request headers: $headers');

    final resp = await http.get(uri, headers: headers);

    log('fetchBlogs: status=${resp.statusCode}');
    log('fetchBlogs: response headers: ${resp.headers}');
    log('fetchBlogs: response body: ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('Failed to load blogs (${resp.statusCode})');
    }

    try {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      final items = body['items'] as List<dynamic>;
      log('fetchBlogs: parsed items count=${items.length}');
      return items.map((e) => Blog.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      log('fetchBlogs: JSON parse error: $e');
      log('fetchBlogs: stack: ${st.toString()}');
      throw Exception('Failed to parse blogs response: $e');
    }
  }
}
