import 'package:flutter/material.dart';

class CategoryModel {
  final String id;        // contoh: 'food'
  final String label;     // contoh: 'Makan & Minum'
  final IconData icon;    // contoh: Icons.restaurant
  final Color color;      // warna background lingkaran icon
  final bool isExpense;   // true = Pengeluaran, false = Pemasukan

  const CategoryModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.isExpense,
  });
}

// Semua warna diambil dari design token HTML mockup
const List<CategoryModel> kExpenseCategories = [
  CategoryModel(id: 'food',          label: 'Makan & Minum',  icon: Icons.restaurant,       color: Color(0xFFACEEEE), isExpense: true),
  CategoryModel(id: 'transport',     label: 'Transportasi',   icon: Icons.directions_car,   color: Color(0xFFFFDBCB), isExpense: true),
  CategoryModel(id: 'shopping',      label: 'Belanja',        icon: Icons.shopping_bag,     color: Color(0xFFFFDBCD), isExpense: true),
  CategoryModel(id: 'bills',         label: 'Tagihan',        icon: Icons.receipt_long,     color: Color(0xFFFFDAD6), isExpense: true),
  CategoryModel(id: 'entertainment', label: 'Hiburan',        icon: Icons.movie,            color: Color(0xFFECEEED), isExpense: true),
  CategoryModel(id: 'health',        label: 'Kesehatan',      icon: Icons.medical_services, color: Color(0xFFACEEEE), isExpense: true),
  CategoryModel(id: 'education',     label: 'Pendidikan',     icon: Icons.school,           color: Color(0xFFFDA682), isExpense: true),
  CategoryModel(id: 'social',        label: 'Sosial',         icon: Icons.group,            color: Color(0xFFFFDBCB), isExpense: true),
];

const List<CategoryModel> kIncomeCategories = [
  CategoryModel(id: 'salary',        label: 'Gaji',           icon: Icons.account_balance_wallet, color: Color(0xFFACEEEE), isExpense: false),
  CategoryModel(id: 'freelance',     label: 'Freelance',      icon: Icons.laptop,                 color: Color(0xFFFFDBCD), isExpense: false),
  CategoryModel(id: 'investment',    label: 'Investasi',      icon: Icons.trending_up,            color: Color(0xFFFFDBCB), isExpense: false),
  CategoryModel(id: 'other_income',  label: 'Lainnya',        icon: Icons.add_circle_outline,     color: Color(0xFFECEEED), isExpense: false),
];
