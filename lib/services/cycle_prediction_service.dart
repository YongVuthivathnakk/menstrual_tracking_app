import 'package:menstrual_tracking_app/services/period_calculations_service.dart';

import '../model/period_log.dart';
import '../services/menstrual_log_database.dart';

class CalendarPredictionService {
  PeriodCalculator? _calculator;

  Future<void> loadPeriodLogs() async {
    final logs = await MenstrualLogDatabase.instance.getPeriodLogs();
    if (logs.isEmpty) return;

    _calculator = PeriodCalculator(logs);
  }

  bool isDatePredicted(DateTime date) {
    if (_calculator == null) return false;
    return _calculator!.isDatePredicted(date);
  }

  List<PeriodLog> get periodLogs => _calculator?.periodLogs ?? [];
}
