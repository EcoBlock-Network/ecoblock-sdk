/// Statistiques utilisateur
class Stats {
  final int nbBlocs;
  final int nbNodes;
  final List<int> xpParJour;
  final double progression;
  final int niveau;
  final int xp;

  Stats({
    required this.nbBlocs,
    required this.nbNodes,
    required this.xpParJour,
    required this.progression,
    required this.niveau,
    required this.xp,
  });
  Map<String, dynamic> toJson() => {
    'nbBlocs': nbBlocs,
    'nbNodes': nbNodes,
    'xpParJour': xpParJour,
    'progression': progression,
    'niveau': niveau,
    'xp': xp,
  };

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    nbBlocs: json['nbBlocs'],
    nbNodes: json['nbNodes'],
    xpParJour: List<int>.from(json['xpParJour'] ?? []),
    progression: (json['progression'] as num).toDouble(),
    niveau: json['niveau'],
    xp: json['xp'],
  );
}
