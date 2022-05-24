import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  const AppCard({Key? key, required this.child, this.elevation = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(firstSize),
          side: const BorderSide(color: primaryColor)),
      elevation: elevation,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: firstSize),
          child: child));
}
