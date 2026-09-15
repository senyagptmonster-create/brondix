import 'package:flutter/material.dart';

class BrondixRetailTokens {
  BrondixRetailTokens._();

  // Craft paper and neon coral color tokens
  static const Color craftPaperBase = Color(0xFFFBF7EE);
  static const Color craftCardFill = Color(0xFFF3E8D3);
  static const Color craftBorder = Color(0xFFDECDB3);
  static const Color craftTextPrimary = Color(0xFF2B2620);
  static const Color craftTextSecondary = Color(0xFF7A6F62);
  static const Color neonCoralStamp = Color(0xFFFF5238);
  static const Color deepCoralAccent = Color(0xFFD63B23);
  static const Color goldenWheat = Color(0xFFE4A43D);
  static const Color forestSage = Color(0xFF3F7E5A);
  static const Color stampHoleUnpunched = Color(0xFFE5D7BF);
  static const Color inkHighlight = Color(0xFF1E1B18);
  static const Color stampSurfaceWhite = Color(0xFFFFFDF8);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'AppFont',
      scaffoldBackgroundColor: craftPaperBase,
      colorScheme: const ColorScheme.light(
        primary: neonCoralStamp,
        secondary: goldenWheat,
        surface: craftCardFill,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: craftTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: craftPaperBase,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: craftTextPrimary),
        titleTextStyle: TextStyle(
          fontFamily: 'AppFont',
          color: craftTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: craftCardFill,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: craftBorder, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonCoralStamp,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'AppFont',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: stampSurfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: craftBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: craftBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neonCoralStamp, width: 2),
        ),
        labelStyle: const TextStyle(color: craftTextSecondary, fontFamily: 'AppFont'),
        hintStyle: const TextStyle(color: craftBorder, fontFamily: 'AppFont'),
      ),
    );
  }
}
