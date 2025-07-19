import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_profile_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_profile_data_usecase.dart';
import '../../domain/entities/profile.dart';

final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile>(ProfileNotifier.new);

class ProfileNotifier extends AsyncNotifier<Profile> {
  @override
  Future<Profile> build() async {
    final repo = ProfileRepositoryImpl(LocalProfileDataSource());
    final usecase = GetProfileDataUseCase(repo);
    return await usecase();
  }
}
