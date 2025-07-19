import '../entities/block_data.dart';
import '../repositories/block_repository.dart';

class GetAllBlocksUseCase {
  final BlockRepository repository;
  GetAllBlocksUseCase(this.repository);

  Future<List<BlockData>> call() => repository.getAllBlocks();
}
