import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:flutter/material.dart';

class AppTopRightButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final double padding;
  final Color color;
  const AppTopRightButton(
      {Key? key,
      this.color = primaryColor,
      required this.onPressed,
      required this.icon,
      required this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.topRight,
      child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, padding, padding, 0.0),
          child: IconButton(
              onPressed: onPressed,
              icon: icon,
              color: color,
              iconSize: mainSize)));
}
