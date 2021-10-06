import 'package:bike_life/constants.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/material.dart';

class AppTextfield extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController textfieldController;
  final String? Function(String?)? validator;
  final String hintText;
  final String label;
  final bool obscureText;
  const AppTextfield(
      {Key? key,
      required this.focusNode,
      required this.textfieldController,
      required this.validator,
      required this.hintText,
      required this.label,
      required this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: TextFormField(
            focusNode: focusNode,
            controller: textfieldController,
            style: const TextStyle(color: mainColor),
            obscureText: obscureText,
            decoration: InputDecoration(
                focusedBorder: textfieldBorder(mainSize, secondColor),
                prefixIcon: Icon(Icons.lock,
                    color: focusNode.hasFocus ? secondColor : mainColor),
                border: textfieldBorder(mainSize, secondColor),
                labelText: label,
                labelStyle: TextStyle(
                    color: focusNode.hasFocus ? secondColor : mainColor),
                hintText: hintText),
            cursorColor: mainColor,
            validator: validator));
  }
}

OutlineInputBorder textfieldBorder(double radius, Color borderColor) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: borderColor));
}
