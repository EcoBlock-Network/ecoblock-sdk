/// Badge de succès
class Badge {
  final String id;
  final String nom;
  final String description;
  final String condition;
  final bool unlocked;

  Badge({
    required this.id,
    required this.nom,
    required this.description,
    required this.condition,
    required this.unlocked,
  });
}
