import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/views/member/bike_details.dart';
import 'package:flutter/material.dart';

class AppBikeTile extends StatelessWidget {
  final Bike bike;
  const AppBikeTile({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(_bikeDetailsRoute()),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(mainSize)),
            margin: const EdgeInsets.all(thirdSize),
            elevation: thirdSize,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: paddingTop),
              child: ListTile(
                  leading: Image.network(bike.image),
                  title: Padding(
                      padding: const EdgeInsets.only(bottom: thirdSize),
                      child: Text(bike.name,
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  subtitle: Text(bike.details)),
            )));
  }

  Route _bikeDetailsRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BikeDetails(bike: bike),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
              position: animation.drive(
                  Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeInOut))),
              child: child);
        });
  }
}
