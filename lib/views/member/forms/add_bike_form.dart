import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/routes/args/member_argument.dart';
import 'package:bike_life/routes/member_home_route.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:bike_life/views/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddBikeForm extends StatefulWidget {
  final Member member;
  const AddBikeForm({Key? key, required this.member}) : super(key: key);

  @override
  _AddBikeFormState createState() => _AddBikeFormState();
}

class _AddBikeFormState extends State<AddBikeForm> {
  final _keyForm = GlobalKey<FormState>();

  final _nameFocus = FocusNode();
  final _name = TextEditingController();

  final _imageFocus = FocusNode();
  final _image = TextEditingController();

  final _nbKmFocus = FocusNode();
  final _nbKm = TextEditingController();

  String _dateOfPurchase = DateTime.now().toString().split(' ')[0];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            AppTopLeftButton(
                title: 'Ajouter un vélo',
                callback: () => Navigator.pushNamed(
                    context, MemberHomeRoute.routeName,
                    arguments: MemberArgument(widget.member))),
          ]),
          Form(
              key: _keyForm,
              child: Column(children: <Widget>[
                AppTextField(
                    focusNode: _nameFocus,
                    textfieldController: _name,
                    validator: fieldValidator,
                    hintText: 'Entrer un nom de vélo',
                    label: 'Nom du vélo',
                    icon: Icons.pedal_bike),
                AppTextField(
                    focusNode: _imageFocus,
                    textfieldController: _image,
                    validator: fieldValidator,
                    hintText: "Lien de l'image du vélo",
                    label: 'Image du vélo',
                    icon: Icons.image),
                AppTextField(
                    focusNode: _nbKmFocus,
                    textfieldController: _nbKm,
                    validator: kmValidator,
                    hintText: 'Nombre de kilomètres du vélo',
                    label: 'Nombre de km',
                    icon: Icons.add_road),
                Padding(
                    padding: const EdgeInsets.only(top: thirdSize),
                    child: Text("Date d'achat", style: secondTextStyle)),
                SfDateRangePicker(
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.single,
                    onSelectionChanged: _onDateChanged),
                AppButton(
                    text: 'Ajouter', callback: _onAddBike, color: mainColor)
              ]))
        ]));
  }

  void _onAddBike() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _addBike(_name.text, _image.text, _dateOfPurchase, _nbKm.text);
    }
  }

  void _addBike(
      String name, String image, String dateOfPurchase, String nbKm) async {
    BikeRepository bikeRepository = BikeRepository();
    List<dynamic> response = await bikeRepository.addBike(widget.member.id,
        name, image, dateOfPurchase, double.parse(nbKm.replaceAll(",", ".")));
    bool created = response[0];
    dynamic jsonResponse = response[1];

    if (created) {
      Navigator.pushNamed(context, MemberHomeRoute.routeName,
          arguments: MemberArgument(widget.member));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse['confirm']),
          backgroundColor: Theme.of(context).primaryColor));
    }
  }

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _dateOfPurchase = args.value.toString().split(' ')[0];
  }
}
