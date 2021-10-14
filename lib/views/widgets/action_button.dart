import 'package:bike_life/constants.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/material.dart';

class AppActionButton extends StatelessWidget {
  final VoidCallback callback;
  final IconData icon;
  const AppActionButton({Key? key, required this.callback, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, secondSize, secondSize, 0),
            child: IconButton(
                onPressed: callback,
                icon: Icon(icon),
                color: mainColor,
                iconSize: mainSize)));
  }
}
