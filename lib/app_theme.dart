import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color forestGreen = Color(0xFF2E7D32);
  static const Color mintGreen = Color(0xFF81C784);
  static const Color glacierBlue = Color(0xFFB2EBF2);
  static const Color solarYellow = Color(0xFFFFF176);
  static const Color softGrey = Color(0xFFE0E0E0);
  static const Color lightBeige = Color(0xFFF1F8E9);
  static const Color white = Color(0xFFFFFFFF);

  static ThemeData materialTheme = ThemeData(
    fontFamily: 'Inter',
    colorScheme: ColorScheme.light(
      primary: forestGreen,
      secondary: mintGreen,
      background: lightBeige,
      surface: white,
      onPrimary: white,
      onSecondary: forestGreen,
      onBackground: forestGreen,
      onSurface: forestGreen,
      tertiary: glacierBlue,
      surfaceVariant: softGrey,
      error: Colors.red,
    ),
    cardTheme: CardThemeData(
      color: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: forestGreen),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: forestGreen),
      bodyMedium: TextStyle(fontSize: 16, color: forestGreen),
      bodySmall: TextStyle(fontSize: 14, color: forestGreen),
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      primaryColor: forestGreen,
      barBackgroundColor: lightBeige,
      scaffoldBackgroundColor: lightBeige,
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(fontFamily: 'SF Pro', color: forestGreen),
      ),
    ),
  );

  static CupertinoThemeData cupertinoTheme = const CupertinoThemeData(
    primaryColor: forestGreen,
    barBackgroundColor: lightBeige,
    scaffoldBackgroundColor: lightBeige,
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(fontFamily: 'SF Pro', color: forestGreen),
    ),
  );
}
