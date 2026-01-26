import 'dart:ui';

enum CyclePhase {
  menstrual("Menstrual", Color(0xFF7A0000)),
  follicular("Follicular", Color(0xFFFFB6C1)),
  ovulation("Ovulation", Color(0xFFADD8E6)),
  luteal("Luteal", Color(0xFF3F51B5));

  final String label;
  final Color color;

  const CyclePhase(this.label, this.color);
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

  /// Ovulation is estimated 14 days before next period
  int get ovulationDay => cycleLength - 14;

  CyclePhase get currentPhase {
    if (currentDay <= periodLength) return CyclePhase.menstrual;
    if (currentDay < ovulationDay) return CyclePhase.follicular;
    if (currentDay == ovulationDay) return CyclePhase.ovulation;
    return CyclePhase.luteal;
  }

  /// 🔥 NEXT PHASE INFO (this is what you want)
  String get nextPhaseInfo {
    switch (currentPhase) {
      case CyclePhase.menstrual:
        final daysLeft = periodLength - currentDay + 1;
        return "FOLLICULAR: $daysLeft days left";

      case CyclePhase.follicular:
        final daysLeft = ovulationDay - currentDay;
        return "OVULATION: $daysLeft days left";

      case CyclePhase.ovulation:
        return "LUTEAL: 14 days left";

      case CyclePhase.luteal:
        final daysLeft = cycleLength - currentDay;
        return "MENSTRUAL: $daysLeft days left";
    }
  }

  double daysToAngle(int days) => (days / cycleLength) * 2 * 3.141592653589793;
}
