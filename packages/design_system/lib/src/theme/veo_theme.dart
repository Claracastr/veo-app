import 'package:flutter/material.dart';

abstract final class VeoColors {
  static const ink = Color(0xFF16271F);
  static const forest = Color(0xFF174A38);
  static const mint = Color(0xFFCBF36B);
  static const canvas = Color(0xFFF7F8F3);
  static const surface = Colors.white;
  static const muted = Color(0xFF718077);
  static const line = Color(0xFFE4EAE2);
  static const danger = Color(0xFFB53E3E);
}
abstract final class VeoSpace {
  static const xs = 4.0, sm = 8.0, md = 16.0, lg = 24.0, xl = 32.0;
}
abstract final class VeoRadius {
  static const sm = 12.0, md = 18.0, lg = 26.0;
}
abstract final class VeoTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: VeoColors.canvas,
    colorScheme: ColorScheme.fromSeed(seedColor: VeoColors.forest, primary: VeoColors.forest, secondary: VeoColors.mint, surface: VeoColors.surface),
    textTheme: const TextTheme(
      displaySmall: TextStyle(fontSize: 35, fontWeight: FontWeight.w800, color: VeoColors.ink, height: 1.08, letterSpacing: -1.2),
      headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: VeoColors.ink, letterSpacing: -.8),
      titleLarge: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: VeoColors.ink),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: VeoColors.ink),
      bodyMedium: TextStyle(fontSize: 14, color: VeoColors.ink, height: 1.5),
      bodySmall: TextStyle(fontSize: 12, color: VeoColors.muted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(VeoRadius.md), borderSide: const BorderSide(color: VeoColors.line)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(VeoRadius.md), borderSide: const BorderSide(color: VeoColors.line)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: VeoColors.canvas, foregroundColor: VeoColors.ink, surfaceTintColor: Colors.transparent),
  );
}
