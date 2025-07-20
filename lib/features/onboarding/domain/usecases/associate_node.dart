import '../../data/datasources/onboarding_local_data_source.dart';

class AssociateNode {
  final OnboardingLocalDataSource localDataSource;
  AssociateNode(this.localDataSource);

  Future<void> call() async {
    await localDataSource.setNodeAssociated(true);
  }
}
