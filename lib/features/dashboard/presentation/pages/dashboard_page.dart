import 'dart:math';
import 'dart:ui';
import 'dart:convert';
import 'package:ecoblock_mobile/features/story/presentation/story_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/features/quests/presentation/providers/quest_provider.dart';
import 'package:ecoblock_mobile/features/quests/domain/entities/quest.dart';
import 'package:ecoblock_mobile/features/quests/data/models/quest_type.dart';

// Widget timer avant le renouvellement des quêtes
class _DailyQuestTimer extends StatefulWidget {
  @override
  State<_DailyQuestTimer> createState() => _DailyQuestTimerState();
}

class _DailyQuestTimerState extends State<_DailyQuestTimer> {
  late Duration timeLeft;
  late final ticker;

  @override
  void initState() {
    super.initState();
    _updateTime();
    ticker = Stream.periodic(const Duration(seconds: 1), (_) => _updateTime()).listen((_) {});
  }

  void _updateTime() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    setState(() {
      timeLeft = nextMidnight.difference(now);
    });
  }

  @override
  void dispose() {
    ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = timeLeft.inHours;
    final m = timeLeft.inMinutes % 60;
    final s = timeLeft.inSeconds % 60;
    return Row(
      children: [
        Icon(Icons.timer, color: Theme.of(context).colorScheme.primary, size: 18),
        const SizedBox(width: 6),
        Text('Nouvelles quêtes dans : ${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7), fontSize: 13)),
      ],
    );
  }
}

// Widget minimaliste pour une quête avec titre, icône, progression et flèche pour déplier
class _QuestListItem extends StatefulWidget {
  final dynamic quest;
  const _QuestListItem({Key? key, required this.quest}) : super(key: key);
  @override
  State<_QuestListItem> createState() => _QuestListItemState();
}

class _QuestListItemState extends State<_QuestListItem> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => expanded = !expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Row(
              children: [
                Icon(Icons.bolt, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.quest.title,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: scheme.onBackground),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: LinearProgressIndicator(
                    value: (widget.quest.progress) / (widget.quest.goal == 0 ? 1 : widget.quest.goal),
                    backgroundColor: scheme.surface,
                    color: scheme.primary,
                  ),
                ),
                Icon(expanded ? Icons.expand_less : Icons.chevron_right, color: scheme.primary),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.quest.description, style: TextStyle(color: scheme.onBackground.withOpacity(0.8))),
                Text('Objectif : ${widget.quest.goal}', style: TextStyle(color: scheme.primary)),
                Text('Progression : ${widget.quest.progress}/${widget.quest.goal}', style: TextStyle(color: scheme.primary)),
                Text('Du ${widget.quest.startDate.day}/${widget.quest.startDate.month}/${widget.quest.startDate.year} au ${widget.quest.endDate.day}/${widget.quest.endDate.month}/${widget.quest.endDate.year}', style: TextStyle(color: scheme.onBackground.withOpacity(0.6), fontSize: 12)),
              ],
            ),
          ),
        Divider(height: 1, color: scheme.surface),
      ],
    );
  }
}

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
  Future<List<Quest>> _loadUniqueQuests(BuildContext context) async {
    final data = await DefaultAssetBundle.of(context).loadString('assets/data/unique_quests.json');
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((e) => Quest(
      id: e['id'],
      type: QuestTypeExt.fromString(e['type']),
      title: e['title'],
      description: e['description'],
      goal: e['goal'],
      progress: e['progress'],
      startDate: DateTime.parse(e['startDate']),
      endDate: DateTime.parse(e['endDate']),
    )).toList();
  }
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
                    const SizedBox(height: 4),
                    _DailyQuestTimer(),
                    const SizedBox(height: 8),
                    Consumer(
                      builder: (context, ref, _) {
                        final questsAsync = ref.watch(personalQuestsProvider);
                        return questsAsync.when(
                          data: (quests) => Column(
                            children: quests.take(3).map((q) => _QuestListItem(quest: q)).toList(),
                          ),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('Erreur de chargement des quêtes')),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Quêtes communautaires',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: scheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final commQuestsAsync = ref.watch(communityQuestsProvider);
                        return commQuestsAsync.when(
                          data: (quests) => Column(
                            children: [
                              ...quests.take(2).map((q) => _QuestListItem(quest: q)),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (ctx) => Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: ListView(
                                          children: quests.map((q) => _QuestListItem(quest: q)).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Voir plus', style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('Erreur de chargement des quêtes communautaires')),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Quêtes uniques du compte',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: scheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FutureBuilder<List<Quest>>(
                      future: _loadUniqueQuests(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Erreur de chargement des quêtes uniques'));
                        }
                        final quests = snapshot.data ?? [];
                        return Column(
                          children: [
                            ...quests.take(2).map((q) => _QuestListItem(quest: q)),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (ctx) => Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ListView(
                                        children: quests.map((q) => _QuestListItem(quest: q)).toList(),
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Voir plus', style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
// Charge les quêtes uniques du compte depuis le JSON
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
