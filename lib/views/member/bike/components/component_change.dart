import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/component_change.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/bike/bike_details.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChangeComponentPage extends StatefulWidget {
  final Component component;
  final Bike bike;
  const ChangeComponentPage(
      {Key? key, required this.component, required this.bike})
      : super(key: key);

  @override
  _ChangeComponentPageState createState() => _ChangeComponentPageState();
}

class _ChangeComponentPageState extends State<ChangeComponentPage> {
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

  Widget _wideLayout() => ListView(
        children: <Widget>[
          if (!isWeb)
            AppTopLeftButton(title: 'Changement de composant', callback: _back),
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
            callback: _change,
            icon: const Icon(Icons.save),
          )
        ],
      );

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _changedDate = args.value;
  }

  void _back() => Navigator.pop(context);

  void _change() async {
    final HttpResponse response = await ComponentService().changeComponent(
        widget.component.id,
        ComponentChange(_changedDate, widget.component.totalKm,
            widget.component.price, widget.component.brand));

    if (response.success()) {
      Navigator.pushAndRemoveUntil(context,
          animationRightLeft(const MemberHomePage()), (route) => false);
      Navigator.push(
          context, animationRightLeft(BikeDetailsPage(bike: widget.bike)));

      showSuccessSnackBar(context, response.message());
    } else {
      showErrorSnackBar(context, response.message());
    }
  }
}
