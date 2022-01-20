import 'dart:async';

import 'package:bike_life/models/component_type.dart';
import 'package:bike_life/repositories/component_types_repository.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddComponentPage extends StatefulWidget {
  const AddComponentPage({Key? key}) : super(key: key);

  @override
  _AddComponentPageState createState() => _AddComponentPageState();
}

class _AddComponentPageState extends State<AddComponentPage> {
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

  final _componentTypesRepository = ComponentTypesRepository();
  List<ComponentType> _componentTypes = [];
  late String _dropDownValue;

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

  Form wideLayout() => Form(
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
            items: _componentTypes
                .map<DropdownMenuItem<String>>((ComponentType componentType) {
              return DropdownMenuItem(
                  child: Text(componentType.name), value: componentType.name);
            }).toList()),
        AppCalendar(callback: _onDateChanged, selectedDate: _dateOfPurchase)
      ]));

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _dateOfPurchase = args.value.toString().split(' ')[0];
  }

  void _onChanged(String? value) {
    setState(() {
      _dropDownValue = value!;
    });
  }
}
