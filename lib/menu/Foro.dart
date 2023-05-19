import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Foro extends StatefulWidget {
  @override
  _ForoState createState() => _ForoState();
}

class _ForoState extends State<Foro> {
  final TextEditingController _textEditingController = TextEditingController();
  final CollectionReference _messagesCollection = FirebaseFirestore.instance.collection('messages');
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arocival - Foro'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index].data() as Map<String, dynamic>;
                      final sender = message['sender'];
                      final text = message['text'];
                      final timestamp = message['timestamp'] as Timestamp;

                      final dateTime = timestamp.toDate();
                      final dateFormat = DateFormat('dd/MM/yyyy');
                      final timeFormat = DateFormat('HH:mm');
                      final formattedDate = dateFormat.format(dateTime);
                      final formattedTime = timeFormat.format(dateTime);

                      return ListTile(
                        title: Text('$sender: $text'),
                        subtitle: Text('$formattedDate - $formattedTime'),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
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
    final text = _textEditingController.text.trim();
    if (text.isNotEmpty) {
      _messagesCollection.add({
        'sender': _currentUser.displayName ?? _currentUser.email!,
        'text': text,
        'timestamp': Timestamp.now(),
        'userId': _currentUser.uid,
      });
      _textEditingController.clear();
    }
  }
}
