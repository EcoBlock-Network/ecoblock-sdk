import '../entities/quest.dart';
import '../repositories/quest_repository.dart';

/// Use case to get personal quests
class GetPersonalQuests {
  final QuestRepository repository;
  GetPersonalQuests(this.repository);

  Future<List<Quest>> call() async {
    return await repository.getPersonalQuests();
  }
}
