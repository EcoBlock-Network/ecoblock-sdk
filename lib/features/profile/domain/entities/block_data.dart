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
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'value': value,
    'timestamp': timestamp.toIso8601String(),
    'parents': parents,
    'statut': statut,
    'hash': hash,
  };

  factory BlockData.fromJson(Map<String, dynamic> json) => BlockData(
    id: json['id'],
    type: json['type'],
    value: json['value'],
    timestamp: DateTime.parse(json['timestamp']),
    parents: List<String>.from(json['parents'] ?? []),
    statut: json['statut'],
    hash: json['hash'],
  );
}
