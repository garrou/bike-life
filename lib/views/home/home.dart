import 'dart:async';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/home/discover.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/widgets/nav_button.dart';
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
          signedOut: _layout()));

  ListView _layout() => ListView(children: <Widget>[
        Row(children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(mainSize, mainSize, 0, 0),
              child: Text(title, style: secondTextStyle)),
        ]),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(thirdSize),
              child: Image.asset('assets/bike.png', fit: BoxFit.contain)),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: thirdSize),
              child: Text("La santé de votre vélo\nse surveille de près.",
                  style: italicTextStyle)),
          const AppNavButton(
              text: 'Découvrir',
              destination: DiscoverPage(),
              color: primaryColor),
          const AppNavButton(
              text: 'Connexion', destination: SigninPage(), color: primaryColor)
        ])
      ]);
}
