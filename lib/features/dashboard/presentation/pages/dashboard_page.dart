import 'dart:math';
import 'dart:ui';
// ...existing code...
import 'package:ecoblock_mobile/features/story/presentation/story_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/features/quests/presentation/providers/quest_provider.dart';
import 'package:ecoblock_mobile/features/quests/presentation/widgets/quest_card.dart';

final dashboardProgressProvider = StateNotifierProvider<DashboardProgressNotifier, double>((ref) {
  return DashboardProgressNotifier();
});

class DashboardProgressNotifier extends StateNotifier<double> {
  DashboardProgressNotifier() : super(0.72);
  void setProgress(double value) => state = value;
}

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: 4,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('Tapped story $i');
                      final storyGroup = StoryGroup(
                        ownerName: 'User $i',
                        ownerAvatar: 'https://placehold.co/64x64',
                        items: [
                          StoryItem(
                            url: 'https://placehold.co/600x400',
                            type: StoryType.image,
                            duration: const Duration(seconds: 5),
                          ),
                          StoryItem(
                            url: 'https://placehold.co/600x400',
                            type: StoryType.image,
                            duration: const Duration(seconds: 5),
                          ),
                        ],
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => StoryViewer(storyGroup: storyGroup),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [scheme.primary, scheme.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: scheme.primary,
                              width: 2.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.5),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage('https://placehold.co/64x64?text=Admin'),
                              backgroundColor: scheme.surface,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Story ${i + 1}',
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mon Arbre',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: scheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: CustomPaint(
                              painter: _CircleProgressPainter(
                                progress: _progressAnim.value,
                                colorStart: scheme.primary,
                                colorEnd: scheme.secondary,
                              ),
                            ),
                          ),
                          Icon(Icons.eco, size: 80, color: scheme.primary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '${(_progressAnim.value * 100).round()}% de progression aujourd\'hui',
                        style: TextStyle(
                          color: scheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Quêtes du jour',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: scheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Consumer(
                      builder: (context, ref, _) {
                        final questsAsync = ref.watch(personalQuestsProvider);
                        return questsAsync.when(
                          data: (quests) => Column(
                            children: quests.map((q) => 
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: QuestCard(key: ValueKey(q.id), quest: q),
                              )
                            ).toList(),
                          ),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('Erreur de chargement des quêtes')), 
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color colorStart;
  final Color colorEnd;

  _CircleProgressPainter({
    required this.progress,
    required this.colorStart,
    required this.colorEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final bgPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      colors: [colorStart, colorEnd],
    );
    final fgPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_CircleProgressPainter old) {
    return old.progress != progress;
  }
}
