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
}
