import 'dart:convert';

import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/views/member/add_component.dart';
import 'package:bike_life/views/member/bike_details.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/account_button.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/card.dart';
import 'package:bike_life/widgets/flip.dart';
import 'package:bike_life/widgets/percent_bar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_right_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BikeCard extends StatefulWidget {
  final Bike bike;
  const BikeCard({Key? key, required this.bike}) : super(key: key);

  @override
  _BikeCardState createState() => _BikeCardState();
}

class _BikeCardState extends State<BikeCard> {
  final ComponentService _componentService = ComponentService();
  List<Component> _components = [];

  @override
  void initState() {
    super.initState();
    _loadComponents();
  }

  @override
  Widget build(BuildContext context) => AppFlip(
      front: _buildFrontCard(widget.bike, context),
      back: _buildBackCard(widget.bike));

  void _loadComponents() async {
    Response response =
        await _componentService.getBikeComponents(widget.bike.id);
    setState(() =>
        _components = createComponentsFromList(jsonDecode(response.body)));
  }

  Widget _buildFrontCard(Bike bike, BuildContext context) => AppCard(
      child: ListView(
          padding:
              const EdgeInsets.fromLTRB(thirdSize, 0, thirdSize, thirdSize),
          children: <Widget>[
            Center(child: Text(bike.name, style: secondTextStyle)),
            Padding(
                child: Text('Distance parcourue', style: boldSubTitleStyle),
                padding: const EdgeInsets.only(top: thirdSize)),
            Text('${bike.nbKm} km', style: thirdTextStyle),
            AppAccountButton(
                callback: _onOpenPopUp,
                text: 'Ajouter des km',
                color: deepGreen)
          ]),
      elevation: secondSize);

  Widget _buildPopUp(BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(mainSize))),
        title: const Text('Ajouter des km'),
        content: AddKmForm(bike: widget.bike),
        actions: <Widget>[
          AppAccountButton(
              callback: () => Navigator.of(context).pop(),
              text: 'Fermer',
              color: deepGreen)
        ],
      );

  Widget _buildBackCard(Bike bike) => AppCard(
      elevation: secondSize,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: secondSize),
          children: <Widget>[
            AppTopRightButton(
                callback: _onBikeDetailsClick,
                icon: Icons.settings,
                padding: 0.0),
            for (Component component in _components)
              AppPercentBar(component: component),
            AppAccountButton(
                color: deepGreen,
                text: 'Ajouter un composant',
                callback: _onAddComponentPage)
          ]));

  void _onAddComponentPage() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              AddComponentPage(bike: widget.bike)));

  void _onBikeDetailsClick() => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => BikeDetailsPage(bike: widget.bike),
        ),
      );

  void _onOpenPopUp() =>
      showDialog(context: context, builder: (context) => _buildPopUp(context));
}

class AddKmForm extends StatefulWidget {
  final Bike bike;
  const AddKmForm({Key? key, required this.bike}) : super(key: key);

  @override
  _AddKmFormState createState() => _AddKmFormState();
}

class _AddKmFormState extends State<AddKmForm> {
  final _keyForm = GlobalKey<FormState>();
  final _kmFocus = FocusNode();
  final _km = TextEditingController();
  final _bikeService = BikeService();

  @override
  Widget build(BuildContext context) => Form(
      key: _keyForm,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AppTextField(
              keyboardType: TextInputType.number,
              focusNode: _kmFocus,
              textfieldController: _km,
              validator: kmValidator,
              hintText: 'Nombre de km effectués',
              label: 'Kilomètres',
              icon: Icons.add_road),
          AppButton(
              text: 'Ajouter',
              callback: () => _onAddKm(_km.text),
              color: deepGreen)
        ],
      ));

  void _onAddKm(String km) {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _addKm(double.parse(km));
    }
  }

  void _addKm(double toAdd) async {
    Response response = await _bikeService.updateBikeKm(widget.bike.id, toAdd);
    Color responseColor = deepGreen;
    dynamic json = jsonDecode(response.body);

    if (response.statusCode == httpCodeOk) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const MemberHomePage()),
          (Route<dynamic> route) => false);
    } else {
      responseColor = red;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(json['confirm']), backgroundColor: responseColor));
  }
}
