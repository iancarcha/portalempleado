import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Proyecto {
  final String nombre;
  final String descripcion;
  final List<Tarea> tareas;

  Proyecto(this.nombre, this.descripcion, this.tareas);

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'tareas': tareas.map((tarea) => tarea.toMap()).toList(),
    };
  }

  factory Proyecto.fromJson(Map<String, dynamic> json) {
    List<Tarea> tareas = [];
    for (var tareaJson in json['tareas']) {
      tareas.add(Tarea.fromJson(tareaJson));
    }
    return Proyecto(json['nombre'], json['descripcion'], tareas);
  }

  void addTarea(String nombre, String descripcion, DateTime fechaLimite, String responsable) {
    tareas.add(Tarea(nombre, descripcion, fechaLimite, responsable));
  }
}

class Tarea {
  final String nombre;
  final String descripcion;
  final DateTime fechaLimite;
  final String responsable;

  Tarea(this.nombre, this.descripcion, this.fechaLimite, this.responsable);

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'fechaLimite': fechaLimite,
      'responsable': responsable,
    };
  }

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      json['nombre'],
      json['descripcion'],
      DateTime.parse(json['fechaLimite']),
      json['responsable'],
    );
  }
}


class ListaProyectos extends StatefulWidget {
  const ListaProyectos({Key? key}) : super(key: key);

  @override
  _ListaProyectosState createState() => _ListaProyectosState();
}
class _ListaProyectosState extends State<ListaProyectos> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  bool _agregandoProyecto = false;
  List<String> _proyectos = [];

  @override

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _agregarProyecto() {
    setState(() {
      _agregandoProyecto = true;
    });
  }

  void _cancelarAgregar() {
    setState(() {
      _agregandoProyecto = false;
      _controller.clear();
    });
  }

  void _guardarProyecto() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _proyectos.add(_controller.text);
        _agregandoProyecto = false;
        _controller.clear();
      });
    }
  }

  void _eliminarProyecto(int index) {
    setState(() {
      _proyectos.removeAt(index);
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
                key: Key(entry.value),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) =>
                    _eliminarProyecto(entry.key),
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                child: ListTile(
                  title: Text(entry.value),
                ),
              ),
            )
                .toList(),
          ),
      ],
    );
  }
}

