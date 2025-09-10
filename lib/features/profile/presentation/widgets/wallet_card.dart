import 'package:flutter/material.dart';

class WalletCard extends StatelessWidget {
  final int points;
  final int tokens;
  final DateTime lastClaim;
  const WalletCard({Key? key, required this.points, required this.tokens, required this.lastClaim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Solde', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)), const SizedBox(height: 6), Text('$points pts', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),]),
      const Spacer(),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('Tokens', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)), const SizedBox(height: 6), Text('$tokens', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text('Dernier retrait: ${lastClaim.day}/${lastClaim.month}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant))])
    ]);
  }
}
