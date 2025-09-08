import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ibluetooth_service.dart';
import 'bluetooth_service.dart';

final bluetoothServiceProvider = Provider<IBluetoothService>((ref) {
  return BluetoothService() as IBluetoothService;
});
