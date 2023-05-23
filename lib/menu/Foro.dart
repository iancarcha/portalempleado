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
        title: Text(
          'Arocival Foro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
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
                      final message =
                      messages[index].data() as Map<String, dynamic>;
                      final sender = message['sender'];
                      final text = message['text'];
                      final timestamp =
                      message['timestamp'] as Timestamp;

                      final dateTime = timestamp.toDate();
                      final dateFormat = DateFormat('dd/MM/yyyy');
                      final timeFormat = DateFormat('HH:mm');
                      final formattedDate = dateFormat.format(dateTime);
                      final formattedTime = timeFormat.format(dateTime);

                      return ListTile(
                        title: Text(
                          '$sender',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$text',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '$formattedDate - $formattedTime',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Write a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
