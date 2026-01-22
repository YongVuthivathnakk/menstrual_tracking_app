//import 'package:dotted_border/dotted_border.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:menstrual_tracking_app/model/cycle_math.dart';
import 'package:menstrual_tracking_app/model/period_log.dart';
import 'package:menstrual_tracking_app/services/menstrual_log_database.dart';
import 'package:menstrual_tracking_app/ui/pages/calandar_page.dart';
//import 'package:menstrual_tracking_app/ui/pages/history_page.dart';
import 'package:menstrual_tracking_app/ui/widget/log_button.dart';
import 'package:menstrual_tracking_app/ui/widget/menstrual_cycle_ring.dart';
import 'package:menstrual_tracking_app/utils/svg_icons.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<PeriodLog> periodLogs = [];
  int averagePeriodLength = 0;

  int calculateCurrentCycleDay(List<PeriodLog> logs) {
    if (logs.isEmpty) return 0;

    final earliestStart = logs
        .reduce((a, b) => a.startDate.isBefore(b.startDate) ? a : b)
        .startDate;

    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);

    final anchor = DateTime(
      earliestStart.year,
      earliestStart.month,
      earliestStart.day,
    );
    // Days since anchor % cycle length (28)
    // We add 1 because cycles usually start at "Day 1", not "Day 0"
    int diff = startOfToday.difference(anchor).inDays;
    return (diff % 28) + 1;
  }

  Future<void> getAveragePeriodDuration() async {
    final logs = await MenstrualLogDatabase.instance.getPeriodLogs();

    if (logs.isEmpty) return;

    int totalBleedingDays = 0;
    for (final log in logs) {
      // Adding 1 ensures that if start and end are the same day, it counts as 1 day
      totalBleedingDays += log.endDate.difference(log.startDate).inDays + 1;
    }

    setState(() {
      periodLogs = logs;
      averagePeriodLength = (totalBleedingDays / logs.length).round();
    });
  }

  @override
  void initState() {
    super.initState();
    // Defer data loading until after the first frame to avoid blocking
    // the initial UI rendering.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAveragePeriodDuration();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getAveragePeriodDuration,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              color: Colors.white,
              child: Column(
                spacing: 20,
                children: [
                  Title(),
                  CurrentDate(
                    averagePeriodLength: averagePeriodLength,
                    periodLogs: periodLogs,
                  ),
                  SizedBox(),
                  MenstrualCycleRing(
                    cycleLength: 28,
                    periodLength: averagePeriodLength,
                    currentDay: calculateCurrentCycleDay(periodLogs),
                  ),
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        PhaseLabel(
                          label: 'Menstrual Phase',
                          color: CyclePhase.menstrual.color,
                        ),
                        SizedBox(width: 9),
                        PhaseLabel(
                          label: "Follicular Phase",
                          color: CyclePhase.follicular.color,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        PhaseLabel(
                          label: 'Ovulation Phase',
                          color: CyclePhase.ovulation.color,
                        ),
                        SizedBox(width: 10),

                        PhaseLabel(
                          label: "Luteal Phase",
                          color: CyclePhase.luteal.color,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LogPeriodButton(
                          onDataChanged: () => getAveragePeriodDuration(),
                        ),
                        LogMoodAndSymptomButton(),
                      ],
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhaseLabel extends StatelessWidget {
  final String label;
  final Color color;

  const PhaseLabel({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Container(
          width: 15,
          height: 15,

          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.5),
          ),
        ),
        Text(label),
      ],
    );
  }
}

// Current Date

class CurrentDate extends StatefulWidget {
  final int averagePeriodLength;
  final List<PeriodLog> periodLogs;
  const CurrentDate({
    super.key,
    required this.averagePeriodLength,
    required this.periodLogs,
  });

  @override
  State<CurrentDate> createState() => _CurrentDateState();
}

class _CurrentDateState extends State<CurrentDate> {
  late DateTime currentWeekDate;

  DateTime? get earliestStart {
    if (widget.periodLogs.isEmpty) return null;
    return widget.periodLogs
        .reduce((a, b) => a.startDate.isBefore(b.startDate) ? a : b)
        .startDate;
  }

  DateTime? getEarliestStartDate() {
    if (widget.periodLogs.isEmpty) return null;

    // Find the log with the oldest (minimum) start date
    return widget.periodLogs
        .reduce((a, b) => a.startDate.isBefore(b.startDate) ? a : b)
        .startDate;
  }

  bool _isDatePredicted(DateTime date) {
    final earliestStart = getEarliestStartDate();
    if (earliestStart == null) return false;

    // 1. Normalize dates to ignore time (midnight)
    final anchor = DateTime(
      earliestStart.year,
      earliestStart.month,
      earliestStart.day,
    );
    final checkDate = DateTime(date.year, date.month, date.day);

    // 2. We don't predict for dates before the first log
    if (checkDate.isBefore(anchor)) return false;

    // 3. Calculate total days since the very first start date
    final totalDaysSinceStart = checkDate.difference(anchor).inDays;

    // 4. Use modulo 28 to see where this day falls in the repeating cycle
    final cycleDay = totalDaysSinceStart % 28;

    // 5. If the day is between 0 and (averageLength or 5), it's a predicted period day
    int window = widget.averagePeriodLength > 0
        ? widget.averagePeriodLength
        : 5;

    return cycleDay >= 0 && cycleDay < window;
  }

  @override
  void initState() {
    super.initState();
    currentWeekDate = DateTime.now();
  }

  static final DateFormat _dayFormat = DateFormat('d');

  List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

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

      bool isPredictedDay = _isDatePredicted(dayDate);

      // Get the current index of the day eg. "Mon", "Tue" ...
      String dayName = days[index];

      // Get the current day number eg. "1", "2" ...
      String dayNumber = _dayFormat.format(dayDate);

      bool isToday =
          dayDate.day == DateTime.now().day &&
          dayDate.month == DateTime.now().month &&
          dayDate.year == DateTime.now().year;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          Text(
            dayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
            ),
          ),
          Container(
            width: 27.5,
            height: 27.5,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              color: isToday
                  ? const Color(0xffBBDCE5)
                  : isPredictedDay
                  ? const Color(0xffE39895)
                  : null,
            ),
            child: Text(
              dayNumber,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isToday
                    ? Colors.white
                    : isPredictedDay
                    ? Colors.white
                    : null,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onFullCalandar,
                child: const Text(
                  "View Full Calandar",
                  style: TextStyle(
                    color: Color(0xff9A0002),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onPrevious,
              icon: SvgPicture.asset(
                SvgIcons.chevronLeft,
                width: 16,
                height: 16,
              ),
            ),
            ..._showCurrentDate(),
            IconButton(
              onPressed: onNext,
              icon: SvgPicture.asset(
                SvgIcons.chevronRight,
                width: 16,
                height: 16,
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
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: const Color(0xff9A0002),
            ),

            child: SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                SvgIcons.calandar,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          const Text(
            "Cycle Tracker",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 30), // empty box
        ],
      ),
    );
  }
}