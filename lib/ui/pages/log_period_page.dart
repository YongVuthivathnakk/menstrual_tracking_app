import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/ui/widget/back_app_bar.dart';
import 'package:menstrual_tracking_app/ui/widget/log_period_card.dart';

class LogPeriodPage extends StatefulWidget {
  const LogPeriodPage({super.key});

  @override
  State<LogPeriodPage> createState() => _LogPeriodPageState();
}

class _LogPeriodPageState extends State<LogPeriodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: BackAppBar(), body: LogPeriodCard());
  }
}
