import 'package:ecoblock_mobile/services/rust_bridge_service.dart';
import 'package:ecoblock_mobile/services/memory_service.dart';
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
  final MemoryService memory;

  OnboardingController(this.localDataSource,
      {RustBridgeService? rustApi, MemoryService? memorySvc})
      : rustApi = rustApi ?? RustBridgeService(),
        memory = memorySvc ?? memoryService,
        super(false);

  Future<String?> associateNode() async {
    try {
      final isInit = await rustApi.nodeIsInitialized();
      String nodeId;
      if (!isInit) {
  nodeId = await rustApi.createLocalNode();
  debugPrint('[EcoBlock] Nouveau node créé ! NodeId : $nodeId');
      } else {
  nodeId = await rustApi.getNodeId();
  debugPrint('[EcoBlock] Node déjà initialisé. NodeId : $nodeId');
      }
      await localDataSource.setNodeAssociated(true);
      // store nodeId in memory for quick access by other parts of the app
      try {
        memory.write<String>('nodeId', nodeId);
      } catch (e) {
        debugPrint('[OnboardingController] Failed to write nodeId to MemoryService: $e');
      }
      state = true;
      return nodeId;
    } catch (e, stack) {
  debugPrint('[EcoBlock] Erreur lors de la création du node : $e');
  debugPrint('Details: ${e.toString()}');
  debugPrint('Stack: $stack');
      return null;
    }
  }
}
