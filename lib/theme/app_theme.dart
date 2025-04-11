import 'package:flutter/material.dart';

class AppTheme {
  // Define our color palette
  static const Color primaryPurple = Color(0xFF8A2BE2); // Deep purple
  static const Color accentPurple = Color(0xFFD8BFD8); // Light purple
  static const Color beetleBlack = Color(0xFF1E1E1E); // Dark beetle black
  static const Color darkGrey = Color(0xFF2D2D2D);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color white = Colors.white;

  // Create our theme data
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryPurple,
      scaffoldBackgroundColor: beetleBlack,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: accentPurple,
        background: beetleBlack,
        surface: darkGrey,
        onPrimary: white,
        onSecondary: beetleBlack,
        onBackground: white,
        onSurface: white,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: accentPurple,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: lightGrey,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: accentPurple,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPurple,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}
