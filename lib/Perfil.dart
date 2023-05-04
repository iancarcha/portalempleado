import 'package:flutter/material.dart';

class Empleado {
  String nombre;
  String apellidos;
  String email;
  String telefono;

  Empleado({
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.telefono,
  });

  void editarNombre(String nuevoNombre) {
    this.nombre = nuevoNombre;
  }

  void editarApellidos(String nuevosApellidos) {
    this.apellidos = nuevosApellidos;
  }

  void editarEmail(String nuevoEmail) {
    this.email = nuevoEmail;
  }

  void editarTelefono(String nuevoTelefono) {
    this.telefono = nuevoTelefono;
  }
}

class Perfil extends StatefulWidget {
  final Empleado empleado;

  Perfil({required this.empleado});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidosController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.empleado.nombre;
    _apellidosController.text = widget.empleado.apellidos;
    _emailController.text = widget.empleado.email;
    _telefonoController.text = widget.empleado.telefono;
  }

  void _guardarCambios() {
    setState(() {
      widget.empleado.editarNombre(_nombreController.text);
      widget.empleado.editarApellidos(_apellidosController.text);
      widget.empleado.editarEmail(_emailController.text);
      widget.empleado.editarTelefono(_telefonoController.text);
    });
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