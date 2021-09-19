import 'package:bike_life/constants.dart';
import 'package:bike_life/main.dart';
import 'package:flutter/material.dart';

class AddBikePage extends StatelessWidget {
  const AddBikePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Ajouter un vélo"), backgroundColor: mainColor),
        body: Container(color: Colors.green));
  }
}
