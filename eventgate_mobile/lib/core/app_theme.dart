import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFF63049);
  static const Color secondaryColor = Color(0xFFD02752); 
  static const Color tertiaryColor = Color(0xFF8A244B); 
  static const Color darkTextColor = Color(
    0xFF111F35,
  ); 

  static const Color backgroundColor = Color(
    0xFFF9FAFB,
  ); 
  static const Color surfaceColor = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSurface: darkTextColor,
        error: Color(0xFFB00020),
      ),

      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,

      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: darkTextColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkTextColor),
        titleTextStyle: TextStyle(
          color: darkTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade600),
        floatingLabelStyle: const TextStyle(color: primaryColor),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: darkTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        headlineMedium: TextStyle(
          color: darkTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        bodyLarge: TextStyle(color: darkTextColor, fontSize: 16),
        bodyMedium: TextStyle(
          color: darkTextColor,
          fontSize: 14,
        ),
      ),
      iconTheme: const IconThemeData(color: darkTextColor),
    );
  }
}
