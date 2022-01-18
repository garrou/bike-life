import 'dart:async';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/widgets/nav_button.dart';
import 'package:bike_life/widgets/title.dart';
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
    GuardHelper.checkIfLogged(_authState);
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
      padding: EdgeInsets.symmetric(horizontal: maxPadding),
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
      padding: const EdgeInsets.symmetric(vertical: thirdSize),
      child: Text(quote, style: italicTextStyle));
}
