import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/routes/member_argument.dart';
import 'package:bike_life/routes/member_home_route.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/styles/rounded_button_style.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:bike_life/views/widgets/flip.dart';
import 'package:bike_life/views/widgets/textfield.dart';
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

  Widget _buildPopUp(BuildContext context) {
    final kmFocus = FocusNode();
    final km = TextEditingController();
    final keyForm = GlobalKey<FormState>();
    return AlertDialog(
      title: const Text('Ajouter des km'),
      content: Form(
          key: keyForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppTextField(
                  focusNode: kmFocus,
                  textfieldController: km,
                  validator: fieldValidator,
                  hintText: 'Entrer le nombre de km effectué',
                  label: 'Kilomètres',
                  obscureText: false,
                  icon: Icons.add_road,
                  maxLines: 1),
              AppButton(
                  text: 'Ajouter',
                  callback: () => _onAddBike(km.text),
                  color: mainColor)
            ],
          )),
      actions: <Widget>[
        ElevatedButton(
          style: roundedButtonStyle(mainColor),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  void _onAddBike(String newKm) async {
    BikeRepository bikeRepository = BikeRepository();
    Bike toUpdate = Bike(
        widget.bike.id,
        widget.bike.name,
        widget.bike.image,
        widget.bike.description,
        widget.bike.nbKm + int.parse(newKm),
        widget.bike.dateOfPurchase);
    List<dynamic> response = await bikeRepository.updateBike(toUpdate);
    bool updated = response[0];
    dynamic jsonResponse = response[1];

    if (updated) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse['confirm']), backgroundColor: mainColor));
    }
    Navigator.pushNamed(context, MemberHomeRoute.routeName,
        arguments: MemberArgument(widget.member));
  }

  Widget _buildBackCard(Bike bike) => AppCard(
      elevation: secondSize,
      child: ListView(
          padding: const EdgeInsets.all(thirdSize),
          children: const <Widget>[]));
}
