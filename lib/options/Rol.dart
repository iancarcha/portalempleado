import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Define la clase Rol
class Rol {
  final String nombre; // Nombre del rol
  final List<String> permisos; // Lista de permisos del rol

  // Constructor de la clase Rol
  Rol({required this.nombre, required this.permisos});

  // Método para asignar un rol a un usuario en Firestore
  Future<void> asignarRolUsuario(User user) async {
    // Obtiene una referencia al documento de roles en Firestore usando el UID del usuario
    final rolRef = FirebaseFirestore.instance.collection('roles').doc(user.uid);

    // Crea un mapa de datos para el rol
    final rolData = {
      'nombre': nombre, // Nombre del rol
      'permisos': permisos, // Lista de permisos del rol
    };

    // Establece los datos del rol en Firestore
    await rolRef.set(rolData);
  }
}
