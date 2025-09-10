import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class NodeCard extends StatefulWidget {
  final String nodeId;
  final String addr;
  final String latency;
  final bool connected;

  const NodeCard({Key? key, required this.nodeId, required this.addr, required this.latency, required this.connected}) : super(key: key);

  @override
  State<NodeCard> createState() => _NodeCardState();
}

class _NodeCardState extends State<NodeCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _flip() {
    if (_ctrl.status == AnimationStatus.completed || _ctrl.value > 0.5) {
      _ctrl.reverse();
    } else {
      _ctrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final nodeId = widget.nodeId;
    final addr = widget.addr;
    final latency = widget.latency;
    final connected = widget.connected;

    return GestureDetector(
      onTap: _flip,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              final t = _ctrl.value;
              final angle = t * math.pi;
              final isFront = t <= 0.5;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surface.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: scheme.onSurface.withOpacity(0.06)),
                    boxShadow: isFront ? [BoxShadow(color: scheme.primary.withOpacity(0.10), blurRadius: 18, offset: const Offset(0, 8))] : null,
                  ),
                  child: isFront ? _buildFront(context, nodeId, addr, latency, connected, scheme) : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildBack(context, nodeId, addr, latency, connected, scheme),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFront(BuildContext context, String nodeId, String addr, String latency, bool connected, ColorScheme scheme) {
    final short = nodeId.isNotEmpty ? (nodeId.length > 10 ? '${nodeId.substring(0, 10)}…' : nodeId) : '—';
    return Row(children: [
      
      Container(
        width: 8,
        height: 56,
        decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(6)),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('Mon nœud', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurface.withOpacity(0.9))),
          const SizedBox(height: 6),
          Text(addr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: Text('Latency: $latency', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant), overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 12),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(color: scheme.surfaceVariant.withOpacity(0.03), borderRadius: BorderRadius.circular(8)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(short, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.primary.withOpacity(0.95))),
                const SizedBox(width: 6),
                Icon(Icons.info_outline, size: 16, color: scheme.primary.withOpacity(0.9)),
              ]),
            ),
          ])
        ]),
      ),
      const SizedBox(width: 8),
      Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: connected ? scheme.primary.withOpacity(0.12) : scheme.onSurface.withOpacity(0.06)),
        child: Icon(connected ? Icons.router : Icons.portable_wifi_off, color: connected ? scheme.primary : scheme.onSurfaceVariant),
      ),
    ]);
  }

  Widget _buildBack(BuildContext context, String nodeId, String addr, String latency, bool connected, ColorScheme scheme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Détails du nœud', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        IconButton(onPressed: () => _flip(), icon: Icon(Icons.close, color: scheme.onSurface))
      ]),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: scheme.surfaceVariant.withOpacity(0.06)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Node ID', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 6),
          SelectableText(nodeId, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Address', style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: 6), Text(addr, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600))])),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Latency', style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: 6), Text(latency, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600))])),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Text('Connected: ', style: Theme.of(context).textTheme.bodySmall),
            Icon(connected ? Icons.check_circle : Icons.cancel, color: connected ? scheme.primary : scheme.error, size: 18),
            const SizedBox(width: 12),
            ElevatedButton.icon(onPressed: () {
              Clipboard.setData(ClipboardData(text: nodeId));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Node ID copié')));
            }, icon: const Icon(Icons.copy, size: 16), label: const Text('Copier'))
          ])
        ]),
      )
    ]);
  }
}
