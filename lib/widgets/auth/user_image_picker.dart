import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class UserImagePicker extends StatefulWidget {
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  Image pickedImage;

  void _pickImage() async {
    if (kIsWeb) {
      final pickedImageLocal =
          await ImagePickerWeb.getImage(outputType: ImageType.widget);
      setState(() {
        pickedImage = pickedImageLocal;
      });
    } else {
      final _picker = ImagePicker();
      final pickedFile = await _picker.getImage(source: ImageSource.camera);
      final pickedImageLocal = Image.file(File(pickedFile.path));
      setState(() {
        pickedImage = pickedImageLocal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          child: pickedImage,
          radius: 30,
        ),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: () => _pickImage,
            icon: Icon(Icons.image),
            label: Text('Add image')),
      ],
    );
  }
}
