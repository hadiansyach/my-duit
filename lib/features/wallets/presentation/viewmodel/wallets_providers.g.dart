// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallets_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletAccountsHash() => r'66010aa5fbb39cfdd5c7fbaf31cf950660d5c649';

/// See also [walletAccounts].
@ProviderFor(walletAccounts)
final walletAccountsProvider =
    AutoDisposeStreamProvider<List<WalletGroupModel>>.internal(
      walletAccounts,
      name: r'walletAccountsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$walletAccountsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WalletAccountsRef =
    AutoDisposeStreamProviderRef<List<WalletGroupModel>>;
String _$totalBalanceHash() => r'fc220f096f2efc21defd76ec4fabe0e252e646e7';

/// See also [totalBalance].
@ProviderFor(totalBalance)
final totalBalanceProvider = AutoDisposeProvider<double>.internal(
  totalBalance,
  name: r'totalBalanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalBalanceRef = AutoDisposeProviderRef<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
