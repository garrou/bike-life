import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String text;
  final double paddingTop;
  const AppTitle({Key? key, required this.text, required this.paddingTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: paddingTop),
        child: Center(child: Text(text, style: mainTextStyle)),
      );
}
