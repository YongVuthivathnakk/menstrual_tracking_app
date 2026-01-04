import 'dart:ui';

enum CyclePhase {
  menstrual("Menstrual", "PERIOD PHASE", Color(0xFF7A0000)),
  follicular("Follicular", "CHANCE OF CONCEIVING: LOW", Color(0xFFFFB6C1)),
  ovulation("Ovulation", "HIGH FERTILITY", Color(0xFFADD8E6)),
  luteal("Luteal", "PREMENSTRUAL PHASE", Color(0xFF3F51B5));

  final String label;
  final String info;
  final Color color;

  const CyclePhase(this.label, this.info, this.color);
}

class CycleMath {
  final int cycleLength;
  final int periodLength;
  final int currentDay;

  CycleMath({
    required this.cycleLength,
    required this.periodLength,
    required this.currentDay,
  });

  // Most medical apps estimate ovulation at 14 days BEFORE the next period
  int get ovulationDay => cycleLength - 14;

  CyclePhase get currentPhase {
    if (currentDay <= periodLength) return CyclePhase.menstrual;
    if (currentDay < ovulationDay) return CyclePhase.follicular;
    if (currentDay == ovulationDay) return CyclePhase.ovulation;
    return CyclePhase.luteal;
  }

  double daysToAngle(int days) => (days / cycleLength) * 2 * 3.141592653589793;
}
