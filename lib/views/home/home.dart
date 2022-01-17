import 'dart:async';

import 'package:bike_life/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/nav_button.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          signedOut: LayoutBuilder(builder: (context, constraint) {
            if (constraint.maxWidth > maxSize) {
              return narrowLayout();
            } else {
              return wideLayout();
            }
          })));

  Padding narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  Column wideLayout() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const AppTitle(text: title, paddingTop: 0),
          appQuote(),
          const AppNavButton(
              text: 'Se connecter',
              destination: SigninPage(),
              color: mainColor),
          const AppNavButton(
              text: "S'inscrire", destination: SignupPage(), color: mainColor)
        ],
      );

  Padding appQuote() => Padding(
      // TODO: Update keyboard type
      padding: const EdgeInsets.symmetric(vertical: thirdSize),
      child: Text(quote, style: italicTextStyle));
}
