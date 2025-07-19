


import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/src/rust/api/simple.dart';
import 'package:ecoblock_mobile/src/rust/frb_generated.dart';
import 'package:ecoblock_mobile/services/bluetooth_service.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'app_shell.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


final forestLightScheme = ColorScheme(
  brightness: Brightness.light,

  // Couleurs principales
  primary: Color(0xFF6E7426),      // Vert olive dense (#6e7426)
  onPrimary: Color(0xFFFBEFDF),    // Ivoire doux (#fbefdf) - excellent contraste

  secondary: Color(0xFF957C4F),    // Brun olive (#957c4f)
  onSecondary: Color(0xFFFBFDF0),  // Clair pour contraste sur brun

  // Arrière-plan principal
  background: Color(0xFFFBEFDF),   // Ivoire (#fbefdf)
  onBackground: Color(0xFF120E09), // Noir forêt (#120e09)

  // Surface (cartes, feuilles)
  surface: Color(0xFFEFD5B7),      // Beige clair (#efd5b7)
  onSurface: Color(0xFF3F321B),    // Brun profond (#3f321b)

  // Couleur d’erreur
  error: Color(0xFF6D5438),        // Terre brûlée (#6d5438)
  onError: Color(0xFFFBEFDF),      // Ivoire clair

  // Tertiaire (support neutre, accents complémentaires)
  tertiary: Color(0xFF50551D),     // Vert forêt (#50551d)
  onTertiary: Color(0xFFFBEFDF),   // Ivoire

  // Optionnelles (si besoin de plus de nuances dans votre design system)
  primaryContainer: Color(0xFFA5A954),   // Vert mousse
  secondaryContainer: Color(0xFF726055), // Brun rosé
  tertiaryContainer: Color(0xFFCFB580),  // Sable doré
  outline: Color(0xFF523B2B),            // Brun foncé
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  await checkAndRequestPermissions();
  // Démarre advertising mesh BLE au lancement
  final bluetoothService = BluetoothService();
  runApp(
    ProviderScope(
      child: MyApp(bluetoothService: bluetoothService),
    ),
  );
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: forestLightScheme,               //  [oai_citation:0‡api.flutter.dev](https://api.flutter.dev/flutter/material/ThemeData/colorScheme.html?utm_source=chatgpt.com)
        textTheme: Typography.material2021().black.apply(
              bodyColor: forestLightScheme.onBackground,
              displayColor: forestLightScheme.onBackground,
            ),
      ),      supportedLocales: const [
        Locale('en', ''),
      ],
      home: AppShell(),
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


