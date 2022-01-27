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
          signedIn: const MemberHomePage(initialPage: 0),
          signedOut: LayoutBuilder(builder: (context, constraint) {
            if (constraint.maxWidth > maxSize) {
              return _narrowLayout();
            } else {
              return _wideLayout();
            }
          })));

  Padding _narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout());

  Column _wideLayout() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AppTitle(text: title, paddingTop: 0, style: mainTextStyle),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: thirdSize),
              child: Text(quote, style: italicTextStyle)),
          const AppNavButton(
              text: 'Se connecter',
              destination: SigninPage(),
              color: deepGreen),
          const AppNavButton(
              text: "S'inscrire", destination: SignupPage(), color: deepGreen)
        ],
      );
}
