import '../entities/quest.dart';

/// Abstract repository for quests
abstract class QuestRepository {
  Future<List<Quest>> getPersonalQuests();
  Future<List<Quest>> getCommunityQuests();
}
