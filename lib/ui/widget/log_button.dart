import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/model/period_log.dart';
import 'package:menstrual_tracking_app/services/menstrual_log_database.dart';
import 'package:menstrual_tracking_app/ui/pages/log_mood_and_symptom_page.dart';
import 'package:menstrual_tracking_app/ui/pages/log_period_page.dart';

// Log Period Button
class LogPeriodButton extends StatefulWidget {
  final VoidCallback onDataChanged;
  const LogPeriodButton({super.key, required this.onDataChanged});

  @override
  State<LogPeriodButton> createState() => _LogPeriodButtonState();
}

class _LogPeriodButtonState extends State<LogPeriodButton> {
  @override
  Widget build(BuildContext context) {
    void onLog() async {
      PeriodLog? item = await Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LogPeriodPage()),
      );

      if (item != null) {
        await MenstrualLogDatabase.instance.insertPeriodLog(item);
        widget.onDataChanged();
        // Notify History and other listeners
      }
    }

    return TextButton(
      onPressed: onLog,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xffE39895),
        minimumSize: const Size(120, 40),
      ),
      child: const Text(
        "Log Period",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Log Mood and Symptom Button
class LogMoodAndSymptomButton extends StatefulWidget {
  const LogMoodAndSymptomButton({super.key});

  @override
  State<LogMoodAndSymptomButton> createState() =>
      _LogMoodAndSymptomButtonState();
}

class _LogMoodAndSymptomButtonState extends State<LogMoodAndSymptomButton> {
  @override
  Widget build(BuildContext context) {
    void onLog() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LogMoodAndSymptomPage(),
        ),
      );

      if (result == true) {
        // Notify History and other listeners
      }
    }

    return TextButton(
      onPressed: onLog,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xff3396D3),
        minimumSize: const Size(120, 40),
      ),
      child: Text(
        "Log Symptoms",
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
