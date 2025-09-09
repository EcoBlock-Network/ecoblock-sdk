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
  // Electric accent for dark-mode highlights
  static const Color electric = Color(0xFF00E676);
  // Dark-mode specific tokens
  static const Color darkBackground = Color(0xFF07140B);
  static const Color darkSurface = Color(0xFF0F1A12);
  static const Color darkGlass = Color(0xFF09140C);
  static const Color darkOnBackground = Color(0xFFEDF7EE);
  static const Color darkMuted = Color(0xFF9AA79A);
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

/// Dark variant of the ForestLuxury color scheme using existing tokens.
final forestLuxuryDarkScheme = ColorScheme(
  brightness: Brightness.dark,
  // Keep primary as the brand green; onPrimary stays light for contrast.
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  // Use tertiary as a secondary accent in dark mode for subtle contrast.
  secondary: AppColors.tertiary,
  onSecondary: AppColors.onTertiary,
  // Use black as the primary background and white-ish onBackground for legibility.
  background: AppColors.black,
  onBackground: AppColors.onPrimary,
  // Surfaces use a darker green container token for depth; onSurface stays light.
  surface: AppColors.primaryContainer,
  onSurface: AppColors.onPrimary,
  error: AppColors.error,
  onError: AppColors.onError,
  tertiary: AppColors.tertiary,
  onTertiary: AppColors.onTertiary,
  primaryContainer: AppColors.primaryContainer,
  secondaryContainer: AppColors.secondaryContainer,
  tertiaryContainer: AppColors.tertiaryContainer,
  outline: AppColors.outline,
);

ThemeData _buildLightTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: forestLuxuryScheme,
      textTheme: Typography.material2021().black.apply(
        bodyColor: forestLuxuryScheme.onBackground,
        displayColor: forestLuxuryScheme.onBackground,
      ),
    );

ThemeData _buildDarkTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: forestLuxuryDarkScheme,
      scaffoldBackgroundColor: forestLuxuryDarkScheme.background,
      cardColor: forestLuxuryDarkScheme.surface,
      dialogBackgroundColor: forestLuxuryDarkScheme.surface,
      textTheme: Typography.material2021().white.apply(
        bodyColor: forestLuxuryDarkScheme.onBackground,
        displayColor: forestLuxuryDarkScheme.onBackground,
      ),
      // Small adjustments for dark mode to keep elevated surfaces readable.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: forestLuxuryDarkScheme.primary,
          foregroundColor: forestLuxuryDarkScheme.onPrimary,
        ),
      ),
          appBarTheme: AppBarTheme(
            backgroundColor: forestLuxuryDarkScheme.surface.withOpacity(0.12),
            foregroundColor: forestLuxuryDarkScheme.onPrimary,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: forestLuxuryDarkScheme.surface.withOpacity(0.14),
            modalBackgroundColor: forestLuxuryDarkScheme.surface.withOpacity(0.16),
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: forestLuxuryDarkScheme.surface.withOpacity(0.08),
            indicatorColor: forestLuxuryDarkScheme.primary.withOpacity(0.16),
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: forestLuxuryDarkScheme.surface.withOpacity(0.06),
            selectedItemColor: forestLuxuryDarkScheme.primary,
            unselectedItemColor: forestLuxuryDarkScheme.onBackground.withOpacity(0.6),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: forestLuxuryDarkScheme.surface.withOpacity(0.12),
            contentTextStyle: TextStyle(
              color: forestLuxuryDarkScheme.onBackground,
            ),
          ),
    );

ThemeData buildAppTheme({Brightness brightness = Brightness.light}) {
  return brightness == Brightness.dark ? _buildDarkTheme() : _buildLightTheme();
}

extension ColorWithValues on Color {
  Color withValues({double? alpha}) => withOpacity(alpha ?? 1.0);
}

/// Helpful scheme extension for theme-aware UI colors.
extension AppColorSchemeExt on ColorScheme {
  /// Background used for translucent/nav surfaces.
  /// - Light mode: transparent (keep original look)
  /// - Dark mode: subtle electric green tint to emphasize the brand.
  Color get navBackgroundGlass => brightness == Brightness.dark
      ? AppColors.electric.withOpacity(0.06)
      : Colors.transparent;
}