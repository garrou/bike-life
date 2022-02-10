import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback callback;
  final Icon icon;
  final double width;
  final double height;
  const AppButton(
      {Key? key,
      required this.text,
      required this.callback,
      this.color = primaryColor,
      this.width = buttonWidth,
      this.height = buttonHeight,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(thirdSize),
      child: SizedBox(
          height: height,
          width: width,
          child: ElevatedButton.icon(
              onPressed: callback,
              icon: icon,
              label: Text(text, style: thirdTextStyle),
              style: roundedButtonStyle(color))));
}
