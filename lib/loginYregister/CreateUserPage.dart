import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUserPage extends StatefulWidget{


  @override
  State createState(){
    return _CreateUserState();
  }
}

class _CreateUserState extends State<CreateUserPage> {

  late String email, password, userEmail;
  final _formsKey = GlobalKey<FormState>();
  String error = '';

  @override
  void initState() {
    super.initState();
  }
//contruye la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arocival - Portal del Empleado"),backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.0),
            Text(
              "Registrarse",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Offstage(
              offstage: error == '',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            formulario(),
            SizedBox(height: 32.0),
            botonCrearUsuario(),
          ],
        ),
      ),
    );
  }
//contiene campos de estrada de correo y contraseña
  Widget formulario() {
    return Form(
      key: _formsKey,
      child: Column(
        children: [
          buildEmail(),
          SizedBox(height: 16.0),
          buildPassword(),
        ],
      ),
    );
  }

//construye los campos de entrada de correo electrónico
  Widget buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Correo electrónico",
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8),
          borderSide: new BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String? value) {
        email = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }
//construye los campos de entrada de la contraseña
  Widget buildPassword() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Contraseña",
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8),
          borderSide: new BorderSide(color: Colors.black),
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
        password = value!;
      },
    );
  }
//construye el botón de "Crear cuenta" que llama al método crearUsuario() cuando se presiona.
  Widget botonCrearUsuario() {
    return ElevatedButton(
      onPressed: () async {
        if (_formsKey.currentState!.validate()) {
          _formsKey.currentState!.save();
          UserCredential? credenciales = await crearUsuario(email, password);
          if (credenciales != null) {
            if (credenciales.user != null) {
              String userName = email.split('@')[0]; // Obtener la parte izquierda del '@' como nombre de usuario
              await credenciales.user!.updateDisplayName(userName); // Establecer el nombre de usuario en Firebase Auth
              await credenciales.user!.sendEmailVerification();

              if (email == "iancarretero@gmail.com") {
                await FirebaseFirestore.instance
                    .collection('roles')
                    .doc(credenciales.user!.uid)
                    .set({
                  'rol': 'admin',
                  'correo': userEmail,
                });
              } else {
                await FirebaseFirestore.instance
                    .collection('roles')
                    .doc(credenciales.user!.uid)
                    .set({
                  'rol': 'cliente',
                  'correo': userEmail,
                });
              }

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Registro completado"),
                    content: Text(
                        "Se ha enviado un email de verificación a la dirección proporcionada."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text("Aceptar"),
                      ),
                    ],
                  );
                },
              );
            }
          }
        }
      },
      child: Text(
        "Crear cuenta",
        style: TextStyle(fontSize: 18.0),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

//utiliza la clase FirebaseAuth para crear un nuevo usuario utilizando el correo electrónico y la contraseña proporcionados.
// Maneja posibles excepciones y muestra mensajes de error correspondientes.
  Future<UserCredential?> crearUsuario(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          error =
          'La contraseña es demasiado débil. Por favor, elija una contraseña más segura.';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          error =
          'Este email ya está en uso. Por favor, utilice una dirección de correo electrónico diferente.';
        });
      }
    }
  }
}