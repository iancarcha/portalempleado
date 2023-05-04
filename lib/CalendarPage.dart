import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:portalempleado/InfoCalendario.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, String> _holidays;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _holidays = InfoCalendario.getDias();
    initializeDateFormatting();
  }

  Future<void> initializeDateFormatting() async {
    await Future.wait([
      initializeLocale('es', 'ES'),
    ]);
    Intl.defaultLocale = 'es_ES';
  }
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'es_ES',
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blueGrey[100],
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle(
          color: Colors.red,
        ),
        holidayTextStyle: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.blueGrey[700],
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.blueGrey[700],
        ),
      ),
      calendarFormat: _calendarFormat,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      holidayPredicate: (day) => _holidays.containsKey(day),
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2023, 12, 31),
      // Configure custom day styles here
      weekendDays: [6, 7], // Saturday, Sunday
    );
  }
}
