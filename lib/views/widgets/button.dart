import 'package:bike_life/constants.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/styles/rounded_button_style.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback callback;
  const AppButton(
      {Key? key,
      required this.text,
      required this.callback,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(thirdSize),
      child: SizedBox(
          height: buttonHeight,
          width: buttonWidth,
          child: ElevatedButton(
            onPressed: callback,
            child: Text(text, style: secondTextStyle),
            style: roundedButtonStyle(color),
          )));
}
