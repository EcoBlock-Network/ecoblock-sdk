import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluetoothServiceProvider = Provider<BluetoothService>((ref) {
  return BluetoothService();
});

class BluetoothService {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  // Advertising BLE désactivé, on prépare le serveur GATT
  final String meshServiceUuid = "0000181C-0000-1000-8000-00805f9b34fb"; // exemple UUID mesh
  final String meshDeviceName = "EcoBlockMeshNode";

  // Scan continu pour découvrir les voisins mesh
  Stream<DiscoveredDevice> scanForMeshNodes() {
  debugPrint('[MESH] Scan BLE mesh...');
    return _ble.scanForDevices(
      withServices: [Uuid.parse(meshServiceUuid)],
      scanMode: ScanMode.lowLatency,
    ).map((device) {
  debugPrint('[MESH] Mesh node détecté: ${device.name}, ${device.id}, RSSI: ${device.rssi}');
      return device;
    });
  }
  // Démarrage du serveur GATT (à compléter avec natif ou plugin)
    static const MethodChannel _channel = MethodChannel('ecoblock/gatt_server');
  Future<void> startGattServer(String nodeId) async {
  debugPrint('[GATT] Démarrage serveur GATT avec nodeId: $nodeId');
    await _channel.invokeMethod('startGattServer', {'nodeId': nodeId});
  }

  // Connexion automatique à un nœud mesh détecté (client BLE)
  Stream<ConnectionStateUpdate> connectToMeshNode(String id) {
    debugPrint('[MESH] Connexion auto à un mesh node: $id');
    return _ble.connectToDevice(id: id, connectionTimeout: const Duration(seconds: 5)).map((update) {
      debugPrint('[MESH] Connexion update: $update');
      return update;
    });
  }
  // Relais de message mesh (à compléter selon ta logique métier)
  Future<void> relayMeshMessage(String deviceId, Uuid serviceUuid, Uuid characteristicUuid, List<int> message) async {
  debugPrint('[MESH] Relais message vers $deviceId');
    await writeCharacteristic(
      deviceId: deviceId,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      value: message,
    );
  debugPrint('[MESH] Message relayé');
  }

  Future<void> disconnectDevice(String id) async {
    // flutter_reactive_ble ne propose pas de méthode directe, la déconnexion se fait en annulant le stream
    // Ici, on expose une méthode pour la cohérence, mais il faut gérer le cancel du stream côté appelant
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
  debugPrint('[BLE] Écriture caractéristique: service=$serviceUuid, char=$characteristicUuid, device=$deviceId, value=$value');
    await _ble.writeCharacteristicWithResponse(characteristic, value: value);
  debugPrint('[BLE] Écriture terminée');
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
    debugPrint('[BLE] Abonnement caractéristique: service=$serviceUuid, char=$characteristicUuid, device=$deviceId');
    return _ble.subscribeToCharacteristic(characteristic).map((data) {
      debugPrint('[BLE] Notification reçue: $data');
      return data;
    });
  }
}
