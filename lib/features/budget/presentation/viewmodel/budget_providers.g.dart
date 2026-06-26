// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetSummaryHash() => r'a9ecd35865fabce0af2e7f1073887711c543f0cd';

/// See also [budgetSummary].
@ProviderFor(budgetSummary)
final budgetSummaryProvider = AutoDisposeProvider<BudgetSummaryModel>.internal(
  budgetSummary,
  name: r'budgetSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetSummaryRef = AutoDisposeProviderRef<BudgetSummaryModel>;
String _$budgetPeriodFilterHash() =>
    r'7f7b3fce1b34886fefb232c2affc5f3ba03f6de8';

/// See also [BudgetPeriodFilter].
@ProviderFor(BudgetPeriodFilter)
final budgetPeriodFilterProvider =
    AutoDisposeNotifierProvider<BudgetPeriodFilter, String>.internal(
      BudgetPeriodFilter.new,
      name: r'budgetPeriodFilterProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$budgetPeriodFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BudgetPeriodFilter = AutoDisposeNotifier<String>;
String _$budgetCategoriesNotifierHash() =>
    r'3cf2465a709ea6370724bb3c1b0f79e58694c213';

/// See also [BudgetCategoriesNotifier].
@ProviderFor(BudgetCategoriesNotifier)
final budgetCategoriesNotifierProvider =
    AutoDisposeNotifierProvider<
      BudgetCategoriesNotifier,
      List<BudgetCategoryModel>
    >.internal(
      BudgetCategoriesNotifier.new,
      name: r'budgetCategoriesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$budgetCategoriesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BudgetCategoriesNotifier =
    AutoDisposeNotifier<List<BudgetCategoryModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
