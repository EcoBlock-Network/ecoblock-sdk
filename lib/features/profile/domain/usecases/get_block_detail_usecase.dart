import '../entities/block_data.dart';
import '../repositories/block_repository.dart';

class GetBlockDetailUseCase {
  final BlockRepository repository;
  GetBlockDetailUseCase(this.repository);

  Future<BlockData?> call(String id) => repository.getBlockDetail(id);
}
