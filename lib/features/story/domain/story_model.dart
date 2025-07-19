import 'package:flutter/material.dart';

enum StoryType { image, video }

class StoryItem {
  final String url;
  final StoryType type;
  final Duration duration;

  StoryItem({
    required this.url,
    required this.type,
    this.duration = const Duration(seconds: 5),
  });
}
