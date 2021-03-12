import 'dart:io';

import 'package:chat_app/widgets/image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
    BuildContext context,
  ) submitAuthForm;
  final bool isLoading;
  AuthForm(this.submitAuthForm, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _userName = "";
  String _userEmail = "";
  String _userPassword = "";
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    print(_userName);
    print(_userEmail);
    print(_userPassword);
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please pick an image."),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitAuthForm(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLogin ? Container() : ImagePickerScreen(_pickedImage),
                  TextFormField(
                    key: ValueKey("email"),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                    ),
                    validator: (value) {
                      if (value.isEmpty || !value.contains("@")) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _userEmail = val;
                    },
                  ),
                  // if (!_isLogin)
                  AnimatedOpacity(
                    curve: Curves.easeOut,
                    opacity: _isLogin ? 0.0 : 1.0,
                    duration: Duration(seconds: 2),
                    child: _isLogin
                        ? SizedBox(
                            height: 5,
                          )
                        : Container(
                            child: TextFormField(
                              key: ValueKey("username"),
                              decoration: InputDecoration(
                                labelText: "Username",
                              ),
                              validator: (value) {
                                if (value.isEmpty || value.length < 4) {
                                  return "Username must be 4 character long";
                                }
                                return null;
                              },
                              onSaved: (val) {
                                _userName = val;
                              },
                            ),
                          ),
                  ),
                  TextFormField(
                    key: ValueKey("password"),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return "Password at least 7 character long";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _userPassword = val;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        _trySubmit();
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: _isLogin
                          ? Text(
                              "Login",
                            )
                          : Text("Sign Up"),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: _isLogin
                          ? Text(
                              "Create New Account",
                            )
                          : Text(
                              "Already have an account?",
                            ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
