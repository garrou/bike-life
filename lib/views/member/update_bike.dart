import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:bike_life/widgets/top_right_button.dart';
import 'package:flutter/material.dart';

class UpdateBikePage extends StatefulWidget {
  final Bike bike;
  const UpdateBikePage({Key? key, required this.bike}) : super(key: key);

  @override
  _UpdateBikePageState createState() => _UpdateBikePageState();
}

class _UpdateBikePageState extends State<UpdateBikePage> {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidth) {
          return _narrowLayout(context);
        } else {
          return _wideLayout();
        }
      }));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout());

  Widget _wideLayout() => ListView(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          AppTopLeftButton(title: widget.bike.name, callback: _back),
          AppTopRightButton(
              callback: _onDelete,
              icon: const Icon(Icons.delete, color: red),
              padding: secondSize)
        ]),
        UpdateBikeForm(bike: widget.bike)
      ]);

  _onDelete() async {
    final BikeService bikeService = BikeService();
    final HttpResponse response = await bikeService.delete(widget.bike.id);

    if (response.success()) {
      Navigator.pushAndRemoveUntil(
          context,
          animationRightLeft(const MemberHomePage(initialPage: 0)),
          (Route<dynamic> route) => false);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message()), backgroundColor: response.color()));
  }

  void _back() => Navigator.of(context).pop();
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
  final _name = TextEditingController();

  final _kmWeekFocus = FocusNode();
  final _kmWeek = TextEditingController();

  final List<String> _types = ['VTT', 'Ville', 'Route'];

  late int _nbPerWeek;
  late bool? _electric;
  late String? _type;

  @override
  void initState() {
    super.initState();
    _type = widget.bike.type;
    _nbPerWeek = widget.bike.nbUsedPerWeek;
    _electric = widget.bike.electric;
    _kmWeek.text = '${widget.bike.kmPerWeek}';
    _name.text = widget.bike.name;
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
            hintText: 'Nom du vélo',
            label: 'Nom du vélo',
            icon: Icons.pedal_bike),
        AppTextField(
            keyboardType: TextInputType.number,
            focusNode: _kmWeekFocus,
            textfieldController: _kmWeek,
            validator: kmValidator,
            hintText: 'Kilomètres par semaine',
            label: 'Kilomètres par semaine',
            icon: Icons.image),
        Text('Utilisation par semaine', style: secondTextStyle),
        Slider(
            value: _nbPerWeek.toDouble(),
            thumbColor: primaryColor,
            activeColor: primaryColor,
            inactiveColor: const Color.fromARGB(255, 156, 156, 156),
            min: 1,
            max: 7,
            divisions: 6,
            label: '$_nbPerWeek',
            onChanged: (rating) {
              setState(() => _nbPerWeek = rating.toInt());
            }),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('Electrique', style: secondTextStyle),
          Checkbox(
              fillColor: MaterialStateProperty.all(primaryColor),
              value: _electric,
              onChanged: (bool? value) {
                setState(() => _electric = value);
              }),
        ]),
        _buildBikesTypes(),
        AppButton(
            text: 'Modifier', callback: _onUpdate, icon: const Icon(Icons.save))
      ]));

  Widget _buildBikesTypes() => Column(children: <Widget>[
        for (String type in _types)
          ListTile(
              title: GestureDetector(
                  child: MouseRegion(
                      child: Text(type), cursor: SystemMouseCursors.click),
                  onTap: () {
                    setState(() => _type = type);
                  }),
              leading: Radio<String>(
                  activeColor: primaryColor,
                  value: type,
                  groupValue: _type,
                  onChanged: (String? value) {
                    setState(() => _type = value);
                  }))
      ]);

  void _onUpdate() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _update();
    }
  }

  void _update() async {
    final Bike bike = Bike(
        widget.bike.id,
        _name.text,
        double.parse(_kmWeek.text),
        _nbPerWeek,
        _electric!,
        _type!,
        widget.bike.addedAt);
    final BikeService bikeService = BikeService();
    final HttpResponse response = await bikeService.update(bike);

    if (response.success()) {
      Navigator.pushAndRemoveUntil(
          context,
          animationRightLeft(const MemberHomePage(initialPage: 0)),
          (Route<dynamic> route) => false);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message()), backgroundColor: response.color()));
  }
}
