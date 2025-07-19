abstract class IBluetoothService {
  Future<bool> isBluetoothEnabled();
  Future<void> startScan();
  Future<void> stopScan();
  Future<void> connect(String deviceId);
  Future<void> disconnect(String deviceId);
  Stream<List<String>> get discoveredDevices;
  Stream<String> get connectionStatus;
}
