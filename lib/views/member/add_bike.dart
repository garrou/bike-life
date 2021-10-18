import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/routes/member_argument.dart';
import 'package:bike_life/routes/member_home_route.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/top_left_button.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddBikePage extends StatelessWidget {
  final Member member;
  const AddBikePage({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > maxSize) {
        return narrowLayout();
      } else {
        return wideLayout();
      }
    }));
  }

  Widget narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }

  Widget wideLayout() {
    return SingleChildScrollView(
        child: Column(children: <Widget>[AddBikeForm(member: member)]));
  }
}

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

  final _descriptionFocus = FocusNode();
  final _description = TextEditingController();

  final _imageFocus = FocusNode();
  final _image = TextEditingController();

  String _dateOfPurchase = DateTime.now().toString().split(' ')[0];

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _keyForm,
        child: Padding(
            padding: const EdgeInsets.all(thirdSize),
            child: Column(children: <Widget>[
              AppTopLeftButton(
                  callback: () => Navigator.pushNamed(
                      context, MemberHomeRoute.routeName,
                      arguments: MemberArgument(widget.member))),
              AppTextField(
                  focusNode: _nameFocus,
                  textfieldController: _name,
                  validator: fieldValidator,
                  hintText: 'Entrer un nom de vélo',
                  label: 'Nom du vélo',
                  obscureText: false,
                  icon: Icons.pedal_bike,
                  maxLines: 1),
              AppTextField(
                  focusNode: _descriptionFocus,
                  textfieldController: _description,
                  validator: fieldValidator,
                  hintText: 'Entrer une description valide',
                  label: 'Description du vélo',
                  obscureText: false,
                  icon: Icons.article,
                  maxLines: 8),
              AppTextField(
                  focusNode: _imageFocus,
                  textfieldController: _image,
                  validator: fieldValidator,
                  hintText: "Lien de l'image du vélo",
                  label: 'Image du vélo',
                  obscureText: false,
                  icon: Icons.image,
                  maxLines: 1),
              Text("Date d'achat", style: secondTextStyle),
              SfDateRangePicker(
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.single,
                  onSelectionChanged: _onDateChanged),
              AppButton(text: 'Ajouter', callback: _onAddBike, color: mainColor)
            ])));
  }

  void _onAddBike() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _addBike(_name.text, _description.text, _image.text, _dateOfPurchase);
    }
  }

  void _addBike(String name, String description, String image,
      String dateOfPurchase) async {
    BikeRepository bikeRepository = BikeRepository();
    List<dynamic> response = await bikeRepository.addBike(
        widget.member.id, name, description, image, dateOfPurchase);
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
