import '../../domain/entities/badge.dart';
import '../datasources/local_badge_data_source.dart';
import '../../domain/repositories/badge_repository.dart';

class BadgeRepositoryImpl implements BadgeRepository {
  final LocalBadgeDataSource localDataSource;
  BadgeRepositoryImpl(this.localDataSource);

  @override
  Future<List<Badge>> getBadges() => localDataSource.loadBadges();
}
