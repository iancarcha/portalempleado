import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portalempleado/Comunicacion.dart';
import 'package:portalempleado/menu/Empleado.dart';

class ComunicacionesPage extends StatelessWidget {
  final List<Comunicacion> comunicaciones; // Lista de comunicaciones
  final Empleado empleado; // Instancia de la clase Empleado

  const ComunicacionesPage({Key? key, required this.comunicaciones, required this.empleado}) : super(key: key);

  // Función para agregar una comunicación
  void agregarComunicacion(BuildContext context) {
    String titulo = ''; // Variable para almacenar el título ingresado
    String descripcion = ''; // Variable para almacenar la descripción ingresada

    // Mostrar un cuadro de diálogo para ingresar los detalles de la comunicación
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
                  titulo = value; // Almacenar el valor del título ingresado
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Descripción',
                ),
                onChanged: (value) {
                  descripcion = value; // Almacenar el valor de la descripción ingresada
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el cuadro de diálogo sin agregar la comunicación
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Crear una nueva instancia de Comunicacion con los valores ingresados
                Comunicacion comunicacion = Comunicacion(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  titulo: titulo,
                  descripcion: descripcion,
                  fecha: DateTime.now(),
                  autor: empleado.nombre + ' ' + empleado.apellidos,
                );
                comunicaciones.add(comunicacion); // Agregar la comunicación a la lista
                Navigator.pop(context); // Cerrar el cuadro de diálogo
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
          Comunicacion comunicacion = comunicaciones[index]; // Obtener la comunicación en el índice actual
          return GestureDetector(
            onTap: () {
              // Mostrar un cuadro de diálogo con los detalles de la comunicación al hacer clic en ella
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
                          Navigator.pop(context); // Cerrar el cuadro de diálogo
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
          agregarComunicacion(context); // Invocar la función para agregar una comunicación
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
