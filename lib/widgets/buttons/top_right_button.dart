import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:flutter/material.dart';

class AppTopRightButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final double paddingTop;
  final Color color;
  const AppTopRightButton(
      {Key? key,
      this.color = primaryColor,
      required this.onPressed,
      required this.icon,
      required this.paddingTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(top: paddingTop),
          child: IconButton(
              onPressed: onPressed,
              icon: icon,
              color: color,
              iconSize: firstSize),
        ),
      );
}
