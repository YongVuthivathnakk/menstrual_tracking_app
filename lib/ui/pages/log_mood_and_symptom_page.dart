import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/ui/widget/back_app_bar.dart';
import 'package:menstrual_tracking_app/ui/widget/log_mood_and_symptom_card.dart';

class LogMoodAndSymptomPage extends StatefulWidget {
  const LogMoodAndSymptomPage({super.key});

  @override
  State<LogMoodAndSymptomPage> createState() => _LogMoodAndSymptomPageState();
}

class _LogMoodAndSymptomPageState extends State<LogMoodAndSymptomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: BackAppBar(), body: LogMoodAndSymptomCard());
  }
}
