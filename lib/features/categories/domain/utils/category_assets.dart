import 'package:flutter/material.dart';

class CategoryAssets {
  static const Map<String, IconData> iconMap = {
    'restaurant': Icons.restaurant,
    'directions_car': Icons.directions_car,
    'shopping_bag': Icons.shopping_bag,
    'receipt_long': Icons.receipt_long,
    'movie': Icons.movie,
    'medical_services': Icons.medical_services,
    'school': Icons.school,
    'group': Icons.group,
    'account_balance_wallet': Icons.account_balance_wallet,
    'laptop': Icons.laptop,
    'trending_up': Icons.trending_up,
    'add_circle_outline': Icons.add_circle_outline,
    'home': Icons.home,
    'flight': Icons.flight,
    'local_cafe': Icons.local_cafe,
    'pets': Icons.pets,
    'sports_esports': Icons.sports_esports,
    'shopping_cart': Icons.shopping_cart,
    'coffee': Icons.coffee,
  };

  static IconData getIconData(String? name) {
    if (name == null) return Icons.category;
    return iconMap[name] ?? Icons.category;
  }

  static String getIconName(IconData icon) {
    for (final entry in iconMap.entries) {
      if (entry.value == icon) return entry.key;
    }
    return 'category';
  }

  static Color getColorFromHex(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFF035657);
    String formattedHex = hex.replaceAll('#', '');
    if (formattedHex.length == 6) {
      formattedHex = 'FF$formattedHex';
    }
    final intValue = int.tryParse(formattedHex, radix: 16);
    if (intValue == null) return const Color(0xFF035657);
    return Color(intValue);
  }

  static String getHexFromColor(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  // Pre-defined icons for Add Category form
  static const List<String> selectableIcons = [
    'restaurant',
    'directions_car',
    'shopping_bag',
    'home',
    'flight',
    'local_cafe',
    'medical_services',
    'school',
    'pets',
    'sports_esports',
  ];

  // Pre-defined colors for Add Category form (from HTML design tokens)
  static const List<String> selectableColors = [
    '#035657', // Teal/Primary
    '#8F4C2F', // Secondary
    '#734025', // Tertiary
    '#BA1A1A', // Error
    '#E2A243', // Orange/Amber
    '#6B8EAD', // Blue
    '#8A79A8', // Purple
  ];
}
