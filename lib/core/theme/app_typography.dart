import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTypography {
  /// Maps DESIGN.md type scale to Flutter TextTheme:
  /// - display-lg (28px, Bold, 36px line height, -0.02em letter spacing) -> displayLarge
  /// - display-sm (22px, Bold, 28px line height, -0.01em letter spacing) -> headlineSmall
  /// - section-title (18px, SemiBold, 24px line height)                  -> titleLarge
  /// - body-md (16px, Medium, 24px line height)                          -> bodyLarge
  /// - body-sm (14px, Medium, 20px line height)                          -> bodyMedium
  /// - label-md (12px, Regular, 16px line height)                        -> labelMedium
  /// - label-sm (11px, Regular, 14px line height)                        -> labelSmall
  static TextTheme get textTheme {
    return GoogleFonts.plusJakartaSansTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
          height: 36.0 / 28.0, // 1.28
          letterSpacing: -0.02 * 28.0, // Convert em to logical pixels
        ),
        headlineSmall: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
          height: 28.0 / 22.0, // 1.27
          letterSpacing: -0.01 * 22.0, // Convert em to logical pixels
        ),
        titleLarge: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600, // SemiBold
          height: 24.0 / 18.0, // 1.33
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500, // Medium
          height: 24.0 / 16.0, // 1.50
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500, // Medium
          height: 20.0 / 14.0, // 1.43
        ),
        labelMedium: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400, // Regular
          height: 16.0 / 12.0, // 1.33
        ),
        labelSmall: TextStyle(
          fontSize: 11.0,
          fontWeight: FontWeight.w400, // Regular
          height: 14.0 / 11.0, // 1.27
        ),
      ),
    );
  }
}
