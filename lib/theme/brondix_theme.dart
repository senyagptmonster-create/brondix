import 'package:flutter/material.dart';

class BrondixTheme {
  static const bg = Color(0xFFFFFBEB);
  static const surface = Color(0xFFFFFFFF);
  static const edge = Color(0xFFFEF3C7);
  static const accent = Color(0xFFB45309);
  static const accentLight = Color(0xFFFBBF24);
  static const ink = Color(0xFF451A03);
  static const muted = Color(0xFF78350F);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      fontFamily: 'AppFont',
      primaryColor: accent,
      colorScheme: const ColorScheme.light(
        primary: accent,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: ink,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: edge, width: 1.5),
        ),
      ),
    );
  }
}
