import 'dart:async';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/home/discover.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/nav_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:lottie/lottie.dart';

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
    Storage.checkIfLogged(_authState);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: AuthGuard(
          authStream: _authState.stream,
          signedIn: const MemberHomePage(),
          signedOut: _layout(context)));

  Widget _layout(BuildContext context) => ListView(
        children: <Widget>[
          Center(
            child: Padding(
              child: Text(title, style: mainTextStyle),
              padding: const EdgeInsets.only(top: thirdSize),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: Lottie.asset('assets/bike.json'), 
                height: MediaQuery.of(context).size.height / 1.5,
              ),
              Text(
                "La santé de votre vélo se surveille de près.",
                style: italicTextStyle,
                textAlign: TextAlign.center,
              ),      
              const AppNavButton(
                  text: 'Découvrir',
                  destination: DiscoverPage(),
                  color: primaryColor),
              const AppNavButton(
                  text: 'Connexion',
                  destination: SigninPage(),
                  color: primaryColor)
            ],
          )
        ],
      );
}
