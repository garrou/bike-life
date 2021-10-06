import 'package:bike_life/constants.dart';
import 'package:bike_life/views/styles/rounded_button_style.dart';
import 'package:flutter/material.dart';

class AppRoundButton extends StatelessWidget {
  final VoidCallback callback;
  final IconData icon;
  final Color color;
  const AppRoundButton(
      {Key? key,
      required this.callback,
      required this.icon,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, secondSize, secondSize, 0),
        child: ElevatedButton(
            onPressed: callback,
            style: roundedButtonStyle(color),
            child: Icon(icon)));
  }
}
