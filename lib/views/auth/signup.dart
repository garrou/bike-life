import 'dart:convert';

import 'package:bike_life/utils/auth.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:bike_life/views/widgets/link_page.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/constants.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

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

  Center wideLayout() {
    return Center(
        child: SingleChildScrollView(
            child: Column(children: const <Widget>[
      AppTitle(text: "S'inscrire", paddingTop: secondSize),
      AppCard(child: BuildForm()),
      AppLinkToPage(
          text: 'Déjà membre ? Se connecter', destination: SigninPage())
    ])));
  }

  Padding narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
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
    return Form(
        key: _keyForm,
        child: Column(children: <Widget>[
          AppTextField(
              label: 'Email',
              hintText: 'Entrer un email valide',
              focusNode: _emailFocus,
              textfieldController: _email,
              validator: emailValidator,
              obscureText: false,
              icon: Icons.alternate_email,
              maxLines: 1),
          AppTextField(
              label: 'Mot de passe',
              hintText:
                  'Entrer un mot de passe avec $minPasswordSize caractères minimum',
              focusNode: _passwordFocus,
              textfieldController: _password,
              validator: passwordValidator,
              obscureText: true,
              icon: Icons.lock,
              maxLines: 1),
          AppButton(text: "S'inscrire", callback: _onSignin)
        ]));
  }

  void _onSignin() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _createUser(_email.text, _password.text);
    }
  }

  void _createUser(String email, String password) async {
    final response = await signup(email, password);
    final jsonResponse = jsonDecode(response.body);
    Color statusColor = Theme.of(context).errorColor;

    if (response.statusCode == 201) {
      statusColor = Theme.of(context).primaryColor;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SigninPage()));
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonResponse['confirm']), backgroundColor: statusColor));
  }
}
