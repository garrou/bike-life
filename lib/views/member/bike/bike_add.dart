import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:flutter/material.dart';

class AddBikePage extends StatelessWidget {
  const AddBikePage({Key? key}) : super(key: key);

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
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: thirdSize),
        children: <Widget>[
          if (!isWeb)
            AppTopLeftButton(
                title: 'Ajouter un vélo',
                callback: () => Navigator.pop(context)),
          const AddBikeForm()
        ],
      );
}

class AddBikeForm extends StatefulWidget {
  const AddBikeForm({Key? key}) : super(key: key);

  @override
  _AddBikeFormState createState() => _AddBikeFormState();
}

class _AddBikeFormState extends State<AddBikeForm> {
  final _keyForm = GlobalKey<FormState>();

  final _nameFocus = FocusNode();
  final _name = TextEditingController();

  final _kmWeekFocus = FocusNode();
  final _kmWeek = TextEditingController();

  final _priceFocus = FocusNode();
  final _price = TextEditingController();

  final List<String> _types = ['VTT', 'Ville', 'Route'];

  bool _electric = false;
  bool _automatic = true;
  String? _type = 'VTT';

  @override
  Widget build(BuildContext context) => Form(
        key: _keyForm,
        child: ListView(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            AppTextField(
              keyboardType: TextInputType.text,
              focusNode: _nameFocus,
              textfieldController: _name,
              validator: fieldValidator,
              hintText: 'Nom du vélo',
              label: 'Nom du vélo',
              icon: Icons.pedal_bike,
            ),
            AppTextField(
              keyboardType: TextInputType.number,
              focusNode: _kmWeekFocus,
              textfieldController: _kmWeek,
              validator: positiveValidator,
              hintText: 'Kilomètres par semaine',
              label: 'Kilomètres par semaine',
              icon: Icons.add_road,
            ),
            AppTextField(
              keyboardType: TextInputType.number,
              focusNode: _priceFocus,
              textfieldController: _price,
              validator: positiveValidator,
              hintText: 'Prix du vélo',
              label: 'Prix du vélo',
              icon: Icons.euro,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('Ajout quotidien des km ?', style: thirdTextStyle),
              Switch(
                  activeColor: primaryColor,
                  value: _automatic,
                  onChanged: (bool value) {
                    setState(() => _automatic = value);
                  }),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('Electrique', style: thirdTextStyle),
              Switch(
                  activeColor: primaryColor,
                  value: _electric,
                  onChanged: (bool value) {
                    setState(() => _electric = value);
                  }),
            ]),
            _buildBikesTypes(),
            AppButton(
                text: 'Ajouter',
                callback: _onAddBike,
                icon: const Icon(Icons.add))
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

  void _onAddBike() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _addBike();
    }
  }

  void _addBike() async {
    final String memberId = await Storage.getMemberId();
    final Bike bike = Bike(
        '',
        _name.text,
        double.parse(_kmWeek.text),
        _electric,
        _type!,
        DateTime.now(),
        0,
        _automatic,
        double.parse(_price.text));
    final HttpResponse response = await BikeService().create(memberId, bike);

    if (response.success()) {
      _onMemberHomePage();
      showSuccessSnackBar(context, response.message());
    } else {
      showErrorSnackBar(context, response.message());
    }
  }

  void _onMemberHomePage() => Navigator.pushAndRemoveUntil(
      context,
      animationRightLeft(const MemberHomePage()),
      (Route<dynamic> route) => false);
}
