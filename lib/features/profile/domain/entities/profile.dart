/// Entité principale du profil utilisateur
class Profile {
  final String userId;
  final String pseudonyme;
  final String avatar;
  final int xp;
  final int niveau;
  final List<String> completedUniqueQuestIds;

  Profile({
    required this.userId,
    required this.pseudonyme,
    required this.avatar,
    required this.xp,
    required this.niveau,
    this.completedUniqueQuestIds = const [],
  });

  Profile copyWith({
    String? userId,
    String? pseudonyme,
    String? avatar,
    int? xp,
    int? niveau,
    List<String>? completedUniqueQuestIds,
  }) => Profile(
    userId: userId ?? this.userId,
    pseudonyme: pseudonyme ?? this.pseudonyme,
    avatar: avatar ?? this.avatar,
    xp: xp ?? this.xp,
    niveau: niveau ?? this.niveau,
    completedUniqueQuestIds: completedUniqueQuestIds ?? this.completedUniqueQuestIds,
  );
}
