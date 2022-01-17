import 'package:bike_life/models/bike.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:flutter/material.dart';

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
  final _bikeRepository = BikeRepository();

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
              color: mainColor)
        ],
      ));

  void _onAddKm(String newKm) {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _addKm(int.parse(_km.text));
    }
  }

  void _addKm(int newKm) async {
    List<dynamic> response = await _bikeRepository.updateBike(Bike(
        widget.bike.id,
        widget.bike.name,
        widget.bike.image,
        widget.bike.nbKm + newKm,
        widget.bike.dateOfPurchase));
    bool updated = response[0];
    dynamic jsonResponse = response[1];

    if (updated) {
      Navigator.pushReplacementNamed(context, '/home');
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonResponse['confirm']), backgroundColor: mainColor));
  }
}
