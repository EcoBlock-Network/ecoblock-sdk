import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kernel_api.dart';
import 'network_service.dart';
import 'rust_bridge_service.dart';
import 'bluetooth_service.dart';
import 'ibluetooth_service.dart';
import 'communication_service.dart';

final apiBaseUrlProvider = Provider<String>((ref) => 'http://ecoblock.fr');

final kernelApiProvider = Provider<KernelApi>((ref) {
  final base = ref.watch(apiBaseUrlProvider);
  return KernelApi(baseUrl: base);
});

final networkServiceProvider = Provider<NetworkService>((ref) {
  final base = ref.watch(apiBaseUrlProvider);
  return NetworkService(baseUrl: base);
});

final rustBridgeServiceProvider = Provider<RustBridgeService>((ref) {
  return RustBridgeService();
});

final bluetoothServiceProvider = Provider<IBluetoothService>((ref) {
  return BluetoothService() as IBluetoothService;
});

final apiKeyProvider = Provider<String>((ref) => const String.fromEnvironment('ECO_API_KEY', defaultValue: ''));

final communicationServiceProvider = Provider<CommunicationService>((ref) {
  final base = ref.watch(apiBaseUrlProvider);
  final key = ref.watch(apiKeyProvider);
  return CommunicationService(baseUrl: base, apiKey: key);
});