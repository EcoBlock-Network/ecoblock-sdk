import 'package:flutter_test/flutter_test.dart';
import 'package:ecoblock_mobile/features/onboarding/application/controllers/onboarding_controller.dart';
import 'package:ecoblock_mobile/features/onboarding/data/datasources/onboarding_local_data_source.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('associateNode met à jour l’état', () async {
    final dataSource = OnboardingLocalDataSource();
    final controller = OnboardingController(dataSource);
    await controller.associateNode();
    expect(controller.state, true);
  });
}
