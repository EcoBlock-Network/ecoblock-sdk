import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/services/locator.dart';
import 'package:ecoblock_mobile/services/communication_service.dart';

final blogsProvider = FutureProvider<List<CommItem>>((ref) async {
  final svc = ref.watch(communicationServiceProvider);
  return svc.fetchBlogs();
});
