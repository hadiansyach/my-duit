import 'package:flutter/material.dart';

abstract class AppColors {
  // Raw Light Tokens (from DESIGN.md)
  static const Color surface = Color(0xFFF8FAF9);
  static const Color surfaceDim = Color(0xFFD8DADA);
  static const Color surfaceBright = Color(0xFFF8FAF9);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F3);
  static const Color surfaceContainer = Color(0xFFECEEED);
  static const Color surfaceContainerHigh = Color(0xFFE6E9E8);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E2);
  
  static const Color onSurface = Color(0xFF191C1C);
  static const Color onSurfaceVariant = Color(0xFF3F4948);
  static const Color inverseSurface = Color(0xFF2E3131);
  static const Color inverseOnSurface = Color(0xFFEFF1F0);
  
  static const Color outline = Color(0xFF6F7978);
  static const Color outlineVariant = Color(0xFFBFC8C8);
  static const Color surfaceTint = Color(0xFF216868);
  
  static const Color primary = Color(0xFF035657);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF2A6F6F);
  static const Color onPrimaryContainer = Color(0xFFACEFEF);
  static const Color inversePrimary = Color(0xFF90D2D2);
  
  static const Color secondary = Color(0xFF8F4C2F);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFDA682);
  static const Color onSecondaryContainer = Color(0xFF773A1E);
  
  static const Color tertiary = Color(0xFF734025);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF8F573A);
  static const Color onTertiaryContainer = Color(0xFFFFDCCC);
  
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  
  static const Color background = Color(0xFFF8FAF9);
  static const Color onBackground = Color(0xFF191C1C);
  static const Color surfaceVariant = Color(0xFFE1E3E2);

  // Derived/Explicit Dark Mode Tokens
  // Background and Card are explicitly from DESIGN.md "Elevation & Depth"
  static const Color darkBackground = Color(0xFF1C1E1F);
  static const Color darkCard = Color(0xFF272A2B);
}
