import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/loot_item.dart';

class LocalLootDataSource {
  Future<List<LootItem>> loadLoot() async {
    final data = await rootBundle.loadString('assets/data/profile/mock_loot.json');
    final jsonList = jsonDecode(data) as List;
    return jsonList.map((json) => LootItem(
      id: json['id'],
      nom: json['nom'],
      type: json['type'],
      image: json['image'],
      debloque: json['debloque'],
    )).toList();
  }
}

abstract class ILootRemoteDataSource {
  Future<List<LootItem>> fetchLoot();
}
