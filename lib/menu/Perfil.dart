import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portalempleado/menu/Empleado.dart';

class Perfil extends StatefulWidget {
  final User user;

  Perfil({required this.user});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidosController;
  late TextEditingController _telefonoController;
  late TextEditingController _provinciaController;
  late TextEditingController _direccionController;
  late TextEditingController _apodoController;

  late Empleado _empleado;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.user.displayName);
    _apellidosController = TextEditingController();
    _telefonoController = TextEditingController();
    _provinciaController = TextEditingController();
    _direccionController = TextEditingController();
    _apodoController = TextEditingController();

    _empleado = Empleado(
      nombre: widget.user.displayName ?? '',
      apellidos: '',
      email: widget.user.email ?? '',
      telefono: '',
      provincia: '',
      direccion: '',
      apodo: '',
    );

    _obtenerDatosUsuario();
  }

  Future<void> _obtenerDatosUsuario() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
    await firestore.collection('empleados').doc(widget.user.uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      setState(() {
        _empleado.editarApellidos(data['apellidos']);
        _empleado.editarTelefono(data['telefono']);
        _empleado.editarProvincia(data['provincia']);
        _empleado.editarDireccion(data['direccion']);
        _empleado.editarApodo(data['apodo']);

      });
    }
  }

  Future<void> _guardarCambios() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference empleadoRef = firestore.collection('empleados').doc(widget.user.uid);

    _empleado.editarApellidos(_apellidosController.text);
    _empleado.editarTelefono(_telefonoController.text);
    _empleado.editarProvincia(_provinciaController.text);
    _empleado.editarDireccion(_direccionController.text);
    _empleado.editarApodo(_apodoController.text);

    // Actualizar los controladores de texto con los nuevos valores
    _apellidosController.text = _empleado.apellidos;
    _telefonoController.text = _empleado.telefono;
    _provinciaController.text = _empleado.provincia;
    _direccionController.text = _empleado.direccion;
    _apodoController.text = _empleado.apodo;

    await empleadoRef.update({
      'apellidos': _empleado.apellidos,
      'telefono': _empleado.telefono,
      'provincia': _empleado.provincia,
      'direccion': _empleado.direccion,
      'apodo': _empleado.apodo,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cambios guardados correctamente')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
    child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 60,
                child: Image.asset(
                  'assets/logo.png',
                  height: 60,
                ),
            ),
            SizedBox(height: 16),
            Text(
              'Usuario: ${widget.user.displayName}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${widget.user.email}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nombreController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidosController,
              decoration: InputDecoration(labelText: 'Apellidos'),
            ),
            TextField(
              controller: _apodoController,
              decoration: InputDecoration(labelText: 'Apodo'),
            ),
            TextField(
              controller: _telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: _provinciaController,
              decoration: InputDecoration(labelText: 'Provincia'),
            ),
            TextField(
              controller: _direccionController,
              decoration: InputDecoration(labelText: 'Direccion'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: Text('Guardar cambios'),
            ),
          ],
        ),
      )
      ),
    );
  }
}
