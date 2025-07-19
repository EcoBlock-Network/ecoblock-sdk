import 'package:flutter/cupertino.dart';
import 'dart:ui';
class EcoBlurSheet extends StatelessWidget {
  final Widget child;
  const EcoBlurSheet({required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          color: CupertinoColors.systemGrey6.withOpacity(0.7),
          padding: EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
