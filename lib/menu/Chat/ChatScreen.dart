import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  ChatScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user['username']),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(user['userId'])
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = messages[index].data() as Map<String, dynamic>?;

                    if (message == null) {
                      // Manejar el caso en que el mensaje sea nulo
                      return Container();
                    }

                    return ListTile(
                      title: Text(message['text'] as String? ?? ''),
                      subtitle: Text(message['timestamp']?.toString() ?? ''),
                    );
                  },
                );

              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.message),
            title: TextField(
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
              ),
              onSubmitted: (String text) {
                // Enviar el mensaje al chat
                FirebaseFirestore.instance
                    .collection('chats')
                    .doc(user['userId'])
                    .collection('messages')
                    .add({
                  'text': text,
                  'timestamp': DateTime.now(),
                });

                // Limpiar el campo de texto después de enviar el mensaje
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
