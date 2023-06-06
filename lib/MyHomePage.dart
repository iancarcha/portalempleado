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
      apodo: '',
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

  void mostrarDetallesComunicacion(Comunicacion comunicacion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(comunicacion.titulo),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(comunicacion.descripcion),
              SizedBox(height: 8.0),
              Text(
                'Fecha: ${DateFormat('dd/MM/yyyy').format(comunicacion.fecha)}',
              ),
              Text('Autor: ${comunicacion.autor}'),
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
  }

  void agregarComunicacion() async {
    TextEditingController descripcionController = TextEditingController();
    List<String> destinatarios = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Añadir Comunicación"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Descripción:"),
              TextField(
                controller: descripcionController,
              ),
              SizedBox(height: 8.0),
              Text("Destinatarios:"),
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Perfil', 'Opción 1', 'Opción 2', 'Opción 3']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
              onPressed: () async {
                // Obtener una referencia a la colección "comunicaciones"
                CollectionReference comunicacionesCollection =
                FirebaseFirestore.instance.collection('comunicaciones');

                // Crear un nuevo documento con un ID automático
                DocumentReference newComunicacionRef = comunicacionesCollection
                    .doc();

                // Obtener los destinatarios seleccionados
                if (dropdownValue == 'Perfil') {
                  // Si se selecciona "Perfil", se enviará la comunicación a todos los usuarios registrados
                  QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
                      .collection('users').get();
                  destinatarios =
                      usersSnapshot.docs.map((doc) => doc.id).toList();
                } else {
                  // De lo contrario, se enviará la comunicación a los usuarios seleccionados
                  destinatarios = [dropdownValue];
                }

                // Crear un mapa con los datos de la nueva comunicación
                Map<String, dynamic> nuevaComunicacion = {
                  'titulo': 'Título de la comunicación',
                  'descripcion': descripcionController.text,
                  'fecha': DateTime.now(),
                  'autor': widget.user.email,
                  'destinatarios': destinatarios,
                };

                // Guardar la nueva comunicación en Firestore
                await newComunicacionRef.set(nuevaComunicacion);

                // Cerrar el cuadro de diálogo
                Navigator.pop(context);

                // Mostrar un mensaje de éxito
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Comunicación creada exitosamente")),
                );
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
        title: Text(
          "Home",
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
                    mostrarDetallesComunicacion(comunicacion);
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
                              DateFormat('dd/MM/yyyy').format(
                                  comunicacion.fecha),
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
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: agregarComunicacion,
            child: Text("Añadir Comunicación"),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),

                ],
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
                  MaterialPageRoute(
                      builder: (context) => Perfil(user: widget.user)),
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
              leading: Icon(
                  Icons.access_time_outlined, color: Color(0xffe06b2c)),
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
              leading: Icon(
                  Icons.calendar_today_rounded, color: Color(0xffe06b2c)),
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
              leading: Icon(Icons.upload_file, color: Color(0xffe06b2c)),
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
              leading: Icon(Icons.settings, color: Color(0xffe06b2c)),
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
