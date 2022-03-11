import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChangeComponentPage extends StatefulWidget {
  final Component component;
  const ChangeComponentPage({Key? key, required this.component})
      : super(key: key);

  @override
  _ChangeComponentPageState createState() => _ChangeComponentPageState();
}

class _ChangeComponentPageState extends State<ChangeComponentPage> {
  final _keyForm = GlobalKey<FormState>();
  final _kmFocus = FocusNode();
  final _km = TextEditingController();

  DateTime _changedDate = DateTime.now();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > maxWidth) {
            return _narrowLayout(context);
          } else {
            return _wideLayout();
          }
        }),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout());

  Widget _wideLayout() => Form(
        key: _keyForm,
        child: ListView(
          children: <Widget>[
            AppTopLeftButton(title: 'Changement de composant', callback: _back),
            Center(
              child: Padding(
                child: Text('Parcouru : ${widget.component.totalKm} km',
                    style: thirdTextStyle),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            AppTextField(
                focusNode: _kmFocus,
                textfieldController: _km,
                validator: (String? value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null ||
                      double.tryParse(value)! < 0 ||
                      double.parse(value) > widget.component.totalKm) {
                    return 'Saisie invalide';
                  }
                  return '';
                },
                hintText: 'Km parcourus avant le changement',
                label: 'Km parcourus avant le changement',
                icon: Icons.add_road,
                keyboardType: TextInputType.number),
            Padding(
              child: AppCalendar(
                  minDate: widget.component.changedAt,
                  callback: _onDateChanged,
                  selectedDate: _changedDate,
                  text: 'Date du changement',
                  visible: true),
              padding: const EdgeInsets.all(20),
            ),
            AppButton(
              text: 'Changer le composant',
              callback: _onChange,
              icon: const Icon(Icons.save),
            )
          ],
        ),
      );

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _changedDate = args.value;
  }

  void _back() => Navigator.pop(context);

  void _onChange() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _change();
    }
  }

  void _change() async {
    final HttpResponse response = await ComponentService().changeComponent(
        widget.component.id,
        _changedDate,
        widget.component.totalKm,
        double.parse(_km.text));

    if (response.success()) {
      Navigator.push(
          context, animationRightLeft(const MemberHomePage(initialPage: 0)));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message(),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: response.color(),
      ),
    );
  }
}
