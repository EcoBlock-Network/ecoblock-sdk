import '../../domain/entities/profile.dart';
import '../datasources/local_profile_data_source.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final LocalProfileDataSource localDataSource;
  ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<Profile> getProfile() => localDataSource.loadProfile();
}
