import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class AddBikePage extends StatelessWidget {
  const AddBikePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: const <Widget>[AppTitle(text: 'Ajouter un vélo')]));
  }
}
