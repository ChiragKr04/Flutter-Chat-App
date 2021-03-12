import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMsg = '';
  var _sendMsgController = TextEditingController();
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection("userData")
          .doc(user.uid)
          .get();
      FirebaseFirestore.instance.collection("chat").add({
        "text": _enteredMsg,
        "sendAt": Timestamp.now(),
        "userId": user.uid,
        "username": userData["username"],
        "user_image": userData["image_url"],
      });
      _enteredMsg = '';
      _sendMsgController.clear();
    } catch (e) {
      print("chat cant send");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              controller: _sendMsgController,
              decoration: InputDecoration(
                hintText: "Send Message...",
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMsg = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color:
                  _enteredMsg.trim().isEmpty ? Colors.grey : Colors.blueAccent,
              size: 25,
            ),
            onPressed: _enteredMsg.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
