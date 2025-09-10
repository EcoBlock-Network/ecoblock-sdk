import 'dart:ui';
import 'package:flutter/material.dart';
import 'node_health_timeline.dart';

class NodeCard extends StatelessWidget {
  final String nodeId;
  final String addr;
  final String latency;
  final bool connected;

  const NodeCard({Key? key, required this.nodeId, required this.addr, required this.latency, required this.connected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [scheme.surfaceVariant.withOpacity(0.06), scheme.primary.withOpacity(0.04)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.primary.withOpacity(0.08)),
          ),
          child: Row(children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: connected ? scheme.primary : scheme.onSurface.withOpacity(0.06)),
              child: Icon(connected ? Icons.router : Icons.portable_wifi_off, color: connected ? scheme.onPrimary : scheme.onSurfaceVariant),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Mon nœud', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text(addr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(children: [Text('Latency: $latency', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)), const SizedBox(width: 12), Text(nodeId, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant))])
            ])),
            ElevatedButton(
              onPressed: () {
                final entries = [
                  NodeHealthEntry(ts: DateTime.now().subtract(const Duration(minutes: 2)), status: 'ok', message: 'Sync réussi'),
                  NodeHealthEntry(ts: DateTime.now().subtract(const Duration(minutes: 22)), status: 'warn', message: 'Latence élevée'),
                  NodeHealthEntry(ts: DateTime.now().subtract(const Duration(hours: 3)), status: 'ok', message: 'Transmission de données'),
                  NodeHealthEntry(ts: DateTime.now().subtract(const Duration(days: 1, hours: 2)), status: 'down', message: 'Déconnecté temporairement'),
                ];
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  builder: (ctx) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            const Icon(Icons.info_outline, size: 28),
                            const SizedBox(width: 12),
                            Expanded(child: Text('Détails du nœud', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                          ]),
                          const SizedBox(height: 12),
                          NodeHealthTimeline(entries: entries),
                          const SizedBox(height: 12),
                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Fermer')),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ping en cours...')));
                                await Future.delayed(const Duration(seconds: 1));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ping: 72 ms')));
                              },
                              child: const Text('Ping'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Traceroute en cours...')));
                                await Future.delayed(const Duration(seconds: 2));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Traceroute terminé')));
                              },
                              child: const Text('Traceroute'),
                            ),
                          ])
                        ]),
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Détails'))
          ]),
        ),
      ),
    );
  }
}
