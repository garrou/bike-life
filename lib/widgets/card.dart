import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/styles/general.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  const AppCard({Key? key, required this.child, required this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mainSize),
          side: const BorderSide(color: deepGreen)),
      elevation: 0.0,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: mainSize),
          child: child));
}
