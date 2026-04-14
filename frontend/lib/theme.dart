import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core Brand Colors (Stay constant across themes)
  static const Color primaryColor = Color(0xFFE11D48); // Soft medical red
  static const Color secondaryColor = Color(0xFFF9A8D4); // Light pink
  static const Color successColor = Color(0xFF10B981); // Soft green
  static const Color warningColor = Color(0xFFF79009); // Orange
  static const Color errorColor = Color(0xFFD32F2F); // Standard red

  // Semantic Light Mode Tokens
  static const Color lightBackground = Color(0xFFF9FAFB);
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceSecondary = Color(0xFFF2F4F7);
  static const Color lightTextPrimary = Color(0xFF101828);
  static const Color lightTextSecondary = Color(0xFF475467);
  static const Color lightTextMuted = Color(0xFF98A2B3);
  static const Color lightBorder = Color(0xFFEAECF0);

  // Semantic Dark Mode Tokens
  static const Color darkBackground = Color(0xFF0F1113); // Clean deep dark
  static const Color darkSurface = Color(0xFF1A1C1E);
  static const Color darkSurfaceSecondary = Color(0xFF2C2E30);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFFD0D5DD);
  static const Color darkTextMuted = Color(0xFF98A2B3);
  static const Color darkBorder = Color(0xFF344054);

  // The global material ThemeData for LIGHT mode
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        error: errorColor,
        surfaceVariant: lightSurfaceSecondary,
        outline: lightBorder,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(color: lightTextPrimary, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.inter(color: lightTextPrimary, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: lightTextPrimary),
        bodyMedium: GoogleFonts.inter(color: lightTextSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(color: lightTextPrimary, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      dividerTheme: const DividerThemeData(color: lightBorder, thickness: 1),
      cardTheme: const CardTheme(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFFEAECF0)),
        ),
      ),
    );
  }

  // THE GLOBAL material ThemeData for DARK mode
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        surface: darkSurface,
        onSurface: darkTextPrimary,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        error: errorColor,
        surfaceVariant: darkSurfaceSecondary,
        outline: darkBorder,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(color: darkTextPrimary, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.inter(color: darkTextPrimary, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: darkTextPrimary),
        bodyMedium: GoogleFonts.inter(color: darkTextSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(color: darkTextPrimary, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      dividerTheme: const DividerThemeData(color: darkBorder, thickness: 1),
      cardTheme: const CardTheme(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFF344054)),
        ),
      ),
    );
  }
}
