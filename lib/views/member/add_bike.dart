import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/widgets/click_region.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddBikePage extends StatelessWidget {
  const AddBikePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > maxWidth) {
            return _narrowLayout(context);
          } else {
            return _wideLayout(context);
          }
        }),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: thirdSize),
        children: <Widget>[
          AppTopLeftButton(
              title: 'Ajouter un vélo', callback: () => Navigator.pop(context)),
          const AddBikeForm()
        ],
      );
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

  final _kmRealisedFocus = FocusNode();
  final _kmRealised = TextEditingController();

  final List<String> _types = ['VTT', 'Ville', 'Route'];

  DateTime _dateOfPurchase = DateTime.now();
  bool _electric = false;
  bool _automatic = true;
  String? _type = 'VTT';

  @override
  Widget build(BuildContext context) => Form(
        key: _keyForm,
        child: ListView(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
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
                icon: Icons.add_road),
            AppTextField(
                keyboardType: TextInputType.number,
                focusNode: _kmRealisedFocus,
                textfieldController: _kmRealised,
                validator: kmValidator,
                hintText: 'Kilomètres réalisés',
                label: 'Kilomètres réalisés',
                icon: Icons.add_road),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('Ajout quotidien des km ?', style: thirdTextStyle),
              Switch(
                  activeColor: primaryColor,
                  value: _automatic,
                  onChanged: (bool value) {
                    setState(() => _automatic = value);
                  }),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('Electrique', style: thirdTextStyle),
              Switch(
                  activeColor: primaryColor,
                  value: _electric,
                  onChanged: (bool value) {
                    setState(() => _electric = value);
                  }),
            ]),
            _buildBikesTypes(),
            AppCalendar(
                minDate: DateTime(1900),
                callback: _onDateChanged,
                selectedDate: _dateOfPurchase,
                text: "Date d'ajout"),
            AppButton(
                text: 'Ajouter',
                callback: _onAddBike,
                icon: const Icon(Icons.add))
          ],
        ),
      );

  Widget _buildBikesTypes() => Column(
        children: <Widget>[
          for (String type in _types)
            ListTile(
              title: GestureDetector(
                  child: AppClickRegion(child: Text(type)),
                  onTap: () {
                    setState(() => _type = type);
                  }),
              leading: Radio<String>(
                  activeColor: primaryColor,
                  value: type,
                  groupValue: _type,
                  onChanged: (String? value) {
                    setState(() => _type = value);
                  }),
            )
        ],
      );

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
    final Bike bike = Bike(
        '',
        _name.text,
        double.parse(_kmWeek.text),
        _electric,
        _type!,
        _dateOfPurchase,
        double.parse(_kmRealised.text),
        _automatic);
    final HttpResponse response = await BikeService().create(memberId, bike);

    if (response.success()) {
      _onMemberHomePage();
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message(),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: response.color()));
  }

  void _onMemberHomePage() => Navigator.pushAndRemoveUntil(
      context,
      animationRightLeft(const MemberHomePage(initialPage: 0)),
      (Route<dynamic> route) => false);
}
