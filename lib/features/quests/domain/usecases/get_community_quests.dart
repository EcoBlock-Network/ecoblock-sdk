import '../entities/quest.dart';
import '../repositories/quest_repository.dart';

/// Use case to get community quests
class GetCommunityQuests {
  final QuestRepository repository;
  GetCommunityQuests(this.repository);

  Future<List<Quest>> call() async {
    return await repository.getCommunityQuests();
  }
}
