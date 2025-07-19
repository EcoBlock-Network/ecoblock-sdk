import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_badge_data_source.dart';
import '../../data/repositories/badge_repository_impl.dart';
import '../../domain/usecases/get_badges_usecase.dart';
import '../../domain/entities/badge.dart';

final badgeListProvider = AsyncNotifierProvider<BadgeListNotifier, List<Badge>>(BadgeListNotifier.new);

class BadgeListNotifier extends AsyncNotifier<List<Badge>> {
  @override
  Future<List<Badge>> build() async {
    final repo = BadgeRepositoryImpl(LocalBadgeDataSource());
    final usecase = GetBadgesUseCase(repo);
    return await usecase();
  }
}
