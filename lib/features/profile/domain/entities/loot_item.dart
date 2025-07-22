/// Objet ou coffre débloqué
class LootItem {
  final String id;
  final String nom;
  final String type;
  final String image;
  final bool debloque;

  LootItem({
    required this.id,
    required this.nom,
    required this.type,
    required this.image,
    required this.debloque,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'type': type,
    'image': image,
    'debloque': debloque,
  };

  factory LootItem.fromJson(Map<String, dynamic> json) => LootItem(
    id: json['id'],
    nom: json['nom'],
    type: json['type'],
    image: json['image'],
    debloque: json['debloque'],
  );
}
