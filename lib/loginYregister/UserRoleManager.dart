import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRoleManagerPage extends StatefulWidget {
  @override
  _UserRoleManagerPageState createState() => _UserRoleManagerPageState();
}

class _UserRoleManagerPageState extends State<UserRoleManagerPage> {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('roles');
  String currentUserRole = '';

  Future<void> updateUserRole(String userId, String newRole) async {
    DocumentReference userRef = _usersCollection.doc(userId);

    await userRef.update({'rol': newRole});
  }

  Future<void> fetchCurrentUserRole() async {
    try {

      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Get the document snapshot of the current user from the 'users' collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('roles')
          .doc(currentUserId)
          .get();

      // Extract the 'role' field from the document data
      String? rol = (userSnapshot.data() as Map<String, dynamic>)['rol'];


      // Assign the role to the 'currentUserRole' variable
      setState(() {
        currentUserRole = rol!;
      });
    } catch (error) {
      print('Error fetching user role: $error');
    }
  }


  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      fetchCurrentUserRole();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No hay usuarios registrados');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final userId = document.id;
              final userData = document.data() as Map<String, dynamic>;
              final email = userData['correo'];

              bool canChangeRole = false;
              if (currentUserRole == 'admin') {
                canChangeRole = true;
              }

              return ListTile(
                leading: Icon(Icons.person, color: Color(0xffe06b2c)),
                title: Text(email ?? ''),
                subtitle: Text(userData['rol'] ?? ''),
                trailing: canChangeRole
                    ? ElevatedButton(
                  child: Text('Cambiar Rol'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Cambiar Rol'),
                          content: Text(
                              'Selecciona el nuevo rol para el usuario.'),
                          actions: [
                            TextButton(
                              child: Text('Cliente'),
                              onPressed: () {
                                updateUserRole(userId, 'cliente');
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('Admin'),
                              onPressed: () {
                                updateUserRole(userId, 'admin');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
                    : null,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
