import 'package:bike_life/constants.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/calendar.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:bike_life/views/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddBikeForm extends StatefulWidget {
  const AddBikeForm({Key? key}) : super(key: key);

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

  final BikeRepository _bikeRepository = BikeRepository();

  String _dateOfPurchase = DateTime.now().toString().split(' ')[0];

  late int _memberId;

  @override
  void initState() {
    super.initState();
    _getMemberId();
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(thirdSize),
      child: Column(children: <Widget>[
        Row(children: <Widget>[
          AppTopLeftButton(
              title: 'Ajouter un vélo',
              callback: () => Navigator.pushNamed(context, '/home'))
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
              AppCalendar(
                  callback: _onDateChanged, selectedDate: _dateOfPurchase),
              AppButton(text: 'Ajouter', callback: _onAddBike, color: mainColor)
            ]))
      ]));

  void _getMemberId() async {
    _memberId = await Storage.getMemberId();
  }

  void _onAddBike() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _addBike(_name.text, _image.text, _dateOfPurchase, _nbKm.text);
    }
  }

  void _addBike(
      String name, String image, String dateOfPurchase, String nbKm) async {
    List<dynamic> response = await _bikeRepository.addBike(
        _memberId, name, image, dateOfPurchase, int.parse(nbKm));

    if (response[0]) {
      Navigator.pushNamed(context, '/home');
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response[1]['confirm']), backgroundColor: mainColor));
  }

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _dateOfPurchase = args.value.toString().split(' ')[0];
  }
}
