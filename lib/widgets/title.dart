import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String text;
  final double paddingTop;
  final double paddingBottom;
  final TextStyle style;
  const AppTitle(
      {Key? key,
      required this.text,
      this.paddingBottom = 0,
      this.paddingTop = 0,
      required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(0, paddingTop, 0, paddingBottom),
        child: Text(text, style: style, textAlign: TextAlign.center),
      );
}
