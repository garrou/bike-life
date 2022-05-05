import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/models/repair.dart';
import 'package:bike_life/services/repair_service.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/member/bike/components/component_details.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:bike_life/widgets/calendar.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ComponentRepairPage extends StatefulWidget {
  final Component component;
  final Bike bike;
  const ComponentRepairPage(
      {Key? key, required this.component, required this.bike})
      : super(key: key);

  @override
  State<ComponentRepairPage> createState() => _ComponentRepairPageState();
}

class _ComponentRepairPageState extends State<ComponentRepairPage> {
  final _keyForm = GlobalKey<FormState>();

  final _reasonFocus = FocusNode();
  final _reason = TextEditingController();

  final _priceFocus = FocusNode();
  final _price = TextEditingController();

  DateTime _repairDate = DateTime.now();

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
            AppTopLeftButton(title: 'Réparation du composant', callback: _back),
            AppTextField(
                keyboardType: TextInputType.text,
                focusNode: _reasonFocus,
                textfieldController: _reason,
                validator: (value) => lengthValidator(value, 1000),
                label: 'Raison de la réparation',
                icon: Icons.text_fields,
                maxLines: 10),
            AppTextField(
                keyboardType: TextInputType.number,
                focusNode: _priceFocus,
                textfieldController: _price,
                validator: positiveValidator,
                label: 'Prix de la réparation',
                icon: Icons.euro),
            Padding(
              child: AppCalendar(
                  minDate: widget.bike.addedAt,
                  callback: _onDateChanged,
                  selectedDate: _repairDate,
                  text: 'Date de la réparation',
                  visible: true),
              padding: const EdgeInsets.all(10),
            ),
            AppButton(
              text: 'Enregistrer',
              callback: _onAddRepair,
              icon: const Icon(Icons.save),
            )
          ],
        ),
      );

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _repairDate = args.value;
  }

  void _back() => Navigator.pop(context);

  void _onAddRepair() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _addRepair();
    }
  }

  void _addRepair() async {
    final Repair repair = Repair(0, _repairDate, _reason.text,
        double.parse(_price.text), widget.component.id);
    final HttpResponse response = await RepairService().addRepair(repair);

    if (response.success()) {
      doublePush(context, const MemberHomePage(),
          ComponentDetailsPage(component: widget.component, bike: widget.bike));
      showSuccessSnackBar(context, response.message());
    } else {
      showErrorSnackBar(context, response.message());
    }
  }
}
