import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:ecoblock_mobile/core/config.dart';

class Story {
  final String id;
  final String title;
  final String? imageUrl;

  Story({required this.id, required this.title, this.imageUrl});

  factory Story.fromJson(Map<String, dynamic> json) {
    final idVal = (json['id'] ?? json['uuid'] ?? json['slug'] ?? '')?.toString() ?? '';
    final titleVal = (json['title'] ?? json['label'] ?? json['name'] ?? '')?.toString() ?? '';
    final imageVal = (json['image'] ?? json['image_url'] ?? json['thumbnail'])?.toString();
    return Story(id: idVal, title: titleVal, imageUrl: imageVal);
  }
}

class StoriesService {
  final String baseUrl;
  StoriesService({this.baseUrl = 'https://ecoblock.fr'});

  Future<List<Story>> fetchStories() async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('$baseUrl/api/communication/stories');
      final req = await client.getUrl(uri);
      req.headers.set(HttpHeaders.acceptHeader, 'application/json');
      if (kApiKey.isNotEmpty) {
        req.headers.set('x-api-key', kApiKey);
        log('stories_service: using x-api-key length=${kApiKey.length}');
      } else {
        log('stories_service: no ECO_API_KEY provided');
      }
      final resp = await req.close();
      if (resp.statusCode != 200) {
        throw HttpException('Bad status: \\${resp.statusCode}');
      }
      final body = await resp.transform(utf8.decoder).join();
      final decoded = json.decode(body);
      // API may return a bare list or an object with `items` or `data`.
      if (decoded is List) {
        return decoded.map((e) => Story.fromJson(e as Map<String, dynamic>)).toList();
      }
      if (decoded is Map) {
        if (decoded['items'] is List) {
          return (decoded['items'] as List).map((e) => Story.fromJson(e as Map<String, dynamic>)).toList();
        }
        if (decoded['data'] is List) {
          return (decoded['data'] as List).map((e) => Story.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } finally {
      client.close(force: true);
    }
  }
}
