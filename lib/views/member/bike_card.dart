import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:bike_life/views/widgets/flip_card.dart';
import 'package:flutter/material.dart';

class BikeCard extends StatefulWidget {
  final Bike bike;
  const BikeCard({Key? key, required this.bike}) : super(key: key);

  @override
  _BikeCardState createState() => _BikeCardState();
}

class _BikeCardState extends State<BikeCard> {
  @override
  Widget build(BuildContext context) {
    return AppFlipCard(
        front: _buildFrontCard(widget.bike), back: _buildBackCard(widget.bike));
  }

  Widget _buildFrontCard(Bike bike) => AppCard(
      child: Column(children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(thirdSize),
            child: Image.network(bike.image, fit: BoxFit.cover)),
        Padding(
            child: Text(bike.name, style: secondTextStyle),
            padding: const EdgeInsets.all(thirdSize)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          IconButton(
              onPressed: () {
                /* TODO: see bike ( see details) */
              },
              icon: const Icon(Icons.remove_red_eye)),
          IconButton(
              onPressed: () {/* TODO: edit bike */},
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {/* TODO: edit bike */},
              icon: const Icon(Icons.delete))
        ])
      ]),
      elevation: secondSize);

  Widget _buildBackCard(Bike bike) => AppCard(
      elevation: secondSize,
      child: Padding(
          padding: EdgeInsets.all(thirdSize), child: Text(bike.description)));
}
