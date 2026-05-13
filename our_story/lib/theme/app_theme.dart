import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryPink = Color(0xFFFFB5C2);
  static const Color softPink = Color(0xFFFFF0F3);
  static const Color creamBackground = Color(0xFFFFF8F5);
  static const Color warmBrown = Color(0xFF8B7355);
  static const Color lightText = Color(0xFF6B5B4F);
  static const Color cardBackground = Color(0xFFFFFAF8);
  static const Color shadowColor = Color(0x1AFFB5C2);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [creamBackground, softPink],
  );

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
      primaryColor: primaryPink,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPink,
        primary: primaryPink,
        secondary: warmBrown,
        surface: cardBackground,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.dancingScript(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: warmBrown,
        ),
        displayMedium: GoogleFonts.dancingScript(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: warmBrown,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: warmBrown,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: lightText,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          color: lightText,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          color: lightText,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryPink, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.dancingScript(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: warmBrown,
        ),
        iconTheme: const IconThemeData(color: warmBrown),
      ),
    );
  }
}
