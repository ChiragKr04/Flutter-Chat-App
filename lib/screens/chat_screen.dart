import 'package:chat_app/widgets/messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isNight = false;
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
        title: Text(
          "Chat Screen",
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          InkWell(
            splashColor: Colors.black54.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            child: DropdownButton(
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
              icon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: isNight
                ? Icon(
                    Icons.nights_stay_rounded,
                    color: Colors.black87,
                  )
                : Icon(
                    Icons.wb_sunny,
                    color: Colors.yellow,
                  ),
            onPressed: () {
              setState(() {
                isNight = !isNight;
              });
            },
          ),
        ],
      ),
      body: Container(
        color: isNight ? Colors.black54.withOpacity(0.5) : Colors.white70,
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
