import '../../domain/entities/block_data.dart';
import '../datasources/local_block_data_source.dart';
import '../../domain/repositories/block_repository.dart';

class BlockRepositoryImpl implements BlockRepository {
  final LocalBlockDataSource localDataSource;
  BlockRepositoryImpl(this.localDataSource);

  @override
  Future<List<BlockData>> getAllBlocks() => localDataSource.loadBlocks();

  @override
  Future<BlockData?> getBlockDetail(String id) async {
    final blocks = await localDataSource.loadBlocks();
    return blocks.firstWhere((b) => b.id == id);
  }
}
