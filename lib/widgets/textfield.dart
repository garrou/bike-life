import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/styles/textfield_border.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController textfieldController;
  final String? Function(String?)? validator;
  final String hintText;
  final String label;
  final bool obscureText;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;
  const AppTextField(
      {Key? key,
      required this.focusNode,
      required this.textfieldController,
      required this.validator,
      required this.hintText,
      required this.label,
      required this.icon,
      required this.keyboardType,
      this.obscureText = false,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(thirdSize),
      child: TextFormField(
          keyboardType: keyboardType,
          maxLines: maxLines,
          focusNode: focusNode,
          controller: textfieldController,
          style: const TextStyle(color: deepGreen),
          obscureText: obscureText,
          decoration: InputDecoration(
              focusedBorder: textFieldBorder(mainSize, intermediateGreen),
              prefixIcon: Icon(icon,
                  color: focusNode.hasFocus ? intermediateGreen : deepGreen),
              border: textFieldBorder(mainSize, intermediateGreen),
              labelText: label,
              labelStyle: TextStyle(
                  color: focusNode.hasFocus ? intermediateGreen : deepGreen),
              hintText: hintText),
          cursorColor: deepGreen,
          validator: validator));
}
