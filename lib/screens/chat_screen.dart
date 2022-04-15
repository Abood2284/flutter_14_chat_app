import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_14_firebase/widgets/chats/messages.dart';
import 'package:flutter_14_firebase/widgets/chats/new_message.dart';

// ! There is no use of statefulWidget here, though its important to let be, bcoz the important code commented out
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // ! This code is commented becuase
  // ! Purpose -> To send notification when a new message was sent
  // ! Reason -> It needs firebase functions inorder to do that, and functions need a biolling account which i am unable to provide at the moment
  // ! Alternative -> You can still youe firebase cloud_messaging tool to send important notifications & marketing messages
  // @override
  // void initState() {
  //   super.initState();
  //   final fbm = FirebaseMessaging.instance;
  //   fbm.requestPermission();
  //   FirebaseMessaging.onMessage.listen((message) {
  //     print(message);
  //     return;
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     print(message);
  //     return;
  //   });
  // fbm.subscribeToTopic('chat'); //* You need Cloud functions inorder to work with notifications that are auto send based on some task, though you can still send marketing messages using cloud_messaging tool on firebase
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Flutter Chat'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                child: Row(
                  children: const [
                    Icon(Icons.exit_to_app, color: Colors.black),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Logout'),
                  ],
                ),
                value:
                    'logout', // SO that every menuItem has unique name to identify with, though here we have only one menuItem
              ),
            ],
            onChanged: (itemIdentifier) {
              // That is why we use value on DropdownMenuItem, to differentiate every item and execute different functions on different pressed
              if (itemIdentifier == 'logout') {
                ///.... Log the user out
                FirebaseAuth.instance.signOut();
              }
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),

      /// This takes a stream which our snapshot is providing to us
      /// * Stream is flow of data that keeps coming, and if it finds any new data it will pull it to our flutter app
      body: Container(
        child: Column(children: const [
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ]),
      ),
    );
  }
}
