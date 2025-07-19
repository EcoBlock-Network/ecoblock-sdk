import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ibluetooth_service.dart';
import 'bluetooth_service.dart';

final bluetoothServiceProvider = Provider<IBluetoothService>((ref) {
  // Remplacer par MockBluetoothService pour les tests
  return BluetoothService() as IBluetoothService;
});
