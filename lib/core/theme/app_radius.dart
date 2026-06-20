import 'package:flutter/material.dart';

abstract class AppRadius {
  static const double sm = 4.0;
  static const double defaultValue = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;

  // Explicit mappings from DESIGN.md Shapes and Components sections
  static const double cards = lg;      // 16px corner radius for Approachable containers
  static const double inputs = md;     // 12px corner radius for text fields
  static const double buttons = full;  // Full-round (pill) shape for buttons
  static const double pills = full;    // Full-round (pill) shape for chips/interactive pills

  // Helper BorderRadius values
  static final BorderRadius cardRadius = BorderRadius.circular(cards);
  static final BorderRadius inputRadius = BorderRadius.circular(inputs);
  static final BorderRadius buttonRadius = BorderRadius.circular(buttons);
  static final BorderRadius pillRadius = BorderRadius.circular(pills);
}
