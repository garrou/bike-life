import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/component_change.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/bike/bike_details.dart';
import 'package:bike_life/views/member/home.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ComponentChangePage extends StatefulWidget {
  final Component component;
  final Bike bike;
  const ComponentChangePage(
      {Key? key, required this.component, required this.bike})
      : super(key: key);

  @override
  _ComponentChangePageState createState() => _ComponentChangePageState();
}

class _ComponentChangePageState extends State<ComponentChangePage> {
  DateTime _changedDate = DateTime.now();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Changement pour ${widget.component.type.toLowerCase()}",
              style: secondTextStyle),
        ),
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
          Padding(
            child: AppCalendar(
                minDate: widget.component.changedAt,
                callback: _onDateChanged,
                selectedDate: _changedDate,
                text: 'Date du changement',
                visible: true),
            padding: const EdgeInsets.all(10),
          ),
          AppButton(
            text: 'Enregistrer',
            callback: () => _showChangeDialog(context),
            icon: const Icon(Icons.save_outlined),
          )
        ],
      );

  Future _showChangeDialog(BuildContext context) async => await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(secondSize)),
          title: const Text('Petit rappel'),
          content: const Text(
              "Pensez à modifier la marque et le prix du composant que vous allez changer dans l'onglet paramètres du composant."),
          actions: <Widget>[
            TextButton(
              child: const Text('Changer le composant',
                  style: TextStyle(color: primaryColor)),
              onPressed: _change,
            )
          ],
        ),
      );

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _changedDate = args.value;
  }

  void _change() async {
    final HttpResponse response = await ComponentService().changeComponent(
        widget.component.id,
        ComponentChange(_changedDate, widget.component.totalKm,
            widget.component.price, widget.component.brand));

    if (response.success()) {
      doublePush(
          context, const MemberHomePage(), BikeDetailsPage(bike: widget.bike));
      showSuccessSnackBar(context, response.message());
    } else {
      showErrorSnackBar(context, response.message());
    }
  }
}
