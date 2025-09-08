import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/eco_dashboard_header.dart';
import '../providers/profile_provider.dart';
import 'dart:math';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: EcoPageBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: profileAsync.when(
              data: (profile) {
                // Polished profile layout: header, KPIs, missions, and Tangle summary
                final samplePeers = [
                  {'id': 'p1', 'addr': 'node-1.eco', 'latency': '42ms', 'connected': true},
                  {'id': 'p2', 'addr': 'node-24.eco', 'latency': '118ms', 'connected': true},
                  {'id': 'p3', 'addr': 'node-7.eco', 'latency': '73ms', 'connected': true},
                ];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with avatar + level
                    EcoDashboardHeader(currentLevel: profile.niveau),
                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // Avatar placeholder
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: scheme.primary.withOpacity(0.12)),
                            child: const Icon(Icons.person, size: 44, color: Colors.green),
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
                          // Small xp ring
                          Column(
                            children: [
                              SizedBox(
                                width: 64,
                                height: 64,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(value: profile.xp / 1000, strokeWidth: 6, color: scheme.primary, backgroundColor: scheme.onSurface.withOpacity(0.04)),
                                    Text('${(profile.xp / 10).toInt()}%', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // KPI cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          _KpiCard(icon: Icons.device_hub, label: 'Nœuds connectés', value: '3'),
                          const SizedBox(width: 10),
                          _KpiCard(icon: Icons.data_usage, label: 'Données', value: '12.4 MB', backgroundColors: [scheme.tertiaryContainer, scheme.primaryContainer]),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Missions / Actions quick list
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

                    const SizedBox(height: 14),

                    // Tangle peers list (interactive)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Nœuds connectés', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                        const SizedBox(height: 8),
                        _TangleNodeList(initialPeers: samplePeers),
                      ]),
                    ),

                    const SizedBox(height: 22),

                    // Actions row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Row(children: [
                        Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload_file), label: const Text('Exporter données'))),
                        const SizedBox(width: 12),
                        Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.settings), label: const Text('Paramètres'))),
                      ]),
                    ),

                    const SizedBox(height: 32),
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

// Background circles are now provided by `EcoPageBackground`.

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
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            gradient: backgroundColors != null
                ? LinearGradient(colors: backgroundColors!, begin: Alignment.topLeft, end: Alignment.bottomRight)
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: scheme.primary.withOpacity(0.12)),
                  child: Icon(icon, color: scheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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

class _SurfaceCard extends StatelessWidget {
  final Widget child;
  const _SurfaceCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceVariant, // surfaceVariant provided by ColorScheme
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}

// New interactive Tangle node list implementation
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
    // Simulate dynamic connect/disconnect
    Future.delayed(const Duration(seconds: 3), _simulateChange);
  }

  void _simulateChange() async {
    if (!mounted) return;
    // connect a new node
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

class _TangleNodeItem extends StatefulWidget {
  final Map<String, Object?> peer;
  const _TangleNodeItem({Key? key, required this.peer}) : super(key: key);

  @override
  State<_TangleNodeItem> createState() => _TangleNodeItemState();
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
                    decoration: BoxDecoration(shape: BoxShape.circle, color: connected ? Colors.greenAccent.shade400 : Colors.grey, border: Border.all(color: scheme.surface, width: 2)),
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
