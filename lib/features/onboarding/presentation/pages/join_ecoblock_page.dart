import 'package:ecoblock_mobile/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/join_ecoblock_intro_text.dart';
import '../widgets/join_ecoblock_animated_background.dart';
import '../widgets/join_ecoblock_info_card.dart';
import '../../application/controllers/onboarding_controller.dart';

class JoinEcoBlockPage extends ConsumerWidget {
  const JoinEcoBlockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingControllerProvider.notifier);
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      child: Stack(
        children: [
          const JoinEcoBlockAnimatedBackground(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const JoinEcoBlockIntroText(),
                const SizedBox(height: 32),
                Hero(
                  tag: 'join-node-btn',
                  child: CupertinoButton.filled(
                    child: const Text('Créer mon nœud', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      await controller.associateNode();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 700),
                            pageBuilder: (_, __, ___) => const DashboardPage(),
                            transitionsBuilder: (_, anim, __, child) => FadeTransition(
                              opacity: anim,
                              child: ScaleTransition(scale: anim, child: child),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const JoinEcoBlockInfoCard(),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
