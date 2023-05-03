import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:portalempleado/InfoCalendario.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<String>> _events;
  late Map<DateTime, String> _holidays;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _events = {};
    _holidays = InfoCalendario.getDias();
  }

  void _onDaySelected(DateTime day, List<dynamic> events) {
    setState(() {
      _selectedDay = day;
    });

    // Mark/unmark vacation days
    if (_events[day] == null) {
      _events[day] = ['Vacaciones'];
    } else {
      _events[day]!.remove('Vacaciones');
      if (_events[day]!.isEmpty) {
        _events.remove(day);
      }
    }

    // Update bottom message
    if (_holidays.containsKey(day)) {
      setState(() {
        _selectedDay = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hoy es festivo en España: ${_holidays[day]}'),
          ),
        );
      });
    } else if (_events.containsKey(day)) {
      setState(() {
        _selectedDay = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tienes un día de vacaciones marcado'),
          ),
        );
      });
    } else {
      setState(() {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      });
    }
  }

  Widget _buildCalendar() {
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
      //onDaySelected: _onDaySelected,
     // eventLoader: (day) => _events[day],
      holidayPredicate: (day) => _holidays.containsKey(day),
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2023, 12, 31),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}