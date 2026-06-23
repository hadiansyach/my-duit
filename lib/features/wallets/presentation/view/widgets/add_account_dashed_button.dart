import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_duit/core/theme/app_radius.dart';

class AddAccountDashedButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddAccountDashedButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.buttons),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: theme.colorScheme.outline,
          borderRadius: AppRadius.buttons,
          strokeWidth: 1.0,
          dashLength: 6.0,
          gapLength: 4.0,
        ),
        child: Container(
          width: double.infinity,
          height: 48.0,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Tambah Akun Baru',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashLength = 5.0,
    this.gapLength = 3.0,
    this.borderRadius = 24.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = dashLength;
        final Path extractPath = metric.extractPath(
          distance,
          (distance + length).clamp(0.0, metric.length),
        );
        canvas.drawPath(extractPath, paint);
        distance += length + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.gapLength != gapLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
