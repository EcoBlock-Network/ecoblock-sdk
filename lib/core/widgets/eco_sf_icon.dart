import 'package:flutter/cupertino.dart';
class EcoSfIcon extends StatelessWidget {
  final String symbol;
  final Color color;
  const EcoSfIcon(this.symbol, {required this.color});
  @override
  Widget build(BuildContext context) {
    // Use CupertinoIcons for SF Symbols mapping
    final iconData = _sfSymbolToCupertinoIcon(symbol);
    return Icon(iconData, color: color);
  }
  IconData _sfSymbolToCupertinoIcon(String symbol) {
    switch (symbol) {
      case 'gear': return CupertinoIcons.gear;
      case 'leaf': return CupertinoIcons.leaf_arrow_circlepath;
      case 'bolt': return CupertinoIcons.bolt;
      case 'chevron.right': return CupertinoIcons.chevron_right;
      case 'person.2': return CupertinoIcons.person_2;
      case 'book': return CupertinoIcons.book;
      default: return CupertinoIcons.circle;
    }
  }
}
