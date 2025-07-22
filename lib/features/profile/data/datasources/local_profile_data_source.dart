
import 'package:ecoblock_mobile/features/profile/domain/entities/profile.dart';

class LocalProfileDataSource {
  Future<Profile> loadProfile() async {
    throw UnimplementedError('Le profil doit être chargé depuis la persistance réelle.');
  }
}

abstract class IProfileRemoteDataSource {
  Future<Profile> fetchProfile();
}
