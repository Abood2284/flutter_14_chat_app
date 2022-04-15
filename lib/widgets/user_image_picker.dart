import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.imagePickerFn, {Key? key}) : super(key: key);

  final void Function(File choosenImg)
      imagePickerFn; // Just to pass the selected file to auth_form.dart, coz in the end every data to the DB is sent through there

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    // imageQuality: -> needs value between 0-100, we dont need hight quality image as it increases the storage on firebase, also same goes with width
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    setState(() {
      _pickedImage = File(pickedImage!.path);
    });
    widget.imagePickerFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text('Add image')),
      ],
    );
  }
}
