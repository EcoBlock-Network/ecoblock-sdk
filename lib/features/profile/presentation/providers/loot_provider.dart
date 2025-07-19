import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_loot_data_source.dart';
import '../../data/repositories/loot_repository_impl.dart';
import '../../domain/usecases/get_loot_items_usecase.dart';
import '../../domain/entities/loot_item.dart';

final lootProvider = AsyncNotifierProvider<LootNotifier, List<LootItem>>(LootNotifier.new);

class LootNotifier extends AsyncNotifier<List<LootItem>> {
  @override
  Future<List<LootItem>> build() async {
    final repo = LootRepositoryImpl(LocalLootDataSource());
    final usecase = GetLootItemsUseCase(repo);
    return await usecase();
  }
}
