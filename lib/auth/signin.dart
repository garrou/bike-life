import 'dart:convert';

import 'package:bike_life/auth/signup.dart';
import 'package:bike_life/constants.dart';
import 'package:bike_life/user/user_home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key}) : super(key: key);

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
          LinkSignup()
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
        padding: const EdgeInsets.all(thirdSize),
        child: Text('Se connecter', style: mainTextStyle));
  }
}

class BuildForm extends StatefulWidget {
  const BuildForm({Key? key}) : super(key: key);

  @override
  _BuildFormState createState() => _BuildFormState();
}

class _BuildFormState extends State<BuildForm> {
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
              // TODO: Extract
              if (value == null || value.isEmpty || !value.contains("@")) {
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
              // TODO: Extract
              if (value == null || value.isEmpty || value.length < 8) {
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
          child: Text('Connexion', style: secondTextStyle),
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
      _authUser(_email.text, _password.text);
    }
  }

  void _authUser(String email, String password) async {
    // TODO: Auth
    final response = await http.post(
      Uri.parse("$androidEndpoint/members"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, String>{"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const UserHome()));
    } else {
      throw Exception("Failed to login");
    }
  }
}

class LinkSignup extends StatelessWidget {
  const LinkSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(mainSize),
        child: InkWell(
            child: const Text("Nouveau ? Créer un compte",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: secondSize)),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignupPage()))));
  }
}
