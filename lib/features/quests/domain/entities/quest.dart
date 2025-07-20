
import 'package:ecoblock_mobile/features/quests/data/models/quest_type.dart';

class Quest {
  final String id;
  final String title;
  final String description;
  final int goal;
  final int progress;
  final DateTime startDate;
  final DateTime endDate;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.goal,
    required this.progress,
    required this.startDate,
    required this.endDate, required QuestType type,
  });

  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        goal: json['goal'],
        progress: json['progress'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        type: QuestType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
          orElse: () => QuestType.values.first,
        ),
      );
}