import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Horario extends StatefulWidget {
  const Horario({Key? key}) : super(key: key);

  @override
  _HorarioState createState() => _HorarioState();
}

class _HorarioState extends State<Horario> {
  final List<String> _diasSemana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'];

  // Mapa para almacenar el horario
  Map<String, List<String>> _horario = {
    'Lunes': ['', '', '', '', '', '', '', '', '', '', '', ''],
    'Martes': ['', '', '', '', '', '', '', '', '', '', '', ''],
    'Miércoles': ['', '', '', '', '', '', '', '', '', '', '', ''],
    'Jueves': ['', '', '', '', '', '', '', '', '', '', '', ''],
    'Viernes': ['', '', '', '', '', '', '', '', '', '', '', ''],
  };

  // Lista de controladores de texto para los campos de horario
  List<List<TextEditingController>> _controllers =
  List.generate(5, (_) => List.generate(12, (_) => TextEditingController()));

  @override
  void initState() {
    super.initState();
    obtenerHorarioGuardado();
  }

  // Método para obtener el horario guardado en SharedPreferences
  Future<void> obtenerHorarioGuardado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String horarioGuardado = prefs.getString('horario') ?? '';

    if (horarioGuardado.isNotEmpty) {
      setState(() {
        // Si hay un horario guardado, se carga en el mapa de horario y en los controladores de texto
        _horario = Map<String, List<String>>.from(
            (jsonDecode(horarioGuardado) as Map).map((key, value) => MapEntry(key, List<String>.from(value))));
        for (var i = 0; i < 5; i++) {
          for (var j = 0; j < 12; j++) {
            _controllers[i][j].text = _horario[_diasSemana[i]]![j];
          }
        }
      });
    } else {
      obtenerHorarioActual();
    }
  }

  // Método para obtener el horario actual desde Firestore
  Future<void> obtenerHorarioActual() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference horarios = firestore.collection('horarios');
    DocumentSnapshot snapshot = await horarios.doc('horario_actual').get();
    if (snapshot.exists) {
      setState(() {
        // Si hay un horario actual en Firestore, se carga en el mapa de horario y en los controladores de texto
        _horario = Map<String, List<String>>.from(snapshot.data() as Map);
        for (var i = 0; i < 5; i++) {
          for (var j = 0; j < 12; j++) {
            _controllers[i][j].text = _horario[_diasSemana[i]]![j];
          }
        }
      });
    }
  }

  // Método para mostrar un cuadro de diálogo de confirmación antes de borrar el horario
  void borrarHorario() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro de que quieres borrar el horario actual?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                ejecutarBorradoHorario();
              },
            ),
          ],
        );
      },
    );
  }

  // Método para borrar el horario actual y limpiar los controladores de texto
  void ejecutarBorradoHorario() {
    setState(() {
      for (var i = 0; i < 5; i++) {
        for (var j = 0; j < 12; j++) {
          _controllers[i][j].text = '';
        }
      }
      _horario = {
        'Lunes': ['', '', '', '', '', '', '', '', '', '', '', ''],
        'Martes': ['', '', '', '', '', '', '', '', '', '', '', ''],
        'Miércoles': ['', '', '', '', '', '', '', '', '', '', '', ''],
        'Jueves': ['', '', '', '', '', '', '', '', '', '', '', ''],
        'Viernes': ['', '', '', '', '', '', '', '', '', '', '', ''],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Horario',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Hora',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    for (var i = 0; i < 5; i++)
                      DataColumn(
                        label: Text(
                          _diasSemana[i],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                  rows: [
                    for (var hora = 8; hora < 20; hora++)
                      DataRow(cells: [
                        DataCell(
                          Text('$hora:00'),
                        ),
                        for (var i = 0; i < 5; i++)
                          DataCell(
                            Container(
                              width: 100,
                              child: TextField(
                                controller: _controllers[i][hora - 8],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ),
                      ]),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: guardarCambios,
                child: Text('Guardar cambios'),
              ),
              ElevatedButton(
                onPressed: borrarHorario,
                child: Text('Borrar horario'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para guardar los cambios en el horario en Firestore y SharedPreferences
  Future<void> guardarCambios() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference horarios = firestore.collection('horarios');
    DocumentReference horarioActual = horarios.doc('horario_actual');

    // Datos del horario a guardar
    Map<String, List<String>> datosHorario = {
      'Lunes': [
        _controllers[0][0].text,
        _controllers[0][1].text,
        _controllers[0][2].text,
        _controllers[0][3].text,
        _controllers[0][4].text,
        _controllers[0][5].text,
        _controllers[0][6].text,
        _controllers[0][7].text,
        _controllers[0][8].text,
        _controllers[0][9].text,
        _controllers[0][10].text,
        _controllers[0][11].text
      ],
      'Martes': [
        _controllers[1][0].text,
        _controllers[1][1].text,
        _controllers[1][2].text,
        _controllers[1][3].text,
        _controllers[1][4].text,
        _controllers[1][5].text,
        _controllers[1][6].text,
        _controllers[1][7].text,
        _controllers[1][8].text,
        _controllers[1][9].text,
        _controllers[1][10].text,
        _controllers[1][11].text
      ],
      'Miércoles': [
        _controllers[2][0].text,
        _controllers[2][1].text,
        _controllers[2][2].text,
        _controllers[2][3].text,
        _controllers[2][4].text,
        _controllers[2][5].text,
        _controllers[2][6].text,
        _controllers[2][7].text,
        _controllers[2][8].text,
        _controllers[2][9].text,
        _controllers[2][10].text,
        _controllers[2][11].text
      ],
      'Jueves': [
        _controllers[3][0].text,
        _controllers[3][1].text,
        _controllers[3][2].text,
        _controllers[3][3].text,
        _controllers[3][4].text,
        _controllers[3][5].text,
        _controllers[3][6].text,
        _controllers[3][7].text,
        _controllers[3][8].text,
        _controllers[3][9].text,
        _controllers[3][10].text,
        _controllers[3][11].text
      ],
      'Viernes': [
        _controllers[4][0].text,
        _controllers[4][1].text,
        _controllers[4][2].text,
        _controllers[4][3].text,
        _controllers[4][4].text,
        _controllers[4][5].text,
        _controllers[4][6].text,
        _controllers[4][7].text,
        _controllers[4][8].text,
        _controllers[4][9].text,
        _controllers[4][10].text,
        _controllers[4][11].text
      ],
    };

    await horarioActual
        .set(datosHorario)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Horario guardado con éxito')),
      );

      guardarHorarioEnSharedPreferences(jsonEncode(datosHorario));
    })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el horario')),
      );
    });
  }

  // Método para guardar el horario en SharedPreferences
  Future<void> guardarHorarioEnSharedPreferences(String horario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('horario', horario);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horario App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Horario(),
    );
  }
}
