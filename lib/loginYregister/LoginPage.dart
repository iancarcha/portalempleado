import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portalempleado/loginYregister/CreateUserPage.dart';
import 'package:portalempleado/MyHomePage.dart';

class LoginPage extends StatefulWidget {
  final User? user;

  LoginPage({this.user});

  @override
  State createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  late String email, password;
  final _formsKey = GlobalKey<FormState>();
  String error = '';
  bool isEmailVerified = false;


  @override
  void initState() {
    super.initState();
  }
//Este método construye la interfaz de usuario de la página utilizando widgets de Flutter.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              "Bienvenido a Arocival",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              child: Image.asset(
                'assets/logo.png',
                height: 80,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Offstage(
                offstage: error.isEmpty,
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: formulario(),
            ),
            SizedBox(height: 24),
            botonLogin(),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: nuevousuario(),
            ),
          ],
        ),
      ),
    );
  }
// construye un botón "¿No tienes cuenta? Regístrate" que redirige al usuario a la página de creación de usuarios cuando se presiona.
  Widget nuevousuario() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateUserPage()),
        );
      },
      child: Text(
        "¿No tienes cuenta? Regístrate",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
// retorna un widget Form que contiene los campos de entrada de correo electrónico y contraseña.
  Widget formulario() {
    return Form(
      key: _formsKey,
      child: Column(
        children: [
          buildEmail(),
          SizedBox(height: 24),
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
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
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
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
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

  // construye el botón "Ingresar" que llama al método login() cuando se presiona.
  // También muestra mensajes de error correspondientes en caso de que ocurra un error durante el inicio de sesión.
  Widget botonLogin() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: ElevatedButton(
        onPressed: () async {
          if (_formsKey.currentState!.validate()) {
            _formsKey.currentState!.save();
            UserCredential? credenciales = await login(email, password);
            if (credenciales != null) {
              if (credenciales.user != null) {
                isEmailVerified = credenciales.user!.emailVerified;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(
                      user: credenciales.user!,
                      isEmailVerified: isEmailVerified,
                    ),
                  ),
                      (Route<dynamic> route) => false,
                );
              } else {
                setState(() {
                  error = "Error al iniciar sesión. Inténtelo de nuevo.";
                });
              }
            }
          }
        },
        child: Text(
          "Ingresar",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF82B540),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }


// Este método utiliza la clase FirebaseAuth para autenticar al usuario utilizando el correo electrónico y la contraseña proporcionados.
// Maneja posibles excepciones y muestra mensajes de error correspondientes.
  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        isEmailVerified = userCredential.user!.emailVerified;
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          error = "El usuario no fue encontrado. Por favor, verifique sus credenciales.";
        });
      }
      if (e.code == 'wrong-password') {
        setState(() {
          error = "La contraseña es incorrecta. Por favor, verifique sus credenciales.";
        });
      }
    }
  }

}