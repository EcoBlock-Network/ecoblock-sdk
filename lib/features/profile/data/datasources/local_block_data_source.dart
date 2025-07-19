import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/block_data.dart';

class LocalBlockDataSource {
  Future<List<BlockData>> loadBlocks() async {
    final data = await rootBundle.loadString('assets/data/profile/mock_blocks.json');
    final jsonList = jsonDecode(data) as List;
    return jsonList.map((json) => BlockData(
      id: json['id'],
      type: json['type'],
      value: json['value'],
      timestamp: DateTime.parse(json['timestamp']),
      parents: List<String>.from(json['parents']),
      statut: json['statut'],
      hash: json['hash'],
    )).toList();
  }
}

abstract class IBlockRemoteDataSource {
  Future<List<BlockData>> fetchBlocks();
}
