import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portalempleado/LoginPage.dart';

class Opciones extends StatefulWidget {
  @override
  _OpcionesState createState() => _OpcionesState();
}

class _OpcionesState extends State<Opciones> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Opciones',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Aromes Citrics Valencians (Arocival)',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.orange),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Cambiar contraseña',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                _mostrarCuadroDialogo(context);
              },
            ),

          ],
        ),
      ),
    );
  }

  void _mostrarCuadroDialogo(BuildContext context) {
    String nuevaContrasena = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nueva contraseña'),
          content: TextFormField(
            autofocus: true,
            decoration: InputDecoration(
                hintText: 'Ingresa la nueva contraseña'),
            onChanged: (value) {
              nuevaContrasena = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                _cambiarContrasena(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Función para cambiar la contraseña del usuario
  void _cambiarContrasena(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cambiar Contraseña'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(hintText: 'Nueva Contraseña'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingrese una contraseña';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  User user = FirebaseAuth.instance.currentUser!;
                  String newPassword = _passwordController.text.trim();
                  try {
                    await user.updatePassword(newPassword);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Contraseña actualizada"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error al actualizar la contraseña"),
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
