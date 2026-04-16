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

  // THE DYNAMIC THEME GENERATOR
  static ThemeData getTheme(bool isDarkMode, Color primaryColor, {String preset = 'Default'}) {
    // Override colors based on presets
    Color backgroundColor = isDarkMode ? darkBackground : lightBackground;
    Color surfaceColor = isDarkMode ? darkSurface : lightSurface;
    Color surfaceVariant = isDarkMode ? darkSurfaceSecondary : lightSurfaceSecondary;
    
    if (isDarkMode) {
      if (preset == 'Orange Mechanic') {
        backgroundColor = const Color(0xFF1A1714); // Slightly warmer/orange dark
        surfaceColor = const Color(0xFF24201C);
      } else if (preset == 'Purple Disco') {
        backgroundColor = const Color(0xFF14111A); // Deep purple dark
        surfaceColor = const Color(0xFF1E1926);
      } else if (preset == 'Blue Powder') {
        backgroundColor = const Color(0xFF11141A); // Deep blue dark
        surfaceColor = const Color(0xFF191D26);
      }
    }

    final Brightness brightness = isDarkMode ? Brightness.dark : Brightness.light;
    final Color textColor = isDarkMode ? darkTextPrimary : lightTextPrimary;
    final Color textSecondary = isDarkMode ? darkTextSecondary : lightTextSecondary;
    final Color borderColor = isDarkMode ? darkBorder : lightBorder;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
        primary: primaryColor,
        surface: surfaceColor,
        onSurface: textColor,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        error: errorColor,
        surfaceVariant: surfaceVariant,
        outline: borderColor,
      ),
      textTheme: GoogleFonts.interTextTheme(isDarkMode ? ThemeData.dark().textTheme : ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(color: textColor, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.inter(color: textColor, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: textColor),
        bodyMedium: GoogleFonts.inter(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      dividerTheme: DividerThemeData(color: borderColor, thickness: 1),
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
