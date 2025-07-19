import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/quest.dart';
import '../../data/datasources/local_quest_datasource.dart';
import '../../data/datasources/remote_quest_datasource.dart';
import '../../data/repositories/quest_repository_impl.dart';
import '../../domain/usecases/get_personal_quests.dart';
import '../../domain/usecases/get_community_quests.dart';

final _localDatasource = LocalQuestDatasource();
final _remoteDatasource = RemoteQuestDatasource();
final _repository = QuestRepositoryImpl(
  localDatasource: _localDatasource,
  remoteDatasource: _remoteDatasource,
);

final personalQuestsProvider = FutureProvider<List<Quest>>((ref) async {
  final usecase = GetPersonalQuests(_repository);
  return await usecase();
});

final communityQuestsProvider = FutureProvider<List<Quest>>((ref) async {
  final usecase = GetCommunityQuests(_repository);
  return await usecase();
});
