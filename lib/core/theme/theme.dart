// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// Extendable theme class that consolidates all global theme data.
/// Provides both a light and dark theme variant.
class AppTheme {
  // Define a light color scheme following Material Design guidelines.
  // Adjust these colors as per your branding or design requirements.
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff4caf50),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffc8e6c9),
    onPrimaryContainer: Color(0xff1b5e20),
    secondary: Color(0xff8bc34a),
    onSecondary: Color(0xff000000),
    secondaryContainer: Color(0xffdcedc8),
    onSecondaryContainer: Color(0xff33691e),
    tertiary: Color(0xff4db6ac),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffb2dfdb),
    onTertiaryContainer: Color(0xff004d40),
    error: Color(0xffd32f2f),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffcdd2),
    onErrorContainer: Color(0xffb71c1c),
    background: Color(0xffffffff),
    onBackground: Color(0xff000000),
    surface: Color(0xffffffff),
    onSurface: Color(0xff000000),
    outline: Color(0xff757575),
    outlineVariant: Color(0xff9e9e9e),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff121212),
    onInverseSurface: Color(0xffffffff),
    inversePrimary: Color(0xff388e3c),
    surfaceTint: Color(0xff4caf50),
  );

  // Define a dark color scheme following Material Design guidelines.
  // Adjust these colors as per your branding or design requirements.
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffa5d6a7),
    onPrimary: Color(0xff000000),
    primaryContainer: Color(0xff425c43),
    onPrimaryContainer: Color(0xffffffff),
    secondary: Color(0xffb5f9b8),
    onSecondary: Color(0xff000000),
    secondaryContainer: Color(0xff6c956e),
    onSecondaryContainer: Color(0xffffffff),
    tertiary: Color(0xffcbfccd),
    onTertiary: Color(0xff000000),
    tertiaryContainer: Color(0xff4bac4e),
    onTertiaryContainer: Color(0xffffffff),
    error: Color(0xffffb4ab),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffb4ab),
    surface: Color(0xff090a09),
    onSurface: Color(0xffffffff),
    background: Color(0xff181820),
    onBackground: Color(0xffffffff),
    outline: Color(0xff8c8c8c),
    outlineVariant: Color(0xff404040),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffffffff),
    onInverseSurface: Color(0xff000000),
    inversePrimary: Color(0xff4c604d),
    surfaceTint: Color(0xffa5d6a7),
  );

  // Create a common text theme builder that adjusts to the given [ColorScheme].
  static TextTheme _buildTextTheme(ColorScheme scheme) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: scheme.onBackground,
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: scheme.onBackground,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: scheme.onBackground,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: scheme.onBackground,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: scheme.onBackground,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: scheme.onBackground,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: scheme.onBackground,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
      ),
    );
  }

  // Builds a common ThemeData using the given ColorScheme.
  // This function ensures consistency between light and dark themes.
  static ThemeData _buildThemeData(ColorScheme scheme) {
    final textTheme = _buildTextTheme(scheme);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.background,

      // ListTileTheme
      listTileTheme: ListTileThemeData(
        tileColor: scheme.surfaceVariant.withOpacity(0.2),
        iconColor: scheme.onSurface,
        textColor: scheme.onSurface,
      ),

      // ChipTheme
      chipTheme: ChipThemeData(
        labelPadding: const EdgeInsets.symmetric(horizontal: 14),
        padding: EdgeInsets.zero,
        selectedColor: scheme.primaryContainer,
        showCheckmark: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        backgroundColor: scheme.surfaceVariant,
      ),

      // FilledButton (Material 3 style)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.all(14),
          foregroundColor: scheme.onPrimary,
          backgroundColor: scheme.primary,
        ),
      ),

      // ElevatedButton Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // OutlinedButton Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // TextButton Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: scheme.surfaceVariant,
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Input Decoration Theme (TextFields, etc.)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceVariant.withOpacity(0.1),
        hintStyle: TextStyle(color: scheme.onSurface.withOpacity(0.7)),
        labelStyle: TextStyle(color: scheme.onSurface),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.primary),
        ),
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        actionTextColor: scheme.primary,
        behavior: SnackBarBehavior.floating,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: scheme.surface,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Public getters for the light and dark themes:
  static ThemeData get lightTheme => _buildThemeData(lightColorScheme);
  static ThemeData get darkTheme => _buildThemeData(darkColorScheme);
}
