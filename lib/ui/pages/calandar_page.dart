import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/ui/widget/back_app_bar.dart';
import 'package:menstrual_tracking_app/ui/widget/calandar_card.dart';

class CalandarPage extends StatefulWidget {
  const CalandarPage({super.key});

  @override
  State<CalandarPage> createState() => _CalandarPageState();
}

class _CalandarPageState extends State<CalandarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 40,
              children: [
                Text(
                  "Calandar",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                DefaultCalandar(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Label(text: 'Menstrual', color: Color(0xff9D1B1B)),
                    Label(text: 'Ovulation', color: Color(0xffBBDCE5)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String text;
  final Color color;
  const Label({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Text(text, style: TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
