

//import 'package:dotted_border/dotted_border.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:menstrual_tracking_app/ui/pages/calandar_page.dart';
//import 'package:menstrual_tracking_app/ui/pages/history_page.dart';
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
  late DateTime currentWeekDate;

  @override
  void initState() {
    super.initState();
    currentWeekDate = DateTime.now();
  }

  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  DateTime get monday =>
      currentWeekDate.subtract(Duration(days: currentWeekDate.weekday - 1));
  String get formattedDate => DateFormat("MMMM yyyy").format(currentWeekDate);

  void onFullCalandar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => CalandarPage()),
    );
  }

  void onNext() {
    setState(() {
      currentWeekDate = currentWeekDate.add(const Duration(days: 7));
    });
  }

  void onPrevious() {
    setState(() {
      currentWeekDate = currentWeekDate.subtract(const Duration(days: 7));
    });
  }

  List<Widget> _showCurrentDate() {
    // This will generate 7 index of the widget
    return List.generate(7, (index) {
      // Find the day number in monday then add with index
      DateTime dayDate = monday.add(Duration(days: index));

      // Get the current index of the day eg. "Mon", "Tue" ...
      String dayName = days[index];

      // Get the current day number eg. "1", "2" ...
      String dayNumber = DateFormat('d').format(dayDate);

      bool isToday =
          dayDate.day == DateTime.now().day &&
          dayDate.month == DateTime.now().month &&
          dayDate.year == DateTime.now().year;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          Text(
            dayName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          //DottedBorder(           
            //child: 
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
            
            // Container(
            //   width: 40,
            //   height: 40,
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(500),
            //     color: isToday ? const Color(0xffE39895) : null,
            //     border: isToday
            //         ? Border.all(color: const Color(0xff9A0002), width: 2)
            //         : null,
            //   ),
            //   child: Text(
            //     dayNumber,
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //     fontSize: 18,
            //     color: isToday ? Colors.white : Colors.black,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          //),
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
              onPressed: onPrevious,
              icon: SvgPicture.asset(
                SvgIcons.chevronLeft,
                width: 30,
                height: 30,
              ),
            ),
            ..._showCurrentDate(),
            IconButton(
              onPressed: onNext,
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
      spacing: 65.5,
      crossAxisAlignment: CrossAxisAlignment.center,
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
       // empty box
      ],
    );
  }
}
