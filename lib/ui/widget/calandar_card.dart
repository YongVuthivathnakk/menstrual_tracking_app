import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:menstrual_tracking_app/services/cycle_prediction_service.dart';
import 'package:menstrual_tracking_app/utils/svg_icons.dart';

enum CalendarType { start, end }

class DefaultCalandar extends StatefulWidget {
  const DefaultCalandar({super.key});

  @override
  State<DefaultCalandar> createState() => _DefaultCalandarState();
}

class _DefaultCalandarState extends State<DefaultCalandar> {
  final CalendarPredictionService _predictionService =
      CalendarPredictionService();

  DateTime currentMonth = DateTime.now();
  List<String> fullWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _getAveragePeriodDuration() async {
    final logs = await MenstrualLogDatabase.instance.getPeriodLogs();

    if (logs.isEmpty) return;

    int totalBleedingDays = 0;
    for (final log in logs) {
      // Adding 1 ensures that if start and end are the same day, it counts as 1 day
      totalBleedingDays += log.endDate.difference(log.startDate).inDays + 1;
    }

    setState(() {
      _isLoading = false;
    });
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final startOfCalendar = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday % 7),
    );

    return List.generate(
      42,
      (index) => startOfCalendar.add(Duration(days: index)),
    );
  }

  void onNext() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  void onPrevious() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
          Header(
            currentMonth: currentMonth,
            onNext: onNext,
            onPervious: onPrevious,
          ),
          const SizedBox(height: 12),
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

              final isPredicted = _predictionService.isDatePredicted(day);

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

class Header extends StatelessWidget {
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
          onPressed: onPervious,
        ),
        Text(
          DateFormat('MMMM yyyy').format(currentMonth),
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
          onPressed: onNext,
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
  final List<String> fullWeek = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

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

              // User selected dates
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

              // Range selection for end date
              final rangeEnd = widget.startDate?.add(const Duration(days: 6));
              final isInRange =
                  widget.startDate != null &&
                  !day.isBefore(widget.startDate!) &&
                  !day.isAfter(rangeEnd ?? widget.startDate!);

              bool isDisabled = false;
              if (widget.type == CalendarType.end) {
                isDisabled = widget.startDate == null || !isInRange;
              }

              // Decide cell color
              Color cellColor;
              if (isToday) {
                cellColor = const Color(0xff3396D3);
              } else if (isStartSelected || isEndSelected) {
                cellColor = const Color(0xffE39895);
              } else if (isInRange && widget.type == CalendarType.end) {
                cellColor = const Color.fromARGB(255, 255, 227, 226);
              } else {
                cellColor = Colors.transparent;
              }

              // Decide text color
              Color textColor;
              if (isToday || isStartSelected || isEndSelected) {
                textColor = Colors.white;
              } else if (!isCurrentMonth || isDisabled) {
                textColor = Colors.grey.shade300;
              } else {
                textColor = Colors.black;
              }

              return GestureDetector(
                onTap: isCurrentMonth && !isDisabled
                    ? () => widget.onDateSelected(day)
                    : null,
                child: Center(
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cellColor,
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
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