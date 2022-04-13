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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          children: <Widget>[
            Visibility(
                visible: iconVisible,
                child: Align(
                    alignment: Alignment.topLeft,
                    child: BackButton(onPressed: callback))),
            Text(title, style: thirdTextStyle)
          ],
        ),
      );
}
