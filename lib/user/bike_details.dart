import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:flutter/material.dart';

class BikeDetails extends StatelessWidget {
  final Bike bike;
  const BikeDetails({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(bike.name), backgroundColor: mainColor),
        body: Center(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(thirdSize),
              child: Image.network(bike.image)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: thirdSize),
              child: Text(bike.name, style: mainTextStyle)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: thirdSize),
              child: Text(bike.details, style: thirdTextStyle))
        ])));
  }
}
