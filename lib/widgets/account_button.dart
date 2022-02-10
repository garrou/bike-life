import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
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
  Widget build(BuildContext context) => Padding(
      child: ElevatedButton(
          style: roundedButtonStyle(color),
          onPressed: callback,
          child: Text(text)),
      padding: const EdgeInsets.only(top: thirdSize));
}
