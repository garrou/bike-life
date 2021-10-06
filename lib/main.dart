import 'package:bike_life/constants.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: title,
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: mainColor,
            brightness: Brightness.light),
        home: const HomePage());
  }
}
