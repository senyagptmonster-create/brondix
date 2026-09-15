import 'package:flutter/material.dart';

class BrondixTokens {
  static const Color kraftPaper = Color(0xFFF4ECE1);
  static const Color inkNavy = Color(0xFF1B2A4A);
  static const Color stampRed = Color(0xFFC0392B);
  static const Color leatherBrown = Color(0xFF6E473B);
  static const Color cardBorder = Color(0xFFDCCBB5);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'AppFont',
      scaffoldBackgroundColor: kraftPaper,
      colorScheme: const ColorScheme.light(
        primary: inkNavy,
        secondary: stampRed,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: Color(0xFF2C3E50),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: inkNavy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
