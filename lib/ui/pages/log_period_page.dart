import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/ui/widget/back_app_bar.dart';
import 'package:menstrual_tracking_app/ui/widget/calandar_card.dart';

class LogPeriodPage extends StatefulWidget {
  const LogPeriodPage({super.key});

  @override
  State<LogPeriodPage> createState() => _LogPeriodPageState();
}

class _LogPeriodPageState extends State<LogPeriodPage> {
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
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  spacing: 40,
                  children: [
                    Text(
                      "Log Period date",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Column(
                      spacing: 20,
                      children: [
                        const CalandarLabel(label: 'Start Date *'),
                        const SelectableCalendar(),
                      ],
                    ),
                    Column(
                      spacing: 20,
                      children: [
                        const CalandarLabel(label: 'End Date *'),
                        const SelectableCalendar(),
                      ],
                    ),

                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xffE39895),
                        fixedSize: Size(350, 40),
                      ),
                      child: Text(
                        "Log Period",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
