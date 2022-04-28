import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController textfieldController;
  final String? Function(String?)? validator;
  final String label;
  final bool obscureText;
  final IconData icon;
  final int maxLines;
  final bool enabled;
  final TextInputType keyboardType;
  const AppTextField(
      {Key? key,
      required this.focusNode,
      required this.textfieldController,
      required this.validator,
      required this.label,
      required this.icon,
      required this.keyboardType,
      this.obscureText = false,
      this.maxLines = 1,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: TextFormField(
            enabled: enabled,
            keyboardType: keyboardType,
            maxLines: maxLines,
            focusNode: focusNode,
            controller: textfieldController,
            obscureText: obscureText,
            decoration: InputDecoration(
              focusedBorder: textFieldBorder(firstSize, primaryColor),
              prefixIcon: Icon(icon,
                  color: focusNode.hasFocus ? intermediateColor : primaryColor),
              border: textFieldBorder(firstSize, intermediateColor),
              labelText: label,
              labelStyle: TextStyle(
                  color: focusNode.hasFocus ? intermediateColor : primaryColor),
            ),
            cursorColor: primaryColor,
            validator: validator),
      );
}
