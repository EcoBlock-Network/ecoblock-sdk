import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final data = await rootBundle.loadString('assets/data/profile/mock_stats.json');
  return DashboardStats.fromJson(json.decode(data));
});
final dashboardQuestsProvider = FutureProvider<DashboardQuests>((ref) async {
  final data = await rootBundle.loadString('assets/data/personal_quests.json');
  return DashboardQuests.fromJson(json.decode(data));
});
final dashboardStoriesProvider = FutureProvider<List<DashboardStory>>((ref) async {
  final data = await rootBundle.loadString('assets/data/profile/mock_badges.json');
  return (json.decode(data) as List).map((e) => DashboardStory.fromJson(e)).toList();
});
class DashboardStats {
  final int level;
  final double progress;
  DashboardStats({required this.level, required this.progress});
  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
    level: json['level'],
    progress: json['progress'],
  );
}
class DashboardQuests {
  final Quest daily;
  DashboardQuests({required this.daily});
  factory DashboardQuests.fromJson(Map<String, dynamic> json) => DashboardQuests(
    daily: Quest.fromJson(json['daily']),
  );
}
class Quest {
  final String title;
  Quest({required this.title});
  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
    title: json['title'],
  );
}
class DashboardStory {
  final String id;
  final String title;
  DashboardStory({required this.id, required this.title});
  factory DashboardStory.fromJson(Map<String, dynamic> json) => DashboardStory(
    id: json['id'],
    title: json['title'],
  );
}
