import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_block_data_source.dart';
import '../../data/repositories/block_repository_impl.dart';
import '../../domain/usecases/get_block_detail_usecase.dart';
import '../../domain/entities/block_data.dart';

final blockDetailProvider = AsyncNotifierProvider.family<BlockDetailNotifier, BlockData?, String>(BlockDetailNotifier.new);

class BlockDetailNotifier extends FamilyAsyncNotifier<BlockData?, String> {
  @override
  Future<BlockData?> build(String id) async {
    final repo = BlockRepositoryImpl(LocalBlockDataSource());
    final usecase = GetBlockDetailUseCase(repo);
    return await usecase(id);
  }
}
