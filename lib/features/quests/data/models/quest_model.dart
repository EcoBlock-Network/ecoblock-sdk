import 'quest_type.dart';

/// Raw Quest model for JSON parsing
class QuestModel {
  final String id;
  final QuestType type;
  final String title;
  final String description;
  final int goal;
  final int progress;
  final DateTime startDate;
  final DateTime endDate;

  QuestModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.goal,
    required this.progress,
    required this.startDate,
    required this.endDate,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: json['id'] as String,
      type: QuestTypeExt.fromString(json['type'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      goal: json['goal'] as int,
      progress: json['progress'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'title': title,
    'description': description,
    'goal': goal,
    'progress': progress,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
  };
}
