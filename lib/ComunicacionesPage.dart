import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portalempleado/Comunicacion.dart';
import 'package:portalempleado/menu/Empleado.dart';

class ComunicacionesPage extends StatelessWidget {
  final List<Comunicacion> comunicaciones;
  final Empleado empleado;

  const ComunicacionesPage({Key? key, required this.comunicaciones, required this.empleado}) : super(key: key);

  void agregarComunicacion(BuildContext context) {
    String titulo = '';
    String descripcion = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar comunicación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Título',
                ),
                onChanged: (value) {
                  titulo = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Descripción',
                ),
                onChanged: (value) {
                  descripcion = value;
                },
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
                Comunicacion comunicacion = Comunicacion(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  titulo: titulo,
                  descripcion: descripcion,
                  fecha: DateTime.now(),
                  autor: empleado.nombre + ' ' + empleado.apellidos,
                );
                comunicaciones.add(comunicacion);
                Navigator.pop(context);
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comunicaciones'),
      ),
      body: ListView.builder(
        itemCount: comunicaciones.length,
        itemBuilder: (BuildContext context, int index) {
          Comunicacion comunicacion = comunicaciones[index];
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Detalles de la comunicación'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          comunicacion.titulo,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          comunicacion.descripcion,
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd/MM/yyyy').format(comunicacion.fecha),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                            Text(
                              'Por ${comunicacion.autor}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comunicacion.titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    comunicacion.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(comunicacion.fecha),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        'Por ${comunicacion.autor}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          agregarComunicacion(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
