import 'package:bike_life/auth.dart';
import 'package:bike_life/constants.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: <Widget>[
      const AppTitle(text: 'Profil'),
      AppButton(text: 'Se déconnecter', callback: _onDisconnect),
      const BuildForm()
    ])));
  }

  void _onDisconnect() {
    // TODO: Disconnect
  }
}

class BuildForm extends StatefulWidget {
  const BuildForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<BuildForm> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainSize)),
        elevation: thirdSize,
        child: Column(children: <Widget>[
          Text('Modifier mon profil', style: secondTextStyle),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: paddingTop),
              child: Form(
                  key: _keyForm,
                  child: Column(children: <Widget>[
                    AppTextfield(
                        label: 'Email',
                        hintText: 'Entrer un email valide',
                        focusNode: _emailFocus,
                        textfieldController: _email,
                        validator: emailValidator,
                        obscureText: false),
                    AppTextfield(
                        label: 'Mot de passe',
                        hintText:
                            'Entrer un mot de passe de minimum $minPasswordSize caractères',
                        focusNode: _passwordFocus,
                        textfieldController: _password,
                        validator: passwordValidator,
                        obscureText: true),
                    AppButton(text: 'Modifier', callback: _onUpdate)
                  ])))
        ]));
  }

  void _onUpdate() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      // TODO: Update profil
    }
  }
}
