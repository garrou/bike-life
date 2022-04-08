import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:flutter/material.dart';

class ComponentSettingsPage extends StatelessWidget {
  final Component component;
  const ComponentSettingsPage({Key? key, required this.component})
      : super(key: key);

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
        children: <Widget>[UpdateComponentForm(component: component)],
      );
}

class UpdateComponentForm extends StatefulWidget {
  final Component component;
  const UpdateComponentForm({Key? key, required this.component})
      : super(key: key);

  @override
  State<UpdateComponentForm> createState() => _UpdateComponentFormState();
}

class _UpdateComponentFormState extends State<UpdateComponentForm> {
  final _keyForm = GlobalKey<FormState>();

  final _brandFocus = FocusNode();
  final _brand = TextEditingController();

  final _priceFocus = FocusNode();
  final _price = TextEditingController();

  @override
  void initState() {
    super.initState();
    _brand.text = widget.component.brand;
    _price.text = widget.component.price.toString();
  }

  @override
  Widget build(BuildContext context) => Form(
      key: _keyForm,
      child: Column(
        
        children: <Widget>[
        AppTextField(
          focusNode: _brandFocus,
          textfieldController: _brand,
          validator: fieldValidator,
          hintText: 'Marque du composant',
          label: 'Marque du composant',
          icon: Icons.branding_watermark,
          keyboardType: TextInputType.text,
        ),
        AppTextField(
          focusNode: _priceFocus,
          textfieldController: _price,
          validator: positiveValidator,
          hintText: 'Prix du composant',
          label: 'Prix du composant',
          icon: Icons.euro,
          keyboardType: TextInputType.number,
        ),
        AppButton(
            text: 'Enregistrer',
            callback: _onUpdateComponent,
            icon: const Icon(Icons.save))
      ]));

  void _onUpdateComponent() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateComponent();
    }
  }

  void _updateComponent() async {
    final HttpResponse response = await ComponentService().updateComponent(
        Component(
            widget.component.id,
            widget.component.duration,
            widget.component.type,
            widget.component.active,
            widget.component.changedAt,
            widget.component.totalKm,
            _brand.text,
            double.parse(_price.text)));

    if (response.success()) {
      Navigator.push(
          context, animationRightLeft(const MemberHomePage(initialPage: 0)));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message(),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: response.color(),
      ),
    );
  }
}
