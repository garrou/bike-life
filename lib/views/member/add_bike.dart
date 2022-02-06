import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddBikePage extends StatefulWidget {
  const AddBikePage({Key? key}) : super(key: key);

  @override
  _AddBikePageState createState() => _AddBikePageState();
}

class _AddBikePageState extends State<AddBikePage> {
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
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout());

  Widget _wideLayout() =>
      ListView(padding: const EdgeInsets.all(thirdSize), children: <Widget>[
        Row(children: <Widget>[
          AppTopLeftButton(
              title: 'Ajouter un vélo', callback: () => Navigator.pop(context))
        ]),
        const AddBikeForm()
      ]);
}

class AddBikeForm extends StatefulWidget {
  const AddBikeForm({Key? key}) : super(key: key);

  @override
  _AddBikeFormState createState() => _AddBikeFormState();
}

class _AddBikeFormState extends State<AddBikeForm> {
  final _keyForm = GlobalKey<FormState>();

  final _nameFocus = FocusNode();
  final _name = TextEditingController();

  final _kmWeekFocus = FocusNode();
  final _kmWeek = TextEditingController();

  final BikeService _bikeService = BikeService();
  final List<String> _types = ['VTT', 'Ville', 'Route'];

  DateTime _dateOfPurchase = DateTime.now();
  double _nbPerWeek = 1;
  bool? _electric = false;
  String? _type;

  @override
  void initState() {
    super.initState();
    _type = _types.first;
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
            value: _nbPerWeek,
            thumbColor: primaryColor,
            activeColor: primaryColor,
            inactiveColor: const Color.fromARGB(255, 156, 156, 156),
            min: 1,
            max: 7,
            divisions: 6,
            label: '$_nbPerWeek',
            onChanged: (rating) {
              setState(() => _nbPerWeek = rating);
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
        AppCalendar(callback: _onDateChanged, selectedDate: _dateOfPurchase),
        AppButton(
            text: 'Ajouter',
            callback: _onAddBike,
            color: primaryColor,
            icon: const Icon(Icons.add))
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

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _dateOfPurchase = args.value;
  }

  void _onAddBike() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _addBike();
    }
  }

  void _addBike() async {
    final String memberId = await Storage.getMemberId();
    final Bike bike = Bike('', _name.text, double.parse(_kmWeek.text),
        _nbPerWeek.toInt(), _electric!, _type!, _dateOfPurchase);
    final HttpResponse response = await _bikeService.create(memberId, bike);

    if (response.success()) {
      _onMemberHomePage();
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message()), backgroundColor: response.color()));
  }

  void _onMemberHomePage() => Navigator.pushAndRemoveUntil(
      context,
      animationRightLeft(const MemberHomePage(initialPage: 0)),
      (Route<dynamic> route) => false);
}
