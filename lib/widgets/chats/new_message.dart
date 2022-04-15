import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredText = '';
  final _controller = TextEditingController(); // TO clear the TextField

  void _sendMessage() async {
    FocusScope.of(context).unfocus(); // Hide the soft keyboard
    final user = FirebaseAuth.instance.currentUser;
    // * We are fetching the data of the current user to get access to its Username
    //* then we store that username with the chat message he writes
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredText,

      // So that in [chat_screen.dart] we can fetch our chats by ordering from the newest at the bottom
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()![
          'username'], // Stroring the users username with the chat, you can use .data() to extract anything, though Without it also it is working, no reason available, but for acceessing you need data
      'userImage': userData.data()!['imageUrl'],
    });
    _controller.clear();
    setState(() {
      _enteredText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller:
                  _controller, // For clearing the field after the meesage is sent
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization
                  .sentences, // All sentences start with capital first letter
              decoration: const InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredText = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredText.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
