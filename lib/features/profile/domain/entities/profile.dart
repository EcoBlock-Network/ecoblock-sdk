/// Entité principale du profil utilisateur
class Profile {
  final String userId;
  final String pseudonyme;
  final String avatar;
  final int xp;
  final int niveau;

  Profile({
    required this.userId,
    required this.pseudonyme,
    required this.avatar,
    required this.xp,
    required this.niveau,
  });
}
