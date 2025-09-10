import 'package:ecoblock_mobile/features/onboarding/presentation/pages/join_ecoblock_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/onboarding/presentation/pages/onboarding_flow_page.dart';

import 'src/rust/frb_generated.dart';
import 'services/bluetooth_service.dart';
import 'services/permission_service.dart';
import 'theme/theme.dart';
import 'app_shell.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  await PermissionService.checkAndRequest();

  final bluetoothService = BluetoothService();

  runApp(ProviderScope(child: MyApp(bluetoothService: bluetoothService)));
}

class MyApp extends ConsumerWidget {
  final BluetoothService bluetoothService;

  const MyApp({super.key, required this.bluetoothService});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final themeMode = ref.watch(themeProvider);
  return MaterialApp(
      theme: buildAppTheme(brightness: Brightness.light),
      darkTheme: buildAppTheme(brightness: Brightness.dark),
      themeMode: themeMode,
      supportedLocales: const [Locale('en', ''), Locale('fr', '')],
      locale: Locale(lang),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AppShell(),
      routes: {
        '/onboarding': (_) => const OnboardingFlowPage(),
        '/app': (_) => const AppShell(),
      },
    );
  }
}
