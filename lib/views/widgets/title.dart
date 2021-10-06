import 'package:bike_life/constants.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String text;
  const AppTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: thirdSize),
      child: Center(child: Text(text, style: mainTextStyle)),
    );
  }
}
