import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/transaction_providers.dart';

class TransactionsSearchBar extends ConsumerStatefulWidget {
  const TransactionsSearchBar({super.key});

  @override
  ConsumerState<TransactionsSearchBar> createState() => _TransactionsSearchBarState();
}

class _TransactionsSearchBarState extends ConsumerState<TransactionsSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(transactionSearchQueryProvider);
    _controller = TextEditingController(text: initialQuery);
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        ref.read(transactionSearchQueryProvider.notifier).state = value;
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 12.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        decoration: InputDecoration(
          hintText: 'Cari transaksi...',
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.outline,
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerLowest,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: theme.colorScheme.surfaceContainerHigh,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
