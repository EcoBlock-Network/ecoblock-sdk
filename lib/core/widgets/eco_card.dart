import 'package:flutter/material.dart';

class EcoCard extends StatelessWidget {
  final Widget child;
  const EcoCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFFE3F2E1).withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: child,
    );
  }
}
