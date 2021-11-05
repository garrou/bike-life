import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Padding(
      child: CircularProgressIndicator(color: mainColor),
      padding: EdgeInsets.fromLTRB(100.0, 200.0, 100.0, 200.0));
}
