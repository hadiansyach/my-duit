// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_account_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$manageAccountWalletHash() =>
    r'87527619833fc35578a192894d37a0de4eeb1781';

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

/// See also [manageAccountWallet].
@ProviderFor(manageAccountWallet)
const manageAccountWalletProvider = ManageAccountWalletFamily();

/// See also [manageAccountWallet].
class ManageAccountWalletFamily extends Family<AsyncValue<Wallet?>> {
  /// See also [manageAccountWallet].
  const ManageAccountWalletFamily();

  /// See also [manageAccountWallet].
  ManageAccountWalletProvider call(int accountId) {
    return ManageAccountWalletProvider(accountId);
  }

  @override
  ManageAccountWalletProvider getProviderOverride(
    covariant ManageAccountWalletProvider provider,
  ) {
    return call(provider.accountId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'manageAccountWalletProvider';
}

/// See also [manageAccountWallet].
class ManageAccountWalletProvider extends AutoDisposeStreamProvider<Wallet?> {
  /// See also [manageAccountWallet].
  ManageAccountWalletProvider(int accountId)
    : this._internal(
        (ref) => manageAccountWallet(ref as ManageAccountWalletRef, accountId),
        from: manageAccountWalletProvider,
        name: r'manageAccountWalletProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$manageAccountWalletHash,
        dependencies: ManageAccountWalletFamily._dependencies,
        allTransitiveDependencies:
            ManageAccountWalletFamily._allTransitiveDependencies,
        accountId: accountId,
      );

  ManageAccountWalletProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
  }) : super.internal();

  final int accountId;

  @override
  Override overrideWith(
    Stream<Wallet?> Function(ManageAccountWalletRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ManageAccountWalletProvider._internal(
        (ref) => create(ref as ManageAccountWalletRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Wallet?> createElement() {
    return _ManageAccountWalletProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ManageAccountWalletProvider && other.accountId == accountId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ManageAccountWalletRef on AutoDisposeStreamProviderRef<Wallet?> {
  /// The parameter `accountId` of this provider.
  int get accountId;
}

class _ManageAccountWalletProviderElement
    extends AutoDisposeStreamProviderElement<Wallet?>
    with ManageAccountWalletRef {
  _ManageAccountWalletProviderElement(super.provider);

  @override
  int get accountId => (origin as ManageAccountWalletProvider).accountId;
}

String _$manageAccountTransactionsHash() =>
    r'ebb54ee4746713d1cebc3ee1017fb54ee8d1e209';

/// See also [manageAccountTransactions].
@ProviderFor(manageAccountTransactions)
const manageAccountTransactionsProvider = ManageAccountTransactionsFamily();

/// See also [manageAccountTransactions].
class ManageAccountTransactionsFamily
    extends Family<AsyncValue<List<TransactionWithCategory>>> {
  /// See also [manageAccountTransactions].
  const ManageAccountTransactionsFamily();

  /// See also [manageAccountTransactions].
  ManageAccountTransactionsProvider call(int accountId) {
    return ManageAccountTransactionsProvider(accountId);
  }

  @override
  ManageAccountTransactionsProvider getProviderOverride(
    covariant ManageAccountTransactionsProvider provider,
  ) {
    return call(provider.accountId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'manageAccountTransactionsProvider';
}

/// See also [manageAccountTransactions].
class ManageAccountTransactionsProvider
    extends AutoDisposeStreamProvider<List<TransactionWithCategory>> {
  /// See also [manageAccountTransactions].
  ManageAccountTransactionsProvider(int accountId)
    : this._internal(
        (ref) => manageAccountTransactions(
          ref as ManageAccountTransactionsRef,
          accountId,
        ),
        from: manageAccountTransactionsProvider,
        name: r'manageAccountTransactionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$manageAccountTransactionsHash,
        dependencies: ManageAccountTransactionsFamily._dependencies,
        allTransitiveDependencies:
            ManageAccountTransactionsFamily._allTransitiveDependencies,
        accountId: accountId,
      );

  ManageAccountTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
  }) : super.internal();

  final int accountId;

  @override
  Override overrideWith(
    Stream<List<TransactionWithCategory>> Function(
      ManageAccountTransactionsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ManageAccountTransactionsProvider._internal(
        (ref) => create(ref as ManageAccountTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TransactionWithCategory>>
  createElement() {
    return _ManageAccountTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ManageAccountTransactionsProvider &&
        other.accountId == accountId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ManageAccountTransactionsRef
    on AutoDisposeStreamProviderRef<List<TransactionWithCategory>> {
  /// The parameter `accountId` of this provider.
  int get accountId;
}

class _ManageAccountTransactionsProviderElement
    extends AutoDisposeStreamProviderElement<List<TransactionWithCategory>>
    with ManageAccountTransactionsRef {
  _ManageAccountTransactionsProviderElement(super.provider);

  @override
  int get accountId => (origin as ManageAccountTransactionsProvider).accountId;
}

String _$manageAccountDataHash() => r'a2962ffd8e71d3e4bf37e5196e000630cadf2a52';

/// See also [manageAccountData].
@ProviderFor(manageAccountData)
const manageAccountDataProvider = ManageAccountDataFamily();

/// See also [manageAccountData].
class ManageAccountDataFamily extends Family<ManageAccountData?> {
  /// See also [manageAccountData].
  const ManageAccountDataFamily();

  /// See also [manageAccountData].
  ManageAccountDataProvider call(int accountId) {
    return ManageAccountDataProvider(accountId);
  }

  @override
  ManageAccountDataProvider getProviderOverride(
    covariant ManageAccountDataProvider provider,
  ) {
    return call(provider.accountId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'manageAccountDataProvider';
}

/// See also [manageAccountData].
class ManageAccountDataProvider
    extends AutoDisposeProvider<ManageAccountData?> {
  /// See also [manageAccountData].
  ManageAccountDataProvider(int accountId)
    : this._internal(
        (ref) => manageAccountData(ref as ManageAccountDataRef, accountId),
        from: manageAccountDataProvider,
        name: r'manageAccountDataProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$manageAccountDataHash,
        dependencies: ManageAccountDataFamily._dependencies,
        allTransitiveDependencies:
            ManageAccountDataFamily._allTransitiveDependencies,
        accountId: accountId,
      );

  ManageAccountDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
  }) : super.internal();

  final int accountId;

  @override
  Override overrideWith(
    ManageAccountData? Function(ManageAccountDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ManageAccountDataProvider._internal(
        (ref) => create(ref as ManageAccountDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<ManageAccountData?> createElement() {
    return _ManageAccountDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ManageAccountDataProvider && other.accountId == accountId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ManageAccountDataRef on AutoDisposeProviderRef<ManageAccountData?> {
  /// The parameter `accountId` of this provider.
  int get accountId;
}

class _ManageAccountDataProviderElement
    extends AutoDisposeProviderElement<ManageAccountData?>
    with ManageAccountDataRef {
  _ManageAccountDataProviderElement(super.provider);

  @override
  int get accountId => (origin as ManageAccountDataProvider).accountId;
}

String _$manageAccountNotifierHash() =>
    r'6c96de35961dd3b55f95f59e8ecf9e30a211e98c';

abstract class _$ManageAccountNotifier
    extends BuildlessAutoDisposeAsyncNotifier<void> {
  late final int accountId;

  FutureOr<void> build(int accountId);
}

/// See also [ManageAccountNotifier].
@ProviderFor(ManageAccountNotifier)
const manageAccountNotifierProvider = ManageAccountNotifierFamily();

/// See also [ManageAccountNotifier].
class ManageAccountNotifierFamily extends Family<AsyncValue<void>> {
  /// See also [ManageAccountNotifier].
  const ManageAccountNotifierFamily();

  /// See also [ManageAccountNotifier].
  ManageAccountNotifierProvider call(int accountId) {
    return ManageAccountNotifierProvider(accountId);
  }

  @override
  ManageAccountNotifierProvider getProviderOverride(
    covariant ManageAccountNotifierProvider provider,
  ) {
    return call(provider.accountId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'manageAccountNotifierProvider';
}

/// See also [ManageAccountNotifier].
class ManageAccountNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ManageAccountNotifier, void> {
  /// See also [ManageAccountNotifier].
  ManageAccountNotifierProvider(int accountId)
    : this._internal(
        () => ManageAccountNotifier()..accountId = accountId,
        from: manageAccountNotifierProvider,
        name: r'manageAccountNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$manageAccountNotifierHash,
        dependencies: ManageAccountNotifierFamily._dependencies,
        allTransitiveDependencies:
            ManageAccountNotifierFamily._allTransitiveDependencies,
        accountId: accountId,
      );

  ManageAccountNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
  }) : super.internal();

  final int accountId;

  @override
  FutureOr<void> runNotifierBuild(covariant ManageAccountNotifier notifier) {
    return notifier.build(accountId);
  }

  @override
  Override overrideWith(ManageAccountNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ManageAccountNotifierProvider._internal(
        () => create()..accountId = accountId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ManageAccountNotifier, void>
  createElement() {
    return _ManageAccountNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ManageAccountNotifierProvider &&
        other.accountId == accountId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ManageAccountNotifierRef on AutoDisposeAsyncNotifierProviderRef<void> {
  /// The parameter `accountId` of this provider.
  int get accountId;
}

class _ManageAccountNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ManageAccountNotifier, void>
    with ManageAccountNotifierRef {
  _ManageAccountNotifierProviderElement(super.provider);

  @override
  int get accountId => (origin as ManageAccountNotifierProvider).accountId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
