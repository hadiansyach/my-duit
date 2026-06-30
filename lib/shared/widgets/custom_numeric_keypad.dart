import 'package:flutter/material.dart';

class CustomNumericKeypad extends StatelessWidget {
  final void Function(String) onKeyPress;
  final void Function() onBackspace;

  const CustomNumericKeypad({
    super.key,
    required this.onKeyPress,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildKey(String value, {Widget? child}) {
      return _KeypadButton(
        label: value,
        onTap: () => onKeyPress(value),
        child: child,
      );
    }

    Widget buildBackspaceKey() {
      return _KeypadButton(
        label: 'backspace',
        onTap: onBackspace,
        child: Icon(
          Icons.backspace_outlined,
          color: theme.colorScheme.onSurfaceVariant,
          size: 20.0,
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

class _KeypadButton extends StatefulWidget {
  final String label;
  final Widget? child;
  final VoidCallback onTap;

  const _KeypadButton({
    required this.label,
    this.child,
    required this.onTap,
  });

  @override
  State<_KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends State<_KeypadButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 40),
          height: 56.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isPressed
                ? theme.colorScheme.surfaceContainerHigh
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: widget.child ??
              Text(
                widget.label,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}
