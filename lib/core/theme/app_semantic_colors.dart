import 'package:flutter/material.dart';

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color income;
  final Color expense;
  final Color warning;
  final Color danger;

  const AppSemanticColors({
    required this.income,
    required this.expense,
    required this.warning,
    required this.danger,
  });

  // Light semantic colors from design_system.md / ui_guidelines.md
  static const light = AppSemanticColors(
    income: Color(0xFF7FA88E),   // Sage
    expense: Color(0xFFC97B5A),  // Clay
    warning: Color(0xFFD4A94A),  // Amber
    danger: Color(0xFFC96B5A),   // Coral
  );

  // Derived dark semantic colors (desaturated to fit dark backgrounds)
  static const dark = AppSemanticColors(
    income: Color(0xFF6B8F77),
    expense: Color(0xFFB36B4D),
    warning: Color(0xFFB58F3B),
    danger: Color(0xFFB35D4D),
  );

  @override
  AppSemanticColors copyWith({
    Color? income,
    Color? expense,
    Color? warning,
    Color? danger,
  }) {
    return AppSemanticColors(
      income: income ?? this.income,
      expense: expense ?? this.expense,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

// Extension to read semantic colors directly from context/theme
extension AppSemanticColorsX on ThemeData {
  AppSemanticColors get semanticColors => extension<AppSemanticColors>() ?? AppSemanticColors.light;
}
