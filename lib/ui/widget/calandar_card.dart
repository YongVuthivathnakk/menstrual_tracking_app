import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:menstrual_tracking_app/utils/svg_icons.dart';

class DefaultCalandar extends StatefulWidget {
  const DefaultCalandar({super.key});

  @override
  State<DefaultCalandar> createState() => _DefaultCalandarState();
}

class _DefaultCalandarState extends State<DefaultCalandar> {
  DateTime currentMonth = DateTime.now();

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
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = _daysInMonth(currentMonth);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      padding: const EdgeInsets.all(16),
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
                    style: TextStyle(
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

              return Center(
                child: Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday ? Color(0xff9D1B1B) : Colors.transparent,
                  ),
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCurrentMonth
                          ? (isToday ? Colors.white : Colors.black)
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
          style: IconButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          icon: SvgPicture.asset(SvgIcons.chevronLeft),
          onPressed: widget.onPervious,
        ),
        Text(
          DateFormat('MMMM yyyy').format(widget.currentMonth),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: SvgPicture.asset(SvgIcons.chevronRight),
          style: IconButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          onPressed: widget.onNext,
        ),
      ],
    );
  }
}

class SelectableCalendar extends StatefulWidget {
  const SelectableCalendar({super.key});

  @override
  State<SelectableCalendar> createState() => _SelectableCalendarState();
}

class _SelectableCalendarState extends State<SelectableCalendar> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = DateTime.now(); // optional: auto-select today
  }

  List<String> fullWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

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
      margin: const EdgeInsets.symmetric(horizontal: 50),
      padding: const EdgeInsets.all(16),
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

              final isSelected =
                  _selectedDate != null &&
                  day.year == _selectedDate!.year &&
                  day.month == _selectedDate!.month &&
                  day.day == _selectedDate!.day;

              return GestureDetector(
                onTap: !isCurrentMonth
                    ? null
                    : () {
                        setState(() {
                          _selectedDate = day;
                        });
                      },
                child: Center(
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? const Color(0xff9D1B1B)
                          : isToday
                          ? const Color(0xffE39895)
                          : Colors.transparent,
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: !isCurrentMonth
                            ? Colors.grey.shade300
                            : isSelected
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
