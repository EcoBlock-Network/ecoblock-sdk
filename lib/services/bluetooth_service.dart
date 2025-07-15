import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter/material.dart';

class BluetoothService {
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  Stream<DiscoveredDevice> scanForDevices() {
    print('[BLE] Démarrage du scan BLE...');
    return _ble.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).map((device) {
      print('[BLE] Appareil détecté: ${device.name}, ${device.id}, RSSI: ${device.rssi}');
      return device;
    });
  }

  Stream<ConnectionStateUpdate> connectToDevice(String id) {
    print('[BLE] Connexion à l’appareil: $id');
    return _ble.connectToDevice(id: id, connectionTimeout: const Duration(seconds: 5)).map((update) {
      print('[BLE] Connexion update: $update');
      return update;
    });
  }

  Future<void> disconnectDevice(String id) async {
    // flutter_reactive_ble ne propose pas de méthode directe, la déconnexion se fait en annulant le stream
    // Ici, on expose une méthode pour la cohérence, mais il faut gérer le cancel du stream côté appelant
  }

  // Exemple lecture caractéristique
  Future<List<int>> readCharacteristic({
    required String deviceId,
    required Uuid serviceUuid,
    required Uuid characteristicUuid,
  }) async {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: characteristicUuid,
      deviceId: deviceId,
    );
    print('[BLE] Lecture caractéristique: service=$serviceUuid, char=$characteristicUuid, device=$deviceId');
    final result = await _ble.readCharacteristic(characteristic);
    print('[BLE] Valeur lue: $result');
    return result;
  }

  // Exemple écriture caractéristique
  Future<void> writeCharacteristic({
    required String deviceId,
    required Uuid serviceUuid,
    required Uuid characteristicUuid,
    required List<int> value,
  }) async {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: characteristicUuid,
      deviceId: deviceId,
    );
    print('[BLE] Écriture caractéristique: service=$serviceUuid, char=$characteristicUuid, device=$deviceId, value=$value');
    await _ble.writeCharacteristicWithResponse(characteristic, value: value);
    print('[BLE] Écriture terminée');
  }

  // Exemple abonnement à une caractéristique
  Stream<List<int>> subscribeToCharacteristic({
    required String deviceId,
    required Uuid serviceUuid,
    required Uuid characteristicUuid,
  }) {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: characteristicUuid,
      deviceId: deviceId,
    );
    print('[BLE] Abonnement caractéristique: service=$serviceUuid, char=$characteristicUuid, device=$deviceId');
    return _ble.subscribeToCharacteristic(characteristic).map((data) {
      print('[BLE] Notification reçue: $data');
      return data;
    });
  }
}
