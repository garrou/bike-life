import 'package:bike_life/constants.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/round_button.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class AddBikePage extends StatelessWidget {
  const AddBikePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > maxSize) {
        return narrowLayout();
      } else {
        return wideLayout();
      }
    }));
  }

  Widget narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }

  Widget wideLayout() {
    return SingleChildScrollView(
        child: Column(children: const <Widget>[
      WrapperRoundButton(),
      AppTitle(text: 'Ajouter un vélo', paddingTop: 0),
      AddBikeForm()
    ]));
  }
}

class AddBikeForm extends StatefulWidget {
  const AddBikeForm({Key? key}) : super(key: key);

  @override
  _AddBikeFormState createState() => _AddBikeFormState();
}

class _AddBikeFormState extends State<AddBikeForm> {
  final _keyForm = GlobalKey<FormState>();

  final _bikeNameFocus = FocusNode();
  final _bikeName = TextEditingController();

  final _bikeDescriptionFocus = FocusNode();
  final _bikeDescription = TextEditingController();

  final _bikeImageFocus = FocusNode();
  final _bikeImage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _keyForm,
        child: Column(children: <Widget>[
          AppTextField(
              focusNode: _bikeNameFocus,
              textfieldController: _bikeName,
              validator: fieldValidator,
              hintText: 'Entrer un nom de vélo',
              label: 'Nom du vélo',
              obscureText: false,
              icon: Icons.pedal_bike,
              maxLines: 1),
          AppTextField(
              focusNode: _bikeDescriptionFocus,
              textfieldController: _bikeDescription,
              validator: fieldValidator,
              hintText: 'Entrer une description valide',
              label: 'Description du vélo',
              obscureText: false,
              icon: Icons.article,
              maxLines: 8),
          AppTextField(
              focusNode: _bikeImageFocus,
              textfieldController: _bikeImage,
              validator: fieldValidator,
              hintText: "Lien de l'image du vélo",
              label: 'Image du vélo',
              obscureText: false,
              icon: Icons.image,
              maxLines: 1),
          AppButton(text: 'Ajouter', callback: _onAddBike)
        ]));
  }

  void _onAddBike() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      // TODO: Add bike
    }
  }
}

class WrapperRoundButton extends StatelessWidget {
  const WrapperRoundButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: AppRoundButton(
            icon: Icons.arrow_back,
            callback: () => Navigator.of(context).pop(),
            color: mainColor));
  }
}
