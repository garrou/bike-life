import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(children: const <Widget>[
        Padding(
            padding: EdgeInsets.all(mainSize),
            child: CircularProgressIndicator(color: primaryColor))
      ]);
}
