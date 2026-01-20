import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Dark Mode Palette
  static const Color primary = Color(0xFF00E676); // Neon Green
  static const Color backgroundDark = Color(0xFF21252B); // Darker Blue-Grey
  static const Color cardDark = Color(0xFF2C313C); // Slightly lighter
  static const Color surfaceDark = Color(0xFF3A414C); // Even lighter
  
  // Light Mode Palette
  static const Color primaryLight = Color(0xFF2E7D32); // Forest Green
  static const Color backgroundLight = Color(0xFFF4F1EA); // Parchment
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFE8E5DE);
  static const Color textDark = Color(0xFF221910); // Dark Wood text
  static const Color textMutedLight = Color(0xFF5D4037); // Brown Muted

  static const Color textMuted = Color(0xFFBAAB9C);
}

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.cardDark,
      onSurface: Colors.white,
      // background removed
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
    ),
    cardTheme: const CardThemeData(color: AppColors.cardDark),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.surfaceDark,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.textMuted),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      surface: AppColors.cardLight,
      onSurface: AppColors.textDark,
      // background removed
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.light().textTheme.apply(
            bodyColor: AppColors.textDark,
            displayColor: AppColors.textDark,
          ),
    ),
    cardTheme: const CardThemeData(color: AppColors.cardLight),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.surfaceLight,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.textMutedLight),
    ),
  );
}
