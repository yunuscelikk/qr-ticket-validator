import 'package:flutter/material.dart';

class AppTheme {
  // 1. RENK PALETİ (Senin Seçimlerin)
  static const Color primaryColor = Color(0xFFF63049); // Ana Renk
  static const Color secondaryColor = Color(0xFFD02752); // İkincil (Daha koyu)
  static const Color tertiaryColor = Color(0xFF8A244B); // Üçüncül (En koyu)
  static const Color darkTextColor = Color(
    0xFF111F35,
  ); // Yazı Rengi (Lacivertimsi Siyah)

  static const Color backgroundColor = Color(
    0xFFF9FAFB,
  ); // Arka plan (Hafif gri - göz yormaz)
  static const Color surfaceColor = Colors.white; // Kartların rengi

  // 2. TEMA VERİSİ (ThemeData)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // A) Renk Şeması (Material 3 Standartları)
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: surfaceColor,
        onPrimary: Colors.white, // Primary üzerindeki yazı rengi
        onSurface: darkTextColor, // Beyaz üzerindeki yazı rengi
        error: Color(0xFFB00020),
      ),

      // B) Arka Plan Renkleri
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,

      // C) AppBar Teması
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: darkTextColor, // Başlık rengi
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

      // D) Buton Teması (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ), // Hafif yuvarlatılmış köşeler
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // E) Input (TextFormField) Teması
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        // Normal Durum
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        // Tıklanınca (Focus)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        // Hata Durumu
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        // Etiket Stilleri
        labelStyle: TextStyle(color: Colors.grey.shade600),
        floatingLabelStyle: const TextStyle(color: primaryColor),
      ),

      // F) Genel Yazı Teması (Fontlar)
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
          color: darkTextColor, // Varsayılan metin rengi
          fontSize: 14,
        ),
      ),

      // G) İkon Teması
      iconTheme: const IconThemeData(color: darkTextColor),
    );
  }
}
