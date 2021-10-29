import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/routes/add_bike_route.dart';
import 'package:bike_life/routes/args/bike_argument.dart';
import 'package:bike_life/views/member/bike_details.dart';
import 'package:bike_life/views/member/forms/add_km_form.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/account_button.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:bike_life/views/widgets/flip.dart';
import 'package:bike_life/views/widgets/percent_bar.dart';
import 'package:bike_life/views/widgets/top_right_button.dart';
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
  final BikeRepository _bikeRepository = BikeRepository();
  List<Component> components = [];

  @override
  Widget build(BuildContext context) {
    return AppFlip(
        front: _buildFrontCard(widget.bike), back: _buildBackCard(widget.bike));
  }

  void _loadComponents() async {
    dynamic jsonComponents =
        await _bikeRepository.getComponents(widget.bike.id);

    if (jsonComponents != null) {
      setState(() {
        components = [
          Component.fromJson(jsonComponents, 'frame', 'Cadre'),
          Component.fromJson(jsonComponents, 'fork', 'Fourche'),
          Component.fromJson(jsonComponents, 'string', 'Chaîne'),
          Component.fromJson(
              jsonComponents, 'air_chamber_forward', 'Chambre à air avant'),
          Component.fromJson(
              jsonComponents, 'air_chamber_backward', 'Chambre à air arrière'),
          Component.fromJson(jsonComponents, 'brake_forward', 'Frein avant'),
          Component.fromJson(jsonComponents, 'brake_backward', 'Frein arrière'),
          Component.fromJson(jsonComponents, 'tire_forward', 'Pneu avant'),
          Component.fromJson(jsonComponents, 'tire_backward', 'Pneu arrière'),
          Component.fromJson(jsonComponents, 'transmission', 'Transmission'),
          Component.fromJson(jsonComponents, 'wheel_forward', 'Roue avant'),
          Component.fromJson(jsonComponents, 'wheel_backward', 'Roue arrière')
        ];
      });
    }
  }

  Widget _buildFrontCard(Bike bike) => AppCard(
      child:
          ListView(padding: const EdgeInsets.all(thirdSize), children: <Widget>[
        Image.network(bike.image, fit: BoxFit.cover),
        Center(
            child: Padding(
                child: Text(bike.name, style: secondTextStyle),
                padding: const EdgeInsets.symmetric(vertical: thirdSize))),
        Padding(
            child: Text('Distance parcourue', style: boldSubTitleStyle),
            padding: const EdgeInsets.only(top: thirdSize)),
        Text('${bike.nbKm} km', style: thirdTextStyle),
        AppAccountButton(
            callback: _onDemandPopUp, text: 'Ajouter des km', color: mainColor)
      ]),
      elevation: secondSize);

  Widget _buildPopUp(BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(mainSize))),
        title: const Text('Ajouter des km'),
        content: AddKmForm(bike: widget.bike, member: widget.member),
        actions: <Widget>[
          AppAccountButton(
              callback: () => Navigator.of(context).pop(),
              text: 'Fermer',
              color: mainColor)
        ],
      );

  Widget _buildBackCard(Bike bike) {
    _loadComponents();
    return AppCard(
        elevation: secondSize,
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: thirdSize),
            children: <Widget>[
              AppTopRightButton(
                  callback: _onBikeDetailsClick,
                  icon: Icons.info,
                  padding: 0.0),
              for (Component component in components)
                AppPercentBar(component: component),
            ]));
  }

  void _onBikeDetailsClick() async {
    Navigator.pushNamed(context, AddBikeRoute.routeName,
        arguments: BikeArgument(widget.bike));
  }

  void _onDemandPopUp() {
    showDialog(context: context, builder: (context) => _buildPopUp(context));
  }
}
