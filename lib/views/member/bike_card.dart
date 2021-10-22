import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/views/member/add_km_form.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/styles/rounded_button_style.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:bike_life/views/widgets/flip.dart';
import 'package:flutter/material.dart';

class BikeCard extends StatefulWidget {
  final Member member;
  final Bike bike;
  const BikeCard({Key? key, required this.bike, required this.member})
      : super(key: key);

  @override
  _BikeCardState createState() => _BikeCardState();
}

class _BikeCardState extends State<BikeCard> {
  @override
  Widget build(BuildContext context) {
    return AppFlip(
        front: _buildFrontCard(widget.bike), back: _buildBackCard(widget.bike));
  }

  Widget _buildFrontCard(Bike bike) => AppCard(
      child:
          ListView(padding: const EdgeInsets.all(thirdSize), children: <Widget>[
        Image.network(bike.image, fit: BoxFit.cover),
        Center(
            child: Padding(
                child: Text(bike.name, style: secondTextStyle),
                padding: const EdgeInsets.only(top: thirdSize))),
        Text('Description', style: boldSubTitleStyle),
        Text(bike.description, style: thirdTextStyle),
        Padding(
            child: Text('Distance parcourue', style: boldSubTitleStyle),
            padding: const EdgeInsets.only(top: thirdSize)),
        Padding(
            child: Text('${bike.nbKm} km', style: thirdTextStyle),
            padding: const EdgeInsets.only(bottom: thirdSize)),
        ElevatedButton(
            style: roundedButtonStyle(mainColor),
            onPressed: _onDemandPopUp,
            child: const Text('Ajouter des km'))
      ]),
      elevation: secondSize);

  void _onDemandPopUp() {
    showDialog(context: context, builder: (context) => _buildPopUp(context));
  }

  Widget _buildPopUp(BuildContext context) => AlertDialog(
        title: const Text('Ajouter des km'),
        content: AddKmForm(bike: widget.bike, member: widget.member),
        actions: <Widget>[
          ElevatedButton(
            style: roundedButtonStyle(mainColor),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      );

  Widget _buildBackCard(Bike bike) => AppCard(
      elevation: secondSize,
      child: ListView(
          padding: const EdgeInsets.all(thirdSize),
          children: const <Widget>[/* TODO: Add composants */]));
}
