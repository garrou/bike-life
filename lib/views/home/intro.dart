import 'dart:async';

import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final StreamController<bool> _authState = StreamController();

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
  }

  void _onIntroEnd(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
      (Route<dynamic> route) => false);

  @override
  Widget build(BuildContext context) => Scaffold(
      body: AuthGuard(
          authStream: _authState.stream,
          signedIn: const MemberHomePage(initialPage: 0),
          signedOut: _buildIntroductionScreen()));

  IntroductionScreen _buildIntroductionScreen() => IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
            title: 'Gestion de vos vélos',
            body: "Ajouter vos vélos dans l'application.",
            image: const Icon(Icons.bike_scooter)),
        PageViewModel(
            title: 'Gestion des composants des vélos',
            body:
                "Ajouter les composants de votre vélo.\nGardez un oeil sur l'utilisation de ceux-ci.",
            image: const Icon(Icons.health_and_safety)),
        PageViewModel(
            title: 'Une démarche écologique',
            body: 'Entretenir son vélo, un premier pas pour la planète',
            image: const Icon(Icons.eco)),
        PageViewModel(
            title: 'Une démarche économique',
            body: 'Entretenir son vélo, pour le garder plus longtemps',
            image: const Icon(Icons.euro))
      ],
      showSkipButton: true,
      skip: const Text('Passer', style: TextStyle(color: deepGreen)),
      next: const Icon(Icons.arrow_forward, color: deepGreen),
      done: const Text('Compris', style: TextStyle(color: deepGreen)),
      curve: Curves.easeIn,
      dotsDecorator: const DotsDecorator(
        size: Size(secondSize, secondSize),
        color: deepGreen,
        activeColor: deepGreen,
        activeSize: Size(mainSize, secondSize),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(mainSize)),
        ),
      ),
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context));
}
