import 'package:bike_life/constants.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  const AppCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainSize)),
        elevation: secondSize,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: mainSize),
            child: child));
  }
}
