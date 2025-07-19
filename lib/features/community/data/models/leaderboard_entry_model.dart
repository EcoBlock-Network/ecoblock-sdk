import '../../domain/entities/leaderboard_entry.dart';

class LeaderboardEntryModel {
  final String id;
  final String pseudo;
  final String avatar;
  final int score;

  LeaderboardEntryModel({
    required this.id,
    required this.pseudo,
    required this.avatar,
    required this.score,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      id: json['id'],
      pseudo: json['pseudo'],
      avatar: json['avatar'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'pseudo': pseudo,
    'avatar': avatar,
    'score': score,
  };

  LeaderboardEntry toEntity() => LeaderboardEntry(
    id: id,
    pseudo: pseudo,
    avatar: avatar,
    score: score,
  );
}
