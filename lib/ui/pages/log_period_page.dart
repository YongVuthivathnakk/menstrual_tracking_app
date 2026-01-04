import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/model/period_log.dart';
import 'package:menstrual_tracking_app/services/period_log_database.dart';
import 'package:menstrual_tracking_app/ui/widget/back_app_bar.dart';
import 'package:menstrual_tracking_app/ui/widget/calandar_card.dart';
import 'package:menstrual_tracking_app/ui/widget/empty_date_dialog.dart';
import 'package:menstrual_tracking_app/ui/widget/submit_button.dart';
import 'package:uuid/uuid.dart';

class LogPeriodPage extends StatefulWidget {
  const LogPeriodPage({super.key});

  @override
  State<LogPeriodPage> createState() => _LogPeriodPageState();
}

class _LogPeriodPageState extends State<LogPeriodPage> {
  DateTime? startDate;
  DateTime? endDate;

  int periodLength = 0;

  DateTime? get rangeEnd => startDate?.add(const Duration(days: 6));

  void onSubmit() async {
    if (startDate == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => EmptyDateDialog(),
      );
      return;
    }

    if (endDate == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => EmptyDateDialog(),
      );
      return;
    }

    final log = PeriodLog(
      id: Uuid().v4(),
      logDate: DateTime.now(),
      startDate: startDate!,
      endDate: endDate!,
    );

    await PeriodLogDatabase.instance.insertPeriodLog(log);
    final logs = await PeriodLogDatabase.instance.getAllPeriodLogs();
    debugPrint(logs.toString());

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  spacing: 30,
                  children: [
                    Text(
                      "Log Period date",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      spacing: 10,
                      children: [
                        const CalandarLabel(label: 'Start Date *'),
                        SelectableCalendar(
                          type: CalendarType.start,
                          startDate: startDate,
                          endDate: endDate,
                          onDateSelected: (date) {
                            setState(() {
                              startDate = date;
                              endDate = null; // reset end date
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      spacing: 10,
                      children: [
                        const CalandarLabel(label: 'End Date *'),
                        SelectableCalendar(
                          type: CalendarType.end,
                          startDate: startDate,
                          endDate: endDate,
                          onDateSelected: (date) {
                            setState(() {
                              endDate = date;
                            });
                          },
                        ),
                      ],
                    ),
                    SubmitButton(label: "Log Data", onSubmit: onSubmit),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalandarLabel extends StatelessWidget {
  final String label;

  const CalandarLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: TextStyle(fontWeight: FontWeight.w600));
  }
}
