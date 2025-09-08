import 'package:flutter/animation.dart';

class AppMotion {
  static const Duration short = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration long = Duration(milliseconds: 700);

  static const Curve ease = Curves.ease;
  static const Curve softOut = Curves.easeOutCubic;
  static const Curve springy = Curves.easeOutBack;
}
