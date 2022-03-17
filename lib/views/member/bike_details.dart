import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/widgets/click_region.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:bike_life/widgets/buttons/top_right_button.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:flutter/material.dart';

class BikeDetails extends StatelessWidget {
  final Bike bike;
  const BikeDetails({Key? key, required this.bike}) : super(key: key);

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
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AppTopLeftButton(
                  title: 'Détails', callback: () => _back(context)),
              AppTopRightButton(
                  onPressed: () => _showDeleteDialog(context),
                  icon: const Icon(Icons.delete, color: red),
                  padding: secondSize)
            ],
          ),
          UpdateBikeForm(bike: bike)
        ],
      );

  Future _showDeleteDialog(BuildContext context) async => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(secondSize)),
          title: const Text('Supprimer ce vélo ?'),
          content: const Text(
              'La suppression de ce vélo entrainera la suppression de toutes les données liées à celui-ci'),
          actions: <Widget>[
            TextButton(
                child: const Text('Confirmer', style: TextStyle(color: red)),
                onPressed: () {
                  _onDelete(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      animationRightLeft(const MemberHomePage(initialPage: 0)),
                      (Route<dynamic> route) => false);
                }),
            TextButton(
              child:
                  const Text('Annuler', style: TextStyle(color: primaryColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );

  _onDelete(BuildContext context) async {
    final HttpResponse response = await BikeService().delete(bike.id);

    if (response.success()) {
      Navigator.pushAndRemoveUntil(
          context,
          animationRightLeft(const MemberHomePage(initialPage: 0)),
          (Route<dynamic> route) => false);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message(),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: response.color()));
  }

  void _back(BuildContext context) => Navigator.of(context).pop();
}

class UpdateBikeForm extends StatefulWidget {
  final Bike bike;
  const UpdateBikeForm({Key? key, required this.bike}) : super(key: key);

  @override
  _UpdateBikeFormState createState() => _UpdateBikeFormState();
}

class _UpdateBikeFormState extends State<UpdateBikeForm> {
  final _keyForm = GlobalKey<FormState>();

  final _nameFocus = FocusNode();
  final _name = TextEditingController();

  final _kmWeekFocus = FocusNode();
  final _kmWeek = TextEditingController();

  final _kmRealisedFocus = FocusNode();
  final _kmRealised = TextEditingController();

  final List<String> _types = ['VTT', 'Ville', 'Route'];

  late bool _automatic;
  late String? _type;

  @override
  void initState() {
    super.initState();
    _type = widget.bike.type;
    _kmWeek.text = '${widget.bike.kmPerWeek}';
    _name.text = widget.bike.name;
    _automatic = widget.bike.automaticKm;
    _kmRealised.text = widget.bike.formatKm();
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _keyForm,
        child: Column(
          children: <Widget>[
            AppTextField(
                keyboardType: TextInputType.text,
                focusNode: _nameFocus,
                textfieldController: _name,
                validator: lengthValidator,
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
            widget.bike.automaticKm
                ? Container()
                : AppTextField(
                    keyboardType: TextInputType.number,
                    focusNode: _kmRealisedFocus,
                    textfieldController: _kmRealised,
                    validator: kmValidator,
                    hintText: 'Kilomètres réalisés',
                    label: 'Kilomètres réalisés',
                    icon: Icons.add_road),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('Ajout automatique des kilomètres', style: thirdTextStyle),
              Switch(
                  activeColor: primaryColor,
                  value: _automatic,
                  onChanged: (bool value) {
                    setState(() => _automatic = value);
                  }),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Electrique', style: thirdTextStyle),
                Icon(
                  widget.bike.electric ? Icons.toggle_on : Icons.toggle_off,
                  size: 40,
                )
              ],
            ),
            _buildBikesTypes(),
            Text('Ajouté le : ${widget.bike.formatAddedDate()}',
                style: thirdTextStyle),
            AppButton(
                text: 'Enregistrer',
                callback: _onUpdate,
                icon: const Icon(Icons.save))
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

  void _onUpdate() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _update();
    }
  }

  void _update() async {
    final Bike bike = Bike(
        widget.bike.id,
        _name.text,
        double.parse(_kmWeek.text),
        widget.bike.electric,
        _type!,
        widget.bike.addedAt,
        widget.bike.automaticKm
            ? widget.bike.totalKm
            : double.parse(_kmRealised.text),
        _automatic);
    final HttpResponse response = await BikeService().update(bike);

    if (response.success()) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const MemberHomePage(initialPage: 0)),
          (Route<dynamic> route) => false);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message(),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: response.color()));
  }
}
