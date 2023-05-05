import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:portalempleado/InfoCalendario.dart';
import 'package:table_calendar/table_calendar.dart';

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
    initializeDateFormatting('es_ES', null);
  }

  Future<void> initializeDateSymbol(String locale, String? path) async {
    await initializeDateFormatting(locale, path);
    Intl.defaultLocale = 'es_ES';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Calendario - Arocival"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TableCalendar(
            locale: 'es_ES',
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange[100],
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(
                color: Colors.red,
              ),
              holidayTextStyle: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              // Customize the selected day's marker
              markerDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2),
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
                color: Colors.orange[700],
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.orange[700],
              ),
            ),
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            // Lunes como primer día de la semana
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            holidayPredicate: (day) => _holidays.containsKey(day),
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2099, 12, 31),
            weekendDays: [6, 7], // Sabado y domingo
          ),
        ),
      ),
    );
  }
}
