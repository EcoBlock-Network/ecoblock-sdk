import '../../domain/entities/daily_quest.dart';

class DailyQuestModel {
  final String id;
  final String title;
  final String description;
  final int progress;
  final int goal;

  DailyQuestModel({required this.id, required this.title, required this.description, required this.progress, required this.goal});

  factory DailyQuestModel.fromJson(Map<String, dynamic> json) => DailyQuestModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    progress: json['progress'],
    goal: json['goal'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'progress': progress,
    'goal': goal,
  };

  DailyQuest toEntity() => DailyQuest(id: id, title: title, description: description, progress: progress, goal: goal);
}
