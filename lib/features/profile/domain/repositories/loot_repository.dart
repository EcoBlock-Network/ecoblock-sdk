import '../entities/loot_item.dart';

abstract class LootRepository {
  Future<List<LootItem>> getLootItems();
}
