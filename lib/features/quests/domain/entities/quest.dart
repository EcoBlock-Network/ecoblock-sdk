import '../../data/models/quest_type.dart';

/// Domain entity for Quest
class Quest {
  final String id;
  final QuestType type;
  final String title;
  final String description;
  final int goal;
  final int progress;
  final DateTime startDate;
  final DateTime endDate;

  Quest({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.goal,
    required this.progress,
    required this.startDate,
    required this.endDate,
  });
}
