import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:portalempleado/menu/Calendario/InfoCalendario.dart'; // Importar clase InfoCalendario
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, String> _holidays; // Mapa de fechas festivas
  CalendarFormat _calendarFormat = CalendarFormat.month; // Formato del calendario
  DateTime _focusedDay = DateTime.now(); // Día en foco
  DateTime? _selectedDay; // Día seleccionado
  Map<DateTime, String> _selectedDates = {}; // Mapa de fechas seleccionadas
  Set<DateTime> _selectedDatesToDelete = {}; // Conjunto de fechas seleccionadas para eliminar

  final TextEditingController _labelController = TextEditingController(); // Controlador de texto para la etiqueta

  @override
  void initState() {
    super.initState();
    _holidays = InfoCalendario.getDiasFestivos(); // Obtener las fechas festivas del año del objeto InfoCalendario
    initializeDateFormatting('es_ES', null); // Inicializar la configuración regional para el formato de fechas en español
    loadSelectedDates(); // Cargar las fechas seleccionadas guardadas
  }

  Future<void> saveSelectedDates() async {
    try {
      final List<Map<String, dynamic>> savedDates = _selectedDates.entries
          .map((entry) => {
        'date': entry.key.toIso8601String(),
        'label': entry.value,
      })
          .toList();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedDates', savedDates.toString());

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Éxito'),
          content: Text('Las fechas seleccionadas se han guardado correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Hubo un error al guardar las fechas seleccionadas.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> loadSelectedDates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedDatesString = prefs.getString('selectedDates');

      if (savedDatesString != null && savedDatesString.isNotEmpty) {
        final savedDates = savedDatesString
            .split(',')
            .map((entry) => entry.replaceAll(RegExp(r'[\{\}\[\]]'), ''))
            .map((entry) => entry.split(':'))
            .where((entry) => entry.length == 2)
            .map((entry) => {
          'date': entry[0].trim(),
          'label': entry[1].trim(),
        })
            .toList();

        setState(() {
          _selectedDates = savedDates.fold<Map<DateTime, String>>(
            {},
                (map, entry) {
              final DateTime date = DateTime.parse(entry['date']!);
              final String? label = entry['label'];
              map[date] = label!;
              return map;
            },
          );
        });
      }
    } catch (e) {
      print('Error al cargar las fechas: $e');
    }
  }

  void _showLabelDialog(DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Etiqueta para ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _labelController,
              decoration: InputDecoration(
                labelText: 'Etiqueta',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final String label = _labelController.text;
              if (label.isNotEmpty && !_selectedDates.containsKey(selectedDate)) {
                setState(() {
                  _selectedDates[selectedDate] = label;
                });
              }
              Navigator.pop(context);
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _deleteSelectedDates() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar fechas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _selectedDates.entries
              .map(
                (entry) => CheckboxListTile(
              title: Text(DateFormat('dd/MM/yyyy').format(entry.key)),
              value: _selectedDatesToDelete.contains(entry.key),
              onChanged: (value) {
                setState(() {
                  if (value != null && value) {
                    _selectedDatesToDelete.add(entry.key);
                  } else {
                    _selectedDatesToDelete.remove(entry.key);
                  }
                });
              },
            ),
          )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedDatesToDelete.forEach((date) {
                  _selectedDates.remove(date);
                });
                _selectedDatesToDelete.clear();
              });
              Navigator.pop(context);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
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
        title: Text("Calendario"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  holidayPredicate: (day) => _holidays.containsKey(day),
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2099, 12, 31),
                  weekendDays: [6, 7],
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _showLabelDialog(selectedDay);
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      final labels = _selectedDates[date];
                      final markers = <Widget>[];

                      if (labels != null && labels.isNotEmpty) {
                        markers.add(
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              color: Colors.orange,
                              child: Text(
                                labels,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }

                      return markers.isNotEmpty ? Column(children: markers) : null;
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Fechas guardadas:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _selectedDates.length,
            itemBuilder: (context, index) {
              final date = _selectedDates.keys.toList()[index];
              final label = _selectedDates[date];
              return ListTile(
                title: Text(DateFormat('dd/MM/yyyy').format(date)),
                subtitle: Text(label!),
              );
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: saveSelectedDates,
            child: Text('Guardar fechas'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _deleteSelectedDates,
            child: Text('Eliminar fechas'),
          ),
        ],
      ),
    );
  }
}
