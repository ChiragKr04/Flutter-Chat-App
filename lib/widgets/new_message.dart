import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMsg = '';
  var _sendMsgController = TextEditingController();
  bool sendImageLoading = false;
  final user = FirebaseAuth.instance.currentUser;
  String url = "";
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    try {
      if (url.trim() == "") {
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
          "user_chat_image": "",
        });
        setState(() {
          _enteredMsg = "";
          _sendMsgController.clear();
          url = "";
        });
      } else {
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
          "user_chat_image": url,
        });
        setState(() {
          _enteredMsg = "";
          _sendMsgController.clear();
          url = "";
          sendImageLoading = false;
        });
      }
    } catch (e) {
      print(e);
      print("chat cant send");
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxLines = 5;
    return Container(
      margin: EdgeInsets.only(top: 2),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: sendImageLoading
          ? Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sending your Image..."),
                  SizedBox(
                    width: 20,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: Container(
                    height: maxLines + 40.0,
                    padding:
                        EdgeInsets.only(left: 10, right: 2, bottom: 2, top: 2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.black54,
                          width: 2,
                        )),
                    child: TextField(
                      maxLines: maxLines,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      controller: _sendMsgController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 5, bottom: 10, right: 2),
                        border: InputBorder.none,
                        hintText: "Send Message...",
                      ),
                      onChanged: (value) {
                        setState(() {
                          _enteredMsg = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    heroTag: "imageBtn",
                    backgroundColor: Colors.blueAccent,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Icon(
                        Icons.image,
                        size: 25,
                      ),
                    ),
                    onPressed: openImagePicker,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    heroTag: "sendBtn",
                    backgroundColor: _enteredMsg.trim().isEmpty
                        ? Colors.grey
                        : Colors.blueAccent,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.send,
                        size: 25,
                      ),
                    ),
                    onPressed: _enteredMsg.trim().isEmpty ? null : _sendMessage,
                  ),
                ),
              ],
            ),
    );
  }

  void openImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Pick image from gallery"),
                onTap: () {
                  _pickImage(0);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Capture image"),
                onTap: () {
                  _pickImage(1);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  File _image;
  final picker = ImagePicker();

  void _pickImage(int method) async {
    if (method == 0) {
      final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
      sendImageToFirebase(_image);
    }
    if (method == 1) {
      final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 100,
        // maxWidth: 800,
        // maxHeight: 800
      );
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
      sendImageToFirebase(_image);
    }
  }

  void sendImageToFirebase(File image) async {
    setState(() {
      sendImageLoading = true;
    });
    final ref = FirebaseStorage.instance
        .ref()
        .child("user_chat_image")
        .child(user.uid + DateTime.now().toString() + ".jpg");
    await ref.putFile(image);
    url = await ref.getDownloadURL();
    _sendMessage();
  }
}
