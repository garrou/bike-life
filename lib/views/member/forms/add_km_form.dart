import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/routes/args/member_argument.dart';
import 'package:bike_life/routes/member_home_route.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:flutter/material.dart';

class AddKmForm extends StatefulWidget {
  final Member member;
  final Bike bike;
  const AddKmForm({Key? key, required this.bike, required this.member})
      : super(key: key);

  @override
  _AddKmFormState createState() => _AddKmFormState();
}

class _AddKmFormState extends State<AddKmForm> {
  final _keyForm = GlobalKey<FormState>();
  final _kmFocus = FocusNode();
  final _km = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _keyForm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppTextField(
                focusNode: _kmFocus,
                textfieldController: _km,
                validator: null,
                hintText: 'Entrer le nombre de km effectués',
                label: 'Kilomètres',
                obscureText: false,
                icon: Icons.add_road,
                maxLines: 1),
            AppButton(
                text: 'Ajouter',
                callback: () => _onAddBike(_km.text),
                color: mainColor)
          ],
        ));
  }

  void _onAddBike(String newKm) async {
    if (!isValidKm(newKm)) {
      return;
    }
    int km = int.parse(newKm);
    BikeRepository bikeRepository = BikeRepository();
    Bike toUpdate = Bike(
        widget.bike.id,
        widget.bike.name,
        widget.bike.image,
        widget.bike.description,
        widget.bike.nbKm + km,
        widget.bike.dateOfPurchase);
    List<dynamic> response = await bikeRepository.updateBike(toUpdate);
    bool updated = response[0];
    dynamic jsonResponse = response[1];

    if (updated) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse['confirm']), backgroundColor: mainColor));
      Navigator.pushNamed(context, MemberHomeRoute.routeName,
          arguments: MemberArgument(widget.member));
    }
  }
}
