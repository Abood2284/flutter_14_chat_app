import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_14_firebase/widgets/chats/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    /// * Fetching all the messages by ordering from the timeStamp they are created
    return StreamBuilder(
      stream: FirebaseFirestore.instance

          /// * Also we set descending = true, becuase we want the newest chat at the bottom while the listView is reversed
          /// * [createdAt] field is created when you add new meesage in [_sendMessage] in [new_message.dart]
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(), // * Becuase chat is a collection which will have multiple chats called documents
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse:
              true, //  So that new chats are coming from bottom as you see in whatssapp
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index]['text'],
            chatDocs[index]['userId'] == user!.uid ? true : false,
            chatDocs[index]['username'],
            chatDocs[index]['userImage'],
          ),
        );
      },
    );
  }
}
