import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/badge.dart';

class LocalBadgeDataSource {
  Future<List<Badge>> loadBadges() async {
    final data = await rootBundle.loadString('assets/data/profile/mock_badges.json');
    final jsonList = jsonDecode(data) as List;
    return jsonList.map((json) => Badge(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      condition: json['condition'],
      unlocked: json['unlocked'],
    )).toList();
  }
}

abstract class IBadgeRemoteDataSource {
  Future<List<Badge>> fetchBadges();
}
