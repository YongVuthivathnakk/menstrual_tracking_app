import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/ui/pages/log_mood_and_symptom_page.dart';
import 'package:menstrual_tracking_app/ui/pages/log_period_page.dart';

// Log Period Button
class LogPeriodButton extends StatefulWidget {
  const LogPeriodButton({super.key});

  @override
  State<LogPeriodButton> createState() => _LogPeriodButtonState();
}

class _LogPeriodButtonState extends State<LogPeriodButton> {
  @override
  Widget build(BuildContext context) {
    void onLog() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LogPeriodPage()),
      );
    }

    return TextButton(
      onPressed: onLog,
      style: TextButton.styleFrom(
        backgroundColor: Color(0xffE39895),
        minimumSize: const Size(175, 40),
      ),
      child: Text(
        "Log Period",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight(600)),
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
    void onLog() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LogMoodAndSymptomPage(),
        ),
      );
    }

    return TextButton(
      onPressed: onLog,
      style: TextButton.styleFrom(
        backgroundColor: Color(0xff3396D3),
        minimumSize: const Size(175, 40),
      ),
      child: Text(
        "Log Mood & Symptoms",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight(600)),
      ),
    );
  }
}
