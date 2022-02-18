import 'dart:async';

import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final StreamController<bool> _authState = StreamController();

  @override
  void initState() {
    super.initState();
    Storage.checkIfLogged(_authState);
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
            body: """
Ajouter vos vélos dans l'application.
Notez les dates de changements de composants.
Suivez l'utilisation de vos composants.
Soignez informé quand un composant doit-être changé.
                 """,
            image: Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_138qcknv.json')),
        PageViewModel(
            title: 'Une démarche écologique',
            body: 'Entretenir son vélo, un premier pas pour la planète',
            image: Lottie.network(
                'https://assets3.lottiefiles.com/private_files/lf30_flhopjdx.json')),
        PageViewModel(
            title: 'Une démarche économique',
            body: 'Entretenir son vélo, pour le garder plus longtemps',
            image: Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_h9pkkcih.json'))
      ],
      showSkipButton: true,
      skip: const Text('Passer', style: TextStyle(color: primaryColor)),
      next: const Icon(Icons.arrow_forward, color: primaryColor),
      done: const Text('Compris', style: TextStyle(color: primaryColor)),
      curve: Curves.easeIn,
      dotsDecorator: const DotsDecorator(
        size: Size(secondSize, secondSize),
        color: primaryColor,
        activeColor: primaryColor,
        activeSize: Size(firstSize, secondSize),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(firstSize)),
        ),
      ),
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context));
}
