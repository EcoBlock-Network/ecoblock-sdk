import '../../domain/entities/loot_item.dart';
import '../datasources/local_loot_data_source.dart';
import '../../domain/repositories/loot_repository.dart';

class LootRepositoryImpl implements LootRepository {
  final LocalLootDataSource localDataSource;
  LootRepositoryImpl(this.localDataSource);

  @override
  Future<List<LootItem>> getLootItems() => localDataSource.loadLoot();
}
