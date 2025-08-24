import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/quest_service_provider.dart';
import '../../domain/entities/quest.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

final uniqueQuestsProvider = FutureProvider.autoDispose<List<Quest>>((ref) async {
  final service = ref.read(questServiceProvider);
  final all = await service.loadUniqueQuests();
  final profileAsync = ref.watch(profileProvider);
  final completed = profileAsync.maybeWhen(data: (p) => p.completedUniqueQuestIds, orElse: () => <String>[]);
  return all.where((q) => !completed.contains(q.id)).toList();
});
