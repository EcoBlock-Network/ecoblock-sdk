import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kernel_api.dart';

// Configure this provider with your API_BASE_URL in app startup
final apiBaseUrlProvider = Provider<String>((ref) => 'http://127.0.0.1:3000');

final kernelApiProvider = Provider<KernelApi>((ref) {
  final base = ref.watch(apiBaseUrlProvider);
  return KernelApi(baseUrl: base);
});
