import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:flutter/material.dart';

class AppTopLeftButton extends StatelessWidget {
  final VoidCallback callback;
  final String title;
  final bool iconVisible;
  const AppTopLeftButton(
      {Key? key,
      required this.title,
      required this.callback,
      this.iconVisible = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(children: <Widget>[
        Visibility(
            visible: iconVisible,
            child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        secondSize, secondSize, 0.0, 0.0),
                    child: BackButton(onPressed: callback)))),
        Padding(
            padding: const EdgeInsets.only(top: secondSize),
            child: Text(title, style: thirdTextStyle))
      ]);
}
