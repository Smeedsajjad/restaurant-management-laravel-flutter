import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFFee8e1e);
  static const Color primaryVariant = Color(0xFFe9a24d);
  static const Color primaryLight = Color(0xFFfcf4e9);
  static const Color secondary = Color(0xFFf13f95);
  static const Color secondaryVariant = Color(0xFFfdecf4);
  static const Color accent = Color(0xFFd2d2d2);

  // Neutral / greys
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1f1f1f);
  static const Color grey100 = Color(0xFFF5F6FA);
  static const Color grey200 = Color(0xFFf4f4f7);
  static const Color grey300 = Color.fromARGB(255, 193, 191, 199);
  static const Color grey400 = Color(0xFF949494);
  static const Color grey500 = Color(0xFF656565);
  static const Color textPrimary = Color(0xFF656565);
  static const Color textSecondary = Color(0xFF8f8f8f);

  // Semantic colors
  static const Color info = Color(0xFF7251f8);
  static const Color success = Color(0xFF64b799);
  static const Color successVariant = Color(0xFFeff8f5);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Transparent helpers
  static const Color transparent = Colors.transparent;
}
