import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/model/cycle_math.dart';
import 'package:menstrual_tracking_app/utils/cycle_ring_painter.dart';

class MenstrualCycleRing extends StatelessWidget {
  final int cycleLength;
  final int periodLength;
  final int currentDay;

  const MenstrualCycleRing({
    super.key,
    required this.cycleLength,
    required this.periodLength,
    required this.currentDay,
  });

  @override
  Widget build(BuildContext context) {
    final math = CycleMath(
      cycleLength: cycleLength,
      periodLength: periodLength,
      currentDay: currentDay,
    );

    final phase = math.currentPhase;
    final angle =
        (currentDay / cycleLength) * 2 * 3.141592653589793 -
        (3.141592653589793 / 2);

    return SizedBox(
      width: 225,
      height: 225,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(225, 225),
            painter: CycleRingPainter(math: math),
          ),
          CycleCenterText(
            day: currentDay,
            phase: phase.label, // Accessed from enum
            ovulationInfo: phase.info, // Accessed from enum
          ),
          CycleHeart(
            angle: angle,
            radius: 110,
            color: phase.color, // Accessed from enum
          ),
        ],
      ),
    );
  }
}

class CycleCenterText extends StatelessWidget {
  final int day;
  final String phase;
  final String ovulationInfo;

  const CycleCenterText({
    super.key,
    required this.day,
    required this.phase,
    required this.ovulationInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Day $day',
          style: TextStyle(
            fontSize: 18,
            color: Colors.red.shade300,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          phase,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(width: 40, height: 2, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        Text(
          ovulationInfo,
          style: const TextStyle(
            fontSize: 14,
            letterSpacing: 1.2,
            color: Colors.blue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class CycleHeart extends StatelessWidget {
  final double angle;
  final double radius;
  final Color color;

  const CycleHeart({
    super.key,
    required this.angle,
    required this.radius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle, // orbit rotation
      child: Transform.translate(
        offset: Offset(radius, 0),
        child: Transform.rotate(
          angle: -angle, // 👈 counter rotation (keeps icon straight)
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4),
              ],
            ),
            child: Icon(Icons.favorite, size: 16, color: color),
          ),
        ),
      ),
    );
  }
}
