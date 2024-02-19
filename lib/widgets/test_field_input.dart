import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditngController;
  final bool isPass;
  final String hintText;
  final TextInputType keyboardType;
  const TextFieldInput(
      {super.key,
      required this.textEditngController,
      this.isPass = false,
      required this.hintText,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Colors.transparent),
    );
    return TextField(
      controller: textEditngController,
      keyboardType: keyboardType,
      obscureText: isPass,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
      ),
    );
  }
}
