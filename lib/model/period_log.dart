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
    this.cycleLength = 28,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logDate': logDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'cycleLength': cycleLength,
    };
  }

  factory PeriodLog.fromMap(Map<String, dynamic> json) {
    return PeriodLog(
      id: json['id'],
      logDate: DateTime.parse(json['logDate']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      cycleLength: json['cycleLength'] ?? 28,
    );
  }

  @override
  String toString() {
    return 'PeriodLog(id: $id, start: ${startDate.toIso8601String()}, end: ${endDate.toIso8601String()}, cycle: $cycleLength days)';
  }
}
