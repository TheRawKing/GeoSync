import 'package:flutter/material.dart';

class AppTheme {
  static final Color _primaryColor = const Color(0xFF6C63FF); // Modern Purple
  static final Color _secondaryColor = const Color(0xFF00C853); // Green for "Go"/Check-in
  static final Color _accentColor = const Color(0xFFFFAB40); // Amber for highlights
  static final Color _surfaceColor = const Color(0xFFF3F4F6); // Light Grey BG

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceColor,
        tertiary: _accentColor,
      ),
      scaffoldBackgroundColor: _surfaceColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIconColor: _primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Color(0xFF2D3436),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3436),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF636E72),
        ),
      ),
    );
  }
}
