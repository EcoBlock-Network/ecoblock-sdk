
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: EcoBlockApp()));
}

class EcoBlockApp extends StatelessWidget {
  const EcoBlockApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoBlock',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Scaffold(
        body: Center(child: Text('EcoBlock App Structure Ready')),
      ),
    );
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  await checkAndRequestPermissions();
  // Démarre advertising mesh BLE au lancement
  final bluetoothService = BluetoothService();
  runApp(MyApp(bluetoothService: bluetoothService));
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
  final BluetoothService bluetoothService;
  const MyApp({super.key, required this.bluetoothService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', ''),
      ],
      home: Scaffold(
        appBar: AppBar(title: const Text('EcoBlock Mesh BLE')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('EcoBlock Mesh BLE'),
              const SizedBox(height: 20),
              Builder(
                builder: (buttonContext) => Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        print('[UI] Scan Mesh demandé');
                        showDialog(
                          context: buttonContext,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Mesh Neighbors'),
                            content: SizedBox(
                              height: 200,
                              width: 300,
                              child: StreamBuilder(
                                stream: bluetoothService.scanForMeshNodes(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Text('Scanning mesh...');
                                  }
                                  final device = snapshot.data;
                                  if (device == null) {
                                    return const Text('Aucun voisin mesh trouvé');
                                  }
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Nom: ${device.name}'),
                                      Text('ID: ${device.id}'),
                                      Text('RSSI: ${device.rssi}'),
                                      ElevatedButton(
                                        onPressed: () async {
                                          print('[UI] Connexion auto à ${device.id}');
                                          bluetoothService.connectToMeshNode(device.id).listen((update) {
                                            print('[UI] Connexion update: $update');
                                          });
                                        },
                                        child: const Text('Connecter'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          print('[UI] Relais message vers ${device.id}');
                                          await bluetoothService.relayMeshMessage(
                                            device.id,
                                            Uuid.parse(bluetoothService.meshServiceUuid),
                                            Uuid.parse(bluetoothService.meshServiceUuid),
                                            // Add the missing fourth argument, for example an empty List<int> as message payload
                                            <int>[]
                                          );
                                        },
                                        child: const Text('Relayer message'),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Fermer'))],
                          ),
                        );
                      },
                      child: const Text('Scanner Mesh BLE'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        print('[UI] Démarrage serveur GATT local');
                        await bluetoothService.startGattServer("node-ecoblock-123");
                      },
                      child: const Text('Start GATT Server'),
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