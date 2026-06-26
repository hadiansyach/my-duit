// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_category_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$watchCategoryByIdHash() => r'519f70df2abc5ebc95641de8bea429721260c45c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [watchCategoryById].
@ProviderFor(watchCategoryById)
const watchCategoryByIdProvider = WatchCategoryByIdFamily();

/// See also [watchCategoryById].
class WatchCategoryByIdFamily extends Family<AsyncValue<Category?>> {
  /// See also [watchCategoryById].
  const WatchCategoryByIdFamily();

  /// See also [watchCategoryById].
  WatchCategoryByIdProvider call(int categoryId) {
    return WatchCategoryByIdProvider(categoryId);
  }

  @override
  WatchCategoryByIdProvider getProviderOverride(
    covariant WatchCategoryByIdProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'watchCategoryByIdProvider';
}

/// See also [watchCategoryById].
class WatchCategoryByIdProvider extends AutoDisposeStreamProvider<Category?> {
  /// See also [watchCategoryById].
  WatchCategoryByIdProvider(int categoryId)
    : this._internal(
        (ref) => watchCategoryById(ref as WatchCategoryByIdRef, categoryId),
        from: watchCategoryByIdProvider,
        name: r'watchCategoryByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$watchCategoryByIdHash,
        dependencies: WatchCategoryByIdFamily._dependencies,
        allTransitiveDependencies:
            WatchCategoryByIdFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  WatchCategoryByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final int categoryId;

  @override
  Override overrideWith(
    Stream<Category?> Function(WatchCategoryByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchCategoryByIdProvider._internal(
        (ref) => create(ref as WatchCategoryByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Category?> createElement() {
    return _WatchCategoryByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchCategoryByIdProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WatchCategoryByIdRef on AutoDisposeStreamProviderRef<Category?> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;
}

class _WatchCategoryByIdProviderElement
    extends AutoDisposeStreamProviderElement<Category?>
    with WatchCategoryByIdRef {
  _WatchCategoryByIdProviderElement(super.provider);

  @override
  int get categoryId => (origin as WatchCategoryByIdProvider).categoryId;
}

String _$watchCategoryTransactionsHash() =>
    r'5b1fd7b6126c491b6182bd6891695d62e95a001e';

/// See also [watchCategoryTransactions].
@ProviderFor(watchCategoryTransactions)
const watchCategoryTransactionsProvider = WatchCategoryTransactionsFamily();

/// See also [watchCategoryTransactions].
class WatchCategoryTransactionsFamily
    extends Family<AsyncValue<List<Transaction>>> {
  /// See also [watchCategoryTransactions].
  const WatchCategoryTransactionsFamily();

  /// See also [watchCategoryTransactions].
  WatchCategoryTransactionsProvider call(int categoryId) {
    return WatchCategoryTransactionsProvider(categoryId);
  }

  @override
  WatchCategoryTransactionsProvider getProviderOverride(
    covariant WatchCategoryTransactionsProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'watchCategoryTransactionsProvider';
}

/// See also [watchCategoryTransactions].
class WatchCategoryTransactionsProvider
    extends AutoDisposeStreamProvider<List<Transaction>> {
  /// See also [watchCategoryTransactions].
  WatchCategoryTransactionsProvider(int categoryId)
    : this._internal(
        (ref) => watchCategoryTransactions(
          ref as WatchCategoryTransactionsRef,
          categoryId,
        ),
        from: watchCategoryTransactionsProvider,
        name: r'watchCategoryTransactionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$watchCategoryTransactionsHash,
        dependencies: WatchCategoryTransactionsFamily._dependencies,
        allTransitiveDependencies:
            WatchCategoryTransactionsFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  WatchCategoryTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final int categoryId;

  @override
  Override overrideWith(
    Stream<List<Transaction>> Function(WatchCategoryTransactionsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchCategoryTransactionsProvider._internal(
        (ref) => create(ref as WatchCategoryTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Transaction>> createElement() {
    return _WatchCategoryTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchCategoryTransactionsProvider &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WatchCategoryTransactionsRef
    on AutoDisposeStreamProviderRef<List<Transaction>> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;
}

class _WatchCategoryTransactionsProviderElement
    extends AutoDisposeStreamProviderElement<List<Transaction>>
    with WatchCategoryTransactionsRef {
  _WatchCategoryTransactionsProviderElement(super.provider);

  @override
  int get categoryId =>
      (origin as WatchCategoryTransactionsProvider).categoryId;
}

String _$watchCategoryMonthlyTotalHash() =>
    r'28ec959030b25a519cd55ceeb34ba2ce56561a9f';

/// See also [watchCategoryMonthlyTotal].
@ProviderFor(watchCategoryMonthlyTotal)
const watchCategoryMonthlyTotalProvider = WatchCategoryMonthlyTotalFamily();

/// See also [watchCategoryMonthlyTotal].
class WatchCategoryMonthlyTotalFamily extends Family<AsyncValue<double>> {
  /// See also [watchCategoryMonthlyTotal].
  const WatchCategoryMonthlyTotalFamily();

  /// See also [watchCategoryMonthlyTotal].
  WatchCategoryMonthlyTotalProvider call(int categoryId) {
    return WatchCategoryMonthlyTotalProvider(categoryId);
  }

  @override
  WatchCategoryMonthlyTotalProvider getProviderOverride(
    covariant WatchCategoryMonthlyTotalProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'watchCategoryMonthlyTotalProvider';
}

/// See also [watchCategoryMonthlyTotal].
class WatchCategoryMonthlyTotalProvider
    extends AutoDisposeStreamProvider<double> {
  /// See also [watchCategoryMonthlyTotal].
  WatchCategoryMonthlyTotalProvider(int categoryId)
    : this._internal(
        (ref) => watchCategoryMonthlyTotal(
          ref as WatchCategoryMonthlyTotalRef,
          categoryId,
        ),
        from: watchCategoryMonthlyTotalProvider,
        name: r'watchCategoryMonthlyTotalProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$watchCategoryMonthlyTotalHash,
        dependencies: WatchCategoryMonthlyTotalFamily._dependencies,
        allTransitiveDependencies:
            WatchCategoryMonthlyTotalFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  WatchCategoryMonthlyTotalProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final int categoryId;

  @override
  Override overrideWith(
    Stream<double> Function(WatchCategoryMonthlyTotalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchCategoryMonthlyTotalProvider._internal(
        (ref) => create(ref as WatchCategoryMonthlyTotalRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<double> createElement() {
    return _WatchCategoryMonthlyTotalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchCategoryMonthlyTotalProvider &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WatchCategoryMonthlyTotalRef on AutoDisposeStreamProviderRef<double> {
  /// The parameter `categoryId` of this provider.
  int get categoryId;
}

class _WatchCategoryMonthlyTotalProviderElement
    extends AutoDisposeStreamProviderElement<double>
    with WatchCategoryMonthlyTotalRef {
  _WatchCategoryMonthlyTotalProviderElement(super.provider);

  @override
  int get categoryId =>
      (origin as WatchCategoryMonthlyTotalProvider).categoryId;
}

String _$manageCategoryNotifierHash() =>
    r'f11fe252c1d248e5eb2e72fcf6bd8a1236581cf0';

/// See also [ManageCategoryNotifier].
@ProviderFor(ManageCategoryNotifier)
final manageCategoryNotifierProvider =
    AutoDisposeNotifierProvider<ManageCategoryNotifier, void>.internal(
      ManageCategoryNotifier.new,
      name: r'manageCategoryNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$manageCategoryNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ManageCategoryNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
