import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/user/user_home.dart';
import 'package:flutter/material.dart';

class BikeDetails extends StatelessWidget {
  final Bike bike;
  const BikeDetails({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Row(children: const <Widget>[
        BackHomeButton(),
        DeleteBikeButton(),
      ]),
      BikeImage(bike: bike),
      BikeName(bike: bike),
      BikeDescription(bike: bike)
    ]));
  }
}

class BikeImage extends StatelessWidget {
  final Bike bike;
  const BikeImage({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: Image.network(bike.image));
  }
}

class BikeName extends StatelessWidget {
  final Bike bike;
  const BikeName({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: thirdSize),
        child: Text(bike.name, style: mainTextStyle));
  }
}

class BikeDescription extends StatelessWidget {
  final Bike bike;
  const BikeDescription({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: thirdSize),
        child: Text(bike.details, style: thirdTextStyle));
  }
}

class BackHomeButton extends StatelessWidget {
  const BackHomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(secondSize, secondSize, 0, 0),
        child: Align(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UserHome())),
                style: roundedButtonStyle(mainColor),
                child: const Icon(Icons.arrow_back))));
  }
}

class DeleteBikeButton extends StatelessWidget {
  const DeleteBikeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, secondSize, secondSize, 0),
        child: Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
                onPressed: () => {},
                style: roundedButtonStyle(deleteColor),
                child: const Icon(Icons.delete))));
  }
}
