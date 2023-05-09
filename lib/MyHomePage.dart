import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portalempleado/CalendarPage.dart';
import 'package:portalempleado/ChatScreen.dart';
import 'package:portalempleado/Empleado.dart';
import 'package:portalempleado/LoginPage.dart';
import 'package:portalempleado/Opciones.dart';
import 'package:portalempleado/Perfil.dart';
import 'package:portalempleado/UploadFilePage.dart';
import 'package:portalempleado/GestorDeProyectos.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Empleado empleado;



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
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: Text('Perfil'),
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
