import 'dart:async';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/widgets/account_button.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class ComponentDetailPage extends StatefulWidget {
  final Component component;
  const ComponentDetailPage({Key? key, required this.component})
      : super(key: key);

  @override
  _ComponentDetailPageState createState() => _ComponentDetailPageState();
}

class _ComponentDetailPageState extends State<ComponentDetailPage> {
  final StreamController<bool> _authState = StreamController();

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
  }

  @override
  Widget build(BuildContext context) => AuthGuard(
      authStream: _authState.stream,
      signedIn: Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxSize) {
          return narrowLayout();
        } else {
          return wideLayout();
        }
      })),
      signedOut: const SigninPage());

  Widget narrowLayout() => Padding(
      padding: EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  Widget wideLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: thirdSize),
      child: ListView(children: <Widget>[
        AppTopLeftButton(
            title: widget.component.label,
            callback: () => Navigator.of(context).pop()),
        _buildComponentsInfo(widget.component),
        const Divider(
          color: Colors.black,
          height: mainSize,
        ),
        UpdateBikeComponentForm(component: widget.component)
      ]));

  Widget _buildComponentsInfo(Component component) => Column(children: <Widget>[
        Padding(
            child: Text('Marque : ${component.brand ?? "Non spécifiée"}',
                style: thirdTextStyle),
            padding: const EdgeInsets.only(top: thirdSize)),
        Padding(
            child: Text('Durée moyenne de km : ${component.duration} km',
                style: thirdTextStyle),
            padding: const EdgeInsets.only(top: thirdSize)),
        Padding(
            child: Text('Nombre de kilomètres : ${component.km} km',
                style: thirdTextStyle),
            padding: const EdgeInsets.only(top: thirdSize))
      ]);
}

class UpdateBikeComponentForm extends StatefulWidget {
  final Component component;
  const UpdateBikeComponentForm({Key? key, required this.component})
      : super(key: key);

  @override
  _UpdateBikeComponentFormState createState() =>
      _UpdateBikeComponentFormState();
}

class _UpdateBikeComponentFormState extends State<UpdateBikeComponentForm> {
  final _keyForm = GlobalKey<FormState>();

  final _kmFocus = FocusNode();
  late final TextEditingController _km;

  final _brandFocus = FocusNode();
  late final TextEditingController _brand;

  final _durationFocus = FocusNode();
  late final TextEditingController _duration;

  final BikeRepository _bikeRepository = BikeRepository();

  @override
  void initState() {
    super.initState();
    _km = TextEditingController(text: '${widget.component.km}');
    _brand = TextEditingController(text: widget.component.brand ?? '');
    _duration = TextEditingController(text: '${widget.component.duration}');
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(thirdSize),
      child: Form(
          key: _keyForm,
          child: Column(children: <Widget>[
            Text('Modifier', style: secondTextStyle),
            AppTextField(
                keyboardType: TextInputType.text,
                focusNode: _brandFocus,
                textfieldController: _brand,
                validator: emptyValidator,
                hintText: 'Marque du composant',
                label: 'Marque',
                icon: Icons.branding_watermark),
            AppTextField(
                keyboardType: TextInputType.number,
                focusNode: _kmFocus,
                textfieldController: _km,
                validator: kmValidator,
                hintText: 'Nombre de km du composant',
                label: 'Kilomètres',
                icon: Icons.add_road),
            AppTextField(
                keyboardType: TextInputType.number,
                focusNode: _durationFocus,
                textfieldController: _duration,
                validator: kmValidator,
                hintText: 'Durée de vie',
                label: 'Durée de vie du composant (km)',
                icon: Icons.health_and_safety),
            AppAccountButton(
                callback: _onUpdateComponent,
                text: 'Modifier',
                color: mainColor)
          ])));

  void _onUpdateComponent() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateComponent(
          _brand.text, double.parse(_km.text), double.parse(_duration.text));
    }
  }

  void _updateComponent(
      String newBrand, double newKm, double newDuration) async {
    List<dynamic> response = await _bikeRepository.updateComponent(Component(
        widget.component.label,
        widget.component.field,
        widget.component.id,
        newBrand,
        newKm,
        newDuration));
    Color responseColor = mainColor;

    if (response[0]) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (Route<dynamic> route) => false);
    } else {
      responseColor = errorColor;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response[1]['confirm']), backgroundColor: responseColor));
  }
}
