import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/member/bike/bike_details.dart';
import 'package:bike_life/views/member/nav.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:flutter/material.dart';

class BikeSettingsPage extends StatelessWidget {
  final Bike bike;
  const BikeSettingsPage({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > maxWidth) {
              return _narrowLayout(context);
            } else {
              return _wideLayout(context);
            }
          },
        ),
      ));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => Column(
        children: <Widget>[
          UpdateBikeForm(bike: bike),
        ],
      );
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

  final _priceFocus = FocusNode();
  final _price = TextEditingController();

  final List<String> _types = ['VTT', 'Ville', 'Route'];

  late final bool _automatic;
  late final String? _type;

  @override
  void initState() {
    super.initState();
    _type = widget.bike.type;
    _kmWeek.text = '${widget.bike.kmPerWeek}';
    _name.text = widget.bike.name;
    _automatic = widget.bike.automaticKm;
    _price.text = widget.bike.price.toString();
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
              validator: (value) => lengthValidator(value, maxBikeName),
              label: 'Nom du vélo',
              icon: Icons.pedal_bike_outlined,
            ),
            AppTextField(
              keyboardType: TextInputType.number,
              focusNode: _kmWeekFocus,
              textfieldController: _kmWeek,
              validator: positiveValidator,
              label: 'Kilomètres par semaine',
              icon: Icons.add_road_outlined,
            ),
            AppTextField(
              keyboardType: TextInputType.number,
              focusNode: _priceFocus,
              textfieldController: _price,
              validator: positiveValidator,
              label: 'Prix du vélo',
              icon: Icons.euro_outlined,
            ),
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
                Text(
                  widget.bike.electric ? 'Oui' : 'Non',
                  style: thirdTextStyle,
                )
              ],
            ),
            _buildBikesTypes(),
            Text('Ajouté le : ${widget.bike.formatAddedDate()}',
                style: thirdTextStyle),
            AppButton(
                text: 'Enregistrer',
                callback: _onUpdate,
                icon: const Icon(Icons.save_outlined)),
            AppButton(
              text: 'Supprimer',
              callback: () => _showDeleteDialog(context),
              icon: const Icon(Icons.delete_outlined),
              color: Colors.red[900]!,
            )
          ],
        ),
      );

  Widget _buildBikesTypes() => Column(
        children: <Widget>[
          for (String type in _types)
            ListTile(
              title: InkWell(child: Text(type)),
              onTap: () {
                setState(() => _type = type);
              },
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
        widget.bike.totalKm,
        _automatic,
        double.parse(_price.text));
    final HttpResponse response = await BikeService().update(bike);

    if (response.success()) {
      doublePush(context, const MemberNav(), BikeDetailsPage(bike: bike));
      showSuccessSnackBar(context, response.message());
    } else {
      showErrorSnackBar(context, response.message());
    }
  }

  Future _showDeleteDialog(BuildContext context) async => await showDialog(
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
                  pushAndRemove(context, const MemberNav());
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
    final HttpResponse response = await BikeService().delete(widget.bike.id);

    if (response.success()) {
      pushAndRemove(context, const MemberNav());
      showSuccessSnackBar(context, response.message());
    } else {
      showErrorSnackBar(context, response.message());
    }
  }
}
