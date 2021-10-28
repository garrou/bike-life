import 'package:bike_life/constants.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/material.dart';

class AppTopLeftButton extends StatelessWidget {
  final VoidCallback callback;
  final String title;
  const AppTopLeftButton(
      {Key? key, required this.callback, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(secondSize, secondSize, 0, 0),
              child: IconButton(
                  onPressed: callback,
                  icon: const Icon(Icons.arrow_back),
                  color: mainColor,
                  iconSize: mainSize))),
      Padding(
          padding: const EdgeInsets.only(top: secondSize),
          child: Text(title, style: secondTextStyle))
    ]);
  }
}
