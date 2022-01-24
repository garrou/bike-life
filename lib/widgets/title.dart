import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String text;
  final double paddingTop;
  final TextStyle style;
  const AppTitle(
      {Key? key,
      required this.text,
      required this.paddingTop,
      required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: paddingTop),
        child: Center(child: Text(text, style: style)),
      );
}
