import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Opciones extends StatefulWidget {
  @override
  _OpcionesState createState() => _OpcionesState();
}

class _OpcionesState extends State<Opciones> {
  bool esAdministrador = false; // Variable para almacenar si el usuario es administrador

  Future<void> verificarAdministrador() async {
    // Obtener el resultado de la verificación
    bool esAdmin = await obtenerAdministrador();

    setState(() {
      esAdministrador = esAdmin;
    });
  }

  Future<bool> obtenerAdministrador() async {
    // Obtener el usuario actual
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Obtener el documento del usuario en la colección 'usuarios'
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      // Verificar si el usuario tiene el rol de administrador
      if (doc.exists) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        String userRole = userData['rol'];

        if (userRole == 'administrador') {
          // El usuario tiene el rol de administrador
          return true;
        }
      }
    }
    // El usuario no tiene el rol de administrador o no ha iniciado sesión
    return false;
  }

  @override
  void initState() {
    super.initState();
    // Verificar si el usuario actual es administrador
    verificarAdministrador();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Opciones',
          style: TextStyle(color: Colors.white),

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
              'Opciones',
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
            if (esAdministrador) // Mostrar el botón solo si el usuario es administrador
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Cambiar Contraseña de Roles',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  _mostrarCuadroDialogoCambioContrasena(context);
                },
              ),
          ],
        ),
      ),
    );
  }


  void _mostrarCuadroDialogoCambioContrasena(BuildContext context) {
    String nuevaContrasena = '';
    String confirmarContrasena = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cambio de Contrasena de Roles'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Ingresa la nueva contrasena',
                ),
                onChanged: (value) {
                  nuevaContrasena = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Confirma la nueva contrasena',
                ),
                onChanged: (value) {
                  confirmarContrasena = value;
                },
              ),
            ],
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
                if (nuevaContrasena == confirmarContrasena) {
                  // Aqui puedes realizar la logica para cambiar la contrasena de roles
                  _cambiarContrasenaRoles(nuevaContrasena);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Contrasena de Roles cambiada correctamente"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Las contrasenas no coinciden"),
                    ),
                  );
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _cambiarContrasenaRoles(String nuevaContrasena) {
    FirebaseFirestore.instance
        .collection('configuracion')
        .doc('contrasena_roles')
        .set({'contrasena': nuevaContrasena})
        .then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Contraseña cambiada'),
            content: Text('La contraseña de Roles ha sido cambiada exitosamente.'),
            actions: [
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    })
        .catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al cambiar la contraseña de Roles: $error'),
            actions: [
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }


  void _mostrarDialogoCambioRol(BuildContext context) {
    String selectedRole = ''; // Variable para almacenar el rol seleccionado
    String password = ''; // Variable para almacenar la contraseña ingresada

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cambiar Rol'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Lista de roles
              DropdownButton<String>(
                value: selectedRole,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue!;
                  });
                },
                items: <String>[
                  'admin',
                  'user',
                  'editor'
                ] // Lista de roles disponibles
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              // Campo de contraseña
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Cambiar Rol'),
              onPressed: () {
                _cambiarRol(context, selectedRole, password);
              },
            ),
          ],
        );
      },
    );
  }

  void _cambiarRol(BuildContext context, String selectedRole, String password) {
    FirebaseFirestore.instance
        .collection('configuracion')
        .doc('contrasena_roles')
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          String? contrasenaCorrecta = data['contrasena'];

          if (contrasenaCorrecta != null && password == contrasenaCorrecta) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Rol cambiado correctamente"),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Contraseña incorrecta"),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Los datos son nulos o no son un mapa válido"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No se encontró la contraseña de Roles"),
          ),
        );
      }

      Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al obtener la contraseña de Roles"),
        ),
      );
      // Manejar el error de obtener la contraseña de Roles
    });
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
