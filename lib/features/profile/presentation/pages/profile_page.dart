import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import 'package:ecoblock_mobile/shared/widgets/eco_page_background.dart';
import 'package:ecoblock_mobile/features/dashboard/presentation/widgets/eco_dashboard_header.dart';
import '../providers/profile_provider.dart';

class Peer {
  final String id;
  final String addr;
  final String latency;
  bool connected;

  Peer({required this.id, required this.addr, required this.latency, this.connected = true});
}

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late List<Peer> peers;

  @override
  void initState() {
    super.initState();
    peers = [
      Peer(id: 'p1', addr: 'node-1.eco', latency: '42ms'),
      Peer(id: 'p2', addr: 'node-24.eco', latency: '118ms'),
      Peer(id: 'p3', addr: 'node-7.eco', latency: '73ms'),
    ];
  }

  void _removePeer(String id) async {
    final idx = peers.indexWhere((p) => p.id == id);
    if (idx == -1) return;
    setState(() => peers[idx].connected = false);
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => peers.removeWhere((p) => p.id == id));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: EcoPageBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: profileAsync.when(
              data: (profile) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EcoDashboardHeader(currentLevel: profile.niveau),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: scheme.primary.withOpacity(0.08)),
                        child: const Icon(Icons.person, size: 44),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('My Tangle', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                          const SizedBox(height: 6),
                          Text('Network visualization and collected data', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                        ]),
                      ),
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: Stack(alignment: Alignment.center, children: [
                          CircularProgressIndicator(value: (profile.xp ?? 0) / 1000, strokeWidth: 6, color: scheme.primary, backgroundColor: scheme.onSurface.withOpacity(0.04)),
                          Text('${((profile.xp ?? 0) / 10).toInt()}%', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(children: [
                      _KpiCard(icon: Icons.device_hub, label: 'Connected nodes', value: '${peers.length}'),
                      const SizedBox(width: 10),
                      _KpiCard(icon: Icons.data_usage, label: 'Data', value: '12.4 MB', backgroundColors: [scheme.tertiaryContainer, scheme.primaryContainer]),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Recommended actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                      const SizedBox(height: 8),
                      _SurfaceCard(
                        child: Row(children: [
                          Icon(Icons.sync, color: scheme.primary),
                          const SizedBox(width: 12),
                          Expanded(child: Text('Synchronize nodes and fetch latest data', style: Theme.of(context).textTheme.bodyMedium)),
                          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Synchronize'))
                        ]),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Connected nodes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                      const SizedBox(height: 8),
                      _SurfaceCard(
                        child: Column(children: peers.map((p) => _peerTile(p)).toList()),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(children: [
                      Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload_file), label: const Text('Export data'))),
                      const SizedBox(width: 12),
                      Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.settings), label: const Text('Settings'))),
                    ]),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(tr(context, 'profile.error'))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _peerTile(Peer p) {
    final scheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(p.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _removePeer(p.id),
      background: Container(color: Theme.of(context).colorScheme.error, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), child: const Icon(Icons.delete, color: Colors.white)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: scheme.primaryContainer, child: Text(p.addr.split('-').last, style: TextStyle(color: scheme.onPrimaryContainer))),
        title: Text(p.addr),
        subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: LinearProgressIndicator(value: p.connected ? 0.6 : 0.0)),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(p.latency, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.remove_circle_outline), color: scheme.error, onPressed: () => _removePeer(p.id)),
        ]),
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
            child: Row(children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(shape: BoxShape.circle, color: scheme.primary.withOpacity(0.12)), child: Icon(icon, color: scheme.primary)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)), const SizedBox(height: 4), Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),])),
            ]),
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
    return Card(color: scheme.surfaceVariant, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2, child: Padding(padding: const EdgeInsets.all(12), child: child));
  }
}

