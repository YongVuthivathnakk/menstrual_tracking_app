import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:menstrual_tracking_app/model/period_log.dart';
import 'package:menstrual_tracking_app/services/menstrual_log_database.dart';
import 'package:menstrual_tracking_app/utils/svg_icons.dart';

enum CalendarType { start, end }

class DefaultCalandar extends StatefulWidget {
  const DefaultCalandar({super.key});

  @override
  State<DefaultCalandar> createState() => _DefaultCalandarState();
}

class _DefaultCalandarState extends State<DefaultCalandar> {
  DateTime currentMonth = DateTime.now();
  int averagePeriodLength = 0;
  List<PeriodLog> periodLogs = [];
  List<String> fullWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  List<DateTime> _daysInMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final startOfCalendar = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday % 7),
    );

    return List.generate(42, (index) {
      return startOfCalendar.add(Duration(days: index));
    });
  }

  Future<void> _getAveragePeriodDuration() async {
    final logs = await MenstrualLogDatabase.instance.getAllPeriodLogs();

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

  DateTime? getEarliestStartDate() {
    if (periodLogs.isEmpty) return null;

    // Find the log with the oldest (minimum) start date
    return periodLogs
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
    int window = averagePeriodLength > 0 ? averagePeriodLength : 5;

    return cycleDay >= 0 && cycleDay < window;
  }

  void onNext() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  void onPervious() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAveragePeriodDuration();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = _daysInMonth(currentMonth);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        color: Colors.white,
      ),
      child: Column(
        children: [
          /// HEADER
          Header(
            currentMonth: currentMonth,
            onNext: onNext,
            onPervious: onPervious,
          ),

          const SizedBox(height: 12),

          /// WEEK DAYS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: fullWeek
                .map(
                  (d) => Text(
                    d,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 12),

          /// DAYS GRID
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isToday =
                  day.day == today.day &&
                  day.month == today.month &&
                  day.year == today.year;
              final isCurrentMonth = day.month == currentMonth.month;

              final isPredicted = _isDatePredicted(day);

              return Center(
                child: Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday
                        ? const Color(0xffBBDCE5)
                        : (isPredicted
                              ? const Color(0xffE39895)
                              : Colors.transparent),
                  ),
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCurrentMonth
                          ? (isToday
                                ? Colors.white
                                : isPredicted
                                ? Colors.white
                                : null)
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Header extends StatefulWidget {
  const Header({
    super.key,
    required this.currentMonth,
    required this.onNext,
    required this.onPervious,
  });
  final VoidCallback onNext;
  final VoidCallback onPervious;

  final DateTime currentMonth;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          style: IconButton.styleFrom(
            fixedSize: const Size(32, 32),
            side: BorderSide(color: Colors.grey.shade300, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          icon: SvgPicture.asset(SvgIcons.chevronLeft, width: 18, height: 18),
          onPressed: widget.onPervious,
        ),
        Text(
          DateFormat('MMMM yyyy').format(widget.currentMonth),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          padding: const EdgeInsets.all(0),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          style: IconButton.styleFrom(
            fixedSize: const Size(32, 32),
            side: BorderSide(color: Colors.grey.shade300, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          icon: SvgPicture.asset(SvgIcons.chevronRight, height: 18, width: 18),
          onPressed: widget.onNext,
        ),
      ],
    );
  }
}

class SelectableCalendar extends StatefulWidget {
  final CalendarType type;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onDateSelected;

  const SelectableCalendar({
    super.key,
    required this.type,
    this.startDate,
    this.endDate,
    required this.onDateSelected,
  });

  @override
  State<SelectableCalendar> createState() => _SelectableCalendarState();
}

class _SelectableCalendarState extends State<SelectableCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  final List<String> fullWeek = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  List<DateTime> _daysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final start = firstDay.subtract(Duration(days: firstDay.weekday % 7));
    return List.generate(42, (i) => start.add(Duration(days: i)));
  }

  void onNext() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void onPrevious() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = _daysInMonth(_currentMonth);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Header(
            currentMonth: _currentMonth,
            onNext: onNext,
            onPervious: onPrevious,
          ),

          const SizedBox(height: 12),

          /// WEEK DAYS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: fullWeek
                .map(
                  (d) => Text(
                    d,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 12),

          /// DAYS GRID
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];

              final isToday =
                  day.year == today.year &&
                  day.month == today.month &&
                  day.day == today.day;

              final isCurrentMonth = day.month == _currentMonth.month;

              final isStartSelected =
                  widget.startDate != null &&
                  day.year == widget.startDate!.year &&
                  day.month == widget.startDate!.month &&
                  day.day == widget.startDate!.day;

              final isEndSelected =
                  widget.endDate != null &&
                  day.year == widget.endDate!.year &&
                  day.month == widget.endDate!.month &&
                  day.day == widget.endDate!.day;

              final rangeEnd = widget.startDate?.add(const Duration(days: 6));

              final isInRange =
                  widget.startDate != null &&
                  !day.isBefore(widget.startDate!) &&
                  !day.isAfter(rangeEnd!);

              bool isDisabled = false;

              if (widget.type == CalendarType.end) {
                isDisabled = widget.startDate == null || !isInRange;
              }

              return GestureDetector(
                onTap: isCurrentMonth && !isDisabled
                    ? () => widget.onDateSelected(day)
                    : null,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isToday
                          ? const Color(0xff3396D3)
                          : isStartSelected || isEndSelected
                          ? const Color(0xffE39895)
                          : isInRange && widget.type == CalendarType.end
                          ? const Color.fromARGB(255, 255, 227, 226)
                          : Colors.transparent,
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isToday
                            ? Colors.white
                            : (!isCurrentMonth || isDisabled)
                            ? Colors.grey.shade300
                            : (isStartSelected || isEndSelected)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
