import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_stats_data_source.dart';
import '../../data/repositories/stats_repository_impl.dart';
import '../../domain/usecases/get_stats_usecase.dart';
import '../../domain/entities/stats.dart';

final statsProvider = AsyncNotifierProvider<StatsNotifier, Stats>(StatsNotifier.new);

class StatsNotifier extends AsyncNotifier<Stats> {
  @override
  Future<Stats> build() async {
    final repo = StatsRepositoryImpl(LocalStatsDataSource());
    final usecase = GetStatsUseCase(repo);
    return await usecase();
  }
}
