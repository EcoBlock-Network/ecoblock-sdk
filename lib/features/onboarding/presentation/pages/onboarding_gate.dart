import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/features/onboarding/presentation/pages/join_ecoblock_page.dart';
import 'package:ecoblock_mobile/app_shell.dart';
import 'package:ecoblock_mobile/features/onboarding/data/datasources/onboarding_local_data_source.dart';

class OnboardingGate extends StatefulWidget {
  const OnboardingGate({Key? key}) : super(key: key);

  @override
  State<OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends State<OnboardingGate> {
  bool? _isAssociated;

  @override
  void initState() {
    super.initState();
    _checkAssociation();
  }

  Future<void> _checkAssociation() async {
    final ds = OnboardingLocalDataSource();
    final isAssociated = await ds.isNodeAssociated();
    setState(() => _isAssociated = isAssociated);
  }

  @override
  Widget build(BuildContext context) {
    if (_isAssociated == null) {
      return const CupertinoPageScaffold(child: Center(child: CupertinoActivityIndicator()));
    }
    return _isAssociated!
        ? const AppShell()
        : const JoinEcoBlockPage();
  }
}
