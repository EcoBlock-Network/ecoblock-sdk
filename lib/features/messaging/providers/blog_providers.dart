import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/features/messaging/services/blog_service.dart';
import 'package:ecoblock_mobile/core/config.dart';

final blogServiceProvider = Provider<BlogService>((ref) {
  return BlogService(apiKey: kApiKey);
});

final blogsProvider = FutureProvider<List<Blog>>((ref) async {
  final svc = ref.watch(blogServiceProvider);
  return svc.fetchBlogs();
});
