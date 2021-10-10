import 'package:bike_life/constants.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/styles/rounded_button_style.dart';
import 'package:flutter/material.dart';

class AppNavButton extends StatelessWidget {
  final String text;
  final Widget destination;
  const AppNavButton({Key? key, required this.text, required this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: thirdSize),
        child: SizedBox(
            height: buttonHeight,
            width: buttonWidth,
            child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => destination)),
                child: Text(text, style: secondTextStyle),
                style: roundedButtonStyle(mainColor))));
  }
}
