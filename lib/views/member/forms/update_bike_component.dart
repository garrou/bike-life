import 'package:bike_life/constants.dart';
import 'package:bike_life/models/component.dart';
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

  @override
  void initState() {
    super.initState();
    _km = TextEditingController(text: '${widget.component.km}');
    _brand = TextEditingController(text: widget.component.brand ?? '');
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
              AppAccountButton(
                  callback: _updateComponent,
                  text: 'Modifier',
                  color: mainColor)
            ])));
  }

  void _updateComponent() {
    // TODO; Update component
  }
}
