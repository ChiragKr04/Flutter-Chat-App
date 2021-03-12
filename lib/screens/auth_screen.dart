import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  void _submitAuthForm(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential _auth;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        _auth = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        _auth = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child(_auth.user.uid + ".jpg");
        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("userData")
            .doc(_auth.user.uid)
            .set({
          "username": username,
          "email": email,
          "image_url": url,
        });
        setState(() {
          isLoading = false;
        });
      }
    } on PlatformException catch (e) {
      print("error catch plat");
      var defMsg = "An error occurred, check credentials.";
      if (e.message != null) {
        defMsg = e.message;
      }
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(defMsg),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );

      print("defmsg $defMsg");
      print("err : $e");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text("Can\'t login"),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      print("error catch ");
      print("err : $e");
    }
  }

  @override
  void dispose() {
    if (!mounted) {
      return;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, isLoading),
    );
  }
}
