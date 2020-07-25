import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      _pickedImage = File(pickedFile.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_pickedImage != null)
          CircleAvatar(
            backgroundImage: FileImage(_pickedImage),
            radius: 30,
          ),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              _pickImage();
            },
            icon: Icon(Icons.image),
            label: Text('Add image')),
      ],
    );
  }
}
