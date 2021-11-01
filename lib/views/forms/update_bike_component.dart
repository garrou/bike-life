import 'package:bike_life/constants.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/account_button.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: Form(
            key: _keyForm,
            child: Column(children: <Widget>[
              Text('Modifier', style: secondTextStyle),
              AppTextField(
                  focusNode: _brandFocus,
                  textfieldController: _brand,
                  validator: emptyValidator,
                  hintText: 'Marque du composant',
                  label: 'Marque',
                  icon: Icons.branding_watermark),
              AppTextField(
                  focusNode: _kmFocus,
                  textfieldController: _km,
                  validator: kmValidator,
                  hintText: 'Nombre de km du composant',
                  label: 'Kilomètres',
                  icon: Icons.add_road),
              AppTextField(
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
  }

  void _onUpdateComponent() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateComponent(
          _brand.text, int.parse(_km.text), int.parse(_duration.text));
    }
  }

  void _updateComponent(String newBrand, int newKm, int newDuration) async {
    List<dynamic> response = await _bikeRepository.updateComponent(Component(
        widget.component.label,
        widget.component.field,
        widget.component.id,
        newBrand,
        newKm,
        newDuration));
    bool updated = response[0];
    dynamic jsonResponse = response[1];

    if (updated) {
      Navigator.of(context).pop();
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(jsonResponse['confirm'])));
  }
}
