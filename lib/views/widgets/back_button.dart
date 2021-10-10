import 'package:bike_life/constants.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback callback;
  const AppBackButton({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(secondSize, secondSize, 0, 0),
            child: IconButton(
                onPressed: callback,
                icon: const Icon(Icons.arrow_back),
                color: mainColor,
                iconSize: mainSize)));
  }
}
