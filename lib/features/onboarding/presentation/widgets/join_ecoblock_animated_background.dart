import 'package:flutter/cupertino.dart';
import 'package:ecoblock_mobile/theme/theme.dart';

class JoinEcoBlockAnimatedBackground extends StatelessWidget {
  const JoinEcoBlockAnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.onboardingGradientStart, AppColors.onboardingGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
  child: Icon(CupertinoIcons.tree, size: 180, color: AppColors.greenStrong.withAlpha((0.15 * 255).toInt())),
      ),
    );
  }
}
