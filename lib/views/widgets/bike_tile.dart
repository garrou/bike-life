import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/views/member/bike_details.dart';
import 'package:flutter/material.dart';

class AppBikeTile extends StatelessWidget {
  final Member member;
  final Bike bike;
  const AppBikeTile({Key? key, required this.bike, required this.member})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(bikeDetailsRoute()),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(mainSize)),
            margin: const EdgeInsets.all(thirdSize),
            elevation: thirdSize,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: mainSize),
              child: ListTile(
                  leading: Image.network(bike.image),
                  title: Padding(
                      padding: const EdgeInsets.only(bottom: thirdSize),
                      child: Text(bike.name,
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  subtitle: Text(bike.description)),
            )));
  }

  Route bikeDetailsRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BikeDetailsPage(bike: bike, member: member),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
              position: animation.drive(
                  Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeInOut))),
              child: child);
        });
  }
}
