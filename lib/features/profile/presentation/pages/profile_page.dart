import 'dart:ui';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import 'package:ecoblock_mobile/services/memory_service.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/eco_dashboard_header.dart';
import '../providers/profile_provider.dart';
import 'dart:math';
import '../widgets/node_card.dart';
import '../widgets/impact_card.dart';
import '../widgets/activity_feed.dart';
import '../widgets/quick_toggles.dart';
import '../widgets/data_usage_graph.dart';
import '../widgets/wallet_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.background,
      body: EcoPageBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: profileAsync.when(
              data: (profile) {
                final sampleBadges = [
                  {'id': 'b1', 'title': 'Network Starter', 'unlocked': true},
                  {'id': 'b2', 'title': 'Data Relayer', 'unlocked': true},
                  {'id': 'b3', 'title': 'Community Helper', 'unlocked': false},
                  {'id': 'b4', 'title': 'Tree Planter', 'unlocked': false},
                  {'id': 'b5', 'title': 'Marathoner', 'unlocked': true},
                ];

    // determine if this is a fresh/new profile (no persisted userId)
    final bool isNew = profile.userId.isEmpty;
    final String? memNodeId = memoryService.read<String>('nodeId');

    return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EcoDashboardHeader(currentLevel: profile.niveau),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: NodeCard(
      nodeId: memNodeId ?? (isNew ? '0' : 'local-${profile.niveau}'),
      addr: isNew ? '0' : 'node-${profile.niveau}.local',
      latency: isNew ? '0 ms' : '${50 + (profile.xp.toInt() % 150)} ms',
      connected: !isNew,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [scheme.primary.withOpacity(0.14), scheme.primary.withOpacity(0.06)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: scheme.primary.withOpacity(0.12)),
                                  boxShadow: [BoxShadow(color: scheme.primary.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 6))],
                                ),
                                child: Icon(Icons.person, size: 48, color: scheme.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mon Tangle', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                                const SizedBox(height: 6),
                                Text('Visualisation réseau & données collectées', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: 64,
                                height: 64,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(value: profile.xp / 1000.0, strokeWidth: 6, color: scheme.primary, backgroundColor: scheme.onSurface.withOpacity(0.04)),
                                    Text('${((profile.xp / 10.0)).toInt()}%', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              IconButton(
                                icon: Icon(Icons.share, color: scheme.primary),
                                tooltip: 'Partager le profil',
                                onPressed: () {
                                  final snapshot = {'niveau': profile.niveau, 'xp': profile.xp};
                                  final json = jsonEncode(snapshot);
                                  showModalBottomSheet<void>(
                                    context: context,
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                    ),
                                    builder: (ctx) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Row(children: [
                                            const Icon(Icons.share, size: 28),
                                            const SizedBox(width: 12),
                                            Expanded(child: Text('Partager le profil', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                                          ]),
                                          const SizedBox(height: 12),
                                          SelectableText(json, style: Theme.of(ctx).textTheme.bodySmall),
                                          const SizedBox(height: 12),
                                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Fermer')),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await Clipboard.setData(ClipboardData(text: json));
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text('Copier JSON'),
                                            ),
                                          ])
                                        ]),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          _KpiCard(icon: Icons.device_hub, label: 'Nœuds connectés', value: isNew ? '0' : '3'),
                          const SizedBox(width: 10),
                          _KpiCard(icon: Icons.data_usage, label: 'Données', value: isNew ? '0 MB' : '12.4 MB', backgroundColors: [scheme.tertiaryContainer, scheme.primaryContainer]),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: WalletCard(points: profile.xp.toInt(), tokens: 12, lastClaim: DateTime.now().subtract(const Duration(days: 2))),
                    ),

                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Actions recommandées', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                        const SizedBox(height: 8),
                        _SurfaceCard(
                          child: Row(children: [
                            Icon(Icons.sync, color: scheme.primary),
                            const SizedBox(width: 12),
                            Expanded(child: Text('Synchroniser les nœuds et récupérer les dernières données', style: Theme.of(context).textTheme.bodyMedium)),
                            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Synchroniser'))
                          ]),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Impact', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                        const SizedBox(height: 8),
                        // derive simple fallbacks from profile.xp if detailed metrics aren't available
                        ImpactCard(dataBytes: (profile.xp * 120), points: profile.xp),
                        const SizedBox(height: 10),
                        Text('Usage des 7 derniers jours', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        DataUsageGraph(values: List.generate(7, (i) => ((i + 1) * (profile.xp % 5 + 1) * 2.5))),
                      ]),
                    ),

                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Activité récente', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                        const SizedBox(height: 8),
                        ActivityFeed(items: [
                          ActivityItemModel(id: 'a1', type: 'sync', title: 'Synchronisation', subtitle: '3 nœuds mis à jour', timestamp: DateTime.now().subtract(const Duration(minutes: 15))),
                          ActivityItemModel(id: 'a2', type: 'badge', title: 'Badge obtenu', subtitle: 'Network Starter', timestamp: DateTime.now().subtract(const Duration(days: 1))),
                        ]),
                        const SizedBox(height: 12),
                      ]),
                    ),

                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Réglages rapides', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                        const SizedBox(height: 8),
                        QuickToggles(
                          autoSync: true,
                          sharePublic: false,
                          onToggle: (k, v) {},
                        ),
                      ]),
                    ),
                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Badges', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            itemBuilder: (context, index) {
                              final b = sampleBadges[index];
                              return _BadgeTile(
                                id: b['id'] as String,
                                title: b['title'] as String,
                                unlocked: b['unlocked'] as bool,
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemCount: sampleBadges.length,
                          ),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 22),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(tr(context, 'profile.error'))),
            ),
          ),
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;
  const _SurfaceCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [scheme.surfaceVariant.withOpacity(0.05), scheme.primary.withOpacity(0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.primary.withOpacity(0.10)),
            boxShadow: [BoxShadow(color: scheme.primary.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 6))],
          ),
          child: child,
        ),
      ),
    );
  }
}


class _KpiCard extends StatelessWidget {
  const _KpiCard({Key? key, required this.icon, required this.label, required this.value, this.backgroundColors}) : super(key: key);

  final IconData icon;
  final String label;
  final String value;
  final List<Color>? backgroundColors;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
    child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: backgroundColors != null
                  ? LinearGradient(colors: backgroundColors!, begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : LinearGradient(colors: [scheme.surfaceVariant.withOpacity(0.06), scheme.primary.withOpacity(0.06)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.primary.withOpacity(0.10)),
              boxShadow: [BoxShadow(color: scheme.primary.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 8))],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: scheme.primary.withOpacity(0.12)),
                  child: Icon(icon, color: scheme.primary, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                    const SizedBox(height: 6),
                    Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final String id;
  final String title;
  final bool unlocked;
  const _BadgeTile({Key? key, required this.id, required this.title, required this.unlocked}) : super(key: key);

  void _showAchievementDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: unlocked ? scheme.primary : scheme.onSurface.withOpacity(0.06),
                  child: Icon(unlocked ? Icons.emoji_events : Icons.lock_outline, color: unlocked ? scheme.onPrimary : scheme.onSurfaceVariant, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
              ]),
              const SizedBox(height: 12),
              Text(
                unlocked ? 'This achievement is unlocked.' : 'This achievement is locked. Complete the required actions to unlock it.',
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Close')),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onLongPress: () => _showAchievementDetails(context),
      child: SizedBox(
        width: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: unlocked ? scheme.primary : scheme.onSurface.withOpacity(0.06),
              child: Icon(unlocked ? Icons.emoji_events : Icons.lock_outline, color: unlocked ? scheme.onPrimary : scheme.onSurfaceVariant, size: 30),
            ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _TangleNodeItem extends StatefulWidget {
  final Map<String, Object?> peer;
  const _TangleNodeItem({Key? key, required this.peer}) : super(key: key);

  @override
  State<_TangleNodeItem> createState() => _TangleNodeItemState();
}

class _TangleNodeList extends StatefulWidget {
  final List<Map<String, Object?>> initialPeers;

  const _TangleNodeList({Key? key, required this.initialPeers}) : super(key: key);

  @override
  State<_TangleNodeList> createState() => _TangleNodeListState();
}

class _TangleNodeListState extends State<_TangleNodeList> with TickerProviderStateMixin {
  late List<Map<String, Object?>> peers;
  final _rand = Random();

  @override
  void initState() {
    super.initState();
    peers = List.from(widget.initialPeers);
    Future.delayed(const Duration(seconds: 3), _simulateChange);
  }

  void _simulateChange() async {
    if (!mounted) return;
    setState(() {
      peers.add({'id': 'p${peers.length + 1}', 'addr': 'node-${peers.length + 1}.eco', 'latency': '${50 + peers.length * 10}ms', 'connected': 'true'});
    });
    // Wait a bit while nodes transfer data
    await Future.delayed(Duration(seconds: 2 + _rand.nextInt(3)));
    if (!mounted) return;
    // randomly pick a node to disconnect (simulate)
    if (peers.isNotEmpty) {
      final idx = _rand.nextInt(peers.length);
      final id = peers[idx]['id'];
      // mark disconnecting
      setState(() {
        peers[idx]['connected'] = 'false';
      });
      // allow animation to play then remove
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() {
        peers.removeWhere((p) => p['id'] == id);
      });
    }
    // schedule next change
    Future.delayed(Duration(seconds: 2 + _rand.nextInt(5)), _simulateChange);
  }

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: Column(
          children: peers.map((p) => _TangleNodeItem(peer: p, key: ValueKey(p['id']))).toList(),
        ),
      ),
    );
  }
}

class _TangleNodeItemState extends State<_TangleNodeItem> with SingleTickerProviderStateMixin {
  late AnimationController _transferCtrl;
  bool _connected = true;

  @override
  void initState() {
    super.initState();
    _transferCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    // When transfer completes, reset to 0 then start again after a short pause
    _transferCtrl.addStatusListener((s) async {
      if (s == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          _transferCtrl.value = 0.0;
          await Future.delayed(const Duration(milliseconds: 150));
          if (mounted) _transferCtrl.forward();
        }
      }
    });
    // initial connected state
    _connected = widget.peer['connected'] == 'true' || widget.peer['connected'] == 'True';
    // staggered start
    Future.delayed(Duration(milliseconds: (100 * (widget.peer['id']!.hashCode % 10))), () {
      if (mounted && _connected) _transferCtrl.forward();
    });
  }

  @override
  void dispose() {
    _transferCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final connVal = widget.peer['connected'];
    final connected = (connVal is bool) ? connVal : (connVal?.toString().toLowerCase() == 'true');
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: connected ? 1.0 : 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                    backgroundColor: scheme.primaryContainer,
                    child: Text((widget.peer['addr'] as String).split('-').last, style: TextStyle(color: scheme.onPrimaryContainer))),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: connected ? scheme.primary : Colors.grey,
                      border: Border.all(color: scheme.surface, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.peer['addr']?.toString() ?? '-', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                // animated transfer bar that fills to 100% then resets
                AnimatedBuilder(
                  animation: _transferCtrl,
                  builder: (context, child) {
                    final progress = _transferCtrl.value.clamp(0.0, 1.0);
                    return Stack(
                      children: [
                        Container(height: 8, decoration: BoxDecoration(color: scheme.onSurface.withOpacity(0.06), borderRadius: BorderRadius.circular(6))),
                        LayoutBuilder(builder: (context, constraints) {
                          return Container(
                            height: 8,
                            width: constraints.maxWidth * progress,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [scheme.primary, scheme.secondary], begin: Alignment.centerLeft, end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [BoxShadow(color: scheme.primary.withOpacity(0.12), blurRadius: 6, offset: const Offset(0, 2))],
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ]),
            ),
            const SizedBox(width: 12),
            Text(widget.peer['latency'] as String, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}



// Peer comparison removed (mini leaderboard)

// Removed unused additional cards to keep file tidy. Re-add when needed.
