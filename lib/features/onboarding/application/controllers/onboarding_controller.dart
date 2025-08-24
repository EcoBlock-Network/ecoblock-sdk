import 'package:ecoblock_mobile/services/rust_bridge_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../data/datasources/onboarding_local_data_source.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, bool>((ref) {
  final localDataSource = OnboardingLocalDataSource();
  return OnboardingController(localDataSource);
});

class OnboardingController extends StateNotifier<bool> {
  final OnboardingLocalDataSource localDataSource;
  final RustBridgeService rustApi;

  // Allow injecting a RustBridgeService for tests; default to real implementation.
  OnboardingController(this.localDataSource, {RustBridgeService? rustApi})
      : rustApi = rustApi ?? RustBridgeService(),
        super(false);

  Future<void> associateNode() async {
    try {
      // Vérifie si déjà initialisé (pour éviter le double init)
      final isInit = await rustApi.nodeIsInitialized();
      String nodeId;
      if (!isInit) {
  nodeId = await rustApi.createLocalNode();
  debugPrint('[EcoBlock] Nouveau node créé ! NodeId : $nodeId');
        // Optionnel : tu peux le stocker/localiser ici si besoin
      } else {
  nodeId = await rustApi.getNodeId();
  debugPrint('[EcoBlock] Node déjà initialisé. NodeId : $nodeId');
      }
      await localDataSource.setNodeAssociated(true);
      state = true;
    } catch (e, stack) {
  debugPrint('[EcoBlock] Erreur lors de la création du node : $e');
  debugPrint('Details: ${e.toString()}');
  debugPrint('Stack: $stack');
    }
  }
}
