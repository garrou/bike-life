import 'dart:async';

import 'package:bike_life/repositories/member_repository.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/card.dart';
import 'package:bike_life/widgets/link_page.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final StreamController<bool> _authState = StreamController();

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: AuthGuard(
          authStream: _authState.stream,
          signedIn: const MemberHomePage(),
          signedOut: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > maxSize) {
              return narrowLayout();
            } else {
              return wideLayout();
            }
          })));

  Center wideLayout() => Center(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
        const AppTitle(text: "S'inscrire", paddingTop: 0),
        const AppCard(child: SignupForm(), elevation: secondSize),
        AppLinkToPage(
            padding: mainSize,
            child: Text('Déjà membre ? Se connecter', style: linkStyle),
            destination: const SigninPage())
      ])));

  Padding narrowLayout() => Padding(
      padding: EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

  final _confirmPasswordFocus = FocusNode();
  final _confirmPassword = TextEditingController();

  final MemberRepository _memberRepository = MemberRepository();

  @override
  Widget build(BuildContext context) => Form(
      key: _keyForm,
      child: Column(children: <Widget>[
        AppTextField(
            keyboardType: TextInputType.emailAddress,
            label: 'Email',
            hintText: 'Entrer un email valide',
            focusNode: _emailFocus,
            textfieldController: _email,
            validator: emailValidator,
            icon: Icons.alternate_email),
        AppTextField(
            keyboardType: TextInputType.text,
            label: 'Mot de passe',
            hintText: 'Mot de passe, $minPasswordSize caractères minimum',
            focusNode: _passwordFocus,
            textfieldController: _password,
            validator: passwordValidator,
            obscureText: true,
            icon: Icons.lock),
        AppTextField(
            keyboardType: TextInputType.text,
            label: 'Confirmer le mot de passe',
            hintText: 'Mot de passe, $minPasswordSize caractères minimum',
            focusNode: _confirmPasswordFocus,
            textfieldController: _confirmPassword,
            validator: (value) {
              if (_password.text != value) {
                return 'Mot de passe incorrect';
              }
            },
            obscureText: true,
            icon: Icons.lock),
        AppButton(text: "S'inscrire", callback: _onSignup, color: mainColor)
      ]));

  void _onSignup() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _createUser(_email.text, _password.text);
    }
  }

  void _createUser(String email, String password) async {
    List<dynamic> response = await _memberRepository.signup(email, password);
    Color responseColor = mainColor;

    if (response[0]) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', (Route<dynamic> route) => false);
    } else {
      responseColor = errorColor;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response[1]['confirm']), backgroundColor: responseColor));
  }
}
