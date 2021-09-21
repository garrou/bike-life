import 'package:bike_life/constants.dart';
import 'package:bike_life/home/home.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: const <Widget>[
      BuildTitle(),
      DisconnectButton(),
      BuildForm()
    ])));
  }
}

class BuildTitle extends StatelessWidget {
  const BuildTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: paddingTop),
      child: Text("Profil", style: mainTextStyle),
    );
  }
}

class DisconnectButton extends StatelessWidget {
  const DisconnectButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: paddingTop),
        child: SizedBox(
          height: buttonHeight,
          width: buttonWidth,
          child: ElevatedButton(
              onPressed: () {
                // TODO: Disconnect
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: Text("Se déconnecter", style: secondTextStyle),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(mainSize),
                          side: const BorderSide(color: secondColor))))),
        ));
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

  Padding buildEmailField() {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: TextFormField(
            focusNode: _emailFocus,
            controller: _email,
            style: const TextStyle(color: mainColor),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(mainSize),
                    borderSide: const BorderSide(color: secondColor)),
                prefixIcon: Icon(Icons.email,
                    color: _emailFocus.hasFocus ? secondColor : mainColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(mainSize),
                    borderSide: const BorderSide(color: secondColor)),
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

  Padding buildPasswordField() {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: TextFormField(
            focusNode: _passwordFocus,
            controller: _password,
            style: const TextStyle(color: mainColor),
            obscureText: true,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(mainSize),
                    borderSide: const BorderSide(color: secondColor)),
                prefixIcon: Icon(Icons.lock,
                    color: _passwordFocus.hasFocus ? secondColor : mainColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(mainSize),
                    borderSide: const BorderSide(color: secondColor)),
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

  SizedBox buildSigninButton() {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
          onPressed: () => _onUpdate(),
          child: Text("Modifier", style: secondTextStyle),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(mainColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(mainSize),
                      side: const BorderSide(color: secondColor))))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainSize)),
        elevation: thirdSize,
        child: Column(children: <Widget>[
          Text("Modifier mon profil", style: secondTextStyle),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: paddingTop),
              child: Form(
                  key: _keyForm,
                  child: Column(children: <Widget>[
                    buildEmailField(),
                    buildPasswordField(),
                    buildSigninButton()
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
