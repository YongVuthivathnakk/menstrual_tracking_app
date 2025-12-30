class PeriodLog {
  final String id;
  final DateTime logDate;
  final DateTime startDate;
  final DateTime endDate;
  final int cycleLength;

  const PeriodLog({
    required this.id,
    required this.logDate,
    required this.startDate,
    required this.endDate,
    required this.cycleLength,
  });
}
