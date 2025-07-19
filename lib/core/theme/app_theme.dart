import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AppTheme {
  static AppTheme of(BuildContext context) => AppTheme();
  final Color background = const Color(0xFFF6F8F3); // Wheat
  final Color card = const Color(0xFFE3F2E1); // Fern
  final Color accent = const Color(0xFFB7C9A3); // Moss
  final Color iconColor = const Color(0xFF4C6A3C); // Fern
  final Gradient fernGradient = LinearGradient(colors: [Color(0xFFB7C9A3), Color(0xFF4C6A3C)]);
  final TextStyle titleStyle = TextStyle(fontFamily: 'SF Pro', fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4C6A3C));
  final TextStyle levelStyle = TextStyle(fontFamily: 'SF Pro', fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF4C6A3C));
  final TextStyle labelStyle = TextStyle(fontFamily: 'SF Pro', fontSize: 14, color: Color(0xFF4C6A3C));
  final TextStyle cardTitleStyle = TextStyle(fontFamily: 'SF Pro', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF4C6A3C));
  final TextStyle cardSubtitleStyle = TextStyle(fontFamily: 'SF Pro', fontSize: 14, color: Color(0xFF4C6A3C));
}
