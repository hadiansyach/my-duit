import 'package:flutter/material.dart';

class NumericKeypad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onBackspacePressed;

  const NumericKeypad({
    super.key,
    required this.onKeyPressed,
    required this.onBackspacePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildKey(String value, {Widget? child}) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onKeyPressed(value),
          borderRadius: BorderRadius.circular(16.0),
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
          child: Container(
            height: 56.0,
            alignment: Alignment.center,
            child:
                child ??
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
      );
    }

    Widget buildBackspaceKey() {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onBackspacePressed,
          borderRadius: BorderRadius.circular(16.0),
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
          child: Container(
            height: 56.0,
            alignment: Alignment.center,
            child: Icon(
              Icons.backspace_outlined,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20.0,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: buildKey('1')),
              Expanded(child: buildKey('2')),
              Expanded(child: buildKey('3')),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(child: buildKey('4')),
              Expanded(child: buildKey('5')),
              Expanded(child: buildKey('6')),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(child: buildKey('7')),
              Expanded(child: buildKey('8')),
              Expanded(child: buildKey('9')),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: buildKey(
                  '000',
                  child: Text(
                    '000',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(child: buildKey('0')),
              Expanded(child: buildBackspaceKey()),
            ],
          ),
        ],
      ),
    );
  }
}
