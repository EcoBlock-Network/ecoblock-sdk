import 'package:flutter_test/flutter_test.dart';
import 'package:ecoblock_mobile/features/onboarding/application/controllers/onboarding_controller.dart';
import 'package:ecoblock_mobile/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:ecoblock_mobile/services/rust_bridge_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// A lightweight fake to avoid invoking platform channels in tests.
class FakeRustBridgeService extends RustBridgeService {
  @override
  Future<String> createLocalNode() async => 'fake-node-id';

  @override
  Future<String> getNodeId() async => 'fake-node-id';

  @override
  Future<bool> nodeIsInitialized() async => false;

  // other methods not needed for this test
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('associateNode met à jour l’état', () async {
  // Provide mock initial values so SharedPreferences calls don't hit platform channels.
  SharedPreferences.setMockInitialValues({});
    final dataSource = OnboardingLocalDataSource();
    final controller = OnboardingController(dataSource, rustApi: FakeRustBridgeService());
    await controller.associateNode();
    expect(controller.state, true);
  });
}
