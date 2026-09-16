import 'package:flutter/material.dart';
import '../theme/brondix_theme.dart';

class StampPunchCardPainter extends CustomPainter {
  final int totalPunches; // e.g. 8 or 10
  final int completedPunches; // e.g. 5

  StampPunchCardPainter({
    required this.totalPunches,
    required this.completedPunches,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Perforated card body
    final cardRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(12, 12, w - 24, h - 24),
      const Radius.circular(16),
    );
    final bgPaint = Paint()
      ..color = BrondixTheme.surface
      ..style = PaintingStyle.fill;
    canvas.drawRRect(cardRRect, bgPaint);

    final borderPaint = Paint()
      ..color = BrondixTheme.edge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(cardRRect, borderPaint);

    // Left & Right punch notches
    final notchPaint = Paint()
      ..color = BrondixTheme.bg
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(12, h / 2), 12.0, notchPaint);
    canvas.drawCircle(Offset(w - 12, h / 2), 12.0, notchPaint);

    // Punch circles grid: 2 rows
    final cols = (totalPunches / 2).ceil();
    final colSpacing = (w - 72) / (cols > 1 ? cols - 1 : 1);
    final row1Y = h * 0.38;
    final row2Y = h * 0.68;

    for (int i = 0; i < totalPunches; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final x = 36 + col * colSpacing;
      final y = row == 0 ? row1Y : row2Y;

      final isPunched = i < completedPunches;

      if (isPunched) {
        // Punched star stamp
        final punchBg = Paint()
          ..color = BrondixTheme.accent
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), 14.0, punchBg);

        final starPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), 4.0, starPaint);
      } else {
        // Empty dashed circle slot
        final emptyPaint = Paint()
          ..color = BrondixTheme.edge
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawCircle(Offset(x, y), 14.0, emptyPaint);

        final centerDot = Paint()
          ..color = BrondixTheme.edge
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), 2.5, centerDot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant StampPunchCardPainter oldDelegate) {
    return oldDelegate.totalPunches != totalPunches ||
        oldDelegate.completedPunches != completedPunches;
  }
}
