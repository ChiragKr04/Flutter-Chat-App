import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  final void Function(File pickedImage) imagePickedFn;
  ImagePickerScreen(this.imagePickedFn);
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File _image;
  final picker = ImagePicker();

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Pick image from galley"),
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

  void _pickImage(int method) async {
    if (method == 0) {
      final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150,
      );
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
      widget.imagePickedFn(_image);
    }
    if (method == 1) {
      final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 150,
      );
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
      widget.imagePickedFn(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_image == null)
          CircleAvatar(
            radius: 50,
            child: Text("Select\nImage"),
          ),
        if (_image != null)
          CircleAvatar(
            radius: 50,
            backgroundImage: FileImage(_image),
          ),
        TextButton.icon(
          onPressed: _openBottomSheet,
          icon: Icon(
            Icons.image,
            size: 20,
          ),
          label: Text("Add Image"),
        ),
      ],
    );
  }
}
