import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Horario extends StatefulWidget {
  const Horario({Key? key}) : super(key: key);

  @override
  _HorarioState createState() => _HorarioState();
}

class _HorarioState extends State<Horario> {
  // Días de la semana
  final List<String> _diasSemana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'];

  // Horario actual
  Map<String, List<String>> _horario = {
    'Lunes': ['', '', '', '', '', ''],
    'Martes': ['', '', '', '', '', ''],
    'Miércoles': ['', '', '', '', '', ''],
    'Jueves': ['', '', '', '', '', ''],
    'Viernes': ['', '', '', '', '', ''],
  };

  // Controladores de texto para las celdas de la tabla
  List<List<TextEditingController>> _controllers = [
    [for (var i = 0; i < 6; i++) TextEditingController()],
    [for (var i = 0; i < 6; i++) TextEditingController()],
    [for (var i = 0; i < 6; i++) TextEditingController()],
    [for (var i = 0; i < 6; i++) TextEditingController()],
    [for (var i = 0; i < 6; i++) TextEditingController()],
  ];

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores de texto con los valores del horario actual
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 6; j++) {
        _controllers[i][j].text = _horario[_diasSemana[i]]![j];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horario'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FixedColumnWidth(60),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(),
                4: FlexColumnWidth(),
                5: FlexColumnWidth(),
              },
              children: [
                // Encabezado de la tabla
                TableRow(
                  children: [
                    SizedBox(),
                    for (var dia in _diasSemana) TableCell(
                      child: Center(child: Text(dia)),
                    ),
                  ],
                ),
                // Filas de la tabla con el horario actual
                for (var hora = 8; hora < 14; hora++) TableRow(
                  children: [
                    TableCell(
                      child: Center(child: Text('$hora:00')),
                    ),
                    for (var i = 0; i < 5; i++) TableCell(
                      child: TextField(
                        controller: _controllers[i][hora - 8],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );

  }
  void _guardarCambios() {
    // Obtener una instancia de la clase FirebaseFirestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Obtener una referencia a la colección "horarios"
    CollectionReference horarios = firestore.collection('horarios');

    // Crear un nuevo documento en la colección "horarios"
    DocumentReference nuevoHorario = horarios.doc();

    // Crear un mapa con los datos del horario
    Map<String, List<String>> datosHorario = {
      'Lunes': [_controllers[0][0].text, _controllers[0][1].text, _controllers[0][2].text, _controllers[0][3].text, _controllers[0][4].text, _controllers[0][5].text],
      'Martes': [_controllers[1][0].text, _controllers[1][1].text, _controllers[1][2].text, _controllers[1][3].text, _controllers[1][4].text, _controllers[1][5].text],
      'Miércoles': [_controllers[2][0].text, _controllers[2][1].text, _controllers[2][2].text, _controllers[2][3].text, _controllers[2][4].text, _controllers[2][5].text],
      'Jueves': [_controllers[3][0].text, _controllers[3][1].text, _controllers[3][2].text, _controllers[3][3].text, _controllers[3][4].text, _controllers[3][5].text],
      'Viernes': [_controllers[4][0].text, _controllers[4][1].text, _controllers[4][2].text, _controllers[4][3].text, _controllers[4][4].text, _controllers[4][5].text],
    };
// Asignar el mapa como los datos del documento creado
    nuevoHorario.set(datosHorario).then((value) {
// Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Horario guardado con éxito')),
      );
    }).catchError((error) {
// Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el horario')),
      );
    });
  }
  }