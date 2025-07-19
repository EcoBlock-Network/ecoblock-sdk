import '../../domain/entities/stats.dart';
import '../datasources/local_stats_data_source.dart';
import '../../domain/repositories/stats_repository.dart';

class StatsRepositoryImpl implements StatsRepository {
  final LocalStatsDataSource localDataSource;
  StatsRepositoryImpl(this.localDataSource);

  @override
  Future<Stats> getStats() => localDataSource.loadStats();
}
