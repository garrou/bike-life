import 'dart:async';
import 'dart:convert';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BikeDetailsPage extends StatefulWidget {
  final Bike bike;
  const BikeDetailsPage({Key? key, required this.bike}) : super(key: key);

  @override
  _BikeDetailsPageState createState() => _BikeDetailsPageState();
}

class _BikeDetailsPageState extends State<BikeDetailsPage> {
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
          return _narrowLayout();
        } else {
          return _wideLayout();
        }
      })),
      signedOut: const SigninPage());

  Widget _wideLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: thirdSize),
      child: ListView(children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AppTopLeftButton(
                  title: 'Paramètres du vélo',
                  callback: () => Navigator.pop(context))
            ]),
        UpdateBikeForm(bike: widget.bike),
      ]));

  Widget _narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout());
}

class UpdateBikeForm extends StatefulWidget {
  final Bike bike;
  const UpdateBikeForm({Key? key, required this.bike}) : super(key: key);

  @override
  _UpdateBikeFormState createState() => _UpdateBikeFormState();
}

class _UpdateBikeFormState extends State<UpdateBikeForm> {
  final BikeService _bikeService = BikeService();

  final _keyForm = GlobalKey<FormState>();

  final _nameFocus = FocusNode();
  final TextEditingController _name = TextEditingController();

  final _imageFocus = FocusNode();
  final TextEditingController _image = TextEditingController();

  final _nbKmFocus = FocusNode();
  final TextEditingController _nbKm = TextEditingController();

  String _dateOfPurchase = DateTime.now().toString();
  bool? _isElectric = false;

  @override
  void initState() {
    super.initState();
    _name.text = widget.bike.name;
    _image.text = widget.bike.image ?? '';
    _nbKm.text = '${widget.bike.nbKm}';
    _dateOfPurchase = widget.bike.dateOfPurchase.split(' ')[0];
    _isElectric = widget.bike.electric;
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
            validator: emptyValidator,
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
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('Vélo électrique ?', style: secondTextStyle),
          Checkbox(
              fillColor: MaterialStateProperty.all(deepGreen),
              value: _isElectric,
              onChanged: (bool? value) {
                setState(() => _isElectric = value);
              })
        ]),
        AppCalendar(callback: _onDateChanged, selectedDate: _dateOfPurchase),
        AppButton(
            text: 'Modifier',
            callback: _onUpdateBike,
            color: deepGreen,
            icon: const Icon(Icons.edit)),
        AppButton(
            text: 'Supprimer',
            callback: _showDialog,
            color: red,
            icon: const Icon(Icons.delete))
      ]));

  Future _showDialog() async => showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(secondSize)),
            title: const Text('Supprimer ce vélo ?'),
            content: const Text('Le vélo et ses composants seront supprimés'),
            actions: <Widget>[
              TextButton(
                child:
                    const Text('Confirmer', style: TextStyle(color: deepGreen)),
                onPressed: () {
                  _onDeleteBike();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const MemberHomePage(initialPage: 0)),
                      (Route<dynamic> route) => false);
                },
              ),
              TextButton(
                child:
                    const Text('Annuler', style: TextStyle(color: deepGreen)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));

  void _onDeleteBike() async {
    Response response = await _bikeService.deleteBike(widget.bike.id);
    Color color = deepGreen;
    dynamic json = jsonDecode(response.body);

    if (response.statusCode == httpCodeOk) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const MemberHomePage(initialPage: 0)),
          (Route<dynamic> route) => false);
    } else {
      color = red;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(json['confirm']), backgroundColor: color));
  }

  void _onUpdateBike() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateBike();
    }
  }

  void _updateBike() async {
    Response response = await _bikeService.updateBike(Bike(
        widget.bike.id,
        _name.text,
        _image.text,
        double.parse(_nbKm.text),
        _dateOfPurchase,
        _isElectric!));
    Color color = deepGreen;
    dynamic json = jsonDecode(response.body);

    if (response.statusCode == httpCodeOk) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const MemberHomePage(initialPage: 0)),
          (Route<dynamic> route) => false);
    } else {
      color = red;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(json['confirm']), backgroundColor: color));
  }

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _dateOfPurchase = args.value.toString().split(' ')[0];
  }
}
