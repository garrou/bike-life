import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/top_left_button.dart';
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
  DateTime _changedDate = DateTime.now();

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
        AppTopLeftButton(title: 'Changement de composant', callback: _back),
        Padding(
            child: AppCalendar(
                callback: _onDateChanged,
                selectedDate: _changedDate,
                text: 'Date du changement',
                visible: true),
            padding: const EdgeInsets.all(20)),
        // TODO: add ref of component
        AppButton(
            text: 'Changer le composant',
            callback: _change,
            icon: const Icon(Icons.save))
      ]);

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _changedDate = args.value;
  }

  void _back() => Navigator.push(
      context, animationRightLeft(const MemberHomePage(initialPage: 0)));

  void _change() async {
    final ComponentService componentService = ComponentService();
    final HttpResponse response = await componentService.changeComponent(
        widget.component.id, _changedDate);

    if (response.success()) {
      Navigator.push(
          context, animationRightLeft(const MemberHomePage(initialPage: 0)));
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message()), backgroundColor: response.color()));
  }
}
