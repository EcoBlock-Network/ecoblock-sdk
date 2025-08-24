import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/settings/presentation/pages/settings_page.dart';

import 'src/rust/frb_generated.dart';
import 'services/bluetooth_service.dart';
import 'services/permission_service.dart';
import 'theme/theme.dart';
import 'features/onboarding/presentation/pages/onboarding_gate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
class MyApp extends ConsumerWidget {
  final BluetoothService bluetoothService;

  const MyApp({super.key, required this.bluetoothService});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    return MaterialApp(
      theme: buildAppTheme(),
      supportedLocales: const [Locale('en', ''), Locale('fr', '')],
      locale: Locale(lang),
      localizationsDelegates: const [
        // Basic material/localization delegates
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const OnboardingGate(),
    );
  }
}