import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portalempleado/Comunicacion.dart';
import 'package:portalempleado/menu/Calendario/CalendarPage.dart';
import 'package:portalempleado/menu/Chat/UserListTab.dart';
import 'package:portalempleado/menu/Foro.dart';
import 'package:portalempleado/menu/Empleado.dart';
import 'package:portalempleado/menu/Horario.dart';
import 'package:portalempleado/loginYregister/LoginPage.dart';
import 'package:portalempleado/options/Opciones.dart';
import 'package:portalempleado/menu/Perfil.dart';
import 'package:portalempleado/menu/UploadFilePage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portalempleado/menu/GestorDeProyectos.dart';
import 'package:portalempleado/loginYregister/UserRoleManager.dart';

class MyHomePage extends StatefulWidget {
  final User user;
  final bool isEmailVerified;

  const MyHomePage({required this.user, required this.isEmailVerified, Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Empleado empleado;
  late List<Comunicacion> comunicaciones;
  Comunicacion? selectedComunicacion;

  @override
  void initState() {
    super.initState();
    empleado = Empleado(
      nombre: '',
      apellidos: '',
      email: '',
      telefono: '',
      provincia: '',
      direccion: '',
    );
    _tabController = TabController(length: 4, vsync: this);
    comunicaciones = [
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
            child: ListView.builder(
              itemCount: comunicaciones.length,
              itemBuilder: (BuildContext context, int index) {
                Comunicacion comunicacion = comunicaciones[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedComunicacion = comunicacion;
                    });
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

                // va bien
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
                  MaterialPageRoute(builder: (context) => Perfil(user: widget.user)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Color(0xffe06b2c)),
              title: Text(
                'Chat',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserListTab()),
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
                'Gestión de Proyectos',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              /*onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GestorDeProyectos()),
                );
              },*/

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
              leading: Icon(Icons.verified_user, color: Color(0xffe06b2c)),
              title: Text(
                'Usuarios',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserRoleManagerPage()),

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
