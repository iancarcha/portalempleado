import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Horario extends StatefulWidget {
  const Horario({Key? key}) : super(key: key);

  @override
  _HorarioState createState() => _HorarioState();
}

class _HorarioState extends State<Horario> {
  final List<String> _diasSemana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'];

  Map<String, List<String>> _horario = {
    'Lunes': ['', '', '', '', '', '', '', '', '', '', '', ''],
    'Martes': ['', '', '', '', '', '', '', '', '', '', '', ''],
    'Miércoles': ['', '', '', '', '', '', '', '', '', '', '', ''],
    'Jueves': ['', '', '', '', '', '', '', '', '', '', '', ''],
    'Viernes': ['', '', '', '', '', '', '', '', '', '', '', ''],
  };

  List<List<TextEditingController>> _controllers = [
    [for (var i = 0; i < 12; i++) TextEditingController()],
    [for (var i = 0; i < 12; i++) TextEditingController()],
    [for (var i = 0; i < 12; i++) TextEditingController()],
    [for (var i = 0; i < 12; i++) TextEditingController()],
    [for (var i = 0; i < 12; i++) TextEditingController()],
  ];

  @override
  void initState() {
    super.initState();
    obtenerHorarioActual();
  }

  Future<void> obtenerHorarioActual() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference horarios = firestore.collection('horarios');
    DocumentSnapshot snapshot = await horarios.doc('horario_actual').get();
    if (snapshot.exists) {
      setState(() {
        _horario = Map<String, List<String>>.from(snapshot.data() as Map);
        for (var i = 0; i < 5; i++) {
          for (var j = 0; j < 12; j++) {
            _controllers[i][j].text = _horario[_diasSemana[i]]![j];
          }
        }
      });
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
              for (var hora = 8; hora < 20; hora++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$hora:00',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 16,
                      children: [
                        for (var i = 0; i < 5; i++)
                          Container(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _diasSemana[i],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                TextField(
                                  controller: _controllers[i][hora - 8],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ElevatedButton(
                onPressed: guardarCambios,
                child: Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> guardarCambios() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference horarios = firestore.collection('horarios');
    DocumentReference horarioActual = horarios.doc('horario_actual');

    Map<String, List<String>> datosHorario = {
      'Lunes': [_controllers[0][0].text, _controllers[0][1].text, _controllers[0][2].text, _controllers[0][3].text, _controllers[0][4].text, _controllers[0][5].text, _controllers[0][6].text, _controllers[0][7].text, _controllers[0][8].text, _controllers[0][9].text, _controllers[0][10].text, _controllers[0][11].text],
      'Martes': [_controllers[1][0].text, _controllers[1][1].text, _controllers[1][2].text, _controllers[1][3].text, _controllers[1][4].text, _controllers[1][5].text, _controllers[1][6].text, _controllers[1][7].text, _controllers[1][8].text, _controllers[1][9].text, _controllers[1][10].text, _controllers[1][11].text],
      'Miércoles': [_controllers[2][0].text, _controllers[2][1].text, _controllers[2][2].text, _controllers[2][3].text, _controllers[2][4].text, _controllers[2][5].text, _controllers[2][6].text, _controllers[2][7].text, _controllers[2][8].text, _controllers[2][9].text, _controllers[2][10].text, _controllers[2][11].text],
      'Jueves': [_controllers[3][0].text, _controllers[3][1].text, _controllers[3][2].text, _controllers[3][3].text, _controllers[3][4].text, _controllers[3][5].text, _controllers[3][6].text, _controllers[3][7].text, _controllers[3][8].text, _controllers[3][9].text, _controllers[3][10].text, _controllers[3][11].text],
      'Viernes': [_controllers[4][0].text, _controllers[4][1].text, _controllers[4][2].text, _controllers[4][3].text, _controllers[4][4].text, _controllers[4][5].text, _controllers[4][6].text, _controllers[4][7].text, _controllers[4][8].text, _controllers[4][9].text, _controllers[4][10].text, _controllers[4][11].text],
    };

    await horarioActual.set(datosHorario).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Horario guardado con éxito')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el horario')),
      );
    });
  }
}
