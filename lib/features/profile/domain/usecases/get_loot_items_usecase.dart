import '../entities/loot_item.dart';
import '../repositories/loot_repository.dart';

class GetLootItemsUseCase {
  final LootRepository repository;
  GetLootItemsUseCase(this.repository);

  Future<List<LootItem>> call() => repository.getLootItems();
}
