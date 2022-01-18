import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/styles/rounded_button_style.dart';
import 'package:flutter/material.dart';

class AppNavButton extends StatelessWidget {
  final String text;
  final Widget destination;
  final Color color;
  const AppNavButton(
      {Key? key,
      required this.text,
      required this.destination,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: thirdSize),
      child: SizedBox(
          height: buttonHeight,
          width: buttonWidth,
          child: ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => destination)),
              child: Text(text, style: secondTextStyle),
              style: roundedButtonStyle(color))));
}
