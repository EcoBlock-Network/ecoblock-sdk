import '../datasources/local_quest_datasource.dart';
import '../datasources/remote_quest_datasource.dart';
import '../models/quest_model.dart';
import '../../domain/entities/quest.dart';
import '../../domain/repositories/quest_repository.dart';

/// Implementation of QuestRepository
class QuestRepositoryImpl implements QuestRepository {
  final LocalQuestDatasource localDatasource;
  final RemoteQuestDatasource remoteDatasource;

  QuestRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<List<Quest>> getPersonalQuests() async {
    final models = await localDatasource.getPersonalQuests();
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<List<Quest>> getCommunityQuests() async {
    final models = await localDatasource.getCommunityQuests();
    return models.map((m) => _toEntity(m)).toList();
  }

  Quest _toEntity(QuestModel model) {
    return Quest(
      id: model.id,
      type: model.type,
      title: model.title,
      description: model.description,
      goal: model.goal,
      progress: model.progress,
      startDate: model.startDate,
      endDate: model.endDate,
    );
  }
}
