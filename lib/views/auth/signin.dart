import 'dart:convert';

import 'package:bike_life/auth.dart';
import 'package:bike_life/constants.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/link_page.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              AppTitle(text: 'Se connecter'),
              BuildForm(),
              AppLinkToPage(
                  text: 'Nouveau ? Créer un compte', destination: SignupPage())
            ]));
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
  _BuildFormState createState() => _BuildFormState();
}

class _BuildFormState extends State<BuildForm> {
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
          AppTextfield(
              label: 'Email',
              hintText: 'Entrer un email valide',
              focusNode: _emailFocus,
              textfieldController: _email,
              validator: emailValidator,
              obscureText: false),
          AppTextfield(
              label: 'Mot de passe',
              hintText: 'Entrer votre mot de passe',
              focusNode: _passwordFocus,
              textfieldController: _password,
              validator: passwordValidator,
              obscureText: true),
          AppButton(text: 'Connexion', callback: _onSignin)
        ]));
  }

  void _onSignin() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _authUser(_email.text, _password.text);
    }
  }

  void _authUser(String email, String password) async {
    const storage = FlutterSecureStorage();
    http.Response response = await login(email, password);
    dynamic jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await storage.write(key: 'jwt', value: jsonResponse['accessToken']);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MemberHome()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Email ou mot de passe incorrect !'),
          backgroundColor: Theme.of(context).errorColor));
    }
  }
}
