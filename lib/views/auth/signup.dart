import 'dart:async';

import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/forms/signup_form.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:bike_life/views/widgets/link_page.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/constants.dart';
import 'package:bike_life/views/widgets/title.dart';
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
    _checkIfLogged();
  }

  void _checkIfLogged() async {
    int memberId = await Storage.getMemberId();
    memberId != -1 ? _authState.add(true) : _authState.add(false);
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
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());
}
