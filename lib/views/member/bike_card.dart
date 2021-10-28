import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/views/member/bike_details.dart';
import 'package:bike_life/views/member/forms/add_km_form.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/account_button.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:bike_life/views/widgets/flip.dart';
import 'package:bike_life/views/widgets/percent_bar.dart';
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
            padding: const EdgeInsets.all(thirdSize),
            children: <Widget>[
              Center(child: Text('À changer bientôt', style: secondTextStyle)),
              for (Component component in components)
                if (component.duration - component.km <= limitDuration)
                  AppPercentBar(component: component),
              AppAccountButton(
                  callback: _onBikeDetailsClick,
                  text: 'Composants',
                  color: mainColor)
            ]));
  }

  void _onBikeDetailsClick() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BikeDetailsPage(bike: widget.bike, components: components)),
    );
  }

  void _onDemandPopUp() {
    showDialog(context: context, builder: (context) => _buildPopUp(context));
  }
}
