import 'package:flutter/material.dart';

class ActivityItemModel {
  final String id;
  final String type;
  final String title;
  final String? subtitle;
  final DateTime timestamp;

  ActivityItemModel({required this.id, required this.type, required this.title, this.subtitle, required this.timestamp});
}

class ActivityFeed extends StatelessWidget {
  final List<ActivityItemModel> items;
  const ActivityFeed({Key? key, required this.items}) : super(key: key);

  String _timeAgo(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}j';
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return SizedBox(height: 60, child: Center(child: Text('Aucune activité récente', style: Theme.of(context).textTheme.bodyMedium)));
    return Column(children: items.take(5).map((it) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Icon(it.type == 'sync' ? Icons.sync : (it.type == 'badge' ? Icons.emoji_events : Icons.info), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(it.title, style: Theme.of(context).textTheme.bodyMedium), if (it.subtitle != null) Text(it.subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))])),
          const SizedBox(width: 8),
          Text(_timeAgo(it.timestamp), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]),
      );
    }).toList());
  }
}
