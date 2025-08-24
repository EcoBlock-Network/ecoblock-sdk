import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/block_list_provider.dart';
import '../widgets/profile_widgets.dart';
import 'package:ecoblock_mobile/l10n/translation.dart';
// ...existing code... (removed unused import)

class BlockHistoryPage extends ConsumerStatefulWidget {
  const BlockHistoryPage({super.key});

  @override
  ConsumerState<BlockHistoryPage> createState() => _BlockHistoryPageState();
}

class _BlockHistoryPageState extends ConsumerState<BlockHistoryPage> {
  String _selectedType = 'Tous';
  final List<String> _types = ['Tous', 'air', 'water', 'earth', 'température', 'CO2', 'PM2.5'];

  @override
  Widget build(BuildContext context) {
    final blocksAsync = ref.watch(blockListProvider);
    return Scaffold(
      appBar: AppBar(
  title: Text(tr(context, 'my_blocks')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButton<String>(
              value: _selectedType,
              items: _types.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedType = val);
              },
            ),
          ),
          Expanded(
            child: blocksAsync.when(
              data: (blocks) {
                final filtered = _selectedType == 'Tous'
                  ? blocks
                  : blocks.where((b) => b.type == _selectedType).toList();
                if (filtered.isEmpty) {
                  return Center(child: Text(tr(context, 'no_blocks'), style: TextStyle(color: Theme.of(context).colorScheme.secondary)));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final block = filtered[i];
                    return FadeTransition(
                      opacity: AlwaysStoppedAnimation(1.0),
                      child: BlockCard(block: block, onDetail: () {}),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(tr(context, 'error_loading_blocks'))),
            ),
          ),
        ],
      ),
    );
  }
}
