import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:flutter/material.dart';

class AppTopLeftButton extends StatelessWidget {
  final VoidCallback callback;
  final String title;
  const AppTopLeftButton(
      {Key? key, required this.title, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(secondSize, secondSize, 0.0, 0.0),
                child: BackButton(onPressed: callback))),
        Padding(
            padding: const EdgeInsets.only(top: secondSize),
            child: Text(title, style: secondTextStyle))
      ]);
}
