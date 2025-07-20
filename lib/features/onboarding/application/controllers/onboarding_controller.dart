import 'package:ecoblock_mobile/services/rust_bridge_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/onboarding_local_data_source.dart';
import '../../../../src/rust/api/simple.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, bool>((ref) {
      final localDataSource = OnboardingLocalDataSource();
      return OnboardingController(localDataSource);
    });

class OnboardingController extends StateNotifier<bool> {
  final OnboardingLocalDataSource localDataSource;
  OnboardingController(this.localDataSource) : super(false);

  Future<void> associateNode() async {
    final rustApi = RustBridgeService();
    try {
      // Vérifie si déjà initialisé (pour éviter le double init)
      final isInit = await rustApi.nodeIsInitialized();
      String nodeId;
      if (!isInit) {
        nodeId = await rustApi.createLocalNode();
        print('[EcoBlock] Nouveau node créé ! NodeId : $nodeId');
        // Optionnel : tu peux le stocker/localiser ici si besoin
      } else {
        nodeId = await rustApi.getNodeId();
        print('[EcoBlock] Node déjà initialisé. NodeId : $nodeId');
      }
      await localDataSource.setNodeAssociated(true);
      state = true;
    } catch (e, stack) {
      print('[EcoBlock] Erreur lors de la création du node : $e');
      print('Details: ${e.toString()}');
      print('Stack: $stack');
    }
  }
}
