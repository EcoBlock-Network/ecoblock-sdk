import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/stats.dart';

class LocalStatsDataSource {
  Future<Stats> loadStats() async {
    final data = await rootBundle.loadString('assets/data/profile/mock_stats.json');
    final json = jsonDecode(data);
    return Stats(
      nbBlocs: json['nbBlocs'],
      nbNodes: json['nbNodes'],
      xpParJour: List<int>.from(json['xpParJour']),
      progression: json['progression'],
      niveau: json['niveau'],
      xp: json['xp'],
    );
  }
}

abstract class IStatsRemoteDataSource {
  Future<Stats> fetchStats();
}
