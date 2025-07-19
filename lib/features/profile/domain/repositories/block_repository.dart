import '../entities/block_data.dart';

abstract class BlockRepository {
  Future<List<BlockData>> getAllBlocks();
  Future<BlockData?> getBlockDetail(String id);
}
