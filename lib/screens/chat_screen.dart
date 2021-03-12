import 'package:chat_app/widgets/messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // final fbm = FirebaseMessaging.instance.getInitialMessage();
    // FirebaseMessaging.onMessage.listen((event) { })
    super.initState();
  }

  var msg = [];
  @override
  Widget build(BuildContext context) {
    print("buildrun");
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Screen"),
        actions: [
          DropdownButton(
            underline: Container(),
            onChanged: (itemClicked) {
              if (itemClicked == "logout") {
                FirebaseAuth.instance.signOut();
              }
            },
            items: [
              DropdownMenuItem(
                value: "logout",
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Logout"),
                    ],
                  ),
                ),
              )
            ],
            icon: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.more_vert,
                color: Theme.of(context).accentColor,
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(
      //     Icons.add,
      //   ),
      //   onPressed: () {
      //     FirebaseFirestore.instance
      //         .collection("chats/xs6S0Dskd6Ouiqn3MTp7/messages")
      //         .add({
      //       "text": "Hellew added by pressing button",
      //     });
      //   },
      // ),
    );
  }
}
