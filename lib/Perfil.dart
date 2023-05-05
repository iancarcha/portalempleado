import 'package:flutter/material.dart';
import 'package:portalempleado/Empleado.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Perfil extends StatefulWidget {
  final Empleado empleado;

  Perfil({required this.empleado});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  late SharedPreferences _prefs;
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidosController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _nombreController.text = widget.empleado.nombre;
    _apellidosController.text = widget.empleado.apellidos;
    _emailController.text = widget.empleado.email;
    _telefonoController.text = widget.empleado.telefono;
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _nombreController.addListener(_guardarCambios);
    _apellidosController.addListener(_guardarCambios);
    _emailController.addListener(_guardarCambios);
    _telefonoController.addListener(_guardarCambios);
  }

  void _guardarCambios() {
    widget.empleado.editarNombre(_nombreController.text);
    widget.empleado.editarApellidos(_apellidosController.text);
    widget.empleado.editarEmail(_emailController.text);
    widget.empleado.editarTelefono(_telefonoController.text);
    _guardarEmpleadoEnSharedPreferences();
  }

  Future<void> _guardarEmpleadoEnSharedPreferences() async {
    await _prefs.setString('nombre', widget.empleado.nombre);
    await _prefs.setString('apellidos', widget.empleado.apellidos);
    await _prefs.setString('email', widget.empleado.email);
    await _prefs.setString('telefono', widget.empleado.telefono);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidosController,
              decoration: InputDecoration(labelText: 'Apellidos'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: Text('Guardar cambios'),
            ),
            SizedBox(height: 16),
            Text('Nombre: ${widget.empleado.nombre}'),
            Text('Apellidos: ${widget.empleado.apellidos}'),
            Text('Email: ${widget.empleado.email}'),
            Text('Teléfono: ${widget.empleado.telefono}'),
          ],
        ),
      ),
    );
  }
}