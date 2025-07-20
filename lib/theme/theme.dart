import 'package:flutter/material.dart';

/// ForestLuxury color scheme for the app.
final forestLuxuryScheme = ColorScheme(
  brightness: Brightness.light,
  primary: const Color(0xFF305635),
  onPrimary: const Color(0xFFF9F6F2),
  secondary: const Color(0xFFA9957B),
  onSecondary: const Color(0xFF1C251A),
  background: const Color(0xFFF5F2EA),
  onBackground: const Color(0xFF21301F),
  surface: const Color(0xFFE5DDC6),
  onSurface: const Color(0xFF41392A),
  error: const Color(0xFFB34C2E),
  onError: const Color(0xFFFFFFFF),
  tertiary: const Color(0xFF6FA58A),
  onTertiary: const Color(0xFFFAF7F0),
  primaryContainer: const Color(0xFF5F8552),
  secondaryContainer: const Color(0xFFD3BAA4),
  tertiaryContainer: const Color(0xFFBAC9B6),
  outline: const Color(0xFF523B2B),
);

ThemeData buildAppTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: forestLuxuryScheme,
      textTheme: Typography.material2021().black.apply(
        bodyColor: forestLuxuryScheme.onBackground,
        displayColor: forestLuxuryScheme.onBackground,
      ),
    );