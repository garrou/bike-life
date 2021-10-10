import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/styles/rounded_button_style.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final IconData icon;
  final Color color;
  const AppIconButton(
      {Key? key,
      required this.callback,
      required this.icon,
      required this.color,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: callback,
        style: roundedButtonStyle(mainColor),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    text,
                    style: secondTextStyle,
                  ),
                )
              ],
            )));
  }
}
