import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portalempleado/menu/Chat/ChatScreen.dart';

class UserListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = users[index].data() as Map<String, dynamic>;

              final username = user['username'] as String?;
              final correo = user['correo'] as String?;

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
