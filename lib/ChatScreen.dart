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

  // Lista de usuarios cargada desde la base de datos.
  late List<Map<String, dynamic>> _users;

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
      _userName = user.displayName!;
    }
    // Cargar la lista de usuarios desde la base de datos.
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((querySnapshot) {
      _users = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedUser != null
            ? Text(_selectedUser!['username'])
            : Text('Chat'),
      ),
      body: Column(
          children: [
      Expanded(
      child: _selectedUser != null
      ? StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('users', arrayContains: _userId)
          .where('users', arrayContains: _selectedUser!['uid'])
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        _messages = List<Map<String, dynamic>>.from(snapshot.data!.docs.map((doc) => doc.data()));

        return ListView.builder(
          reverse: true,
          controller: _scrollController,
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final message = _messages[index];
            return ListTile(
              title: Text(message['text']),
              subtitle: Text(message['sender']),
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
                    decoration: InputDecoration(hintText: 'Enter message'),
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
      'user': _userName,
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
