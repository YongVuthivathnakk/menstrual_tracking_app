import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:menstrual_tracking_app/ui/pages/calandar_page.dart';
import 'package:menstrual_tracking_app/ui/widget/log_button.dart';
import 'package:menstrual_tracking_app/utils/svg_icons.dart';

class CycleTrackerCard extends StatelessWidget {
  const CycleTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            spacing: 20,
            children: [Title(), CurrentDate(), PeriodChart(), LogButtons()],
          ),
        ),
      ),
    );
  }
}

class LogButtons extends StatelessWidget {
  const LogButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [LogPeriodButton(), LogMoodAndSymptomButton()],
    );
  }
}

class PeriodChart extends StatelessWidget {
  const PeriodChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// Current Date

class CurrentDate extends StatefulWidget {
  const CurrentDate({super.key});

  @override
  State<CurrentDate> createState() => _CurrentDateState();
}

class _CurrentDateState extends State<CurrentDate> {
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  DateTime now = DateTime.now();
  String get formattedDate => DateFormat("MMMM yyyy").format(now);

  void onFullCalandar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => CalandarPage()),
    );
  }

  List<Widget> _showCurrentDate() {
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));

    // This will generate 7 index of the widget
    return List.generate(7, (index) {
      // Find the day number in monday then add with index
      DateTime dayDate = monday.add(Duration(days: index));

      // Get the current index of the day eg. "Mon", "Tue" ...
      String dayName = days[index];

      // Get the current day number eg. "1", "2" ...
      String dayNumber = DateFormat('d').format(dayDate);

      bool isToday =
          dayDate.day == now.day &&
          dayDate.month == now.month &&
          dayDate.year == now.year;

      return Column(
        children: [
          Text(
            dayName,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: isToday ? const Color(0xffE39895) : null,
              border: isToday
                  ? Border.all(color: const Color(0xff9A0002), width: 2)
                  : null,
            ),
            child: Text(
              dayNumber,
              style: TextStyle(
                fontSize: 14,
                color: isToday ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formattedDate,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: onFullCalandar,
              child: Text(
                "View Full Calandar",
                style: TextStyle(
                  color: const Color(0xff9A0002),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                SvgIcons.chevronLeft,
                width: 30,
                height: 30,
              ),
            ),
            ..._showCurrentDate(),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                SvgIcons.chevronRight,
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Title

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xff9A0002),
          ),

          child: SizedBox(
            width: 25,
            height: 25,
            child: SvgPicture.asset(
              SvgIcons.calandar,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
        const Text(
          "Cycle Tracker",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(), // empty box
      ],
    );
  }
}
