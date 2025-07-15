

import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/src/rust/api/simple.dart';
import 'package:ecoblock_mobile/src/rust/frb_generated.dart';
import 'package:ecoblock_mobile/services/bluetooth_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  // Vérification et demande des permissions BLE/Localisation
  await checkAndRequestPermissions();
  runApp(const MyApp());
}

Future<void> checkAndRequestPermissions() async {
  final bluetoothScan = await Permission.bluetoothScan.status;
  final bluetoothConnect = await Permission.bluetoothConnect.status;
  final location = await Permission.location.status;
  print('[PERM] BluetoothScan: $bluetoothScan, BluetoothConnect: $bluetoothConnect, Location: $location');
  if (!bluetoothScan.isGranted) {
    final res = await Permission.bluetoothScan.request();
    print('[PERM] Request BluetoothScan: $res');
  }
  if (!bluetoothConnect.isGranted) {
    final res = await Permission.bluetoothConnect.request();
    print('[PERM] Request BluetoothConnect: $res');
  }
  if (!location.isGranted) {
    final res = await Permission.location.request();
    print('[PERM] Request Location: $res');
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bluetoothService = BluetoothService();
    return MaterialApp(
      supportedLocales: const [
        Locale('en', ''),
      ],
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Action: Call Rust `greet("Tom")`\nResult: `${greet(name: "Tom")}`',
              ),
              const SizedBox(height: 20),
              Builder(
                builder: (buttonContext) => Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => displayTangleSize(buttonContext),
                      child: const Text('Afficher la taille du Tangle'),
                    ),
                    ElevatedButton(
                      onPressed: () => displayCreateBlock(buttonContext),
                      child: const Text('Créer un bloc'),
                    ),
                    ElevatedButton(
                      onPressed: () => displayAddPeerConnection(buttonContext),
                      child: const Text('Ajouter une connexion peer'),
                    ),
                    ElevatedButton(
                      onPressed: () => displayListPeers(buttonContext),
                      child: const Text('Lister les voisins d’un peer'),
                    ),
                    ElevatedButton(
                      onPressed: () => displayPublicKey(buttonContext),
                      child: const Text('Afficher la clé publique'),
                    ),
                    ElevatedButton(
                      onPressed: () => displayPropagateBlock(buttonContext),
                      child: const Text('Propager un bloc'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        print('[UI] Scan Bluetooth demandé');
                        showDialog(
                          context: buttonContext,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Scan Bluetooth'),
                            content: SizedBox(
                              height: 200,
                              width: 300,
                              child: StreamBuilder(
                                stream: bluetoothService.scanForDevices(),
                                builder: (context, snapshot) {
                                  print('[UI] Scan snapshot: ${snapshot.connectionState}, hasData: ${snapshot.hasData}');
                                  if (!snapshot.hasData) {
                                    return const Text('Scanning...');
                                  }
                                  final device = snapshot.data;
                                  if (device == null) {
                                    return const Text('Aucun appareil trouvé');
                                  }
                                  print('[UI] Device trouvé: ${device.name}, ${device.id}, RSSI: ${device.rssi}');
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Nom: ${device.name}'),
                                      Text('ID: ${device.id}'),
                                      Text('RSSI: ${device.rssi}'),
                                    ],
                                  );
                                },
                              ),
                            ),
                            actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Fermer'))],
                          ),
                        );
                      },
                      child: const Text('Scanner Bluetooth'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> displayTangleSize(BuildContext context) async {
  final size = await frbGetTangleSize();
  print('[DART] Tangle size: $size');
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Tangle Size'),
      content: Text('Current tangle size: $size'),
      actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
    ),
  );
}


Future<void> displayCreateBlock(BuildContext context) async {
  final sensorData = {
    "pm25": 12.5,
    "co2": 420.0,
    "temperature": 22.3,
    "humidity": 55.0,
    "timestamp": DateTime.now().millisecondsSinceEpoch
  };
  print('[DART] SensorData envoyé: $sensorData');
  final data = utf8.encode(jsonEncode(sensorData));
  final parents = <String>[];
  final id = await frbCreateBlock(data: data, parents: parents);
  print('[DART] Bloc créé, id: $id');
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Bloc créé'),
      content: Text('ID du bloc: $id'),
      actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
    ),
  );
}

Future<void> displayAddPeerConnection(BuildContext context) async {
  print('[DART] Ajout connexion peerA -> peerB, poids 1.0');
  await frbAddPeerConnection(from: 'peerA', to: 'peerB', weight: 1.0);
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Connexion ajoutée'),
      content: const Text('peerA -> peerB (poids 1.0)'),
      actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
    ),
  );
}

Future<void> displayListPeers(BuildContext context) async {
  final peers = await frbListPeers(peerId: 'peerA');
  print('[DART] Voisins de peerA: $peers');
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Voisins de peerA'),
      content: Text('Peers: ${peers.join(", ")}'),
      actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
    ),
  );
}

Future<void> displayPublicKey(BuildContext context) async {
  final key = await frbGetPublicKey();
  print('[DART] Clé publique hex: $key');
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Clé publique'),
      content: Text('Hex: $key'),
      actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
    ),
  );
}

Future<void> displayPropagateBlock(BuildContext context) async {
  final sensorData = {
    "pm25": 12.5,
    "co2": 420.0,
    "temperature": 22.3,
    "humidity": 55.0,
    "timestamp": DateTime.now().millisecondsSinceEpoch
  };
  print('[DART] SensorData propagé: $sensorData');
  final data = utf8.encode(jsonEncode(sensorData));
  final parents = <String>[];
  final id = await frbPropagateBlock(data: data, parents: parents);
  print('[DART] Bloc propagé, id: $id');
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Bloc propagé'),
      content: Text('ID du bloc: $id'),
      actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
    ),
  );
}