import 'package:bike_life/constants.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(children: const <Widget>[BuildTitle(), BuildForm()])));
  }
}

class BuildTitle extends StatelessWidget {
  const BuildTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: thirdSize),
      child: Text("Profil", style: mainTextStyle),
    );
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

  Padding _buildEmailField() {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: TextFormField(
            focusNode: _emailFocus,
            controller: _email,
            style: const TextStyle(color: mainColor),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: secondColor)),
                prefixIcon: Icon(Icons.email,
                    color: _emailFocus.hasFocus ? secondColor : mainColor),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: secondColor)),
                labelText: 'Email',
                labelStyle: TextStyle(
                    color: _emailFocus.hasFocus ? secondColor : mainColor),
                hintText: 'Entrer un email valide'),
            cursorColor: mainColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email invalide';
              }
            },
            onSaved: (value) => {}));
  }

  Padding _buildPasswordField() {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: TextFormField(
            focusNode: _passwordFocus,
            controller: _password,
            style: const TextStyle(color: mainColor),
            obscureText: true,
            decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: secondColor)),
                prefixIcon: Icon(Icons.lock,
                    color: _passwordFocus.hasFocus ? secondColor : mainColor),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: secondColor)),
                labelText: 'Mot de passe',
                labelStyle: TextStyle(
                    color: _passwordFocus.hasFocus ? secondColor : mainColor),
                hintText: 'Entrer un mot de passe valide'),
            cursorColor: mainColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mot de passe invalide';
              }
            },
            onSaved: (value) => {}));
  }

  ElevatedButton _buildSigninButton() {
    return ElevatedButton(
        onPressed: () => _onUpdate(),
        child: Text("Modifier mon profil", style: secondTextStyle),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(mainColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(thirdSize),
                    side: const BorderSide(color: secondColor)))));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _keyForm,
        child: Column(children: <Widget>[
          _buildEmailField(),
          _buildPasswordField(),
          _buildSigninButton()
        ]));
  }

  void _onUpdate() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      // TODO: Update profil
    }
  }
}
