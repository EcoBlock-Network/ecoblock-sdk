import '../../domain/entities/upcoming_quest.dart';

class UpcomingQuestModel {
  final String id;
  final String title;
  final String status; // "past", "current", "future"
  final String date;

  UpcomingQuestModel({required this.id, required this.title, required this.status, required this.date});

  factory UpcomingQuestModel.fromJson(Map<String, dynamic> json) => UpcomingQuestModel(
    id: json['id'],
    title: json['title'],
    status: json['status'],
    date: json['date'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'status': status,
    'date': date,
  };

  UpcomingQuest toEntity() => UpcomingQuest(id: id, title: title, status: status, date: date);
}
