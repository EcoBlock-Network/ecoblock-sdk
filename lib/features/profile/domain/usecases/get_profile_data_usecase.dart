import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class GetProfileDataUseCase {
  final ProfileRepository repository;
  GetProfileDataUseCase(this.repository);

  Future<Profile> call() => repository.getProfile();
}
