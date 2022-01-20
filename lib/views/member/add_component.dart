import 'dart:async';

import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component_type.dart';
import 'package:bike_life/repositories/component_repository.dart';
import 'package:bike_life/repositories/component_types_repository.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddComponentPage extends StatefulWidget {
  final Bike bike;
  const AddComponentPage({Key? key, required this.bike}) : super(key: key);

  @override
  _AddComponentPageState createState() => _AddComponentPageState();
}

class _AddComponentPageState extends State<AddComponentPage> {
  final _componentTypesRepository = ComponentTypesRepository();
  final _componentRepository = ComponentRepository();
  final StreamController<bool> _authState = StreamController();
  final _keyForm = GlobalKey<FormState>();

  final _imageFocus = FocusNode();
  final _image = TextEditingController();

  final _nbKmFocus = FocusNode();
  final _nbKm = TextEditingController();

  final _brandFocus = FocusNode();
  final _brand = TextEditingController();

  final _durationFocus = FocusNode();
  final _duration = TextEditingController();

  String _dateOfPurchase = DateTime.now().toString().split(' ')[0];
  List<ComponentType> _componentTypes = [];
  String _dropDownValue = "";

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
    _load();
  }

  void _load() async {
    dynamic json = await _componentTypesRepository.getTypes();
    setState(() {
      _componentTypes = createSeveralComponentTypes(json);
      _dropDownValue = _componentTypes.first.name;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: AuthGuard(
          authStream: _authState.stream,
          signedIn: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > maxSize) {
              return narrowLayout();
            } else {
              return wideLayout();
            }
          }),
          signedOut: const SigninPage()));

  Padding narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  ListView wideLayout() => ListView(children: <Widget>[
        Row(children: <Widget>[
          AppTopLeftButton(
              title: 'Ajouter un composant',
              callback: () => Navigator.pushNamed(context, '/home'))
        ]),
        Form(
            key: _keyForm,
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              AppTextField(
                  focusNode: _brandFocus,
                  textfieldController: _brand,
                  validator: emptyValidator,
                  hintText: 'Marque',
                  label: 'Marque',
                  icon: Icons.text_fields,
                  keyboardType: TextInputType.text),
              AppTextField(
                  focusNode: _imageFocus,
                  textfieldController: _image,
                  validator: emptyValidator,
                  hintText: "Lien de l'image",
                  label: 'Image',
                  icon: Icons.image,
                  keyboardType: TextInputType.text),
              AppTextField(
                  focusNode: _nbKmFocus,
                  textfieldController: _nbKm,
                  validator: kmValidator,
                  hintText: 'Kilomètres parcourus avec le composant',
                  label: 'Kilomètres',
                  icon: Icons.add_road,
                  keyboardType: TextInputType.number),
              AppTextField(
                  focusNode: _durationFocus,
                  textfieldController: _duration,
                  validator: kmValidator,
                  hintText: 'Durée de vie en kilomètres',
                  label: 'Durée de vie en km',
                  icon: Icons.health_and_safety,
                  keyboardType: TextInputType.number),
              DropdownButton(
                  value: _dropDownValue,
                  onChanged: _onChanged,
                  items: _componentTypes.map<DropdownMenuItem<String>>(
                      (ComponentType componentType) {
                    return DropdownMenuItem(
                        child: Text(componentType.name, style: secondTextStyle),
                        value: componentType.name);
                  }).toList()),
              Padding(
                  child: AppCalendar(
                      callback: _onDateChanged, selectedDate: _dateOfPurchase),
                  padding: const EdgeInsets.only(top: secondSize)),
              AppButton(
                  callback: _onAddComponent, text: 'Ajouter', color: mainColor)
            ]))
      ]);

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _dateOfPurchase = args.value.toString().split(' ')[0];
  }

  void _onChanged(String? value) {
    setState(() {
      _dropDownValue = value!;
    });
  }

  void _addComponent(String brand, String image, double km, double duration,
      String type, String date) async {
    List<dynamic> response = await _componentRepository.add(
        brand, image, km, duration, type, date, widget.bike.id);
    Color respColor = mainColor;

    if (response[0]) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (Route<dynamic> route) => false);
    } else {
      respColor = errorColor;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response[1]['confirm']), backgroundColor: respColor));
  }

  void _onAddComponent() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _addComponent(_brand.text, _image.text, double.parse(_nbKm.text),
          double.parse(_duration.text), _dropDownValue, _dateOfPurchase);
    }
  }
}
