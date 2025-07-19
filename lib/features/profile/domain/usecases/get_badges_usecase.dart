import '../entities/badge.dart';
import '../repositories/badge_repository.dart';

class GetBadgesUseCase {
  final BadgeRepository repository;
  GetBadgesUseCase(this.repository);

  Future<List<Badge>> call() => repository.getBadges();
}
