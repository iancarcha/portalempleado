import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Rol {
  final String nombre;
  final List<String> permisos;

  Rol({required this.nombre, required this.permisos});

  Future<void> asignarRolUsuario(User user) async {
    final rolRef = FirebaseFirestore.instance.collection('roles').doc(user.uid);
    final rolData = {
      'nombre': nombre,
      'permisos': permisos,
    };
    await rolRef.set(rolData);
  }
}



