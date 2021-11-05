import 'package:bike_life/constants.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  const AppCard({Key? key, required this.child, required this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(mainSize)),
      elevation: elevation,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: mainSize),
          child: child));
}
