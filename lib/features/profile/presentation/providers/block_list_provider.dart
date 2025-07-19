import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_block_data_source.dart';
import '../../data/repositories/block_repository_impl.dart';
import '../../domain/usecases/get_all_blocks_usecase.dart';
import '../../domain/entities/block_data.dart';

final blockListProvider = AsyncNotifierProvider<BlockListNotifier, List<BlockData>>(BlockListNotifier.new);

class BlockListNotifier extends AsyncNotifier<List<BlockData>> {
  @override
  Future<List<BlockData>> build() async {
    final repo = BlockRepositoryImpl(LocalBlockDataSource());
    final usecase = GetAllBlocksUseCase(repo);
    return await usecase();
  }
}
