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
  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'description': description,
    'condition': condition,
    'unlocked': unlocked,
  };

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    id: json['id'],
    nom: json['nom'],
    description: json['description'],
    condition: json['condition'],
    unlocked: json['unlocked'],
  );
}
