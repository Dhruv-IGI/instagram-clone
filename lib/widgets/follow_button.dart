import 'package:flutter/material.dart';

import '../utils/global_variables.dart';

class Followbutton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;
  const Followbutton({super.key, this.function, required this.backgroundColor, required this.borderColor, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding:width < webScreenSize ? const EdgeInsets.only(top: 8.0) : const EdgeInsets.only(top: 15.0),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: backgroundColor,
            border: Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          width: width < webScreenSize ? width/1.8 : width/5,
          height: width < webScreenSize ? 25 : 35,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

