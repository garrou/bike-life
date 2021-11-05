import 'package:bike_life/models/bike.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/calendar.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UpdateBikeForm extends StatefulWidget {
  final Bike bike;
  const UpdateBikeForm({Key? key, required this.bike}) : super(key: key);

  @override
  _UpdateBikeFormState createState() => _UpdateBikeFormState();
}

class _UpdateBikeFormState extends State<UpdateBikeForm> {
  final _keyForm = GlobalKey<FormState>();

  final _nameFocus = FocusNode();
  late final TextEditingController _name;

  final _imageFocus = FocusNode();
  late final TextEditingController _image;

  final _nbKmFocus = FocusNode();
  late final TextEditingController _nbKm;

  final BikeRepository _bikeRepository = BikeRepository();

  late String _dateOfPurchase;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.bike.name);
    _image = TextEditingController(text: widget.bike.image);
    _nbKm = TextEditingController(text: '${widget.bike.nbKm}');
    _dateOfPurchase = widget.bike.dateOfPurchase.split(' ')[0];
  }

  @override
  Widget build(BuildContext context) => Form(
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
        AppCalendar(callback: _onDateChanged, selectedDate: _dateOfPurchase),
        AppButton(text: 'Modifier', callback: _onUpdateBike, color: mainColor)
      ]));

  void _onUpdateBike() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateBike(_name.text, _image.text, _nbKm.text, _dateOfPurchase);
    }
  }

  void _updateBike(
      String name, String image, String dateOfPurchase, String nbKm) async {
    List<dynamic> response = await _bikeRepository.updateBike(
        Bike(widget.bike.id, name, image, int.parse(nbKm), dateOfPurchase));
    bool isUpdated = response[0];
    dynamic jsonResponse = response[1];

    if (isUpdated) {
      Navigator.of(context).pop();
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(jsonResponse['confirm'])));
  }

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    _dateOfPurchase = args.value.toString().split(' ')[0];
  }
}
