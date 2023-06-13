import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Clase que representa un proyecto
class Proyecto {
  final String nombre;
  final String descripcion;
  final List<Tarea> tareas;

  Proyecto(this.nombre, this.descripcion, this.tareas);

  // Convierte el proyecto a un mapa para facilitar su serialización
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'tareas': tareas.map((tarea) => tarea.toMap()).toList(),
    };
  }

  // Constructor de la clase que crea un proyecto a partir de un mapa
  factory Proyecto.fromJson(Map<String, dynamic> json) {
    List<Tarea> tareas = [];
    for (var tareaJson in json['tareas']) {
      tareas.add(Tarea.fromJson(tareaJson));
    }
    return Proyecto(json['nombre'], json['descripcion'], tareas);
  }

  // Agrega una nueva tarea al proyecto
  void addTarea(String nombre, String descripcion, DateTime fechaLimite, String responsable) {
    tareas.add(Tarea(nombre, descripcion, fechaLimite, responsable));
  }
}

// Clase que representa una tarea
class Tarea {
  final String nombre;
  final String descripcion;
  final DateTime fechaLimite;
  final String responsable;

  Tarea(this.nombre, this.descripcion, this.fechaLimite, this.responsable);

  // Convierte la tarea a un mapa para facilitar su serialización
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'fechaLimite': fechaLimite,
      'responsable': responsable,
    };
  }

  // Constructor de la clase que crea una tarea a partir de un mapa
  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      json['nombre'],
      json['descripcion'],
      DateTime.parse(json['fechaLimite']),
      json['responsable'],
    );
  }
}

// Widget StatefulWidget que muestra una lista de proyectos
class ListaProyectos extends StatefulWidget {
  const ListaProyectos({Key? key}) : super(key: key);

  @override
  _ListaProyectosState createState() => _ListaProyectosState();
}

class _ListaProyectosState extends State<ListaProyectos> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  bool _agregandoProyecto = false;
  List<Proyecto> _proyectos = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _cargarProyectos();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Carga los proyectos guardados desde SharedPreferences al iniciar la aplicación
  void _cargarProyectos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String proyectosString = prefs.getString('proyectos') ?? '';
    List<dynamic> proyectosJson = jsonDecode(proyectosString);

    setState(() {
      _proyectos = proyectosJson.map((json) => Proyecto.fromJson(json)).toList();
    });
  }

  // Guarda los proyectos en SharedPreferences
  void _guardarProyectos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> proyectosJson = _proyectos.map((proyecto) => proyecto.toMap()).toList();
    String proyectosString = jsonEncode(proyectosJson);
    await prefs.setString('proyectos', proyectosString);
  }

  // Activa el modo de agregar un nuevo proyecto
  void _agregarProyecto() {
    setState(() {
      _agregandoProyecto = true;
    });
  }

  // Cancela el modo de agregar un nuevo proyecto
  void _cancelarAgregar() {
    setState(() {
      _agregandoProyecto = false;
      _controller.clear();
    });
  }

  // Guarda un nuevo proyecto en la lista
  void _guardarProyecto() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        Proyecto nuevoProyecto = Proyecto(_controller.text, '', []);
        _proyectos.add(nuevoProyecto);
        _guardarProyectos();
        _agregandoProyecto = false;
        _controller.clear();
      });
    }
  }

  // Elimina un proyecto de la lista
  void _eliminarProyecto(int index) {
    setState(() {
      _proyectos.removeAt(index);
      _guardarProyectos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Proyectos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _agregarProyecto,
              child: Text('Agregar Proyecto'),
            ),
          ],
        ),
        SizedBox(height: 16),
        if (_agregandoProyecto) ...[
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nombre del proyecto',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _guardarProyecto,
                  child: Text('Guardar'),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: _cancelarAgregar,
                  child: Text('Cancelar'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
        if (_proyectos.isEmpty)
          Text('No hay proyectos guardados.'),
        if (_proyectos.isNotEmpty)
          Column(
            children: _proyectos
                .asMap()
                .entries
                .map(
                  (entry) => Dismissible(
                key: Key(entry.key.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => _eliminarProyecto(entry.key),
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                child: ListTile(
                  title: Text(entry.value.nombre),
                  subtitle: Text(entry.value.descripcion),
                ),
              ),
            )
                .toList(),
          ),
      ],
    );
  }
}
