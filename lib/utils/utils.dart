import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

imagePicker (ImageSource source) async {
  print(source);
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);
  if (image == null) return null;
  return await image.readAsBytes();
}

showSnackBar (BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}