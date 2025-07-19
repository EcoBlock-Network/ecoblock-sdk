import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class EcoCard extends StatelessWidget {
  final Widget child;
  const EcoCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFFE3F2E1).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: child,
    );
  }
}
