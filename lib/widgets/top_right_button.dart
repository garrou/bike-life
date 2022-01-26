import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/styles/general.dart';
import 'package:flutter/material.dart';

class AppTopRightButton extends StatelessWidget {
  final VoidCallback callback;
  final IconData icon;
  final double padding;
  final Color color;
  const AppTopRightButton(
      {Key? key,
      this.color = deepGreen,
      required this.callback,
      required this.icon,
      required this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.topRight,
      child: Padding(
          padding: EdgeInsets.fromLTRB(0, padding, padding, 0),
          child: IconButton(
              onPressed: callback,
              icon: Icon(icon),
              color: color,
              iconSize: mainSize)));
}
