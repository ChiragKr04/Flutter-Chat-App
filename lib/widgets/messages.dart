import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("sendAt", descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting &&
            chatSnapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data.docs;
        print(chatDocs);

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ChatBubble(
                chatDocs[index]["text"],
                chatDocs[index]["userId"] ==
                    FirebaseAuth.instance.currentUser.uid,
                chatDocs[index]["username"],
                chatDocs[index]["user_image"],
                FirebaseAuth.instance.currentUser.metadata.creationTime,
                key: ValueKey(chatDocs[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
