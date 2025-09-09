// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// Centralized app color tokens.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF305635);
  static const Color onPrimary = Color(0xFFF9F6F2);

  static const Color secondary = Color(0xFFA9957B);
  static const Color onSecondary = Color(0xFF1C251A);

  static const Color background = Color(0xFFF5F2EA);
  static const Color onBackground = Color(0xFF21301F);

  static const Color surface = Color(0xFFE5DDC6);
  static const Color onSurface = Color(0xFF41392A);

  static const Color error = Color(0xFFB34C2E);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color tertiary = Color(0xFF6FA58A);
  static const Color onTertiary = Color(0xFFFAF7F0);

  static const Color primaryContainer = Color(0xFF5F8552);
  static const Color secondaryContainer = Color(0xFFD3BAA4);
  static const Color tertiaryContainer = Color(0xFFBAC9B6);

  static const Color outline = Color(0xFF523B2B);

  // Onboarding specific accents
  static const Color onboardingGradientStart = Color(0xFFA5D6A7);
  static const Color onboardingGradientEnd = Color(0xFFB2EBF2);
  static const Color greenStrong = Color(0xFF2E7D32);

  // Common neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  // Additional accents
  static const Color amber = Color(0xFFFFC107);
  static const Color orange = Color(0xFFFF9800);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color green200 = Color(0xFFA5D6A7);
  static const Color green = Color(0xFF4CAF50);
  static const Color brown = Color(0xFF8D6E63);
}

/// ForestLuxury color scheme for the app using centralized tokens.
final forestLuxuryScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  secondary: AppColors.secondary,
  onSecondary: AppColors.onSecondary,
  background: AppColors.background,
  onBackground: AppColors.onBackground,
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
  error: AppColors.error,
  onError: AppColors.onError,
  tertiary: AppColors.tertiary,
  onTertiary: AppColors.onTertiary,
  primaryContainer: AppColors.primaryContainer,
  secondaryContainer: AppColors.secondaryContainer,
  tertiaryContainer: AppColors.tertiaryContainer,
  outline: AppColors.outline,
);

ThemeData buildAppTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: forestLuxuryScheme,
      textTheme: Typography.material2021().black.apply(
        bodyColor: forestLuxuryScheme.onBackground,
        displayColor: forestLuxuryScheme.onBackground,
      ),
    );