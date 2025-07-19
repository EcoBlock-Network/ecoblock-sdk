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
}
