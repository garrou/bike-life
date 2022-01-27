import 'dart:async';
import 'dart:convert';

import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component_type.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/services/component_types_service.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/storage.dart';
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
        // AppNetworkImage(
        //     image: widget.component.image!, progressColor: deepGreen),
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
  final BikeService _bikeService = BikeService();
  final _keyForm = GlobalKey<FormState>();

  final _kmFocus = FocusNode();
  final TextEditingController _km = TextEditingController();

  final _brandFocus = FocusNode();
  final TextEditingController _brand = TextEditingController();

  final _durationFocus = FocusNode();
  final TextEditingController _duration = TextEditingController();

  final _imageFocus = FocusNode();
  final TextEditingController _image = TextEditingController();

  late Future<List<Bike>> _bikes;
  late Future<List<ComponentType>> _componentTypes;
  late String _dateOfPurchase;
  late String _typeValue;
  String? _bikeValue;

  @override
  void initState() {
    super.initState();
    _componentTypes = _loadComponentTypes();
    _bikes = _loadBikes();
    _km.text = '${widget.component.km}';
    _brand.text = widget.component.brand ?? '';
    _duration.text = '${widget.component.duration}';
    _image.text = widget.component.image ?? '';
    _dateOfPurchase = widget.component.dateOfPurchase;
    _typeValue = widget.component.type;
  }

  Future<List<ComponentType>> _loadComponentTypes() async {
    final Response response = await _componentTypesService.getTypes();

    if (response.statusCode == httpCodeOk) {
      return createComponentTypes(jsonDecode(response.body));
    } else {
      throw Exception('Impossible de récupérer les types de composants');
    }
  }

  Future<List<Bike>> _loadBikes() async {
    final String id = await Storage.getMemberId();
    final Response response = await _bikeService.getBikes(id);

    if (response.statusCode == httpCodeOk) {
      return createBikes(jsonDecode(response.body));
    } else {
      throw Exception('Impossible de récupérer les vélos');
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
            _buildBikesDropdown(),
            _buildComponentTypesDropdown(),
            AppCalendar(
                callback: _onDateChanged, selectedDate: _dateOfPurchase),
            AppButton(
                callback: _onUpdateComponent,
                text: 'Modifier',
                color: deepGreen),
            AppButton(
                callback: _onArchiveComponent, text: 'Archiver', color: red),
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

  Widget _buildBikesDropdown() => Visibility(
      visible: widget.component.archived,
      child: FutureBuilder<List<Bike>>(
          future: _bikes,
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              return DropdownButton(
                  value: _bikeValue ??
                      snapshot.data!
                          .firstWhere(
                              (bike) => bike.id == widget.component.bikeId)
                          .id,
                  onChanged: (String? value) =>
                      setState(() => _bikeValue = value!),
                  items: snapshot.data!
                      .map<DropdownMenuItem<String>>((Bike bike) =>
                          DropdownMenuItem(
                              child: Text(bike.name, style: secondTextStyle),
                              value: bike.id))
                      .toList());
            }
            return const AppLoading();
          }));

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _dateOfPurchase = args.value.toString().split(' ')[0];
  }

  void _onUpdateComponent() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateComponent(widget.component.archived);
    }
  }

  void _onArchiveComponent() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateComponent(!widget.component.archived);
    }
  }

  void _updateComponent(bool archived) async {
    Response response = await _componentService.update(Component(
        widget.component.id,
        widget.component.bikeId,
        double.parse(_km.text),
        _brand.text,
        _dateOfPurchase,
        double.parse(_duration.text),
        _image.text,
        _typeValue,
        archived));
    Color responseColor = deepGreen;
    dynamic json = jsonDecode(response.body);

    if (response.statusCode == httpCodeOk) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const MemberHomePage(initialPage: 0)),
          (Route<dynamic> route) => false);
    } else {
      responseColor = red;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(json['confirm']), backgroundColor: responseColor));
  }
}
