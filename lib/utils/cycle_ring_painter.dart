import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/model/cycle_math.dart';

class CycleRingPainter extends CustomPainter {
  final CycleMath math;
  final double strokeWidth;

  // Cache common Paints to avoid reallocating them on each paint
  final Paint _backgroundPaint;
  final Paint _arcPaint;

  CycleRingPainter({required this.math, this.strokeWidth = 12})
    : _backgroundPaint = Paint()
        // ignore: deprecated_member_use
        ..color = Colors.grey.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
      _arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final pi = 3.141592653589793;

    final center = size.center(Offset.zero);
    final radius = size.width / 2 - strokeWidth;
    final startAngle = -pi / 2;

    double currentAngle = startAngle;

    void drawArc(int days, Color color) {
      final sweep = math.daysToAngle(days);
      _arcPaint.color = color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        sweep,
        false,
        _arcPaint,
      );

      currentAngle += sweep;
    }

    // Background
    canvas.drawCircle(center, radius, _backgroundPaint);

    drawArc(math.periodLength, const Color(0xFF7A0000)); // Menstrual
    drawArc(
      math.ovulationDay - math.periodLength - 1,
      const Color(0xFFFFB6C1),
    ); // Follicular
    drawArc(1, const Color(0xFFADD8E6)); // Ovulation
    drawArc(
      math.cycleLength - math.ovulationDay,
      const Color(0xFF3F51B5), // Luteal
    );
  }

  @override
  bool shouldRepaint(covariant CycleRingPainter oldDelegate) {
    // Repaint only when the underlying data changes
    return oldDelegate.math.cycleLength != math.cycleLength ||
        oldDelegate.math.periodLength != math.periodLength ||
        oldDelegate.math.currentDay != math.currentDay ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
