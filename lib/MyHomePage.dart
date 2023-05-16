import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portalempleado/menu/CalendarPage.dart';
import 'package:portalempleado/menu/ChatScreen.dart';
import 'package:portalempleado/Comunicacion.dart';
import 'package:portalempleado/menu/Empleado.dart';
import 'package:portalempleado/menu/Horario.dart';
import 'package:portalempleado/loginYregister/LoginPage.dart';
import 'package:portalempleado/options/Opciones.dart';
import 'package:portalempleado/menu/Perfil.dart';
import 'package:portalempleado/menu/UploadFilePage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Empleado empleado;

  List<Comunicacion> comunicaciones = [    Comunicacion(      id: '1',      titulo: 'Comunicación 1',      descripcion: 'Descripción de la comunicación 1',      fecha: DateTime.now(),      autor: 'Autor de la comunicación 1',    ),    Comunicacion(      id: '2',      titulo: 'Comunicación 2',      descripcion: 'Descripción de la comunicación 2',      fecha: DateTime.now(),      autor: 'Autor de la comunicación 2',    ),  ];

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
            child: TabBarView(
              controller: _tabController,
              children: [
            ListView.builder(
            itemCount: comunicaciones.length,
              itemBuilder: (BuildContext context, int index) {
                Comunicacion comunicacion = comunicaciones[index];
                return ListTile(
                  title: Text(comunicacion.titulo),
                  subtitle: Text('${comunicacion.fecha.toString()} por ${comunicacion.autor}'),
                  onTap: () {
                    // Detalles comunicacion
                  },
                );
              },

      )
            ]),
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
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people, color: Color(0xffe06b2c)),
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
