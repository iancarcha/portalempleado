import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portalempleado/menu/Chat/ChatScreen.dart';

class UserListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Establece el stream de datos desde la colección 'users' en Firestore
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Comprobar si hay algún error en el snapshot
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Comprobar el estado de conexión del snapshot
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Obtener la lista de usuarios del snapshot
          final users = snapshot.data!.docs;

          // Construir una ListView con los usuarios
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = users[index].data() as Map<String, dynamic>;

              // Obtener el nombre de usuario y el correo del usuario actual
              final username = user['username'] as String?;
              final correo = user['correo'] as String?;

              // Mostrar una lista de usuarios en ListTile
              return ListTile(
                title: Text(username ?? ''),
                subtitle: Text(correo ?? ''),
                onTap: () {
                  // Navegar al chat con el usuario seleccionado
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(user),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
