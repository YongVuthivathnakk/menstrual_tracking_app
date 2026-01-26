import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/model/cycle_math.dart';
import 'package:menstrual_tracking_app/utils/cycle_ring_painter.dart';

class MenstrualCycleRing extends StatefulWidget {
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
  State<MenstrualCycleRing> createState() => _MenstrualCycleRingState();
}

class _MenstrualCycleRingState extends State<MenstrualCycleRing> {
  @override
  Widget build(BuildContext context) {
    final math = CycleMath(
      cycleLength: widget.cycleLength,
      periodLength: widget.periodLength,
      currentDay: widget.currentDay,
    );

    final phase = math.currentPhase;
    final nextPhase = math.nextPhaseInfo;
    final angle =
        (widget.currentDay / widget.cycleLength) * 2 * 3.141592653589793 -
        (3.141592653589793 / 2);

    return SizedBox(
      width: 250,
      height: 250,
      child: RepaintBoundary(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(250, 250),
              painter: CycleRingPainter(math: math),
            ),
            CycleCenterText(
              periodLength: widget.periodLength,
              day: widget.currentDay,
              phase: phase.label, // Accessed from enum
              ovulationInfo: nextPhase, // Accessed from enum
            ),
            widget.periodLength != 0
                ? CycleHeart(
                    angle: angle,
                    radius: 125,
                    color: phase.color, // Accessed from enum
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class CycleCenterText extends StatefulWidget {
  final int day;
  final int periodLength;
  final String phase;
  final String ovulationInfo;

  const CycleCenterText({
    super.key,
    required this.day,
    required this.phase,
    required this.ovulationInfo,
    required this.periodLength,
  });

  @override
  State<CycleCenterText> createState() => _CycleCenterTextState();
}

class _CycleCenterTextState extends State<CycleCenterText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Day ${widget.periodLength != 0 ? widget.day : 0}',
          style: TextStyle(
            fontSize: 18,
            color: Colors.red.shade300,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.periodLength != 0 ? widget.phase : "No Data",
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(width: 40, height: 2, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        Text(
          widget.periodLength != 0 ? widget.ovulationInfo : "NO DATA",
          style: const TextStyle(
            fontSize: 12,
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
          angle: -angle, // counter rotation (keeps the heart icon straight)
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
