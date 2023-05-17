import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portalempleado/menu/CalendarPage.dart';
import 'package:portalempleado/menu/Foro.dart';
import 'package:portalempleado/Comunicacion.dart';
import 'package:portalempleado/menu/Empleado.dart';
import 'package:portalempleado/menu/Horario.dart';
import 'package:portalempleado/loginYregister/LoginPage.dart';
import 'package:portalempleado/options/Opciones.dart';
import 'package:portalempleado/menu/Perfil.dart';
import 'package:portalempleado/menu/UploadFilePage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Empleado empleado;

  List<Comunicacion> comunicaciones = [
    Comunicacion(
      id: '1',
      titulo: 'Comunicación 1',
      descripcion: 'Descripción de la comunicación 1',
      fecha: DateTime.now(),
      autor: 'Autor de la comunicación 1',
    ),
    Comunicacion(
      id: '2',
      titulo: 'Comunicación 2',
      descripcion: 'Descripción de la comunicación 2',
      fecha: DateTime.now(),
      autor: 'Autor de la comunicación 2',
    ),
  ];

  void agregarComunicacion() {
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
                setState(() {
                  comunicaciones.add(comunicacion);
                });
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
  void initState() {
    super.initState();
    empleado = Empleado(
      nombre: '',
      apellidos: '',
      email: '',
      telefono: '',
    );
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String dropdownValue = 'Perfil';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: Color(0xffe06b2c),
      ),
      body: Column(
          children: [
      Expanded(
      child: GestureDetector(
      onTap: () {
      // Acción al hacer clic en el cuadro de comunicaciones
      // Mostrar lista de comunicaciones y botón para añadir
    },
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: comunicaciones.length,
          itemBuilder: (BuildContext context, int index) {
            Comunicacion comunicacion = comunicaciones[index];
            return GestureDetector(
              onTap: () {
                // Detalles de la comunicación y usuario que la creó
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
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
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
      ),
    ),
    ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Obtener una referencia a la colección "comunicaciones"
                CollectionReference comunicacionesCollection = FirebaseFirestore.instance.collection('comunicaciones');

                // Crear un nuevo documento con un ID automático
                DocumentReference newComunicacionRef = comunicacionesCollection.doc();

                // Crear un mapa con los datos de la nueva comunicación
                Map<String, dynamic> nuevaComunicacion = {
                  'titulo': 'Título de la comunicación',
                  'descripcion': 'Descripción de la comunicación',
                  'fecha': DateTime.now(),
                  'autor': 'Nombre del autor',
                };

                // Guardar la nueva comunicación en Firestore
                await newComunicacionRef.set(nuevaComunicacion);

                // si todo va bien
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Comunicación creada exitosamente")),
                );
              },
              child: Text("Añadir Comunicaciones"),
            ),
          ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffe06b2c),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xffe06b2c)),
              title: Text(
                'Perfil',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Perfil(empleado: empleado)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people_sharp, color: Color(0xffe06b2c)),
              title: Text(
                'Foro',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Foro()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.paste_rounded, color: Color(0xffe06b2c)),
              title: Text(
                'Gestion de Proyectos',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                //Navigator.push(
                  //context,
                //  MaterialPageRoute(builder: (context) => GestorDeProyectos()),
                //);
              },
            ),
            ListTile(
              leading: Icon(Icons.access_time_outlined, color: Color(0xffe06b2c)),
              title: Text(
                'Horario',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Horario()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Color(0xffe06b2c)),
              title: Text(
                'Calendario',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.file_upload, color: Color(0xffe06b2c)),
              title: Text(
                'Subir Archivos',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadFilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_7, color: Color(0xffe06b2c)),
              title: Text(
                'Opciones',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Opciones()),

                );
              },
            ),
          ],
        ),
      ),

    );
  }
  }
