import 'dart:async';
import 'dart:ui';
import 'package:ecoblock_mobile/core/providers/dashboard_providers.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/shared/widgets/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/eco_dashboard_header.dart';
import '../widgets/eco_section_title.dart';
import '../widgets/eco_progress_circle.dart';
import '../widgets/eco_daily_quests_list.dart';
import '../widgets/eco_quest_card.dart';
import '../../services/quest_service.dart';


/// ---------------------
/// PROVIDER / STATE LAYER
/// ---------------------

final dashboardProgressProvider =
    StateNotifierProvider<DashboardProgressNotifier, double>((ref) {
  return DashboardProgressNotifier();
});

class DashboardProgressNotifier extends StateNotifier<double> {
  DashboardProgressNotifier() : super(0.0);
  void setProgress(double value) => state = value;
}

final personalQuestsProvider = FutureProvider<List<Quest>>((ref) async {
  final service = QuestService();
  return await service.loadPersonalQuests();
});

/// ---------------------
/// UI LAYER - MAIN PAGE
/// ---------------------

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
    with SingleTickerProviderStateMixin {
  int _currentLevel = 1;
  bool _showLevelUp = false;
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    final progress = ref.read(dashboardProgressProvider);
    _progressAnim = Tween<double>(begin: 0, end: progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    )..addListener(() => setState(() {}));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<Quest>> _loadUniqueQuests() async {
    final service = QuestService();
    return await service.loadUniqueQuests();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final newLevel = 1 + (_progressAnim.value * 5).floor();
    if (newLevel > _currentLevel) {
      _currentLevel = newLevel;
      _showLevelUp = true;
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _showLevelUp = false);
      });
    }

    return Scaffold(
      backgroundColor: scheme.background,
      body:  
      AnimatedEcoBackground(
        child: Stack(
          children: [
            Positioned(
              top: -70,
              left: -80,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      scheme.primary.withOpacity(0.13),
                      Colors.transparent,
                    ],
                    radius: 0.9,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      scheme.tertiaryContainer.withOpacity(0.12),
                      Colors.transparent,
                    ],
                    radius: 0.9,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 16, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EcoDashboardHeader(currentLevel: _currentLevel),
                    const SizedBox(height: 22),
                    Center(
                      child: EcoProgressCircle(
                        progress: _progressAnim.value,
                        level: _currentLevel,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Center(
                      child: Text(
                        '${(_progressAnim.value * 100).round()}% profile completed',
                        style: TextStyle(
                          color: scheme.onBackground.withOpacity(0.58),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    /// DAILY QUESTS
                    EcoSectionTitle(
                      title: 'Daily Quests',
                      icon: Icons.eco,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: EcoDailyQuestsList(),
                    ),
                    const SizedBox(height: 28),

                    /// UNIQUE QUESTS
                    EcoSectionTitle(title: 'Unique Quests', icon: Icons.star),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: FutureBuilder<List<Quest>>(
                        future: _loadUniqueQuests(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Loading error'));
                          }
                          final quests = snapshot.data ?? [];
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: quests
                                  .map((q) => EcoQuestCard(
                                        quest: q,
                                        small: true,
                                        vibrant: true,
                                      ))
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),

            /// OVERLAY – Level up
            if (_showLevelUp)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.48),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) => LinearGradient(
                            colors: [scheme.primary, Colors.yellow.shade300],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(rect),
                          child: Icon(Icons.emoji_events, color: Colors.white, size: 86),
                        ),
                        const SizedBox(height: 12),
                        Text('Level Up!',
                            style: TextStyle(
                              color: scheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 31,
                              shadows: [Shadow(color: Colors.white, blurRadius: 10)],
                            )),
                        const SizedBox(height: 6),
                        Text('Level $_currentLevel unlocked',
                            style: TextStyle(
                              color: scheme.onPrimary,
                              fontSize: 18,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

