import 'package:bike_life/constants.dart';
import 'package:bike_life/views/styles/rounded_button_style.dart';
import 'package:flutter/material.dart';

class AppAccountButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final Color color;
  const AppAccountButton(
      {Key? key,
      required this.callback,
      required this.text,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        child: ElevatedButton(
            style: roundedButtonStyle(color),
            onPressed: callback,
            child: Text(text)),
        padding: const EdgeInsets.only(top: thirdSize));
  }
}
