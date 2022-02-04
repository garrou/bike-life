import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:bike_life/widgets/top_right_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateBikePage extends StatefulWidget {
  final Bike bike;
  const UpdateBikePage({Key? key, required this.bike}) : super(key: key);

  @override
  _UpdateBikePageState createState() => _UpdateBikePageState();
}

class _UpdateBikePageState extends State<UpdateBikePage> {
  final BikeService _bikeService = BikeService();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final FocusNode _nameFocus = FocusNode();
  final TextEditingController _name = TextEditingController();

  final FocusNode _kmWeekFocus = FocusNode();
  final TextEditingController _kmWeek = TextEditingController();
  final List<String> _bikeTypes = ['VTT', 'Ville', 'Route'];

  bool? _electric;
  String? _bikeType;
  int? _nbPerWeek;

  @override
  void initState() {
    super.initState();
    _electric = widget.bike.electric;
    _bikeType = widget.bike.type;
    _nbPerWeek = widget.bike.nbUsedPerWeek;
    _name.text = widget.bike.name;
    _kmWeek.text = '${widget.bike.kmPerWeek}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > maxSize) {
            return _narrowLayout();
          } else {
            return _wideLayout();
          }
        }),
        floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            child: const Icon(Icons.save),
            onPressed: _onUpdate));
  }

  Widget _narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout());

  Widget _wideLayout() => Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          AppTopLeftButton(title: widget.bike.name, callback: _back),
          AppTopRightButton(
              callback: _onDelete,
              icon: const Icon(Icons.delete, color: red),
              padding: secondSize)
        ]),
        _buildForm()
      ]);

  Form _buildForm() => Form(
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
        Padding(
            padding: const EdgeInsets.all(thirdSize),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(50)),
                child: Column(children: <Widget>[
                  _buildRow(
                      'Utilisation par semaine',
                      DropdownButton<int>(
                          value: _nbPerWeek,
                          onChanged: (int? value) =>
                              setState(() => _nbPerWeek = value!),
                          items: List.generate(7, (index) => index + 1)
                              .map<DropdownMenuItem<int>>((int day) =>
                                  DropdownMenuItem(
                                      child: Padding(
                                          child: Text('$day',
                                              style: secondTextStyle),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20)),
                                      value: day))
                              .toList())),
                  _buildRow(
                      'Vélo électrique',
                      Checkbox(
                          fillColor: MaterialStateProperty.all(primaryColor),
                          value: _electric,
                          onChanged: (bool? value) {
                            setState(() => _electric = value);
                          })),
                  _buildRow(
                      'Type de vélo',
                      DropdownButton<String>(
                          value: _bikeType,
                          onChanged: (String? value) =>
                              setState(() => _bikeType = value!),
                          items: _bikeTypes
                              .map<DropdownMenuItem<String>>((String type) =>
                                  DropdownMenuItem(
                                      child: Padding(
                                          child: Text(type,
                                              style: secondTextStyle),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20)),
                                      value: type))
                              .toList()))
                ])))
      ]));

  Widget _buildRow(String field, Widget widget) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Padding(
            child: Text(field, style: secondTextStyle),
            padding: const EdgeInsets.only(right: secondSize)),
        widget
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
        _nbPerWeek!,
        _electric!,
        _bikeType!,
        widget.bike.addedAt);
    Response response = await _bikeService.update(bike);
    HttpResponse httpResponse = HttpResponse(response);

    if (httpResponse.success()) {
      _onMemberHomePage();
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(httpResponse.message()),
        backgroundColor: httpResponse.color()));
  }

  _onDelete() async {
    Response response = await _bikeService.delete(widget.bike.id);
    HttpResponse httpResponse = HttpResponse(response);

    if (httpResponse.success()) {
      _onMemberHomePage();
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(httpResponse.message()),
        backgroundColor: httpResponse.color()));
  }

  void _onMemberHomePage() => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const MemberHomePage(initialPage: 0)),
      (Route<dynamic> route) => false);

  void _back() => Navigator.of(context).pop();
}
