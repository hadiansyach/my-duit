import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/add_transaction_providers.dart';

class CustomNumericKeypad extends ConsumerWidget {
  const CustomNumericKeypad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Widget buildKeypadButton(String label, {VoidCallback? onTap, Widget? child}) {
      return Expanded(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap ?? () {
              ref.read(addTransactionAmountProvider.notifier).appendNumber(label);
            },
            borderRadius: BorderRadius.circular(9999.0),
            child: Container(
              height: 56.0,
              alignment: Alignment.center,
              child: child ?? Text(
                label,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 360.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              buildKeypadButton('1'),
              buildKeypadButton('2'),
              buildKeypadButton('3'),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              buildKeypadButton('4'),
              buildKeypadButton('5'),
              buildKeypadButton('6'),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              buildKeypadButton('7'),
              buildKeypadButton('8'),
              buildKeypadButton('9'),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              buildKeypadButton(
                '000',
                onTap: () => ref.read(addTransactionAmountProvider.notifier).appendTripleZero(),
              ),
              buildKeypadButton('0'),
              buildKeypadButton(
                'backspace',
                onTap: () => ref.read(addTransactionAmountProvider.notifier).removeLast(),
                child: Icon(
                  Icons.backspace_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
