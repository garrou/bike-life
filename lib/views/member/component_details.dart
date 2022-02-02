import 'dart:async';
import 'dart:convert';

import 'package:bike_life/models/component_type.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/services/component_types_service.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ComponentDetailPage extends StatefulWidget {
  final Component component;
  const ComponentDetailPage({Key? key, required this.component})
      : super(key: key);

  @override
  _ComponentDetailPageState createState() => _ComponentDetailPageState();
}

class _ComponentDetailPageState extends State<ComponentDetailPage> {
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

  Widget _narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout());

  Widget _wideLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: thirdSize),
      child: ListView(children: <Widget>[
        AppTopLeftButton(
            title: widget.component.type,
            callback: () => Navigator.of(context).pop()),
        UpdateBikeComponentForm(component: widget.component)
      ]));
}

class UpdateBikeComponentForm extends StatefulWidget {
  final Component component;
  const UpdateBikeComponentForm({Key? key, required this.component})
      : super(key: key);

  @override
  _UpdateBikeComponentFormState createState() =>
      _UpdateBikeComponentFormState();
}

class _UpdateBikeComponentFormState extends State<UpdateBikeComponentForm> {
  final ComponentService _componentService = ComponentService();
  final ComponentTypesService _componentTypesService = ComponentTypesService();

  final _keyForm = GlobalKey<FormState>();

  final _kmFocus = FocusNode();
  final TextEditingController _km = TextEditingController();

  final _brandFocus = FocusNode();
  final TextEditingController _brand = TextEditingController();

  final _durationFocus = FocusNode();
  final TextEditingController _duration = TextEditingController();

  final _imageFocus = FocusNode();
  final TextEditingController _image = TextEditingController();

  late Future<List<ComponentType>> _componentTypes;
  late String _dateOfPurchase;
  late String _typeValue;
  late String? _bikeValue;

  @override
  void initState() {
    super.initState();
    _componentTypes = _loadComponentTypes();
    _km.text = '${widget.component.km}';
    _brand.text = widget.component.brand ?? '';
    _duration.text = '${widget.component.duration}';
    _image.text = widget.component.image ?? '';
    _dateOfPurchase = widget.component.dateOfPurchase;
    _typeValue = widget.component.type;
    _bikeValue = widget.component.bikeId;
  }

  Future<List<ComponentType>> _loadComponentTypes() async {
    final Response response = await _componentTypesService.getTypes();

    if (response.statusCode == httpCodeOk) {
      return createComponentTypes(jsonDecode(response.body));
    } else {
      throw Exception('Impossible de récupérer les types de composants');
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(thirdSize),
      child: Form(
          key: _keyForm,
          child: Column(children: <Widget>[
            AppTextField(
                keyboardType: TextInputType.text,
                focusNode: _brandFocus,
                textfieldController: _brand,
                validator: emptyValidator,
                hintText: 'Marque du composant',
                label: 'Marque',
                icon: Icons.branding_watermark),
            AppTextField(
                keyboardType: TextInputType.number,
                focusNode: _kmFocus,
                textfieldController: _km,
                validator: kmValidator,
                hintText: 'Nombre de km du composant',
                label: 'Kilomètres',
                icon: Icons.add_road),
            AppTextField(
                keyboardType: TextInputType.number,
                focusNode: _durationFocus,
                textfieldController: _duration,
                validator: kmValidator,
                hintText: 'Durée de vie',
                label: 'Durée de vie du composant (km)',
                icon: Icons.health_and_safety),
            AppTextField(
                focusNode: _imageFocus,
                textfieldController: _image,
                validator: emptyValidator,
                hintText: "Lien de l'image",
                label: 'Image',
                icon: Icons.image,
                keyboardType: TextInputType.text),
            _buildComponentTypesDropdown(),
            AppCalendar(
                callback: _onDateChanged, selectedDate: _dateOfPurchase),
            AppButton(
                callback: _onUpdateComponent,
                text: 'Modifier',
                color: deepGreen,
                icon: const Icon(Icons.edit)),
          ])));

  Widget _buildComponentTypesDropdown() => FutureBuilder<List<ComponentType>>(
      future: _componentTypes,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          return DropdownButton(
              value: _typeValue,
              onChanged: (String? value) => setState(() => _typeValue = value!),
              items: snapshot.data!
                  .map<DropdownMenuItem<String>>((ComponentType componentType) {
                return DropdownMenuItem(
                    child: Text(componentType.name, style: secondTextStyle),
                    value: componentType.name);
              }).toList());
        }
        return const AppLoading();
      });

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _dateOfPurchase = args.value.toString().split(' ')[0];
  }

  void _onUpdateComponent() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateComponent();
    }
  }

  void _updateComponent() async {
    Response response = await _componentService.update(Component(
        widget.component.id,
        _bikeValue!,
        double.parse(_km.text),
        _brand.text,
        _dateOfPurchase,
        double.parse(_duration.text),
        _image.text,
        _typeValue));
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
}
