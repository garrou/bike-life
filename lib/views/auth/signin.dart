import 'dart:async';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/repositories/member_repository.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/widgets/card.dart';
import 'package:bike_life/widgets/link_page.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
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
        const AppTitle(text: 'Se connecter', paddingTop: 0),
        const AppCard(child: SigninForm(), elevation: secondSize),
        AppLinkToPage(
            padding: mainSize,
            child: Text('Nouveau ? Créer un compte', style: linkStyle),
            destination: const SignupPage())
      ])));

  Padding narrowLayout() => Padding(
      padding: EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());
}

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

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
            hintText: 'Entrer votre mot de passe',
            focusNode: _passwordFocus,
            textfieldController: _password,
            validator: passwordValidator,
            obscureText: true,
            icon: Icons.lock),
        AppButton(text: 'Connexion', callback: _onSignin, color: mainColor)
      ]));

  void _onSignin() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _authUser(_email.text, _password.text);
    }
  }

  void _authUser(String email, String password) async {
    List<dynamic> response = await _memberRepository.login(email, password);

    if (response[0]) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (Route<dynamic> route) => false);
    } else {
      _password.text = '';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response[1]['confirm']),
          backgroundColor: Theme.of(context).errorColor));
    }
  }
}
