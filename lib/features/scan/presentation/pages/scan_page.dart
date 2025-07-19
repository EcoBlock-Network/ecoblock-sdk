import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final scanProvider = StateNotifierProvider<ScanNotifier, bool>((ref) {
  return ScanNotifier();
});

class ScanNotifier extends StateNotifier<bool> {
  ScanNotifier() : super(false);
  void startScan() => state = true;
  void stopScan() => state = false;
}

class ScanPage extends ConsumerWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScanning = ref.watch(scanProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.radar, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              isScanning ? 'Scan en cours...' : 'Scanner le réseau BLE...',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              child: Text(isScanning ? 'Arrêter le scan' : 'Lancer un scan'),
              onPressed: () {
                if (isScanning) {
                  ref.read(scanProvider.notifier).stopScan();
                } else {
                  ref.read(scanProvider.notifier).startScan();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
