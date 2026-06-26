import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/core/theme/app_spacing.dart';
import 'package:my_duit/features/categories/domain/utils/category_assets.dart';
import 'package:my_duit/features/categories/presentation/viewmodel/add_category_viewmodel.dart';

class AddCategoryBottomSheet extends ConsumerStatefulWidget {
  final String? initialType; // 'expense' or 'income'

  const AddCategoryBottomSheet({
    super.key,
    this.initialType,
  });

  static Future<bool?> show(BuildContext context, {String? initialType}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCategoryBottomSheet(initialType: initialType),
    );
  }

  @override
  ConsumerState<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends ConsumerState<AddCategoryBottomSheet> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    
    // Set initial type if provided
    if (widget.initialType != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(addCategoryNotifierProvider.notifier).setCategoryType(widget.initialType!);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addCategoryNotifierProvider);
    final notifier = ref.read(addCategoryNotifierProvider.notifier);
    final theme = Theme.of(context);
    
    final selectedColor = CategoryAssets.getColorFromHex(state.selectedColor);
    final selectedIconData = CategoryAssets.getIconData(state.selectedIcon);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          const SizedBox(height: 12.0),
          Container(
            width: 48.0,
            height: 6.0,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(99.0),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  color: theme.colorScheme.onSurfaceVariant,
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    'Tambah Kategori',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                // Spacer to balance the close button
                const SizedBox(width: 48.0),
              ],
            ),
          ),
          
          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.marginMobile,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type Toggle
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(99.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => notifier.setCategoryType('expense'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                color: state.categoryType == 'expense'
                                    ? theme.colorScheme.surface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(99.0),
                                boxShadow: state.categoryType == 'expense'
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 4.0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Pengeluaran',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: state.categoryType == 'expense'
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: state.categoryType == 'expense'
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => notifier.setCategoryType('income'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                color: state.categoryType == 'income'
                                    ? theme.colorScheme.surface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(99.0),
                                boxShadow: state.categoryType == 'income'
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 4.0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Pemasukan',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: state.categoryType == 'income'
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: state.categoryType == 'income'
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  
                  // Live Preview Card
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 56.0,
                            height: 56.0,
                            decoration: BoxDecoration(
                              color: selectedColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              selectedIconData,
                              color: selectedColor,
                              size: 28.0,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            state.categoryName.isEmpty ? 'Pratinjau Kategori' : state.categoryName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  
                  // Nama Kategori Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nama Kategori',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${state.categoryName.length}/30',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _nameController,
                    maxLength: 30,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Belanja Bulanan',
                      counterText: '',
                      hintStyle: TextStyle(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 14.0,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerLowest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: (val) => notifier.setCategoryName(val),
                  ),
                  const SizedBox(height: 24.0),
                  
                  // Pilih Ikon Section
                  Text(
                    'Pilih Ikon',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                    ),
                    itemCount: CategoryAssets.selectableIcons.length,
                    itemBuilder: (context, index) {
                      final iconName = CategoryAssets.selectableIcons[index];
                      final iconData = CategoryAssets.getIconData(iconName);
                      final isSelected = state.selectedIcon == iconName;
                      
                      return InkWell(
                        onTap: () => notifier.setSelectedIcon(iconName),
                        borderRadius: BorderRadius.circular(99.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceContainerLowest,
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: theme.colorScheme.surfaceContainerHighest,
                                  ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                                      blurRadius: 8.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            iconData,
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                            size: 22.0,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24.0),
                  
                  // Pilih Warna Section
                  Text(
                    'Pilih Warna',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  SizedBox(
                    height: 48.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: CategoryAssets.selectableColors.length,
                      itemBuilder: (context, index) {
                        final colorHex = CategoryAssets.selectableColors[index];
                        final colorVal = CategoryAssets.getColorFromHex(colorHex);
                        final isSelected = state.selectedColor == colorHex;
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: GestureDetector(
                            onTap: () => notifier.setSelectedColor(colorHex),
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorVal,
                                border: isSelected
                                    ? Border.all(
                                        color: theme.colorScheme.surface,
                                        width: 3.0,
                                      )
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: colorVal.withValues(alpha: 0.4),
                                          blurRadius: 6.0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: theme.colorScheme.onPrimary,
                                      size: 18.0,
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 16.0),
                    Text(
                      state.errorMessage!,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
          
          // Fixed Action Button
          Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  elevation: 2.0,
                ),
                onPressed: state.isSaving
                    ? null
                    : () async {
                        final success = await notifier.saveCategory();
                        if (success && context.mounted) {
                          Navigator.pop(context, true);
                        }
                      },
                child: state.isSaving
                    ? const SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text(
                        'Simpan Kategori',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
