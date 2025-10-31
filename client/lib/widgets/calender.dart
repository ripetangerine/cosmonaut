import 'package:flutter/material.dart';
import 'package:flutter_calenders/flutter_calenders.dart';


class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScheduleBasedCalender(
      events: [
        Event(
          eventName: 'Sick leave',
          dates: [DateTime(2025, 8, 21), DateTime(2025, 8, 22)],
          color: Colors.green,
        ),
        Event(
          eventName: 'Paid leave',
          dates: [DateTime(2025, 8, 17), DateTime(2025, 8, 18)],
          color: Colors.orange,
        ),
      ],
      currentMonth: 8,
      currentYear: 2025,
      backgroundColor: Colors.white.withValues(alpha: .1),
      monthDateColor: Colors.white.withValues(alpha: .1),
      weekdayColor: Colors.white.withValues(alpha: .1),
      monthTextColor: Colors.white,
      weekdayTextColor: Colors.white,
      isSelectedShow: true,
      isSelectedColor: Colors.deepOrange,
      onDateTap: (date) {
        // ignore: avoid_print
        print(date);
      },
    );
  }
}