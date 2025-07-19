/// Bloc environnemental collecté
class BlockData {
  final String id;
  final String type;
  final num value;
  final DateTime timestamp;
  final List<String> parents;
  final String statut;
  final String hash;

  BlockData({
    required this.id,
    required this.type,
    required this.value,
    required this.timestamp,
    required this.parents,
    required this.statut,
    required this.hash,
  });
}
