import 'package:flutter/material.dart';

class NodeHealthEntry {
  final DateTime ts;
  final String status;
  final String message;

  NodeHealthEntry({required this.ts, required this.status, required this.message});
}

class NodeHealthTimeline extends StatelessWidget {
  final List<NodeHealthEntry> entries;
  const NodeHealthTimeline({Key? key, required this.entries}) : super(key: key);

  String _tsText(DateTime t) {
    final now = DateTime.now();
    final d = now.difference(t);
    if (d.inMinutes < 60) return '${d.inMinutes} minutes';
    if (d.inHours < 24) return '${d.inHours} heures';
    return '${d.inDays} jours';
  }

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return Text('Aucun historique', style: Theme.of(context).textTheme.bodyMedium);
    return Column(children: entries.map((e) {
      final color = e.status == 'ok' ? Colors.green : (e.status == 'warn' ? Colors.orange : Colors.red);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Column(children: [Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color)), const SizedBox(height: 4)]),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e.message, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 4), Text(_tsText(e.ts), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))])),
        ]),
      );
    }).toList());
  }
}
