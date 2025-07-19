import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/profile.dart';

class LocalProfileDataSource {
  Future<Profile> loadProfile() async {
    final data = await rootBundle.loadString('assets/data/profile/mock_stats.json');
    final json = jsonDecode(data);
    return Profile(
      userId: 'user1',
      pseudonyme: 'EcoUser',
      avatar: 'assets/images/avatar.png',
      xp: json['xp'],
      niveau: json['niveau'],
    );
  }
}

abstract class IProfileRemoteDataSource {
  Future<Profile> fetchProfile();
}
