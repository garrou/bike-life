import 'dart:convert';

import 'package:bike_life/auth/signin.dart';
import 'package:bike_life/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

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

  Padding wideLayout() {
    return Padding(
        padding: const EdgeInsets.only(top: paddingTop),
        child: Center(
            child: Column(children: const <Widget>[
          BuildTitle(),
          BuildForm(),
          LinkSignin()
        ])));
  }

  Padding narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }
}

class BuildTitle extends StatelessWidget {
  const BuildTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: thirdSize),
        child: Text("S'inscrire", style: mainTextStyle));
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
              if (value == null ||
                  value.isEmpty ||
                  value.length < minPasswordSize) {
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
            onPressed: () => _onSignin(),
            child: Text("S'inscrire", style: secondTextStyle),
            style: roundedButtonStyle(mainColor)));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _keyForm,
        child: Column(children: <Widget>[
          buildEmailField(),
          buildPasswordField(),
          buildSigninButton()
        ]));
  }

  void _onSignin() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _createUser(_email.text, _password.text);
    }
  }

  void _createUser(String email, String password) async {
    final response = await _auth(email, password);
    late Color statusColor;
    late String statusMsg;

    if (response.statusCode == 201) {
      statusColor = Theme.of(context).primaryColor;
      statusMsg = 'Compte créé avec succés !';
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SigninPage()));
    } else if (response.statusCode == 409) {
      statusColor = Theme.of(context).errorColor;
      statusMsg = 'Un compte est déjà associé à cet email.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(statusMsg), backgroundColor: statusColor));
  }

  Future<http.Response> _auth(String email, String password) {
    return http.post(
      Uri.parse("$androidEndpoint/members"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, String>{"email": email, "password": password}),
    );
  }
}

class LinkSignin extends StatelessWidget {
  const LinkSignin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(mainSize),
        child: InkWell(
            child: const Text("Déjà un compte ? Se connecter",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: secondSize)),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SigninPage()))));
  }
}

class AuthMessage extends StatelessWidget {
  const AuthMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Colors.red,
      content: const Text("Erreur durant la création du compte"),
      action: SnackBarAction(label: 'Ok', onPressed: () {}),
    );
  }
}
