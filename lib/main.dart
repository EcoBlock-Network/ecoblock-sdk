import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/rust/api/simple.dart';
import 'src/rust/frb_generated.dart';
import 'services/bluetooth_service.dart';
import 'services/permission_service.dart';
import 'theme/theme.dart';
import 'features/onboarding/presentation/pages/onboarding_gate.dart';

/// EcoBlock application entry point.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  await PermissionService.checkAndRequest();

  final bluetoothService = BluetoothService();

  runApp(
    ProviderScope(
      child: MyApp(bluetoothService: bluetoothService),
    ),
  );
}

/// Root widget, injects BLE service and provides theme and navigation shell.
class MyApp extends StatelessWidget {
  final BluetoothService bluetoothService;

  const MyApp({super.key, required this.bluetoothService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildAppTheme(),
      supportedLocales: const [
        Locale('en', ''),
      ],
      home: const OnboardingGate(),
    );
  }
}