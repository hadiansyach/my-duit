import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/database_providers.dart';

part 'add_category_viewmodel.g.dart';

class AddCategoryState {
  final String categoryName;
  final String categoryType; // 'expense' or 'income'
  final String selectedIcon;
  final String selectedColor;
  final bool isSaving;
  final String? errorMessage;

  AddCategoryState({
    required this.categoryName,
    required this.categoryType,
    required this.selectedIcon,
    required this.selectedColor,
    required this.isSaving,
    this.errorMessage,
  });

  AddCategoryState copyWith({
    String? categoryName,
    String? categoryType,
    String? selectedIcon,
    String? selectedColor,
    bool? isSaving,
    String? errorMessage,
  }) {
    return AddCategoryState(
      categoryName: categoryName ?? this.categoryName,
      categoryType: categoryType ?? this.categoryType,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      selectedColor: selectedColor ?? this.selectedColor,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class AddCategoryNotifier extends _$AddCategoryNotifier {
  @override
  AddCategoryState build() {
    return AddCategoryState(
      categoryName: '',
      categoryType: 'expense',
      selectedIcon: 'restaurant',
      selectedColor: '#035657',
      isSaving: false,
    );
  }

  void setCategoryName(String name) {
    state = state.copyWith(categoryName: name);
  }

  void setCategoryType(String type) {
    String defaultIcon = type == 'expense' ? 'restaurant' : 'account_balance_wallet';
    state = state.copyWith(
      categoryType: type,
      selectedIcon: defaultIcon,
    );
  }

  void setSelectedIcon(String icon) {
    state = state.copyWith(selectedIcon: icon);
  }

  void setSelectedColor(String color) {
    state = state.copyWith(selectedColor: color);
  }

  Future<bool> saveCategory() async {
    if (state.categoryName.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Nama kategori tidak boleh kosong');
      return false;
    }
    
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final companion = CategoriesCompanion.insert(
        name: state.categoryName.trim(),
        type: state.categoryType,
        icon: Value(state.selectedIcon),
        color: Value(state.selectedColor),
        isDefault: const Value(0), // Custom category
        createdAt: DateTime.now().toIso8601String(),
      );
      
      await ref.read(categoriesDaoProvider).insertCategory(companion);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: 'Gagal menyimpan: $e');
      return false;
    }
  }
}
