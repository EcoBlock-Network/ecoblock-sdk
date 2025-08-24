import 'package:flutter/material.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
import '../../domain/entities/block_data.dart';
import '../../domain/entities/stats.dart';
import '../../domain/entities/badge.dart' as eco;
import '../../domain/entities/loot_item.dart';

class BlockCard extends StatelessWidget {
  final BlockData block;
  final VoidCallback? onDetail;
  const BlockCard({super.key, required this.block, this.onDetail});

  String typeLabel(BuildContext context) {
    switch (block.type) {
      case 'air': return tr(context, 'type.air');
      case 'water': return tr(context, 'type.water');
      case 'earth': return tr(context, 'type.earth');
      case 'température': return tr(context, 'type.temperature');
      case 'CO2': return tr(context, 'type.co2');
      case 'PM2.5': return tr(context, 'type.pm25');
      default: return block.type;
    }
  }

  IconData get typeIcon {
    switch (block.type) {
      case 'air': return Icons.air;
      case 'water': return Icons.water;
      case 'earth': return Icons.landscape;
      case 'température': return Icons.thermostat;
      case 'CO2': return Icons.cloud;
      case 'PM2.5': return Icons.blur_on;
      default: return Icons.device_unknown;
    }
  }

  String statusLabel(BuildContext context) {
    switch (block.statut) {
      case 'collected': return tr(context, 'status.collected');
      case 'pending': return tr(context, 'status.pending');
      case 'validated': return tr(context, 'status.validated');
      default: return block.statut;
    }
  }

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(block.timestamp);
    if (diff.inMinutes < 60) {
      return 'il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'il y a ${diff.inHours} h';
    } else {
      return '${block.timestamp.day}/${block.timestamp.month}/${block.timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: ListTile(
      leading: Icon(typeIcon, color: color, size: 32),
          title: Text(tr(context, 'profile.type_value', {'type': typeLabel(context), 'value': block.value.toString()}), style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        Text(tr(context, 'profile.block_id', {'id': block.id.substring(0, 6)})),
        Text(tr(context, 'profile.received', {'time': formattedTime})),
        Text(tr(context, 'profile.status', {'status': statusLabel(context)})),
            ],
          ),
          trailing: onDetail != null ? IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: onDetail,
          ) : null,
        ),
      ),
    );
  }
}
// Imports déjà présents en haut du fichier, à supprimer ici

class StatGrid extends StatelessWidget {
  final Stats stats;
  const StatGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatItem(icon: Icons.eco, label: 'Blocs', value: stats.nbBlocs.toString(), color: color),
            _StatItem(icon: Icons.account_tree, label: 'Nœuds', value: stats.nbNodes.toString(), color: color),
            _StatItem(icon: Icons.star, label: 'XP', value: stats.xp.toString(), color: color),
            _StatItem(icon: Icons.emoji_events, label: 'Niveau', value: stats.niveau.toString(), color: color),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatItem({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}

class BadgeList extends StatelessWidget {
  final List<eco.Badge> badges;
  const BadgeList({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final badge = badges[i];
          return Hero(
            tag: 'badge_${badge.id}',
            child: AnimatedScale(
              scale: badge.unlocked ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 400),
              child: Opacity(
                opacity: badge.unlocked ? 1.0 : 0.4,
                child: Card(
                  color: badge.unlocked ? Colors.amber : Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emoji_events, color: badge.unlocked ? Colors.orange : Colors.grey, size: 28),
                        Text(badge.nom, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LootList extends StatelessWidget {
  final List<LootItem> loot;
  const LootList({super.key, required this.loot});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: loot.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final item = loot[i];
          return Card(
            color: item.debloque ? Colors.green[200] : Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory, color: item.debloque ? Colors.green : Colors.grey, size: 28),
                  Text(item.nom, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
