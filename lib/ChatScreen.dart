import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late String _userId;
  late String _userName;
  late List<Map<String, dynamic>> _users = [];
  String? _currentUsername;

  // Lista de mensajes para el usuario seleccionado.
  List<Map<String, dynamic>> _messages = [];

  // Usuario seleccionado actualmente.
  Map<String, dynamic>? _selectedUser;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      _userName = user.displayName ?? user.email!.split('@')[0]; // Obtener el nombre de usuario del usuario actual
    }
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail != null) {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUserEmail)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.size > 0) {
          final user = querySnapshot.docs[0].data();
          setState(() {
            _currentUsername = user['username'];
          });
        }
      });
    }
    // Cargar la lista de usuarios desde la base de datos.
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((querySnapshot) {
      _users = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState(() {});
    }).catchError((error) {
      print('Error al cargar los usuarios: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedUser != null
            ? Text(_selectedUser!['username'] as String? ?? '')
            : _currentUsername != null
            ? Text(_currentUsername!)
            : Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _selectedUser != null
                ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('users',
                  arrayContainsAny: [_userId, _selectedUser!['uid']])
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al obtener los mensajes'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Text('No hay mensajes'),
                  );
                }

                final List<DocumentSnapshot> documents =
                    snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final message = documents[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(message['text'] as String),
                      subtitle: Text(message['sender'] as String),
                    );
                  },
                );

              },
            )
                : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user['username']),
                  onTap: () {
                    setState(() {
                      _selectedUser = user;
                    });
                  },
                );
              },
            ),
          ),
          if (_selectedUser != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: 'Escribe aqui'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }



  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    FirebaseFirestore.instance.collection('messages').add({
      'text': text,
      'sender': _userName,
      'userId': _userId,
      'timestamp': Timestamp.now(),
    });


    _controller.clear();
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
