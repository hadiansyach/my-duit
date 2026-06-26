// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$watchCategoriesHash() => r'ec656406135a62eda4a4610f156e14467f3b4308';

/// See also [watchCategories].
@ProviderFor(watchCategories)
final watchCategoriesProvider =
    AutoDisposeStreamProvider<List<Category>>.internal(
      watchCategories,
      name: r'watchCategoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$watchCategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WatchCategoriesRef = AutoDisposeStreamProviderRef<List<Category>>;
String _$categoryTransactionCountsHash() =>
    r'5e801ef83a1188f7ac09096946674c521eff9578';

/// See also [categoryTransactionCounts].
@ProviderFor(categoryTransactionCounts)
final categoryTransactionCountsProvider =
    AutoDisposeStreamProvider<Map<int, int>>.internal(
      categoryTransactionCounts,
      name: r'categoryTransactionCountsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryTransactionCountsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryTransactionCountsRef =
    AutoDisposeStreamProviderRef<Map<int, int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
