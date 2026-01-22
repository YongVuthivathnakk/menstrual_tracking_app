import 'package:menstrual_tracking_app/model/period_log.dart';

class PeriodCalculator {
  final List<PeriodLog> periodLogs;
  late final DateTime earliestStartDate;
  late final int averagePeriodLength;

  PeriodCalculator(this.periodLogs) {
    if (periodLogs.isEmpty) {
      throw Exception("No period logs available");
    }

    // Calculate earliest start date
    earliestStartDate = periodLogs
        .map((log) => log.startDate)
        .reduce((a, b) => a.isBefore(b) ? a : b);

    // Calculate average period length
    int totalDays = periodLogs
        .map((log) => log.endDate.difference(log.startDate).inDays + 1)
        .reduce((a, b) => a + b);

    averagePeriodLength = (totalDays / periodLogs.length).round();
  }

  bool isDatePredicted(DateTime date) {
    final anchor = DateTime(
      earliestStartDate.year,
      earliestStartDate.month,
      earliestStartDate.day,
    );

    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate.isBefore(anchor)) return false;

    final totalDaysSinceStart = checkDate.difference(anchor).inDays;
    final cycleDay = totalDaysSinceStart % 28;

    final window = averagePeriodLength > 0 ? averagePeriodLength : 5;

    return cycleDay >= 0 && cycleDay < window;
  }
}
