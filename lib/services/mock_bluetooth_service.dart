import 'ibluetooth_service.dart';
import 'dart:async';

class MockBluetoothService implements IBluetoothService {
  final _devicesController = StreamController<List<String>>.broadcast();
  final _statusController = StreamController<String>.broadcast();

  @override
  Future<bool> isBluetoothEnabled() async => true;

  @override
  Future<void> startScan() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _devicesController.add(['MockDevice1', 'MockDevice2']);
  }

  @override
  Future<void> stopScan() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _devicesController.add([]);
  }

  @override
  Future<void> connect(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _statusController.add('connected:$deviceId');
  }

  @override
  Future<void> disconnect(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _statusController.add('disconnected:$deviceId');
  }

  @override
  Stream<List<String>> get discoveredDevices => _devicesController.stream;

  @override
  Stream<String> get connectionStatus => _statusController.stream;
}
