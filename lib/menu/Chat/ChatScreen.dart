import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  ChatScreen(this.user);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Stream<QuerySnapshot> _messageStream;

  @override
  void initState() {
    super.initState();

    // Establecer el stream de mensajes desde la colección correspondiente en Firestore
    _messageStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.user['userId'])
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void _sendMessage() {
    final String text = _messageController.text.trim();

    if (text.isNotEmpty) {
      // Guardar el mensaje en la colección correspondiente en Firestore
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.user['userId'])
          .collection('messages')
          .add({
        'text': text,
        'timestamp': DateTime.now(),
      });

      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat con ${widget.user['username']}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messageStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // Comprobar si hay algún error en el snapshot
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                // Comprobar el estado de conexión del snapshot
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Obtener la lista de mensajes del snapshot
                final messages = snapshot.data!.docs;

                // Desplazarse automáticamente hacia el último mensaje recibido
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });

                // Construir una ListView para mostrar los mensajes
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message =
                    messages[index].data() as Map<String, dynamic>?;

                    if (message == null) {
                      // Manejar el caso en que el mensaje sea nulo
                      return Container();
                    }

                    // Mostrar el mensaje en un ListTile
                    return ListTile(
                      title: Text(
                        message['text'] as String? ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
            trailing: IconButton(
              icon: Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
