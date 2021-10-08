import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/member/account.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/round_button.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class AddBikePage extends StatelessWidget {
  final Member member;
  const AddBikePage({Key? key, required this.member}) : super(key: key);

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
        child: Column(children: <Widget>[
      const WrapperRoundButton(),
      const AppTitle(text: 'Ajouter un vélo', paddingTop: 0),
      AddBikeForm(member: member)
    ]));
  }
}

class AddBikeForm extends StatefulWidget {
  final Member member;
  const AddBikeForm({Key? key, required this.member}) : super(key: key);

  @override
  _AddBikeFormState createState() => _AddBikeFormState();
}

class _AddBikeFormState extends State<AddBikeForm> {
  final _keyForm = GlobalKey<FormState>();

  final _nameFocus = FocusNode();
  final _name = TextEditingController();

  final _descriptionFocus = FocusNode();
  final _description = TextEditingController();

  final _imageFocus = FocusNode();
  final _image = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _keyForm,
        child: Column(children: <Widget>[
          AppTextField(
              focusNode: _nameFocus,
              textfieldController: _name,
              validator: fieldValidator,
              hintText: 'Entrer un nom de vélo',
              label: 'Nom du vélo',
              obscureText: false,
              icon: Icons.pedal_bike,
              maxLines: 1),
          AppTextField(
              focusNode: _descriptionFocus,
              textfieldController: _description,
              validator: fieldValidator,
              hintText: 'Entrer une description valide',
              label: 'Description du vélo',
              obscureText: false,
              icon: Icons.article,
              maxLines: 8),
          AppTextField(
              focusNode: _imageFocus,
              textfieldController: _image,
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
      _addBike(_name.text, _description.text, _image.text);
    }
  }

  void _addBike(String name, String description, String image) async {
    BikeRepository bikeRepository = BikeRepository();
    List<dynamic> response = await bikeRepository.addBike(
        widget.member.id, name, description, image);
    bool created = response[0];
    dynamic jsonResponse = response[1];
    Color statusColor = Theme.of(context).errorColor;

    if (created) {
      statusColor = Theme.of(context).primaryColor;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AccountPage(member: widget.member)));
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonResponse['confirm']), backgroundColor: statusColor));
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
