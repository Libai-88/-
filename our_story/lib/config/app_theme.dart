import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF8B4C4);
  static const Color softPink = Color(0xFFFFE4E8);
  static const Color cream = Color(0xFFFFF5E6);
  static const Color warmWhite = Color(0xFFFFFBF5);
  static const Color softPeach = Color(0xFFFFE5D9);
  static const Color dustyRose = Color(0xFFE8B4B8);
  static const Color warmBrown = Color(0xFF8B7355);
  static const Color deepRose = Color(0xFFD4838F);
  static const Color softLavender = Color(0xFFE8E0F0);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryPink,
      scaffoldBackgroundColor: AppColors.warmWhite,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryPink,
        secondary: AppColors.softPeach,
        surface: AppColors.warmWhite,
        onPrimary: Colors.white,
        onSecondary: AppColors.warmBrown,
        onSurface: AppColors.warmBrown,
        tertiary: AppColors.dustyRose,
      ),
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.warmWhite,
        foregroundColor: AppColors.warmBrown,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.dancingScript(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.warmBrown,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        shadowColor: AppColors.primaryPink.withOpacity(0.15),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPink,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepRose,
          side: const BorderSide(color: AppColors.primaryPink, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cream,
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
          borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.dustyRose, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.nunito(
          color: AppColors.warmBrown.withOpacity(0.5),
          fontSize: 16,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.deepRose,
        unselectedItemColor: AppColors.warmBrown.withOpacity(0.4),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.warmBrown,
        size: 24,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.dustyRose.withOpacity(0.3),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.warmBrown,
        contentTextStyle: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.dancingScript(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: AppColors.warmBrown,
      ),
      displayMedium: GoogleFonts.dancingScript(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: AppColors.warmBrown,
      ),
      displaySmall: GoogleFonts.dancingScript(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.warmBrown,
      ),
      headlineLarge: GoogleFonts.dancingScript(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      headlineMedium: GoogleFonts.dancingScript(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      headlineSmall: GoogleFonts.dancingScript(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.warmBrown,
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      titleSmall: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.warmBrown,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.warmBrown,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.warmBrown.withOpacity(0.8),
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.warmBrown,
      ),
      labelMedium: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.warmBrown,
      ),
      labelSmall: GoogleFonts.nunito(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.warmBrown.withOpacity(0.7),
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const SoftCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.softPeach.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warmWhite,
            AppColors.softPink,
            AppColors.cream,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
