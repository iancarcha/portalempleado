import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portalempleado/CalendarPage.dart';
import 'package:portalempleado/ChatScreen.dart';
import 'package:portalempleado/Empleado.dart';
import 'package:portalempleado/LoginPage.dart';
import 'package:portalempleado/Perfil.dart';
import 'package:portalempleado/UploadFilePage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Empleado empleado;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    empleado = Empleado(
      nombre: '',
      apellidos: '',
      email: '',
      telefono: '',
    );
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
          Center(
            child: InkWell(
              child: Text(
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
          ),
          Center(
            child: InkWell(
              child: Text(
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
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text(
                    'Cargar archivo',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadFilePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffe06b2c),
                  ),
                ),
              ],
            ),
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
          ],
        ),
      ),
      bottomNavigationBar: Material(
          color: Color(0xFFfabb18),
        child: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Perfil',
              icon: Icon(Icons.person),
            ),
            Tab(
              text: 'Chat',
              icon: Icon(Icons.chat),
            ),
            Tab(
              text: 'Calendario',
              icon: Icon(Icons.calendar_today),
            ),
          ],
        ),
      ),
    );
  }
  }
