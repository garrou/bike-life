import 'package:bike_life/utils/constants.dart';
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
      padding: const EdgeInsets.only(top: thirdSize),
      child: SizedBox(
          height: buttonHeight,
          width: buttonWidth,
          child: ElevatedButton(
              child: Text(text),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => destination)),
              style: roundedButtonStyle(color))));
}
