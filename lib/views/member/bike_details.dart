import 'dart:async';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:bike_life/widgets/top_right_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BikeDetailsPage extends StatefulWidget {
  final Bike bike;
  const BikeDetailsPage({Key? key, required this.bike}) : super(key: key);

  @override
  _BikeDetailsPageState createState() => _BikeDetailsPageState();
}

class _BikeDetailsPageState extends State<BikeDetailsPage> {
  final BikeRepository _bikeRepository = BikeRepository();
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

  Widget wideLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: thirdSize),
      child: ListView(children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AppTopLeftButton(
                  title: 'Paramètres du vélo',
                  callback: () => Navigator.pop(context)),
              AppTopRightButton(
                  callback: () {}, icon: Icons.help, padding: secondSize)
            ]),
        UpdateBikeForm(bike: widget.bike),
        const Divider(color: Colors.black),
        AppButton(text: 'Supprimer', callback: _onDeleteBike, color: errorColor)
      ]));

  Widget narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  void _onDeleteBike() async {
    List<dynamic> response = await _bikeRepository.deleteBike(widget.bike.id);
    Color responseColor = mainColor;

    if (response[0]) {
      Navigator.pushNamed(context, '/tips');
    } else {
      responseColor = errorColor;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response[1]['confirm']), backgroundColor: responseColor));
  }
}

class UpdateBikeForm extends StatefulWidget {
  final Bike bike;
  const UpdateBikeForm({Key? key, required this.bike}) : super(key: key);

  @override
  _UpdateBikeFormState createState() => _UpdateBikeFormState();
}

class _UpdateBikeFormState extends State<UpdateBikeForm> {
  final _keyForm = GlobalKey<FormState>();

  final _nameFocus = FocusNode();
  late final TextEditingController _name;

  final _imageFocus = FocusNode();
  late final TextEditingController _image;

  final _nbKmFocus = FocusNode();
  late final TextEditingController _nbKm;

  final BikeRepository _bikeRepository = BikeRepository();

  late String _dateOfPurchase;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.bike.name);
    _image = TextEditingController(text: widget.bike.image);
    _nbKm = TextEditingController(text: '${widget.bike.nbKm}');
    _dateOfPurchase = widget.bike.dateOfPurchase.split(' ')[0];
  }

  @override
  Widget build(BuildContext context) => Form(
      key: _keyForm,
      child: Column(children: <Widget>[
        AppTextField(
            keyboardType: TextInputType.text,
            focusNode: _nameFocus,
            textfieldController: _name,
            validator: fieldValidator,
            hintText: 'Entrer un nom de vélo',
            label: 'Nom du vélo',
            icon: Icons.pedal_bike),
        AppTextField(
            keyboardType: TextInputType.text,
            focusNode: _imageFocus,
            textfieldController: _image,
            validator: fieldValidator,
            hintText: "Lien de l'image du vélo",
            label: 'Image du vélo',
            icon: Icons.image),
        AppTextField(
            keyboardType: TextInputType.number,
            focusNode: _nbKmFocus,
            textfieldController: _nbKm,
            validator: kmValidator,
            hintText: 'Nombre de kilomètres du vélo',
            label: 'Nombre de km',
            icon: Icons.add_road),
        AppCalendar(callback: _onDateChanged, selectedDate: _dateOfPurchase),
        AppButton(text: 'Modifier', callback: _onUpdateBike, color: mainColor)
      ]));

  void _onUpdateBike() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateBike(_name.text, _image.text, _dateOfPurchase, _nbKm.text);
    }
  }

  void _updateBike(
      String name, String image, String dateOfPurchase, String nbKm) async {
    List<dynamic> response = await _bikeRepository.updateBike(
        Bike(widget.bike.id, name, image, int.parse(nbKm), dateOfPurchase));
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

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _dateOfPurchase = args.value.toString().split(' ')[0];
  }
}
